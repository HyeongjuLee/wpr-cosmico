<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "CONFIG"
	INFO_MODE = "CONFIG2-1"

	agreeType = gRequestTF("type",True)
	strNationCode = Request("nc")


	Select Case agreeType
		Case "policy01"
			INFO_MODE = "CONFIG2-1"
		Case "policy02"
			INFO_MODE = "CONFIG2-2"
		Case "policy03"
			INFO_MODE = "CONFIG2-3"
		Case "policy04"
			INFO_MODE = "CONFIG2-4"
		Case "policy05"
			INFO_MODE = "CONFIG2-5"
		Case "policy06"
			INFO_MODE = "CONFIG2-6"
		Case "delivery"
			INFO_MODE = "CONFIG2-7-"&DKRS_FA_intSort&""

		Case "PAYTAG01"
			INFO_MODE = "CONFIGPTG-1"
		Case "PAYTAG02"
			INFO_MODE = "CONFIGPTG-2"
		Case "PAYTAG03"
			INFO_MODE = "CONFIGPTG-3"

		Case "KSNET01"
			INFO_MODE = "CONFIGKSNET-1"

	End Select
	'INFO_TEXT = DKRS_FA_strNationName&"의"


	'SQL = "SELECT [policyContent] FROM [DK_POLICY] WHERE [delTF] = 'F' AND [policyType] = ?"
	arrParams = Array(_
		Db.makeParam("@policyType",adVarChar,adParamInput,20,agreeType), _
		Db.makeParam("@strNationCode",adVarChar,adParamInput,6,viewAdminLangCode) _
	)
	policyContent = Db.execRsData("DKPC_POLICY_CONTENT",DB_PROC,arrParams,Nothing)
	If policyContent <> "" Then policyContent = Replace(policyContent,"OOO",LNG_SITE_TITLE)

'PRINT strNationCode
%>
<%=CONST_SmartEditor_JS%>
<link rel="stylesheet" href="/admin/css/policy.css" />
<script type="text/javascript" language="javascript">
<!--
	function frmCheck(form){
		oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);
		//form.content1.value = document.getElementById("ir1").value;

		var msg = "등록하시겠습니까?";
		if(confirm(msg)){
			return true;
		}else{
			return false;
		}
	}
//-->
</script>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div class="policy">
	<form name="frm" method="post" action="policyHandler.asp" onsubmit="return frmCheck(this)">
		<input type="hidden" name="type" value="<%=agreeType%>" readonly="readonly" />
		<input type="hidden" name="strNationCode" value="<%=viewAdminLangCode%>" readonly="readonly" />
		<!-- <textarea name="GoodsContent" id="GoodsContent" style="display:none" cols="50" rows="10"></textarea> -->
		<textarea name="content1" id="ir1" style="width:100%;height:650px;display:none;" cols="50" rows="10"><%=backword(policyContent)%></textarea>
		<%=FN_Print_SmartEditor("ir1","policy",UCase(viewAdminLangCode),"","","")%>

		<div class="submit"><input type="submit" class="input_submit_b design1" value="정책 저장" /></div>

	</form>
</div>

<!--#include virtual = "/admin/_inc/copyright.asp"-->
