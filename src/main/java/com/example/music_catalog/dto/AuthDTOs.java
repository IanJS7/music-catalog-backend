package com.example.music_catalog.dto;

import lombok.Data;

// ── Auth DTOs ────────────────────────────────────────────────────────────────

public class AuthDTOs {

    @Data
    public static class RegisterRequest {
        private String username;
        private String password;
    }

    @Data
    public static class LoginRequest {
        private String username;
        private String password;
    }

    @Data
    public static class AuthResponse {
        private Long id;
        private String username;
        private String message;

        public AuthResponse(Long id, String username, String message) {
            this.id = id;
            this.username = username;
            this.message = message;
        }
    }
}
