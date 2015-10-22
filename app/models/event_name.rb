class TrafficSpy::EventName < ActiveRecord::Base
  validates :event_name, uniqueness: true
  has_many :payloads
end
