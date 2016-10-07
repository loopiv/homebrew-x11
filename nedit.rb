class Nedit < Formula
  desc "fast, compact Motif/X11 plain text editor"
  homepage "http://sourceforge.net/projects/nedit"
  url "https://downloads.sourceforge.net/project/nedit/nedit-source/nedit-5.6a-src.tar.gz"
  sha256 "53677983cb6c91c5da1fcdcac90f7f9a193f08fa13b7a6330bc9ce21f9461eed"

  bottle do
    cellar :any
    sha256 "8a6e4d439a90f3a7aa4728907a1a2f5becc32ad2e92e729a53b9fc286e7f30e8" => :el_capitan
    sha256 "48ad7bff68c36148447844bf15572cec2c14975a1c227486a87a8c28dee19cbd" => :yosemite
    sha256 "589624a13c080f3cbbb8a5af6f22243d1ce3b48270d795cc9da0a2d7c22d1593" => :mavericks
  end

  depends_on "openmotif"
  depends_on :x11

  # Nedit specifically checks the version of openmotif that is running against.
  # Unfortunately this check leaves out the latest versions of openmotif 2.3.4+ (
  # which is what homebrew currently has)
  # see https://sourceforge.net/p/nedit/patches/177/ for the upstream bug report,
  # and patch.
  patch :DATA

  def install
    system "make", "macosx", "MOTIFLINK='-lXm'"
    system "make", "-C", "doc", "man", "doc"

    bin.install "source/nedit"
    bin.install "source/nc" => "ncl"

    man1.install "doc/nedit.man" => "nedit.1x"
    man1.install "doc/nc.man" => "ncl.1x"
    (etc/"X11/app-defaults").install "doc/NEdit.ad" => "NEdit"
    doc.install Dir["doc/*"]
  end

  test do
    system bin/"nedit", "-version"
    system bin/"ncl", "-version"
  end
end
__END__
diff --git a/util/motif.c.old b/util/motif.c
index 1ab3ef8..8d11abc 100644
--- a/util/motif.c.old
+++ b/util/motif.c
@@ -151,7 +151,7 @@ static enum MotifStability GetOpenMotifStability(void)
     {
         result = MotifKnownBad;
     }
-    else if (XmFullVersion >= 200203 && XmFullVersion <= 200303) /* 2.2.3 - 2.3 is good */
+    else if (XmFullVersion >= 200203 && XmFullVersion <= 200306) /* 2.2.3 - 2.3.6 is good */
     {
         result = MotifKnownGood;
     }
