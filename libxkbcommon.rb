class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https://xkbcommon.org/"
  url "https://xkbcommon.org/download/libxkbcommon-0.7.1.tar.xz"
  sha256 "ba59305d2e19e47c27ea065c2e0df96ebac6a3c6e97e28ae5620073b6084e68b"

  bottle do
    sha256 "c24733ed10142c51aafa1f3d430b5b7dcf9bc16ab3d7a7b6639462e2e6b815a0" => :sierra
    sha256 "3a004bcd4596b08f1dc0fbc81585f07aacdb04be18b7a2fccbe68e89f417a3a4" => :el_capitan
    sha256 "5a7289cdba5b6a2f7c0556b243ea03acf256fce4d7620d8e4c603c8ed194c6bf" => :yosemite
  end

  head do
    url "https://github.com/xkbcommon/libxkbcommon.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on :x11
  depends_on "bison" => :build
  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh" if build.head?
    inreplace "configure" do |s|
      s.gsub! "-version-script $output_objdir/$libname.ver", ""
      s.gsub! "$wl-version-script", ""
    end
    inreplace %w[Makefile.in Makefile.am] do |s|
      s.gsub! "-Wl,--version-script=${srcdir}/xkbcommon.map", ""
      s.gsub! "-Wl,--version-script=${srcdir}/xkbcommon-x11.map", ""
    end

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
    #include <stdlib.h>
    #include <xkbcommon/xkbcommon.h>
    int main() {
      return (xkb_context_new(XKB_CONTEXT_NO_FLAGS) == NULL)
        ? EXIT_FAILURE
        : EXIT_SUCCESS;
    }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lxkbcommon",
                   "-o", "test"
    system "./test"
  end
end
