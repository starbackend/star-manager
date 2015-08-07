package star.manager;

import hu.mapro.mfw.spring.JsonArgConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;
import org.springframework.http.converter.json.Jackson2ObjectMapperBuilder;

import java.text.SimpleDateFormat;

@Configuration
@Import({
        StarManagerController.class,
        ProjectsController.class,
        OvrController.class,
        XmlController.class,
        StarManagerConfigService.class,
        JsonArgConfiguration.class
})
public class StarManagerWebConfiguration {

}
