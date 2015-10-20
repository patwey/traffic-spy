module TrafficSpy
  class Server < Sinatra::Base
    get '/' do
      erb :index
    end

    post '/sources' do
      # require 'pry'; binding.pry
      status, body = TrafficSpy::SourceCreator.process(params)
      status(status)
      body(body)
    end

    not_found do
      erb :error
    end
  end
end
