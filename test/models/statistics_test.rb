require './test/test_helper'

class StatisticsTest < Minitest::Test
  def test_get_ranked_browsers_returns_nested_array_of_browsers_and_their_count
    user_agent_strings = ["mozilla/5.0 (macintosh; intel mac os x 10_8_2) applewebkit/537.17 (khtml, like gecko) chrome/24.0.1309.0 safari/537.17",
                          "mozilla/5.0 (macintosh; intel mac os x 10_8_2) applewebkit/537.17 (khtml, like gecko) chrome/24.0.1309.0 safari/537.17",
                          "mozilla/5.0 (macintosh; intel mac os x 10_8_2) applewebkit/537.17 (khtml, like gecko) chrome/24.0.1309.0 safari/537.17"]
    user_agents = user_agent_strings.map { |string| UserAgent.parse(string) }
    browsers = TrafficSpy::Statistics.get_ranked_browsers(user_agents)

    assert_equal [["Safari", 3]], browsers
  end

  def test_get_ranked_op_systems_returns_nested_array_of_systems_and_their_count
    user_agent_strings = ["mozilla/5.0 (macintosh; intel mac os x 10_8_2) applewebkit/537.17 (khtml, like gecko) chrome/24.0.1309.0 safari/537.17",
                          "mozilla/5.0 (macintosh; intel mac os x 10_8_2) applewebkit/537.17 (khtml, like gecko) chrome/24.0.1309.0 safari/537.17",
                          "mozilla/5.0 (macintosh; intel mac os x 10_8_2) applewebkit/537.17 (khtml, like gecko) chrome/24.0.1309.0 safari/537.17"]
    user_agents = user_agent_strings.map { |string| UserAgent.parse(string) }
    op_systems = TrafficSpy::Statistics.get_ranked_op_systems(user_agents)

    assert_equal [["intel mac os x 10_8_2", 3]], op_systems
  end

  def test_parse_user_agents_returns_array_of_browsers_and_op_systems
    create_source
    payloads = []
    payloads << create_payload({url: "jumpstartlab.com/blog"})
    payloads << create_payload({url: "jumpstartlab.com/home"})

    user_agent_stats = TrafficSpy::Statistics.parse_user_agents(payloads)

    assert_equal [[["Safari", 2]], [["intel mac os x 10_8_2", 2]]], user_agent_stats
  end

  def test_get_ranked_urls_returns_nested_array_of_urls_and_their_count
    create_source
    payloads = []
    payloads << create_payload({url: "jumpstartlab.com/blog"})
    payloads << create_payload({url: "jumpstartlab.com/home"})
    payloads << create_payload({url: "jumpstartlab.com/home"})

    ranked_url_stats = TrafficSpy::Statistics.get_ranked_urls(payloads)

    assert_equal [["jumpstartlab.com/home", 2], ["jumpstartlab.com/blog", 1]], ranked_url_stats
  end

  def test_order_collection_returns_nested_arrays_of_elements_and_their_count
    collection = ['duck', 'duck', 'goose']
    ordered = TrafficSpy::Statistics.order_collection(collection)

    assert_equal [['duck', 2], ['goose', 1]], ordered
  end

  def test_application_details_returns_hash_of_relevant_data
    create_source
    payloads = []
    payloads << create_payload
    payloads << create_payload
    payloads << create_payload

    expected = {:urls=>[["http://jumpstartlab.com/blog", 3]], :browsers=>[["Safari", 3]], :op_systems=>[["intel mac os x 10_8_2", 3]]}

    assert_equal expected, TrafficSpy::Statistics.application_details(payloads)
  end

  def test_get_ranked_resolution_returns_nested_array_of_resolutions_and_count
    create_source
    payloads = []
    payloads << create_payload({resolution_height: 10,
                                resolution_width: 10 })
    payloads << create_payload({resolution_height: 10,
                                                            resolution_width: 10 })
    payloads << create_payload({url: "jumpstartlab.com/home"})
    payloads << create_payload({url: "jumpstartlab.com/home"})

    ranked_resolutions = TrafficSpy::Statistics.get_ranked_resolutions(payloads)

    assert_equal [], ranked_resolutions
  end

end