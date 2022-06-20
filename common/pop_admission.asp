<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/_include/document.asp" -->
<%
	Dim popWidth : popWidth = 500
	Dim popHeight : popHeight = 600
	If DK_MEMBER_TYPE = "COMPANY" Then
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
			DKRS_hometel			= DKRS("hometel")
			DKRS_hptel				= DKRS("hptel")

			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				On Error Resume Next
					If DKRS_Email		<> "" Then DKRS_Email		= objEncrypter.Decrypt(DKRS_Email)
					If DKRS_hometel			<> "" Then DKRS_hometel		= objEncrypter.Decrypt(DKRS_hometel)
					If DKRS_hptel			<> "" Then DKRS_hptel		= objEncrypter.Decrypt(DKRS_hptel)
				On Error GoTo 0
			Set objEncrypter = Nothing
		Else
			Call ALERTS(LNG_JS_MEMBERINFO_FAIL,"back","")
		End If
		Call closeRS(DKRS)
	End If

%>
<link rel="stylesheet" href="/css/admission.css?v0">
<style>
	/* loading */
	.loadingsA {position: fixed; height: 100%; width: 100%; background:url(/images_kr/join/loading_bg70_1.png) 0 0 repeat; z-index:999; display: none; top: 0px; left: 0px;}
	.loadingsInnerA {position: relative; top:40%; text-align:center;}
</style>
<script>
	function chkAdmission(f){
		if(!chkNull(f.strMobile, "<%=LNG_JS_MOBILE%>")) return false;
		if(!chkNull(f.strEmail, "<%=LNG_JS_EMAIL%>")) return false;
		if (!checkEmail(f.strEmail.value)) {
			alert("<%=LNG_JS_EMAIL_CONFIRM%>");
			f.strEmail.focus();
			return false;
		}
		if(!chkNull(f.strSubject, "<%=LNG_COUNSEL_JS04%>")) return false;
		if(!chkNull(f.strContent, "<%=LNG_COUNSEL_JS05%>")) return false;

		$("#loadingsA").show();
		var ajaxTF = "false";
		$.ajax({
			type: "POST"
			//,async : false
			,url: "ajax_pop_admission.asp"
			,data: {
				"strMobile"	: f.strMobile.value,
				"strEmail"	: f.strEmail.value,
				"strSubject"		: f.strSubject.value,
				"strContent"		: f.strContent.value
			}
			,success: function(jsonData) {
				var json = $.parseJSON(jsonData);
				//alert(jsonData);
				if (json.result == "success") {
					alert(json.message);
					$("#loadingsA").hide();
					self.close();
				} else {
					alert(json.message);
					$("#loadingsA").hide();
					return false;
				}
			}
			,error:function(jsonData) {
				alert("<%=LNG_AJAX_ERROR_MSG%> "+jsonData.status+" "+jsonData.statusText+" "+jsonData.responseText);
			}

		});
		if (ajaxTF != "true")
		{
			doubleSubmit = false;
			return false;
		}

	}
</script>
</head>
<div id="loadingsA" class="loadingsA">
	<div class="loadingsInnerA">
		<img src="<%=IMG%>/159.gif" width="60" alt="" />
	</div>
</div>
<body>
	<form name="frm2s" method="post" action="ajax_pop_admission.asp" >
		<div class="admission">
			<div class="title">
				<h1><%=LNG_BOTTOM_GOODS%></h1>
				<div class="logo"><img src="/images/share/logo(1).svg" alt=""></div>
			</div>
			<div class="contents">
				<div class="inputs">
					<input type="text" name="strMobile" class="input_text" maxlength="15" <%=onLyKeys%> value="<%=DKRS_hptel%>" placeholder="<%=LNG_ADMISSION_01%>">
					<input type="text" name="strEmail" class="input_text" maxlength="100" value="<%=DKRS_Email%>" placeholder="<%=LNG_ADMISSION_02%>">
					<input type="text" name="strSubject" class="input_text" maxlength="100" placeholder="<%=LNG_ADMISSION_03%>">
					<textarea name="strContent" class="input_text" placeholder="<%=LNG_ADMISSION_04%>"></textarea>
				</div>
				<input type="button" class="promise" value="<%=LNG_ADMISSION_05%>"  onclick="chkAdmission(this.form);">
			</div>
		</div>
	</form>
	<script type="text/javascript">
		resizePopupWindow(parseInt("<%=popWidth%>", 10), parseInt("<%=popHeight%>", 10));
	</script>
</body>
</html>