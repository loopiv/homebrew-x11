class Sxiv < Formula
  desc "Simple X Image Viewer"
  homepage "https://github.com/muennich/sxiv"
  url "https://github.com/muennich/sxiv/archive/v1.3.2.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/s/sxiv/sxiv_1.3.2.orig.tar.gz"
  sha256 "9f5368de8f0f57e78ebe02cb531a31107a993f2769cec51bcc8d70f5c668b653"

  head "https://github.com/muennich/sxiv.git"

  bottle do
    cellar :any
    revision 1
    sha256 "8f26e720d8bb1583828210fd5aad7907c65dea733177d6b3ca4b041d41c13a98" => :el_capitan
    sha256 "65ea6058d7970bd8fbef2bad4f4f6809f83b204e34fbc0f082916707b9986a2d" => :yosemite
    sha256 "cc7d4b3fa3d11a85aa95e4ff52fa46a0dc05d441d0da3dc3b0489114cc749532" => :mavericks
  end

  depends_on :x11
  depends_on "imlib2"
  depends_on "giflib"
  depends_on "libexif"

  def install
    system "make", "config.h"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/sxiv", "-v"
  end
end
