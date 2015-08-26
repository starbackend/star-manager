package star.manager;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.google.common.base.Throwables;
import com.google.common.collect.Maps;
import eu.europa.emsa.schemas.cdf.v_1_0.projectovr.ProjectOvrRootType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Import;
import org.springframework.util.StreamUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import star.connect.imdate.format.format.AtlanticFormat;
import star.connect.imdate.format.format.DefaultFormatResult;

import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.JAXBElement;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * Created by pappmar on 03/08/2015.
 */
@RestController
@RequestMapping("/api")
@Import({
        AtlanticFormat.class
})
public class ProjectsOvrController {

    @Autowired
    AtlanticFormat atlanticFormat;

    @Autowired
    StarManagerConfigService configService;

    @RequestMapping("/projectsOvr/formats")
    public Collection<ProjectsOvrFormat> formats() {
        return formatMap.values();
    }

    int idSequence = 0;

    @RequestMapping(value="/projectsOvr/uploads", method = RequestMethod.GET)
    public Collection<UploadedFile> listUploads() {
        return uploadMap.values();
    }

    @RequestMapping(value="/projectsOvr/uploads", method = RequestMethod.POST)
    public UploadedFile upload(
            @RequestParam("format") String format,
            @RequestParam("data") MultipartFile file,
            @RequestParam("parameters") String parametersJson
    ) {
        UploadedFile uploadedFile = formatMap.get(format).process(file, parametersJson);

        uploadedFile.format = format;

        uploadMap.put(uploadedFile.id, uploadedFile);

        return uploadedFile;
    }


    @RequestMapping(value="/projectsOvr/uploads/{uploadId}", method = RequestMethod.DELETE)
    public String delete(
            @PathVariable("uploadId") int uploadId
    ) {
        uploadMap.remove(uploadId);

        return "\"OK\"";
    }

    @RequestMapping(value="/projectsOvr/uploads/{uploadId}", method = RequestMethod.POST)
    public String send(
            @PathVariable("uploadId") int uploadId,
            @RequestParam("environment") String environment
    ) {
        configService.getEnvironment(environment).getBeans().projectsOvrService.populateProjectOvr(uploadMap.get(uploadId).cdf);

        return "\"OK\"";
    }

    @RequestMapping(
            value="/projectsOvr/uploads/source",
            method = RequestMethod.GET,
            produces = "text/plain"
    )
    public void source(
            @RequestParam("uploadId") int uploadId,
            HttpServletResponse response
    ) throws IOException {
        StreamUtils.copy(new FileInputStream(uploadMap.get(uploadId).tmpFile), response.getOutputStream());
    }


    @RequestMapping(value="/projectsOvr/uploads/{uploadId}/errors", method = RequestMethod.GET)
    public List<DefaultFormatResult.Error> errors(
            @PathVariable("uploadId") int uploadId
    ) {
        return uploadMap.get(uploadId).errors;
    }

    @JsonAutoDetect(fieldVisibility = JsonAutoDetect.Visibility.ANY)
    public abstract class ProjectsOvrFormat {
        public String name;
        public String[] projects;

        public ProjectsOvrFormat(String name, String... projects) {
            this.name = name;
            this.projects = projects;

            formatMap.put(name, this);
        }

        abstract UploadedFile process(MultipartFile file, String parametersJson);
    }

    private final Map<String, ProjectsOvrFormat> formatMap = Maps.newHashMap();
    private final Map<Integer, UploadedFile> uploadMap = Maps.newHashMap();

    {
        new ProjectsOvrFormat("atlantic_csv", "ATLANTIC") {

            @Override
            UploadedFile process(MultipartFile file, String parametersJson) {
                DefaultFormatResult errors = new DefaultFormatResult();
                try {
                    JAXBElement<ProjectOvrRootType> cdf = atlanticFormat.processCSV(file.getInputStream(), "ATLANTIC", errors);

                    return new UploadedFile(file, errors.errors, "csv", cdf);
                } catch (IOException e) {
                    throw Throwables.propagate(e);
                }


            }
        };
        new ProjectsOvrFormat("mediterranean_csv", "MEDITERRANEAN") {

            @Override
            UploadedFile process(MultipartFile file, String parametersJson) {
                DefaultFormatResult errors = new DefaultFormatResult();
                try {
                    JAXBElement<ProjectOvrRootType> cdf = atlanticFormat.processCSV(file.getInputStream(), "MEDITERRANEAN", errors);

                    return new UploadedFile(file, errors.errors, "csv", cdf);
                } catch (IOException e) {
                    throw Throwables.propagate(e);
                }


            }
        };

    }

    @JsonAutoDetect(fieldVisibility = JsonAutoDetect.Visibility.ANY)
    class UploadedFile {

        int id = idSequence++;

        Date creationTime = new Date();

        @JsonIgnore
        final MultipartFile file;

        @JsonIgnore
        final File tmpFile;

        @JsonIgnore
        final List<DefaultFormatResult.Error> errors;

        public String format;

        final public String fileFormat;

        public int getErrorCount() {
            return errors.size();
        }

        @JsonIgnore
        final JAXBElement<ProjectOvrRootType> cdf;

        UploadedFile(MultipartFile file, List<DefaultFormatResult.Error> errors, String fileFormat, JAXBElement<ProjectOvrRootType> cdf) {
            this.errors = errors;
            this.fileFormat = fileFormat;
            this.cdf = cdf;
            try {
                tmpFile = File.createTempFile("star-manager-projectOvr", file.getOriginalFilename());
                tmpFile.deleteOnExit();
                file.transferTo(tmpFile);
            } catch (IOException e) {
                throw Throwables.propagate(e);
            }
            this.file = file;
        }

        public String getFileName() {
            return file.getOriginalFilename();
        }

        public long getFileSize() {
            return tmpFile.length();
        }
    }


}
