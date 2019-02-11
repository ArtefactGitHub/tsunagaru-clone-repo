'use strict';

document.addEventListener("turbolinks:load", function(){
  // 画像選択時にサムネイルを切り替える
  if (document.querySelector('#user_image') != undefined) {
    document.querySelector('#user_image').onchange = function(event) {
      var files = event.target.files;
      if(files.length == 0) return;
      var file = files[0];
      if(!file.type.match(/image/)) {
        alert("画像ファイルを選んでください");
        return;
      }
      var reader = new FileReader();
      reader.onload = (function(){
        return function(e) {
          var elem = document.querySelector('#js-user-avatar')
          elem.src = e.target.result;
        };
      })(file);
      reader.readAsDataURL(file);
    }
  }

  $('#use_type_setting_use_type_use_normal').click(function() {
    $('#use_type_setting_use_text_input').prop('checked', true);
    $('#use_type_setting_use_button_input').prop('checked', false);
  });
  $('#use_type_setting_use_type_only_chat').click(function() {
    $('#use_type_setting_use_text_input').prop('checked', false);
    $('#use_type_setting_use_button_input').prop('checked', true);
  });
})
