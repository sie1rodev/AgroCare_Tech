package br.com.fiap.mvcagrocaretech.servico;

import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.UUID;

public interface ServicoRepository extends JpaRepository<Servico, UUID> {

    long countByDataServicoGreaterThanEqual(LocalDate data);
}