class Rdesktop < Formula
  homepage "http://www.rdesktop.org/"
  url "https://github.com/rdesktop/rdesktop/releases/download/v1.8.3/rdesktop-1.8.3.tar.gz"
  sha256 "43896afa6cde099fc1c2609eae1b0fa0997897888daed16e5b992c8878dd3b4f"

  depends_on "openssl"
  depends_on :x11

  # Note: The patch below is meant to remove the reference to the
  # undefined symbol SCARD_CTL_CODE. Since we are compiling with
  # --disable-smartcard, we don't need it anyway (and it should
  # probably have been #ifdefed in the original code).
  # upstream bug report: https://sourceforge.net/p/rdesktop/bugs/352/
  patch :DATA

  def install
    args = ["--prefix=#{prefix}",
            "--disable-credssp",
            "--with-openssl=#{Formula["openssl"].opt_prefix}",
            "--x-includes=#{MacOS::X11.include}",
            "--x-libraries=#{MacOS::X11.lib}"]
    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rdesktop -help 2>&1", 64)
  end
end

__END__
diff --git a/scard.c b/scard.c
index caa0745..5521ee9 100644
--- a/scard.c
+++ b/scard.c
@@ -2152,7 +2152,6 @@ TS_SCardControl(STREAM in, STREAM out)
	{
		/* Translate to local encoding */
		dwControlCode = (dwControlCode & 0x3ffc) >> 2;
-		dwControlCode = SCARD_CTL_CODE(dwControlCode);
	}
	else
	{
@@ -2198,7 +2197,7 @@ TS_SCardControl(STREAM in, STREAM out)
	}

 #ifdef PCSCLITE_VERSION_NUMBER
-	if (dwControlCode == SCARD_CTL_CODE(3400))
+	if (0)
	{
		int i;
		SERVER_DWORD cc;
