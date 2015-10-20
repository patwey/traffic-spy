require './test/test_helper'

class RegisterAppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    TrafficSpy::Server
  end

  def test_cannot_register_app_without_identifier
    total = App.count
    post '/sources', {app: {root_url: 'http://jumpstartlab.com'}}

    assert_equal total, App.count
    assert_equal 400, last_response.status
    assert_equal "Identifier can't be blank", last_response.body
  end
end
