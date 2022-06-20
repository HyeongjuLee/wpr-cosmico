<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "MANAGE"
	INFO_MODE = "MANAGE3-3"

	Dim SEARCHTERM, SEARCHSTR, PAGE, PAGESIZE
		replyTF = pRequestTF("replyTF",False)
		SEARCHTERM = pRequestTF("SEARCHTERM",False)
		SEARCHSTR = pRequestTF("SEARCHSTR",False)
		PAGE = pRequestTF("page",False)
		PAGESIZE = 20



	If SEARCHTERM = "" Then SEARCHTERM = "" End If
	If SEARCHSTR = "" Then SEARCHSTR = "" End if
	If PAGE="" Then PAGE = 1 End If
	If replyTF = "" Then replyTF = ""

	arrParams = Array(_
		Db.makeParam("@replyTF",adChar,adParamInput,1,replyTF),_
		Db.makeParam("@SEARCHTERM",adVarChar,adParamInput,30,SEARCHTERM),_
		Db.makeParam("@SEARCHSTR",adVarChar,adParamInput,30,convSql(SEARCHSTR)),_
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE),_
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE),_
		Db.makeParam("@ALL_COUNT",adInteger,adParamOutput,0,0) _
	)
	arrList = Db.execRsList("DKPA_COUNSEL2_LIST",DB_PROC,arrParams,listLen,Nothing)
	All_Count = arrParams(UBound(arrParams))(4)

	Dim PAGECOUNT,CNT
	PAGECOUNT = Int((CCur(All_Count) - 1 ) / CInt(PAGESIZE) ) + 1
	IF CCur(PAGE) = 1 Then
		CNT = All_Count
	Else
		CNT = All_Count - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
	End If

%>
<link rel="stylesheet" href="/admin/css/manage.css" />
<script type="text/javascript" src="counsel2.js"></script>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="manage" class="fleft adminFullWidth">
	<p class="titles">검색</p>
	<form name="sfrm" action="counsel2_list.asp" method="post">
		<table <%=tableatt%> class="adminFullTable search table_fixed">
			<colgroup>
				<col width="220" />
				<col width="*" />
			</colgroup>
			<tr>
				<th>상태값</th>
				<td>
					<input type="radio" name="replyTF" id="replyTF1" class="input_radio" <%=isChecked(replyTF,"")%> value="" /><label for="replyTF1">전체보기</label>
					<input type="radio" name="replyTF" id="replyTF2" class="input_radio" <%=isChecked(replyTF,"T")%> value="T" /><label for="replyTF2">답변한 상담만 보기</label>
					<input type="radio" name="replyTF" id="replyTF3" class="input_radio" <%=isChecked(replyTF,"F")%> value="F" /><label for="replyTF3">미답변한 상담만 보기</label>
				</td>
			</tr><tr>
				<th>조건검색</th>
				<td>
					<select name="SEARCHTERM" class="selectbox">
						<option value="" <%=isSelect(SEARCHTERM,"")%>>==조건을 선택해주세요==</option>
						<option value="strContact" <%=isSelect(SEARCHTERM,"strName")%>>상담자명으로 검색</option>
						<option value="strSubject" <%=isSelect(SEARCHTERM,"strSubject")%>>제목으로 검색</option>
						<option value="strContent" <%=isSelect(SEARCHTERM,"strContent")%>>내용으로 검색</option>
						<option value="strMobile" <%=isSelect(SEARCHTERM,"strMobile")%>>연락처로 검색</option>
						<option value="strEmail" <%=isSelect(SEARCHTERM,"strEmail")%>>이메일주소로 검색</option>
					</select>
					<input type="text" name="SEARCHSTR" class="input_text" style="width:200px;" value="<%=SEARCHSTR%>" />
					<input type="image" src="<%=IMG_BTN%>/btn_search.gif" class="vtop" />
					<%=aImg(Request.ServerVariables("SCRIPT_NAME"),IMG_BTN&"/search_reset.gif",80,23,"")%>
				</td>
			</tr>
		</table>
	</form>
	<p class="titles">리스트</p>
	<div id="counsel">
		<table <%=tableatt%> class="adminFullTable list">
			<colgroup>
				<col width="6%" />
				<col width="16%" />
				<col width="19%" />
				<col width="27%" />
				<col width="8%" />
				<col width="15%" />
				<col width="*" />
			</colgroup>
			<thead>
				<tr>
					<th>번호</th>
					<th>상담자명</th>
					<th>휴대전화 / 이메일</th>
					<th>제목</th>
					<th>상태</th>
					<th>작성일/아이피</th>
					<th>기능</th>
				</tr>
			</thead>
			<tbody>
			<%
				If IsArray(arrList) Then
					For i = 0 To listLen
						ThisNum = ALL_COUNT - CInt(arrList(0,i)) + 1

						Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
							objEncrypter.Key = con_EncryptKey
							objEncrypter.InitialVector = con_EncryptKeyIV
							On Error Resume Next
							If arrList(3,i)		<> "" Then arrList(3,i)	= objEncrypter.Decrypt(arrList(3,i))
							If arrList(5,i)		<> "" Then arrList(5,i)	= objEncrypter.Decrypt(arrList(5,i))
							On Error GoTo 0
						Set objEncrypter = Nothing
			%>
				<tr>
					<td><%=ThisNum%></td>
					<td class="tweight"><%=arrList(2,i)%></td>
					<td class="contents"><%=arrList(3,i)%><br /><%=arrList(5,i)%></td>
					<td class="contents"><%=backword(arrList(4,i))%></td>
					<td><%=TFVIEWER(arrList(9,i),"REPLY")%></td>
					<td class="lheight"><%=arrList(7,i)%><br />IP :&lt; <%=arrList(8,i)%> &gt;</td>
					<td><%=aImgOpt("javascript:counselView('"&arrList(1,i)&"');","S",IMG_BTN&"/btn_gray_detailView.gif",70,22,"","")%></td>
				</tr>
			<%
					Next
				Else
			%>
				<tr>
					<td colspan="7" class="notData">등록된 상담이 없습니다.</td>
				</tr>
			<%
				End If
			%>
			</tbody>

		</table>
	</div>
	<div class="paging_area"><%Call pageList(PAGE,PAGECOUNT)%></div>
	<form name="frm" method="post" action="">
		<input type="hidden" name="replyTF" value="<%=replyTF%>" />
		<input type="hidden" name="SEARCHTERM" value="<%=SEARCHTERM%>" />
		<input type="hidden" name="SEARCHSTR" value="<%=convSql(SEARCHSTR)%>" />
		<input type="hidden" name="PAGESIZE" value="<%=PAGESIZE%>" />
		<input type="hidden" name="PAGE" value="<%=PAGE%>" />
		<input type="hidden" name="intIDX" value="" />
	</form>
</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
