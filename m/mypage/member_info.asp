<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	'PAGE_SETTING = "MYPAGE"
	PAGE_SETTING = "MYOFFICE"
	INFO_MODE	 = "MEMBER2-4"
	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1)

	ISLEFT = "T"
	ISSUBTOP = "T"
	ISSUBVISUAL = "T"
	view = 1
	mNum = 1
	sNum = view

%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<link rel="stylesheet" href="/m/css/member_info.css?v0" />
<script type="text/javascript" src="/m/js/check.js"></script>
<!-- <script type="text/javascript" src="member_info.js"></script> -->
<script type="text/javascript">
<!--

	$(document).ready(function() {
		//체크박스 해제
		$("input[type=checkbox]:checked").each(function() {
			$(this).prop("checked",false);
		});
	});

	//CPNO 입력토글
	function toggle_tr(f_menu)
	{
		var f = document.cfrm;

		 if (document.getElementById(f_menu).style.display == "table-row")
		 {
			document.getElementById(f_menu).style.display = "none"
			//초기화
			$('#cpno_Check').val("F");
			$('#chk_CpnoNum1').val("");
			$('#chk_CpnoNum2').val("");
			$('#cpnoCheck').text("");		//text 삭제

		 } else {
			document.getElementById(f_menu).style.display = "table-row"
			//초기화
			f.ssh2.value		= '';
			$('#cpno_Check').val("F");
			$('#chk_CpnoNum1').val("");
			$('#chk_CpnoNum2').val("");
		 }
	 }

	//CPNO 입력토글2
	function toggle_flex(f_menu)
	{
		var f = document.cfrm;

		 if (document.getElementById(f_menu).style.display == "flex")
		 {
			document.getElementById(f_menu).style.display = "none"
			//초기화
			$('#cpno_Check').val("F");
			$('#chk_CpnoNum1').val("");
			$('#chk_CpnoNum2').val("");
			$('#cpnoCheck').text("");		//text 삭제

		 } else {
			document.getElementById(f_menu).style.display = "flex"
			//초기화
			f.ssh2.value		= '';
			$('#cpno_Check').val("F");
			$('#chk_CpnoNum1').val("");
			$('#chk_CpnoNum2').val("");
		 }
	 }

	//SSN check  제이준몽골
	function join_SSNcheck() {
		var ids = document.cfrm.cpno_Global;
		if (ids.value == '')
		{
			alert("Please enter SSN");
			ids.focus();
			return false;
		}
		if (ids.value.stripspace().length < 9) {
			alert("Please enter SSN Number correctly!");
			ids.focus();
			return false;
		}
		createRequest();
		var url = '/common/ajax_SSNcheck.asp?ids='+ids.value;
		request.open("GET",url,true);
		request.onreadystatechange = function ChgContent() {
			if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
				if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
					var newContent = request.responseText;
					document.getElementById("SSNCheck").innerHTML = newContent;
			}
		  }
		}
		request.send(null);
	}

	//CPNO CHECK
	function join_cpnoCheck() {
		var ssh1 = document.cfrm.ssh1;
		var ssh2 = document.cfrm.ssh2;

		for (var i=1; i<=2; i++) {
			objItem = eval('ssh'+i);
			if (chkEmpty(objItem)) {
				alert("주민등록번호를 입력해 주세요.");
				objItem.focus();
				return false;
			}
		}
		if (!checkSSHs(ssh1, ssh2)) return false;
		//if (!checkSSHALL(ssh1, ssh2)) return false;
		if (!checkMinor2(ssh1, ssh2)) return false;
		/*
		createRequest();
		var url = '/common/ajax_cpnoCheck.asp?ssh1='+ssh1.value+'&ssh2='+ssh2.value;

		request.open("GET",url,true);
		request.onreadystatechange = function ChgContent() {
			if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
				if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
					var newContent = request.responseText;
					document.getElementById("cpnoCheck").innerHTML = newContent;
				}
			}
		}
		request.send(null);
		*/
		var f = document.cfrm;
		$.ajax({
			type: "POST"
			,url: "/common/ajax_cpnoCheck.asp"
			,data: {
				 "ssh1"	: f.ssh1.value
				,"ssh2"	: f.ssh2.value
			}
			,success: function(data) {
				var dataArray = data.split("||");
				if (dataArray[0] == 'IMPOSSIBLE')
				{
					$('#cpno_Check').val("F");
					$('#chk_CpnoNum1').val("");
					$('#chk_CpnoNum2').val("");
					$("#cpnoCheck").html(dataArray[1]);
					//$("#cpnoCheck").html("<span class=\"red tweight\">이미 CS에 등록된 주민번호입니다.</span>");

				} else if (dataArray[0] == 'POSSIBLE') {
					//성공시 상단 체크값 세팅
					$('#cpno_Check').val("T");
					$('#chk_CpnoNum1').val(f.ssh1.value);
					$('#chk_CpnoNum2').val(f.ssh2.value);
					$("#cpnoCheck").html(dataArray[1]);
					//$("#cpnoCheck").html("<span class=\"blue tweight\">등록가능한 주민번호입니다.</span>");
				}

			}
			,error:function(data) {
				//console.log(data);
				$("#cpnoCheck").html("<span class=\"red\">ajax 처리 중 에러가 발생하였습니다. 다시 시도해주세요!.</span>");
				//alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
			}
		});

	}

	function checkChgPass(item) {
		var f = document.cfrm;
		var objBody = document.getElementById("bodyPass");

		if (item.checked) {
			objBody.style.display = "";
		} else {
			f.newPass.value = "";
			f.newPass2.value = "";
			objBody.style.display = "none";
		}
	}

	function openzip() {
		openPopup("pop_Zipcode.asp", "Zipcodes", 0, 0,"");
	}

	function memInfoChk() {

		var f = document.cfrm;
		var objItem;

		if (chkEmpty(f.strPass)) {
			alert("<%=LNG_JS_PASSWORD%>");
			f.strPass.focus();
			return false;
		}


	//	if (f.isChgPass.checked) {
		if ($("input[name=isChgPass]:checked").val() == 'T') {

			if (chkEmpty(f.newPass)) {
				alert("<%=LNG_MYPAGE_INFO_JS_TEXT02%>");
				f.newPass.focus();
				return false;
			}
			if (!checkPass(f.newPass.value, 6, 20) || !checkEngNum(f.newPass.value)){
				alert("<%=LNG_JS_PASSWORD_FORM_CHECK%>");
				f.newPass.focus();
				return false;
			}
			if (chkEmpty(f.newPass2)) {
				alert("<%=LNG_MYPAGE_INFO_JS_TEXT04%>");
				f.newPass2.focus();
				return false;
			}
			if (f.newPass.value != f.newPass2.value) {
				alert("<%=LNG_MYPAGE_INFO_JS_TEXT05%>");
				f.newPass.focus();
				return false;
			}
		}

		//▣cpno체크
		if (f.CPNO_CHANGE_TF.value == "T") {

			//동의 체크시 수행
			if (f.agreement.checked) {
				var objItem;
				for (var i=1; i<=2; i++) {
					objItem = eval('f.ssh'+i);
					if (chkEmpty(objItem)) {
						alert("주민등록번호를 입력해 주세요!!");
						objItem.focus();
						return false;
					}
				}
				if (!checkSSHs(f.ssh1, f.ssh2)) return false;
				//if (!checkSSHALL(f.ssh1, f.ssh2)) return false;
				if (!checkMinor2(f.ssh1, f.ssh2)) return false;

				//checkbox체크/해제시 상단값 비교
				if (f.cpno_Check.value == 'F' ){
					alert("주민번호 중복체크를해주세요!!");
					return false;
				}
				if (f.cpno_Check.value == 'T' ){
					if (f.ssh1.value != f.chk_CpnoNum1.value || f.ssh2.value != f.chk_CpnoNum2.value ){
						alert("중복확인한 주민번호와 현재 입력한 주민번호가 틀립니다. \n\n다시한번 중복체크를 해주세요.!!!");
						return false;
					}
				}

				/*
				if (f.cpnoCheck.value == 'F' ){
					alert("주민번호 중복체크를해주세요!");
					return false;
				}

				if (f.ssh1.value != f.chkCpnoNum1.value || f.ssh2.value != f.chkCpnoNum2.value ){
					alert("중복확인한 주민번호와 현재 입력한 주민번호가 틀립니다. \n\n다시한번 중복체크를 해주세요.");
					return false;
				}
				*/
			}
		}

		<%If UCase(DK_MEMBER_NATIONCODE) = "MN" Then%>		//제이준 몽골
			//개인식별번호 필수
			if (f.cpno_Global_ori.value == "") {

				if (f.cpno_Global.value == "")
				{
					alert("<%=LNG_JOINSTEP03_U_JS30%>");
					f.cpno_Global.focus();
					return false;
				} else {

					if (f.cpno_Global.value != "")
					{
						if (f.cpno_Global.value.stripspace().length < 9) {
							alert("<%=LNG_JOINSTEP03_U_JS29%>");
							f.cpno_Global.focus();
							return false;
						}
						if (f.SSNcheck.value == 'F'){
							alert("<%=LNG_JOINSTEP03_U_JS31%>");
							f.cpno_Global.focus();
							return false;
						}
						if (f.cpno_Global.value != f.chkSSN.value){
							alert("<%=LNG_JOINSTEP03_U_JS32%>");
							$("#SSNCheck").text("<%=LNG_JS_DUPLICATION_CHECK%>").css({"color":"red","font-weight":"bold"});
							f.cpno_Global.focus();
							return false;
						}
					}
				}

			}
		<%End If%>


	//	if (chkEmpty(f.strZip) || chkEmpty(f.strADDR1)) {
		if (chkEmpty(f.strADDR1)) {
			alert("<%=LNG_JS_ADDRESS1%>");
			f.strADDR1.focus();
			return false;
		}

		if (chkEmpty(f.strADDR2)) {
			alert("<%=LNG_JS_ADDRESS2%>");
			f.strADDR2.focus();
			return false;
		}
	/*
		for (i=1; i<=3; i++) {
			objItem = eval("f.tel_num"+i);
			if (chkEmpty(objItem)) {
				alert("<%=LNG_JS_TEL%>");
				objItem.focus();
				return false;
			}
		}
	*/
	<%If DK_MEMBER_TYPE = "COMPANY" Then%>

		<%If UCase(DK_MEMBER_NATIONCODE) = "KR" Then%>
			if (!chkMob(f.strMobile.value)) {
				alert("<%=LNG_JS_MOBILE_FORM_CHECK%>");
				f.strMobile.focus();
				return false;
			}
			if (!chkEmpty(f.strTel)) {
				if (!chkTel(f.strTel.value)) {
					alert("정확한 전화번호를 입력해 주세요");
					f.strTel.focus();
					return false;
				}
			}
		<%Else%>
			if (f.strMobile.value.length < 10) {
				alert("<%=LNG_JS_MOBILE_FORM_CHECK%>");
				f.strMobile.focus();
				return false;
			}
		<%End If%>

	<%ELSE%>
		for (i=1; i<=3; i++) {
			objItem = eval("f.mob_num"+i);
			if (chkEmpty(objItem)) {
				alert("<%=LNG_JS_MOBILE%>");
				objItem.focus();
				return false;
			}
		}
	<%END IF%>


		if (f.strEmail.value == "")
		{
			/*
			alert2("<%=LNG_JS_EMAIL%>", "#emailCheckTXT", "F");
			f.strEmail.focus();
			return false;
			*/
		} else {

			if (!checkEmail(f.strEmail.value)) {
				alert2("<%=LNG_JS_EMAIL_CONFIRM%>", "#emailCheckTXT", "F");
				f.strEmail.focus();
				return false;
			}

			if (f.strEmail.value != f.ori_strEmail.value) {   //이메일 변경 시

				if (f.emailCheck.value == 'F'){
					alert2("<%=LNG_JS_EMAIL_DOUBLE_CHECK%>", "#emailCheckTXT", "F");
					f.strEmail.focus();
					return false;
				}
				if (f.strEmail.value != f.chkEmail.value){
					alert2("<%=LNG_JS_EMAIL_DOUBLE_CHECK2%>", "#emailCheckTXT", "F");
					f.strEmail.focus();
					return false;
				}

			}
		}

		/*
		if (chkEmpty(f.mailh)) {
			alert("<%=LNG_JS_EMAIL1%>");
			f.mailh.focus();
			return false;
		}
		if (chkEmpty(f.mailt)) {
			alert("<%=LNG_JS_EMAIL2%>");
			f.mailt.focus();
			return false;
		}
		*/
		if (chkEmpty(f.birthYY) || chkEmpty(f.birthMM) || chkEmpty(f.birthDD)) {
			alert("<%=LNG_JS_BIRTH%>");
			f.birthYY.focus();
			return false;
		}
		if (f.isSolar[0].checked == false && f.isSolar[1].checked == false ) {
			alert("<%=LNG_MYPAGE_INFO_JS_TEXT14%>");
			f.isSolar[0].focus();
			return false;
		}

		if (confirm("<%=LNG_MYPAGE_INFO_JS_TEXT15%>")) {
			//f.submit();
		} else {
			return false;
		}
	}



	function openzip_mjp2EN() {
		openPopup("/m/common/pop_ZipCode_JP2EN.asp", "Zipcodes");		//일본주소(영문)
	}



	//■계좌인증
	function Toggle_BankReg() {
		/*
		if ($('#cpno_Check').val() == "T") {
			$("#bankReg").toggle();
		} else {
			alert("정상 주민등록번호 저장 후 계좌인증(변경)이 가능합니다.");
		}
		*/
		$("#bankReg").toggle();
	}
	function bankAuth() {
		var f = document.cfrm;
		var bankCode = $("select[name=bankCode]");
		var BankNumber = $("input[name=BankNumber]");

		if (bankCode.val() == '')
		{
			alert("은행을 선택해주세요");
			bankCode.focus();
			return false;
		}
		if (BankNumber.val() == '')
		{
			alert("계좌번호를 입력해주세요");
			BankNumber.focus();
			return false;
		}

		$.ajax({
			type: "POST"
			,url: "/ajax/ajax_member_info_bank.asp"
			,data: {
				 "bankCode"	: bankCode.val()
				,"BankNumber"	: BankNumber.val()
			}
			,success: function(data) {
				var obj = $.parseJSON(data);
				alert(obj.message);
				if (obj.statusCode == '0000')
				{
					//location.href="/mypage/member_info.asp";
					$("#bankInfo").html(obj.result).addClass("blue");
					$("#ajaxTF").val("T");
					$("#TempDataNum").val(obj.data);
					$("#Reg_bankaccnt_TF").val("T");

				} else {
					$("#bankInfo").html(obj.result).addClass("red");
					$("#ajaxTF").val("");
					$("#TempDataNum").val("");
					$("#Reg_bankaccnt_TF").val("F");

				}

			}
			,error:function(data) {
				var obj = $.parseJSON(data);
				alert(obj.message);
				//$("#bankResult").html(obj.result);
			}
		});

	}
	function bankAccountKey(event){
		var strVal = $("input[name=BankNumber]").val();
		if (event.keyCode == 32){
			$("input[name=BankNumber]").val($.trim(strVal));
		}
	}

	function join_emailCheck() {
		var f = document.cfrm;
		if (f.strEmail.value == '')
		{
			alert2("메일을 입력해 주세요.", "#emailCheckTXT", "F");
			f.strEmail.focus();
			return false;
		}
		if (!checkEmail(f.strEmail.value)) {
			alert2("형식에 맞지 않는 이메일 주소입니다.\n\n이메일 주소를 정확하게 입력해 주세요.", "#emailCheckTXT", "F");
			f.strEmail.focus();
			return false;
		}
		$.ajax({
			type: "POST"
			,async : false
			,url: "/common/ajax_emailCheck_mypage.asp"
			,data: {
				"email" : f.strEmail.value
			}
			,success: function(jsonData) {
				//console.log(jsonData);
				var json = $.parseJSON(jsonData);

				if (json.result == "success")
				{
					if (json.emailCheck == "T") {
						//$("#emailCheckTXT").text(json.message).addClass("blue2").removeClass("red2");
						alertTxt(json.message, "#emailCheckTXT", "T");
						$("input[name=emailCheck]").val("T");
						$("input[name=chkEmail]").val($("input[name=strEmail]").val());

					}else{
						//$("#emailCheckTXT").text(json.message).addClass("red2").removeClass("blue2");
						alertTxt(json.message, "#emailCheckTXT", "F");
						$("input[name=emailCheck]").val("F");
					}
				}
			}
			,error:function(jsonData) {
				alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+jsonData.status+" "+jsonData.statusText+" "+jsonData.responseText);
			}

		});

	}

//-->
</script>
<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>
<script src="/jscript/daumPostCode.js"></script>
</head>
<body onunload="">
<!--#include virtual = "/m/_include/header.asp"-->
<%Select Case DK_MEMBER_TYPE%>
<%	Case "MEMBER","ADMIN","OPERATOR","SADMIN"%><!--#inc lude file = "member_info_member.asp"-->
<%	Case "COMPANY"%><!--#include file = "member_info_company.asp"-->
<%	Case Else%>
<%End Select%>

<!--#include virtual = "/m/_include/modal_config.asp" -->
<!--#include virtual = "/m/_include/LayerAddress.asp"-->
<!--#include virtual = "/m/_include/copyright.asp"-->
