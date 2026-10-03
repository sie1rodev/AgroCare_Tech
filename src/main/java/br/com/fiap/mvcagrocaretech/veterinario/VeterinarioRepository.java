package br.com.fiap.mvcagrocaretech.veterinario;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface VeterinarioRepository extends JpaRepository<Veterinario, UUID>{

    List<Veterinario> findByName(String name);

    List<Veterinario> findAllByOrderByNameAsc();
}
