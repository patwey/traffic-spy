module TrafficSpy
  class SourceCreator
    def self.process(data)
      # downcase values before inserting!?
      # what will the params key look like for :rootUrl?
      #if App.exists?(identifier: data[:identifier])
        data = format_data(data)
        app = Source.new(data)
        if app.save
          body = 'app created'
        else
          status = 400
          body = app.errors.full_messages.join(', ')
        end
        #end
      return status, body
    end

    def self.format_data(data) # DataSanitizer?
      { :root_url => data["rootUrl"] }
    end
  end
end
