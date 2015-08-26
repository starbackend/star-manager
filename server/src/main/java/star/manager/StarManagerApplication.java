package star.manager;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.data.rest.RepositoryRestMvcAutoConfiguration;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.boot.autoconfigure.orm.jpa.HibernateJpaAutoConfiguration;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.context.web.SpringBootServletInitializer;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;

import java.awt.*;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;

@Configuration
@EnableAutoConfiguration(exclude={
        DataSourceAutoConfiguration.class,
        RepositoryRestMvcAutoConfiguration.class,
        HibernateJpaAutoConfiguration.class
})
@Import({ 
	StarManagerWebConfiguration.class
})
public class StarManagerApplication extends SpringBootServletInitializer implements CommandLineRunner {
    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(StarManagerApplication.class);
    }

    public static void main(String[] args) throws Exception {
        SpringApplication app = new SpringApplication(StarManagerApplication.class);
        app.setHeadless(false);
        app.run(args);
    }

    @Value("http://localhost:${server.port}")
    String url;

    @Override
    public void run(String... args) throws Exception {
        if(Desktop.isDesktopSupported()){
            Desktop desktop = Desktop.getDesktop();
            try {
                desktop.browse(new URI(url));
            } catch (IOException | URISyntaxException e) {
                e.printStackTrace();
            }
        }

    }
}
