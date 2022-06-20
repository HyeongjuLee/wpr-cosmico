<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/MyOffice\point\_point_Config.asp"-->
<%
	'If webproIP <> "T" Then Call ALERTS("죄송합니다. 현재페이지 업데이트 중입니다.","back","")

	PAGE_SETTING = "MYPAGE"

	If MYOFFICE_MODE_TF = "T" Then
		PAGE_SETTING = "MYOFFICE"
		INFO_MODE	 = "MEMBER2-6"
	End If

	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1)
'	Call ONLY_MEMBER_CONFIRM(DK_MEMBER_LEVEL)

	'PAGE_SETTING = "MYPAGE"
	ISLEFT = "T"
	ISSUBTOP = "T"
	ISSUBVISUAL = "T"
	IS_LANGUAGESELECT = "F"

	view = 6
	mNum = 1
	sNum = view

	If Not checkRef(houUrl &"/mypage/member_info.asp") Then Call ALERTS(LNG_ALERT_WRONG_ACCESS,"go","/mypage/member_info.asp")

	IF CONFIG_SendPassWord = "" Then Call ALERTS(LNG_ALERT_WRONG_ACCESS,"go","/m/mypage/member_info.asp")

%>
<!--#include virtual = "/_include/document.asp"-->
<!-- <link rel="stylesheet" href="member_info.css" /> -->
<link rel="stylesheet" href="/css/member_info.css?v1" />
<script type="text/javascript">

	$(document).ready(function() {
		//새로고침 초기화
		$("input[name=WebPassWord]").val('');
		<%If RESET_TO_MAIL = "T" Then%>
			$("input[name=strEmail]").val('');
		<%End If%>
		<%If RESET_TO_MOBILE = "T" Then%>
		$("input[name=strMobile]").val('');
		<%End If%>
	});


	function Money_Output_Pin_Reset_Check() {
		var f = document.cfrm;

		if (chkEmpty(f.WebPassWord)) {
			alert("<%=LNG_JS_PASSWORD%>");
			f.WebPassWord.focus();
			return false;
		}

		<%If RESET_TO_MAIL = "T" Then%>
			if (!checkEmail(f.strEmail.value)) {
				alert("<%=LNG_JS_EMAIL_CONFIRM%>");
				f.strEmail.focus();
				return false;
			}
			<%End If%>

		<%If RESET_TO_MOBILE = "T" Then%>
			if (chkEmpty(f.strMobile)) {
				alert("<%=LNG_JS_MOBILE%>");
				f.strMobile.focus();
				return false;
			}
			if (!chkMob(f.strMobile.value)) {
				alert("<%=LNG_JS_MOBILE_FORM_CHECK%>");
				f.strMobile.focus();
				return false;
			}
		<%End If%>

		var ajaxTF = "false";
		$.ajax({
			type: "POST"
			//,async : false
			,url: "/mypage/ajax_member_outpin_reset.asp"
			,data: {
				<%If RESET_TO_MAIL = "T" Then%>
				"strEmail"		: f.strEmail.value,
				<%End If%>
				<%If RESET_TO_MOBILE = "T" Then%>
				"strMobile"		: f.strMobile.value,
				<%End If%>
				"WebPassWord"	: f.WebPassWord.value
			}
			,beforeSend: function(){
				$('#loadingPro').show();
			}
			,complete : function(){
				$('#loadingPro').hide();
			}
			,success: function(jsonData) {
				//console.log(jsonData);
				var json = $.parseJSON(jsonData);
				//alert(jsonData);
				if (json.result == "success")
				{
					if (left(json.message,5) == "error") {
						$("#Money_Output_Pin_Reset_Check").html(json.message).addClass("red tweight").removeClass("blue");
					} else {
						$("#Money_Output_Pin_Reset_Check").html(json.message + '<br /><%=LNG_AJAX_OUTPIN_RESET_CHANGE_ALERT%>').addClass("blue tweight").removeClass("red");
						setTimeout(function() {
							alert(json.message);
							ajaxTF = "true";
							document.cfrm.submit();
						},300);
					}

				} else {
					$("#Money_Output_Pin_Reset_Check").html(json.message).addClass("red tweight").removeClass("blue");
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
	<form name="cfrm" method="post" action="/mypage/member_outpin_change.asp" onsubmit="return Money_Output_Pin_Reset_Check(this);">
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
					<span id="Money_Output_Pin_Reset_Check"></span>
					<span style="color:red;"></span>
					<!-- <input type="password" name="WebPassWord" class="input_text" maxlength="20" />
					<span id="WebPassWord_Check"></span> -->
				</div>
			</div>
			<%If RESET_TO_MAIL = "T" Then%>
			<div class="email mobile">
				<h5><%=LNG_TEXT_EMAIL%> <%=startext%></h5>
				<div class="con">
					<input type="email" name="strEmail" class="input_text imes width95a" style="width: 250px;" value=""/>
				</div>
			</div>
			<%End If%>
			<%If RESET_TO_MOBILE = "T" Then%>
			<div class="mobile">
				<h5><%=LNG_TEXT_MOBILE%> <%=startext%></h5>
				<div class="con">
					<input type="tel" id="strMobile" name="strMobile" maxlength="15" class="input_text imes" style="width: 250px;" <%=onLyKeys%> oninput="maxLengthCheck(this)" />
				</div>
			</div>
			<%End If%>

			<div class="btnZone">
				<input type="submit" class="button" value="<%=LNG_TEXT_CONFIRM%>" />
			</div>
		</article>
	</form>
</div>

<!--#include virtual = "/_include/copyright.asp"-->
