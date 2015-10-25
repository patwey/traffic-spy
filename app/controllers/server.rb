module TrafficSpy
  class Server < Sinatra::Base
    get '/' do
      erb :index
    end

    post '/sources' do
      status, body = TrafficSpy::SourceCreator.process(params)
      status(status)
      body(body)
    end

    post '/sources/:id/data' do |id|
      status, body = TrafficSpy::PayloadCreator.process(params)
      status(status)
      body(body)
    end

    get '/sources/:identifier' do |identifier|
      locals = TrafficSpy::Statistics.application_details(identifier)
      erb :application_details, locals: locals
    end

    get '/sources/:identifier/urls/:relative' do |identifier, relative|
      not_found unless TrafficSpy::Source.all.find_by(identifier: identifier)
      locals = TrafficSpy::Statistics.url_statistics(identifier, relative)
      erb :application_url_statistics, locals: locals
    end

    get '/sources/:identifier/events' do |identifier|
      locals = TrafficSpy::Statistics.application_events_index(identifier)
      erb :application_events_index, locals: locals
    end

    get '/sources/:identifier/events/:event_name' do |identifier, event_name|
      locals = TrafficSpy::Statistics.application_event_details(identifier, event_name)
      erb :application_event_details, locals: locals
    end

    not_found do
      erb :error
    end
  end
end
