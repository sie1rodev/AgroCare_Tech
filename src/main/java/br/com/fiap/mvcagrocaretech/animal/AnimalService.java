package br.com.fiap.mvcagrocaretech.animal;




import org.springframework.stereotype.Service;

import java.util.List;


@Service
public class AnimalService {
    private final AnimalRepository animalRepository;

    public AnimalService(AnimalRepository animalRepository) {
        this.animalRepository = animalRepository;
    }

    public List<Animal> findAll(){
        return animalRepository.findAll();
    }

    public long count(){
        return animalRepository.count();
    }
}
