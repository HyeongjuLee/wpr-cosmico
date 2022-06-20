<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "WEBPRO"
	INFO_MODE = "WEBPRO1-1"
	W1200 = "T"

	view = 4

	strBoardName = gRequestTF("bname",True)

	arrParams = Array(_
		Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName) _
	)

	Set DKRS = Db.execRs("DKPA_FORUM_CONFIG_READ",DB_PROC,arrParams,Nothing)

	If Not DKRS.BOF And Not DKRS.EOF Then
		intEmailLevel		= DKRS("intEmailLevel")
		intMobileLevel		= DKRS("intMobileLevel")
		intTelLevel			= DKRS("intTelLevel")
		intData1Level		= DKRS("intData1Level")
		intData2Level		= DKRS("intData2Level")
		intData3Level		= DKRS("intData3Level")
		intLinkLevel		= DKRS("intLinkLevel")

		isEmail				= DKRS("isEmail")
		isMobile			= DKRS("isMobile")
		isTel				= DKRS("isTel")
		isData1				= DKRS("isData1")
		isData2				= DKRS("isData2")
		isData3				= DKRS("isData3")
		isLink				= DKRS("isLink")
	Else
		Call ALERTS("설정값 로딩중 문제가 발생하였습니다. 새로고침 후 다시 시도해주세요.","back","")

	End If
	Call closeRS(DKRS)
	strBoardTitle = Db.execRsData("DKPA_FORUM_TITLE_SELECT",DB_PROC,arrParams,Nothing)


	EmailSelectB = "이메일 항목의 공개 레벨 설정입니다."
	MobileSelectB = "휴대폰 항목의 공개 레벨 설정입니다."
	TelSelectB = "전화번호 항목의 공개 레벨 설정입니다."
	Data1SelectB = "첨부파일1 항목의 공개 레벨 설정입니다."
	Data2SelectB = "첨부파일1 항목의 공개 레벨 설정입니다."
	Data3SelectB = "첨부파일1 항목의 공개 레벨 설정입니다."
	LinkSelectB = "링크 항목의 공개 레벨 설정입니다."



	If isEmail = "F" Then
		EmailSelectA = "disabled=""disabled"""
		EmailSelectB = "이메일 항목이 미사용상태입니다."
	End If
	If isMobile = "F" Then
		MobileSelectA = "disabled=""disabled"""
		MobileSelectB = "휴대폰 항목이 미사용상태입니다."
	End If
	If isTel = "F" Then
		TelSelectA = "disabled=""disabled"""
		TelSelectB = "전화번호 항목이 미사용상태입니다."
	End If
	If isData1 = "F" Then
		Data1SelectA = "disabled=""disabled"""
		Data1SelectB = "첨부파일1 항목이 미사용상태입니다."
	End If
	If isData2 = "F" Then
		Data2SelectA = "disabled=""disabled"""
		Data2SelectB = "첨부파일2 항목이 미사용상태입니다."
	End If
	If isData3 = "F" Then
		Data3SelectA = "disabled=""disabled"""
		Data3SelectB = "첨부파일3 항목이 미사용상태입니다."
	End If
	If isLink = "F" Then
		LinkSelectA = "disabled=""disabled"""
		LinkSelectB = "링크 항목이 미사용상태입니다."
	End If



%>

<script type="text/javascript" src="forum.js"></script>
<link rel="stylesheet" href="forum.css" />

</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->

<div class="insert">
<!--#include file = "forum_tabs.asp"-->

<form name="cfrm" action="forumHandler.asp" enctype="multipart/form-data" method="post">
<input type="hidden" name="mode" value="READ" />
<input type="hidden" name="strBoardName" value="<%=strBoardName%>" />

<table <%=tableatt%> class="width100">
	<colgroup>
		<col width="200" />
		<col width="300" />
		<col width="*" />
	</colgroup>
	<tr>
		<th>게시판아이디</th>
		<td colspan="2"><%=strBoardName%></td>
	</tr><tr>
		<th>게시판 이름</th>
		<td colspan="2"><%=strBoardTitle%></td>
	</tr><tr>
		<th colspan="3" style="padding:5px 0px;">항목이 활성화 되지 않은 메뉴는 기본값인 10레벨로 설정됩니다. <br />단 쓰기 설정에서 미사용으로 된 경우에는 게시판에서 출력되지 않습니다.</th>
	</tr><tr>
		<th>이메일 공개</th>
		<td>
			<select name="intEmailLevel" class="select" <%=EmailSelectA%>>
				<option value="0"	<%=isSelect("0",intEmailLevel)%> >전체공개</option>
				<option value="1"	<%=isSelect("1",intEmailLevel)%> >1레벨 이상 회원에게 공개</option>
				<option value="2"	<%=isSelect("2",intEmailLevel)%> >2레벨 이상 회원에게 공개</option>
				<option value="3"	<%=isSelect("3",intEmailLevel)%> >3레벨 이상 회원에게 공개</option>
				<option value="4"	<%=isSelect("4",intEmailLevel)%> >4레벨 이상 회원에게 공개</option>
				<option value="5"	<%=isSelect("5",intEmailLevel)%> >5레벨 이상 회원에게 공개</option>
				<option value="6"	<%=isSelect("6",intEmailLevel)%> >6레벨 이상 회원에게 공개</option>
				<option value="7"	<%=isSelect("7",intEmailLevel)%> >7레벨 이상 회원에게 공개</option>
				<option value="8"	<%=isSelect("8",intEmailLevel)%> >8레벨 이상 회원에게 공개</option>
				<option value="9"	<%=isSelect("9",intEmailLevel)%> >9레벨 이상 회원에게 공개</option>
				<option value="10"	<%=isSelect("10",intEmailLevel)%>>10레벨 이상 회원에게 공개</option>
			</select>
		</td>
		<td class="borLeft"><%=EmailSelectB%></td>
	</tr><tr>
		<th>휴대폰 공개</th>
		<td>
			<select name="intMobileLevel" class="select" <%=MobileSelectA%>>
				<option value="0"	<%=isSelect("0",intMobileLevel)%> >전체공개</option>
				<option value="1"	<%=isSelect("1",intMobileLevel)%> >1레벨 이상 회원에게 공개</option>
				<option value="2"	<%=isSelect("2",intMobileLevel)%> >2레벨 이상 회원에게 공개</option>
				<option value="3"	<%=isSelect("3",intMobileLevel)%> >3레벨 이상 회원에게 공개</option>
				<option value="4"	<%=isSelect("4",intMobileLevel)%> >4레벨 이상 회원에게 공개</option>
				<option value="5"	<%=isSelect("5",intMobileLevel)%> >5레벨 이상 회원에게 공개</option>
				<option value="6"	<%=isSelect("6",intMobileLevel)%> >6레벨 이상 회원에게 공개</option>
				<option value="7"	<%=isSelect("7",intMobileLevel)%> >7레벨 이상 회원에게 공개</option>
				<option value="8"	<%=isSelect("8",intMobileLevel)%> >8레벨 이상 회원에게 공개</option>
				<option value="9"	<%=isSelect("9",intMobileLevel)%> >9레벨 이상 회원에게 공개</option>
				<option value="10"	<%=isSelect("10",intMobileLevel)%>>10레벨 이상 회원에게 공개</option>
			</select>
		</td>
		<td class="borLeft"><%=MobileSelectB%></td>
	</tr><tr>
		<th>전화번호 공개</th>
		<td>
			<select name="intTelLevel" class="select" <%=TelSelectA%>>
				<option value="0"	<%=isSelect("0",intTelLevel)%> >전체공개</option>
				<option value="1"	<%=isSelect("1",intTelLevel)%> >1레벨 이상 회원에게 공개</option>
				<option value="2"	<%=isSelect("2",intTelLevel)%> >2레벨 이상 회원에게 공개</option>
				<option value="3"	<%=isSelect("3",intTelLevel)%> >3레벨 이상 회원에게 공개</option>
				<option value="4"	<%=isSelect("4",intTelLevel)%> >4레벨 이상 회원에게 공개</option>
				<option value="5"	<%=isSelect("5",intTelLevel)%> >5레벨 이상 회원에게 공개</option>
				<option value="6"	<%=isSelect("6",intTelLevel)%> >6레벨 이상 회원에게 공개</option>
				<option value="7"	<%=isSelect("7",intTelLevel)%> >7레벨 이상 회원에게 공개</option>
				<option value="8"	<%=isSelect("8",intTelLevel)%> >8레벨 이상 회원에게 공개</option>
				<option value="9"	<%=isSelect("9",intTelLevel)%> >9레벨 이상 회원에게 공개</option>
				<option value="10"	<%=isSelect("10",intTelLevel)%>>10레벨 이상 회원에게 공개</option>
			</select>
		</td>
		<td class="borLeft"><%=TelSelectB%></td>
	</tr><tr>
		<th>첨부파일1 다운로드</th>
		<td>
			<select name="intData1Level" class="select" <%=Data1SelectA%>>
				<option value="0"	<%=isSelect("0",intData1Level)%> >전체공개</option>
				<option value="1"	<%=isSelect("1",intData1Level)%> >1레벨 이상 회원에게 공개</option>
				<option value="2"	<%=isSelect("2",intData1Level)%> >2레벨 이상 회원에게 공개</option>
				<option value="3"	<%=isSelect("3",intData1Level)%> >3레벨 이상 회원에게 공개</option>
				<option value="4"	<%=isSelect("4",intData1Level)%> >4레벨 이상 회원에게 공개</option>
				<option value="5"	<%=isSelect("5",intData1Level)%> >5레벨 이상 회원에게 공개</option>
				<option value="6"	<%=isSelect("6",intData1Level)%> >6레벨 이상 회원에게 공개</option>
				<option value="7"	<%=isSelect("7",intData1Level)%> >7레벨 이상 회원에게 공개</option>
				<option value="8"	<%=isSelect("8",intData1Level)%> >8레벨 이상 회원에게 공개</option>
				<option value="9"	<%=isSelect("9",intData1Level)%> >9레벨 이상 회원에게 공개</option>
				<option value="10"	<%=isSelect("10",intData1Level)%>>10레벨 이상 회원에게 공개</option>
			</select>
		</td>
		<td class="borLeft"><%=Data1SelectB%></td>
	</tr><tr>
		<th>첨부파일2 다운로드</th>
		<td>
			<select name="intData2Level" class="select" <%=Data2SelectA%>>
				<option value="0"	<%=isSelect("0",intData2Level)%> >전체공개</option>
				<option value="1"	<%=isSelect("1",intData2Level)%> >1레벨 이상 회원에게 공개</option>
				<option value="2"	<%=isSelect("2",intData2Level)%> >2레벨 이상 회원에게 공개</option>
				<option value="3"	<%=isSelect("3",intData2Level)%> >3레벨 이상 회원에게 공개</option>
				<option value="4"	<%=isSelect("4",intData2Level)%> >4레벨 이상 회원에게 공개</option>
				<option value="5"	<%=isSelect("5",intData2Level)%> >5레벨 이상 회원에게 공개</option>
				<option value="6"	<%=isSelect("6",intData2Level)%> >6레벨 이상 회원에게 공개</option>
				<option value="7"	<%=isSelect("7",intData2Level)%> >7레벨 이상 회원에게 공개</option>
				<option value="8"	<%=isSelect("8",intData2Level)%> >8레벨 이상 회원에게 공개</option>
				<option value="9"	<%=isSelect("9",intData2Level)%> >9레벨 이상 회원에게 공개</option>
				<option value="10"	<%=isSelect("10",intData2Level)%>>10레벨 이상 회원에게 공개</option>
			</select>
		</td>
		<td class="borLeft"><%=Data2SelectB%></td>
	</tr><tr>
		<th>첨부파일3 다운로드</th>
		<td>
			<select name="intData3Level" class="select" <%=Data3SelectA%>>
				<option value="0"	<%=isSelect("0",intData3Level)%> >전체공개</option>
				<option value="1"	<%=isSelect("1",intData3Level)%> >1레벨 이상 회원에게 공개</option>
				<option value="2"	<%=isSelect("2",intData3Level)%> >2레벨 이상 회원에게 공개</option>
				<option value="3"	<%=isSelect("3",intData3Level)%> >3레벨 이상 회원에게 공개</option>
				<option value="4"	<%=isSelect("4",intData3Level)%> >4레벨 이상 회원에게 공개</option>
				<option value="5"	<%=isSelect("5",intData3Level)%> >5레벨 이상 회원에게 공개</option>
				<option value="6"	<%=isSelect("6",intData3Level)%> >6레벨 이상 회원에게 공개</option>
				<option value="7"	<%=isSelect("7",intData3Level)%> >7레벨 이상 회원에게 공개</option>
				<option value="8"	<%=isSelect("8",intData3Level)%> >8레벨 이상 회원에게 공개</option>
				<option value="9"	<%=isSelect("9",intData3Level)%> >9레벨 이상 회원에게 공개</option>
				<option value="10"	<%=isSelect("10",intData3Level)%>>10레벨 이상 회원에게 공개</option>
			</select>
		</td>
		<td class="borLeft"><%=Data3SelectB%></td>
	</tr><tr>
		<th>링크주소 공개</th>
		<td>
			<select name="intLinkLevel" class="select" <%=LinkSelectA%>>
				<option value="0"	<%=isSelect("0",intLinkLevel)%> >전체공개</option>
				<option value="1"	<%=isSelect("1",intLinkLevel)%> >1레벨 이상 회원에게 공개</option>
				<option value="2"	<%=isSelect("2",intLinkLevel)%> >2레벨 이상 회원에게 공개</option>
				<option value="3"	<%=isSelect("3",intLinkLevel)%> >3레벨 이상 회원에게 공개</option>
				<option value="4"	<%=isSelect("4",intLinkLevel)%> >4레벨 이상 회원에게 공개</option>
				<option value="5"	<%=isSelect("5",intLinkLevel)%> >5레벨 이상 회원에게 공개</option>
				<option value="6"	<%=isSelect("6",intLinkLevel)%> >6레벨 이상 회원에게 공개</option>
				<option value="7"	<%=isSelect("7",intLinkLevel)%> >7레벨 이상 회원에게 공개</option>
				<option value="8"	<%=isSelect("8",intLinkLevel)%> >8레벨 이상 회원에게 공개</option>
				<option value="9"	<%=isSelect("9",intLinkLevel)%> >9레벨 이상 회원에게 공개</option>
				<option value="10"	<%=isSelect("10",intLinkLevel)%>>10레벨 이상 회원에게 공개</option>
			</select>
		</td>
		<td class="borLeft"><%=LinkSelectB%></td>
	</tr>
</table>
</form>
	<div class="btn_area"><%=viewImgStJS(IMG_BTN&"/btn_rect_confirm.gif",99,45,"","margin-top:20px;","cp","onclick=""submitChkLevel();""")%></div>
</div>

<!--#include virtual = "/admin/_inc/copyright.asp"-->
