<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "BRANCH"
	INFO_MODE = "BRANCH3-1"








%>
<link rel="stylesheet" href="/admin/css/branch.css">
<script type="text/javascript" src="/admin/jscript/branch.js"></script>
</head>
<body>


<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="branch_phone">
	<p class="titles">정책폰 추가</p>
	<form name="frm_insert" method="post" action="branchPhoneHandler.asp" onsubmit="return phoneChk(this);">
	<input type="hidden" name="mode" value="INSERT" />
	<table <%=tableatt%> class="adminFullTable insert">
		<colgroup>
			<col width="200" />
			<col width="800" />
		</colgroup>
		<tr>
			<th>정책폰명</th>
			<td class="subject">
				<input type="text" name="PhoneName" class="input_text" style="width:200px" />
				<label><input type="checkbox" name="isView" value="T" />등록 후 바로 사용합니다.</label>
				<input type="image" src="<%=IMG_BTN%>/btn_submit_gray.gif" style="margin-left:50px;" />
			</td>
		</tr>
	</table>
	</form>
	<p class="titles">택배사 리스트</p>
		<form name="frm_update" method="post" action="branchPhoneHandler.asp">
		<input type="hidden" name="mode" value="" />
		<input type="hidden" name="intIDX" value="" />
	</form>
	<table <%=tableatt%> class="adminFullTable list">
		<colgroup>
			<col width="80" />
			<col width="120" />
			<col width="400" />
			<col width="180" />
			<col width="*" />
		</colgroup>
		<thead>
			<tr>
				<th>No</th>
				<th>사용여부</th>
				<th>정책폰명</th>
				<th>등록일</th>
				<th>기능</th>
			</tr>
		</thead>
	</table>
	<%

		' ===================================================================
		' 게시판 변수 받아오기(설정)
		' ===================================================================
			Dim SEARCHTERM, SEARCHSTR, PAGE, PAGESIZE
				SEARCHTERM = Request.Form("SEARCHTERM")
				SEARCHSTR = Request.Form("SEARCHSTR")
				PAGE = Request.Form("page")
				PAGESIZE = 16

			If SEARCHTERM = "" Then SEARCHTERM = "" End If
			If SEARCHSTR = "" Then SEARCHSTR = "" End if
			If PAGE="" Then PAGE = 1 End If


			arrParams = Array( _
				Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE), _
				Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
				Db.makeParam("@SEARCHSTR",adVarChar,adParamInput,30,SEARCHSTR), _
				Db.makeParam("@SEARCHTERM",adVarChar,adParamInput,30,SEARCHTERM), _


				Db.makeParam("@ALL_COUNT",adInteger,adParamOutput,0,0) _

			)
			arrList = Db.execRsList("DKP_ADMIN_BRANCH_PHONE_LIST",DB_PROC,arrParams,listLen,Nothing)

			All_Count = arrParams(UBound(arrParams))(4)
			Dim PAGECOUNT,CNT
			PAGECOUNT = Int((CCur(All_Count) - 1 ) / CInt(PAGESIZE) ) + 1
			IF CCur(PAGE) = 1 Then
				CNT = All_Count
			Else
				CNT = All_Count - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
			End If


			If IsArray(arrList) Then
				For i = 0 To listLen
					ThisNum = (ALL_COUNT - cInt(arrList(0,i))) + 1

					Select Case arrList(3,i)
						Case "T" :  chgBtn = aImgSt("javascript:ChgBranchPhoneView('"&arrList(1,i)&"')",IMG_BTN&"/btn_chg_useF_85.gif",85,22,"","","vmiddle")
						Case "F" :  chgBtn = aImgSt("javascript:ChgBranchPhoneView('"&arrList(1,i)&"')",IMG_BTN&"/btn_chg_useT_85.gif",85,22,"","","vmiddle")
						Case Else : chgBtn = "Undefined"
					End Select
					PRINT tabs(1)&"<form name=""frms"&arrList(1,i)&""" method=""post"" action=""branchPhoneHandler.asp"" onsubmit=""return chkThisFrm(this);"">"
					PRINT tabs(1)&" <input type=""hidden"" name=""mode"" value=""UPDATE"" />"
					PRINT tabs(1)&" <input type=""hidden"" name=""intIDX"" value="""&arrList(1,i)&""" />"
					PRINT tabs(1)&"	<table "&tableatt&" class=""adminFullTable lists"">"
					PRINT tabs(1)&"			<colgroup>"
					PRINT tabs(1)&"				<col width=""80"" />"
					PRINT tabs(1)&"				<col width=""120"" />"
					PRINT tabs(1)&"				<col width=""400"" />"
					PRINT tabs(1)&"				<col width=""180"" />"
					PRINT tabs(1)&"				<col width=""*"" />"
					PRINT tabs(1)&"			</colgroup>"
					PRINT tabs(1)&"			<tbody>"
					PRINT tabs(1)&"		<tr>"
					PRINT tabs(1)&"			<td>"&ThisNum&"</td>"
					PRINT tabs(1)&"			<td>"&TFVIEWER(arrList(3,i),"USE")&"</td>"
					PRINT tabs(1)&"			<td><input type=""text"" name=""phoneName"" class=""input_text"" style=""width:390px;"" value="""&arrList(2,i)&""" /></td>"
					PRINT tabs(1)&"			<td>"&arrList(4,i)&"</td>"
					PRINT tabs(1)&"			<td><input type=""image"" src="""&IMG_BTN&"/btn_gray_update.gif"" />"&"&nbsp;"&chgBtn&"</td>"
					PRINT tabs(1)&"		</tr>"
					PRINT tabs(1)&"	</table>"
					PRINT tabs(1)&"</form>"
				Next
			Else
			End If
		%>
	<div class="paging_area"><% Call pageList(PAGE,PAGECOUNT)%></div>
</div>
		<form name="frm" method="post" action="">
			<input type="hidden" name="PAGE" value="<%=PAGE%>" />
		</form>
<!--#include virtual = "/admin/_inc/copyright.asp"-->

