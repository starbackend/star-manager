package star.manager;

import org.cwatch.imdate.domain.Projects;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.stream.Collectors;

/**
 * Created by pappmar on 03/08/2015.
 */
@RestController
@RequestMapping("/api")
public class StarManagerController {

    @Autowired
    StarManagerConfigService configService;

    @RequestMapping("/environments")
    public List<String> environments() {
        return configService.getEnvironmentNames().collect(Collectors.<String>toList());
    }

}
