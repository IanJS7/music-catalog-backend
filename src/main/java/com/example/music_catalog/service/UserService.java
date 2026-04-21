package com.example.music_catalog.service;

import com.example.music_catalog.dto.AuthDTOs.*;
import com.example.music_catalog.entity.User;
import com.example.music_catalog.repository.UserRepository;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public AuthResponse register(RegisterRequest request) {
        if (request.getUsername() == null || request.getUsername().isBlank()) {
            throw new IllegalArgumentException("Username is required");
        }
        if (request.getPassword() == null || request.getPassword().isBlank()) {
            throw new IllegalArgumentException("Password is required");
        }
        if (userRepository.existsByUsername(request.getUsername())) {
            throw new IllegalArgumentException("Username already taken");
        }

        // NOTE: In production, hash the password (e.g. BCrypt).
        // Kept plain for simplicity as per spec.
        User user = User.builder()
                .username(request.getUsername())
                .password(request.getPassword())
                .build();

        User saved = userRepository.save(user);
        return new AuthResponse(saved.getId(), saved.getUsername(), "Registered successfully");
    }

    public AuthResponse login(LoginRequest request) {
        User user = userRepository.findByUsername(request.getUsername())
                .orElseThrow(() -> new IllegalArgumentException("Invalid username or password"));

        if (!user.getPassword().equals(request.getPassword())) {
            throw new IllegalArgumentException("Invalid username or password");
        }

        return new AuthResponse(user.getId(), user.getUsername(), "Login successful");
    }
}
