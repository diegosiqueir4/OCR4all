package de.uniwue.feature;

import java.util.HashSet;
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
			LIBRARIES = ClassLoader.class.getDeclaredField("loadedLibraryNames");
			LIBRARIES.setAccessible(true);
			Object libraries = LIBRARIES.get(ClassLoader.getSystemClassLoader());

			String[] libraryEntries = null;
			if (libraries instanceof Vector) {
				// libraries is of type Vector in java 9 and below
				libraryEntries = ((Vector<String>) libraries).toArray(new String[] {});
			} else if (libraries instanceof HashSet) {
				// libraries is of type HashMap in java 10 and above
				libraryEntries = ((HashSet<String>) libraries).toArray(new String[] {});
			} else {
				// Unknown object type for ClassLoader "loadedLibraryNames"
				// (Might have been changed in a future java version)
				throw new UnsupportedOperationException("Unkown object type for ClassLoader \"loadedLibraryNames\""
						+ " (Might have been changed in a future java version)");
			}

			for (String libpath : libraryEntries)
				if (libpath.contains(org.opencv.core.Core.NATIVE_LIBRARY_NAME))
					return true;

		} catch (NoSuchFieldException | SecurityException | IllegalArgumentException | IllegalAccessException e) {
			e.printStackTrace();
			return false;
		}
		return false;
	}
}
