// ReactionRepository.java
package com.example.music_catalog.repository;
import com.example.music_catalog.entity.Reaction;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface ReactionRepository extends JpaRepository<Reaction, Long> {
    Optional<Reaction> findBySongIdAndUserId(Long songId, Long userId);
}

