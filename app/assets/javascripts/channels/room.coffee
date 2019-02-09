jQuery(document).on 'turbolinks:load', ->
  messages = $('#messages')
  message_section = $('#message-section')
  connect_room = $('#js-connect-room')
  disconnect_room = $('#js-disconnect-room')

  App.room = App.cable.subscriptions.create { channel: "RoomChannel", room_id: messages.data('room_id') },
    connected: ->
      # Called when the subscription is ready for use on the server
      @install()
      @scroll_message_section()

    disconnected: ->
      # Called when the subscription has been terminated by the server
      @uninstall()

    rejected: ->
      # Called when the subscription has been rejected by the server
      @uninstall()

    received: (data) ->
      @perform 'received'
      messages.append data['message']
      @adjust_layout_own_message()
      # $(window).scrollTop(0);
      # $("#message-section").scrollTop(0);

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

    adjust_layout_own_message: ->
      current_user_uuid = connect_room.data('current_user_uuid')
      message = $('#messages .message').last()
      user_uuid = message.data('user_uuid')
      if current_user_uuid == user_uuid
        message.css('text-align', 'right');
        message.find('.avatar').addClass('order-2');
        @scroll_message_section()

    scroll_message_section: ->
      message_section.scrollTop(message_section.get(0).scrollHeight)

  $(document).on 'keypress', '[data-behavior~=room_speaker]', (event) ->
    if event.keyCode is 13 # return = send
      if event.target.value.length <= 0
        alert 'メッセージを入力してください'
      else if event.target.value.length > 100
        alert 'メッセージの最大文字数を超えています'
      else
        App.room.speak event.target.value
        event.target.value = ''
        event.preventDefault()
        # $(window).scrollTop(0);

  $ ->
    $('.js-command').click (e) ->
      App.room.speak_by_message_button($(this).data('message_no'), $(this).data('message_type'))
      $(window).scrollTop(0);

    $('#js-clear-button').click ->
      messages.empty()
      App.room.all_clear ''
