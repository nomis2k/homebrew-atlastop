require "formula"

class Analysistop < Formula
  homepage ""
  url "http://epweb2.ph.bham.ac.uk/user/head/AnalysisTop-2.0.0.tar.gz"
  sha1 "f36057baf2cb67da95888e6a084648393c994511"

  depends_on :x11
  depends_on "root6"

  def install
    system "./configure #{prefix}"
  end

  test do
    system "true"
  end
end
