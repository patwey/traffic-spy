module TrafficSpy
  class Server < Sinatra::Base
    get '/' do
      erb :index
    end

    post '/sources' do
      app = App.new(params[:app])
      if app.save
        'app created'
      else
        status 400
        app.errors.full_messages.join(', ')
      end
    end

    not_found do
      erb :error
    end
  end
end
