package com.example.music_catalog.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Entity
@Table(name = "songs")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Song {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 150)
    private String title;

    @Column(nullable = false, length = 150)
    private String artist;

    // Aumentamos a 1000 por si las URLs son largas
    @Column(nullable = false, length = 1000)
    private String imageUrl;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
// --- NUEVOS CAMPOS ---

    @OneToMany(mappedBy = "song", cascade = CascadeType.ALL)
    private List<Reaction> reactions;

    @OneToMany(mappedBy = "song", cascade = CascadeType.ALL)
    private List<Comment> comments;

    // Campo auxiliar para enviar el nombre del dueño a Flutter más fácil
    public String getAddedBy() {
        return (user != null) ? user.getUsername() : "Desconocido";
    }

    // Campo auxiliar para el contador de likes que usaremos en el DTO/Frontend
    public int getReactionCount() {
        return (reactions != null) ? reactions.size() : 0;
    }
}
