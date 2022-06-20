
function fTrans(files,transPath) {
	location.target = "_blank";
	location.href = "/trans/trans.asp?filename="+encodeURIComponent(files)+"&path="+encodeURIComponent(transPath);
}

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
			//resNo1.value = "";
			resNo2.value = "";
			//resNo1.focus();
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

function checkSSHALL(resNo1, resNo2) {
	var i;

	if (resNo1.value.stripspace() == "" || resNo2.value.stripspace() == "") return false;
	var resNo = resNo1.value + resNo2.value;

	//var resNo = juminNo.value.replace("-", "");
	var checkBit = new Array(2,3,4,5,6,7,8,9,2,3,4,5);
	var num7  = resNo.charAt(6);			// 7번째자릿수 (주민 뒷자리 1째글자)
	var num13 = resNo.charAt(12);		// 마지막자릿수
	//alert(num13);
	var total = 0;
	if (resNo.length == 13 ) {
		for (i=0; i<checkBit.length; i++) { // 주민번호 12자리를 키값을 곱하여 합산한다.
			total += resNo.charAt(i)*checkBit[i];
		}
		// 외국인 구분 체크
		if (num7 == 0 || num7 == 9) {		// 내국인 ( 1800년대 9: 남자, 0:여자)
			total = (11-(total % 11)) % 10;
			//alert(total)
		}
		else if (num7 > 4) {				// 외국인 ( 1900년대 5:남자 6:여자  2000년대 7:남자, 8:여자)
			total = (13-(total % 11)) % 10;
			//alert(total)
		}
		else {								// 내국인 ( 1900년대 1:남자 2:여자  2000년대 3:남자, 4:여자)
			total = (11-(total % 11)) % 10;
			//alert(total)
		}

		if(total != num13) {
			alert ("유효한 주민등록번호가 아닙니다!!");
			//resNo1.value = "";
			//resNo2.value = "";
			resNo1.focus();
			return false;					//형식오류
		} else {
			return true;					//OK!
		}

	}
	else if (resNo1.value.stripspace().length != 6) {
		alert("주민등록번호 앞자리는 6자리입니다. 다시 입력하세요!!");
		resNo1.value = "";
		resNo1.focus();
		return false;
	}
	else if (resNo2.value.stripspace().length != 7) {
		alert("주민등록번호 뒷자리는 7자리입니다. 다시 입력하세요!!");
		resNo2.value = "";
		resNo2.focus();
		return false;
	}

}

//===================================================================================
// 미성년자
function addZero(n) {
  return n < 10 ? "0" + n : n;
}
function checkMinor(obj1,obj2) {

	var ThisDate = new Date();
	var year = ThisDate.getYear()-20;
	var month = addZero(ThisDate.getMonth()+1);
	var day = addZero(ThisDate.getDate());

	var ssn2 = obj2.value.substring(0,1);

//	alert(year);
//	alert(month);
//	alert(day);


	if (ssn2 == "1" || ssn2 == "2")
	{
		date2 = "19"+obj1.value;
	} else if (ssn2 == "3" || ssn2 == "4")
	{
		date2 = "20"+obj1.value;
	} else {
		alert("존재하지 않는 주민등록번호입니다.");
		return false;
	}


	var date1 = year +""+ month +""+ day;

//	alert(date1);
//	alert(date2);

	if (date1 < date2)
	{
		alert("미성년자는 가입할 수 없습니다");
		obj1.value = '';
		obj2.value = '';
		obj1.focus();
		return false;
	}
	return true;

}

function checkMinor2(obj1,obj2) {

	var ThisDate = new Date();
	//만19세 이하 주민번호체크

//	var year = ThisDate.getYear()-19;		//크롬 .ie9 버그 -> getFullYear
	var year = ThisDate.getFullYear()-19;
	var month = addZero(ThisDate.getMonth()+1);
	var day = addZero(ThisDate.getDate());

	var ssn2 = obj2.value.substring(0,1);


	if (ssn2 == "1" || ssn2 == "2")
	{
		date2 = "19"+obj1.value;
	} else if (ssn2 == "3" || ssn2 == "4")
	{
		date2 = "20"+obj1.value;
	} else {
		alert("존재하지 않는 주민등록번호입니다.");
		return false;
	}

	var date1 = year +""+ month +""+ day;


	if (date1 < date2)
	{
		alert("미성년자는 가입할 수 없습니다.");
		//obj1.value = '';
		obj2.value = '';
		return false;
	}
	return true;

}
/*
950408 1221113 미
950407 1222229
*/


//생년월일 미성년자체크 YYYYMMDD
function checkMinorBirth(obj1,obj2,obj3) {

	var ThisDate = new Date();
	//만19세 이하 생년월일체크
//	var year = ThisDate.getYear()-19;		//크롬 .ie9 버그 -> getFullYear
	var year = ThisDate.getFullYear()-19;
	var month = addZero(ThisDate.getMonth()+1);
	var day = addZero(ThisDate.getDate());

	var date2 = obj1.value + obj2.value + obj3.value;	//입력된 생년월일
	var date1 = year +""+ month +""+ day;				//미성년 기준일
	//alert(date1);
	//alert(date2);

	if (date1 < date2)
	{
		alert("미성년자는 가입할 수 없습니다!!");
		obj1.value = '';
		obj2.value = '';
		obj3.value = '';
		return false;
	}
	return true;

}



// 아이디 확인 ##################################################
function checkID(value, min, max) {
	var RegExp = /^[a-zA-Z0-9_]*$/i;
	var returnVal = RegExp.test(value) ? true : false;
	if (typeof(min) != "undefined" && value.length < min) returnVal = false;
	if (typeof(max) != "undefined" && value.length > max) returnVal = false;
	return returnVal;
}
// 특정글자로 시작하는 아이디 체크 ################################
function checkID_CSID(value) {
	var RegExp = /^(test|cs_)/i;
	var returnVal = RegExp.test(value) ? true : false;
	//alert(returnVal);
	return returnVal;
}
// 비밀번호 확인 ##################################################
function checkPass(value, min, max) {
	var RegExp = /^[a-zA-Z0-9]*$/i;
	//var RegExp = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{6,20}$/;		//특수문자포함, strFuncJoin.asp 동시변경
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

//영문 확인 S ##################################################
function checkEng(str) {
	const regExp = /^[a-zA-Z]*$/;	// 영어만
	if(regExp.test(str)){
		return true;
	}else{
		return false;
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

// 숫자, '-' 입력 확인 ############################################
function numberOnly2(val,txt1)
{
	var pattern = /(^[0-9\-]+$)/;
	var num = val.value;
	if(!pattern.test(num)){
		//alert('숫자와 - 만 입력 가능합니다. 다시 입력해주세요.');
		alert(txt1);
		val.value = '';
	  event.returnValue = false;
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
// 통화형태로 변환(EN_US) ##################################################
function toCurrencyEN_US(obj) {
	if (obj.disabled) return false;

	var num = obj.value.stripspace();
	if (num == "") return false;

	num = num.replace(/[^0-9\,.]/g,'')
	num = removePreZero(num);
	obj.value = formatComma(num,2);
}

// 소수점 둘째자리까지 입력 ##################################################
function toCurrencyP2(obj) {
	//var prev = "";
	var prev = 0;
	var regexp = /^\d*(\.\d{0,2})?$/;

	if (obj.value.search(regexp)==-1)	{
		obj.value = prev;
		calcSettlePrice();
	}else{
		 prev = obj.value;
	}
	obj.value = removePreZero(obj.value);

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

// 표준완성형 한글체크 + (숫자 + 영문 + 허용문자) ##################################################
function checkkorText2350(value) {
	/*
		허용된 기호(특수문자)
		_  	(	)	,	@	&	-	.	[	]	/
		/s  공백
	*/
	var RegExp = /^[a-zA-Z0-9_(),@&\-\.\[\]\/\s가각간갇갈갉갊감갑값갓갔강갖갗같갚갛개객갠갤갬갭갯갰갱갸갹갼걀걋걍걔걘걜거걱건걷걸걺검겁것겄겅겆겉겊겋게겐겔겜겝겟겠겡겨격겪견겯결겸겹겻겼경곁계곈곌곕곗고곡곤곧골곪곬곯곰곱곳공곶과곽관괄괆괌괍괏광괘괜괠괩괬괭괴괵괸괼굄굅굇굉교굔굘굡굣구국군굳굴굵굶굻굼굽굿궁궂궈궉권궐궜궝궤궷귀귁귄귈귐귑귓규균귤그극근귿글긁금급긋긍긔기긱긴긷길긺김깁깃깅깆깊까깍깎깐깔깖깜깝깟깠깡깥깨깩깬깰깸깹깻깼깽꺄꺅꺌꺼꺽꺾껀껄껌껍껏껐껑께껙껜껨껫껭껴껸껼꼇꼈꼍꼐꼬꼭꼰꼲꼴꼼꼽꼿꽁꽂꽃꽈꽉꽐꽜꽝꽤꽥꽹꾀꾄꾈꾐꾑꾕꾜꾸꾹꾼꿀꿇꿈꿉꿋꿍꿎꿔꿜꿨꿩꿰꿱꿴꿸뀀뀁뀄뀌뀐뀔뀜뀝뀨끄끅끈끊끌끎끓끔끕끗끙끝끼끽낀낄낌낍낏낑나낙낚난낟날낡낢남납낫났낭낮낯낱낳내낵낸낼냄냅냇냈냉냐냑냔냘냠냥너넉넋넌널넒넓넘넙넛넜넝넣네넥넨넬넴넵넷넸넹녀녁년녈념녑녔녕녘녜녠노녹논놀놂놈놉놋농높놓놔놘놜놨뇌뇐뇔뇜뇝뇟뇨뇩뇬뇰뇹뇻뇽누눅눈눋눌눔눕눗눙눠눴눼뉘뉜뉠뉨뉩뉴뉵뉼늄늅늉느늑는늘늙늚늠늡늣능늦늪늬늰늴니닉닌닐닒님닙닛닝닢다닥닦단닫달닭닮닯닳담답닷닸당닺닻닿대댁댄댈댐댑댓댔댕댜더덕덖던덛덜덞덟덤덥덧덩덫덮데덱덴델뎀뎁뎃뎄뎅뎌뎐뎔뎠뎡뎨뎬도독돈돋돌돎돐돔돕돗동돛돝돠돤돨돼됐되된될됨됩됫됴두둑둔둘둠둡둣둥둬뒀뒈뒝뒤뒨뒬뒵뒷뒹듀듄듈듐듕드득든듣들듦듬듭듯등듸디딕딘딛딜딤딥딧딨딩딪따딱딴딸땀땁땃땄땅땋때땍땐땔땜땝땟땠땡떠떡떤떨떪떫떰떱떳떴떵떻떼떽뗀뗄뗌뗍뗏뗐뗑뗘뗬또똑똔똘똥똬똴뙈뙤뙨뚜뚝뚠뚤뚫뚬뚱뛔뛰뛴뛸뜀뜁뜅뜨뜩뜬뜯뜰뜸뜹뜻띄띈띌띔띕띠띤띨띰띱띳띵라락란랄람랍랏랐랑랒랖랗래랙랜랠램랩랫랬랭랴략랸럇량러럭런럴럼럽럿렀렁렇레렉렌렐렘렙렛렝려력련렬렴렵렷렸령례롄롑롓로록론롤롬롭롯롱롸롼뢍뢨뢰뢴뢸룀룁룃룅료룐룔룝룟룡루룩룬룰룸룹룻룽뤄뤘뤠뤼뤽륀륄륌륏륑류륙륜률륨륩륫륭르륵른를름릅릇릉릊릍릎리릭린릴림립릿링마막만많맏말맑맒맘맙맛망맞맡맣매맥맨맬맴맵맷맸맹맺먀먁먈먕머먹먼멀멂멈멉멋멍멎멓메멕멘멜멤멥멧멨멩며멱면멸몃몄명몇몌모목몫몬몰몲몸몹못몽뫄뫈뫘뫙뫼묀묄묍묏묑묘묜묠묩묫무묵묶문묻물묽묾뭄뭅뭇뭉뭍뭏뭐뭔뭘뭡뭣뭬뮈뮌뮐뮤뮨뮬뮴뮷므믄믈믐믓미믹민믿밀밂밈밉밋밌밍및밑바박밖밗반받발밝밞밟밤밥밧방밭배백밴밸뱀뱁뱃뱄뱅뱉뱌뱍뱐뱝버벅번벋벌벎범법벗벙벚베벡벤벧벨벰벱벳벴벵벼벽변별볍볏볐병볕볘볜보복볶본볼봄봅봇봉봐봔봤봬뵀뵈뵉뵌뵐뵘뵙뵤뵨부북분붇불붉붊붐붑붓붕붙붚붜붤붰붸뷔뷕뷘뷜뷩뷰뷴뷸븀븃븅브븍븐블븜븝븟비빅빈빌빎빔빕빗빙빚빛빠빡빤빨빪빰빱빳빴빵빻빼빽뺀뺄뺌뺍뺏뺐뺑뺘뺙뺨뻐뻑뻔뻗뻘뻠뻣뻤뻥뻬뼁뼈뼉뼘뼙뼛뼜뼝뽀뽁뽄뽈뽐뽑뽕뾔뾰뿅뿌뿍뿐뿔뿜뿟뿡쀼쁑쁘쁜쁠쁨쁩삐삑삔삘삠삡삣삥사삭삯산삳살삵삶삼삽삿샀상샅새색샌샐샘샙샛샜생샤샥샨샬샴샵샷샹섀섄섈섐섕서석섞섟선섣설섦섧섬섭섯섰성섶세섹센셀셈셉셋셌셍셔셕션셜셤셥셧셨셩셰셴셸솅소속솎손솔솖솜솝솟송솥솨솩솬솰솽쇄쇈쇌쇔쇗쇘쇠쇤쇨쇰쇱쇳쇼쇽숀숄숌숍숏숑수숙순숟술숨숩숫숭숯숱숲숴쉈쉐쉑쉔쉘쉠쉥쉬쉭쉰쉴쉼쉽쉿슁슈슉슐슘슛슝스슥슨슬슭슴습슷승시식신싣실싫심십싯싱싶싸싹싻싼쌀쌈쌉쌌쌍쌓쌔쌕쌘쌜쌤쌥쌨쌩썅써썩썬썰썲썸썹썼썽쎄쎈쎌쏀쏘쏙쏜쏟쏠쏢쏨쏩쏭쏴쏵쏸쐈쐐쐤쐬쐰쐴쐼쐽쑈쑤쑥쑨쑬쑴쑵쑹쒀쒔쒜쒸쒼쓩쓰쓱쓴쓸쓺쓿씀씁씌씐씔씜씨씩씬씰씸씹씻씽아악안앉않알앍앎앓암압앗았앙앝앞애액앤앨앰앱앳앴앵야약얀얄얇얌얍얏양얕얗얘얜얠얩어억언얹얻얼얽얾엄업없엇었엉엊엌엎에엑엔엘엠엡엣엥여역엮연열엶엷염엽엾엿였영옅옆옇예옌옐옘옙옛옜오옥온올옭옮옰옳옴옵옷옹옻와왁완왈왐왑왓왔왕왜왝왠왬왯왱외왹왼욀욈욉욋욍요욕욘욜욤욥욧용우욱운울욹욺움웁웃웅워웍원월웜웝웠웡웨웩웬웰웸웹웽위윅윈윌윔윕윗윙유육윤율윰윱윳융윷으윽은을읊음읍읏응읒읓읔읕읖읗의읜읠읨읫이익인일읽읾잃임입잇있잉잊잎자작잔잖잗잘잚잠잡잣잤장잦재잭잰잴잼잽잿쟀쟁쟈쟉쟌쟎쟐쟘쟝쟤쟨쟬저적전절젊점접젓정젖제젝젠젤젬젭젯젱져젼졀졈졉졌졍졔조족존졸졺좀좁좃종좆좇좋좌좍좔좝좟좡좨좼좽죄죈죌죔죕죗죙죠죡죤죵주죽준줄줅줆줌줍줏중줘줬줴쥐쥑쥔쥘쥠쥡쥣쥬쥰쥴쥼즈즉즌즐즘즙즛증지직진짇질짊짐집짓징짖짙짚짜짝짠짢짤짧짬짭짯짰짱째짹짼쨀쨈쨉쨋쨌쨍쨔쨘쨩쩌쩍쩐쩔쩜쩝쩟쩠쩡쩨쩽쪄쪘쪼쪽쫀쫄쫌쫍쫏쫑쫓쫘쫙쫠쫬쫴쬈쬐쬔쬘쬠쬡쭁쭈쭉쭌쭐쭘쭙쭝쭤쭸쭹쮜쮸쯔쯤쯧쯩찌찍찐찔찜찝찡찢찧차착찬찮찰참찹찻찼창찾채책챈챌챔챕챗챘챙챠챤챦챨챰챵처척천철첨첩첫첬청체첵첸첼쳄쳅쳇쳉쳐쳔쳤쳬쳰촁초촉촌촐촘촙촛총촤촨촬촹최쵠쵤쵬쵭쵯쵱쵸춈추축춘출춤춥춧충춰췄췌췐취췬췰췸췹췻췽츄츈츌츔츙츠측츤츨츰츱츳층치칙친칟칠칡침칩칫칭카칵칸칼캄캅캇캉캐캑캔캘캠캡캣캤캥캬캭컁커컥컨컫컬컴컵컷컸컹케켁켄켈켐켑켓켕켜켠켤켬켭켯켰켱켸코콕콘콜콤콥콧콩콰콱콴콸쾀쾅쾌쾡쾨쾰쿄쿠쿡쿤쿨쿰쿱쿳쿵쿼퀀퀄퀑퀘퀭퀴퀵퀸퀼큄큅큇큉큐큔큘큠크큭큰클큼큽킁키킥킨킬킴킵킷킹타탁탄탈탉탐탑탓탔탕태택탠탤탬탭탯탰탱탸턍터턱턴털턺텀텁텃텄텅테텍텐텔템텝텟텡텨텬텼톄톈토톡톤톨톰톱톳통톺톼퇀퇘퇴퇸툇툉툐투툭툰툴툼툽툿퉁퉈퉜퉤튀튁튄튈튐튑튕튜튠튤튬튱트특튼튿틀틂틈틉틋틔틘틜틤틥티틱틴틸팀팁팃팅파팍팎판팔팖팜팝팟팠팡팥패팩팬팰팸팹팻팼팽퍄퍅퍼퍽펀펄펌펍펏펐펑페펙펜펠펨펩펫펭펴편펼폄폅폈평폐폘폡폣포폭폰폴폼폽폿퐁퐈퐝푀푄표푠푤푭푯푸푹푼푿풀풂품풉풋풍풔풩퓌퓐퓔퓜퓟퓨퓬퓰퓸퓻퓽프픈플픔픕픗피픽핀필핌핍핏핑하학한할핥함합핫항해핵핸핼햄햅햇했행햐향허헉헌헐헒험헙헛헝헤헥헨헬헴헵헷헹혀혁현혈혐협혓혔형혜혠혤혭호혹혼홀홅홈홉홋홍홑화확환활홧황홰홱홴횃횅회획횐횔횝횟횡효횬횰횹횻후훅훈훌훑훔훗훙훠훤훨훰훵훼훽휀휄휑휘휙휜휠휨휩휫휭휴휵휸휼흄흇흉흐흑흔흖흗흘흙흠흡흣흥흩희흰흴흼흽힁히힉힌힐힘힙힛힝]*$/i;

	for( var i=0; i<value.length; i++){
		if(value.charAt(i) != " " && RegExp.test(value.charAt(i)) == false ){
		 alert("'"+value.charAt(i) + "' 는(은) 입력불가능한 문자입니다.\n\n한글입력시 표준한글로 입력해주세요.\nex) 샾 → 샵");
		 break;
		}
	}
	var returnVal = RegExp.test(value) ? false : true;
	return returnVal;
}



//공백제거
function noSpace(inputName){
	var inputValue = $('input[name="'+inputName+'"]').val().replace(/ /gi, '');
	$('input[name="'+inputName+'"]').val(inputValue);
}

// 한글입력금지(toNoKorText)
function toNoKorText(obj) {
	if (obj.disabled) return false;

	var text = obj.value.stripspace();
	if (text == "") return false;

	text = text.replace(/[ㄱ-ㅎ|ㅏ-ㅣ|가-힝|.,]/g,'')
	obj.value = text;
}



/* Coin Currency Formatter */
//var CoinFormatter = new Intl.NumberFormat('de-DE', {
var CoinFormatter = new Intl.NumberFormat('en-US', {
	//style: 'currency', currency: 'USD' ,
	minimumFractionDigits: 8,
	maximumFractionDigits: 8
});


var CoinFormatter_2 = new Intl.NumberFormat('en-US', {
	//style: 'currency', currency: 'USD' ,
	minimumFractionDigits: 2,
	maximumFractionDigits: 2
});

var CoinFormatter_INT = new Intl.NumberFormat('en-US', {
	//style: 'currency', currency: 'USD' ,
	minimumFractionDigits: 0,
	maximumFractionDigits: 0
});




// 생년월일 유효성
	function chkValidBirthDate(dateStr) {
		var year = Number(dateStr.substr(0,4));
		var month = Number(dateStr.substr(4,2));
		var day = Number(dateStr.substr(6,2));
		var today = new Date();
		var yearNow = today.getFullYear();
		var adultYear = yearNow-18;
		//console.log(dateStr.length);
		if (dateStr.length == 8) {
		// 연도의 경우 1900 보다 작거나 yearNow 보다 크다면 false를 반환합니다.
			if (year < 1900 || year > adultYear){
			  //alert(adultYear+"년생 이전 출생자만 등록 가능합니다.");
			  return false;
			}
			if (month < 1 || month > 12) {
			  //alert("달은 1월부터 12월까지 입력 가능합니다.");
			  return false;
			}
			if (day < 1 || day > 31) {
			  //alert("일은 1일부터 31일까지 입력가능합니다.");
			  return false;
			}
			if ((month==4 || month==6 || month==9 || month==11) && day==31) {
			  //alert(month+"월은 31일이 존재하지 않습니다.");
			  return false;
			}
			if (month == 2) {
				var isleap = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
				if (day>29 || (day==29 && !isleap)) {
					//alert(year + "년 2월은  " + day + "일이 없습니다.");
					return false;
				}
			}
			return true;
		} else {
			alert("정확한 생년월일 8자리를 입력해주세요.");
			return false;
		}
	}

// 사업자번호 유효성
	function chkBusinessNo(bNo)
	{
		//첫자리체크
		var bNo1 = Number(bNo.substr(0,1));
		if (bNo1 < 1 || bNo1 > 6 ) {
			//console.log("nope");
			return false;
		}

		// 넘어온 값의 정수만 추츨하여 문자열의 배열로 만들고 10자리 숫자인지 확인합니다.
		if ((bNo = (bNo+'').match(/\d{1}/g)).length != 10) { return false; }

		// 합 / 체크키
		var sum = 0, key = [1, 3, 7, 1, 3, 7, 1, 3, 5];

		// 0 ~ 8 까지 9개의 숫자를 체크키와 곱하여 합에더합니다.
		for (var i = 0 ; i < 9 ; i++) { sum += (key[i] * Number(bNo[i])); }
		// 각 8번배열의 값을 곱한 후 10으로 나누고 내림하여 기존 합에 더합니다.
		// 다시 10의 나머지를 구한후 그 값을 10에서 빼면 이것이 검증번호 이며 기존 검증번호와 비교하면됩니다.
		// 체크섬구함

		var chkSum = 0;
		chkSum = Math.floor(key[8] * Number(bNo[8]) / 10);

		// 체크섬 합계에 더해줌
		sum +=chkSum;
		var reminder = (10 - (sum % 10)) % 10;

		//값 비교
		if(reminder==Number(bNo[9])) return true;
		return false;
	}


//휴대전화 or 일반전화 유효성 확인
	function chkMobTel(value) {
		//var RegExp = /^(01[016789]{1}|02|0[3-9]{1}[0-9]{1})-?[0-9]{3,4}-?[0-9]{4}$/;
		var RegExp = /^(01[016789]{1}|02|0[3-9]{1}[0-9]{1})[0-9]{3,4}[0-9]{4}$/;
		var returnVal = RegExp.test(value) ? true : false;
		return returnVal;
	}
//휴대전화 유효성 확인
	function chkMob(value) {
		var RegExp = /^(01[016789]{1})[0-9]{3,4}[0-9]{4}$/;
		var returnVal = RegExp.test(value) ? true : false;
		return returnVal;
	}
//일반전화 유효성 확인
	function chkTel(value) {
		var RegExp = /^(02|0[3-9]{1}[0-9]{1})[0-9]{3,4}[0-9]{4}$/;
		var returnVal = RegExp.test(value) ? true : false;
		return returnVal;
	}
//크롬 input number
function maxLengthCheck(object){
	if (object.value.length > object.maxLength){
		object.value = object.value.slice(0, object.maxLength);
	}
}

// data images base64 체크 ################################
function checkDataImages(value) {
	var RegExp = /(data:image\/[^;]+;base64[^"]+)/i;
	var returnVal = RegExp.test(value) ? true : false;
	return returnVal;
}
