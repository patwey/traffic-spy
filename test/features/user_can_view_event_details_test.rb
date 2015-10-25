require './test/test_helper'

class ViewApplicationEventDetailsTest < FeatureTest
  def test_user_can_view_hour_by_hour_breakdown_of_events
    create_source
    create_payload({url: "http://jumpstartlab.com/blog", event_name: "antiSocialLogin"})
    create_payload({url: 'http://jumpstartlab.com/blog', event_name: "socialLogin",
                    requested_at: "2015-10-24 12:00:00 -0600"})
    create_payload({url: 'http://jumpstartlab.com/blog', event_name: "socialLogin",
                    requested_at: "2015-10-24 0:00:00 -0600"})

    visit '/sources/jumpstartlab/events/socialLogin'
    assert_equal '/sources/jumpstartlab/events/socialLogin', current_path

    within '#event-name-statistics' do
      within '#events-by-hour' do
        assert has_content? '12 pm 1'
        assert has_content? '12 am 1'
      end
    end
  end

  def test_user_can_see_total_times_event_was_recieved
    create_source
    create_payload({url: "http://jumpstartlab.com/blog", event_name: "antiSocialLogin"})
    create_payload({url: 'http://jumpstartlab.com/blog', event_name: "socialLogin",
                    requested_at: "2015-10-24 12:00:00 -0600"})
    create_payload({url: 'http://jumpstartlab.com/blog', event_name: "socialLogin",
                    requested_at: "2015-10-24 0:00:00 -0600"})

    visit '/sources/jumpstartlab/events/socialLogin'
    assert_equal '/sources/jumpstartlab/events/socialLogin', current_path

      within '#total-count' do
        assert has_content? 'Total: 2'
      end
  end
end
