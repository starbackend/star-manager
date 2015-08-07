package star.manager;

import org.cwatch.imdate.ImdateServices;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Import;
import org.springframework.stereotype.Component;
import star.connect.imdate.DefaultConfigService;
import star.connect.imdate.ImdateConfigurationBase;

/**
 * Created by pappmar on 03/08/2015.
 */
@Component
@Import({
        ImdateConfigurationBase.class
})
public class StarManagerConfigService extends DefaultConfigService {
    @Autowired
    public StarManagerConfigService(ImdateServices imdateServices, ApplicationContext applicationContext) {
        super(imdateServices, applicationContext);
    }
}
