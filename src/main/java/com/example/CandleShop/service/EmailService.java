package com.example.CandleShop.service;

import com.example.CandleShop.entity.Order;
import com.example.CandleShop.entity.OrderItem;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.text.NumberFormat;
import java.util.Locale;

@Service
public class EmailService {

    private static final Logger logger = LoggerFactory.getLogger(EmailService.class);
    private final JavaMailSender emailSender;
    private final NumberFormat currencyFormatter;

    public EmailService(JavaMailSender emailSender) {
        this.emailSender = emailSender;
        this.currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
    }

    // Gửi email khi admin xác nhận đơn hàng
    public void sendOrderConfirmedEmail(Order order) {
        EmailTemplate template = new EmailTemplate(
                "Đơn hàng #" + order.getOrderNumber() + " đã được xác nhận - Candle Shop",
                "Đơn hàng #" + order.getOrderNumber() + " đã được xác nhận",
                "Chúng tôi vui mừng thông báo rằng đơn hàng của bạn đã được xác nhận và đang được chuẩn bị.",
                "Đã xác nhận",
                "#d1ecf1",
                "#bee5eb",
                "#0c5460",
                "Đơn hàng của bạn sẽ được giao trong khoảng 3-5 ngày làm việc. Chúng tôi sẽ thông báo cho bạn khi đơn hàng được giao thành công."
        );

        sendEmail(order, order.getCustomerEmail(), template, "xác nhận");
    }

    public void sendOrderCompletedEmail(Order order) {
        EmailTemplate template = new EmailTemplate(
                "Đơn hàng #" + order.getOrderNumber() + " đã hoàn thành - Candle Shop",
                "Đơn hàng #" + order.getOrderNumber() + " đã hoàn thành",
                "Chúng tôi vui mừng thông báo rằng đơn hàng của bạn đã được giao thành công.",
                "Đã hoàn thành",
                "#d4edda",
                "#c3e6cb",
                "#155724",
                "Cảm ơn bạn đã mua sắm tại Candle Shop. Chúng tôi rất mong được phục vụ bạn trong tương lai!\nNếu bạn hài lòng với sản phẩm, hãy để lại đánh giá để giúp chúng tôi cải thiện dịch vụ."
        );

        sendEmail(order, order.getCustomerEmail(), template, "hoàn thành");
    }

    // Method chung để gửi email
    private void sendEmail(Order order, String customerEmail, EmailTemplate template, String emailType) {
        try {
            logger.info("Bắt đầu gửi email {} đơn hàng #{}", emailType, order.getOrderNumber());

            MimeMessage message = emailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            logger.info("Chuẩn bị gửi email {} đơn hàng đến: {}", emailType, customerEmail);
            helper.setTo(customerEmail);
            helper.setSubject(template.subject);

            String content = buildEmailContent(order, template);
            helper.setText(content, true);

            logger.debug("Nội dung email đã được tạo thành công");
            logger.info("Đang gửi email {} đơn hàng #{} đến {}", emailType, order.getOrderNumber(), customerEmail);

            emailSender.send(message);

            logger.info("Email {} đơn hàng #{} đã được gửi thành công đến {}", emailType, order.getOrderNumber(), customerEmail);

        } catch (MessagingException e) {
            logger.error("Lỗi khi gửi email {} đơn hàng #{}: {}", emailType, order.getOrderNumber(), e.getMessage());
            e.printStackTrace();
        }
    }

    // Method chung để build nội dung email
    private String buildEmailContent(Order order, EmailTemplate template) {
        StringBuilder emailContent = new StringBuilder();

        // Header
        emailContent.append(buildEmailHeader());

        // Main content
        emailContent.append("<div style='padding: 20px; border: 1px solid #e0e0e0; background-color: #f9f9f9;'>");
        emailContent.append("<h2>").append(template.title).append("</h2>");
        emailContent.append("<p>Xin chào ").append(order.getShippingName()).append(",</p>");
        emailContent.append("<p>").append(template.message).append("</p>");

        // Status box
        emailContent.append(buildStatusBox(template));

        // Order details table
        emailContent.append(buildOrderDetailsTable(order));

        // Order summary
        emailContent.append(buildOrderSummary(order));

        // Shipping info
        emailContent.append(buildShippingInfo(order));

        // Footer message
        emailContent.append(buildFooterMessage(template.footerMessage));

        emailContent.append("</div>");

        // Email footer
        emailContent.append(buildEmailFooter());

        return emailContent.toString();
    }

    private String buildEmailHeader() {
        return "<html><body>" +
                "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;'>" +
                "<div style='background-color: #4A3427; padding: 20px; text-align: center;'>" +
                "<h1 style='color: white; margin: 0;'>Candle Shop</h1>" +
                "</div>";
    }

    private String buildStatusBox(EmailTemplate template) {
        return "<div style='background-color: " + template.statusBgColor + "; " +
                "border: 1px solid " + template.statusBorderColor + "; " +
                "color: " + template.statusTextColor + "; " +
                "padding: 12px; margin: 15px 0; border-radius: 4px;'>" +
                "<strong>Trạng thái đơn hàng:</strong> " + template.statusText +
                "</div>";
    }

    private String buildOrderDetailsTable(Order order) {
        StringBuilder table = new StringBuilder();
        table.append("<h3>Thông tin đơn hàng:</h3>");
        table.append("<table style='width: 100%; border-collapse: collapse;'>");
        table.append("<tr style='background-color: #f2f2f2;'>");
        table.append("<th style='padding: 10px; text-align: left; border: 1px solid #ddd;'>Sản phẩm</th>");
        table.append("<th style='padding: 10px; text-align: center; border: 1px solid #ddd;'>Số lượng</th>");
        table.append("<th style='padding: 10px; text-align: right; border: 1px solid #ddd;'>Đơn giá</th>");
        table.append("<th style='padding: 10px; text-align: right; border: 1px solid #ddd;'>Thành tiền</th>");
        table.append("</tr>");

        for (OrderItem item : order.getOrderItems()) {
            table.append("<tr>");
            table.append("<td style='padding: 10px; border: 1px solid #ddd;'>")
                    .append(item.getProduct().getName())
                    .append(" (").append(item.getProductSize().getSizeValue()).append("ml)")
                    .append("</td>");
            table.append("<td style='padding: 10px; text-align: center; border: 1px solid #ddd;'>")
                    .append(item.getQuantity())
                    .append("</td>");
            table.append("<td style='padding: 10px; text-align: right; border: 1px solid #ddd;'>")
                    .append(currencyFormatter.format(item.getUnitPrice()))
                    .append("</td>");
            table.append("<td style='padding: 10px; text-align: right; border: 1px solid #ddd;'>")
                    .append(currencyFormatter.format(item.getSubtotal()))
                    .append("</td>");
            table.append("</tr>");
        }
        table.append("</table>");
        return table.toString();
    }

    private String buildOrderSummary(Order order) {
        StringBuilder summary = new StringBuilder();
        summary.append("<div style='margin-top: 20px;'>");
        summary.append("<p style='text-align: right;'><strong>Tổng tiền hàng:</strong> ")
                .append(currencyFormatter.format(order.getTotalAmount()))
                .append("</p>");

        if (order.getDiscountAmount() != null && order.getDiscountAmount().compareTo(BigDecimal.ZERO) > 0) {
            summary.append("<p style='text-align: right;'><strong>Giảm giá:</strong> ")
                    .append(currencyFormatter.format(order.getDiscountAmount()))
                    .append("</p>");
        }

        summary.append("<p style='text-align: right;'><strong>Phí vận chuyển:</strong> ")
                .append(currencyFormatter.format(order.getShippingFee()))
                .append("</p>");

        summary.append("<p style='text-align: right; font-size: 18px;'><strong>Tổng thanh toán:</strong> ")
                .append(currencyFormatter.format(order.getFinalAmount()))
                .append("</p>");
        summary.append("</div>");
        return summary.toString();
    }

    private String buildShippingInfo(Order order) {
        return "<div style='margin-top: 30px;'>" +
                "<h3>Thông tin giao hàng:</h3>" +
                "<p><strong>Người nhận:</strong> " + order.getShippingName() + "</p>" +
                "<p><strong>Số điện thoại:</strong> " + order.getShippingPhone() + "</p>" +
                "<p><strong>Địa chỉ:</strong> " + order.getShippingAddress() + "</p>" +
                "</div>";
    }

    private String buildFooterMessage(String footerMessage) {
        StringBuilder footer = new StringBuilder();
        footer.append("<div style='margin-top: 30px;'>");

        String[] messages = footerMessage.split("\n");
        for (String message : messages) {
            footer.append("<p>").append(message).append("</p>");
        }

        footer.append("<p>Nếu bạn có bất kỳ câu hỏi nào về đơn hàng, vui lòng liên hệ với chúng tôi qua email support@candleshop.com hoặc số điện thoại 0123456789.</p>");
        footer.append("<p>Trân trọng,<br>Đội ngũ Candle Shop</p>");
        footer.append("</div>");
        return footer.toString();
    }

    private String buildEmailFooter() {
        return "<div style='background-color: #f2f2f2; padding: 15px; text-align: center; font-size: 12px;'>" +
                "<p>&copy; 2025 Candle Shop. All rights reserved.</p>" +
                "</div>" +
                "</div>" +
                "</body></html>";
    }

    // Inner class để chứa template data
    private static class EmailTemplate {
        final String subject;
        final String title;
        final String message;
        final String statusText;
        final String statusBgColor;
        final String statusBorderColor;
        final String statusTextColor;
        final String footerMessage;

        EmailTemplate(String subject, String title, String message, String statusText,
                      String statusBgColor, String statusBorderColor, String statusTextColor,
                      String footerMessage) {
            this.subject = subject;
            this.title = title;
            this.message = message;
            this.statusText = statusText;
            this.statusBgColor = statusBgColor;
            this.statusBorderColor = statusBorderColor;
            this.statusTextColor = statusTextColor;
            this.footerMessage = footerMessage;
        }
    }
}