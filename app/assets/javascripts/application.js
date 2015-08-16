// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

jQuery(function(){
  // ソース生成
  jQuery('#app-make-source-link').on('click', function(e) {
    (e.preventDefault) ? e.preventDefault() : e.returnValue=false;

    var tempId = jQuery('#app-make-source-combo').val();
    if (tempId == '') {
      return;
    }

    var url = jQuery(e.target).data('url');
    var query = jQuery(e.target).data('query');
    if (query != "") {
      query = "?" + query;
    }
    window.open(url + '/' + tempId + query, "_blank");
  });
});
