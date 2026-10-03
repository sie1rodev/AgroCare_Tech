package br.com.fiap.mvcagrocaretech.user;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.core.user.DefaultOAuth2User;
import org.springframework.security.oauth2.core.user.OAuth2User;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Entity
@Table(name = "agrocare_users")
@Data
public class User extends DefaultOAuth2User {

    @Id
    UUID id = UUID.randomUUID();

    String name;

    @Column(unique = true)
    String email;
    String avatar;
    String phoneNumber;
    String password;
    LocalDateTime createdAt;
    LocalDateTime updatedAt;


    public User(OAuth2User principal){
        super(
                List.of(new SimpleGrantedAuthority("USER")),
                principal.getAttributes(),
                "email"
        );
        this.name = principal.getAttribute("name");
        // GitHub envia "avatar_url"; Google envia "picture"
        String githubAvatar = principal.getAttribute("avatar_url");
        this.avatar = githubAvatar != null ? githubAvatar : principal.getAttribute("picture");
        this.email = principal.getAttribute("email");
    }

    public User(){
        super(
                List.of(new SimpleGrantedAuthority("USER")),
                Map.of("email", "anonymous@email.com"),
                "email"
        );
        this.email = this.getAttribute("email");
    }

}
