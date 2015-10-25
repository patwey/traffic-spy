module TrafficSpy
  class Statistics
    def self.application_details(identifier)
      source = Source.find_by(identifier: identifier)
      vars = {}
      vars[:identifier] = identifier
      vars[:urls] = source.urls.map { |url| [url.url, url.payloads.count] }
      vars[:browsers], vars[:op_systems] = parse_user_agents(source.payloads)
      vars[:resolutions] = get_ranked_resolutions(source.payloads)
      vars[:response_times] = get_avg_response_time_by_url(source)
      vars
    end

    def self.url_statistics(identifier, path)
      source = Source.find_by(identifier: identifier)
      payloads = Url.find_by(url: "#{source.root_url}/#{path}").payloads

      # get_response_statistics
      avg_response = payloads.average(:responded_in).to_f
      max_response = payloads.maximum(:responded_in).to_f
      min_response = payloads.minimum(:responded_in).to_f

      # request_types
      request_types = payloads.map { |pl| pl.request_type.request_type }.uniq

      # referred_by
      referred_by = order_collection(payloads.map { |pl| pl.referred_by })

      # get browsers
      browsers = parse_user_agents(payloads).first
      { avg_response: avg_response,
        max_response: max_response,
        min_response: min_response,
        request_types: request_types,
        referred_by: referred_by,
        user_agents: browsers }
    end

    def self.application_events_index(identifier)
      source = Source.find_by(identifier: identifier)
      payloads = source.payloads

      # get_event_names(payloads)
      event_names = get_ordered_events(payloads)
                    .delete_if { |event, _| event.nil? || event.empty? }
      { identifier: identifier,
        event_names: event_names }
    end

    def self.application_event_details(identifier, event_name)
      source = Source.find_by(identifier: identifier)

      # event-specific payloads
      payloads = EventName.find_by(event_name: event_name).payloads

      # parse requested_at
      hours = payloads.map { |payload| DateTime.parse(payload[:requested_at]).strftime("%-l %P") }
      events_by_hour = order_collection(hours)

      # total count
      total_count = total_count(events_by_hour)
      { events_by_hour: events_by_hour, total_count: total_count }
    end

    def self.total_count(events_by_hour)
      count = 0
      events_by_hour.each { |hour, n| count += n }
      count
    end

    def self.order_collection(collection)
      collection.reduce(Hash.new(0)) { |h, element| h[element] += 1 ; h }
                .sort_by { |k, v| v}.reverse
    end

    def self.parse_user_agents(payloads)
      user_agent_strings = payloads.map { |pl| pl.user_agent }
      browsers = user_agent_strings.map { |string| UserAgent.parse(string)
                                                            .browser }
      op_systems = user_agent_strings.map { |string| UserAgent.parse(string)
                                                              .os }
      [order_collection(browsers), order_collection(op_systems)]
    end

    def self.get_ranked_resolutions(payloads)
      resolutions = payloads.map do |pl|
                      "#{pl.resolution_width} x #{pl.resolution_height}"
                    end
      order_collection(resolutions)
    end

    def self.get_avg_response_time_by_url(source)
      source.urls.all.reduce({}) do |avg_by_url, url|
        avg_by_url[url.url] = url.payloads.average(:responded_in).to_f
        avg_by_url
      end.sort_by { |url, time| time }.reverse
    end

    def self.get_ordered_events(payloads)
      event_names = payloads.map { |pl| TrafficSpy::EventName.find_by(id: pl.event_name_id).event_name }
      order_collection(event_names)
    end
  end
end
