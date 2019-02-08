module RoomsControllerModule
  extend ActiveSupport::Concern
  include MessageButtonListsControllerModule

  def create_owner_room(owner)
    room = Room.new
    room.owner = owner
    room.name = "#{owner.name} のチャット部屋"
    room.description = "#{owner.name} のチャット部屋です。"
    room.save!

    setup_default_messages room
  end
end
