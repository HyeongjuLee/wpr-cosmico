<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/MyOffice\point\_point_Config.asp"-->
<%
	'If webproIP <> "T" Then Call ALERTS("죄송합니다. 현재페이지 업데이트 중입니다.","back","")

	PAGE_SETTING = "MYPAGE"

	If MYOFFICE_MODE_TF = "T" Then
		PAGE_SETTING = "MYOFFICE"
		INFO_MODE	 = "MEMBER2-7"
	End If

	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1)
	'Call ONLY_MEMBER_CONFIRM(DK_MEMBER_LEVEL)

	previousURL = request.ServerVariables("HTTP_REFERER")



	'PAGE_SETTING = "MYPAGE"
	ISLEFT = "T"
	ISSUBTOP = "T"
	ISSUBVISUAL = "T"
	IS_LANGUAGESELECT = "F"

	view = 6
	mNum = 1
	sNum = view

	'If Not (checkRef(houUrl &"/mypage/member_info.asp") Or checkRef(houUrl &"/mypage/member_outpin_reset.asp") )  Then Call ALERTS(LNG_ALERT_WRONG_ACCESS,"go","/mypage/member_info.asp")

	'입력 / 수정 mode 설정
	IF CONFIG_BANKINFO = "T" Then
		mode = "MODIFY"
		'MONEY_OUTPUT_PIN_TXT = LNG_MONEY_OUTPUT_PIN_CHANGE
	Else
		mode = "INSERT"
		'MONEY_OUTPUT_PIN_TXT = LNG_MONEY_OUTPUT_PIN_REGISTER
	End If

%>
<!--#include virtual = "/_include/document.asp"-->
<link rel="stylesheet" href="/css/member_info.css?v2" />
<script type="text/javascript">

	$(document).ready(function() {
		//새로고침 초기화
		$("input[name=WebPassWord]").val('');
		//$("input[name=SendPassWord]").val('');
		//$("input[name=SendPassWord2]").val('');
		//$("input[name=newSendPassWord]").val('');
		//$("input[name=newSendPassWord2]").val('');
	});

	function bankinfo_Check() {
		let f = document.cfrm;
		let WebPassWord_ori;
		let SendPassWord_ori;
		let SendPassWord;
		let SendPassWord2;

		// <%IF mode = "INSERT" Then%>
		// 	WebPassWord_ori = f.WebPassWord;
		// 	SendPassWord_ori = '';
		// 	SendPassWord = f.SendPassWord;
		// 	SendPassWord2 = f.SendPassWord2;
		// <%Else%>
		// 	WebPassWord_ori = f.WebPassWord;
		// 	SendPassWord_ori = f.SendPassWord;
		// 	SendPassWord = f.newSendPassWord;
		// 	SendPassWord2 = f.newSendPassWord2;
		// <%End If%>

		WebPassWord_ori = f.WebPassWord;

		if (chkEmpty(WebPassWord_ori)) {
			alert("<%=LNG_JS_PASSWORD%>");
			WebPassWord_ori.focus();
			return false;
		}

		if (f.bankCode.value == '')	{
			alert("은행을 선택해주세요.");
			f.bankCode.focus();
			return false;
		}

		if (f.BankNumber.value == '')	{
			alert("계좌번호를 입력해주세요");
			f.BankNumber.focus();
			return false;
		}
		if (f.BankNumber.value.length < 11)		{
			alert("정확한 계좌번호를 입력해주세요.");
			f.BankNumber.focus();
			return false;
		}

		if (f.bankOwner.value == '') {
			alert("예금주를 입력해주세요.");
			f.bankOwner.focus();
			return false;
		}
		if (!checkkorText(f.bankOwner.value,1)) {
			alert("정확한 예금주를 입력해 주세요.");
			f.bankOwner.focus();
			return false;
		}


		let ajaxTF1 = "false";
		$.ajax({
			type: "POST"
			,async : false
			,url: "/mypage/ajax_member_password_confirm.asp"
			,data: {
				"WebPassWord_ori": WebPassWord_ori.value,
			}
			,success: function(jsonData) {
				let json = $.parseJSON(jsonData);
				if (json.result == "success")	{
					<%IF mode = "INSERT" Then%>
					$("#loadingPro").show();
					<%End If%>
					$("#WebPassWord_Check").html("");
					ajaxTF1 = "true";
				} else {
					$("#WebPassWord_Check").html(json.message).addClass("red tweight").removeClass("blue");
				}
			}
			,error:function(jsonData) {
				alert("<%=LNG_AJAX_ERROR_MSG%> "+jsonData.status+" "+jsonData.statusText+" "+jsonData.responseText);
			}
		});
		if (ajaxTF1 != "true")
		{
			return false;
		}

	}

</script>
</head>
<body>
<!--#include virtual="/_include/header.asp" -->
<style>
	#loadingPro { position: fixed; z-index: 99999; width: 100%; height: 100%; top: 0px; left: 0px; background: url(/images_kr/loading_bg70.png) 0 0 repeat; display: none; }
	#loadingPro .loadingImg { position: relative; top: 40%; text-align: center; }
</style>
<div id="loadingPro">
	<div class="loadingImg" ><img src="<%=IMG%>/159.gif" width="80" alt="" /></div>
</div>
<div id="mypage" class="member_modify width100">
	<form name="cfrm" method="post" action="member_bankinfo_change_handler.asp" onsubmit="return bankinfo_Check(this);">
		<input type="hidden" name="mode" value="<%=mode%>" readonly="readonly"/>
		<input type="hidden" name="previousURL" value="<%=previousURL%>" readonly="readonly"/>
		<p class="c_s_title2"></p>
		<article>
			<!-- <h6><%=LNG_TEXT_MEMBER_BASIC_INFO%></h6> -->
			<div class="drow">
				<div>
					<h5><%=LNG_TEXT_NAME%></h5>
					<div class="con"><%=DK_MEMBER_NAME%></div>
				</div>
				<div>
					<h5><%=LNG_TEXT_MEMID%></h5>
					<div class="con"><%=DK_MEMBER_ID1%>-<%=Right("000000000"&DK_MEMBER_ID2,MBID2_LEN)%></div>
				</div>
			</div>

			<div class="password">
				<h5><%=LNG_TEXT_PASSWORD%> <%=starText%></h5>
				<div class="con">
					<input type="password" name="WebPassWord" class="input_text" maxlength="20" />
					<span id="WebPassWord_Check"></span>
				</div>
			</div>

			<%'If mode = "MODIFY" Then	'수정%>

			<%
				Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
					objEncrypter.Key = con_EncryptKey
					objEncrypter.InitialVector = con_EncryptKeyIV
					If CONFIG_bankaccnt	<> "" Then CONFIG_bankaccnt	= objEncrypter.Decrypt(CONFIG_bankaccnt)
				Set objEncrypter = Nothing
			%>
			<div class="" style="border-top: 2px solid #b3b3b3">
				<h5>은행 <%=starText%></h5>
				<div class="con">
						<select name="bankCode" class="input_select" style="width: 44%;">
							<option value="">은행을 선택해주세요</option>
							<%
								SQL = "SELECT [ncode],[BankName] FROM [tbl_Bank] WITH(NOLOCK) WHERE [Na_Code] = 'KR' ORDER BY [nCode] ASC"
								'SQL = "SELECT [ncode],[BankName] FROM [tbl_Bank] WITH(NOLOCK) WHERE [Na_Code] = 'KR' AND [Using_Flag] = 'T' ORDER BY [nCode] ASC"
								arrList = Db.execRsList(SQL,DB_TEXT,Nothing,listLen,DB3)
								If IsArray(arrList) Then
									For i = 0 To listLen
										PRINT Tabs(5)& "	<option value="""&arrList(0,i)&""" "&isSelect(arrList(0,i),CONFIG_bankcode)&">"&arrList(1,i)&"</option>"
									Next
								Else
									PRINT Tabs(5)& "	<option value="""">등록된 계좌코드가 없습니다.</option>"
								End If
							%>
						</select>
				</div>
			</div>
			<div class="">
				<h5>계좌번호 <%=starText%></h5>
				<div class="con">
					<input type="text" name="BankNumber" class="input_text " style="width: 44%;" value="<%=CONFIG_bankaccnt%>" placeholder="계좌번호" onkeyup="bankAccountKey(event);" maxlength="20" <%=onLyKeys%> />
				</div>
			</div>
			<div class="">
				<h5>예금주 <%=starText%></h5>
				<div class="con">
					<input type="text" name="bankOwner" class="input_text" style="width: 44%;" value="<%=CONFIG_bankowner%>" maxlength="100" />
				</div>
			</div>
			<%'End If%>

			<div class="btnZone">
				<input type="submit" class="button" value="<%=LNG_TEXT_CONFIRM%>" />
			</div>

		</article>
	</form>
</div>

<!--#include virtual = "/_include/copyright.asp"-->
