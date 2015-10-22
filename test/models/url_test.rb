require './test/test_helper'
class UrlTest < Minitest::Test
  include Rack::Test::Methods

    def test_it_has_a_url
      url = TrafficSpy::Url.new({url: "http://turing.io/blog"})

      assert_equal "http://turing.io/blog", url.url
    end
end
