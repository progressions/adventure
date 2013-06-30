class Exit < ActiveRecord::Base
  belongs_to :room
  belongs_to :destination, :class_name => Room, :foreign_key => :destination_id
end
