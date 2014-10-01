require "formula"

class Analysistop < Formula
  homepage ""
  url "http://atlas-computing.web.cern.ch/atlas-computing/links/kitsDirectory/ASG/slc6/AnalysisTop_2.0.1_x86_64-slc6-gcc47-opt.tgz"
  sha1 "de9c0ff05e77d064d530b864912b13a574cd3c42"

  depends_on :x11
  depends_on "root6"
  depends_on "cmake" => :build

  def install
    out = File.new('compile.sh', 'w')
    out.puts('cd 2.0.1')

    #We don't want Asg_root since that takes root from cvmfs
    #We don't want Asg_gccxml since we're using root6
    #Asg_BAT has some scary root6 issue so remove that and KLFitter (which needs BAT) for now 
    out.puts('rm -rf Asg_root Asg_gccxml Asg_BAT KLFitter')
    out.puts('cd RootCore')
    out.puts('rm load_packages* packages rootcore_config')
    out.puts('cd ..')
    
    out.puts('source RootCore/scripts/setup.sh')
    out.puts('rc clean')
    out.puts('rc find_packages')
    out.puts('rc compile')
    out.close()
    
    system "chmod +x compile.sh"
    system "./compile.sh"
  end

  test do
    system "true"
  end
end
