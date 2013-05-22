package se.gu.snd.nesstar.studypublisher;

import java.io.IOException;

import com.nesstar.api.NesstarDB;
import com.nesstar.api.NesstarDBFactory;
import com.nesstar.api.NotAuthorizedException;
import com.nesstar.api.Server;
import com.nesstar.api.publishing.PublishingException;
import com.nesstar.api.publishing.StudyPublishingBuilder;
import java.io.File;
import java.io.FileInputStream;
import java.util.Collection;

public final class NesstarStudyPublisher {

    private final NesstarDB nesstarDB;
    private final Server server;

    public NesstarStudyPublisher(Configuration conf) throws IOException {
        nesstarDB = NesstarDBFactory.getInstance();
        server = nesstarDB.getServer(conf.getServerUri());
        server.login(conf.getUserName(), conf.getPassword());
    }   

    public void publish(Collection<File> ddiFiles) throws IOException,
            PublishingException, NotAuthorizedException {
        StudyPublishingBuilder builder = new StudyPublishingBuilder();
       
        for (File f : ddiFiles) {
            builder.addDDI(new FileInputStream(f));
        }
        
        server.publishStudy(builder);
    }
}