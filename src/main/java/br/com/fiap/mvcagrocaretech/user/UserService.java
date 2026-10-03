package br.com.fiap.mvcagrocaretech.user;

import jakarta.validation.constraints.Min;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserService extends DefaultOAuth2UserService {


    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public void register(OAuth2User principal) {
        if(userRepository.findByEmail(principal.getAttribute("email")).isEmpty())
            userRepository.save(new User(principal));

    }

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        var principal = super.loadUser(userRequest);
        var email = principal.getAttribute("email").toString();
        var current = new User(principal);

        // Mesmo e-mail em provedores diferentes (GitHub/Google) = mesma conta.
        // Atualiza nome e foto com os dados do provedor usado neste login.
        return userRepository.findByEmail(email)
                .map(saved -> {
                    if (current.getName() != null) saved.setName(current.getName());
                    if (current.getAvatar() != null) saved.setAvatar(current.getAvatar());
                    return (OAuth2User) userRepository.save(saved);
                })
                .orElse(current);
    }
}
