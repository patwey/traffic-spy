require './test/test_helper'

class DataSanitizerTest < Minitest::Test
  def test_format_payload_changes_camelCase_keys_to_snake_case
    data = {"payload"=>"{\"url\":\"http://jumpstartlab.com/blog\",\"requestedAt\":\"2013-02-16 21:38:28 -0700\",\"respondedIn\":37,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],\"eventName\": \"socialLogin\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}",
            "splat"=>[],
            "captures"=>["jumpstartlab"],
            "id"=>"jumpstartlab"}

    formatted_payload = TrafficSpy::DataSanitizer.format_payload(data)
    expected_keys = [:url, :requested_at, :responded_in,
                     :referred_by, :request_type, :event_name, :user_agent,
                     :resolution_width, :resolution_height].sort

    assert_equal expected_keys, formatted_payload.keys.sort
  end

  def test_format_payload_sets_nonexistant_keys_to_nil
    data = {"payload"=>"{\"url\":\"http://jumpstartlab.com/blog\"}",
            "splat"=>[],
            "captures"=>["jumpstartlab"],
            "id"=>"jumpstartlab"}

    formatted_payload = TrafficSpy::DataSanitizer.format_payload(data)
    expected_keys = [:url, :requested_at, :responded_in,
                     :referred_by, :request_type, :event_name, :user_agent,
                     :resolution_width, :resolution_height].sort

    assert_equal expected_keys, formatted_payload.keys.sort
    assert_nil formatted_payload[:requested_at]
    assert_nil formatted_payload[:responded_in]
    assert_nil formatted_payload[:referred_by]
    assert_nil formatted_payload[:request_type]
    assert_nil formatted_payload[:event_name]
    assert_nil formatted_payload[:user_agent]
    assert_nil formatted_payload[:resolution_width]
    assert_nil formatted_payload[:resolution_height]
  end

  def test_parse_json_payload_parses_json_payloads
    payload = "{\"url\":\"http://jumpstartlab.com/blog\",\"requestedAt\":\"2013-02-16 21:38:28 -0700\",\"respondedIn\":37,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],\"eventName\": \"socialLogin\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}"
    parsed_json = TrafficSpy::DataSanitizer.parse_json(payload)
    expected_result = {"url"=>"http://jumpstartlab.com/blog",
                       "requestedAt"=>"2013-02-16 21:38:28 -0700",
                       "respondedIn"=>37,
                       "referredBy"=>"http://jumpstartlab.com",
                       "requestType"=>"GET",
                       "parameters"=>[],
                       "eventName"=>"socialLogin",
                       "userAgent"=>"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
                       "resolutionWidth"=>"1920",
                       "resolutionHeight"=>"1280",
                       "ip"=>"63.29.38.211"}

    assert_equal expected_result, parsed_json
  end

  def test_format_source_changes_camelCase_keys_to_snake_case
    data = {"identifier"=>"jumpstartlab", "rootUrl"=>"http://jumpstartlab.com"}
    formatted_source = TrafficSpy::DataSanitizer.format_source(data)
    expected_keys = [:root_url, :identifier].sort

    assert_equal expected_keys, formatted_source.keys.sort
  end

  def test_format_source_sets_nonexistant_keys_to_nil
    data = {"rootUrl" => "http://jumpstartlab"}
    formatted_source = TrafficSpy::DataSanitizer.format_source(data)
    expected_keys = [:root_url, :identifier].sort

    assert_equal expected_keys, formatted_source.keys.sort
    assert_nil formatted_source[:identifier]
  end

  def test_parse_json_returns_error_for_non_json_payloads
    payload = "THISISNTJSON"
    error = TrafficSpy::DataSanitizer.parse_json(payload)
    assert_equal "#{payload} is not JSON", error
  end
end
