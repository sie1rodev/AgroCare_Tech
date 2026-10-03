package br.com.fiap.mvcagrocaretech.user;

import br.com.fiap.mvcagrocaretech.animal.AnimalService;
import br.com.fiap.mvcagrocaretech.servico.ServicoService;
import br.com.fiap.mvcagrocaretech.veterinario.VeterinarioService;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class UserController {

    private final UserService userService;
    private final AnimalService animalService;
    private final ServicoService servicoService;
    private final VeterinarioService veterinarioService;

    public UserController(UserService userService, AnimalService animalService,
                          ServicoService servicoService, VeterinarioService veterinarioService) {
        this.userService = userService;
        this.animalService = animalService;
        this.servicoService = servicoService;
        this.veterinarioService = veterinarioService;
    }

    @GetMapping
    public String index(Model model, @AuthenticationPrincipal OAuth2User principal){
        var user = (User) principal;

        model.addAttribute("user", user);
        model.addAttribute("totalAnimais", animalService.count());
        model.addAttribute("totalConsultas", servicoService.count());
        model.addAttribute("consultasRecentes", servicoService.countUltimosDias(30));
        model.addAttribute("especialistas", veterinarioService.findDestaques());

        return "index";

    }


}
