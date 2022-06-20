<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/MyOffice\point\_point_Config.asp"-->
<%
	'PAGE_SETTING = "MY_MEMBER"
	PAGE_SETTING = "MYOFFICE"
	INFO_MODE	 = "MEMBER2-5"

	ISSUBTOP = "T"


	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1)

	If Not (checkRef(houUrl &"/m/mypage/member_info.asp") _
			Or checkRef(houUrl &"/m/mypage/member_outpin_reset.asp")) Then
		Call alerts(LNG_ALERT_WRONG_ACCESS,"go","/m/mypage/member_info.asp")
	End If

	'입력 / 수정 mode 설정
	IF CONFIG_SendPassWord = "" Then
		mode = "INSERT"
		MONEY_OUTPUT_PIN_TXT = LNG_MONEY_OUTPUT_PIN_REGISTER
	Else
		mode = "MODIFY"
		MONEY_OUTPUT_PIN_TXT = LNG_MONEY_OUTPUT_PIN_CHANGE
	End If

%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<link rel="stylesheet" href="/m/css/member_info.css?v0" />
<script type="text/javascript">

	$(document).ready(function() {
		//새로고침 초기화
		$("input[name=WebPassWord]").val('');
		$("input[name=SendPassWord]").val('');
		$("input[name=SendPassWord2]").val('');
		$("input[name=newSendPassWord]").val('');
		$("input[name=newSendPassWord2]").val('');
	});

	function SendPassWord_Check() {
		let f = document.cfrm;
		let WebPassWord_ori;
		let SendPassWord_ori;
		let SendPassWord;
		let SendPassWord2;

		<%IF mode = "INSERT" Then%>
			WebPassWord_ori = f.WebPassWord;
			SendPassWord_ori = '';
			SendPassWord = f.SendPassWord;
			SendPassWord2 = f.SendPassWord2;
		<%Else%>
			WebPassWord_ori = f.WebPassWord;
			SendPassWord_ori = f.SendPassWord;
			SendPassWord = f.newSendPassWord;
			SendPassWord2 = f.newSendPassWord2;
		<%End If%>

		//출금 PIN
		if (chkEmpty(WebPassWord_ori)) {
			alert("<%=LNG_JS_PASSWORD%>");
			WebPassWord_ori.focus();
			return false;
		}
		<%IF mode = "MODIFY" Then%>
			if (chkEmpty(SendPassWord_ori)) {
				alert("<%=LNG_JS_MONEY_OUTPUT_PIN%>");
				SendPassWord_ori.focus();
				return false;
			}
		<%End If%>
		if (chkEmpty(SendPassWord)) {
			alert("<%=LNG_JS_MONEY_OUTPUT_PIN%>");
			SendPassWord.focus();
			return false;
		}
		if (!checkPass(SendPassWord.value, <%=CONST_OUTPIN_MINIMUM_CHAR%>, <%=CONST_OUTPIN_MAXIMUM_CHAR%>) || !checkEngNum(SendPassWord.value)){
			alert("<%=LNG_JS_MONEY_OUTPUT_PIN_FORM_CHECK%>");
			SendPassWord.focus();
			return false;
		}
		if (chkEmpty(SendPassWord2)) {
			alert("<%=LNG_JS_MONEY_OUTPUT_PIN_CONFIRM%>");
			SendPassWord2.focus();
			return false;
		}
		if (SendPassWord.value != SendPassWord2.value){
			alert("<%=LNG_JS_MONEY_OUTPUT_PIN_CHECK%>");
			SendPassWord2.focus();
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

		<%IF mode = "MODIFY" Then%>
			let ajaxTF = "false";
			$.ajax({
				type: "POST"
				,async : false
				,url: "/mypage/ajax_member_outpin_confirm.asp"
				,data: {
					"SendPassWord_ori": SendPassWord_ori.value
				}
				,success: function(jsonData) {
					//console.log(jsonData);
					let json = $.parseJSON(jsonData);
					//alert(jsonData);
					if (json.result == "success")	{
						$("#loadingPro").show();
						$("#SendPassWord_Check").html("");
						ajaxTF = "true";
					} else {
						$("#SendPassWord_Check").html(json.message).addClass("red tweight").removeClass("blue");
					}
				}
				,error:function(jsonData) {
					alert("<%=LNG_AJAX_ERROR_MSG%> "+jsonData.status+" "+jsonData.statusText+" "+jsonData.responseText);
				}
			});
			if (ajaxTF != "true")
			{
				return false;
			}
		<%End If%>

	}

</script>
</head>
<body>
<!--#include virtual = "/m/_include/header.asp"-->
<style>
	#loadingPro { position: fixed; z-index: 99999; width: 100%; height: 100%; top: 0px; left: 0px; background: url(/images_kr/loading_bg70.png) 0 0 repeat; display: none; }
	#loadingPro .loadingImg { position: relative; top: 40%; text-align: center; }
</style>
<div id="loadingPro">
	<div class="loadingImg" ><img src="<%=IMG%>/159.gif" width="80" alt="" /></div>
</div>
<div id="mypage" class="member_modify width100">
	<form name="cfrm" method="post" action="member_outpin_change_handler.asp" onsubmit="return SendPassWord_Check(this);">
		<input type="hidden" name="mode" value="<%=mode%>" />
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
			<%If mode = "INSERT" Then	'최초 입력%>
				<div class="password">
					<h5><%=LNG_MONEY_OUTPUT_PIN%> <%=starText%></h5>
					<div class="con">
						<input type="password" name="SendPassWord" class="input_text imes" maxlength="8" size="24" onkeyup="noSpace('SendPassWord');" placeholder="" /><span class="summary"><%=LNG_INFO_CHANGE_PIN_TYPE%></span>
						<p class="summary"><%=LNG_MONEY_OUTPUT_PIN_TYPE%></p>
					</div>
				</div>
				<div class="password">
					<h5><%=LNG_MONEY_OUTPUT_PIN_CONFIRM%> <%=starText%></h5>
					<div class="con">
						<input type="password" name="SendPassWord2" class="input_text imes" maxlength="8" size="24" onkeyup="noSpace('SendPassWord2');" placeholder="" />
					</div>
				</div>
			<%ElseIf mode = "MODIFY" Then	'수정%>
				<div class="password">
					<h5><%=LNG_MONEY_OUTPUT_PIN%> <%=starText%></h5>
					<div class="con">
						<input type="password" name="SendPassWord" class="input_text" maxlength="20" />
						<span id="SendPassWord_Check"></span>
					</div>
				</div>
				<div class="password">
					<h5><%=LNG_NEW_MONEY_OUTPUT_PIN%> <%=starText%></h5>
					<div class="con">
						<input type="password" name="newSendPassWord" class="input_text imes" maxlength="8" size="24" onkeyup="noSpace('newSendPassWord');" placeholder="" /><span class="summary"><%=LNG_INFO_CHANGE_PIN_TYPE%></span>
						<p class="summary"><%=LNG_MONEY_OUTPUT_PIN_TYPE%></p>
					</div>
				</div>
				<div class="password">
					<h5><%=LNG_NEW_MONEY_OUTPUT_PIN_CONFIRM%> <%=starText%></h5>
					<div class="con">
						<input type="password" name="newSendPassWord2" class="input_text imes" maxlength="8" size="24" onkeyup="noSpace('newSendPassWord2');" placeholder="" />
					</div>
				</div>
			<%End If%>

		</article>
		<div class="btnZone">
			<input type="submit" class="button" value="<%=LNG_TEXT_CONFIRM%>" />
		</div>
	</form>
</div>

<!--#include virtual = "/m/_include/copyright.asp"-->
