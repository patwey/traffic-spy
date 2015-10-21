require './test/test_helper'

class SourceCreatorTest < Minitest::Test
  include Rack::Test::Methods

  def app
    TrafficSpy::Server
  end

  def test_status_if_identifier_already_exists
    total = TrafficSpy::Source.count

    params = {"identifier"=>"jumpstartlab", "rootUrl"=>"http://jumpstartlab.com"}
    status, body = TrafficSpy::SourceCreator.process(params)
    source = TrafficSpy::Source.all.first

    assert_equal (total + 1), TrafficSpy::Source.count
    assert_equal "http://jumpstartlab.com", source.root_url
    assert_equal "jumpstartlab", source.identifier

    status, body = TrafficSpy::SourceCreator.process(params)

    assert_equal 403, status
    assert_equal 'Identifier already exists', body
  end

  def test_source_cannot_register_without_identifier
    total = TrafficSpy::Source.count

    params = {"rootUrl"=>"http://jumpstartlab.com"}
    status, body = TrafficSpy::SourceCreator.process(params)

    assert_equal (total), TrafficSpy::Source.count
    assert_equal 400, status
    assert_equal "Identifier can't be blank", body
  end

  def test_cannot_register_source_without_rool_url
    total = TrafficSpy::Source.count

    params = {"identifier"=> "jumpstartlab"}
    status, body = TrafficSpy::SourceCreator.process(params)

    assert_equal (total), TrafficSpy::Source.count
    assert_equal 400, status
    assert_equal "Root url can't be blank", body
  end

  def test_cannot_register_source_with_empty_params
    total = TrafficSpy::Source.count

    params = {}
    status, body = TrafficSpy::SourceCreator.process(params)

    assert_equal (total), TrafficSpy::Source.count
    assert_equal 400, status
    assert_equal "Identifier can't be blank, Root url can't be blank", body
  end

  # test source created for valid request
    # status 200
    # body 'source created' ?
end
