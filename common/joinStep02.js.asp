<script type="text/javascript">

	function allCheckAgree() {
		if (document.getElementById("allAgree").checked == true)
		{
			document.getElementById("agree01Chk").checked = true;
			document.getElementById("agree02Chk").checked = true;
			<%If S_SellMemTF = 0 Then%>
				document.getElementById("agree03Chk").checked = true;
				//document.getElementById("agree04Chk").checked = true;
			<%End If%>
			document.getElementById("agree04Chk").checked = true;

		} else if (document.getElementById("allAgree").checked == false)	{
			document.getElementById("agree01Chk").checked = false;
			document.getElementById("agree02Chk").checked = false;
			<%If S_SellMemTF = 0 Then%>
				document.getElementById("agree03Chk").checked = false;
				//document.getElementById("agree04Chk").checked = false;
			<%End If%>
			document.getElementById("agree04Chk").checked = false;
		}
	}

	//new ver
	function checkAgree() {
		var f = document.agreeFrm;

		if (f.agree01.checked == false) {
			alert("<%=LNG_JS_POLICY01%>");
			f.agree01.focus();
			return false;
		}
		if (f.agree02.checked == false) {
			alert("<%=LNG_JS_POLICY02%>");
			f.agree02.focus();
			return false;
		}
		<%If S_SellMemTF = 0 Then%>
			if (f.agree03.checked == false) {
				alert("<%=LNG_JS_POLICY03%>");
				f.agree03.focus();
				return false;
			}
		<%End If%>

		if (f.agree04.checked == false) {
			alert("<%=LNG_JS_POLICY04%>");
			f.agree04.focus();
			return false;
		}
		<%'If S_SellMemTF = 0 Then%>
			// if (f.agree04.checked == false) {
			// 	alert("판매원 유의사항에 동의하셔야합니다.");
			// 	f.agree04.focus();
			// 	return false;
			// }
		<%'End If%>

		<%If NICE_BANK_CONFIRM_TF = "T" And S_SellMemTF = 0 Then%>		//'계좌인증(판매원)
			if (f.ajaxTF.value != "T") {
				alert("계좌 본인인증을 해주세요.")
				f.bankCode.focus();
				return false;
			} else {
				if(!chkNull(f.TempDataNum, "\'데이터베이스 입력 오류\'")) return false;
				if (!checkMinorBirth(f.birthYY, f.birthMM , f.birthDD)) return;		// 미성년자체크(생년월일)
				if (f.bankOwner.value !=f.M_Name_Last.value+f.M_Name_First.value) {
					alert("본인인증시의 입력정보와 현재 입력된 정보가 틀립니다. 본인인증을 다시 해주세요.(예금주) ");
					f.M_Name_First.focus();
					return false;
				}
				if (f.strBankCodeCHK.value != f.bankCode.value || f.strBankNumCHK.value != f.bankNumber.value || f.strBankOwnerCHK.value != f.bankOwner.value || f.birthYYCHK.value != f.birthYY.value || f.birthMMCHK.value != f.birthMM.value || f.birthDDCHK.value != f.birthDD.value)
				{
					alert("본인인증시의 입력정보와 현재 입력된 정보가 틀립니다. 본인인증을 다시 해주세요.");
					$("#result_text").text("본인인증시의 입력정보와 현재 입력된 정보가 틀립니다").addClass("red2").removeClass("blue2");
					f.bankCode.focus();
					return false;
				}
			}

		<%Else%>		//'이름+생년월일 중복체크
			if (f.ajaxTF.value != "T") {
				alert("<%=LNG_JS_DUPLICATION_CHECK%>");
				f.M_Name_Last.focus();
				return false;
			} else {
				if (f.M_Name_Last.value != f.M_Name_LastCHK.value) {
					alert("<%=LNG_JS_DUPLICATE_NAME_CHANGE%>(<%=LNG_TEXT_FAMILY_NAME%>)\n<%=LNG_JS_DUPLICATION_CHECK%>");
					$("#result_text").text("중복체크시 입력정보와 현재 입력된 정보가 틀립니다").addClass("red2").removeClass("blue2");
					f.M_Name_First.focus();
					return false;
				}
				if (f.M_Name_First.value != f.M_Name_FirstCHK.value) {
					alert("<%=LNG_JS_DUPLICATE_NAME_CHANGE%>(<%=LNG_TEXT_GIVEN_NAME%>)\n<%=LNG_JS_DUPLICATION_CHECK%>");
					$("#result_text").text("중복체크시 입력정보와 현재 입력된 정보가 틀립니다").addClass("red2").removeClass("blue2");
					f.M_Name_First.focus();
					return false;
				}
				if (f.birthYY.value != f.birthYYCHK.value || f.birthMM.value != f.birthMMCHK.value || f.birthDD.value != d.birthDDCHK.value) {
					alert("<%=LNG_JS_DUPLICATE_BIRTH_CHANGE%>\n<%=LNG_JS_DUPLICATION_CHECK%>");
					$("#result_text").text("중복체크시 입력정보와 현재 입력된 정보가 틀립니다").addClass("red2").removeClass("blue2");
					f.birthYY.focus();
					return false;
				}
			}
		<%End If%>

		<%If snsToken <> "" Then%>
			if ((f.M_Name_Last.value + f.M_Name_First.value) != '<%=snsName%>') {
				alert("정확한 이름을 입력해 주세요.");
				f.M_Name_Last.focus();
				return false;
			}
			<%If snsBirthYY <> "" Then%>
			if (f.birthYY.value != '<%=snsBirthYY%>') {
				alert("정확한 출생연도를 입력해주세요.");
				f.birthYY.focus();
				return false;
			}
			<%End If%>
			<%If snsBirthMM <> "" Then%>
			if (f.birthMM.value != '<%=snsBirthMM%>') {
				alert("정확한 출생월를 입력해주세요.");
				f.birthMM.focus();
				return false;
			}
			<%End If%>
			<%If snsBirthDD <> "" Then%>
			if (f.birthDD.value != '<%=snsBirthDD%>') {
				alert("정확한 출생일를 입력해주세요.");
				f.birthDD.focus();
				return false;
			}
			<%End If%>
			if (chkEmpty(f.birthYY) || chkEmpty(f.birthMM) || chkEmpty(f.birthDD)) {
				alert("<%=LNG_JS_BIRTH%>");
				f.birthYY.focus();
				return false;
			}
		<%End If%>

	}


	function ajax_memberDuplicateChk(f) {
		var f = document.agreeFrm;

		if (chkEmpty(f.M_Name_Last)) {
			alert("<%=LNG_JS_FAMILY_NAME%>");
			f.M_Name_Last.focus();
			return false;
		}
		if (chkEmpty(f.M_Name_First)) {
			alert("<%=LNG_JS_GIVEN_NAME%>");
			f.M_Name_First.focus();
			return false;
		}
		if( /[\s]/g.test( f.M_Name_Last.value) == true){
			alert("<%=LNG_JS_NO_SPACE%>(<%=LNG_TEXT_FAMILY_NAME%>)");
			f.M_Name_Last.value=f.M_Name_Last.value.replace(/(\s*)/g,'');
			return false;
		}
		if( /[\s]/g.test( f.M_Name_First.value) == true){
			alert("<%=LNG_JS_NO_SPACE%>(<%=LNG_TEXT_GIVEN_NAME%>)");
			f.M_Name_First.value=f.M_Name_First.value.replace(/(\s*)/g,'');
			return false;
		}

		<%IF Ucase(R_NationCode) = "KR" Then%>
			if (!checkkorText(f.M_Name_Last.value,1)) {
				alert("정확한 한글 성을 입력해 주세요.");
				f.M_Name_Last.focus();
				return false;
			}
			if (!checkkorText(f.M_Name_First.value,1)) {
				alert("정확한 한글 이름을 입력해 주세요.");
				f.M_Name_First.focus();
				return false;
			}
		<%End If%>

		if (!checkSCharNum(f.M_Name_Last.value)) {
			alert("<%=LNG_JS_SPCECIALC_NUM_FORMCHECK%>(<%=LNG_TEXT_FAMILY_NAME%>)");
			f.M_Name_Last.value="";
			f.M_Name_Last.focus();
			return false;
		}
		if (!checkSCharNum(f.M_Name_First.value)) {
			alert("<%=LNG_JS_SPCECIALC_NUM_FORMCHECK%>(<%=LNG_TEXT_GIVEN_NAME%>)");
			f.M_Name_First.value="";
			f.M_Name_First.focus();
			return false;
		}
		if (chkEmpty(f.birthYY)) {
			alert("<%=LNG_JS_BIRTH%> (yyyy)");
			f.birthYY.focus();
			return false;
		}
		if (chkEmpty(f.birthMM)) {
			alert("<%=LNG_JS_BIRTH%> (mm)");
			f.birthMM.focus();
			return false;
		}
		if (chkEmpty(f.birthDD)) {
			alert("<%=LNG_JS_BIRTH%> (dd))");
			f.birthDD.focus();
			return false;
		}

		if (!checkMinorBirth(f.birthYY, f.birthMM , f.birthDD)) return false;		// 미성년자체크(생년월일)

		<%If snsToken <> "" Then%>
			if ( (f.M_Name_Last.value + f.M_Name_First.value) != '<%=snsName%>'  ) {
				alert("정확한 이름을 입력해 주세요.");
				f.M_Name_Last.focus();
				return false;
			}
			<%If snsBirthYY <> "" Then%>
			if ( f.birthYY.value != '<%=snsBirthYY%>'  ) {
				alert("정확한 출생연도를 입력해주세요.");
				f.birthYY.focus();
				return false;
			}
			<%End If%>
			<%If snsBirthMM <> "" Then%>
			if ( f.birthMM.value != '<%=snsBirthMM%>'  ) {
				alert("정확한 출생월를 입력해주세요.");
				f.birthMM.focus();
				return false;
			}
			<%End If%>
			<%If snsBirthDD <> "" Then%>
			if ( f.birthDD.value != '<%=snsBirthDD%>'  ) {
				alert("정확한 출생일를 입력해주세요.");
				f.birthDD.focus();
				return false;
			}
			<%End If%>
			if (chkEmpty(f.birthYY) || chkEmpty(f.birthMM) || chkEmpty(f.birthDD)) {
				alert("<%=LNG_JS_BIRTH%>");
				f.birthYY.focus();
				return false;
			}
		<%End If%>

		$.ajax({
			type: "POST"
			,async : false
			,url: "/common/ajax_joinCheck_nc_g.asp"
			,data: {
				 "M_Name_Last"	: f.M_Name_Last.value
				,"M_Name_First"	: f.M_Name_First.value
				,"birthYY"		: f.birthYY.value
				,"birthMM"		: f.birthMM.value
				,"birthDD"		: f.birthDD.value
			}
			,success: function(jsonData) {
				//console.log(jsonData);
				var json = $.parseJSON(jsonData);
				if (json.result == "success") {
					alert(json.message);
					$("#result_text").text(json.message).addClass("blue2").removeClass("red2");
					$("#agreeFrm input[name=name]").val(json.datas.name);
					$("#agreeFrm input[name=M_Name_LastCHK]").val(json.datas.M_Name_Last);
					$("#agreeFrm input[name=M_Name_FirstCHK]").val(json.datas.M_Name_First);
					$("#agreeFrm input[name=birthYYCHK]").val(json.datas.birthYY);
					$("#agreeFrm input[name=birthMMCHK]").val(json.datas.birthMM);
					$("#agreeFrm input[name=birthDDCHK]").val(json.datas.birthDD);
					$("input[name=ajaxTF").val("T")
				} else {
					alert(json.message);
					$("#result_text").text(json.message).addClass("red2").removeClass("blue2");
					$("#agreeFrm input[name=name]").val("");
					$("#agreeFrm input[name=M_Name_LastCHK]").val("");
					$("#agreeFrm input[name=M_Name_FirstCHK]").val("");
					$("#agreeFrm input[name=birthYYCHK]").val("");
					$("#agreeFrm input[name=birthMMCHK]").val("");
					$("#agreeFrm input[name=birthDDCHK]").val("");
					$("input[name=ajaxTF").val("F")
				}
			}
			,error:function(jsonData) {
				alert("<%=LNG_AJAX_ERROR_MSG%> "+jsonData.status+" "+jsonData.statusText+" "+jsonData.responseText);
			}
		});
		return false;
	}

	//계좌인증
	function ajax_accountChk() {
		var f = document.agreeFrm;

		if(!chkNull(f.bankCode, "은행을 선택해 주세요")) return false;
		if(!chkNull(f.bankNumber, "계좌번호를 입력해 주세요")) return false;
		if(!chkNull(f.M_Name_Last, "예금주 성을 입력해 주세요")) return false;
		if(!chkNull(f.M_Name_First, "예금주 이름을 입력해 주세요")) return false;

		if( /[\s]/g.test( f.M_Name_Last.value) == true){
			alert('공백은 사용할 수 없습니다. ')
			f.M_Name_Last.value=f.M_Name_Last.value.replace(/(\s*)/g,'');
			return false;
		}
		if (!checkSCharNum(f.M_Name_Last.value)) {
			alert("특수문자나 숫자는 입력할 수 없습니다.");
			f.M_Name_Last.value="";
			f.M_Name_Last.focus();
			return false;
		}
		if( /[\s]/g.test( f.M_Name_First.value) == true){
			alert('공백은 사용할 수 없습니다!')
			f.M_Name_First.value=f.M_Name_First.value.replace(/(\s*)/g,'');
			return false;
		}
		if (!checkSCharNum(f.M_Name_First.value)) {
			alert("특수문자나 숫자는 입력할 수 없습니다!");
			f.M_Name_First.value="";
			f.M_Name_First.focus();
			return false;
		}
		if (chkEmpty(f.birthYY)) {
			alert("생년월일을 입력해 주세요.(yyyy)");
			f.birthYY.focus();
			return;
		}
		if ( chkEmpty(f.birthMM)) {
			alert("생년월일을 입력해 주세요.(mm)");
			f.birthMM.focus();
			return;
		}
		if ( chkEmpty(f.birthDD)) {
			alert("생년월일을 입력해 주세요.(dd)");
			f.birthDD.focus();
			return;
		}
		if (!checkMinorBirth(f.birthYY, f.birthMM , f.birthDD)) return;		// 미성년자체크(생년월일)

		$.ajax({
			type: "POST"
			,url: "/common/ajax_Bank_Confirm.asp"
			,data: {
				"birthYY"		: f.birthYY.value
				,"birthMM"		: f.birthMM.value
				,"birthDD"		: f.birthDD.value
				,"strBankCode"	: f.bankCode.value
				,"strBankNum"	: f.bankNumber.value
				,"strBankOwner"	: f.M_Name_Last.value+f.M_Name_First.value
				,"M_Name_First"	: f.M_Name_First.value
				,"M_Name_Last"	: f.M_Name_Last.value
			}
			,success: function(data) {
				var obj = $.parseJSON(data);
				alert(obj.message);
				if (obj.statusCode == '0000')	{
					$("#result_text").text(obj.message).addClass("blue2").removeClass("red2");
					$("input[name=name]").val(obj.strBankOwnerCHK)
					$("input[name=bankOwner]").val(obj.strBankOwnerCHK)
					$("input[name=strBankCodeCHK").val(obj.strBankCodeCHK)
					$("input[name=strBankNumCHK").val(obj.strBankNumCHK)
					$("input[name=strBankOwnerCHK").val(obj.strBankOwnerCHK)
					$("input[name=birthYYCHK").val(obj.birthYYCHK)
					$("input[name=birthMMCHK").val(obj.birthMMCHK)
					$("input[name=birthDDCHK").val(obj.birthDDCHK)
					$("input[name=TempDataNum").val(obj.TempDataNum)
					$("input[name=ajaxTF").val("T")
				} else {
					$("#result_text").text(obj.message).addClass("red2").removeClass("blue2");
					$("input[name=name]").val("")
					$("input[name=bankOwner]").val("")
					$("input[name=strBankCodeCHK").val("")
					$("input[name=strBankNumCHK").val("")
					$("input[name=strBankOwnerCHK").val("")
					$("input[name=birthYYCHK").val("")
					$("input[name=birthMMCHK").val("")
					$("input[name=birthDDCHK").val("")
					$("input[name=TempDataNum").val("")
					$("input[name=ajaxTF").val("F")
				}
			}
			,error:function(data) {
				var obj = $.parseJSON(data);
				alert(obj.message);
			}
		});
	}


	$(function(){
		$('.sub-header').append('<div class="join-header-txt"><p><%=LNG_JOINSTEP02_U_STITLE01%></p></div>');
		console.log(<%=S_SellMemTF%>);
	});

</script>
