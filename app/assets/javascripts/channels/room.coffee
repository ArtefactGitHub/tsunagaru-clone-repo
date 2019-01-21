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
      @perform 'received'
      messages.prepend data['message']

    speak: (message) ->
      @perform 'speak', message: message

    all_clear: ->
      @perform 'all_clear'

    speak_by_message_button: (message_no, message_type) ->
      @perform 'speak_by_message_button', message_no: message_no, message_type: message_type

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
      App.room.speak_by_message_button($(this).data('message_no'), $(this).data('message_type'))

    $('#js-clear-button').click ->
      messages.empty()
      App.room.all_clear ''
