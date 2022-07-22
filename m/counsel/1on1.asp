<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/counsel/1on1_config.asp"-->
<%
	'◆◆◆ 휴대전화, 이메일 없는경우 직접 입력가능 ◆◆◆

	PAGE_SETTING = "CUSTOMER"
	PAGE_SETTING2 = "SUBPAGE"
	ISSUBTOP = "T"
	IS_LANGUAGESELECT = "F"

	mNum = 5
	sNum = 3
	sVar = sView
	view = sNum

	If PAGE_SETTING = "MYOFFICE" Then
		Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,2)
		Call ONLY_CS_MEMBER()
	End If

	arrParams = Array(_
		Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
	)
	Set DKRS = Db.execRs("DKP_MEMBER_INFO",DB_PROC,arrParams,DB3)
	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_mbid				= DKRS("mbid")
		DKRS_mbid2				= DKRS("mbid2")
		DKRS_M_Name				= DKRS("M_Name")
		DKRS_E_name				= DKRS("E_name")
		DKRS_Email				= DKRS("Email")
		DKRS_cpno				= DKRS("cpno")
		DKRS_Addcode1			= DKRS("Addcode1")
		DKRS_Address1			= DKRS("Address1")
		DKRS_Address2			= DKRS("Address2")
		DKRS_Address3			= DKRS("Address3")
		DKRS_reqtel				= DKRS("reqtel")
		DKRS_officetel			= DKRS("officetel")
		DKRS_hometel			= DKRS("hometel")
		DKRS_hptel				= DKRS("hptel")
		DKRS_LineCnt			= DKRS("LineCnt")
		DKRS_N_LineCnt			= DKRS("N_LineCnt")
		DKRS_Recordid			= DKRS("Recordid")
		DKRS_Recordtime			= DKRS("Recordtime")
		DKRS_businesscode		= DKRS("businesscode")
		DKRS_bankcode			= DKRS("bankcode")
		DKRS_banklocal			= DKRS("banklocal")
		DKRS_bankaccnt			= DKRS("bankaccnt")
		DKRS_bankowner			= DKRS("bankowner")
		DKRS_Regtime			= DKRS("Regtime")
		DKRS_Saveid				= DKRS("Saveid")
		DKRS_Saveid2			= DKRS("Saveid2")
		DKRS_Nominid			= DKRS("Nominid")
		DKRS_Nominid2			= DKRS("Nominid2")
		DKRS_RegDocument		= DKRS("RegDocument")
		DKRS_CpnoDocument		= DKRS("CpnoDocument")
		DKRS_BankDocument		= DKRS("BankDocument")
		DKRS_Remarks			= DKRS("Remarks")
		DKRS_LeaveCheck			= DKRS("LeaveCheck")
		DKRS_LineUserCheck		= DKRS("LineUserCheck")
		DKRS_LeaveDate			= DKRS("LeaveDate")
		DKRS_LineUserDate		= DKRS("LineUserDate")
		DKRS_LeaveReason		= DKRS("LeaveReason")
		DKRS_LineDelReason		= DKRS("LineDelReason")
		DKRS_WebID				= DKRS("WebID")
		DKRS_WebPassWord		= DKRS("WebPassWord")
		DKRS_BirthDay			= DKRS("BirthDay")
		DKRS_BirthDay_M			= DKRS("BirthDay_M")
		DKRS_BirthDay_D			= DKRS("BirthDay_D")
		DKRS_BirthDayTF			= DKRS("BirthDayTF")
		DKRS_Ed_Date			= DKRS("Ed_Date")
		'DKRS_Ed_TF				= DKRS("Ed_TF")				'신버전삭제
		DKRS_PayStop_Date		= DKRS("PayStop_Date")
		DKRS_PayStop_TF			= DKRS("PayStop_TF")
		DKRS_For_Kind_TF		= DKRS("For_Kind_TF")
		DKRS_Sell_Mem_TF		= DKRS("Sell_Mem_TF")
		DKRS_CurGrade			= DKRS("CurGrade")

		Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV
			On Error Resume Next
				If DKRS_Address1		<> "" Then DKRS_Address1	= objEncrypter.Decrypt(DKRS_Address1)
				If DKRS_Address2		<> "" Then DKRS_Address2	= objEncrypter.Decrypt(DKRS_Address2)
				If DKRS_Address3		<> "" Then DKRS_Address3	= objEncrypter.Decrypt(DKRS_Address3)
				If DKRS_hometel			<> "" Then DKRS_hometel		= objEncrypter.Decrypt(DKRS_hometel)
				If DKRS_hptel			<> "" Then DKRS_hptel		= objEncrypter.Decrypt(DKRS_hptel)
				If DKRS_Email		<> "" Then DKRS_Email		= objEncrypter.Decrypt(DKRS_Email)
			On Error GoTo 0
		Set objEncrypter = Nothing

	Else
		Call ALERTS(LNG_JS_MEMBERINFO_FAIL,"back","")
	End If
	Call closeRS(DKRS)

	'If DKRS_hptel = "" Then
	'	'Call ALERTS(LNG_1on1_NO_MOBILE01&"\n"&LNG_1on1_GOTO_MYPAGE,"GO",M_MEMBER_INFO_LINK_URL)
	'End If

%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<link rel="stylesheet" href="/m/css/1on1.css?v1" />
<script type="text/javascript">
<!--

	$(document).ready(function(){
		var fileTarget = $('.filebox .upload-hidden');

		fileTarget.on('change', function(){
			if(window.FileReader){ // 파일명 추출
				var filename = $(this)[0].files[0].name;
			} else { // Old IE 파일명 추출
				var filename = $(this).val().split('/').pop().split('\\').pop();
			};
			$(this).siblings('.upload-name').val(filename);
		});



		var prev_val;
		var prev_val2;
		$('#Cate1').on('focus',function() {
			prev_val = $(this).val();
		}).change(function(){
			chg_category(prev_val);
		});

		$("#Cate2").on('focus',function() {
			prev_val2 = $(this).val();
		}).change(function(){
			setDefaultText($(this).val(),prev_val2);
		});
	});

	function chg_category(prev_val) {

		var ftf = $("#fSelectTF").val();
		var stf = $("#sSelectTF").val();

		if (ftf != 'F') {
			if (confirm('<%=LNG_1on1_CATEGORY_CHANGE%>')) {
				setCate1Change();
				$("#sSelectTF").val('F');
				if ($("#Cate1").val() == '') {
					$("#fSelectTF").val('F');
				} else {
					$("#fSelectTF").val('T');
				}
			} else {
				$("#Cate1").val(prev_val);
			}
		} else {
			setCate1Change();
			$("#fSelectTF").val('T');

		}
	}
	function setDefaultText(code,prev_code) {
		//alert(code);
		//alert(prev_code);
		var f = document.cfrm;
		var stf = $("#sSelectTF").val();

		if (stf != 'F') {
			if (confirm('<%=LNG_1on1_CATEGORY_CHANGE%>')) {
				setCate2Change(code);
				if ($("#Cate2").val() == '') {
					$("#sSelectTF").val('F');
				} else {
					$("#sSelectTF").val('T');
				}
			} else {
				$("#Cate2").val(prev_code);
			}
		} else {
			setCate2Change(code);
			$("#sSelectTF").val('T');
		}

	}

	function setCate1Change() {
		mode = "category2";
		cate = $('#Cate1').val();

		$("#strContent").attr({"disabled":true, "placeholder":"<%=LNG_CS_GETCATE2_TEXT01%>" }).val('');
		$("#strSubject").attr("disabled",true).attr("placeholder","<%=LNG_CS_GETCATE2_TEXT01%>").val('');
		$("#Cate2").attr("disabled",true);
		$("#Cate2").html("<option value=''><%=LNG_CS_GOODSLIST_JS01%></option>");
		$('tr.file, tr.member').addClass('disabled');

		if (cate.length == 0) {
			$("#Cate2").attr("disabled",true);
			$("#Cate2").html("<option value=''><%=LNG_CS_GOODSLIST_JS01%></option>");
		} else {
			$.ajax({
				type: "POST"
				,url: "/counsel/1on1_Category_d2.asp"
				,data: {
					 "mode"				: mode
					,"cate"				: cate
					,"strNationCode"	: '<%=LANG%>'

				}
				,success: function(data) {
					var FormErrorChk = data.split(",");
					if (FormErrorChk[0] == "FORMERROR")
					{
						//alert("필수값:"+FormErrorChk[1]+"가 넘어오지 않았습니다.\n다시 시도해주세요");
						alert("<%=LNG_STRFUNC_TEXT01%>:"+FormErrorChk[1]+".\n<%=LNG_1on1_TRY_AGAIN%>");
						loadings();
					} else {
						$("#Cate2").attr("disabled",false);
						$("#Cate2").html(data);
					}
				}
				,error:function(data) {
					loadings();
					alert("<%=LNG_AJAX_ERROR_MSG%> "+data.status+" "+data.statusText+" "+data.responseText);
				}
			});
		}
	}
	function setCate2Change(code) {
		if (code == '') {
			$("#strContent").attr({"disabled":true, "placeholder":"<%=LNG_CS_GETCATE2_TEXT01%>" }).val('');
			$("#strSubject").attr("disabled",true).attr("placeholder","<%=LNG_CS_GETCATE2_TEXT01%>").val('');
			$("#sSelectTF").val('F');
			$('tr.file, tr.member').addClass('disabled');

			<%If DKRS_hptel = "" Then	'◆◆◆%>
				$("input[name=AstrMobile]").attr("readonly",true).addClass('readonly').val('');
			<%End If %>
			<%If DKRS_Email = "" Then	'◆◆◆%>
				$("input[name=AstrEmail]").attr("readonly",true).addClass('readonly').val('');
			<%End IF%>

		} else {
			$.ajax({
				type: "POST"
				,url: "/counsel/1on1_Category_dt.asp"
				,data: {
					 "CateCode"		: code
					,"NationCode"	: '<%=LANG%>'

				}
				,success: function(xhrData) {
					jsonData = $.parseJSON(xhrData);
					if (jsonData.result == 'SUCCESS') {
						//$("#strContent").attr({"disabled":false, "placeholder":"<%=LNG_1on1_ENTER_INQUIRY%>\n<%=LNG_1on1_ILLEGAL_CONTENT_MAYBE_DELETED%>" }).val(jsonData.resultMsg);
						$("#strContent").attr({"disabled":false, "placeholder":"<%=LNG_1on1_ENTER_INQUIRY%>\n<%=LNG_1on1_ILLEGAL_CONTENT_MAYBE_DELETED%>" }).val(jsonData.resultMsg.replace(/<br \/>/gi, '\n'));
						$("#strSubject").attr("disabled",false).attr("placeholder","<%=LNG_1on1_ENTER_TITLE%>").val('');
						$('tr.file').removeClass('disabled');

						<%If DKRS_hptel = "" Then	'◆◆◆%>
							$("input[name=AstrMobile]").attr("disabled",false);
							$("input[name=AstrMobile]").attr("readonly",false).removeClass('readonly');
							$('tr.member').removeClass('disabled');
						<%End If %>
						<%If DKRS_Email = "" Then	'◆◆◆%>
							$("input[name=AstrEmail]").attr("disabled",false);
							$("input[name=AstrEmail]").attr("readonly",false).removeClass('readonly');
							$('tr.member').removeClass('disabled');
						<%End If %>

					} else {
						alert(jsonData.resultMsg);
					}
				}
				,error:function(xhrData) {
					loadings();
					alert("<%=LNG_AJAX_ERROR_MSG%> "+xhrData.status+" "+xhrData.statusText+" "+xhrData.responseText);
				}
			});
		}
	}

	function chkThisForm(f) {
		var f = document.cfrm;

		/*
		if (!checkEmail(f.strEmail.value)) {
			alert("<%=LNG_JS_EMAIL_CONFIRM%>");
			f.strEmail.focus();
			return false;
		}
		*/
		if (!chkNull(f.Cate1,"<%=LNG_CS_GETCATE2_TEXT01%>")) return false;
		if (!chkNull(f.Cate2,"<%=LNG_CS_GETCATE2_TEXT02%>")) return false;
		if (!chkNull(f.strSubject,"<%=LNG_COUNSEL_JS04%>")) return false;
		if (!chkNull(f.strContent,"<%=LNG_COUNSEL_JS05%>")) return false;
		//if (!chkNull(f.strMobile,"<%=LNG_JS_MOBILE%>")) return false;

		<%IF DKRS_hptel = "" Then%>
			if (chkEmpty(f.AstrMobile)) {
				alert("<%=LNG_JS_MOBILE%>");
				f.AstrMobile.focus();
				return false;
			}
			if (!chkMob(f.AstrMobile.value)) {
				alert("<%=LNG_JS_MOBILE_FORM_CHECK%>");
				f.AstrMobile.focus();
				return false;
			}
		<%End If%>
		<%IF DKRS_Email = "" Then%>
			if (f.AstrEmail.value == '')
			{
				alert("<%=LNG_JS_EMAIL%>");
				f.AstrEmail.focus();
				return false;
			}
			if (!checkEmail(f.AstrEmail.value)) {
				alert("<%=LNG_JS_EMAIL_CONFIRM%>");
				f.AstrEmail.focus();
				return false;
			}
		<%End If%>

		f.submit();
	}

	var fileNameChange = function(){
		var file = $('tr.file').find('input[type="file"]');
		$('tr.file input[type="file"]').on('change', function(){
			var place = $(this).parents('td').find('.upload-name').attr('placeholder');
			var fileName = $(this).val();
			$(this).parents('td').find('.upload-name').attr('placeholder', fileName).addClass('active');
			//debugger;
		});
	}

	$(function(){
		$('tr.file, tr.member').addClass('disabled');
		fileNameChange();
	});
// -->
</script>
</head>
<body onUnload="">
<!--#include virtual = "/m/_include/header.asp"-->
<input type="hidden" name="fSelectTF" id="fSelectTF" value="F" />
<input type="hidden" name="sSelectTF" id="sSelectTF" value="F" />
<div id="counseling" class="cs_write" style>
	<ul class="info">
		<!-- <li><%=LNG_1on1_NOTICE01%></li> -->
		<li><%=LNG_1on1_NOTICE02%></li>
		<li><%=LNG_1on1_NOTICE03%></li>
	</ul>
	<form name="cfrm" action="1on1_handler.asp" method="post" enctype="multipart/form-data">
		<table <%=tableatt%> class="board write">
			<!-- <col width="100" />
			<col width="*" /> -->
			<col width="25%" />
			<col width="75%" />
			<tr class="category">
				<!-- <th><%=LNG_TEXT_CATEGORY%></th> -->
				<td colspan="2">
					<div>
						<select id="Cate1" name="Cate1" class="input_select">
							<option value=""><%=LNG_CS_GETCATE2_TEXT01%></option>
							<%
								arrParams = Array(_
									Db.makeParam("@strNationCode",adVarChar,adParamInput,6,LANG), _
									Db.makeParam("@strCatrParent",adVarChar,adParamInput,20,"000") _
								)
								arrList = Db.execRsList("DKSP_COUNSEL_1ON1_CATEGORY_LIST",DB_PROC,arrParams,listLen,Nothing)
								If Not IsArray(arrList) Then
									PRINT "<option value="""">"&LNG_1on1_NO_MENU&"</option>"
								Else
									For i = 0 To listLen
										arrList_intIDX				= arrList(1,i)
										arrList_strCateCode			= arrList(3,i)
										arrList_strCateName			= arrList(4,i)
										arrList_strCateParent		= arrList(5,i)
										arrList_intCateDepth		= arrList(6,i)
										arrList_intCateSort			= arrList(7,i)
										arrList_isView				= arrList(8,i)
										PRINT "<option value="""&arrList_strCateCode&""""& isSelect(CATEGORYS1,arrList_strCateCode)&">"&arrList_strCateName&"</option>"
									Next
								End If
							%>
						</select>
						<select id="Cate2" name="Cate2" class="input_select" disabled="disabled">
							<option value=""><%=LNG_CS_GOODSLIST_JS01%></option>
						</select>
					</div>
				</td>
			</tr>
			<tr class="title">
				<!-- <th><%=LNG_TEXT_TITLE%></th> -->
				<td colspan="2">
					<input type="text" name="strSubject" id="strSubject" class="input_text" value="" disabled="disabled" placeholder="<%=LNG_CS_GETCATE2_TEXT01%>" />
				</td>
			</tr>
			<tr class="contents">
				<!-- <th class="vtop"><%=LNG_TEXT_CONTENT%></th> -->
				<td colspan="2">
					<textarea name="strContent" id="strContent" class="input_area" disabled="disabled" placeholder="<%=LNG_CS_GETCATE2_TEXT01%>"></textarea>
				</td>
			</tr>
			<%If USE_DATA1 = "T" Then%>
			<tr class="file disabled">
				<th><%=LNG_TEXT_FILE1%></th>
				<td>
					<div>
						<input class="upload-name" readonly placeholder="<%=LNG_1on1_FILE_SELECT%> <%=LNG_1on1_FILE_LESS_THAN_00%>">
						<label for="strData1" class="ser">
							<input type="file" id="strData1" name="strData1" class="upload-hidden">
							<span><%=LNG_1on1_FILE_SEARCH%></span>
						</label>
					</div>
				</td>
			</tr>
			<%End If%>
			<%If USE_DATA2 = "T" Then%>
			<tr class="file disabled">
				<th><%=LNG_TEXT_FILE2%></th>
				<td>
					<div>
						<input class="upload-name" readonly placeholder="<%=LNG_1on1_FILE_SELECT%> <%=LNG_1on1_FILE_LESS_THAN_00%>">
						<label for="strData2" class="ser">
							<input type="file" id="strData2" name="strData2" class="upload-hidden">
							<span><%=LNG_1on1_FILE_SEARCH%></span>
						</label>
					</div>
				</td>
			</tr>
			<%End If%>
			<%If USE_DATA3 = "T" Then%>
			<tr class="file disabled">
				<th><%=LNG_TEXT_FILE3%></th>
				<td>
					<div>
						<input class="upload-name" readonly placeholder="<%=LNG_1on1_FILE_SELECT%>">
						<label for="strData3" class="ser">
							<input type="file" id="strData3" name="strData3" class="upload-hidden">
							<span><%=LNG_1on1_FILE_SEARCH%></span>
						</label>
					</div>
				</td>
			</tr>
			<%End If%>
			<tr class="member disabled">
				<th><%=LNG_TEXT_CONTACT_NUMBER%></th>
				<td>
					<div>
						<%'◆◆◆ disabled 값 안넘어감, readonly 변경%>
						<input type="text" name="AstrMobile" class="input_text readonly" readonly="readonly" value="<%=DKRS_hptel%>" maxlength="15" <%=onLyKeys%> placeholder="" />
						<input type="hidden" name="strMobile" value="<%=DKRS_hptel%>" readonly="readonly" />
						<%If USE_REPLY_MMS = "T" Then%>
							<label for="isSmsSend">
								<input type="checkbox" name="isSmsSend" id="isSmsSend">
								<i class="icon-ok"></i>
								<span><%=LNG_1on1_RESPONSE_TO_CONTACT_NUMBER%></span>
							</label>
						<%Else%>
							<input type="hidden" name="isSmsSend" value="F">
						<%End If%>
					</div>
				</td>
			</tr>
			<tr class="member disabled">
				<th><%=LNG_TEXT_EMAIL%></th>
				<td>
					<div>
						<%'◆◆◆ disabled 값 안넘어감, readonly 변경%>
						<input type="text" name="AstrEmail" class="input_text readonly" read only="readonly" value="<%=DKRS_Email%>" placeholder="" />
						<input type="hidden" name="strEmail" value="<%=DKRS_Email%>" read only="readonly" />
						<%If USE_REPLY_MMS = "T" Then%>
							<label for="isMailSend">
								<input type="checkbox" name="isMailSend" id="isMailSend">
								<i class="icon-ok"></i>
								<span><%=LNG_1on1_RESPONSE_TO_EMAIL%></span>
							</label>
						<%Else%>
							<input type="hidden" name="isMailSend" value="F">
						<%End If%>
					</div>
				</td>
			</tr>
			<tr class="mypage">
				<td colspan="2">
					<!-- <div class="fleft"><input type="checkbox" name="smsSend" id="input_smsSend" value="T" class="input_check" /> <label for="input_smsSend">답변이 등록되면 SMS 로 알림을 받고 싶습니다.</label></div> -->
					<div><%=LNG_1on1_WRONG_MEMBER_INFORMATION%> - <a href="<%=M_MEMBER_INFO_LINK_URL%>" class="underline"><%=LNG_MYPAGE_01%></a></div>
				</td>
			</tr>
		</table>
		<div class="btnZone">
			<!-- <%If DKRS_hptel = "" Then %>
			<a href="javascript:alert('<%=LNG_1on1_NO_MOBILE01%>');" class="promise"><%=LNG_1on1_REGISTER%></a>
			<%Else%>
			<a href="javascript:chkThisForm();" class="promise"><%=LNG_1on1_REGISTER%></a>
			<%End If%> -->
			<a href="javascript:chkThisForm();" class="promise"><%=LNG_1on1_REGISTER%></a>
			<a href="javascript:history.back();" class="cancel"><%=LNG_1on1_CANCEL%></a>
		</div>
	</form>
</div>


<!--#include virtual = "/m/_include/copyright.asp"-->