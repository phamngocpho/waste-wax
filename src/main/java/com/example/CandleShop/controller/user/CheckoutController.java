package com.example.CandleShop.controller.user;

import com.example.CandleShop.dto.CheckoutDTO;
import com.example.CandleShop.dto.OrderDTO;
import com.example.CandleShop.entity.*;
import com.example.CandleShop.enums.OrderStatus;
import com.example.CandleShop.enums.PaymentStatus;
import com.example.CandleShop.service.*;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpSession;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
public class CheckoutController {
    @Autowired
    private CartService cartService;
    @Autowired
    private VoucherService voucherService;
    @Autowired
    private UserService userService;
    @Autowired
    private UserVoucherService userVoucherService;
    @Autowired
    private OrderService orderService;
    @Autowired
    private PaymentMethodService paymentMethodService;
    @Autowired
    private PaymentService paymentService;
    private static final Log log = LogFactory.getLog(CheckoutController.class);

    @PostMapping("/checkout")
    public String processCheckout(@RequestParam("selectedItems") String selectedItemsJson,
                                  HttpSession session) {
        try {
            ObjectMapper mapper = new ObjectMapper();
            List<Map<String, Object>> selectedItems = mapper.readValue(selectedItemsJson,
                    new TypeReference<List<Map<String, Object>>>() {});

            List<Long> selectedItemIds = selectedItems.stream()
                    .map(item -> Long.parseLong(item.get("id").toString()))
                    .collect(Collectors.toList());

            // Lấy cart items
            List<CartItem> cartItems = cartService.getCartItemsByIds(selectedItemIds);

            // Chuyển đổi sang DTO
            List<CheckoutDTO> checkoutItems = cartItems.stream()
                    .map(CheckoutDTO::new)
                    .collect(Collectors.toList());

            // Tính tổng tiền
            double totalAmount = cartItems.stream()
                    .mapToDouble(item -> item.getProductSize().getPrice().doubleValue() * item.getQuantity())
                    .sum();

            double shippingFee = 30000;

            // Lưu DTO vào session thay vì entity
            session.setAttribute("checkoutItems", checkoutItems);
            session.setAttribute("totalAmount", totalAmount);
            session.setAttribute("shippingFee", shippingFee);

            // Lưu IDs để có thể truy vấn lại khi cần
            session.setAttribute("checkoutItemIds", selectedItemIds);

            return "redirect:/checkout/form";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/cart?error=checkout_failed";
        }
    }

    @GetMapping("/checkout/form")
    public String showCheckoutForm(Model model, HttpSession session) {
        @SuppressWarnings("unchecked")
        List<CheckoutDTO> checkoutItems = (List<CheckoutDTO>) session.getAttribute("checkoutItems");
        Double totalAmount = (Double) session.getAttribute("totalAmount");
        Double shippingFee = (Double) session.getAttribute("shippingFee");

        if (checkoutItems == null || checkoutItems.isEmpty()) {
            return "redirect:/cart";
        }
        model.addAttribute("checkoutItems", checkoutItems);
        model.addAttribute("totalAmount", totalAmount);
        model.addAttribute("shippingFee", shippingFee);

        // Lấy thông tin người dùng từ session
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }

        User user = userService.findById(userId);
        model.addAttribute("fullName", user.getFullName());
        model.addAttribute("phone", user.getPhone());
        model.addAttribute("email", user.getEmail());
        model.addAttribute("address", user.getAddress());
        List<UserVoucher> availableVouchers = userVoucherService.getUsableVouchers(user.getId());
        model.addAttribute("availableVouchers", availableVouchers);

        return "user/checkout";
    }

    // Xử lý áp dụng voucher
    @PostMapping("/checkout/apply-voucher")
    @ResponseBody
    public Map<String, Object> applyVoucher(@RequestParam("userVoucherId") Long userVoucherId,
                                            HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            // Lấy thông tin người dùng từ session
            Long userId = (Long) session.getAttribute("userId");
            if (userId == null) {
                response.put("success", false);
                response.put("message", "Vui lòng đăng nhập để sử dụng voucher");
                return response;
            }

            User user = userService.findById(userId);
            BigDecimal totalAmount = BigDecimal.valueOf((Double) session.getAttribute("totalAmount"));

            Map<String, Object> result = voucherService.applyVoucherToOrder(userVoucherId, user.getId(), totalAmount);

            if ((Boolean) result.get("success")) {
                // Lưu thông tin voucher vào session
                UserVoucher userVoucher = (UserVoucher) result.get("userVoucher");
                BigDecimal discountAmount = (BigDecimal) result.get("discountAmount");

                session.setAttribute("appliedVoucher", userVoucher);
                session.setAttribute("discountAmount", discountAmount);

                // Tính lại tổng tiền
                BigDecimal shippingFee = BigDecimal.valueOf((Double) session.getAttribute("shippingFee"));
                BigDecimal finalAmount = totalAmount.add(shippingFee).subtract(discountAmount);
                session.setAttribute("finalAmount", finalAmount);

                // Trả về kết quả thành công
                response.put("success", true);
                response.put("message", "Áp dụng mã giảm giá thành công!");
                response.put("discount", discountAmount);
                response.put("subtotal", totalAmount);
                response.put("finalTotal", finalAmount);
                response.put("voucherCode", userVoucher.getVoucher().getCode());
            } else {
                response.put("success", false);
                response.put("message", result.get("message"));
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Có lỗi xảy ra: " + e.getMessage());
        }

        return response;
    }

    // Xử lý hủy voucher
    @PostMapping("/checkout/remove-voucher")
    @ResponseBody
    public Map<String, Object> removeVoucher(HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            // Xóa thông tin voucher khỏi session
            session.removeAttribute("appliedVoucher");
            session.removeAttribute("discountAmount");

            // Tính lại tổng tiền
            BigDecimal totalAmount = BigDecimal.valueOf((Double) session.getAttribute("totalAmount"));
            BigDecimal shippingFee = BigDecimal.valueOf((Double) session.getAttribute("shippingFee"));
            BigDecimal finalAmount = totalAmount.add(shippingFee);
            session.setAttribute("finalAmount", finalAmount);

            response.put("success", true);
            response.put("message", "Đã hủy mã giảm giá");
            response.put("subtotal", totalAmount);
            response.put("finalTotal", finalAmount);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Có lỗi xảy ra: " + e.getMessage());
        }

        return response;
    }

    // Xử lý hoàn tất đơn hàng
    @PostMapping("/place-order")
    public String placeOrder(@ModelAttribute OrderDTO orderDTO,
                             @RequestParam(value = "userVoucherId", required = false) Long userVoucherId,
                             @RequestParam(value = "discountAmount", required = false, defaultValue = "0") BigDecimal discountAmount,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        try {
            log.info("=== DEBUG EMAIL CHECKOUT ===");
            log.info("OrderDTO customerEmail: '" + orderDTO.getCustomerEmail() + "'");
            log.info("OrderDTO shippingName: '" + orderDTO.getShippingName() + "'");
            log.info("OrderDTO shippingAddress: '" + orderDTO.getShippingAddress() + "'");
            log.info("OrderDTO shippingPhone: '" + orderDTO.getShippingPhone() + "'");
            log.info("OrderDTO paymentMethodId: " + orderDTO.getPaymentMethodId());
            // Lấy thông tin người dùng từ session
            Long userId = (Long) session.getAttribute("userId");
            if (userId == null) {
                return "redirect:/login";
            }

            // Lấy danh sách sản phẩm từ session
            @SuppressWarnings("unchecked")
            List<CheckoutDTO> checkoutItems = (List<CheckoutDTO>) session.getAttribute("checkoutItems");
            if (checkoutItems == null || checkoutItems.isEmpty()) {
                return "redirect:/cart";
            }

            // Lấy thông tin tổng tiền
            BigDecimal totalAmount = BigDecimal.valueOf((Double) session.getAttribute("totalAmount"));
            BigDecimal shippingFee = BigDecimal.valueOf((Double) session.getAttribute("shippingFee"));
            BigDecimal finalAmount = totalAmount.add(shippingFee).subtract(discountAmount);

            // Tạo đơn hàng
            User user = userService.findById(userId);
            Order order = new Order();
            order.setUser(user);
            order.setTotalAmount(totalAmount);
            order.setShippingFee(shippingFee);
            order.setFinalAmount(finalAmount);
            order.setShippingAddress(orderDTO.getShippingAddress());
            order.setShippingPhone(orderDTO.getShippingPhone());
            order.setCustomerEmail(orderDTO.getCustomerEmail());
            order.setShippingName(orderDTO.getShippingName());
            order.setOrderStatus(OrderStatus.PENDING);
            order.setPaymentStatus(PaymentStatus.PAID);

            // Nếu có voucher
            if (userVoucherId != null && userVoucherId > 0) {
                UserVoucher userVoucher = userVoucherService. findById(userVoucherId);
                if (userVoucher != null) {
                    order.setUserVoucher(userVoucher);
                    order.setDiscountAmount(discountAmount);
                    // Đánh dấu voucher đã sử dụng
                    userVoucher.setIsUsed(true);
                    userVoucherService.saveUserVoucher(userVoucher);
                }
            }

            // Lưu order và tạo order items
            Order savedOrder = orderService.createOrder(order, checkoutItems);
            //Cộng điểm cho người dùng
            int pointEarned = finalAmount.intValue() / 10000;
            userService.addUserPoints(userId, pointEarned);

            // Xóa các sản phẩm đã đặt hàng khỏi giỏ hàng
            @SuppressWarnings("unchecked")
            List<Long> checkoutItemIds = (List<Long>) session.getAttribute("checkoutItemIds");
            if (checkoutItemIds != null && !checkoutItemIds.isEmpty()) {
                cartService.removeCartItems(checkoutItemIds);
            }

            // Xóa thông tin checkout khỏi session
            session.removeAttribute("checkoutItems");
            session.removeAttribute("checkoutItemIds");
            session.removeAttribute("totalAmount");
            session.removeAttribute("shippingFee");
            session.removeAttribute("appliedVoucher");
            session.removeAttribute("discountAmount");
            session.removeAttribute("finalAmount");

            // Tạo thanh toán
            // Tạo thanh toán
            Payment payment = new Payment();
            payment.setOrder(savedOrder);
            payment.setAmount(finalAmount);
            payment.setStatus(String .valueOf(PaymentStatus.PENDING)); // Sử dụng enum thay vì String

// Kiểm tra paymentMethodId trước
            if (orderDTO.getPaymentMethodId() == null) {
                redirectAttributes.addFlashAttribute("error", "Vui lòng chọn phương thức thanh toán");
                return "redirect:/checkout/form";
            }

            PaymentMethod paymentMethod = paymentMethodService.findById(orderDTO.getPaymentMethodId());
            if (paymentMethod == null) {
                // Nếu không tìm thấy phương thức thanh toán, thông báo lỗi và quay lại form
                redirectAttributes.addFlashAttribute("error", "Phương thức thanh toán không hợp lệ");
                return "redirect:/checkout/form";
            }

// Chỉ khi đã có paymentMethod hợp lệ mới gán và lưu
            payment.setPaymentMethod(paymentMethod);
            paymentService.save(payment);


            // Chuyển hướng đến trang xác nhận đơn hàng
            redirectAttributes.addFlashAttribute("orderId", savedOrder.getId());
            return "redirect:/order/confirmation";
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra khi đặt hàng: " + e.getMessage());
            return "redirect:/checkout/form";
        }
    }
    @GetMapping("/order/confirmation")
    public String showOrderConfirmation(Model model, @ModelAttribute("orderId") Long orderId) {
        if (orderId != null) {
            Order order = orderService.getOrderById(orderId);
            if (order != null) {
                model.addAttribute("order", order);
                return "user/order-confirmation";
            }
        }
        return "redirect:/";
    }
}
