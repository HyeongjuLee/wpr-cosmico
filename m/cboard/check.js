





// Trim 함수 ##################################################
// Ex) str = "    테 스트   ".trim(); => str = "테 스트";
String.prototype.trim = function() {
    return this.replace(/(^\s*)|(\s*$)/g, "");
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
function checkSSHs(resNo1, resNo2) {
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

			return false;
		}
		else {
			return true;
		}
	}
	else if (resNo1.value.stripspace().length != 6) {
		alert("주민등록번호 앞자리는 6자리입니다. 다시 입력하세요.");
		return false;
	}
	else if (resNo2.value.stripspace().length != 7) {
		alert("주민등록번호 뒷자리는 7자리입니다. 다시 입력하세요.");
		return false;
	}
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
// 체크 확인 ##################################################
function blockNotNumber(e) {
	var e = window.event || e;
	if (window.event) {
		if (e.keyCode < 48 || e.keyCode > 57) e.returnValue = false;
	}
	else {
		if (e.which != 8 && (e.which < 48 || e.which > 57)) e.preventDefault(); // 8 : Back Space
	}
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
		obj.focus();
		return false;
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