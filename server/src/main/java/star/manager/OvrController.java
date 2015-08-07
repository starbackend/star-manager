package star.manager;

import org.cwatch.imdate.domain.VesselIds;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import star.connect.imdate.OvrUpdateXmlTools;

import java.util.List;

/**
 * Created by pappmar on 03/08/2015.
 */
@RestController
@RequestMapping("/api/env/{env}/ovr")
public class OvrController {

    @Autowired
    StarManagerConfigService configService;

    @RequestMapping(method = RequestMethod.GET)
    public List<? extends VesselIds> search(
            @PathVariable("env") String env,
            OvrSearchParameters parameters
    ) {
        return configService.getEnvironment(env).getBeans().ovrService.search(parameters);
    }

    @RequestMapping(method=RequestMethod.POST)
    public String update(
            @PathVariable("env") String env,
            @RequestBody String xml
    ) {
        configService.getEnvironment(env).getBeans().ovrService.send(xml);
        return "\"OK\"";
    }

}
