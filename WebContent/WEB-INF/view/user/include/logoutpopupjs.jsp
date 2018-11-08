<%@ page pageEncoding="UTF-8" %>
	var logoutPopup = document.getElementById("logoutPopup");
	var grayPanel = document.getElementById("grayPanel");
	var logoutPopupWidth = logoutPopup.clientWidth;
	var logoutPopupHeight = logoutPopup.clientHeight;

	function logoutConfirm(){
		var w_height = $(window).height();
		var w_width = $(window).width();
		var scroll_height = $(window).scrollTop();
		logoutPopup.style.left = (w_width - logoutPopupWidth) / 2 + "px";
		logoutPopup.style.top = scroll_height + (w_height - logoutPopupHeight) / 2 + "px";
		logoutPopup.style.visibility = "visible";
		grayPanel.style.display = "block";
	}

	function logoutCancel(){
		logoutPopup.style.visibility = "hidden";
		grayPanel.style.display = "none";
	}

	// 全体のクリックイベントを取得して、settingPopup以外をクリックしたらsettingPopupを隠す
	$(document).on('click touchend', function(event) {
		  if (!$(event.target).closest('div#logoutPopup').length && !$(event.target).closest("div#logout").length) {
			  logoutCancel();
		  } else if($(event.target).closest('div#logout').length){
			  logoutConfirm();
		  }
	});