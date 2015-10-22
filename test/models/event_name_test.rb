require './test/test_helper'
class EventNameTest < Minitest::Test
  include Rack::Test::Methods

    def test_it_has_a_event_name
      event_name = TrafficSpy::EventName.new({event_name: "socialLogin"})

      assert_equal "socialLogin", event_name.event_name
    end
end
