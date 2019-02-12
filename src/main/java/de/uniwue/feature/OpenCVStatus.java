package de.uniwue.feature;

import java.util.Vector;

/**
 * Helper to check if OpenCV library is loaded
 */
public class OpenCVStatus {

	/**
	 * Check if OpenCV has been loaded.
	 * 
	 * @return true if in library path else false
	 */
	@SuppressWarnings("unchecked")
	public static boolean isLoaded() {
		try {
			final java.lang.reflect.Field LIBRARIES;
			Vector<String> libraries;
			LIBRARIES = ClassLoader.class.getDeclaredField("loadedLibraryNames");
			LIBRARIES.setAccessible(true);
			libraries = (Vector<String>) LIBRARIES.get(ClassLoader.getSystemClassLoader());
			for (String libpath : libraries.toArray(new String[] {}))
				if (libpath.contains(org.opencv.core.Core.NATIVE_LIBRARY_NAME))
					return true;
		} catch (NoSuchFieldException | SecurityException | IllegalArgumentException | IllegalAccessException e) {
			e.printStackTrace();
			return false;
		}
		return false;
	}
}
