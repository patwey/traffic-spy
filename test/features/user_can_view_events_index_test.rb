require './test/test_helper'
class ViewApplicationEventsIndexTest < FeatureTest
  def test_user_can_view_received_events_in_order
    create_source
    create_payload({url: "http://jumpstartlab.com/blog", event_name: "antiSocialLogin"})
    create_payload({url: 'http://jumpstartlab.com/blog', event_name: "socialLogin"})
    create_payload({url: 'http://jumpstartlab.com/blog', event_name: "socialLogin",
                    requested_at: Time.now})

    visit '/sources/jumpstartlab/events'
    assert_equal '/sources/jumpstartlab/events', current_path

    within '#application-events-index' do
      within '#ordered-events' do
        assert has_content? 'socialLogin 2'
        assert has_content? 'antiSocialLogin 1'
      end
    end
  end

  def test_user_can_view_links_to_each_events_data
    create_source
    create_payload({url: "http://jumpstartlab.com/blog", event_name: "antiSocialLogin"})
    create_payload({url: 'http://jumpstartlab.com/blog', event_name: "socialLogin"})
    create_payload({url: 'http://jumpstartlab.com/blog', event_name: "socialLogin",
                    requested_at: Time.now})

    visit '/sources/jumpstartlab/events'
    assert_equal '/sources/jumpstartlab/events', current_path

    within '#application-events-index' do
      within '#ordered-events' do
        assert has_link? 'socialLogin'
        assert has_link? 'antiSocialLogin'
      end
    end
  end

  def test_user_sees_message_if_there_are_events
    create_source
    create_payload({url: "http://jumpstartlab.com/blog", event_name: ""})
    create_payload({url: 'http://jumpstartlab.com/blog', event_name: "",
                    requested_at: 300 })
    create_payload({url: 'http://jumpstartlab.com/blog', event_name: "",
                    requested_at: Time.now })

    visit '/sources/jumpstartlab/events'
    assert_equal '/sources/jumpstartlab/events', current_path

    assert has_content? 'No events have been defined'
  end
end
