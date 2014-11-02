require "formula"

class Analysistop < Formula
  homepage ""
  url "http://atlas-computing.web.cern.ch/atlas-computing/links/kitsDirectory/ASG/slc6/AnalysisTop_2.0.15_x86_64-slc6-gcc47-opt.tgz"
  version '2.0.15'
  sha1 "31962618e3060c598eeb0dc34c3d524058905b6d"

  depends_on :x11
  depends_on "root6"
  depends_on "cmake" => :build

  def install
    out = File.new('compile.sh', 'w')
    
    out.puts "mv #{version}/* #{prefix}/"
    out.puts "cd #{prefix}"
    
    out.puts "source `root-config --prefix`/libexec/thisroot.sh"

    #We don't want Asg_root since that takes root from cvmfs
    #We don't want Asg_gccxml since we're using root6
    #Asg_BAT has some scary root6 issue so remove that and KLFitter (which needs BAT) for now 
    #OxbridgeKinetics failed too
    out.puts "rm -rf Asg_root Asg_gccxml Asg_BAT KLFitter Oxbridgekinetics"
    out.puts "cd RootCore"
    out.puts "rm load_packages* packages rootcore_config"
    out.puts "cd .."
    
    out.puts "source RootCore/scripts/setup.sh"
    out.puts "rc clean"
    out.puts "rc find_packages"
    out.puts "rc compile"
    out.close()
    
    system "chmod +x compile.sh"
    #system "cat compile.sh"
    system "./compile.sh"
    
    out = File.new("#{prefix}/setup.sh", 'w')
    out.puts "source `root-config --prefix`/libexec/thisroot.sh"
    out.puts "source RootCore/scripts/setup.sh"
    out.close()
  end

  test do
    system "true"
  end
  
  def caveats; <<-EOS.undent
	You have installed to #{prefix}
	e.g. 
	cd #{prefix}
	source RootCore/scripts/setup.sh
    EOS
  end

end
