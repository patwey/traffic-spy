require './test/test_helper'
class SourceTest < Minitest::Test
  def test_source_attributes_are_stored
    total = TrafficSpy::Source.all.count
    source = TrafficSpy::Source.new({root_url: "http://turing.io",
                                    identifier: "turing"})

    assert_equal "http://turing.io", source.root_url
    assert_equal "turing", source.identifier
  end
end
