require 'application'

class FluoridaController < ApplicationController
  skip_before_filter :verify_authenticity_token
  FLUORIDA_ROOT = File.join File.dirname(__FILE__), '..', '..'
  REPORT_DIR = File.join FLUORIDA_ROOT, 'report'
  
  def report
    status = params[:status]
    data = params[:data]
    FileUtils.mkdir_p REPORT_DIR
    
    report_file = File.join REPORT_DIR, Time.now.to_i.to_s
    File.open(report_file, 'w'){|f| f.write data }
    status_file = File.join REPORT_DIR, 'status'
    File.open(status_file, 'w'){|f| f.write status }
        
    render :text => data
  end

  def open
    @suite_url = params[:suite]
    render :file => File.join(File.dirname(__FILE__), '..', 'views', 'fluorida', 'open.rhtml')
  end
  
  def load_file
    file_path = File.join FLUORIDA_ROOT, params[:filename]
    content = File.open(file_path){|f| f.read}
    render :text => content
  end
end
