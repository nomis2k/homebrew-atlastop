require 'formula'

class Root6 < Formula
  homepage 'http://root.cern.ch'
  url 'ftp://root.cern.ch/root/root_v6.00.02.source.tar.gz'
  version '6.00.02'
  sha1 '5836283ab21446460f5221d4d4179e03e121088e'

  depends_on :x11
  depends_on :python

  def install
    # brew audit doesn't like non-executables in bin
    # so we will move {thisroot,setxrd}.{c,}sh to libexec
    # (and change any references to them)
    inreplace Dir['config/roots.in', 'config/thisroot.*sh',
                  'etc/proof/utils/pq2/setup-pq2',
                  'man/man1/setup-pq2.1', 'README/INSTALL', 'README/README'],
      /bin.thisroot/, 'libexec/thisroot'

    args = %W[
      --prefix=#{prefix}
      --etcdir=#{prefix}/etc/root
      --mandir=#{man}
    ]

    system "./configure", *args
    system "make"
    system "make install"

    # needed to run test suite
    prefix.install 'test'

    libexec.mkpath
    mv Dir["#{bin}/*.*sh"], libexec
  end

  test do
    system "make -C #{prefix}/test/ hsimple"
    system "#{prefix}/test/hsimple"
  end

  def caveats; <<-EOS.undent
    Because ROOT depends on several installation-dependent
    environment variables to function properly, you should
    add the following commands to your shell initialization
    script (.bashrc/.profile/etc.), or call them directly
    before using ROOT.

    For csh/tcsh users:
      source `brew --prefix root6`/libexec/thisroot.csh
    For bash/zsh users:
      . $(brew --prefix root6)/libexec/thisroot.sh
    EOS
  end
end
