package com.example.music_catalog.repository;

import com.example.music_catalog.entity.Comment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface CommentRepository extends JpaRepository<Comment, Long> {
    // Busca comentarios de una canción específica ordenados por los más recientes
    List<Comment> findAllBySongIdOrderByCreatedAtDesc(Long songId);
}