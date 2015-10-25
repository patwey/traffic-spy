class TrafficSpy::RequestType < ActiveRecord::Base
  validates :request_type, uniqueness: true
  belongs_to :source, foreign_key: :source_id
  has_many :payloads
end
