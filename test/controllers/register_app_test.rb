require './test/test_helper'

class RegisterAppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Server
  end

  def test_cannot_register_app_without_identifier
    skip
  end
end
