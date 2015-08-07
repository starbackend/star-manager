package star.manager;

import hu.mapro.mfw.model.Field;
import hu.mapro.mfw.model.Model;
import hu.mapro.mfw.spring.JsonArg;
import org.cwatch.imdate.domain.Projects;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Created by pappmar on 03/08/2015.
 */
@RestController
@RequestMapping("/api/env/{env}/projects")
public class ProjectsController {

    @Autowired
    StarManagerConfigService configService;

    @RequestMapping(method = RequestMethod.GET)
    public List<Projects> projects(@PathVariable("env") String env) {
        return configService.getEnvironment(env).getBeans().projectsRepository.findAll();
    }

    @RequestMapping(method = RequestMethod.POST)
    public String createProject(
            @PathVariable("env") String env,
            @JsonArg("$.name") String name,
            @JsonArg("$.description") String description
    ) {
        configService.getEnvironment(env).getBeans().imdateRestClient.createProject(
                name,
                description
        );
        return "\"OK\"";
    }


}
