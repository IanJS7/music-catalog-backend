package com.example.music_catalog.service;

import com.example.music_catalog.dto.SongDTOs.*;
import com.example.music_catalog.entity.Song;
import com.example.music_catalog.entity.User;
import com.example.music_catalog.repository.SongRepository;
import com.example.music_catalog.repository.UserRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class SongService {

    private final SongRepository songRepository;
    private final UserRepository userRepository;

    public SongService(SongRepository songRepository, UserRepository userRepository) {
        this.songRepository = songRepository;
        this.userRepository = userRepository;
    }

    public List<SongResponse> getAllSongs() {
        return songRepository.findAllByOrderByIdDesc()
                .stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }

    public SongResponse getSongById(Long id) {
        Song song = songRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Song not found with id: " + id));
        return toResponse(song);
    }

    public SongResponse createSong(SongRequest request) {
        validate(request);

        User user = userRepository.findById(request.getUserId())
                .orElseThrow(() -> new IllegalArgumentException("User not found with id: " + request.getUserId()));

        Song song = Song.builder()
                .title(request.getTitle())
                .artist(request.getArtist())
                .imageUrl(request.getImageUrl())
                .user(user)
                .build();

        return toResponse(songRepository.save(song));
    }

    public SongResponse updateSong(Long id, SongRequest request) {
        validate(request);

        Song song = songRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Song not found with id: " + id));

        song.setTitle(request.getTitle());
        song.setArtist(request.getArtist());
        song.setImageUrl(request.getImageUrl());

        return toResponse(songRepository.save(song));
    }

    public void deleteSong(Long id) {
        if (!songRepository.existsById(id)) {
            throw new IllegalArgumentException("Song not found with id: " + id);
        }
        songRepository.deleteById(id);
    }

    // ── Helpers ──────────────────────────────────────────────────────────────

    private SongResponse toResponse(Song song) {
        return new SongResponse(
                song.getId(),
                song.getTitle(),
                song.getArtist(),
                song.getImageUrl(),
                song.getUser().getUsername()
        );
    }

    private void validate(SongRequest request) {
        if (request.getTitle() == null || request.getTitle().isBlank()) {
            throw new IllegalArgumentException("Title is required");
        }
        if (request.getArtist() == null || request.getArtist().isBlank()) {
            throw new IllegalArgumentException("Artist is required");
        }
        if (request.getImageUrl() == null || request.getImageUrl().isBlank()) {
            throw new IllegalArgumentException("Image URL is required");
        }
        if (request.getUserId() == null) {
            throw new IllegalArgumentException("User ID is required");
        }
    }
}
