require './test/test_helper'

class ProccesRequestTest < Minitest::Test
  include Rack::Test::Methods

  def app
    TrafficSpy::Server
  end

  def test_cannot_process_if_payload_is_missing
    total = TrafficSpy::Data.count
    TrafficSpy::SourceCreator.process({"rootUrl" => "http://jumpstartlab.com",
                                       "identifier" => 'jumpstartlab'})

    assert_equal 'jumpstartlab', TrafficSpy::Source.all.first.identifier

    post '/sources/jumpstartlab/data', {payload: ""}

    assert_equal total, TrafficSpy::Data.count
    assert_equal 400, last_response.status
    assert_equal "Missing Payload", last_response.body

    post '/sources/jumpstartlab/data', {}

    assert_equal total, TrafficSpy::Data.count
    assert_equal 400, last_response.status
    assert_equal "Missing Payload", last_response.body
  end

  def test_cannot_process_if_identifier_doesnt_exist
    refute TrafficSpy::Source.find_by(identifier: 'jumpstartlab')
    total = TrafficSpy::Data.count

    post '/sources/jumpstartlab/data', {payload: "{\"url\":\"http://jumpstartlab.com/blog\",\"requestedAt\":\"2013-02-16 21:38:28 -0700\",\"respondedIn\":37,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],\"eventName\": \"socialLogin\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}"}

    assert_equal total, TrafficSpy::Data.count
    assert_equal 403, last_response.status
    assert_equal "Application Not Registered", last_response.body
  end

  # post '/sources/jumpstartlab/data', {payload: "{\"url\":\"http://jumpstartlab.com/blog\",\"requestedAt\":\"2013-02-16 21:38:28 -0700\",\"respondedIn\":37,\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],\"eventName\": \"socialLogin\",\"userAgent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17\",\"resolutionWidth\":\"1920\",\"resolutionHeight\":\"1280\",\"ip\":\"63.29.38.211\"}"}
  # check if all necessary payload params exist?
  # error msgs returned in body?
end
