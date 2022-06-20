	function MM_swapImgRestore() { //v3.0
	  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
	}

	function MM_findObj(n, d) { //v4.01
	  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
		d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
	  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
	  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
	  if(!x && d.getElementById) x=d.getElementById(n); return x;
	}

	function MM_swapImage() { //v3.0
	  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
	   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
	}

	function toggle_content(f_menu)
		{
			 if (document.getElementById(f_menu).style.display == "block")
			 {
				  document.getElementById(f_menu).style.display = "none"
			 }
			 else
			 {
			  document.getElementById(f_menu).style.display = "block"
			 }
		 }


	function pagegoto(PG,recordcnt)
		{
			document.frm.PAGE.value=PG;
			document.frm.submit();
		}
	function fTrans(files,transPath) {
		location.href = "/trans/trans.asp?filename="+encodeURIComponent(files)+"&path="+encodeURIComponent(transPath);
	}


function resizeElement( gW, gH ){
	document.getElementById('swfDiv').style.height = gH+'px';
	document.getElementById('swfDiv').style.width = gW+'px';

}
function resizeElement1(gH ){
	document.getElementById('left_menu').style.height = gH+'px';

}


// top_search
function topSearch() {
	var fs = document.topFrm;
	if (fs.top_search.value == "") {
		alert("검색어를 입력해주세요.");
		fs.top_search.focus();
		return false;
	}
}
function ssearchs() {
	var fss = document.fssearchs;
	if (fss.strSearchs.value == "") {
		alert("검색어를 입력해주세요.");
		fss.strSearchs.focus();
		return false;
	}
	fss.action="/goods/search.asp";
	fss.submit();

}

   function chkNull(obj, msg){
    if(obj.value.split(" ").join("") == ""){
      alert(msg);
      if(obj.type != "hidden" && obj.style.display != "none"){
        obj.focus();
      }
      return false;
    }else{
      return true;
    }
  }
// 숫자 3자리수마다 콤마(,) 찍기 ##################################################
function formatComma(num, pos) {
	if (!pos) pos = 0;  //소숫점 이하 자리수
	var re = /(-?\d+)(\d{3}[,.])/;

	var strNum = stripComma(num.toString());
	var arrNum = strNum.split(".");

	arrNum[0] += ".";

    while (re.test(arrNum[0])) {
        arrNum[0] = arrNum[0].replace(re, "$1,$2");
    }

	if (arrNum.length > 1) {
		if (arrNum[1].length > pos) {
			arrNum[1] = arrNum[1].substr(0, pos);
		}
		return arrNum.join("");
	}
	else {
		return arrNum[0].split(".")[0];
	}
}
function removePreZero(str) {
	var i, result;

	if (str == "0") return str;

	for (i = 0; i<str.length; i++) {
		if (str.substr(i,1) != "0") break;
	}

	result = str.substr(i, str.length-i);
	return result;
}
// 통화형태로 변환 ##################################################
function toCurrency(obj) {
	if (obj.disabled) return false;

	var num = obj.value.stripspace();
	if (num == "") return false;

	if (!checkNum(stripComma(num))) {
		//alert ("숫자만 입력해주세요.");
		num = stripCharFromNum(num, false);
		obj.blur(); obj.focus();
	}
	num = stripCharFromNum(stripComma(num), false);
	num = removePreZero(num);
	obj.value = formatComma(num);
}

// 즐겨찾기 추가 ##################################################
// 예) <a href="javascript:;" onClick="addFavorites('홈페이지', 'http://www.homepage.com');">즐겨찾기 등록</a>
function addFavorites(title, url) {
	if (document.all) { // IE
		window.external.AddFavorite(url, title);
	}
	else if (window.sidebar) { // Firefox
		window.sidebar.addPanel(title, url, "");
	}
	else { // Opera, Safari ...
		alert("현재 브라우져에서는 이용할 수 없습니다.");
		return;
	}
}

// 시작페이지 설정 ##################################################
// 예) <a href="javascript:;" onClick="setStartPage(this, 'http://www.homepage.com');">시작페이지로</a>
function setStartPage(obj, url) {
	if (document.all && window.external) { // IE
		obj.style.behavior = "url(#default#homepage)";
		obj.setHomePage(url);
	}
	else { // Firefox, Opera, Safari ...
		alert("현재 브라우져에서는 이용할 수 없습니다.");
		return;
    }
}

// 주민등록번호 체크
function checkSSH(resNo1, resNo2) {
	var i;

	if (resNo1.value.stripspace() == "" || resNo2.value.stripspace() == "") return false;

	var total = 0;
	var key = new Array(2,3,4,5,6,7,8,9,2,3,4,5);
	var resNo = resNo1.value + resNo2.value;

	if (resNo.length == 13) {
		for (i=0; i<12; i++) {
			total = total + (eval(resNo.charAt(i)) * key[i]);
		}
		result = (11 - (total % 11)) % 10;

		if (eval(resNo.charAt(12)) != result) {
			alert ("유효한 주민등록번호가 아닙니다.");
			resNo1.value = "";
			resNo2.value = "";
			resNo1.focus();
			return false;
		}
		else {
			return true;
		}
	}
	else if (resNo1.value.stripspace().length != 6) {
		alert("주민등록번호 앞자리는 6자리입니다. 다시 입력하세요.");
		resNo1.value = "";
		resNo1.focus();
		return false;
	}
	else if (resNo2.value.stripspace().length != 7) {
		alert("주민등록번호 뒷자리는 7자리입니다. 다시 입력하세요.");
		resNo2.value = "";
		resNo2.focus();
		return false;
	}
}
// 문자열 공백제거 함수 ##################################################
// Ex) str = "    테 스   트   ".stripspace(); => str = "테스트";
String.prototype.stripspace = function() {
	return this.replace(/ /g, "");
}
//빈값 체크
function chkEmpty(obj) {
	if (obj.value.stripspace() == "") {
		return true;
	}
	else {
		return false;
	}
}
String.prototype.replaceAll = function(a, b) {
	var s = this;
	var n1, n2, s1, s2;

	while (true) {
		if ( s=="" || a=="" ) break;
		n1 = s.indexOf(a);
		if ( n1 < 0 ) break;
		n2 = n1 + a.length;
		if ( n1==0 ) {
			s1 = b;
		}
		else {
			s1 = s.substring(0, n1) + b;
		}
		if ( n2 >= s.length ) {
			s2 = "";
		}
		else {
			s2 = s.substring(n2, s.length);
		}
		s = s1 + s2;
	}
	return s;
}
// Trim 함수 ##################################################
// Ex) str = "    테 스트   ".trim(); => str = "테 스트";
String.prototype.trim = function() {
    return this.replace(/(^\s*)|(\s*$)/g, "");
}
// 키 관련 함수 ##################################################
function blockKey(e) {
	var e = window.event || e;
	if (window.event) {
		e.returnValue = false;
	}
	else {
		if (e.which != 8) e.preventDefault(); // 8 : Back Space
	}
}

function blockEnter(e) {
	var e = window.event || e;
	if (window.event) {
		if (e.keyCode == 13) e.returnValue = false;
	}
	else {
		if (e.which == 13) e.preventDefault();
	}
}

function blockNotNumber(e) {
	var e = window.event || e;
	if (window.event) {
		if (e.keyCode < 48 || e.keyCode > 57) e.returnValue = false;
	}
	else {
		if (e.which != 8 && (e.which < 48 || e.which > 57)) e.preventDefault(); // 8 : Back Space
	}
}

function onEnter(e, nextItem) {
	var e = window.event || e;
	var keyCode = (window.event) ? e.keyCode : e.which;
	if (keyCode == 13) {
		if (nextItem) nextItem.focus();
	}
}

// 숫자입력 확인 ##################################################
function numberOnly(obj, isDec) {
	if (!isDec) isDec = false;
	if (obj.disabled) return false;

	var num = obj.value.stripspace();
	if (num == "") return false;

	if (!checkNum(num, isDec)) {
		//alert ("숫자만 입력해주세요.");
		num = stripCharFromNum(num, isDec);
		obj.blur(); obj.focus();
	}
	num = stripCharFromNum(stripComma(num), isDec);

	var arrNum = num.split(".");
	if (arrNum.length > 1) {
		obj.value = arrNum[0]+"."+arrNum[1];
	}
	else {
		obj.value = arrNum[0];
	}
}

// 숫자 확인 ##################################################
function checkNum(value, isDec) {
	var RegExp;

	if (!isDec) isDec = false;
	RegExp = (isDec) ? /^-?[\d\.]*$/ : /^-?[\d]*$/;

	return RegExp.test(value)? true : false;
}
// 숫자 문자열에서 문자열 제거 ##################################################
function stripCharFromNum(value, isDec) {
	var i;
	var minus = "-";
	var nums = "1234567890"+((isDec) ? "." : "");
	var result = "";

	for(i=0; i<value.length; i++) {
		numChk = value.charAt(i);
		if (i == 0 && numChk == minus) {
			result += minus;
		}
		else {
			for(j=0; j<nums.length; j++) {
				if(numChk == nums.charAt(j)) {
					result += nums.charAt(j);
					break;
				}
			}
		}
	}
	return result;
}

// 콤마(,) 제거 ##################################################
function stripComma(str) {
    var re = /,/g;
    return str.replace(re, "");
}
function goNextFocusChk(obj, len, next_item) {
	if (obj.value.stripspace().length == len){
		next_item.focus();
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




// 팝업 height 연산해서 resize
function popup_resize(w,ids) {
	var ua = navigator.userAgent, h = 0, height = 0;
 if(ua.indexOf("MSIE 8") > 0) { h = 40; } // ie8
	else if (ua.indexOf("SV1") > 0){  h = 14; }   // ie6
	else if(ua.indexOf("MSIE 7") > 0) { h = 45; } // ie7

	else if(ua.indexOf("Chrome") > 0) { h = 22; } // chrome
	else if(ua.indexOf("Gecko") > 0 && ua.indexOf("Firefox") <= 0 && ua.indexOf("Netscape") <= 0 ){ h=22; } //safari
	else if(ua.indexOf("Firefox") > 0 && ua.indexOf("rv:1.8") > 0){  h = 22; } // ff2
	else if(ua.indexOf("Firefox") > 0 && ua.indexOf("rv:1.9") > 0){  h = 45; } // ff3
	else if(ua.indexOf("Opera") >= 0 ) { h = 22; }   // opera
	else if(ua.indexOf("Netscape") > 0 ){ h= -2; }
	else { h = 0; }

	alert(ua);


 var ch = document.body.clientHeight,
  sh = document.body.scrollHeight,
  buffer = 0, // header + footer = 100px
  height = 0;

 height = document.getElementById(ids).scrollHeight;
 alert(height);
 height = height + buffer + h;
 alert(height);
 window.resizeTo(w, height);
}



// 아이디 확인 ##################################################
function checkID(value, min, max) {
	var RegExp = /^[a-zA-Z0-9_]*$/i;
	var returnVal = RegExp.test(value) ? true : false;
	if (typeof(min) != "undefined" && value.length < min) returnVal = false;
	if (typeof(max) != "undefined" && value.length > max) returnVal = false;
	return returnVal;
}

// 비밀번호 확인 ##################################################
function checkPass(value, min, max) {
	var RegExp = /^[a-zA-Z0-9]*$/i;
	var returnVal = RegExp.test(value) ? true : false;
	if (typeof(min) != "undefined" && value.length < min) returnVal = false;
	if (typeof(max) != "undefined" && value.length > max) returnVal = false;
	return returnVal;
}

// 영문/숫자 혼용 확인 ##################################################
function checkEngNum(str) {
	var RegExpE = /[a-zA-Z]/i;
	var RegExpN = /[0-9]/;

	return (RegExpE.test(str) && RegExpN.test(str)) ? true : false;
}




// 한글입력 확인(2자리) ##################################################
function checkkorText(value,min) {
	//var RegExp = /[가-힣]/i;
	var RegExp = /^[가-힣]*$/i;
	var returnVal = RegExp.test(value) ? true : false;
	if (typeof(min) != "undefined" && value.length < min) returnVal = false;
	return returnVal;
}
// 특수문자,숫자 확인(제외) ##################################################
function checkSCharNum(value) {
	//var RegExp = /[`|~|!|@|#|$|%|^|&amp|;|*|\\\'\";:\/?0-9]/gi;
	var RegExp = /[`|~|!|@|#|$|%|^|&|;|*|(|)|_|+|=|\\\'\";:\/?0-9]/gi;
	var returnVal = RegExp.test(value) ? false : true;
	return returnVal;
}



// 이메일 확인 ##################################################
function checkEmail(email) {
	if (email.search(/^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/) != -1) {
		return true;
	}
	else {

		return false;
	}
}
function chkMail(obj,msg) {
	if (obj.value.search(/^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/) != -1) {
		return true;
	}
	else {
		alert(msg);
		return false;
	}
}

// 페이지 이동 ##################################################
function gotoUrl(url) {
	if (url.stripspace() != "") {
		location.href = url;
	}
}

function gotoLogin() {
	location.href = "/member/login.asp?redirect="+escape(document.URL);
}

// 텍스트 길이 확인 (일반) ##################################################
function checkTextLen(obj, mLen) {
	if (obj.value.length > mLen){
		alert("1~"+mLen+"자까지 입력이 가능합니다.");
		obj.value = obj.value.substring(0, mLen);
		obj.focus();
		return false;
	}

	return true;
}

// 텍스트 길이 확인 (Byte) ##################################################
function checkTextLenByte(obj, mLen) {
	var i, len;
	var byteLen = 0;
	var value = obj.value;

	for (i=0, len=value.length; i<len; i++) {
		++byteLen;

		if ((value.charCodeAt(i) < 0) || (value.charCodeAt(i) > 127)) ++byteLen;

		if (byteLen > mLen) {
			alert("1~"+(mLen / 2)+"자의 한글, 또는 2~"+mLen+"자의 영문, 숫자, 문장기호로 입력이 가능합니다.");
			obj.value = value.substring(0, i);
			obj.focus();
			return false;
		}
	}

	return true;
}
/// 날자 유효성 확인 ////
	function isDate(strDate){
		var tmpArr;
		var tmpYear, tmpMon, tmpDay;

		if (strDate.length != 10) return false;

		tmpArr = strDate.split("-");

		if (tmpArr.length != 3 ) return false;

		tmpYear = tmpArr[0];
		tmpMon = tmpArr[1];
		tmpDay = tmpArr[2];

		var tDateString = tmpYear+'/'+tmpMon+'/'+tmpDay+' 8:0:0';
		var tmpDate = new Date(tDateString);

		if (isNaN(tmpDate)) return false;

		if (((tmpDate.getFullYear()).toString() == tmpYear) && (tmpDate.getMonth() == parseInt(tmpMon, 10)-1) && (tmpDate.getDate() == parseInt(tmpDay, 10))) {
			return true;
		}
		else {
			return false;
		}
	}

// 패밀리 사이트
	function goto(str) {
	  temp = str.split(",");
	  loc = temp[0];
	  opt = temp[1];
	  if(opt)
		open(loc,"");
	  else
		location = loc;
	}

// png //
function setPng24(obj){
obj.width=obj.height=1;
obj.className=obj.className.replace(/\bpng24\b/i,'');
obj.style.filter="progid:DXImageTransform.Microsoft.AlphaImageLoader(src='"+obj.src+"',sizeMethod='image');"
objsrc='';
return '';
}
// 영문 문자열 확인 ##################################################
function strEngCheck(value){
	var i;

	for(i=0;i<value.length-1;i++){
		// 한글 체크 (한글 ASCII코드 : 12593부터)
		if (value.charCodeAt(i) > 12592) return false;
		// 공백 체크
		if (value.charAt(i) == " ") return false;
	}
	return true;
}
// 파일명 확인 ##################################################
function checkFileName(obj) {
	var result = false;

	if (obj.value.stripspace() != "") {
		var fidx = obj.value.lastIndexOf("\\")+1;
		var filename = obj.value.substr(fidx, obj.value.length);
		result = strEngCheck(filename);
	}

	if (!result) {
		alert("파일명을 반드시 영문 또는 숫자로 해주세요.");
		obj.focus();
		return false;
	}
	return true;
}

// 파일 확장자 ##################################################
function getFileExt(value) {
	if (value != "") {
		var fidx = value.lastIndexOf("\\")+1;
		var filename = value.substr(fidx, value.length);
		var eidx = filename.lastIndexOf(".")+1;

		return filename.substr(eidx, filename.length);
	}
}

// 파일확장자 확인 ##################################################
function checkFileExt(obj, exts, errMsg) {
	var arrExt = exts.toLowerCase().split(",");
	var result = false;

	if (obj.value.stripspace() != "") {
		var ext = getFileExt(obj.value).toLowerCase();

		for (var i=0; i<arrExt.length; i++) {
			if (arrExt[i].trim() == ext) result = true;
		}
	}

	if (!result) {
		alert(errMsg);
		obj.focus();
		return false;
	}
	return true;
}


function imgcheck(imgObj, bool,imgWidth,imgHeight)
{
//	var imgWidth = 650; //** 설정 이미지 폭값
//	var imgHeight = 800; //** 설정 이미지 높이값

	if(bool) //** 이미지가 로딩이 다 되었을경우
	{
		var O_Width = imgObj.width; //** 이미지의 실제 폭
		var O_Height = imgObj.height; //** 이미지의 실제 높이
		var ReWidth = O_Width; //** 변화된 폭 저장 변수
		var ReHeight = O_Height; //** 변화된 높이 저장 변수

	if(ReWidth > imgWidth)
	{
		ReWidth = imgWidth;
		ReHeight = (O_Height * ReWidth) / O_Width;
	}

	if(ReHeight > imgHeight)
	{
		ReWidth = (ReWidth * imgHeight) / ReHeight;
		ReHeight = imgHeight;
	}

	//** 처리
	imgObj.width = ReWidth;
	imgObj.height = ReHeight;
	imgObj.alt = ReWidth +','+ ReHeight;
	}
	else //** 이미지가 해당 경로에 없어 로딩 에러가 생겼을경우
	{
	//** 안보이게 스타일 시트로 처리
	imgObj.style.display = 'none';
	}
}


	// data images base64 체크 ################################
	function checkDataImages(value) {
		var RegExp = /(data:image\/[^;]+;base64[^"]+)/i;
		var returnVal = RegExp.test(value) ? true : false;
		return returnVal;
	}
