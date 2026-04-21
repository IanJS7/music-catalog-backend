package com.example.music_catalog.dto;

import lombok.*; // Esto importa todo lo de Lombok

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder // <--- ESTA es la que te falta para quitar el error en el Service
public class SongResponse {
    private Long id;
    private String title;
    private String artist;
    private String imageUrl;
    private String username;
}