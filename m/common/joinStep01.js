$(document).ready(function(){
	$(':radio[name="agreement"]').click(function(event){

		var agreementVal = $(':radio[name="agreement"]:checked').val();

		var joinChk = $("#joinChk").val();
		var joinChk_strName = $("#joinChk_strName").val();
		var joinChk_strSSH1 = $("#joinChk_strSSH1").val();
		var joinChk_strSSH2 = $("#joinChk_strSSH2").val();
		var strName = $("#strName").val();
		var strSSH1 = $("#strSSH1").val();
		var strSSH2 = $("#strSSH2").val();


		if (agreementVal == 'T')
		{
			if (joinChk == 'T' && joinChk_strName == strName && joinChk_strSSH1 == strSSH1 && joinChk_strSSH2 == strSSH2)
			{
				$('#joinSubmit').prev('span').find('span.ui-btn-text').text("다음단계로 진행1");
				$('#joinSubmit').button("enable");
			} else {
				$('#joinSubmit').prev('span').find('span.ui-btn-text').text("회원가입확인이 필요합니다.2");
				$('#joinSubmit').button("disable");
			}
		} else {
			if (joinChk == 'T' && joinChk_strName == strName && joinChk_strSSH1 == strSSH1 && joinChk_strSSH2 == strSSH2)
			{
				$('#joinSubmit').prev('span').find('span.ui-btn-text').text("약관동의가 필요합니다.3");
				$('#joinSubmit').button("disable");
			} else {
				$('#joinSubmit').prev('span').find('span.ui-btn-text').text("약관동의 및 가입확인 필요4");
				$('#joinSubmit').button("disable");
			}
		}

	});
});





	function joinStepChk2(f) {

		var agreementVal = $(':radio[name="agreement"]:checked').val();

		if ($(':radio[name="agreement"]:radio:checked').length == 0)
		{
			alert("이용약관 및 개인정보 수집에 대한 동의를 하셔야 회원가입이 가능합니다");
			return false;
		}
		if (agreementVal == "" || agreementVal == 'F')
		{
			alert("이용약관 및 개인정보 수집에 대한 동의를 하셔야 회원가입이 가능합니다.");
			return false;
		}

		if (f.strName.value == "") {
			alert("이름을 입력해 주세요.");
			$('#joinSubmit').prev('span').find('span.ui-btn-text').text("회원가입확인이 필요합니다.3");
			$('#joinSubmit').button("disable");
			f.strName.focus();
			return false;
		}

		var objItem;
		for (var i=1; i<=2; i++) {
			objItem = eval('f.strSSH'+i);
			if (chkEmpty(objItem)) {
				alert("주민등록번호를 입력해 주세요.");
				$('#joinSubmit').prev('span').find('span.ui-btn-text').text("회원가입확인이 필요합니다.4");
				$('#joinSubmit').button("disable");
				objItem.focus();
				return false;
			}
		}

		if (!checkSSH(f.strSSH1, f.strSSH2)) {
			$('#joinSubmit').prev('span').find('span.ui-btn-text').text("회원가입확인이 필요합니다.5");
			$('#joinSubmit').button("disable");
			return false;
		}


		if (f.joinChk_strName.value != f.strName.value || f.joinChk_strSSH1.value != f.strSSH1.value || f.joinChk_strSSH2.value != f.strSSH2.value) {
			alert("가입확인한 정보와 현재 입력된 정보가 틀립니다.");
			$('#joinSubmit').prev('span').find('span.ui-btn-text').text("회원가입확인이 필요합니다.6");
			$('#joinSubmit').button("disable");
			f.strName.focus();
			return false;
		}




	}





	function joinNameChk() {
		createRequest();
		var url = 'joinStep01_ajax.asp';
		//alert(mode1);
		var f = document.joinFrm;
		var strName_val = f.strName.value;
		var strSSH1_val = f.strSSH1.value;
		var strSSH2_val = f.strSSH2.value;
		var agreementVal = $(':radio[name="agreement"]:checked').val();

		if (strName_val == "" || strSSH1_val == "" || strSSH2_val =="")
		{
			alert("이름, 주민번호앞, 뒤자리를 입력하셔야 합니다.");
			return false;
		}

		if (!checkSSH(f.strSSH1, f.strSSH2)) return false;



		postParams = "strName=" + strName_val;
		postParams += "&strSSH1=" + strSSH1_val;
		postParams += "&strSSH2=" + strSSH2_val;

		var joinSbm = $("#joinSubmit span");

		request.open("POST",url,true);
		request.onreadystatechange = function ChgContent() {
			if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
				if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
					var newContent = request.responseText;
					var newContentSplit = newContent.split("&")
					//alert(newContent);
					//document.getElementById("product_area").innerHTML = newContent;

					//	이미 웹에 가입된 주민등록번호 입니다.\n아이디/패스워드 찾기를 이용해주세요.","back","")
					//	If flagRs2 Then	Call alerts("이미 CS에 가입된 주민등록번호 입니다.\n아이디/패스워드 찾기를 이용해주세요.","back","")
					if (newContentSplit[0] == 1)
					{
						alert("이미 웹에 가입된 주민등록번호 입니다.\n아이디/패스워드 찾기를 이용해주세요.");
						//$('#joinSubmit').button("disable");
						return false;
					}
					if (newContentSplit[0] == 2)
					{
						alert("이미 CS에 가입된 주민등록번호 입니다.\n아이디/패스워드 찾기를 이용해주세요.");
						joinSbm.value = "dd";
						return false;
					}
					if (newContentSplit[0] == 3)
					{
						$("#joinChk").val($.trim(newContentSplit[1]));
						$("#joinChk_strName").val($.trim(newContentSplit[2]));
						$("#joinChk_strSSH1").val($.trim(newContentSplit[3]));
						$("#joinChk_strSSH2").val($.trim(newContentSplit[4]));

						if (agreementVal == 'T')
						{
							$('#joinSubmit').prev('span').find('span.ui-btn-text').text("다음단계로 진행");
							$('#joinSubmit').button("enable");
						} else {
							$('#joinSubmit').prev('span').find('span.ui-btn-text').text("약관동의가 필요합니다.");
						}

						return false;
					}
					alert(newContentSplit[0]);
				} else {
					alert("ajax error");
				}
			  }
			}
		request.setRequestHeader("Content-Type","application/x-www-form-urlencoded;charset=utf-8");
		request.send(postParams);
		return;
	}