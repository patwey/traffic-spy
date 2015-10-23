require './test/test_helper'

class PayloadRetrieverTest < Minitest::Test

  def test_retrieve_gets_all_payloads_for_a_source_if_it_exists
    create_source
    source_id = TrafficSpy::Source.all.first.id
    identifier = TrafficSpy::Source.all.first.identifier
    create_payload({url: 'http://jumpstartlab.com/index'})
    create_payload({url: 'http://jumpstartlab.com/blog'})
    payloads = TrafficSpy::PayloadRetriever.retrieve(identifier)

    assert_equal source_id, payloads.first.source_id
    assert_equal source_id, payloads.last.source_id

    assert_equal 2, payloads.count
    assert_equal 1, payloads.first.id
    assert_equal 2, payloads.last.id
  end

  def test_retrieve_returns_error_if_source_doesnt_exist
    identifier = "SOURCEDOESNTEXIST"
    create_payload({url: 'http://espn.com/blog'})
    create_payload({url: 'http://jumpstartlab.com/blog'})
    error = TrafficSpy::PayloadRetriever.retrieve(identifier)

    assert_equal "Source doesn't exist", error
  end
end
