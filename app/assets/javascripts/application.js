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
//= require united/loader
//= require united/bootswatch

$(function(){
  $('a[rel=tooltip]').tooltip( { html: true, placement: 'bottom' } );
  $('a[rel=popover]').popover( { html: true, placement: 'bottom', trigger: 'hover' } );

  // aタグにtarget=blank指定
  $('.target_blank a').attr('target' , '_blank');

  if ($('#autopager_on').val() == 'true') { autopager(); };
});

// オートページャー
function autopager() {
  $(window).scroll(function() {
    var obj = $(this);
    var current = $(window).scrollTop() + window.innerHeight;
    if (current < $(document).height() - 400) return;  // 下部に達していなければリターン
    if (obj.data('loading')) { return };               // ロード中であればリターン

    // パラメータ
    var target_month = $('#target_month').val();
    var next_month   = $('#next_month_' + target_month).val();
    var page         = parseInt($('#current_page').val());
    var next_page    = page + 1

    obj.data('loading', true);  // ローディングフラグON
    $.get(
      "/schedules/pager",
      // 送信データ
      { 'target_month': target_month, 'page': page },
      function(data, status) {
        $('#page_' + page).after(data);     // データ追加
        $('#current_page').val(next_page);  // ページ数更新
        obj.data('loading', false);         // ローディングフラグOFF
      },
      "html"                                // 応答データ形式
    );
  });
}
