// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require cable.js

document.addEventListener("turbolinks:load", function() {
    'use strict';

    function adjust_message_section() {
        var window_height = $(window).height();
        var header_height = $('header').height();
        var output_area_height = $('#output-area').height();
        var pagenate_area_height = header_height;
        var input_area_height = $('#input-area').height();

        // 現在のウィンドウの 1rem の高さ
        // var font_height = $('html').css('font-size');
        var font_height = $('#message-section-title').height();
        // メッセージ欄の拡張可能な高さ
        var add_height = window_height - header_height - output_area_height - pagenate_area_height - input_area_height;

        // メッセージ欄の拡張（数rem分調整）
        var adjustHeight = (font_height * 2);
        add_height = add_height - adjustHeight;
        if (add_height > 0) {
          $('#message-section').height($('#message-section').outerHeight() + add_height);
          $('#input-area').height((input_area_height * 2) + adjustHeight);
        }
    }

    adjust_message_section();
});

document.addEventListener("DOMFocusOut", function(event) {
    'use strict';
    //キーボードが引っ込んだ時
    $(window).scrollTop(0);
}, false);
