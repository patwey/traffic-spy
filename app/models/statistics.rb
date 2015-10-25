module TrafficSpy
  class Statistics
    def self.application_details(identifier)
      payloads = Source.find_by(identifier: identifier).payloads
      urls = get_ranked_urls(payloads)
      browsers, op_systems = parse_user_agents(payloads)
      resolutions = get_ranked_resolutions(payloads)
      response_times = get_avg_response_time_by_url(payloads)
      { identifier: identifier,
        urls: urls,
        browsers: browsers,
        op_systems: op_systems,
        resolutions: resolutions,
        response_times: response_times }
    end

    def self.url_statistics(identifier, path)
      source = Source.find_by(identifier: identifier)

      url = source.urls
                  .find_by(url: "#{source.root_url}/#{path}")
                  .url

      # get_response_statistics
      avg_response = source.payloads
                           .where(url_id: Url.find_by(url: url)
                           .id).average(:responded_in)
                           .to_f
      max_response = source.payloads
                           .where(url_id: Url.find_by(url: url)
                           .id).maximum(:responded_in)
                           .to_f
      min_response = source.payloads
                           .where(url_id: Url.find_by(url: url)
                           .id)
                           .minimum(:responded_in)
                           .to_f

      # request_types
      request_types = source.payloads
                            .map { |pl| pl.request_type.request_type }
                            .uniq

      # referred_by
      referred_by = order_collection(source.payloads
                                           .where(url_id: Url.find_by(url: url)
                                           .id)
                                           .map { |pl| pl.referred_by })

      # get browsers
      browsers, op_systems = parse_user_agents(source.payloads
                                                     .where(url_id: Url.find_by(url: url)
                                                     .id))
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
      payloads = source.payloads
                       .where(event_name_id: EventName.find_by(event_name: event_name)
                                                      .id)
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
      collection_count = Hash.new(0)
      collection.each do |element|
        collection_count[element] += 1
      end
      collection_count.sort_by { |k, v| v}.reverse
    end

    def self.get_ranked_browsers(user_agents)
      raw_browsers = user_agents.map { |user_agent| user_agent.browser }
      order_collection(raw_browsers)
    end

    def self.get_ranked_op_systems(user_agents)
      raw_op_systems = user_agents.map { |user_agent| user_agent.os }
      op_systems = order_collection(raw_op_systems)
    end

    def self.parse_user_agents(payloads)
      user_agent_strings = payloads.map { |payload| payload.user_agent }
      user_agents = user_agent_strings.map { |string| UserAgent.parse(string) }
      browsers = get_ranked_browsers(user_agents)
      op_systems = get_ranked_op_systems(user_agents)
      [browsers, op_systems]
    end

    def self.get_ranked_urls(payloads)
      raw_urls = payloads.map { |payload| TrafficSpy::Url.find_by(id: payload.url_id).url }
      order_collection(raw_urls)
    end

    def self.get_ranked_resolutions(payloads)
      raw_screen_resolutions = payloads.map { |payload| "#{payload.resolution_width} x #{payload.resolution_height}" }
      order_collection(raw_screen_resolutions)
    end

    def self.get_avg_response_time_by_url(payloads)
      urls = payloads.map { |payload| TrafficSpy::Url.find_by(id: payload.url_id) }.uniq
      avg_response_by_url = {}
      urls.each do |url|
        avg_response_by_url[url.url] = Payload.where(url: url).average(:responded_in).to_f
      end
      avg_response_by_url.sort_by { |k, v| v }.reverse
    end

    def self.get_ordered_events(payloads)
      event_names = payloads.map { |pl| TrafficSpy::EventName.find_by(id: pl.event_name_id).event_name }
      order_collection(event_names)
    end
  end
end
