jQuery(document).on 'turbolinks:load', ->
  messages = $('#messages')
  connect_room = $('#js-connect-room')
  disconnect_room = $('#js-disconnect-room')

  App.room = App.cable.subscriptions.create { channel: "RoomChannel", room_id: messages.data('room_id') },
    connected: ->
      # Called when the subscription is ready for use on the server
      @install()

    disconnected: ->
      # Called when the subscription has been terminated by the server
      @uninstall()

    rejected: ->
      # Called when the subscription has been rejected by the server
      @uninstall()

    received: (data) ->
      messages.prepend data['message']

    speak: (message) ->
      @perform 'speak', message: message

    all_clear: ->
      @perform 'all_clear'

    msg_command: (command_id) ->
      @perform 'msg_command', command_id: command_id

    install: ->
      connect_room.show()
      disconnect_room.hide()

    uninstall: ->
      connect_room.hide()
      disconnect_room.show()

  $(document).on 'keypress', '[data-behavior~=room_speaker]', (event) ->
    if event.keyCode is 13 # return = send
      App.room.speak event.target.value
      event.target.value = ''
      event.preventDefault()

  $ ->
    $('.js-command').click (e) ->
      App.room.msg_command $(this).data('msg-command')

    $('#js-clear-button').click ->
      messages.empty()
      App.room.all_clear ''
