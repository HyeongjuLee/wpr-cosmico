	function ajax_accountChk() {
		var f = document.joinFrm;
		/*
		if (f.centerName.value == '')
		{
			alert("센터값이 없습니다.");
			document.location.href = "joinStep_01.asp";
			return;
		}

		if (f.centerCode.value == '')
		{
			alert("센터등록코드를 입력해주세요");
			document.location.href = "joinStep_01.asp";
			return;
		}
		*/
		if (f.strBankCode.value == '')
		{
			alert("은행을 선택해주세요.");
			return;
		}

		if (f.strBankNum.value == '')
		{
			alert("계좌번호를 입력해주세요1");
			f.strBankNum.focus();
			return;
		}
		/*
		if (f.strBankOwner.value == '')
		{
			alert("예금주를 입력해주세요.");
			f.strBankOwner.focus();
			return;
		}
		if( /[\s]/g.test( f.strBankOwner.value) == true){
			alert('공백은 사용할 수 없습니다. ')
			f.strBankOwner.value=f.strBankOwner.value.replace(/(\s*)/g,'');
			return;
		}
		if (!checkkorText(f.strBankOwner.value,2)) {
			alert("정확한 예금주명을 입력해 주세요!!");
			f.strBankOwner.focus();
			return false;
		}
		if (!checkSCharNum(f.strBankOwner.value)) {
			alert("특수문자나 숫자는 입력할 수 없습니다.");
			f.strBankOwner.value="";
			f.strBankOwner.focus();
			return false;
		}
		*/
		if (f.M_Name_Last.value == '')
		{
			alert("예금주 성을 입력해주세요.");
			f.M_Name_Last.focus();
			return false;
		}
		if( /[\s]/g.test( f.M_Name_Last.value) == true){
			alert('공백은 사용할 수 없습니다. ')
			f.M_Name_Last.value=f.M_Name_Last.value.replace(/(\s*)/g,'');
			return false;
		}
		if (!checkkorText(f.M_Name_Last.value,1)) {
			alert("정확한 예금주(성)을 입력해 주세요.");
			f.M_Name_Last.focus();
			return false;
		}
		if (!checkSCharNum(f.M_Name_Last.value)) {
			alert("특수문자나 숫자는 입력할 수 없습니다.");
			f.M_Name_Last.value="";
			f.M_Name_Last.focus();
			return false;
		}

		if (f.M_Name_First.value == '')
		{
			alert("예금주 이름을 입력해주세요.");
			f.M_Name_First.focus();
			return false;
		}
		if( /[\s]/g.test( f.M_Name_First.value) == true){
			alert('공백은 사용할 수 없습니다!')
			f.M_Name_First.value=f.M_Name_First.value.replace(/(\s*)/g,'');
			return false;
		}
		if (!checkkorText(f.M_Name_First.value,1)) {
			alert("정확한 예금주(이름)을 입력해 주세요!");
			f.M_Name_First.focus();
			return false;
		}
		if (!checkSCharNum(f.M_Name_First.value)) {
			alert("특수문자나 숫자는 입력할 수 없습니다!");
			f.M_Name_First.value="";
			f.M_Name_First.focus();
			return false;
		}

		//핸드폰인증기능 사용 (인증된 이름과 비교)
		if (f.NICE_BANK_WITH_MOBILE_USE.value == 'T') {
			if (f.strBankOwner.value != f.M_Name_Last.value+f.M_Name_First.value)	{
				alert("정확한 본인의 이름을 입력해주세요!!!");
				f.M_Name_First.focus();
				return false;
			}
		}

		if (chkEmpty(f.birthYY) || chkEmpty(f.birthMM) || chkEmpty(f.birthDD)) {
			alert("생년월일을 입력해 주세요.");
			f.birthYY.focus();
			return;
		}
		if (!checkMinorBirth(f.birthYY, f.birthMM , f.birthDD)) return;		// 미성년자체크(생년월일)

		document.getElementById("loadings").style.visibility="visible";;

		$.ajax({
			type: "POST"
			,url: "joinStep03_ajax.asp"
			,data: {
				 "centerName"		: f.centerName.value
				,"centerCode"		: f.centerCode.value
				,"birthYY"			: f.birthYY.value
				,"birthMM"			: f.birthMM.value
				,"birthDD"			: f.birthDD.value
				,"strBankCode"		: f.strBankCode.value
				,"strBankNum"		: f.strBankNum.value
				,"strBankOwner"	: f.M_Name_Last.value+f.M_Name_First.value
				,"M_Name_First"	: f.M_Name_First.value
				,"M_Name_Last"		: f.M_Name_Last.value
			}			//,contentType: "application/json; charset=utf-8"
			,success: function(data) {
				$("#result_text").html(data);

				document.getElementById("loadings").style.visibility="hidden";
			}
			,error:function(data) {
				document.getElementById("result_text").innerHTML = "ajax오류!";
			}
		});

	}



	function chkAccountFrm(f) {
		var f = document.joinFrm;

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
			alert("계좌본인확인을 해주세요.")
			return false;
		} else {
		//	if(!chkNull(f.centerName, "\'센터\'를 선택해 주세요1")) return false;
		//	if(!chkNull(f.centerCode, "\'센터코드\'를 입력해 주세요2")) return false;

			if(!chkNull(f.strBankCode, "\'은행\'을 선택해 주세요2")) return false;
			if(!chkNull(f.strBankNum, "\'계좌번호\'를 입력해 주세요2")) return false;
			//if(!chkNull(f.strBankOwner, "\'예금주\'를 입력해 주세요2")) return false;
			if(!chkNull(f.M_Name_First, "\'예금주 이름\'을 입력해 주세요")) return false;
			if(!chkNull(f.M_Name_Last, "\'예금주 성\'을 입력해 주세요")) return false;
			if(!chkNull(f.TempDataNum, "\'데이터베이스 입력 오류\'")) return false;

			if (!checkkorText(f.M_Name_Last.value,1)) {
				alert("정확한 예금주(성)을 입력해 주세요.");
				f.M_Name_Last.focus();
				return false;
			}
			if (!checkSCharNum(f.M_Name_Last.value)) {
				alert("특수문자나 숫자는 입력할 수 없습니다.");
				f.M_Name_Last.value="";
				f.M_Name_Last.focus();
				return false;
			}
			if (!checkkorText(f.M_Name_First.value,1)) {
				alert("정확한 예금주(이름)을 입력해 주세요!");
				f.M_Name_First.focus();
				return false;
			}
			if (!checkSCharNum(f.M_Name_First.value)) {
				alert("특수문자나 숫자는 입력할 수 없습니다!");
				f.M_Name_First.value="";
				f.M_Name_First.focus();
				return false;
			}

			//핸드폰인증된 이름과 비교
			if (f.NICE_BANK_WITH_MOBILE_USE.value == 'T') {
				if (f.strBankOwner.value != f.M_Name_Last.value+f.M_Name_First.value)	{
					alert("정확한 본인의 이름을 입력해주세요!!");
					f.M_Name_First.focus();
					return false;
				}
			}

			if(!chkNull(f.TempDataNum, "\'데이터베이스 입력 오류\'")) return false;

			if (chkEmpty(f.birthYY) || chkEmpty(f.birthMM) || chkEmpty(f.birthDD)) {
				alert("생년월일을 입력해 주세요.");
				f.birthYY.focus();
				return false;
			}
			if (!checkMinorBirth(f.birthYY, f.birthMM , f.birthDD)) return;		// 미성년자체크(생년월일)

			$("input[name=strBankOwner]").val(f.M_Name_Last.value+f.M_Name_First.value);

			if (f.strBankCodeCHK.value != f.strBankCode.value || f.strBankNumCHK.value != f.strBankNum.value || f.strBankOwnerCHK.value != f.strBankOwner.value || f.birthYYCHK.value != f.birthYY.value || f.birthMMCHK.value != f.birthMM.value || f.birthDDCHK.value != f.birthDD.value)
			{
				alert("본인인증시의 입력정보와 현재 입력된 정보가 틀립니다. 본인인증을 다시 해주세요.")
				return false;
			}

		}

		/*
		if (f.centerName.value == '')
		{
			alert("센터값이 없습니다.");
			document.location.href = "joinStep_01.asp";
			return false;
		}

		if (f.centerCode.value == '')
		{
			alert("센터등록코드를 입력해주세요");
			document.location.href = "joinStep_01.asp";
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
			alert("계좌번호를 입력해주세요3");
			f.strBankNum.focus();
			return false;
		}
		if (f.M_Name_Last.value == '')
		{
			alert("예금주 성을 입력해주세요.");
			f.M_Name_Last.focus();
			return;
		}
		if( /[\s]/g.test( f.M_Name_Last.value) == true){
			alert('공백은 사용할 수 없습니다. ')
			f.M_Name_Last.value=f.M_Name_Last.value.replace(/(\s*)/g,'');
			return;
		}
		if (!checkkorText(f.M_Name_Last.value,1)) {
			alert("정확한 예금주(성)을 입력해 주세요.");
			f.M_Name_Last.focus();
			return false;
		}
		if (!checkSCharNum(f.M_Name_Last.value)) {
			alert("특수문자나 숫자는 입력할 수 없습니다.");
			f.M_Name_Last.value="";
			f.M_Name_Last.focus();
			return false;
		}

		if (f.M_Name_First.value == '')
		{
			alert("예금주 이름을 입력해주세요.");
			f.M_Name_First.focus();
			return;
		}
		if( /[\s]/g.test( f.M_Name_First.value) == true){
			alert('공백은 사용할 수 없습니다!')
			f.M_Name_First.value=f.M_Name_First.value.replace(/(\s*)/g,'');
			return;
		}
		if (!checkkorText(f.M_Name_First.value,1)) {
			alert("정확한 예금주(이름)을 입력해 주세요!");
			f.M_Name_First.focus();
			return false;
		}
		if (!checkSCharNum(f.M_Name_First.value)) {
			alert("특수문자나 숫자는 입력할 수 없습니다!");
			f.M_Name_First.value="";
			f.M_Name_First.focus();
			return false;
		}

		f.submit();
		// checkSSH :	jscript/check.js
	}