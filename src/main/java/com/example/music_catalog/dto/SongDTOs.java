package com.example.music_catalog.dto;

import lombok.*;
import java.util.List;

public class SongDTOs {

    @Data @Builder @NoArgsConstructor @AllArgsConstructor
    public static class SongRequest {
        private String title;
        private String artist;
        private String imageUrl;
        private Long userId;
    }

    @Data @Builder @NoArgsConstructor @AllArgsConstructor
    public static class SongResponse {
        private Long id;
        private String title;
        private String artist;
        private String imageUrl;
        private String addedBy;
        private int reactionCount;
        private List<CommentResponse> comments;
    }

    @Data @Builder @NoArgsConstructor @AllArgsConstructor
    public static class CommentResponse {
        private String content;
        private String username;
        private String createdAt;
    }

    @Data @NoArgsConstructor @AllArgsConstructor
    public static class CommentRequest {
        private String content;
        private Long userId;
    }
}
