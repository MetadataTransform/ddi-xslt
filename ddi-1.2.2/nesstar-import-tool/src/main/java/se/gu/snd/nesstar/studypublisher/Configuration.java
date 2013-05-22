package se.gu.snd.nesstar.studypublisher;

import java.io.File;
import java.net.URI;
import java.util.ArrayList;
import java.util.Collection;

public final class Configuration {

    private URI serverUri;
    private String userName;
    private String password;
    private Collection<File> ddiFiles;

    public Configuration()
    {
        ddiFiles = new ArrayList<File>();
    }
    
    public URI getServerUri() {
        return serverUri;
    }

    public String getUserName() {
        return userName;
    }

    public String getPassword() {
        return password;
    }

    public Collection<File> getDdiFiles() {
        return ddiFiles;
    }

    public void setServerUri(URI serverUri) {
        this.serverUri = serverUri;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void addDdiFile(File ddiFile) {
        ddiFiles.add(ddiFile);
    }
}