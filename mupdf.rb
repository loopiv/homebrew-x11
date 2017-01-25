class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com"
  url "https://mupdf.com/downloads/mupdf-1.10a-source.tar.gz"
  sha256 "aacc1f36b9180f562022ef1ab3439b009369d944364f3cff8a2a898834e3a836"

  bottle do
    cellar :any
    revision 1
    sha256 "78099992df386bf48f24ab6935d6daa52c3dc33a6359cedb8ea8e25fdee307fb" => :el_capitan
    sha256 "d7733d3f510002ec5466440f01e64a34ee9530fb6e3700ed2cbfcb37a50d2597" => :yosemite
    sha256 "9885974afb678510b5c03c9cb2e599776b5c48bccb5abc08f4c245f8737822e0" => :mavericks
  end

  depends_on :macos => :snow_leopard
  depends_on :x11
  depends_on "openssl"

  conflicts_with "mupdf-tools",
    :because => "mupdf and mupdf-tools install the same binaries."

  def install
    system "make", "install",
           "build=release",
           "verbose=yes",
           "CC=#{ENV.cc}",
           "prefix=#{prefix}"
    bin.install_symlink "mutool" => "mudraw"
  end

  test do
    pdf = test_fixtures("test.pdf")
    assert_match /Homebrew test/, shell_output("#{bin}/mudraw -F txt #{pdf}")
  end
end
