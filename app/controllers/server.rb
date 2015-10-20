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
      require 'pry'; binding.pry
    end

    not_found do
      erb :error
    end
  end
end
