require './test/test_helper'
class ViewApplicationDetailsTest < FeatureTest

  def test_it_returns_error_page_if_identifier_does_not_exist
    skip
    create_source
    create_payload({url: "http://jumpstartlab.com/tyler"})
    create_payload({url: 'http://jumpstartlab.com/blog'})
    create_payload({url: 'http://jumpstartlab.com/blog', requested_at: Time.now})

    visit '/sources/jumpstartlab'
    assert_equal '/sources/jumpstartlab', current_path

    assert page.has_content?("Identifier doesn't exist")
  end

  def test_user_can_view_most_requested_urls
    create_source
    create_payload({url: "http://jumpstartlab.com/tyler"})
    create_payload({url: 'http://jumpstartlab.com/blog'})
    create_payload({url: 'http://jumpstartlab.com/blog', requested_at: Time.now})

    visit '/sources/jumpstartlab'
    assert_equal '/sources/jumpstartlab', current_path

    within '#application-details' do
      assert has_content?("Most Requested URL's")

      within '#url-ranking' do
        assert has_content?('http://jumpstartlab.com/blog')
        assert has_content?('http://jumpstartlab.com/tyler')
      end
    end
  end

  def test_user_can_view_web_browser_breakdown
    create_source
    create_payload({url: "http://jumpstartlab.com/tyler"})
    create_payload({url: 'http://jumpstartlab.com/blog'})
    create_payload({url: 'http://jumpstartlab.com/blog', requested_at: Time.now})

    visit '/sources/jumpstartlab'
    assert_equal '/sources/jumpstartlab', current_path

    within '#application-details' do
      assert has_content?("Web Browser Breakdown")

      within '#web-browser-breakdown' do
        assert has_content?('Safari 3')
        # assert has_content?('Firefox 1')
      end
    end
  end

  def test_user_can_view_operating_system_breakdown
    create_source
    create_payload({url: "http://jumpstartlab.com/tyler"})
    create_payload({url: 'http://jumpstartlab.com/blog'})
    create_payload({url: 'http://jumpstartlab.com/blog', requested_at: Time.now})

    visit '/sources/jumpstartlab'
    assert_equal '/sources/jumpstartlab', current_path

    within '#application-details' do
      assert has_content?("Operating System Breakdown")

      within '#os-breakdown' do
        assert has_content?("intel mac os x 10_8_2")
      end
    end
  end

  def test_user_can_see_screen_resolutions
    create_source
    create_payload({url: "http://jumpstartlab.com/tyler"})
    create_payload({url: 'http://jumpstartlab.com/blog'})
    create_payload({url: 'http://jumpstartlab.com/blog', requested_at: Time.now})

    visit '/sources/jumpstartlab'
    assert_equal '/sources/jumpstartlab', current_path

    within '#application-details' do
      assert has_content?("Screen Resolution")

      within '#screen-resolution' do
        assert has_content?('1920 x 1280	3')
      end
    end
  end

  def test_user_can_average_response_times
    create_source
    create_payload({url: "http://jumpstartlab.com/tyler"})
    create_payload({url: 'http://jumpstartlab.com/blog'})
    create_payload({url: 'http://jumpstartlab.com/blog', requested_at: Time.now})

    visit '/sources/jumpstartlab'
    assert_equal '/sources/jumpstartlab', current_path

    within '#application-details' do
      assert has_content?("URL by Response Time")

      within '#response-time' do
        assert has_content?('http://jumpstartlab.com/blog')
        assert has_content?('http://jumpstartlab.com')
      end
    end
  end

  def test_user_can_view_urls_to_url_specific_data_and_aggregate_event_data
    create_source
    create_payload({url: "http://jumpstartlab.com/tyler"})
    create_payload({url: 'http://jumpstartlab.com/blog/1'})

    visit '/sources/jumpstartlab'
    assert_equal '/sources/jumpstartlab', current_path
    within '#url-specific-data' do
      assert has_content? 'jumpstartlab.com/tyler'
      assert has_content? 'jumpstartlab.com/blog/1'
    end

    within '#aggregate-event-data' do
      assert has_content? 'jumpstartlab'
    end
  end
end
