class TrafficSpy::RequestType < ActiveRecord::Base
  validates :request_type, uniqueness: true
  has_many :payloads
end
