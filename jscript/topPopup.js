//Top 레이어팝업
if( $('#topPopup').is(":hidden")) {
	var cookie_topPopup = getcookietopPopup('topPopup');
	//alert(cookie_topPopup);
	if(cookie_topPopup =='no'){

	}else {
		$("#topPopupArea").slideToggle(0);
	}
}
function closeTopPopup(fs){
	if(	$("#topPopup").prop("checked") == true) {
		setCookie(fs, 'no' , 1);
	}else {
	}
	$("#topPopupArea").slideToggle(300);
	//$('#topPopupArea').css({"display":"none"});
}
function getcookietopPopup(c_name) {
	var i,x,y,ARRcookies=document.cookie.split(";");
	for (i=0;i<ARRcookies.length;i++) {
		x=ARRcookies[i].substr(0,ARRcookies[i].indexOf("="));
		y=ARRcookies[i].substr(ARRcookies[i].indexOf("=")+1);
		x=x.replace(/^\s+|\s+$/g,"");
		if (x==c_name)		{
			return unescape(y);
		}
	}
}
//쿠키지우기
function delPopupCookie(fs){
	deleteCookie(fs);
}