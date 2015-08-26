package star.manager;

import hu.mapro.mfw.spring.JsonArg;
import org.cwatch.imdate.domain.Projects;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import star.connect.imdate.format.ImdateRestClient;
import star.connect.imdate.format.ProjectsOvrSummary;

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


    @RequestMapping(value="/{projectName}/projectsOvr", method = RequestMethod.GET)
    public ProjectsOvrSummary getProjectsOvr(
            @PathVariable("env") String env,
            @PathVariable("projectName") String projectName
    ) {
        return configService.getEnvironment(env).getBeans().projectsOvrService.getProjectsOvrSummary(projectName);
    }

    @RequestMapping(value="/{projectName}/projectsOvr", method = RequestMethod.DELETE)
    public ImdateRestClient.ImdateRestResponse deleteProjectsOvr(
            @PathVariable("env") String env,
            @PathVariable("projectName") String projectName
    ) {
        return configService.getEnvironment(env).getBeans().projectsOvrService.deleteProjectsOvr(projectName);
    }

}

