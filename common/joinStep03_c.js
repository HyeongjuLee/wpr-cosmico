/***************************************************
JOIN STEP 03. JAVASCRIPT
***************************************************/

	function ajax_accountChk() {
		createRequest();
		var url = 'joinStep03_ajax.asp';
		var f = document.jfrm;
/*
		if (f.centerName.value == '')
		{
			alert("센터값이 없습니다.");
			document.location.href = "joinStep01.asp";
			return;
		}

		if (f.centerCode.value == '')
		{
			alert("센터등록코드를 입력해주세요");
			document.location.href = "joinStep01.asp";
			return;
		}
*/
		if (f.strBankCode.value == '')
		{
			alert("은행을 선택해주세요..");
			return;
		}

		if (f.strBankNum.value == '')
		{
			alert("계좌번호를 입력해주세요..");
			f.strBankNum.focus();
			return;
		}
		if (f.strBankOwner.value == '')
		{
			alert("예금주를 입력해주세요..");
			f.strBankOwner.focus();
			return;
		}
		var objItem;
		for (var i=1; i<=2; i++) {
			objItem = eval('f.strSSH'+i);
			if (chkEmpty(objItem)) {
				alert("주민등록번호를 입력해 주세요..");
				objItem.focus();
				return;
			}
		}
		if (!checkSSH(f.strSSH1, f.strSSH2)) return ;		// checkSSH :	jscript/check.js

		if (!checkMinor2(f.strSSH1, f.strSSH2)) return;		// 미성년자체크




		postParams = "centerName=" + f.centerName.value;
		postParams += "&centerCode=" + f.centerCode.value;
		postParams += "&strSSH1=" + f.strSSH1.value;
		postParams += "&strSSH2=" + f.strSSH2.value;
		postParams += "&strBankCode=" + f.strBankCode.value;
		postParams += "&strBankNum=" + f.strBankNum.value;
		postParams += "&strBankOwner=" + f.strBankOwner.value;

		document.getElementById("loadings").style.visibility="visible";;
		request.open("POST",url,true);
		request.onreadystatechange = function ChgContent() {
			if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
				if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
					var newContent = request.responseText;
					//var newContentSplit = newContent.split("||")
					//alert(newContent);
					document.getElementById("result_text").innerHTML = newContent;
					document.getElementById("loadings").style.visibility="hidden";

					//alert(document.getElementById("innerMask").innerHTML);
				} else {
					document.getElementById("result_text").innerHTML = "ajax오류!";
				}
			  }
			}
		request.setRequestHeader("Content-Type","application/x-www-form-urlencoded;charset=utf-8");
		request.send(postParams);
		return;
	}



	function chkAccountFrm(f) {
		if (f.agree01.value != "T") {
			alert("정상적인 접속이 아니거나 이용약관에 동의하지 않은 상태로 현재 페이지에 접속하셨습니다.");
			document.location.href = "joinStep01.asp";
			return false;
		}

		if (f.agree02.value != "T") {
			alert("정상적인 접속이 아니거나 개인정보 취급방침에 동의하지 않은 상태로 현재 페이지에 접속하셨습니다.");
			document.location.href = "joinStep01.asp";
			return false;
		}

		if (f.agree03.value != "T") {
			alert("정상적인 접속이 아니거나 사업자 회원가입 이용약관에 동의하지 않은 상태로 현재 페이지에 접속하셨습니다.");
			document.location.href = "joinStep01.asp";
			return false;
		}


		if (f.ajaxTF.value != "T")
		{
			alert("계좌본인을 해주세요.")
			return false;
		} else {
		//	if(!chkNull(f.centerName, "\'센터\'를 선택해 주세요")) return false;
		//	if(!chkNull(f.centerCode, "\'센터코드\'를 입력해 주세요")) return false;

			if(!chkNull(f.strBankCode, "\'은행\'을 선택해 주세요")) return false;
			if(!chkNull(f.strBankNum, "\'계좌번호\'를 입력해 주세요")) return false;
			if(!chkNull(f.strBankOwner, "\'예금주\'를 입력해 주세요")) return false;
			if(!chkNull(f.TempDataNum, "\'데이터베이스 입력 오류\'")) return false;

			var objItem;
			for (var i=1; i<=2; i++) {
				objItem = eval('f.strSSH'+i);
				if (chkEmpty(objItem)) {
					alert("주민등록번호를 입력해 주세요.");
					objItem.focus();
					return false;
				}
			}
			if (!checkSSH(f.strSSH1, f.strSSH2)) return false;
			if (!checkMinor2(f.strSSH1, f.strSSH2)) return;		// 미성년자체크


			if (f.strBankCodeCHK.value != f.strBankCode.value || f.strBankNumCHK.value != f.strBankNum.value || f.strBankOwnerCHK.value != f.strBankOwner.value || f.strSSH1CHK.value != f.strSSH1.value || f.strSSH2.value != f.strSSH2CHK.value)
			{
				alert("본인인증시의 입력정보와 현재 입력된 정보가 틀립니다. 본인인증을 다시 해주세요.")
				return false;
			}

		}

/*
		if (f.centerName.value == '')
		{
			alert("센터값이 없습니다.");
			document.location.href = "joinStep01.asp";
			return false;
		}

		if (f.centerCode.value == '')
		{
			alert("센터등록코드를 입력해주세요");
			document.location.href = "joinStep01.asp";
			return false;
		}
*/
		if (f.strBankCode.value == '')
		{
			alert("은행을 선택해주세요.");
			return false;
		}

		if (f.strBankNum.value == '')
		{
			alert("계좌번호를 입력해주세요");
			f.strBankNum.focus();
			return false;
		}
		if (f.strBankOwner.value == '')
		{
			alert("예금주를 입력해주세요");
			f.strBankOwner.focus();
			return false;
		}
		// checkSSH :	jscript/check.js
	}