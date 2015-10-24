require './test/test_helper'
class ViewApplicationUrlStatisticsTest < FeatureTest

  # test edge cases with longer paths (ex) urls/:relative/:path

  def test_it_returns_error_page_if_url_for_identifier_doesnt_exist
    skip
    create_source
    create_payload({url: "http://jumpstartlab.com/tyler"})
    create_payload({url: 'http://jumpstartlab.com/blog'})
    create_payload({url: 'http://jumpstartlab.com/blog', requested_at: Time.now})

    visit '/sources/jumpstartlab/urls/home'
    assert_equal '/sources/jumpstartlab/urls/home', current_path

    assert page.has_content?("Identifier doesn't exist")
  end

  def test_user_can_visit_url_statistics_page_and_view_response_times
    create_source
    create_payload({url: "http://jumpstartlab.com/tyler"})
    create_payload({url: 'http://jumpstartlab.com/blog'})
    create_payload({url: 'http://jumpstartlab.com/blog', requested_at: Time.now})

    visit '/sources/jumpstartlab/urls/blog'
    # '/sources/:identifier/urls/:relative/:path'
    assert_equal '/sources/jumpstartlab/urls/blog', current_path

    within '#application-url-statistics' do
      within '#url-response-times' do
        assert has_content?("Most Requested URL's")

    #   within '#' do
    #     assert has_content?('http://jumpstartlab.com/blog')
    #     assert has_content?('http://jumpstartlab.com/tyler')
       end
    end
  end

end
