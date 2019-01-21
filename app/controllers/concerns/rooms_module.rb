module RoomsModule
  extend ActiveSupport::Concern
  include MessageButtonsModule

  def create_owner_room(owner)
    room = Room.new
    room.owner = owner
    room.name = "#{owner.name} のチャットルーム"
    room.description = "#{owner.name} のチャットルームです。"
    room.save!

    setup_default_messages room
  end
end
