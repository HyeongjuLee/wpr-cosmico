<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "MEMBER"
	INFO_MODE = "MEMBER1-4"
' ===================================================================
'
' ===================================================================
' ===================================================================


' ===================================================================
' 게시판 변수 받아오기(설정)
' ===================================================================
	Dim SEARCHTERM, SEARCHSTR, PAGE, PAGESIZE
		SEARCHTERM = Request.Form("SEARCHTERM")
		SEARCHSTR = Request.Form("SEARCHSTR")
		memberType = Request.Form("memberType")
		PAGE = Request.Form("page")
		PAGESIZE = 16

	If SEARCHTERM = "" Then SEARCHTERM = "" End If
	If SEARCHSTR = "" Then SEARCHSTR = "" End if
	If PAGE="" Then PAGE = 1 End If
	If ORDERS = "" Then ORDERS = "AA"
	If memberType = "" Then memberType = ""
' ===================================================================



' ===================================================================
' 데이터 가져오기
' ===================================================================
	arrParams = Array( _
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE), _
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
		Db.makeParam("@SEARCHSTR",adVarChar,adParamInput,30,convSql(SEARCHSTR)), _
		Db.makeParam("@SEARCHTERM",adVarChar,adParamInput,30,SEARCHTERM), _
		Db.makeParam("@memberType",adChar,adParamInput,1,memberType), _

		Db.makeParam("@ORDERS",adVarChar,adParamInput,50,ORDERS), _
		Db.makeParam("@STATUS",adChar,adParamInput,3,"445"), _

		Db.makeParam("@ALL_COUNT",adInteger,adParamOutput,0,0) _

	)
	arrList = Db.execRsList("DKPA_MEMBER_LIST",DB_PROC,arrParams,listLen,Nothing)

	All_Count = arrParams(UBound(arrParams))(4)

' ===================================================================
		Dim PAGECOUNT,CNT
		PAGECOUNT = Int((CCur(All_Count) - 1 ) / CInt(PAGESIZE) ) + 1
		IF CCur(PAGE) = 1 Then
			CNT = All_Count
		Else
			CNT = All_Count - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
		End If


%>
<link rel="stylesheet" href="/admin/css/member.css" />
<script type="text/javascript" src="/admin/jscript/member.js"></script>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div class="member_list">
	<form name="sfrm" action="member_list.asp" method="post">
		<p class="titles">검색<p>
		<table <%=tableatt%> class="adminFullTable search">
			<colgroup>
				<col width="220" />
				<col width="*" />
			</colgroup>
			<tr>
				<th>회원그룹 선택</th>
				<td>
					<label><input type="radio" name="memberType" value="" class="input_chk" <%=isChecked(memberType,"")%> />전체</label>
					<label><input type="radio" name="memberType" value="M" class="input_chk input_chk_s" <%=isChecked(memberType,"M")%> />회원그룹</label>
					<label><input type="radio" name="memberType" value="M" class="input_chk input_chk_s" <%=isChecked(memberType,"S")%> />지점관리자그룹</label>
					<label><input type="radio" name="memberType" value="M" class="input_chk input_chk_s" <%=isChecked(memberType,"O")%> />오퍼레이터그룹</label>
					<label><input type="radio" name="memberType" value="A" class="input_chk input_chk_s" <%=isChecked(memberType,"A")%> />관리자그룹</label>
				</td>
			</tr><tr>
				<th>조건검색</th>
				<td>
					<select name="SEARCHTERM">
						<option value="" <%=isSelect(SEARCHTERM,"")%>>==조건을 선택해주세요==</option>
						<option value="strUserID" <%=isSelect(SEARCHTERM,"strUserID")%>>신청자 아이디로 검색</option>
						<option value="motherSite" <%=isSelect(SEARCHTERM,"motherSite")%>>가입도메인으로 검색</option>
						<option value="strName" <%=isSelect(SEARCHTERM,"strName")%>>이름으로 검색</option>
					</select>
					<input type="text" name="SEARCHSTR" class="input_text" style="width:200px;" value="<%=SEARCHSTR%>" />
					<input type="image" src="<%=IMG_BTN%>/btn_search.gif" class="vtop" />
					<%=aImg(Request.ServerVariables("SCRIPT_NAME"),IMG_BTN&"/search_reset.gif",80,23,"")%>
				</td>
			</tr>
		</table>
	</form>


	<p class="titles">신청 목록 리스트<p>
	<table <%=tableatt%> class="adminFullTable">
		<colgroup>
			<col width="40" />
			<col width="80" />
			<col width="90" />
			<col width="90" />
			<col width="30" />
			<col width="50" />
			<col width="50" />
			<col width="50" />
			<col width="50" />
			<col width="90" />
			<col width="60" />
			<col width="90" />
			<col width="85" />
			<col width="*" />
		</colgroup>
		<thead>
			<tr>
				<th>Num</th>
				<th>등록일</th>
				<th>ID</th>
				<th>성명</th>
				<th>성별</th>
				<th>메일</th>
				<th>메모</th>
				<th>주소</th>
				<th>전화</th>
				<th>회원그룹</th>
				<th>비고</th>
			</tr>
		</tr>
	<%
		If IsArray(arrList) Then
			For i = 0 To listLen

				Select Case arrList(5,i)
					Case "M" : listNum4 = viewImg(IMG_ICON&"/icon_male.gif",16,16,"")
					Case "F" : listNum4 = viewImg(IMG_ICON&"/icon_female.gif",16,16,"")
				End Select
	'			Select Case arrList(
	'			arrList(5,i)
				arrParams = Array(_
					Db.makeParam("@strUserID",adVarChar,adParamInput,30,arrList(3,i)) _
				)
				MemoCnt = ""
				MemoCnt = CInt(Db.execRsData("DKPA_MEMBER_MEMO_TF",DB_PROC,arrParams,Nothing))
				If MemoCnt > 0 Then
					memo_iconTF = "T"
					MemoiconALT = "메모가 "&MemoCnt&"건 있습니다."
				Else
					memo_iconTF = "F"
					MemoiconALT = "메모가 없습니다."
				End If

				If DKCONF_SITE_ENC = "T" Then
					'==============================================================================================================
						Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
							objEncrypter.Key = con_EncryptKey
							objEncrypter.InitialVector = con_EncryptKeyIV
							On Error Resume Next
								If arrList(8,i)		<> "" Then arrList(8,i)			= objEncrypter.Decrypt(arrList(8,i))
								If arrList(9,i)		<> "" Then arrList(9,i)			= objEncrypter.Decrypt(arrList(9,i))
								If arrList(10,i)	<> "" Then arrList(10,i)		= objEncrypter.Decrypt(arrList(10,i))
								If arrList(11,i)	<> "" Then arrList(11,i)		= objEncrypter.Decrypt(arrList(11,i))
							On Error GoTo 0
						Set objEncrypter = Nothing
					'==============================================================================================================
				End If


				AllZip = "["&arrList(7,i)&"] " & arrList(8,i) & " " &arrList(9,i)
				ThisNum = ALL_COUNT - CInt(arrList(0,i)) + 1
				PRINT "<tr>" & VbCrlf
				PRINT "	<td class=""tcenter"">" & ThisNum &"</td>" &VbCrlf
				PRINT "	<td class=""tcenter"">" & Left(arrList(2,i),10) &"</td>" &VbCrlf
				PRINT "	<td class=""tcenter"">" & arrList(3,i) &"</td>" &VbCrlf
				PRINT "	<td class=""tcenter"">" & arrList(4,i) &"</td>" &VbCrlf
				PRINT "	<td class=""tcenter"">" & listNum4 &"</td>" &VbCrlf
				PRINT "	<td class=""tcenter"">" & viewImgStJS(IMG_ICON&"/icon_email.gif",16,16,"","","cp","onclick=""copyTxt('"&arrList(6,i)&"','Email')""") & viewImgSt(IMG_ICON&"/icon_email_write.gif",16,16,"","margin-left:2px;","") &"</td>" &VbCrlf
				PRINT "	<td class=""tcenter"">" & aImg("javascript:openMemo('"&arrList(3,i)&"');",IMG_ICON&"/icon_memo.gif",16,16,"") & viewImg(IMG_ICON&"/icon_memo"&memo_iconTF&".gif",16,16,MemoiconALT) &"</td>" &VbCrlf
				PRINT "	<td class=""tcenter"">" & viewImgStJS(IMG_ICON&"/icon_homeT.gif",16,16,"","","cp","onclick=""copyTxt('"&AllZip&"','주소')""") &"</td>" &VbCrlf
				PRINT "	<td class=""tcenter"">" & viewImgStJS(IMG_ICON&"/icon_TelT.gif",16,16,"","","cp","onclick=""copyTxt('"&arrList(10,i)&"','전화번호')""") &" " & viewImgStJS(IMG_ICON&"/icon_mobileT.gif",16,16,"","","cp","onclick=""copyTxt('"&arrList(11,i)&"','핸드폰번호')""") &"</td>" &VbCrlf
				PRINT "	<td class=""tcenter"">" & arrList(12,i) &"</td>" &VbCrlf
				PRINT "	<td class=""tcenter"">"&aImg("javascript:goMemberInfo('"&arrList(3,i)&"')",IMG_BTN&"/btn_gray_update.gif",45,22,"")&"</td>" &VbCrlf
				PRINT "</tr>" & VbCrlf
			Next
		Else
			PRINT "<tr>"
			PRINT "	<td colspan=""11"" class=""notData"">등록된 회원이 없습니다</td>"
			PRINT "</tr>"
		End If
	%>
	</table>
	<div class="paging_area">
		<%Call pageList(PAGE,PAGECOUNT)%>
		<form name="frm" method="post" action="">
			<input type="hidden" name="PAGE" value="<%=PAGE%>" />
			<input type="hidden" name="SEARCHTERM" value="<%=SEARCHTERM%>" />
			<input type="hidden" name="SEARCHSTR" value="<%=convSql(SEARCHSTR)%>" />
			<input type="hidden" name="memberType" value="<%=memberType%>" />
			<input type="hidden" name="mid" value="" />
		</form>
	</div>
</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
