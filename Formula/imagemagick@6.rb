class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://www.imagemagick.org/"
  # Please always keep the Homebrew mirror as the primary URL as the
  # ImageMagick site removes tarballs regularly which means we get issues
  # unnecessarily and older versions of the formula are broken.
  url "https://dl.bintray.com/homebrew/mirror/imagemagick%406-6.9.11-7.tar.xz"
  mirror "https://www.imagemagick.org/download/releases/ImageMagick-6.9.11-7.tar.xz"
  sha256 "1a9935b78e3430a4a031602838c4b424e6d6e9420058d1448172a3b8ff9995d5"
  head "https://github.com/imagemagick/imagemagick6.git"

  bottle do
    sha256 "65e0a5220f91bd2abc406809e58a8fed0b29efe5ed8ff598c21d540b91dce7ff" => :catalina
    sha256 "0e7ff9b8c703f6b06baa9f5600b288f9305c2ba909a6dbc81f059a74172d8afc" => :mojave
    sha256 "1b73be219102dc76b475f9e2b78074f4a59e9ce22bc8b0037a56a4b6be8494ba" => :high_sierra
    sha256 "6e8a5f07746f7ba7250719a332fe03e8980a5983fb1a5bc2d827b96082659c59" => :x86_64_linux
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build

  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "little-cms2"
  depends_on "openjpeg"
  depends_on "webp"
  depends_on "xz"

  skip_clean :la

  def install
    # Avoid references to shim
    inreplace Dir["**/*-config.in"], "@PKG_CONFIG@", Formula["pkg-config"].opt_bin/"pkg-config"

    args = %W[
      --disable-osx-universal-binary
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-opencl
      --disable-openmp
      --enable-shared
      --enable-static
      --with-freetype=yes
      --with-modules
      --with-webp=yes
      --with-openjp2
      --without-gslib
      --with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts
      --without-fftw
      --without-pango
      --without-x
      --without-wmf
    ]

    # versioned stuff in main tree is pointless for us
    inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_VERSION}", "${PACKAGE_NAME}"
    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "PNG", shell_output("#{bin}/identify #{test_fixtures("test.png")}")
    # Check support for recommended features and delegates.
    features = shell_output("#{bin}/convert -version")
    %w[Modules freetype jpeg png tiff].each do |feature|
      assert_match feature, features
    end
  end
end
