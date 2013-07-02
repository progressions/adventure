class SavedGame < ActiveRecord::Base
  has_many :rooms
  has_many :exits
  has_many :static_objects
end
