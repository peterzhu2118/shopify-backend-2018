require 'test_helper'

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  test "get main page should result in 200" do
    get '/'

    assert_response 200
  end
end
