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
	strUserID = pRequestTF("mid",True)


	'SQL = "SELECT * FROM DK_MEMBER A,DK_MEMBER_FINANCIAL B WHERE a.STRUSERID = b.STRUSERID AND a.strUserID = ?"
	arrParams = Array(_
		Db.makeParam("@strUserID",adVarChar,adParamInput,20,strUserID) _
	)
	Set DKRS = Db.execRs("DKP_ADMIN_MEMBER_INFO",DB_PROC,arrParams,Nothing)
	If Not DKRS.BOF And Not DKRS.EOF Then
		RS_DOMAIN		= DKRS("MotherSite")
		RS_REGISTDATE	= DKRS("dateRegist")
		RS_ID			= DKRS("strUserID")
		RS_NAME			= DKRS("strName")
		RS_PASS			= DKRS("strPass")
		RS_SSH1			= DKRS("strSSH1")
		RS_ZIP			= DKRS("strZip")
		RS_ADDR1		= DKRS("strADDR1")
		RS_ADDR2		= DKRS("strADDR2")
		RS_TEL			= DKRS("strTel")
		RS_MOBILE		= DKRS("strMobile")

		RS_MAIL			= DKRS("strEmail")
		RS_SMS			= DKRS("isSMS")
		RS_MAILING		= DKRS("isMailing")
		RS_VISIT		= DKRS("INTVISIT")

		RS_BIRTH		= DKRS("strBirth")
		RS_SOLAR		= DKRS("isSolar")

		RS_STATE		= DKRS("STRSTATE")
		RS_LEVEL		= DKRS("INTMEMLEVEL")
		RS_PRICE		= DKRS("INTPRICE")
		RS_PRICE_CNT	= DKRS("INTPRICECNT")
		RS_POINT		= DKRS("INTPOINT")

		RS_MEMBER_TYPE	= DKRS("memberType")

		RS_VOTERID		= DKRS("VoterID")

		'변경
'		If RS_TEL = "" Or IsNull(RS_TEL) Then RS_TEL = "--"
'			arrTEL = Split(RS_TEL,"-")
'		If RS_MOBILE = "" Or IsNull(RS_MOBILE) Then RS_MOBILE = "--"
'			arrMob = Split(RS_MOBILE,"-")
'		If RS_MAIL = "" Or IsNull(RS_MAIL) Then RS_MAIL = "@"
'			arrMAIL = Split(RS_MAIL,"@")
'		If RS_BIRTH = "" Or IsNull(RS_BIRTH) Then RS_BIRTH = "--"
'			arrBIRTH = Split(RS_BIRTH,"-")

		SQL = "SELECT COUNT(*) FROM DK_MEMBER_ADMIN_MEMO WHERE STRUSERID = ?"
		arrParam = Array(_
			Db.makeParam("@strUserID",adVarChar,adParamInput,20,strUserID) _
		)
		ADMIN_MEMO = CInt(Db.execRsData(SQL,DB_TEXT,arrParams,Nothing))

	Else
		Call ALERTS("회원정보가 로드되지 못했습니다.","back","")
	End If
	Call closeRS(DKRS)


	If RS_VOTERID = "" Or IsNull(RS_VOTERID) Then
		RS_VOTERID = "가입시 추천한 회원이 없습니다."
	Else
		arrParams = Array(_
			Db.makeParam("@strUserID",adVarChar,adParamInput,20,RS_VOTERID) _
		)
		Set DKRS = Db.execRs("DKP_ADMIN_MEMBER_VOTER",DB_PROC,arrParams,Nothing)
		If Not DKRS.BOF And Not DKRS.EOF Then
			RS_VOTER_STATE = DKRS("strState")
			RS_VOTERID = "가입시 추천하신 "&RS_VOTERID
			RS_VOTER_RESULT = "님은 현재 "& CallMemState(RS_VOTER_STATE) &" 상태의 회원입니다."

		Else
			RS_VOTER_RESULT = "데이터가 없음. (가입시 추천인을 입력하였으니 해당 추천인이 탈퇴를 한 상태입니다.)"
		End If
	End If




%>
<link rel="stylesheet" href="/admin/css/member.css" />
<script type="text/javascript" src="/admin/jscript/member.js"></script>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div class="member_modify">
	<input type="hidden" name="strUserID" value="<%=RS_ID%>" />
	<table <%=tableatt%> style="width:1000px;">
		<colgroup>
			<col width="130" />
			<col width="215" />
			<col width="130" />
			<col width="215" />
		</colgroup>
		<tbody>
			<tr class="line">
				<th colspan="4" class="th">회원 기본정보</th>
			</tr><tr class="line">
				<th>가입도메인</th>
				<td><%=RS_DOMAIN%></td>
				<th>가입일</th>
				<td><%=RS_REGISTDATE%></td>
			</tr><tr>
				<th>아이디</th>
				<td><%=RS_ID%></td>
				<th>주민등록번호</th>
				<td><%=RS_SSH1%>-*******</td>
			</tr><tr>
				<th>이름</th>
				<td><%=RS_NAME%></td>
				<th>비밀번호 <%=starText%></td>
				<td>-탈퇴요청 회원의 비밀번호는 변경할 수 없습니다</td>
			</tr><tr class="line">
				<th colspan="4" class="th">회원 일반정보</th>
			</tr><tr class="line">
				<th>주소 <%=starText%></th>
				<td colspan="3">(<%=RS_ZIP%>) <%=RS_ADDR1%>
				</td>
			</tr><tr>
				<th>상세주소 <%=starText%></th>
				<td colspan="3"><%=RS_ADDR2%></td>
			</tr><tr>
				<th>전화번호</th>
				<td colspan="3"><%=RS_TEL%></td>
			</tr><tr>
				<th>휴대폰번호 <%=starText%></th>
				<td colspan="3"><%=RS_MOBILE%></td>
			</tr><tr>
				<th>이메일</th>
				<td colspan="3"><%=RS_MAIL%></td>
			</tr><tr>
				<th>생일 <%=starText%></th>
				<td colspan="3"><%=RS_BIRTH%></td>
			</tr><tr class="line">
				<th colspan="4" class="th">회원 상태정보</th>
			</tr><tr class="line">
				<th>회원상태</th>
				<td><%=CallMemState(RS_STATE)%></td>
				<th>회원레벨</th>
				<td><%=RS_MEMBER_TYPE%> 타입의 <%=RS_LEVEL%> 레벨 회원입니다.</td>
			</tr><tr>
				<th>적립금</th>
				<td><strong><%=RS_POINT%></strong> Point <%=aImg("javascript:openPointCalc('"&RS_ID&"');",IMG_ICON&"/icon_plusminus.gif",16,16,"")%>
				<%=aImg("javascript:openPointDetail('"&RS_ID&"');",IMG_ICON&"/icon_detail.gif",16,16,"")%></td>
				<th>총 구매액</th>
				<td>(<strong><%=RS_PRICE_CNT%></strong> 회) / <strong><%=RS_PRICE%></strong> 원</td>
			</tr><tr>
				<th>관리자메모</th>
				<td><strong><%=ADMIN_MEMO%></strong> 건의 메모가 있습니다. <%=aImgSt("javascript:openMemo('"&RS_ID&"');",IMG_ICON&"/icon_memo.gif",16,16,"","","vmiddle")%></td>
				<th>로그인 횟수</th>
				<td><strong><%=RS_VISIT%></strong>번</td>
			</tr><tr class="line">
				<th colspan="4" class="th">회원 추천정보</th>
			</tr><tr>
				<th>가입 추천인</th>
				<td colspan="3"><%=RS_ID%> 님이 <%=RS_VOTERID%> <%=RS_VOTER_RESULT%></td>
			</tr><tr>
				<th>해당회원 추천인</th>
				<td colspan="3">
					<ul>
					<%
						arrParams = Array(_
							Db.makeParam("@strUserID",adVarChar,adParamInput,20,RS_ID) _
						)
						arrList = Db.execRsList("DKP_MEMBER_VOTER_LIST",DB_PROC,arrParams,listLen,Nothing)

						If IsArray(arrList) Then
							For i = 0 To listLen
								PRINT "<li><strong>"&arrList(3,i)&" ("&arrList(0,i)&")</strong> 님이 [ "&arrList(1,i)&" ] 도메인에서 "&arrList(2,i)&" 에 회원님을 추천하여 가입하셨습니다.</li>"
							Next
						Else
							PRINT "<li>회원님을 추천한 회원이 없습니다</li>"

						End If

					%>
					</ul>

				</td>
			</tr>
		</tbody>
	</table>

</div>
<form name="cfrm" method="post" action="memberStateHandler.asp">
	<input type="hidden" name="state" value="" />
	<input type="hidden" name="strUserID" value="<%=strUserID%>" />
</form>
<div class="btn_area p100">
	<%=viewImgStJS(IMG_BTN&"/btn_rect_member_leave.gif",99,45,"","margin-top:20px;","cp","onclick=""memberStateLeave();""")%>
	<%=viewImgStJS(IMG_BTN&"/infoCancel.gif",99,45,"","margin:20px 0px 0px 10px;","cp","onclick=""memberStateLeaveBack();""")%>
	<%=aImgSt("member_list1.asp",IMG_BTN&"/btn_rect_list.gif",99,45,"","margin:20px 0px 0px 10px;","")%>
</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->



