require File.dirname(__FILE__) + '/test_helper'

class FluoridaControllerTest < ActionController::TestCase
  def setup
    @controller = FluoridaController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end
  
  def test_should_save_posted_result
    report_dir = FluoridaController::REPORT_DIR
    FileUtils.rm_rf report_dir
    
    data = "sample report"
    post :report, :data => data
    
    assert File.directory?(report_dir)
    assert_equal data, File.open(Dir[File.join(report_dir, "*")].first){|f| f.read}
  end
  
  def test_should_be_able_to_open_suite
    get :open, :suite => 'test'
    assert_response :success
  end
  
  def test_load_file
    test_file = File.join File.dirname(__FILE__), 'test.file'
    expected_content = File.open(test_file){|f| f.read}
    
    get :load_file, :filename => 'test/test.file'
    assert_equal expected_content, @response.body
  end
end
