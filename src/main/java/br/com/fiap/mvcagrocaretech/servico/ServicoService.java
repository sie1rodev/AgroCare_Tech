package br.com.fiap.mvcagrocaretech.servico;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.http.HttpStatus;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Service
public class ServicoService {

    private final ServicoRepository repository;

    @Autowired
    public ServicoService(ServicoRepository repository) {
        this.repository = repository;
    }

    public List<Servico> findAll() {
        return repository.findAll();
    }

    public long count() {
        return repository.count();
    }

    public long countUltimosDias(int dias) {
        return repository.countByDataServicoGreaterThanEqual(LocalDate.now().minusDays(dias));
    }

}
