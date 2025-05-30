package com.example.CandleShop.service;


import com.example.CandleShop.entity.User;
import com.example.CandleShop.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class UserService {
    private final UserRepository userRepository;

    private final PasswordEncoder passwordEncoder;

    private BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

    public UserService(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    public User registerUser(User user) throws Exception{
        if(userRepository.findByUsername(user.getUsername()) != null){
            throw new Exception("Username has been used");
        }
        if(userRepository.findByEmail(user.getEmail()) != null){
            throw new Exception("Email has been used");
        }
        String encodePassword = encoder.encode(user.getPassword());
        user.setRole(User.Role.USER);
        user.setPassword(encodePassword);
        user.setPoints(0);
        user.setStatus("ACTIVE");
        return userRepository.save(user);
    }
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }
    public User login(String usernameOrEmail, String password) throws Exception {
        User user = userRepository.findByUsernameOrEmail(usernameOrEmail, usernameOrEmail);

        if (user == null) {
            throw new Exception("Tài khoản không tồn tại");
        }

        if (!encoder.matches(password, user.getPassword())) {
            throw new Exception("Mật khẩu không chính xác");
        }

        if (!"ACTIVE".equals(user.getStatus())) {
            throw new Exception("Tài khoản đã bị khóa");
        }

        return user; // Trả về user với đầy đủ thông tin
    }

    public User getUserById(Long id) {
        return userRepository.findById(id).orElse(null);
    }
    public User findById(Long id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy user"));
    }
    public void createUser(User user) throws Exception {
        if (userRepository.findByUsername(user.getUsername()) != null) {
            throw new Exception("Tên đăng nhập đã được sử dụng");
        }
        if (userRepository.findByEmail(user.getEmail()) != null) {
            throw new Exception("Email đã được sử dụng");
        }

        // Mã hóa mật khẩu
        String encodedPassword = encoder.encode(user.getPassword());
        user.setPassword(encodedPassword);

        // Thiết lập các giá trị mặc định
        if (user.getPoints() == null) {
            user.setPoints(0);
        }
        if (user.getStatus() == null) {
            user.setStatus("ACTIVE");
        }
        user.setCreatedAt(LocalDateTime.now());

        userRepository.save(user);
    }

    public void updateUser(Long id, User updatedUser, Boolean changePassword, String newPassword) throws Exception {
        User existingUser = userRepository.findById(id)
                .orElseThrow(() -> new Exception("Không tìm thấy người dùng với ID: " + id));

        // Kiểm tra username và email trùng lặp
        User userWithSameUsername = userRepository.findByUsername(updatedUser.getUsername());
        if (userWithSameUsername != null && !userWithSameUsername.getId().equals(id)) {
            throw new Exception("Tên đăng nhập đã được sử dụng");
        }

        User userWithSameEmail = userRepository.findByEmail(updatedUser.getEmail());
        if (userWithSameEmail != null && !userWithSameEmail.getId().equals(id)) {
            throw new Exception("Email đã được sử dụng");
        }

        // Cập nhật thông tin
        existingUser.setUsername(updatedUser.getUsername());
        existingUser.setEmail(updatedUser.getEmail());
        existingUser.setFullName(updatedUser.getFullName());
        existingUser.setPhone(updatedUser.getPhone());
        existingUser.setAddress(updatedUser.getAddress());
        existingUser.setRole(updatedUser.getRole());
        existingUser.setPoints(updatedUser.getPoints());
        existingUser.setStatus(updatedUser.getStatus());

        // Cập nhật mật khẩu nếu được yêu cầu
        if (Boolean.TRUE.equals(changePassword) && newPassword != null && !newPassword.isEmpty()) {
            existingUser.setPassword(encoder.encode(newPassword));
        }

        userRepository.save(existingUser);
    }

    public void deleteUser(Long id) throws Exception {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new Exception("Không tìm thấy người dùng với ID: " + id));

        userRepository.delete(user);
    }

    public void toggleUserStatus(Long id) throws Exception {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new Exception("Không tìm thấy người dùng với ID: " + id));

        // Đảo ngược trạng thái
        if ("ACTIVE".equals(user.getStatus())) {
            user.setStatus("INACTIVE");
        } else {
            user.setStatus("ACTIVE");
        }

        userRepository.save(user);
    }
    public void addUserPoints(Long userId, Integer points) {
        User user = userRepository.findById(userId).orElse(null);
        if (user != null) {
            user.setPoints(user.getPoints() + points);
            userRepository.save(user);
        }
    }



}
