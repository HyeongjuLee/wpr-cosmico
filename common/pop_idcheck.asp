<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	Dim DKSP : Set DKSP = SERVER.CreateObject("ADODB.COMMAND")

	strID = pRequestTF("strID",True)

'	SQL = "SELECT COUNT([strAdminID]) FROM [DK_SHOP_BASIC_INFO] WHERE [strAdminID] = ?"
'	arrParams = Array(_
'		Db.makeParam("@strID",adVarChar,adParamInput,20,strID) _
'	)
'	intAdminCnt = CInt(Db.execRsData(SQL,DB_TEXT,arrParams,Nothing))

	SQL = "SELECT [strBlockID] FROM [DK_SITE_CONFIG] WHERE [strSiteID] = 'www'"
	blockID = Db.execRsData(SQL,DB_TEXT,null,Nothing)

	If IsNull(blockID) Then blockID = ""
	blockID = Trim(blockID)


	id_oks = True

	If InStr(","& blockID &",", ","& strID &",") > 0 Then id_oks = False



	SQL = " SELECT COUNT([strUserID]) FROM [DK_MEMBER]  WHERE [strUserID] = ?"
	arrParams = Array(_
		Db.makeParam("@strID",adVarChar,adParamInput,20,strID) _
	)
	intMemCnt = CInt(Db.execRsData(SQL,DB_TEXT,arrParams,Nothing))



	If Int(intMemCnt) > 0  Then
		id_oks = False
	End If

%>
<!--#include virtual = "/_include/document.asp"-->
<script type="text/javascript">
<!--
	opener.document.cfrm.idcheck.value = '<%=strID%>';
//-->
</script>
<style type="text/css">
	div#zip_top {clear:both; float:left;width:300px; height:40px;background:url(/images/join/pop_title_bg.jpg) 0 0 repeat-x;overflow:hidden;}

	div#close {height:30px;text-align:center;margin-top:13px;}
	.line1 {height:1px; background-color:#dedede;}
	.line2 {height:2px; background-color:#f4f4f4;}
	div#contents {clear:both;color:#555;padding-top:20px; width:300px;height:60px;overflow:hidden;}
</style>
</head>
<body>
<div id="zip_top"><img src="<%=IMG_JOIN%>/pop_title_idcheck.jpg" width="250" height="40" alt="아이디 중복검사 이미지" /></div>
<div id="contents">
<%If id_oks Then%>
	<p style="font-weight:bold; color:#0099CC; text-align:center;">사용가능</p>
	<center>사용할 수 있는 아이디입니다.</center>
<%else%>
	<p style="font-weight:bold; color:#FF9900; text-align:center;">사용불가</p>
	<center>이미 사용중인 아이디입니다.<br>다른 아이디를 사용해 주세요.</center>
<%End If%>
</div>
<div id="close">
<div class="line1"></div>
<div class="line2"></div>
<img src="<%=IMG_JOIN%>/btn_close01.gif" width="52" height="23" alt="창 닫기" style="margin-top:4px; cursor:pointer;" onclick="self.close();"/>
</div>

</body>
</html>
