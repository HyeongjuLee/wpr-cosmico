$(document).ready(function(){
	$("#strUserID").keyup(function(){
		$('#idcheckBtn').prev('span').find('span.ui-btn-text')
			.text("아이디 중복체크를 해주세요")
			.css("cssText","color:#333 !important");
		$("#idCheckSum").val("F");
		$("#chk_strUserID").val("");
	});

	$("#strNickName").keyup(function(){
		$('#nickcheckBtn').prev('span').find('span.ui-btn-text')
			.text("별칭 중복체크를 해주세요")
			.css("cssText","color:#333 !important");
		$("#nickCheckSum").val("F");
		$("#chk_strNickName").val("");
	});

});

/*
//추천인 아래 후원인 검색 S
function vote_idcheck2() {
	openPopup("/common/pop_voter2.asp", "vote_idcheck", 0, 0, "");
}
*/

function vote_idcheck() {
	openPopup("/common/pop_voter.asp", "vote_idcheck", 0, 0, "");
}
function spon_idcheck() {
	openPopup("/common/pop_Sponsor.asp", "spon_idcheck", 0, 0, "");
}

function openzip() {
	openPopup("/common/pop_Zipcode.asp", "Zipcodes", 0, 0, "");
}

function idcheck() {
	createRequest();
	var url = 'joinStep02_ajax_id.asp';
	//alert(mode1);
	var f = document.joinFrm;
	var strUserID_val = f.strUserID.value;

	if (strUserID_val == "" )
	{
		alert("아이디를 입력해주세요.123");
		f.strUserID.focus();
		return false;
	}
	if (!checkID(strUserID_val.trim(), 4, 20)){
		alert("아이디는 영문 혹은 숫자 4자~20자리로 해주세요.");
		f.strUserID.focus();
		return false;
	}
	postParams = "strUserID=" + strUserID_val;


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

				$("#chk_strUserID").val($.trim(newContentSplit[0]));
				$("#idCheckSum").val($.trim(newContentSplit[1]));
				if ($.trim(newContentSplit[1]) == "T")
				{
					$('#idcheckBtn').prev('span').find('span.ui-btn-text')
						.text($.trim(newContentSplit[2]))
						.css("cssText","color:#000cff !important");

				} else {
					$('#idcheckBtn').prev('span').find('span.ui-btn-text')
						.text($.trim(newContentSplit[2]))
						.css("cssText","color:#ff0000 !important");

				}

			} else {
				alert("ajax error");
			}
		  }
		}
	request.setRequestHeader("Content-Type","application/x-www-form-urlencoded;charset=utf-8");
	request.send(postParams);
	return;
}


function nickcheck() {
	createRequest();
	var url = 'joinStep02_ajax_nick.asp';
	//alert(mode1);
	var f = document.joinFrm;
	var strNickName_val = f.strNickName.value;

	if (strNickName_val == "" )
	{
		alert("별칭을 입력해주세요.");
		return false;
	}




	postParams = "strNickName=" + strNickName_val;


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

				$("#chk_strNickName").val($.trim(newContentSplit[0]));
				$("#nickCheckSum").val($.trim(newContentSplit[1]));
				if ($.trim(newContentSplit[1]) == "T")
				{
					$('#nickcheckBtn').prev('span').find('span.ui-btn-text')
						.text($.trim(newContentSplit[2]))
						.css("cssText","color:#000cff !important");


				} else {
					$('#nickcheckBtn').prev('span').find('span.ui-btn-text')
						.text($.trim(newContentSplit[2]))
						.css("cssText","color:#ff0000 !important");



				}


			} else {
				alert("ajax error");
			}
		  }
		}
	request.setRequestHeader("Content-Type","application/x-www-form-urlencoded;charset=utf-8");
	request.send(postParams);
	return;
}


function chkValNull(obj,mgs) {

	if ( $.trim()($(obj).val()) )
	{
		alert(mgs);
		$(obj).focus();
		return false;
	} else {
		return true;
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
function chkValEqua() {

}




function joinStepChk3() {

	var f = document.joinFrm;
	// alert($("#chk_strUserID").attr("type"));







	/* 아이디 관련 */
	// if(!chkNull($("#chk_strUserID"), "\'아이디\'을 입력해 주세요")) return false;
		if($("#chk_strUserID").val() == "" || $("#strUserID").val() == ""){alert("아이디를 입력해주세요."); $("#strUserID").focus(); return false;}
		if($("#chk_strUserID").val() == "" || $("#idCheckSum").val() == ""){alert("아이디를 중복체크를 하셔야합니다."); return false;}
		if($("#chk_strUserID").val() != $("#strUserID").val()){alert("현재 입력된 아이디와 중복체크된 아이디가 틀립니다."); $("#strUserID").focus(); return false;}

	// 닉네임 관련
		if($("#chk_strNickName").val() == "" || $("#strNickName").val() == ""){alert("별칭을 입력해주세요."); $("#strNickName").focus(); return false;}
		if($("#chk_strNickName").val() == "" || $("#nickCheckSum").val() == ""){alert("별칭 중복체크를 하셔야합니다."); return false;}
		if($("#chk_strNickName").val() != $("#strNickName").val()){alert("현재 입력된 별칭과 중복체크된 별칭이 틀립니다."); $("#strNickName").focus(); return false;}

	// 패스워드
		if ($("#strPass").val() == "" || $("#strPass2").val() == ""){alert("암호 또는 암호확인이 비어있습니다."); $("#strPass").focus(); return false;}
		if ($("#strPass").val() != $("#strPass2").val()) {alert("암호를 다시 확인해주세요."); $("#strPass").focus(); return false;}

	// 센터 businessCode
		if ($("#businessCode").val() == ""){alert("센터는 필수항목입니다."); $("#businessCode").focus(); return false;}

	// 추천인 voter NominID1 NominID2 NominWebID NominChk
	// 후원인 sponsor SponID1 SponID2 SponIDWebID SponIDChk
		if ($("#NominChk").val() != "T"){alert("추천인 검색을 통해서 입력하셔야합니다."); vote_idcheck(); return false;}
		if ($("#SponIDChk").val() != "T"){alert("후원인 검색을 통해서 입력하셔야합니다."); spon_idcheck(); return false;}
		if ($("#voter").val() == "" || $("#NominID1").val() == "" || $("#NominID2").val() == "" || $("#NominWebID").val() == "" || $("#NominChk").val() == ""){alert("추천인 검색을 통해서 입력하셔야합니다."); vote_idcheck(); return false;}
		if ($("#sponsor").val() == "" || $("#SponID1").val() == "" || $("#SponID2").val() == "" || $("#SponIDWebID").val() == "" || $("#SponIDChk").val() == ""){alert("후원인 검색을 통해서 입력하셔야합니다."); spon_idcheck(); return false;}

	// 주소 관련 strZip strAddr1 strAddr2
		if ($("#strZip").val() == "" || $("#strAddr1").val() == ""){alert("우편번호가 비어있습니다.."); openzip(); return false;}
		if ($("#strAddr2").val() == ""){alert("나머지주소를 입력해주세요."); $("#strAddr2").focus(); return false;}
	// 휴대폰 관련 mob_num1 mob_num2 mob_num3
		if ($("#mob_num1").val() == ""){alert("휴대폰의 국번을 선택해 주세요."); $("#mob_num1").focus(); return false;}
		if ($("#mob_num2").val() == ""){alert("휴대폰의 가운데 번호를 입력해주세요."); $("#mob_num2").focus(); return false;}
		if ($("#mob_num3").val() == ""){alert("휴대폰의 마지막 번호를 입력해주세요."); $("#mob_num3").focus(); return false;}

	// sms email 수신
		if ($(':radio[name="sendemail"]:checked').length == 0){alert("이메일 수신여부를 선택해주세요."); $(':radio[name="sendemail"]:first').focus(); return false;}
		if ($(':radio[name="sendsms"]:checked').length == 0){alert("SMS 수신여부를 선택해주세요."); $(':radio[name="sendsms"]:first').focus(); return false;}



}


