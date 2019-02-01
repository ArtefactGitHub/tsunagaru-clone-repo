'use strict';

document.addEventListener("turbolinks:load", function(){
  // 画像選択時にサムネイルを切り替える
  if (document.querySelector('#user_avatar') != undefined) {
    document.querySelector('#user_avatar').onchange = function(event) {
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
})
