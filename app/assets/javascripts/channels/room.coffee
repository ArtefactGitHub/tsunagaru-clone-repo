jQuery(document).on 'turbolinks:load', ->
  body = $("html,body")
  messages = $('#messages')
  message_section = $('#message-section')
  input_area = $('#input-area')
  text_message_section = $('#text-message-section')
  text_input_area = $('#text-message-section .text-area-custom')
  connect_room = $('#js-connect-room')
  disconnect_room = $('#js-disconnect-room')
  default_body_height = 0;
  window_height = 0
  content_height = 0
  margin_height = 0
  window_adjust_height = 0

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
      if connect_room.data('use_type') == 'only_chat'
        @scroll_message_section()

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

  calc_content_height = ->
    pagenate_area_height = if $('#pagenate-area').length == 0 then 0 else $('#pagenate-area').height()
    return $('header').height() + $('#output-area').height() + pagenate_area_height + input_area.height();

  is_use_type_only_chat = ->
    return connect_room.data('use_type') == 'only_chat'

  is_use_text_input = ->
    return $('#text-message-section').length >= 1

  get_adjust_height = ->
    return (default_body_height / 3)

  need_adjust_DOMFocus = ->
    return window_adjust_height > 0

  calc_window_adjust_height = ->
    if is_use_text_input() && isMobile()
      result = get_adjust_height() - (input_area.height() - text_message_section.height())
      result = if result < 0 then 0 else result
      return result
    else
      return 0

  setupLayout = ->
    window_height = $(window).height()
    # 画面上の高さの余白（メッセージ欄の拡張可能な高さ）
    margin_height = window_height - calc_content_height()

    # 現在のウィンドウの 1rem の高さ
    # font_height = $('html').css('font-size');
    font_height = $('#message-section-title').height();
    # メッセージ欄の拡張（数rem分調整）
    add_height = margin_height - (font_height * 2);
    if add_height > 0
      $('#message-section').height($('#message-section').outerHeight() + add_height);

    # 画面の高さを取得
    default_body_height = body.height();
    # 調整後のコンテンツ全体の高さを取得
    content_height = calc_content_height()
    # 画面の高さ調整値を取得
    window_adjust_height = calc_window_adjust_height()

    message_section.scrollTop(message_section.get(0).scrollHeight)

  $(document).on 'keypress', '[data-behavior~=room_speaker]', (event) ->
    if event.keyCode is 13 # return = send
      if event.target.value.length <= 0
        event.preventDefault()
        # alert 'メッセージを入力してください'
      else if event.target.value.length > 100
        event.preventDefault()
        alert 'メッセージの最大文字数を超えています'
      else
        App.room.speak event.target.value
        event.target.value = ''
        event.preventDefault()

  isMobile = -> return navigator.userAgent.match(/(iPhone|iPad|iPod|Android)/i)
  # isMobile = -> return navigator.userAgent.match(/(Mac)/i)

  scroll_window_top = -> body.animate({scrollTop: 0}, 500, 'swing');
  scroll_window_top_and_resize = -> body.animate({scrollTop: 0}, 500, 'swing', () ->
    if need_adjust_DOMFocus()
      body.height(default_body_height))

  scroll_window_bottom = -> body.animate({scrollTop: body.get(0).scrollHeight}, 1000, 'swing')

  # テキスト入力欄のフォーカス
  text_input_area.on 'DOMFocusIn', (event) ->
    if need_adjust_DOMFocus()
      body.height(default_body_height + window_adjust_height)
      scroll_window_bottom()

  # テキスト入力欄のフォーカスが外れた
  text_input_area.on 'DOMFocusOut', (event) ->
    scroll_window_top_and_resize()

  do ->
    setupLayout()

  $ ->
    $('.js-command').click (e) ->
      App.room.speak_by_message_button($(this).data('message_no'), $(this).data('message_type'))
      scroll_window_top();

    $('#js-clear-button').click ->
      messages.empty()
      App.room.all_clear ''
