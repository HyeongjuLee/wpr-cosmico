<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "WEBPRO"
	INFO_MODE = "WEBPRO1-1"
	W1200 = "T"

	view = 3


	strBoardName = gRequestTF("bname",True)

	arrParams = Array(_
		Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName) _
	)

	Set DKRS = Db.execRs("DKPA_FORUM_CONFIG_WRITE",DB_PROC,arrParams,Nothing)

	If Not DKRS.BOF And Not DKRS.EOF Then
		isEditor			= DKRS("isEditor")
		intEditorLevel		= DKRS("intEditorLevel")
		isEmail				= DKRS("isEmail")
		isEmailTF			= DKRS("isEmailTF")
		isMobile			= DKRS("isMobile")
		isMobileTF			= DKRS("isMobileTF")
		isTel				= DKRS("isTel")
		isTelTF				= DKRS("isTelTF")
		isData1				= DKRS("isData1")
		isData1TF			= DKRS("isData1TF")
		intData1MB			= DKRS("intData1MB")
		isData2				= DKRS("isData2")
		isData2TF			= DKRS("isData2TF")
		intData2MB			= DKRS("intData2MB")
		isData3				= DKRS("isData3")
		isData3TF			= DKRS("isData3TF")
		intData3MB			= DKRS("intData3MB")
		isPic				= DKRS("isPic")
		isPicTF				= DKRS("isPicTF")
		intPicMB			= DKRS("intPicMB")
		isLink				= DKRS("isLink")
		isLinkTF			= DKRS("isLinkTF")
		'이미지1,2,3 추가
		isPic1    			= DKRS("isPic1")
		isPic1TF  			= DKRS("isPic1TF")
		intPic1MB 			= DKRS("intPic1MB")
		isPic2    			= DKRS("isPic2")
		isPic2TF  			= DKRS("isPic2TF")
		intPic2MB 			= DKRS("intPic2MB")
		isPic3    			= DKRS("isPic3")
		isPic3TF  			= DKRS("isPic3TF")
		intPic3MB 			= DKRS("intPic3MB")

		isMovie				= DKRS("isMovie")
		isMovieTF			= DKRS("isMovieTF")
		intContentMinLimit	= DKRS("intContentMinLimit")
		intReplyMinLimit	= DKRS("intReplyMinLimit")

	Else
		Call ALERTS("설정값 로딩중 문제가 발생하였습니다. 새로고침 후 다시 시도해주세요.","back","")

	End If
	Call closeRS(DKRS)
	strBoardTitle = Db.execRsData("DKPA_FORUM_TITLE_SELECT",DB_PROC,arrParams,Nothing)

%>

<script type="text/javascript" src="forum.js"></script>
<link rel="stylesheet" href="forum.css" />
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->

<div class="insert">
<!--#include file = "forum_tabs.asp"-->

<form name="cfrm" action="forumHandler.asp" enctype="multipart/form-data" method="post">
<input type="hidden" name="mode" value="WRITE" />
<input type="hidden" name="strBoardName" value="<%=strBoardName%>" />


<table <%=tableatt%> class="width100">
	<colgroup>
		<col width="200" />
		<col width="400" />
		<col width="*" />
	</colgroup>
	<tr>
		<th>게시판아이디</th>
		<td colspan="2"><%=strBoardName%></td>
	</tr><tr>
		<th>게시판 이름</th>
		<td colspan="2"><%=strBoardTitle%></td>
	</tr><tr>
		<th colspan="3">WYSIWYG 회원 레벨의 경우에는 그룹과 상관없이 레벨로만 확인합니다.</th>
	</tr><tr>
		<th>WYSIWYG(멀티게시판)</th>
		<td>
			<select name="isEditor" class="select">
				<option value="">사용여부</option>
				<option value="T" <%=isSelect("T",isEditor)%> class="tcblue">사용</option>
				<option value="F" <%=isSelect("F",isEditor)%> class="tcred" >미사용</option>
			</select>
			<select name="intEditorLevel" class="select">
				<option value="0" <%=isSelect("0",intEditorLevel)%>>쓰기 레벨에 맞는 회원전체</option>
				<option value="1" <%=isSelect("1",intEditorLevel)%>>1레벨 등급 이상 회원</option>
				<option value="2" <%=isSelect("2",intEditorLevel)%>>2레벨 등급 이상 회원</option>
				<option value="3" <%=isSelect("3",intEditorLevel)%>>3레벨 등급 이상 회원</option>
				<option value="4" <%=isSelect("4",intEditorLevel)%>>4레벨 등급 이상 회원</option>
				<option value="5" <%=isSelect("5",intEditorLevel)%>>5레벨 등급 이상 회원</option>
				<option value="6" <%=isSelect("6",intEditorLevel)%>>6레벨 등급 이상 회원</option>
				<option value="7" <%=isSelect("7",intEditorLevel)%>>7레벨 등급 이상 회원</option>
				<option value="8" <%=isSelect("8",intEditorLevel)%>>8레벨 등급 이상 회원</option>
				<option value="9" <%=isSelect("9",intEditorLevel)%>>9레벨 등급 이상 회원</option>
				<option value="10" <%=isSelect("10",intEditorLevel)%>>10레벨 등급 이상 회원</option>
			</select>
		</td>
		<td class="borLeft">위지웍(통칭 멀티게시판) 사용여부 및 사용레벨 설정</td>
	</tr><tr>
		<th>이메일</th>
		<td>
			<select name="isEmail" class="select">
				<option value="">사용여부</option>
				<option value="T" <%=isSelect("T",isEmail)%> class="tcblue">사용</option>
				<option value="F" <%=isSelect("F",isEmail)%> class="tcred" >미사용</option>
			</select>
			<select name="isEmailTF" class="select">
				<option value="">필수값여부</option>
				<option value="T" <%=isSelect("T",isEmailTF)%> class="tcred" >필수값</option>
				<option value="F" <%=isSelect("F",isEmailTF)%> class="tcblue">선택값</option>
			</select>
		</td>
		<td class="borLeft">이메일 항목의 사용 및 필수값 선택</td>
	</tr><tr>
		<th>휴대폰 번호</th>
		<td>
			<select name="isMobile" class="select">
				<option value="">사용여부</option>
				<option value="T" <%=isSelect("T",isMobile)%> class="tcblue">사용</option>
				<option value="F" <%=isSelect("F",isMobile)%> class="tcred" >미사용</option>
			</select>
			<select name="isMobileTF" class="select">
				<option value="">필수값여부</option>
				<option value="T" <%=isSelect("T",isMobileTF)%> class="tcred" >필수값</option>
				<option value="F" <%=isSelect("F",isMobileTF)%> class="tcblue">선택값</option>
			</select>
		</td>
		<td class="borLeft">휴대폰 번호 항목의 사용 및 필수값 선택</td>
	</tr><tr>
		<th>전화 번호</th>
		<td>
			<select name="isTel" class="select">
				<option value="">사용여부</option>
				<option value="T" <%=isSelect("T",isTel)%> class="tcblue">사용</option>
				<option value="F" <%=isSelect("F",isTel)%> class="tcred" >미사용</option>
			</select>
			<select name="isTelTF" class="select">
				<option value="">필수값여부</option>
				<option value="T" <%=isSelect("T",isTelTF)%> class="tcred" >필수값</option>
				<option value="F" <%=isSelect("F",isTelTF)%> class="tcblue">선택값</option>
			</select>
		</td>
		<td class="borLeft">전화 번호 항목의 사용 및 필수값 선택</td>
	</tr><tr>
		<th>첨부파일1</th>
		<td>
			<select name="isData1" class="select">
				<option value="">사용여부</option>
				<option value="T" <%=isSelect("T",isData1)%> class="tcblue">사용</option>
				<option value="F" <%=isSelect("F",isData1)%> class="tcred" >미사용</option>
			</select>
			<select name="isData1TF" class="select">
				<option value="">필수값여부</option>
				<option value="T" <%=isSelect("T",isData1TF)%> class="tcred" >필수값</option>
				<option value="F" <%=isSelect("F",isData1TF)%> class="tcblue">선택값</option>
			</select>
			제한용량 : <input type="text" name="intData1MB" class="input_text" style="width:70px;" value="<%=intData1MB%>" />MB
		</td>
		<td class="borLeft">첨부파일1 항목의 사용 및 필수값, 제한용량 선택</td>
	</tr><tr>
		<th>첨부파일2</th>
		<td>
			<select name="isData2" class="select">
				<option value="">사용여부</option>
				<option value="T" <%=isSelect("T",isData2)%> class="tcblue">사용</option>
				<option value="F" <%=isSelect("F",isData2)%> class="tcred" >미사용</option>
			</select>
			<select name="isData2TF" class="select">
				<option value="">필수값여부</option>
				<option value="T" <%=isSelect("T",isData2TF)%> class="tcred" >필수값</option>
				<option value="F" <%=isSelect("F",isData2TF)%> class="tcblue">선택값</option>
			</select>
			제한용량 : <input type="text" name="intData2MB" class="input_text" style="width:70px;" value="<%=intData2MB%>" />MB
		</td>
		<td class="borLeft">첨부파일2 항목의 사용 및 필수값, 제한용량 선택</td>
	</tr><tr>
		<th>첨부파일3</th>
		<td>
			<select name="isData3" class="select">
				<option value="">사용여부</option>
				<option value="T" <%=isSelect("T",isData3)%> class="tcblue">사용</option>
				<option value="F" <%=isSelect("F",isData3)%> class="tcred" >미사용</option>
			</select>
			<select name="isData3TF" class="select">
				<option value="">필수값여부</option>
				<option value="T" <%=isSelect("T",isData3TF)%> class="tcred" >필수값</option>
				<option value="F" <%=isSelect("F",isData3TF)%> class="tcblue">선택값</option>
			</select>
			제한용량 : <input type="text" name="intData3MB" class="input_text" style="width:70px;" value="<%=intData3MB%>" />MB
		</td>
		<td class="borLeft">첨부파일3 항목의 사용 및 필수값, 제한용량 선택</td>
	</tr>
	<tr>
		<th>이미지파일1</th>
		<td>
			<select name="isPic1" class="select">
				<option value="">사용여부</option>
				<option value="T" <%=isSelect("T",isPic1)%> class="tcblue">사용</option>
				<option value="F" <%=isSelect("F",isPic1)%> class="tcred" >미사용</option>
			</select>
			<select name="isPic1TF" class="select">
				<option value="">필수값여부</option>
				<option value="T" <%=isSelect("T",isPic1TF)%> class="tcred" >필수값</option>
				<option value="F" <%=isSelect("F",isPic1TF)%> class="tcblue">선택값</option>
			</select>
			제한용량 : <input type="text" name="intPic1MB" class="input_text" style="width:70px;" value="<%=intPic1MB%>" />MB
		</td>
		<td class="borLeft">이미지파일1 항목의 사용 및 필수값, 제한용량 선택<br />모바일 이미지보기(다운로드X)</td>
	</tr><tr>
		<th>이미지파일2</th>
		<td>
			<select name="isPic2" class="select">
				<option value="">사용여부</option>
				<option value="T" <%=isSelect("T",isPic2)%> class="tcblue">사용</option>
				<option value="F" <%=isSelect("F",isPic2)%> class="tcred" >미사용</option>
			</select>
			<select name="isPic2TF" class="select">
				<option value="">필수값여부</option>
				<option value="T" <%=isSelect("T",isPic2TF)%> class="tcred" >필수값</option>
				<option value="F" <%=isSelect("F",isPic2TF)%> class="tcblue">선택값</option>
			</select>
			제한용량 : <input type="text" name="intPic2MB" class="input_text" style="width:70px;" value="<%=intPic2MB%>" />MB
		</td>
		<td class="borLeft">이미지파일2 항목의 사용 및 필수값, 제한용량 선택<br />모바일 이미지보기(다운로드X)</td>
	</tr><tr>
		<th>이미지파일3</th>
		<td>
			<select name="isPic3" class="select">
				<option value="">사용여부</option>
				<option value="T" <%=isSelect("T",isPic3)%> class="tcblue">사용</option>
				<option value="F" <%=isSelect("F",isPic3)%> class="tcred" >미사용</option>
			</select>
			<select name="isPic3TF" class="select">
				<option value="">필수값여부</option>
				<option value="T" <%=isSelect("T",isPic3TF)%> class="tcred" >필수값</option>
				<option value="F" <%=isSelect("F",isPic3TF)%> class="tcblue">선택값</option>
			</select>
			제한용량 : <input type="text" name="intPic3MB" class="input_text" style="width:70px;" value="<%=intPic3MB%>" />MB
		</td>
		<td class="borLeft">이미지파일3 항목의 사용 및 필수값, 제한용량 선택<br />모바일 이미지보기(다운로드X)</td>
	</tr>

	<tr>
		<th>그림첨부(썸네일)</th>
		<td>
			<select name="isPic" class="select">
				<option value="">사용여부</option>
				<option value="T" <%=isSelect("T",isPic)%> class="tcblue">사용</option>
				<option value="F" <%=isSelect("F",isPic)%> class="tcred" >미사용</option>
			</select>
			<select name="isPicTF" class="select">
				<option value="">필수값여부</option>
				<option value="T" <%=isSelect("T",isPicTF)%> class="tcred" >필수값</option>
				<option value="F" <%=isSelect("F",isPicTF)%> class="tcblue">선택값</option>
			</select>
			제한용량 : <input type="text" name="intPicMB" class="input_text" style="width:70px;" value="<%=intPicMB%>" />MB
		</td>
		<td class="borLeft">그림첨부 항목의 사용 및 필수값, 제한용량 선택</td>
	</tr><tr>
		<th>링크 주소<br />(짧은 설명)</th>
		<td>
			<select name="isLink" class="select">
				<option value="">사용여부</option>
				<option value="T" <%=isSelect("T",isLink)%> class="tcblue">사용</option>
				<option value="F" <%=isSelect("F",isLink)%> class="tcred" >미사용</option>
			</select>
			<select name="isLinkTF" class="select">
				<option value="">필수값여부</option>
				<option value="T" <%=isSelect("T",isLinkTF)%> class="tcred" >필수값</option>
				<option value="F" <%=isSelect("F",isLinkTF)%> class="tcblue">선택값</option>
			</select>
		</td>
		<td class="borLeft">링크 주소 항목의 사용 및 필수값 선택 (galley2 일경우 짧은 설명)</td>
	</tr><tr>
		<th>동영상 사용</th>
		<td>
			<select name="isMovie" class="select">
				<option value="">사용여부</option>
				<option value="T" <%=isSelect("T",isMovie)%> class="tcblue">사용</option>
				<option value="F" <%=isSelect("F",isMovie)%> class="tcred" >미사용</option>
			</select>
			<select name="isMovieTF" class="select">
				<option value="">필수값여부</option>
				<option value="T" <%=isSelect("T",isMovieTF)%> class="tcred" >필수값</option>
				<option value="F" <%=isSelect("F",isMovieTF)%> class="tcblue">선택값</option>
			</select>
		</td>
		<td class="borLeft">게시판 동영상 사용여부</td>
	</tr><tr>
		<th>쓰기 최소 텍스트 제한</th>
		<td><input type="text" name="intContentMinLimit" class="input_text" style="width:70px;" value="<%=intContentMinLimit%>" /></td>
		<td class="borLeft">게시판 쓰기 최소 텍스트 제한수</td>
	</tr><tr>
		<th>답글 최소 텍스트 제한</th>
		<td><input type="text" name="intReplyMinLimit" class="input_text" style="width:70px;" value="<%=intReplyMinLimit%>" /></td>
		<td class="borLeft">게시판 답변 최소 텍스트 제한수</td>
	</tr>
</table>
</form>
	<div class="btn_area"><%=viewImgStJS(IMG_BTN&"/btn_rect_confirm.gif",99,45,"","margin-top:20px;","cp","onclick=""submitChkLevel();""")%></div>
</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
