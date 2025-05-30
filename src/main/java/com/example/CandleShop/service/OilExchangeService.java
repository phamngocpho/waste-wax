package com.example.CandleShop.service;

import com.example.CandleShop.entity.OilExchange;
import com.example.CandleShop.entity.User;
import com.example.CandleShop.enums.ExchangeStatus;
import com.example.CandleShop.repository.OilExchangeRepository;
import com.example.CandleShop.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Random;

@Service
public class OilExchangeService {

    private final OilExchangeRepository oilExchangeRepository;

    private final UserRepository userRepository;

    private static final int POINTS_PER_LITER = 10;
    private static final double MINIMUM_OIL_AMOUNT = 5.0;

    public OilExchangeService(OilExchangeRepository oilExchangeRepository, UserRepository userRepository) {
        this.oilExchangeRepository = oilExchangeRepository;
        this.userRepository = userRepository;
    }

    // Tạo mã trao đổi dầu
    private String generateExchangeNumber() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyMMdd");
        String datePrefix = LocalDateTime.now().format(formatter);

        Random random = new Random();
        int randomNumber = random.nextInt(10000);

        return "OIL" + datePrefix + String.format("%04d", randomNumber);
    }

    // Tạo yêu cầu trao đổi dầu mới
    @Transactional
    public void createExchange(OilExchange exchange, Long userId) throws Exception {
        // Kiểm tra số lượng dầu tối thiểu
        if (exchange.getOilAmount() < MINIMUM_OIL_AMOUNT) {
            throw new Exception("Số lượng dầu tối thiểu phải từ 5 lít trở lên");
        }

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new Exception("Không tìm thấy người dùng"));

        // Tính điểm thưởng dựa trên số lượng dầu
        int points = (int) (exchange.getOilAmount() * POINTS_PER_LITER);

        // Thiết lập các giá trị
        exchange.setUser(user);
        exchange.setPointsEarned(points);
        exchange.setStatus(ExchangeStatus.PENDING);
        exchange.setExchangeNumber(generateExchangeNumber());

        oilExchangeRepository.save(exchange);
    }

    // Lấy tất cả yêu cầu của một người dùng
    public List<OilExchange> getUserExchanges(User user) {
        return oilExchangeRepository.findByUserOrderByCreatedAtDesc(user);
    }
    public List<OilExchange> getCompletedExchanges() {
        return oilExchangeRepository.findByStatus(ExchangeStatus.COMPLETED);
    }
    // Lấy yêu cầu theo ID
    public OilExchange getExchangeById(Long id) throws Exception {
        return oilExchangeRepository.findById(id)
                .orElseThrow(() -> new Exception("Không tìm thấy yêu cầu trao đổi dầu"));
    }

    // Lấy tất cả yêu cầu đang chờ xử lý
    public List<OilExchange> getPendingExchanges() {
        return oilExchangeRepository.findByStatus(ExchangeStatus.PENDING);
    }

    // Lấy tất cả yêu cầu đã được duyệt, đang chờ lấy dầu
    public List<OilExchange> getApprovedExchanges() {
        return oilExchangeRepository.findByStatus(ExchangeStatus.APPROVED);
    }

    // Phê duyệt yêu cầu
    @Transactional
    public void approveExchange(Long exchangeId, LocalDateTime pickupDate) throws Exception {
        OilExchange exchange = getExchangeById(exchangeId);

        if (exchange.getStatus() != ExchangeStatus.PENDING) {
            throw new Exception("Chỉ có thể phê duyệt yêu cầu đang chờ xử lý");
        }

        exchange.setStatus(ExchangeStatus.APPROVED);
        exchange.setScheduledPickupDate(pickupDate);

        oilExchangeRepository.save(exchange);
    }

    // Hoàn thành yêu cầu và cộng điểm cho người dùng
    @Transactional
    public void completeExchange(Long exchangeId) throws Exception {
        OilExchange exchange = getExchangeById(exchangeId);

        if (exchange.getStatus() != ExchangeStatus.APPROVED) {
            throw new Exception("Chỉ có thể hoàn thành yêu cầu đã được phê duyệt");
        }

        // Cộng điểm cho người dùng
        User user = exchange.getUser();
        Integer currentPoints = user.getPoints() != null ? user.getPoints() : 0;
        user.setPoints(currentPoints + exchange.getPointsEarned());
        userRepository.save(user);

        // Cập nhật trạng thái yêu cầu
        exchange.setStatus(ExchangeStatus.COMPLETED);

        oilExchangeRepository.save(exchange);
    }

    // Từ chối yêu cầu
    @Transactional
    public void rejectExchange(Long exchangeId) throws Exception {
        OilExchange exchange = getExchangeById(exchangeId);

        if (exchange.getStatus() != ExchangeStatus.PENDING) {
            throw new Exception("Chỉ có thể từ chối yêu cầu đang chờ xử lý");
        }

        exchange.setStatus(ExchangeStatus.REJECTED);

        oilExchangeRepository.save(exchange);
    }

    // Hủy yêu cầu
    @Transactional
    public void cancelExchange(Long exchangeId) throws Exception {
        OilExchange exchange = getExchangeById(exchangeId);

        if (exchange.getStatus() != ExchangeStatus.PENDING && exchange.getStatus() != ExchangeStatus.APPROVED) {
            throw new Exception("Chỉ có thể hủy yêu cầu đang chờ xử lý hoặc đã được phê duyệt");
        }

        exchange.setStatus(ExchangeStatus.CANCELLED);

        oilExchangeRepository.save(exchange);
    }
}
