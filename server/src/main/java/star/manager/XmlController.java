package star.manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import star.connect.imdate.format.OvrUpdateXmlTools;

/**
 * Created by pappmar on 03/08/2015.
 */
@RestController
@RequestMapping("/api/xml")
public class XmlController {

    @Autowired
    public OvrUpdateXmlTools ovrUpdateXmlTools;


    @RequestMapping(
            value="/ovr",
            method = RequestMethod.GET,
            produces = "text/xml"
    )
    public String ovr(
            OvrSearchParameters parameters
    ) {
        return ovrUpdateXmlTools.createCdfString(parameters);
    }
}
