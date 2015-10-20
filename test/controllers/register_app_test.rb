require './test/test_helper'

class RegisterSourceTest < Minitest::Test
  include Rack::Test::Methods

  def app
    TrafficSpy::Server
  end

  def test_cannot_register_app_without_identifier
    total = TrafficSpy::Source.count
    post '/sources', {rootUrl: 'http://jumpstartlab.com'}

    assert_equal total, TrafficSpy::Source.count
    assert_equal 400, last_response.status
    assert_equal "Identifier can't be blank", last_response.body
  end

  def test_cannot_register_app_without_root_url
    skip
    total = TrafficSpy::Source.count
    post '/sources', {identifier: 'jumpstartlab'}

    assert_equal total, TrafficSpy::Source.count
    assert_equal 400, last_response.status
    assert_equal "Root url can't be blank", last_response.body
  end

  def test_cannot_register_app_with_empty_params
    skip
    total = TrafficSpy::Source.count
    post '/sources', {}

    assert_equal total, TrafficSpy::Source.count
    assert_equal 400, last_response.status
    assert_equal "Identifier can't be blank, Root url can't be blank", last_response.body
  end

  def test_cannot_register_app_if_identifier_already_exists
    skip
    post '/sources', {identifier: 'jumpstartlab',
                      rootUrl:   'http://jumpstartlab.com'}

    assert TrafficSpy::Source.find_by(identifier: 'jumpstartlab')

    total = TrafficSpy::Source.count
    post '/sources', {identifier: 'jumpstartlab',
                      rootUrl:   'http://turing.io'}

    assert_equal total, TrafficSpy::Source.count
    assert_equal 403, last_response.status
    assert_equal 'Identifer already exists', last_response.body
  end
end
