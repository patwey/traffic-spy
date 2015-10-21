class TrafficSpy::Payload < ActiveRecord::Base
  validates :sha, uniqueness: true

  # { scope: :sha,
  # message: "Request payload has already been received." }
end
