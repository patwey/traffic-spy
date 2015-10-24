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
      # payloads = TrafficSpy::PayloadRetriever.retrieve(identifier)
      locals = TrafficSpy::Statistics.application_details(identifier)
      erb :application_details, locals: locals
    end

    not_found do
      erb :error
    end
  end
end
