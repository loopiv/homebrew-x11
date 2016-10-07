class Freeglut < Formula
  homepage "http://freeglut.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/freeglut/freeglut/3.0.0/freeglut-3.0.0.tar.gz"
  sha256 "2a43be8515b01ea82bcfa17d29ae0d40bd128342f0930cd1f375f1ff999f76a2"

  bottle do
    cellar :any
    sha256 "f974f6a640c0bbe0022b2658645377bbd82e0a1c5c7c6cfc5734defd0df16d39" => :sierra
    sha256 "1ac12fa3ec33908392230016b32e9741a584d81cbaf191cfe41cc9979177cd9b" => :el_capitan
    sha256 "1f656946c3b2cc6d1748c32895c1259fbf0659959c9c9ebbdc37bc67edbf42e6" => :yosemite
  end

  depends_on :x11
  depends_on "cmake"

  patch :DATA

  def install

    system "cmake", "-D", "FREEGLUT_BUILD_DEMOS:BOOL=OFF", "-D", "CMAKE_INSTALL_PREFIX:PATH=#{prefix}", "."
    system "make", "all"
    system "make", "install"
  end
end

__END__

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 28f8651..d1f6a86 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -220,6 +220,16 @@
 IF(FREEGLUT_GLES)
   ADD_DEFINITIONS(-DFREEGLUT_GLES)
   LIST(APPEND LIBS GLESv2 GLESv1_CM EGL)
+ELSEIF(APPLE)
+  # on OSX FindOpenGL uses framework version of OpenGL, but we need X11 version
+  FIND_PATH(GLX_INCLUDE_DIR GL/glx.h
+            PATHS /opt/X11/include /usr/X11/include /usr/X11R6/include)
+  FIND_LIBRARY(OPENGL_gl_LIBRARY GL
+               PATHS /opt/X11/lib /usr/X11/lib /usr/X11R6/lib)
+  FIND_LIBRARY(OPENGL_glu_LIBRARY GLU
+               PATHS /opt/X11/lib /usr/X11/lib /usr/X11R6/lib)
+  LIST(APPEND LIBS ${OPENGL_gl_LIBRARY})
+  INCLUDE_DIRECTORIES(${GLX_INCLUDE_DIR})
 ELSE()
   FIND_PACKAGE(OpenGL REQUIRED)
   LIST(APPEND LIBS ${OPENGL_gl_LIBRARY})
