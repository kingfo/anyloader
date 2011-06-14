FLUORIDA_ROOT = File.join(File.dirname(__FILE__), '..')
REPORT_DIR = File.join(FLUORIDA_ROOT, 'report')
STATUS_FILE = File.join(REPORT_DIR, 'status')

#BROWSER = '/cygdrive/c/Program\ Files/Internet\ Explorer/IEXPLORE.EXE'
BROWSER = '/Applications/Firefox.app/Contents/MacOS/firefox'

task :fluorida do
  browser_cmd = "#{BROWSER} http://localhost:3000/fluorida/open?suite=default.fls"
  execute 'mongrel_rails start -d'
  
  begin
    mkdir_p REPORT_DIR
    File.open(STATUS_FILE, 'w'){|f| f.write 'testing'}
    browser = Thread.new{ execute browser_cmd } 
  
    while((status = File.open(STATUS_FILE){|f| f.read}) == 'testing') do
      sleep 1
    end
  
    browser.exit
  ensure
    execute 'mongrel_rails stop'
  end
  
  raise "Fluorida test failed!" unless status == 'successful'
end

def execute(cmd)
  puts cmd
  raise 'Execution error!' unless system cmd
end