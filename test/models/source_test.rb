require './test/test_helper'

class SourceTest < Minitest::Test
  include Rack::Test::Methods

  def test_source_attributes_are_stored
    source = TrafficSpy::Source.new({root_url: "http://turing.io",
                                    identifier: "turing"})

    assert_equal "http://turing.io", source.root_url
    assert_equal "turing", source.identifier
  end
end
