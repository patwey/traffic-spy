require './test/test_helper'
class RequestTypeTest < Minitest::Test
  include Rack::Test::Methods

    def test_it_has_a_request_type
      request_type = TrafficSpy::RequestType.new({request_type: "GET"})

      assert_equal "GET", request_type.request_type
    end
end
