<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "MEMBER"
	INFO_MODE = "MEMBER1-1"
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
		PAGESIZE = 20

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

		Db.makeParam("@ALL_COUNT",adInteger,adParamOutput,0,0) _

	)
	arrList = Db.execRsList("DKP_ADMIN_MEMBER_LIST_443",DB_PROC,arrParams,listLen,Nothing)

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
				<th>가입사이트</th>
				<th>ID</th>
				<th>성명</th>
				<th>성별</th>
				<th>메일</th>
				<th>메모</th>
				<th>주소</th>
				<th>전화</th>
				<th>적립금</th>
				<th>구매횟수</th>
				<th>구매금액</th>
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
				MemoCnt = CInt(Db.execRsData("DKP_ADMIN_MEMBER_MEMO_TF",DB_PROC,arrParams,Nothing))
				If MemoCnt > 0 Then
					memo_iconTF = "T"
					MemoiconALT = "메모가 "&MemoCnt&"건 있습니다."
				Else
					memo_iconTF = "F"
					MemoiconALT = "메모가 없습니다."
				End If

				AllZip = "["&arrList(7,i)&"] " & arrList(8,i) & " " &arrList(9,i)
				ThisNum = ALL_COUNT - CInt(arrList(0,i)) + 1
				PRINT "<tr>" & VbCrlf
				PRINT "	<td class=""tcenter"">" & ThisNum &"</td>" &VbCrlf
				PRINT "	<td class=""tcenter"">" & Left(arrList(2,i),10) &"</td>" &VbCrlf
				PRINT "	<td class=""tcenter"">" & arrList(16,i) &"</td>" &VbCrlf
				PRINT "	<td class=""tcenter"">" & arrList(3,i) &"</td>" &VbCrlf
				PRINT "	<td class=""tcenter"">" & arrList(4,i) &"</td>" &VbCrlf
				PRINT "	<td class=""tcenter"">" & listNum4 &"</td>" &VbCrlf
				PRINT "	<td class=""tcenter"">" & viewImgStJS(IMG_ICON&"/icon_email.gif",16,16,"","","cp","onclick=""copyTxt('"&arrList(6,i)&"','Email')""") & viewImgSt(IMG_ICON&"/icon_email_write.gif",16,16,"","margin-left:2px;","") &"</td>" &VbCrlf
				PRINT "	<td class=""tcenter"">" & aImg("javascript:openMemo('"&arrList(3,i)&"');",IMG_ICON&"/icon_memo.gif",16,16,"") & viewImg(IMG_ICON&"/icon_memo"&memo_iconTF&".gif",16,16,MemoiconALT) &"</td>" &VbCrlf
				PRINT "	<td class=""tcenter"">" & viewImgStJS(IMG_ICON&"/icon_homeT.gif",16,16,"","","cp","onclick=""copyTxt('"&AllZip&"','주소')""") &"</td>" &VbCrlf
				PRINT "	<td class=""tcenter"">" & viewImgStJS(IMG_ICON&"/icon_TelT.gif",16,16,"","","cp","onclick=""copyTxt('"&arrList(10,i)&"','전화번호')""") &" " & viewImgStJS(IMG_ICON&"/icon_mobileT.gif",16,16,"","","cp","onclick=""copyTxt('"&arrList(10,i)&"','핸드폰번호')""") &"</td>" &VbCrlf
				PRINT "	<td class=""tright"">" & FormatNumber(arrList(14,i),0) & "원" & aImg("javascript:openPointCalc('"&arrList(3,i)&"');",IMG_ICON&"/icon_plusminus.gif",16,16,"") & aImg("javascript:openPointDetail('"&arrList(3,i)&"');",IMG_ICON&"/icon_detail.gif",16,16,"") &"</td>" &VbCrlf
				PRINT "	<td class=""tright"">" & arrList(12,i) &"회</td>" &VbCrlf
				PRINT "	<td class=""tright"">" & FormatNumber(arrList(13,i),0) &"원" & viewImg(IMG_ICON&"/icon_detail.gif",16,16,"") &"</td>" &VbCrlf
				PRINT "	<td class=""tcenter"">" & arrList(15,i) &"</td>" &VbCrlf
				PRINT "	<td class=""tcenter"">"&aImg("javascript:goMemberInfo1('"&arrList(3,i)&"')",IMG_BTN&"/btn_gray_update.gif",45,22,"")&"</td>" &VbCrlf
				PRINT "</tr>" & VbCrlf
			Next

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
