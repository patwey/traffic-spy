class TrafficSpy::Url < ActiveRecord::Base
  validates :url, uniqueness: true
  has_many :payloads
end
