require File.dirname(__FILE__)+"/config.rb"  #Include Config File

def banner()
puts "Droid::Hunter"
puts "Code by hawul"
puts "================================="
end

def help()
  puts "Helo"
end
# ==================================================
class App
 def initialize(file)
   @app_file = file
   @app_perm = ""
   @app_feature = ""
   @app_main = ""
   @app_package = "" 
   @app_workspace = ""
 end
 def scan_info()  #Scanning App default information
   IO.popen($p_aapt+" dump badging "+@app_file, 'r') do |pipe|
   pipe.each_line do |line|
     if line.include? "package: name="
       @app_package = line[14..-1]
       @app_package = @app_package[0..@app_package.index(" ")]
       @app_package = @app_package.delete("'")
     else if line.include? "uses-permission:"
       @app_perm += line[16..-1]
       @app_perm = @app_perm.delete("'")
     else if line.include? "launchable-activity: name="
       @app_main = line[26..-1]
       @app_main = @app_main[0..@app_main.index(" ")]
       @app_main = @app_main.delete("'")
     end
     end
     end
   end
   end
   time = Time.new
   @app_workspace = Dir.pwd+"/"+(time.to_i).to_s+"_"+@app_package
   @app_workspace = @app_workspace.strip!
 end
 def make_work() # Mkdir + Apk Decompile + BakSmiling
   time = Time.new
   Dir.mkdir(@app_workspace)
   system("cp "+@app_file+" "+@app_workspace+"/"+(time.to_i).to_s+"_"+@app_package.strip+".apk")
   Dir.chdir(@app_workspace)
   @app_file = Dir.pwd+"/"+(time.to_i).to_s+"_"+@app_package.strip+".apk"
   system($p_unzip+" "+@app_file+" -d "+@app_workspace+"/1_unzip/")  ## Unzip
   system("java -jar "+$p_apktool+" d "+@app_file+" "+@app_workspace+"/2_apktool/")  ## apktool
   system($p_dex2jar+" "+@app_file)  ## dex2jar
   system($p_unzip+" "+@app_workspace+"/"+(time.to_i).to_s+"_"+@app_package.strip+"_dex2jar.jar"+" -d "+@app_workspace+"/3_dex2jar/")  ## Unzip
 end
 def returnFile()
   puts @app_file
   puts @app_package
   puts @app_perm
   puts @app_main
   puts @app_workspace
 end
 def getpackage()
   return @app_package
 end
 def getworkspace()
   return @app_workspace
 end
end
# ==================================================
banner()
if(ARGV.size == 0)
  help()
  exit()
else if(ARGV[0] == "-h" or ARGV[0] == "--help")
  help()
  exit()
else
  i=0
  app = Array.new
  while(i<ARGV.size)
    app.push(App.new(ARGV[0]))
    i+=1
  end
  i=0
  while(i<ARGV.size)
    app[i].scan_info()
    app[i].returnFile()
    app[i].make_work()
    i+=1
  end
end
end









