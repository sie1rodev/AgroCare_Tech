package br.com.fiap.mvcagrocaretech.veterinario;

import br.com.fiap.mvcagrocaretech.servico.Servico;
import br.com.fiap.mvcagrocaretech.servico.ServicoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class VeterinarioService {

    private final VeterinarioRepository veterinarioRepository;

    @Autowired
    public VeterinarioService(VeterinarioRepository veterinarioRepository) {
        this.veterinarioRepository = veterinarioRepository;
    }

    public List<Veterinario> findAll() {
        return veterinarioRepository.findAll();
    }

    public List<Veterinario> findDestaques() {
        return veterinarioRepository.findAllByOrderByNameAsc();
    }
}
