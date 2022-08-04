// JavaScript Document 한글




function pagegoto(PG,recordcnt)
{
	document.frm.PAGE.value=PG;
	document.frm.submit();
}


function jqminit() {
	$.extend($.mobile, {
		linkBindingEnabled: false,
			ajaxEnabled: false
	});

}

function toggle_tbody(f_menu) {
	if (document.getElementById(f_menu).style.display == "") {
		document.getElementById(f_menu).style.display = "none"
		$('#detail_'+f_menu).find('span.ui-btn-text').text("상세보기");
	} else {
		document.getElementById(f_menu).style.display = ""
		$('#detail_'+f_menu).find('span.ui-btn-text').text("닫 기");
	}
}

//주문내역_배송정보상세
function toggle_tbody_inner(f_menu) {
	if (document.getElementById(f_menu).style.display == "") {
		document.getElementById(f_menu).style.display = "none"
		$('#detail_'+f_menu).text("상세보기");				//id=""detail_tbody"&i&j&"""
		$('#detail_'+f_menu).addClass("txtBtnC small gray border1 radius3");
	} else {
		document.getElementById(f_menu).style.display = ""
		$('#detail_'+f_menu).text("닫 기");
		$('#detail_'+f_menu).addClass("txtBtnC small gray border1 radius3");
	}
}


function toggle_content(f_menu){
	if (document.getElementById(f_menu).style.display == "table-row") {
		document.getElementById(f_menu).style.display = "none"
	} else {
		document.getElementById(f_menu).style.display = "table-row"
	}
}

//업체별 가격 토글
function toggle_shopPrices(ids) {
	if (document.getElementById(ids).style.display == "") {
		document.getElementById(ids).style.display = "none"
		$(".shopPrices-down").show();
	} else {
		document.getElementById(ids).style.display = ""
		$(".shopPrices-down").hide();
	}
}

function toggle_filter(ids) {
	if (document.getElementById(ids).style.display == "") {
		document.getElementById(ids).style.display = "none"
	} else {
		$("#"+ids).fadeIn(300);
		document.getElementById(ids).style.display = ""
	}
}

function selfConfirmLogin() {
	if (confirm('CS 회원전용 페이지 입니다. 로그인 하시겠습니까?')) {
		location.href= "/common/member_login.asp";
	}
}


// 팝업 ##################################################
	function openPopup(theURL, winName, width, height, remFeatures) {
		var features = "";
		if (typeof winName == "undefined") winName = "";
		if (typeof width != "undefined") features += ((features) ? "," : "")+"width="+width;
		if (typeof height != "undefined") features += ((features) ? "," : "")+"height="+height;
		if (typeof remFeatures != "undefined") features += ((features) ? "," : "")+remFeatures;
		if (features.indexOf("status") < 0) features += ",status=yes";

		var popup = window.open(theURL, winName, features);
		popup.focus();

		return popup;
	}
// 팝업 - 팝업창 사이즈 조정 ##################################################

	function resizePopupWindow(width, height) {
		var strAgent = navigator.userAgent.toLowerCase();
		var bIE7 = (strAgent.indexOf("msie 8.0") != -1);
		window.resizeTo(width+10, height+(bIE7 ? 69 : 49));
	}



/*
	focus_next_input
	onkeyup="focus_next_input(this)"
*/
function focus_next_input(me){
	if (me.value.length != me.maxLength){
		return;
	}
	var elements = me.form.elements;
	for (var i=0, numElements=elements.length; i<numElements; i++) {
		if (elements[i]==me){
			break;
		}
	}
	elements[i+1].focus();
}

//현재 페이지 이름
function getPageName(){
	var pageName = "";
	var tempPageName = window.location.href;
	var strPageName = tempPageName.split("/");
	pageName = strPageName[strPageName.length-1].split("?")[0];
	return pageName;
}

//현 페이지 주소 처리 querystring 포함
function thisPageUrl(){
	let thisPageUrl = "";
	thisPageUrl = location.pathname+location.search;
	return thisPageUrl;
}

//모바일 경로  '/m/'
function mob_path() {
	let mob_path = "";
	mob_path = thisPageUrl().substr(0,3);
	if (mob_path == "/m/") {
		mob_path = "/m";
	}else{
		mob_path = "";
	}
	return mob_path;
}

	/* alert + txt alert */
	function alert2(msg, id, result) {  	 //result t/f
		alert(msg);
		if (result == "T") {
			$(id).text(msg).addClass("blue2").removeClass("red2");
		}else{
			$(id).text(msg).addClass("red2").removeClass("blue2");
		}
	}
	/* txt alert fo json */
	function alertTxt(msg, id, result) {  	 //result t/f
		if (result == "T") {
			$(id).text(msg).addClass("blue2").removeClass("red2");
		}else{
			$(id).text(msg).addClass("red2").removeClass("blue2");
		}
	}

	/* left str cut */
	function left(s,c){
		return s.substr(0,c);
	}
	/* right str cut */
	function right(s,c){
		return s.substr(-c);
	}


		/* 우클릭 방지 */
		document.oncontextmenu=Function("return false");
		document.ondragstart=Function("return false");
		document.onselectstart=Function("return false");
