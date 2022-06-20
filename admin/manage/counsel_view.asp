<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "MANAGE"
	'INFO_MODE = "MANAGE3-1"

	strNationCode = Request("nc")

	arrParams_FA = Array(Db.makeParam("@strNationCode",adVarChar,adParamInput,6,strNationCode))
	Set DKRS_FA = Db.execRs("DKSP_SITE_NATION_VIEW",DB_PROC,arrParams_FA,Nothing)
	If Not DKRS_FA.BOF And Not DKRS_FA.EOF Then
		DKRS_FA_strNationName	= DKRS_FA("strNationName")
		DKRS_FA_intSort			= DKRS_FA("intSort")
	Else
		Call ALERTS("설정되지 않은 국가입니다!","BACK","")
	End If

	INFO_MODE = "MANAGE3-1-"&DKRS_FA_intSort&""
	INFO_TEXT = DKRS_FA_strNationName

	Dim SEARCHTERM, SEARCHSTR, PAGE, PAGESIZE
		replyTF			= pRequestTF("replyTF",False)
		SEARCHTERM		= pRequestTF("SEARCHTERM",False)
		SEARCHSTR		= pRequestTF("SEARCHSTR",False)
		PAGE			= pRequestTF("page",False)
		intIDX			=  pRequestTF("intIDX",True)


	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX) _
	)
	Set DKRS = Db.execRs("DKPA_COUNSEL_VIEW",DB_PROC,arrParams,Nothing)

	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_intIDX    		= DKRS("intIDX")
		DKRS_strName   		= DKRS("strName")
		DKRS_strEmail  		= DKRS("strEmail")
		DKRS_strSubject		= DKRS("strSubject")
		DKRS_strMobile 		= DKRS("strMobile")
		DKRS_strContent		= DKRS("strContent")
		DKRS_regDate   		= DKRS("regDate")
		DKRS_strHostIP 		= DKRS("strHostIP")
		DKRS_isReply   		= DKRS("isReply")
		DKRS_adminComment   = DKRS("adminComment")

		Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV
			On Error Resume Next
			If DKRS_strEmail	<> "" Then DKRS_strEmail	= objEncrypter.Decrypt(DKRS_strEmail)
			If DKRS_strMobile	<> "" Then DKRS_strMobile	= objEncrypter.Decrypt(DKRS_strMobile)
			On Error GoTo 0
		Set objEncrypter = Nothing

	Else
		Call ALERTS("잘못된 데이터입니다.","BACK","")
	End If
%>
<link rel="stylesheet" href="/admin/css/manage.css" />
<script type="text/javascript" src="counsel.js"></script>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="collaboration">
	<p class="titles">내용보기</p>
	<form name="insFrm" action="" method="post">
		<input type="hidden" name="MODE" value="" />
		<input type="hidden" name="PAGE" value="<%=PAGE%>" />
		<input type="hidden" name="SEARCHTERM" value="<%=SEARCHTERM%>" />
		<input type="hidden" name="SEARCHSTR" value="<%=SEARCHSTR%>" />
		<input type="hidden" name="replyTF" value="<%=replyTF%>" />
		<input type="hidden" name="intIDX" value="<%=DKRS_intIDX%>" />
		<table <%=tableatt%> class="adminFullTable view">
			<colgroup>
				<col width="15%" />
				<col width="35%" />
				<col width="15%" />
				<col width="35%" />
			</colgroup>
			<tr>
				<th>회사명</th>
				<td><%=DKRS_strName%></td>
				<th>작성일</th>
				<td><%=DKRS_regDate%></td>
			</tr><tr>
				<th>휴대전화</th>
				<td><%=DKRS_strMobile%></td>
				<th>이메일</th>
				<td><%=DKRS_strEmail%></td>
			</tr><tr>
				<th>아이피</th>
				<td><%=DKRS_strHostIP%></td>
				<th>상태</th>
				<td>
					<select name="isReply">
						<option value="T" <%=isSelect(DKRS_isReply,"T")%>>답변된 문의</option>
						<option value="F" <%=isSelect(DKRS_isReply,"F")%>>미답변 문의</option>
					</select>
				</td>
			</tr><tr>
				<th>제목</th>
				<td colspan="3"><%=DKRS_strSubject%></td>
			</tr><tr>
				<th>내용</th>
				<td colspan="3"><%=DKRS_strContent%></td>
			</tr><tr>
				<th>관리자코멘트</th>
				<td colspan="3"><textarea name="adminComment" cols="10" rows="10" class="input_area" style="width:700px; height:150px;"><%=backword(DKRS_adminComment)%></textarea></td>
			</tr>
		</table>
	</form>
</div>
<div class="btn_area"><%=aImgOpt("javascript:submitThisView('"&strNationCode&"');","S",IMG_BTN&"/btn_rect_confirm.gif",99,45,"","")%><%=aImgOpt("javascript:returnList('"&strNationCode&"');","S",IMG_BTN&"/btn_rect_list.gif",99,45,"","style=""margin-left:7px;""")%><%=aImgOpt("javascript:delThisView('"&strNationCode&"');","S",IMG_BTN&"/btn_rect_del.gif",99,45,"","style=""margin-left:7px;""")%></div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
