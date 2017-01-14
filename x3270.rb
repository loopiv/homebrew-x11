class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "http://x3270.bgp.nu/"
  url "https://downloads.sourceforge.net/project/x3270/x3270/3.5ga9/suite3270-3.5ga9-src.tgz"
  sha256 "654756cc1204fd69a861d416d350a0ab3c9cea317173a80b06aca0402a517d3e"

  bottle do
    sha256 "0524236c08b34e81d241b531ac24780f57c4e796a6c5962bf517ed594e65b8e8" => :sierra
    sha256 "a474a22981d9e034efcc4d61ba0dab211d04d3836148b2f1ac62215a3b992029" => :el_capitan
    sha256 "a19fd8b05ef699fb3bd63a1cd0480fac9b9fd48a638433e1a5ed3dc1ea5c3ba8" => :yosemite
  end

  option "with-c3270", "Include c3270 (curses-based version)"
  option "with-s3270", "Include s3270 (displayless version)"
  option "with-tcl3270", "Include tcl3270 (integrated with Tcl)"
  option "with-pr3287", "Include pr3287 (printer emulation)"

  depends_on :x11
  depends_on "openssl"

  def install
    args = ["--prefix=#{prefix}"]
    args << "--enable-x3270"
    args << "--enable-c3270" if build.with? "c3270"
    args << "--enable-s3270" if build.with? "s3270"
    args << "--enable-tcl3270" if build.with? "tcl3270"
    args << "--enable-pr3287" if build.with? "pr3287"

    system "./configure", *args
    system "make", "install"
    system "make", "install.man"
  end

  test do
    system bin/"x3270", "--version"
  end
end
