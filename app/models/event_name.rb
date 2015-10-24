class TrafficSpy::EventName < ActiveRecord::Base
  validates :event_name, uniqueness: true
  has_many :payloads, through: :event_name_id
end
