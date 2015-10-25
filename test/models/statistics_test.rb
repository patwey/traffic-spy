require './test/test_helper'

class StatisticsTest < Minitest::Test

  def test_parse_user_agents_returns_array_of_browsers_and_op_systems
    create_source
    payloads = []
    payloads << create_payload({url: "jumpstartlab.com/blog"})
    payloads << create_payload({url: "jumpstartlab.com/home"})
    user_agent_stats = TrafficSpy::Statistics.parse_user_agents(TrafficSpy::Source.find_by(identifier: 'jumpstartlab').payloads)

    assert_equal [[["Safari", 2]], [["intel mac os x 10_8_2", 2]]], user_agent_stats
  end

  def test_order_collection_returns_nested_arrays_of_elements_and_their_count
    collection = ['duck', 'duck', 'goose']
    ordered = TrafficSpy::Statistics.order_collection(collection)

    assert_equal [['duck', 2], ['goose', 1]], ordered
  end

  def test_application_details_returns_hash_of_relevant_data
    create_source
    payloads = []
    payloads << create_payload({url: "http://jumpstartlab.com/blog"})
    payloads << create_payload({url: "http://jumpstartlab.com/blog",
                                requested_at: 2})
    payloads << create_payload({url: "http://jumpstartlab.com/blog",
                                requested_at: Time.now})

    expected = {identifier: 'jumpstartlab', urls: [["http://jumpstartlab.com/blog", 3]], browsers: [["Safari", 3]], op_systems: [["intel mac os x 10_8_2", 3]], resolutions: [["1920 x 1280", 3]], response_times: [["http://jumpstartlab.com/blog", 37.0]]}

    assert_equal expected, TrafficSpy::Statistics.application_details(TrafficSpy::Source.all.last.identifier)
  end

  def test_get_ranked_resolution_returns_nested_array_of_resolutions_and_count
    create_source
    payloads = []
    payloads << create_payload({resolution_height: 10,
                                resolution_width: 10 })
    payloads << create_payload({resolution_height: 10,
                                resolution_width: 10 })
    payloads << create_payload({resolution_width: 200,
                                 resolution_height: 1})

    ranked_resolutions = TrafficSpy::Statistics.get_ranked_resolutions(payloads)

    assert_equal [["10 x 10", 2], ['200 x 1', 1]], ranked_resolutions
  end

  def test_url_response_time_returns_nested_array_of_ranked_urls_by_average_response_time
    create_source
    create_payload({url: "jumpstartlab.com/blog", responded_in: 1})
    create_payload({url: "jumpstartlab.com/blog", responded_in: 3})
    create_payload({url: "jumpstartlab.com/home", responded_in: 5})
    create_payload({url: "jumpstartlab.com/home", responded_in: 10})

    ranked_avg_response_times = TrafficSpy::Statistics.get_avg_response_time_by_url(TrafficSpy::Source.find_by(identifier: 'jumpstartlab'))

    assert_equal [["jumpstartlab.com/home", 7.5], ["jumpstartlab.com/blog", 2.0]], ranked_avg_response_times
  end

  def test_url_statistics_returns_hash_given_identifier_and_path
    create_source
    create_payload({url: "http://jumpstartlab.com/tyler"})
    create_payload({url: 'http://jumpstartlab.com/blog', responded_in: 10})
    create_payload({url: 'http://jumpstartlab.com/blog', responded_in: 11})

    locals = TrafficSpy::Statistics.url_statistics('jumpstartlab', 'blog')
    expected_result = {avg_response: 10.5,
                       max_response: 11.0,
                       min_response: 10.0,
                       request_types: ["get"],
                       referred_by: [["http://jumpstartlab.com", 2]],
                       user_agents: [["Safari", 2]]}

    assert_equal expected_result, locals
  end

  def test_application_events_index_returns_hash_given_identifier
    create_source
    create_payload({url: "http://jumpstartlab.com/blog", event_name: "antiSocialLogin"})
    create_payload({url: 'http://jumpstartlab.com/blog', event_name: "socialLogin"})
    create_payload({url: 'http://jumpstartlab.com/blog', event_name: "socialLogin",
                    requested_at: Time.now})

    locals = TrafficSpy::Statistics.application_events_index('jumpstartlab')
    expected_result = {identifier: "jumpstartlab",
                       event_names: [["socialLogin", 2],
                                     ["antiSocialLogin", 1]]}

    assert_equal expected_result, locals
  end

  def test_application_event_details_returns_hash_given_identifier_and_event_name
    create_source
    create_payload({url: "http://jumpstartlab.com/blog", event_name: "antiSocialLogin"})
    create_payload({url: 'http://jumpstartlab.com/blog', event_name: "socialLogin",
                    requested_at: "2015-10-24 12:00:00 -0600"})
    create_payload({url: 'http://jumpstartlab.com/blog', event_name: "socialLogin",
                    requested_at: "2015-10-24 0:00:00 -0600"})

    locals = TrafficSpy::Statistics.application_event_details('jumpstartlab', 'socialLogin')
    expected_result = {events_by_hour: [["12 am", 1], ["12 pm", 1]],
                       total_count: 2}

    assert_equal expected_result, locals
  end

end
