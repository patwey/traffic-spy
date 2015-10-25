class TrafficSpy::Url < ActiveRecord::Base
  validates :url, uniqueness: true
  belongs_to :source, foreign_key: :source_id
  has_many :payloads
end
