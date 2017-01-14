class Freeglut < Formula
  homepage "http://freeglut.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/freeglut/freeglut/3.0.0/freeglut-3.0.0.tar.gz"
  sha256 "2a43be8515b01ea82bcfa17d29ae0d40bd128342f0930cd1f375f1ff999f76a2"

  bottle do
    cellar :any
    rebuild 1
    sha256 "5bdcc914f3c6c5346602a7d76562e4267711b8e5fc1a99a16b2f3c5f6b3ef563" => :sierra
    sha256 "033126fb74921716a82caececca0182ac607dadf86e7a960780c079c22e8d3c7" => :el_capitan
    sha256 "24a96ad3e703b6d5a345c036313680ed19c72a48a1a0b94fc3809a943b674465" => :yosemite
  end

  depends_on :x11
  depends_on "cmake" => :build

  patch :DATA

  def install

    inreplace "src/x11/fg_main_x11.c", "CLOCK_MONOTONIC", "UNDEFINED_GIBBERISH"
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
