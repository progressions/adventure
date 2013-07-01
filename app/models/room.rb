class Room < ActiveRecord::Base
  has_many :exits
  has_many :static_objects

  def go(direction)
    direction = String(direction).downcase.strip

    exits.where(:direction => direction).try(:first).try(:destination)
  end

  def exit_list
    exits.map(&:direction)
  end

  def static_object_list
    static_objects.map(&:name)
  end

  def output
    {
      description: description,
      name: name,
      exits: exit_list,
      objects: static_object_list
    }
  end
end
