class TigerVnc < Formula
  desc "High-performance, platform-neutral implementation of VNC"
  homepage "http://tigervnc.org/"
  url "https://github.com/TigerVNC/tigervnc/archive/v1.7.1.tar.gz"
  sha256 "3c021ec0bee4611020c0bcbab995b0ef2f6f1a46127a52b368827f3275527ccc"

  bottle do
    sha256 "865f30e5f97c8c41973c21b93d4837091efa378f63bbd2bd147b0547e12e89e3" => :sierra
    sha256 "12030bc8adc3c5e28756c534f95d4f50d990754b7a884c5d629f512b3f4bbcd0" => :el_capitan
    sha256 "82acf88f0f74db8815fd122523553b102cef135f4771908ab8ef8801b1cc6c6a" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "gnutls" => :recommended
  depends_on "jpeg-turbo"
  depends_on "gettext"
  depends_on "fltk"
  depends_on :x11

  # reduce thread stack size to avoid crash
  patch do
    url "https://github.com/TigerVNC/tigervnc/commit/1349e42e395a0a88b67447580d526daf31dba591.diff"
    sha256 "e7321146c7ab752279423c9fc0ee1414eed8f1dc81afd2ea963a7f2d115a7a79"
  end

  def install
    turbo = Formula["jpeg-turbo"]
    args = std_cmake_args + %W[
      -DJPEG_INCLUDE_DIR=#{turbo.include}
      -DJPEG_LIBRARY=#{turbo.lib}/libjpeg.dylib
      .
    ]
    system "cmake", *args
    system "make", "install"
  end
end
