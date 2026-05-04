package com.example.music_catalog.service;

import com.example.music_catalog.dto.SongDTOs.*;
import com.example.music_catalog.entity.*;
import com.example.music_catalog.repository.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class SongService {

    private final SongRepository songRepository;
    private final UserRepository userRepository;
    private final ReactionRepository reactionRepository;
    private final CommentRepository commentRepository;
    private final String DEFAULT_IMAGE = "https://via.placeholder.com/500x500.png?text=No+Image+Found";

    public SongService(SongRepository songRepository,
                       UserRepository userRepository,
                       ReactionRepository reactionRepository,
                       CommentRepository commentRepository) {
        this.songRepository = songRepository;
        this.userRepository = userRepository;
        this.reactionRepository = reactionRepository;
        this.commentRepository = commentRepository;
    }

    public List<SongResponse> getAllSongs() {
        return songRepository.findAllByOrderByIdDesc()
                .stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }

    public SongResponse getSongById(Long id) {
        Song song = songRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Canción no encontrada con id: " + id));
        return toResponse(song);
    }

    @Transactional
    public SongResponse createSong(SongRequest request) {
        validate(request);
        User user = userRepository.findById(request.getUserId())
                .orElseThrow(() -> new IllegalArgumentException("Usuario no encontrado con id: " + request.getUserId()));

        Song song = Song.builder()
                .title(request.getTitle())
                .artist(request.getArtist())
                .imageUrl(processImageUrl(request.getImageUrl()))
                .user(user)
                .build();

        return toResponse(songRepository.save(song));
    }

    @Transactional
    public SongResponse updateSong(Long id, SongRequest request) {
        validate(request);
        Song song = songRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Canción no encontrada con id: " + id));

        song.setTitle(request.getTitle());
        song.setArtist(request.getArtist());
        song.setImageUrl(processImageUrl(request.getImageUrl()));

        if (!song.getUser().getId().equals(request.getUserId())) {
            User newUser = userRepository.findById(request.getUserId())
                    .orElseThrow(() -> new IllegalArgumentException("Nuevo usuario no encontrado"));
            song.setUser(newUser);
        }

        return toResponse(songRepository.save(song));
    }

    public void deleteSong(Long id) {
        if (!songRepository.existsById(id)) {
            throw new IllegalArgumentException("Canción no encontrada con id: " + id);
        }
        songRepository.deleteById(id);
    }

    // --- MÉTODOS DE REACCIONES ---

    @Transactional
    public void toggleLike(Long songId, Long userId) {
        reactionRepository.findBySongIdAndUserId(songId, userId)
                .ifPresentOrElse(
                        reactionRepository::delete,
                        () -> {
                            Song song = songRepository.findById(songId).orElseThrow();
                            User user = userRepository.findById(userId).orElseThrow();
                            reactionRepository.save(Reaction.builder().song(song).user(user).build());
                        }
                );
    }

    // Este es el método que le faltaba a tu Controller para la línea 81
    @Transactional
    public void addReaction(Long songId, Long userId) {
        Song song = songRepository.findById(songId)
                .orElseThrow(() -> new IllegalArgumentException("Canción no encontrada"));
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("Usuario no encontrado"));

        // Verificamos si ya existe la reacción para no duplicarla
        if (reactionRepository.findBySongIdAndUserId(songId, userId).isEmpty()) {
            reactionRepository.save(Reaction.builder()
                    .song(song)
                    .user(user)
                    .build());
        }
    }

    // --- MÉTODOS DE COMENTARIOS ---

    @Transactional
    public CommentResponse addComment(Long songId, CommentRequest request) {
        Song song = songRepository.findById(songId)
                .orElseThrow(() -> new IllegalArgumentException("Canción no encontrada"));
        User user = userRepository.findById(request.getUserId())
                .orElseThrow(() -> new IllegalArgumentException("Usuario no encontrado"));

        Comment comment = Comment.builder()
                .content(request.getContent())
                .song(song)
                .user(user)
                .build();

        Comment savedComment = commentRepository.save(comment);

        return CommentResponse.builder()
                .content(savedComment.getContent())
                .username(user.getUsername())
                .createdAt(savedComment.getCreatedAt() != null ? savedComment.getCreatedAt().toString() : "")
                .build();
    }

    private String processImageUrl(String url) {
        if (url == null || url.isBlank() || !url.toLowerCase().startsWith("http")) {
            return DEFAULT_IMAGE;
        }
        return url;
    }

    private SongResponse toResponse(Song song) {
        List<CommentResponse> commentDtos = new ArrayList<>();
        if (song.getComments() != null) {
            commentDtos = song.getComments().stream().map(c -> CommentResponse.builder()
                    .content(c.getContent())
                    .username(c.getUser() != null ? c.getUser().getUsername() : "Anónimo")
                    .createdAt(c.getCreatedAt() != null ? c.getCreatedAt().toString() : "")
                    .build()).collect(Collectors.toList());
        }

        return SongResponse.builder()
                .id(song.getId())
                .title(song.getTitle())
                .artist(song.getArtist())
                .imageUrl(song.getImageUrl())
                .addedBy(song.getUser() != null ? song.getUser().getUsername() : "Anónimo")
                .reactionCount(song.getReactions() != null ? song.getReactions().size() : 0)
                .comments(commentDtos)
                .build();
    }

    private void validate(SongRequest request) {
        if (request.getTitle() == null || request.getTitle().isBlank()) throw new IllegalArgumentException("Título requerido");
        if (request.getArtist() == null || request.getArtist().isBlank()) throw new IllegalArgumentException("Artista requerido");
        if (request.getUserId() == null) throw new IllegalArgumentException("ID de usuario requerido");
    }
}