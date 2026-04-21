package com.example.music_catalog.dto;

import lombok.Data;

public class SongDTOs {

    @Data
    public static class SongRequest {
        private String title;
        private String artist;
        private String imageUrl;
        private Long userId;
    }

    @Data
    public static class SongResponse {
        private Long id;
        private String title;
        private String artist;
        private String imageUrl;
        private String addedBy; // username

        public SongResponse(Long id, String title, String artist, String imageUrl, String addedBy) {
            this.id = id;
            this.title = title;
            this.artist = artist;
            this.imageUrl = imageUrl;
            this.addedBy = addedBy;
        }
    }
}
