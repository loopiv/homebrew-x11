class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "http://x3270.bgp.nu/"
  url "https://downloads.sourceforge.net/project/x3270/x3270/3.5ga8/suite3270-3.5ga8-src.tgz"
  sha256 "04d98c2644d8acc3b0089f85558074623500bc194c41609298b344b6e5d905d2"

  bottle do
    revision 1
    sha256 "5eaad4ec8a9e051b1405269df45549f80e816547942054d2aef522f31be142d6" => :el_capitan
    sha256 "e91dfca1372a1dd68ce2b07ad4b704b7ca8500f9b0ddc6dd3fda37cd5e5f9841" => :yosemite
    sha256 "011a3d085f445d87ce91994b24681bdf4b48a868efdbc343b087bd7bad492cca" => :mavericks
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
