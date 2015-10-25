require './test/test_helper'
class ViewApplicationUrlStatisticsTest < FeatureTest

  # test edge cases with longer paths (ex) urls/:relative/:path

  def test_it_returns_error_page_if_url_for_identifier_doesnt_exist
    create_source
    create_payload({url: "http://jumpstartlab.com/tyler"})
    create_payload({url: 'http://jumpstartlab.com/blog'})
    create_payload({url: 'http://jumpstartlab.com/blog', requested_at: Time.now})

    visit '/sources/BADIDENTIFIER/urls/home'

    assert page.has_content?("Identifier doesn't exist")
  end

  def test_user_can_view_url_response_times_statistics
    create_source
    create_payload({url: "http://jumpstartlab.com/tyler"})
    create_payload({url: 'http://jumpstartlab.com/blog', responded_in: 10})
    create_payload({url: 'http://jumpstartlab.com/blog', responded_in: 11})

    visit '/sources/jumpstartlab/urls/blog'
    # '/sources/:identifier/urls/:relative/:path'
    assert_equal '/sources/jumpstartlab/urls/blog', current_path

    within '#application-url-statistics' do
      within '#url-response-times' do
        assert has_content?("URL Response Time")
        within '#url-statistics' do
          assert has_content?('11.0')
          assert has_content?('10.0')
          assert has_content?('10.5')
         end
       end
    end
  end

  def test_user_can_view_most_common_request_types
    create_source
    create_payload({url: "http://jumpstartlab.com/tyler"})
    create_payload({url: 'http://jumpstartlab.com/blog'})
    create_payload({url: 'http://jumpstartlab.com/blog', requested_at: Time.now})

    visit '/sources/jumpstartlab/urls/blog'
    assert_equal '/sources/jumpstartlab/urls/blog', current_path

    within '#application-url-statistics' do
      within '#most-common-request-types' do
        assert has_content?("Most Common Request Types")

        within '#http-verb-statistics' do
          assert has_content?('GET')
         end
       end
    end
  end

  def test_user_can_view_most_popular_referrers
    create_source
    create_payload({url: "http://jumpstartlab.com/tyler"})
    create_payload({url: 'http://jumpstartlab.com/blog'})
    create_payload({url: 'http://jumpstartlab.com/blog', requested_at: Time.now})

    visit '/sources/jumpstartlab/urls/blog'
    assert_equal '/sources/jumpstartlab/urls/blog', current_path

    within '#application-url-statistics' do
      within '#most-popular-referrers' do
        assert has_content?("Most Popular Referrers")

        within '#referred-by-statistics' do
          assert has_content?('http://jumpstartlab.com 2')
         end
       end
    end
  end

  def test_user_can_view_most_popular_user_agents
    create_source
    create_payload({url: "http://jumpstartlab.com/tyler"})
    create_payload({url: 'http://jumpstartlab.com/blog'})
    create_payload({url: 'http://jumpstartlab.com/blog', requested_at: Time.now})

    visit '/sources/jumpstartlab/urls/blog'
    assert_equal '/sources/jumpstartlab/urls/blog', current_path

    within '#application-url-statistics' do
      within '#most-popular-user-agents' do
        assert has_content?("Most Popular User Agents")

        within '#user-agent-statistics' do
          assert has_content?('Safari 2') # display entire string?
         end
       end
    end
  end

end
