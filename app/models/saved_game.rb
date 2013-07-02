class SavedGame < ActiveRecord::Base
  has_many :rooms
  has_many :exits
  has_many :static_objects

  validates :name, presence: true
  validates :name, uniqueness: true
end
