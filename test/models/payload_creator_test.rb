require './test/test_helper'

class PayloadCreatorTest < Minitest::Test
  include Rack::Test::Methods

  def app
    TrafficSpy::Server
  end

  def setup
    TrafficSpy::SourceCreator.process({"rootUrl" => "http://jumpstartlab.com",
                                       "identifier" => 'jumpstartlab'})
  end

  def test_process_returns_a_400_status_and_error_if_payload_is_missing
    params = {"payload"=>"", "splat"=>[], "captures"=>["jumpstartlab"], "id"=>"jumpstartlab"}
    status, body = TrafficSpy::PayloadCreator.process(params, params['id'])

    assert_equal 400, status
    assert_equal 'Missing Payload', body

    params = {"splat"=>[], "captures"=>["jumpstartlab"], "id"=>"jumpstartlab"}
    status, body = TrafficSpy::PayloadCreator.process(params, params['id'])

    assert_equal 400, status
    assert_equal 'Missing Payload', body
  end

  def test_process_returns_a_403_status_and_error_if_payload_has_already_been_received
    total = TrafficSpy::Payload.all.count
    params = {"payload"=>"{\"url\":\"http://jumpstartlab.com/blog\",\"requestedAt\":\"2013-02-16 21:38:28 -0700\",\"respondedIn\":37,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],\"eventName\": \"socialLogin\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}",
              "splat"=>[],
              "captures"=>["jumpstartlab"],
              "id"=>"jumpstartlab"}
    TrafficSpy::PayloadCreator.process(params, params['id'])
    assert_equal (total + 1), TrafficSpy::Payload.all.count

    params = {"payload"=>"{\"url\":\"http://jumpstartlab.com/blog\",\"requestedAt\":\"2013-02-16 21:38:28 -0700\",\"respondedIn\":37,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],\"eventName\": \"socialLogin\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}",
              "splat"=>[],
              "captures"=>["jumpstartlab"],
              "id"=>"jumpstartlab"}
    status, body = TrafficSpy::PayloadCreator.process(params, params['id'])

    assert_equal (total + 1), TrafficSpy::Payload.all.count
    assert_equal 403, status
    assert_equal 'Already Received Request', body
  end

  def test_process_returns_a_403_status_and_error_if_source_for_id_doesnt_exist
    params = {"payload"=>"{\"url\":\"http://jumpstartlab.com/blog\",\"requestedAt\":\"2013-02-16 21:38:28 -0700\",\"respondedIn\":37,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],\"eventName\": \"socialLogin\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}",
              "splat"=>[],
              "captures"=>["jumpstartlab"],
              "id"=>"THISIDENTIFIERDOESNTEXIST"}
    status, body = TrafficSpy::PayloadCreator.process(params, params['id'])

    assert_equal 403, status
    assert_equal 'Application Not Registered', body
  end

  def test_process_returns_a_200_status_and_creates_payload_for_valid_request
    total = TrafficSpy::Payload.all.count
    params = {"payload"=>"{\"url\":\"http://jumpstartlab.com/blog\",\"requestedAt\":\"2013-02-16 21:38:28 -0700\",\"respondedIn\":37,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],\"eventName\": \"socialLogin\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}",
              "splat"=>[],
              "captures"=>["jumpstartlab"],
              "id"=>"jumpstartlab"}
    status, body = TrafficSpy::PayloadCreator.process(params, params['id'])

    assert_equal (total + 1), TrafficSpy::Payload.all.count
    assert_equal 200, status
    assert_equal 'Payload Created', body
  end
end
