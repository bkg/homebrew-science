require 'formula'

class Velvet < Formula
  homepage 'http://www.ebi.ac.uk/~zerbino/velvet/'
  url 'http://www.ebi.ac.uk/~zerbino/velvet/velvet_1.2.09.tgz'
  sha1 'e40d59806599ac06e4b13408205b8978427177d0'

  head 'https://github.com/dzerbino/velvet.git'

  def install
    inreplace 'Makefile' do |s|
      # recommended in Makefile for compiling on Mac OS X
      s.change_make_var! "CFLAGS", "-Wall -m64"
    end

    args = ["OPENMP=1", "LONGSEQUENCES=1"]
    if ENV['MAXKMERLENGTH']
      args << ("MAXKMERLENGTH=" + ENV['MAXKMERLENGTH'])
    end

    system "make", "velveth", "velvetg", *args
    bin.install 'velveth', 'velvetg'

    # install additional contributed scripts
    (share/'velvet/contrib').install Dir['contrib/shuffleSequences_fasta/shuffleSequences_*']
  end

  def caveats
    <<-EOS.undent
      If you want to build with a different kmer length, you can set
      MAXKMERLENGTH=X to a value (X) *before* you brew this formula.

      Some additional user contributed scripts are installed here:
      #{share}/velvet/contrib
    EOS
  end

  def test
    system "velveth --help"
    system "velvetg --help"
  end
end
