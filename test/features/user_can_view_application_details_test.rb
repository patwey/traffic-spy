require './test/test_helper'
class ViewApplicationDetailsTest < FeatureTest

  def create_source
    params = {"identifier"=>"jumpstartlab", "rootUrl"=>"http://jumpstartlab.com"}
    TrafficSpy::SourceCreator.process(params)
  end

  def create_payload(values)
    values[:url] = 'http://jumpstartlab.com/blog' if values[:url].nil?
    values[:user_agent] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17" if values[:user_agent].nil?
    values[:resolution_width] = "1920" if values[:resolution_width].nil?
    values[:resolution_height] = "1280" if values[:resolution_height].nil?
    values[:responded_in] = 37 if values[:responded_in].nil?
    values[:event_name] = "socialLogin" if values[:event_name].nil?
    values[:requested_at] = "2013-02-16 21:38:28 -0700" if values[:requested_at].nil?

    params = {"payload"=>"{\"url\":\"#{values[:url]}\",\"requestedAt\":\"#{values[:requested_at]}\",\"respondedIn\":#{values[:responded_in]},\"referredBy\":\"http://jumpstartlab.com\",\"requestType\":\"GET\",\"parameters\":[],\"eventName\": \"#{values[:event_name]}\",\"userAgent\":\"#{values[:user_agent]}\",\"resolutionWidth\":\"#{values[:resolution_width]}\",\"resolutionHeight\":\"#{values[:resolution_height]}\",\"ip\":\"63.29.38.211\"}",
              "splat"=>[],
              "captures"=>["jumpstartlab"],
              "id"=>"jumpstartlab"}
    TrafficSpy::PayloadCreator.process(params)
  end

  def test_user_can_view_most_requested_urls
    create_source
    create_payload({url: "http://jumpstartlab.com/tyler"})

    create_payload({url: 'http://jumpstartlab.com/blog'})

    create_payload({url: 'http://jumpstartlab.com/blog', requested_at: Time.now})
#     As a registered user,
#     when I visit http://localhost:9393/sources/IDENTIFIER,
#     and the identifier exists,
#     then I expect to see the application details
    visit '/sources/jumpstartlab'
    assert_equal '/sources/jumpstartlab', current_path

    refute page.has_content?("Identifier doesn't exist")

    within '#application-details' do
      assert has_content?("Most Requested URL's")

      within '#url-ranking' do
        assert has_content?('http://jumpstartlab.com/blog: 2')
        assert has_content?('http://jumpstartlab.com/blog: 1')
      end
      save_and_open_page
    end
  end

end
