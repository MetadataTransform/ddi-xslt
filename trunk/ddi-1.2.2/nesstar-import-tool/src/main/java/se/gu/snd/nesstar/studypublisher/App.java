package se.gu.snd.nesstar.studypublisher;

import java.io.File;
import java.net.URI;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import org.apache.log4j.Level;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;

public final class App {

    /*
     * Publishes a study to a Nesstar Server in one or more languages.
     * 
     * Command line parameters:
     * 
     * args[0]   = URI of the Nesstar server, e.g. "http://127.0.0.1:8080"
     * args[1]   = User name to login to Nesstar server with.
     * args[2]   = Password for user.
     * args[3..] = One or more DDI files to publish as a study. Use multiple DDI
     *             files to publish a study in multiple languages. If multiple
     *             DDI files are specified, the language of the first one is
     *             used as the default fallback language.
     */
    public static void main(String[] args) {
        disableLog4J();

        Configuration conf = null;
        try {
            conf = getConfiguration(args);
        } catch (ArgumentException ex) {
            exitWithErrorMessage("Invalid server URI, user name or password.");
        }

        Collection<File> ddiFiles = getDdiFiles(args);
        if (ddiFiles.isEmpty()) {
            exitWithErrorMessage("No DDI files specified.");
        }

        try {
            NesstarStudyPublisher publisher = new NesstarStudyPublisher(conf);
            publisher.publish(getDdiFiles(args));
        } catch (Exception ioe) {
            exitWithErrorMessage(ioe.toString());
        }
    }

    private static void exitWithErrorMessage(String message) {
        System.err.println("Error: " + message);
        System.exit(1);
    }

    private static Configuration getConfiguration(String[] args)
            throws ArgumentException {

        Configuration conf = new Configuration();
        try {
            conf.setServerUri(new URI(args[0]));
            conf.setUserName(args[1]);
            conf.setPassword(args[2]);

        } catch (Exception ex) {
            throw new ArgumentException();
        }

        return conf;
    }

    private static Collection<File> getDdiFiles(String[] args) {
        Collection<File> result = new ArrayList<File>();

        for (int i = 3; i < args.length; i++) {
            result.add(new File(args[i]));
        }

        return result;
    }

    // Disables all output from Log4J to prevent "noise" from ending up on
    // the console
    private static void disableLog4J() {
        List<Logger> loggers = Collections.<Logger>list(LogManager.getCurrentLoggers());
        loggers.add(LogManager.getRootLogger());
        for (Logger logger : loggers) {
            logger.setLevel(Level.OFF);
        }
    }
}
