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
        var header_height = $('header').outerHeight();
        var output_area_height = $('#output-area').outerHeight();
        var pagenate_area_height = header_height;
        // 現在のウィンドウの 1rem の高さ
        // var font_height = $('html').css('font-size');
        var font_height = $('#message-section-title').height();
        // メッセージ欄の拡張可能な高さ
        var add_height = window_height - header_height - output_area_height - pagenate_area_height;

        if ($('#text-message-section').length) {
            add_height = add_height - $('#text-message-section').outerHeight();
        }
        if ($('#button-message-section').length) {
            add_height = add_height - $('#button-message-section').outerHeight();
        }

        // メッセージ欄の拡張（数rem分調整）
        $('#message-section').height($('#message-section').outerHeight() + add_height - (font_height * 4));
    }

    adjust_message_section();
});
