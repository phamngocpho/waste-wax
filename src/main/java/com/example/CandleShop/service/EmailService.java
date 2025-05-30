package com.example.CandleShop.service;

import com.example.CandleShop.entity.Order;
import com.example.CandleShop.entity.OrderItem;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.text.NumberFormat;
import java.util.Locale;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Service
public class EmailService {

    private static final Logger logger = LoggerFactory.getLogger(EmailService.class);

    @Autowired
    private JavaMailSender emailSender;

    // Gửi email khi admin xác nhận đơn hàng
    public void sendOrderConfirmedEmail(Order order) {
        try {
            logger.info("Bắt đầu gửi email xác nhận đơn hàng #{}", order.getOrderNumber());

            MimeMessage message = emailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            // Sử dụng email của khách hàng từ thông tin người dùng
            String customerEmail = order.getUser().getEmail();
            logger.info("Chuẩn bị gửi email xác nhận đơn hàng đến: {}", customerEmail);

            helper.setTo(customerEmail);
            helper.setSubject("Đơn hàng #" + order.getOrderNumber() + " đã được xác nhận - Candle Shop");

            String content = buildOrderConfirmedEmail(order);
            helper.setText(content, true);

            logger.debug("Nội dung email đã được tạo thành công");

            // Thêm log trước khi gửi email
            logger.info("Đang gửi email xác nhận đơn hàng #{} đến {}", order.getOrderNumber(), customerEmail);

            emailSender.send(message);

            // Thêm log sau khi gửi email thành công
            logger.info("Email xác nhận đơn hàng #{} đã được gửi thành công đến {}", order.getOrderNumber(), customerEmail);

        } catch (MessagingException e) {
            logger.error("Lỗi khi gửi email xác nhận đơn hàng #{}: {}", order.getOrderNumber(), e.getMessage());
            e.printStackTrace();
        }
    }

    // Gửi email thông báo đơn hàng đã hoàn thành
    public void sendOrderCompletedEmail(Order order) {
        try {
            logger.info("Bắt đầu gửi email hoàn thành đơn hàng #{}", order.getOrderNumber());

            MimeMessage message = emailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            // Sử dụng email của khách hàng từ thông tin người dùng
            String customerEmail = order.getUser().getEmail();
            logger.info("Chuẩn bị gửi email hoàn thành đơn hàng đến: {}", customerEmail);

            helper.setTo(customerEmail);
            helper.setSubject("Đơn hàng #" + order.getOrderNumber() + " đã hoàn thành - Candle Shop");

            String content = buildOrderCompletedEmail(order);
            helper.setText(content, true);

            logger.debug("Nội dung email đã được tạo thành công");

            // Thêm log trước khi gửi email
            logger.info("Đang gửi email hoàn thành đơn hàng #{} đến {}", order.getOrderNumber(), customerEmail);

            emailSender.send(message);

            // Thêm log sau khi gửi email thành công
            logger.info("Email hoàn thành đơn hàng #{} đã được gửi thành công đến {}", order.getOrderNumber(), customerEmail);

        } catch (MessagingException e) {
            logger.error("Lỗi khi gửi email hoàn thành đơn hàng #{}: {}", order.getOrderNumber(), e.getMessage());
            e.printStackTrace();
        }
    }

    // Tạo nội dung email xác nhận đơn hàng
    private String buildOrderConfirmedEmail(Order order) {
        StringBuilder emailContent = new StringBuilder();
        NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));

        emailContent.append("<html><body>");
        emailContent.append("<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;'>");
        emailContent.append("<div style='background-color: #4A3427; padding: 20px; text-align: center;'>");
        emailContent.append("<h1 style='color: white; margin: 0;'>Candle Shop</h1>");
        emailContent.append("</div>");

        emailContent.append("<div style='padding: 20px; border: 1px solid #e0e0e0; background-color: #f9f9f9;'>");
        emailContent.append("<h2>Đơn hàng #").append(order.getOrderNumber()).append(" đã được xác nhận</h2>");
        emailContent.append("<p>Xin chào ").append(order.getShippingName()).append(",</p>");
        emailContent.append("<p>Chúng tôi vui mừng thông báo rằng đơn hàng của bạn đã được xác nhận và đang được chuẩn bị.</p>");

        // Hiển thị trạng thái đơn hàng
        emailContent.append("<div style='background-color: #d1ecf1; border: 1px solid #bee5eb; color: #0c5460; padding: 12px; margin: 15px 0; border-radius: 4px;'>");
        emailContent.append("<strong>Trạng thái đơn hàng:</strong> Đã xác nhận");
        emailContent.append("</div>");

        emailContent.append("<h3>Thông tin đơn hàng:</h3>");
        emailContent.append("<table style='width: 100%; border-collapse: collapse;'>");
        emailContent.append("<tr style='background-color: #f2f2f2;'>");
        emailContent.append("<th style='padding: 10px; text-align: left; border: 1px solid #ddd;'>Sản phẩm</th>");
        emailContent.append("<th style='padding: 10px; text-align: center; border: 1px solid #ddd;'>Số lượng</th>");
        emailContent.append("<th style='padding: 10px; text-align: right; border: 1px solid #ddd;'>Đơn giá</th>");
        emailContent.append("<th style='padding: 10px; text-align: right; border: 1px solid #ddd;'>Thành tiền</th>");
        emailContent.append("</tr>");

        for (OrderItem item : order.getOrderItems()) {
            emailContent.append("<tr>");
            emailContent.append("<td style='padding: 10px; border: 1px solid #ddd;'>")
                    .append(item.getProduct().getName())
                    .append(" (").append(item.getProductSize().getSizeValue()).append("ml)")
                    .append("</td>");
            emailContent.append("<td style='padding: 10px; text-align: center; border: 1px solid #ddd;'>")
                    .append(item.getQuantity())
                    .append("</td>");
            emailContent.append("<td style='padding: 10px; text-align: right; border: 1px solid #ddd;'>")
                    .append(currencyFormatter.format(item.getUnitPrice()))
                    .append("</td>");
            emailContent.append("<td style='padding: 10px; text-align: right; border: 1px solid #ddd;'>")
                    .append(currencyFormatter.format(item.getSubtotal()))
                    .append("</td>");
            emailContent.append("</tr>");
        }
        emailContent.append("</table>");

        emailContent.append("<div style='margin-top: 20px;'>");
        emailContent.append("<p style='text-align: right;'><strong>Tổng tiền hàng:</strong> ")
                .append(currencyFormatter.format(order.getTotalAmount()))
                .append("</p>");

        if (order.getDiscountAmount() != null && order.getDiscountAmount().compareTo(BigDecimal.ZERO) > 0) {
            emailContent.append("<p style='text-align: right;'><strong>Giảm giá:</strong> ")
                    .append(currencyFormatter.format(order.getDiscountAmount()))
                    .append("</p>");
        }

        emailContent.append("<p style='text-align: right;'><strong>Phí vận chuyển:</strong> ")
                .append(currencyFormatter.format(order.getShippingFee()))
                .append("</p>");

        emailContent.append("<p style='text-align: right; font-size: 18px;'><strong>Tổng thanh toán:</strong> ")
                .append(currencyFormatter.format(order.getFinalAmount()))
                .append("</p>");
        emailContent.append("</div>");

        emailContent.append("<div style='margin-top: 30px;'>");
        emailContent.append("<h3>Thông tin giao hàng:</h3>");
        emailContent.append("<p><strong>Người nhận:</strong> ").append(order.getShippingName()).append("</p>");
        emailContent.append("<p><strong>Số điện thoại:</strong> ").append(order.getShippingPhone()).append("</p>");
        emailContent.append("<p><strong>Địa chỉ:</strong> ").append(order.getShippingAddress()).append("</p>");
        emailContent.append("</div>");

        emailContent.append("<div style='margin-top: 30px;'>");
        emailContent.append("<p>Đơn hàng của bạn sẽ được giao trong khoảng 3-5 ngày làm việc. Chúng tôi sẽ thông báo cho bạn khi đơn hàng được giao thành công.</p>");
        emailContent.append("<p>Nếu bạn có bất kỳ câu hỏi nào về đơn hàng, vui lòng liên hệ với chúng tôi qua email support@candleshop.com hoặc số điện thoại 0123456789.</p>");
        emailContent.append("<p>Trân trọng,<br>Đội ngũ Candle Shop</p>");
        emailContent.append("</div>");

        emailContent.append("</div>");
        emailContent.append("<div style='background-color: #f2f2f2; padding: 15px; text-align: center; font-size: 12px;'>");
        emailContent.append("<p>&copy; 2025 Candle Shop. All rights reserved.</p>");
        emailContent.append("</div>");
        emailContent.append("</div>");
        emailContent.append("</body></html>");

        return emailContent.toString();
    }

    // Tạo nội dung email thông báo đơn hàng đã hoàn thành
    private String buildOrderCompletedEmail(Order order) {
        StringBuilder emailContent = new StringBuilder();
        NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));

        emailContent.append("<html><body>");
        emailContent.append("<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;'>");
        emailContent.append("<div style='background-color: #4A3427; padding: 20px; text-align: center;'>");
        emailContent.append("<h1 style='color: white; margin: 0;'>Candle Shop</h1>");
        emailContent.append("</div>");

        emailContent.append("<div style='padding: 20px; border: 1px solid #e0e0e0; background-color: #f9f9f9;'>");
        emailContent.append("<h2>Đơn hàng #").append(order.getOrderNumber()).append(" đã hoàn thành</h2>");
        emailContent.append("<p>Xin chào ").append(order.getShippingName()).append(",</p>");
        emailContent.append("<p>Chúng tôi vui mừng thông báo rằng đơn hàng của bạn đã được giao thành công.</p>");

        // Hiển thị trạng thái đơn hàng
        emailContent.append("<div style='background-color: #d4edda; border: 1px solid #c3e6cb; color: #155724; padding: 12px; margin: 15px 0; border-radius: 4px;'>");
        emailContent.append("<strong>Trạng thái đơn hàng:</strong> Đã hoàn thành");
        emailContent.append("</div>");

        emailContent.append("<h3>Thông tin đơn hàng:</h3>");
        emailContent.append("<table style='width: 100%; border-collapse: collapse;'>");
        emailContent.append("<tr style='background-color: #f2f2f2;'>");
        emailContent.append("<th style='padding: 10px; text-align: left; border: 1px solid #ddd;'>Sản phẩm</th>");
        emailContent.append("<th style='padding: 10px; text-align: center; border: 1px solid #ddd;'>Số lượng</th>");
        emailContent.append("<th style='padding: 10px; text-align: right; border: 1px solid #ddd;'>Đơn giá</th>");
        emailContent.append("<th style='padding: 10px; text-align: right; border: 1px solid #ddd;'>Thành tiền</th>");
        emailContent.append("</tr>");

        for (OrderItem item : order.getOrderItems()) {
            emailContent.append("<tr>");
            emailContent.append("<td style='padding: 10px; border: 1px solid #ddd;'>")
                    .append(item.getProduct().getName())
                    .append(" (").append(item.getProductSize().getSizeValue()).append("ml)")
                    .append("</td>");
            emailContent.append("<td style='padding: 10px; text-align: center; border: 1px solid #ddd;'>")
                    .append(item.getQuantity())
                    .append("</td>");
            emailContent.append("<td style='padding: 10px; text-align: right; border: 1px solid #ddd;'>")
                    .append(currencyFormatter.format(item.getUnitPrice()))
                    .append("</td>");
            emailContent.append("<td style='padding: 10px; text-align: right; border: 1px solid #ddd;'>")
                    .append(currencyFormatter.format(item.getSubtotal()))
                    .append("</td>");
            emailContent.append("</tr>");
        }
        emailContent.append("</table>");

        emailContent.append("<div style='margin-top: 20px;'>");
        emailContent.append("<p style='text-align: right;'><strong>Tổng tiền hàng:</strong> ")
                .append(currencyFormatter.format(order.getTotalAmount()))
                .append("</p>");

        if (order.getDiscountAmount() != null && order.getDiscountAmount().compareTo(BigDecimal.ZERO) > 0) {
            emailContent.append("<p style='text-align: right;'><strong>Giảm giá:</strong> ")
                    .append(currencyFormatter.format(order.getDiscountAmount()))
                    .append("</p>");
        }

        emailContent.append("<p style='text-align: right;'><strong>Phí vận chuyển:</strong> ")
                .append(currencyFormatter.format(order.getShippingFee()))
                .append("</p>");

        emailContent.append("<p style='text-align: right; font-size: 18px;'><strong>Tổng thanh toán:</strong> ")
                .append(currencyFormatter.format(order.getFinalAmount()))
                .append("</p>");
        emailContent.append("</div>");

        emailContent.append("<div style='margin-top: 30px;'>");
        emailContent.append("<h3>Thông tin giao hàng:</h3>");
        emailContent.append("<p><strong>Người nhận:</strong> ").append(order.getShippingName()).append("</p>");
        emailContent.append("<p><strong>Số điện thoại:</strong> ").append(order.getShippingPhone()).append("</p>");
        emailContent.append("<p><strong>Địa chỉ:</strong> ").append(order.getShippingAddress()).append("</p>");
        emailContent.append("</div>");

        emailContent.append("<div style='margin-top: 30px;'>");
        emailContent.append("<p>Cảm ơn bạn đã mua sắm tại Candle Shop. Chúng tôi rất mong được phục vụ bạn trong tương lai!</p>");
        emailContent.append("<p>Nếu bạn hài lòng với sản phẩm, hãy để lại đánh giá để giúp chúng tôi cải thiện dịch vụ.</p>");
        emailContent.append("<p>Trân trọng,<br>Đội ngũ Candle Shop</p>");
        emailContent.append("</div>");

        emailContent.append("</div>");
        emailContent.append("<div style='background-color: #f2f2f2; padding: 15px; text-align: center; font-size: 12px;'>");
        emailContent.append("<p>&copy; 2025 Candle Shop. All rights reserved.</p>");
        emailContent.append("</div>");
        emailContent.append("</div>");
        emailContent.append("</body></html>");

        return emailContent.toString();
    }
}
