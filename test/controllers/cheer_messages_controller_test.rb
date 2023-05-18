require 'test_helper'

class CheerMessagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get cheer_messages_index_url
    assert_response :success
  end

end
