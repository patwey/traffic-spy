class TrafficSpy::Source < ActiveRecord::Base
  validates_presence_of :identifier, :root_url
  has_many :payloads
  has_many :urls
  has_many :request_types, through: :payloads
  has_many :event_names, through: :payloads
  has_many :user_agents
end
