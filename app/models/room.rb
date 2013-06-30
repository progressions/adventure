class Room < ActiveRecord::Base
  has_many :exits

  def go(direction)
    direction = String(direction).downcase.strip

    exits.where(:direction => direction).try(:first).try(:destination)
  end

  def exit_list
    exits.map(&:direction)
  end
end
