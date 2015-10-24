class TrafficSpy::Payload < ActiveRecord::Base
  belongs_to :source, foreign_key: :source_id
  belongs_to :url, foreign_key: :url_id
  belongs_to :request_type, foreign_key: :request_type_id
  belongs_to :event_name, foreign_key: :event_name_id
  validates :sha, uniqueness: true
end
