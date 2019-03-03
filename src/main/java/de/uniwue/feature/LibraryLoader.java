package de.uniwue.feature;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

/**
 * Class to load shared libraries
 */
public class LibraryLoader implements ServletContextListener {
    @Override
    public void contextDestroyed(ServletContextEvent arg0) { }

    @Override
    public void contextInitialized(ServletContextEvent arg0) {
    	if(!OpenCVStatus.isLoaded()) {
			// Load OpenCV library
			nu.pattern.OpenCV.loadShared();
    	}
		System.loadLibrary(org.opencv.core.Core.NATIVE_LIBRARY_NAME);
    }
}
