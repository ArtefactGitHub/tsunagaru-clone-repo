module RoomsModule
  def create_owner_room(owner)
    room = Room.new
    room.owner = owner
    room.name = "#{owner.name} のチャットルーム"
    room.description = "#{owner.name} のチャットルームです。"
    room.save!
  end
end
