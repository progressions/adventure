require 'spec_helper'

describe Room do
  it "lists its exits" do
    room = Room.create(:name => "Room")
    destination = Room.create(:name => "Destination")
    room.exits.create(:direction => "north", :destination => destination)

    expect(room.exit_list).to eq(["north"])
  end
end
