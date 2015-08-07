package star.manager;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.data.rest.RepositoryRestMvcAutoConfiguration;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.boot.autoconfigure.orm.jpa.HibernateJpaAutoConfiguration;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.context.web.SpringBootServletInitializer;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;

@Configuration
@EnableAutoConfiguration(exclude={
        DataSourceAutoConfiguration.class,
        RepositoryRestMvcAutoConfiguration.class,
        HibernateJpaAutoConfiguration.class
})
@Import({ 
	StarManagerWebConfiguration.class
})
public class StarManagerApplication extends SpringBootServletInitializer {
    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(StarManagerApplication.class);
    }

    public static void main(String[] args) throws Exception {
        SpringApplication.run(StarManagerApplication.class, args);
    }
}
