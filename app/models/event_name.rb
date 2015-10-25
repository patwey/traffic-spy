class TrafficSpy::EventName < ActiveRecord::Base
  validates :event_name, uniqueness: true
  belongs_to :source, foreign_key: :source_id
  has_many :payloads
end
