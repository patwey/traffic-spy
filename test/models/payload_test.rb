require './test/test_helper'

class PayloadTest < Minitest::Test
  def test_payload_attributes_are_stored
    payload = TrafficSpy::Payload.new({ sha: "2e0fb001e51eab0509f6c480b1be7fb337c99766d1fb0708135751b6f8573bdd",
                                        source_id: 3,
                                        url_id: 1,
                                        requested_at: "2013-02-16 21:38:28 -0700",
                                        responded_in: 37,
                                        referred_by: 'http://jumpstartlab.com',
                                        request_type_id: 2,
                                        event_name_id: 3,
                                        user_agent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17',
                                        resolution_width: "1920",
                                        resolution_height: "1280" })

    assert_equal "2e0fb001e51eab0509f6c480b1be7fb337c99766d1fb0708135751b6f8573bdd", payload.sha
    assert_equal 3, payload.source_id
    assert_equal 1, payload.url_id
    assert_equal "2013-02-16 21:38:28 -0700", payload.requested_at
    assert_equal 37, payload.responded_in
    assert_equal 'http://jumpstartlab.com', payload.referred_by
    assert_equal 2, payload.request_type_id
    assert_equal 3, payload.event_name_id
    assert_equal 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17', payload.user_agent
    assert_equal '1920', payload.resolution_width
    assert_equal '1280', payload.resolution_height
  end
end
