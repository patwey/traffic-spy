class TrafficSpy::Payload < ActiveRecord::Base
  belongs_to :source
  validates :sha, uniqueness: true

  # { scope: :sha,
  # message: "Request payload has already been received." }
end
