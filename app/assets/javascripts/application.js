// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require_tree .


$(function(){
  $(".datepicker").datepicker({dateFormat: "dd/mm/yy" });

  $('#email_ids').tagsInput({
    'defaultText':'Enter comma seprated email ids',
    'width' : '500px',
    'height' : '170px'
  });

  $('#email_ids_tag').width('190px');
});

var set_csrf_token = function(xhr){
  xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
}   