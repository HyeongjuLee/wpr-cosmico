<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	PAGE_SETTING = "MYPAGE"
	ISLEFT = "T"
	ISSUBTOP = "T"
	ISSUBVISUAL = "T"
	view = 5


	Call ONLY_MEMBER_CONFIRM(DK_MEMBER_LEVEL)

	arrParams = Array(_
		Db.makeParam("@strUserID",adVarChar,adParamInput,30,DK_MEMBER_ID)_
	)
	Set DKRS = Db.execRs("DKP_MEMBER_INFO",DB_PROC,arrParams,Nothing)
	If Not DKRS.BOF And Not DKRS.EOF Then

		RS_MOTHERSITE = DKRS("motherSite")
		RS_NAME		= DKRS("strName")
'		RS_SSH1		= DKRS("strSSH1")
		RS_ZIP		= DKRS("strZip")
		RS_ADDR1	= DKRS("strADDR1")
		RS_ADDR2	= DKRS("strADDR2")
		RS_TEL		= DKRS("strTel")
		RS_MOBILE	= DKRS("strMobile")

		RS_MAIL		= DKRS("strEmail")
		RS_SMS		= DKRS("isSMS")
		RS_MAILING	= DKRS("isMailing")
		'PRINT RS_SMS

		RS_BIRTH	= DKRS("strBirth")
'		RS_SOLAR	= DKRS("isSolar")

'		RS_VOT_MID1 = DKRS("voter_mbid")
'		RS_VOT_MID2 = DKRS("voter_mbid2")
'		RS_VOT_SHOP = DKRS("voter_WebID")
'		RS_VOT_NAME = DKRS("VOTE_NAME")
'
'		RS_SPON_MID1 = DKRS("sponsor_mbid")
'		RS_SPON_MID2 = DKRS("sponsor_mbid2")
'		RS_SPON_SHOP = DKRS("sponsor_WebID")
'		RS_SPON_NAME = DKRS("SPON_NAME")

'		RS_BANKCODE = DKRS("BankCode")
'		RS_BANKNUM = DKRS("BankNumber")
'		RS_BANKOWN = DKRS("BankOwner")


		'변경
		If RS_TEL = "" Or IsNull(RS_TEL) Then RS_TEL = "--"
			arrTEL = Split(RS_TEL,"-")
		If RS_MOBILE = "" Or IsNull(RS_MOBILE) Then RS_MOBILE = "--"
			arrMob = Split(RS_MOBILE,"-")
		If RS_MAIL = "" Or IsNull(RS_MAIL) Then RS_MAIL = "@"
			arrMAIL = Split(RS_MAIL,"@")
		If RS_BIRTH = "" Or IsNull(RS_BIRTH) Then RS_BIRTH = "--"
			arrBIRTH = Split(RS_BIRTH,"-")
	Else
		Call ALERTS("회원정보가 로드되지 못하였습니다. 다시 로그인 해주세요.","go","/common/member_logout.asp")
	End If




%>

<!--#include virtual = "/_include/document.asp"-->
<link rel="stylesheet" href="/css/mypage.css">
<script type="text/javascript" src="/jscript/member_modify.js"></script>
</head>
<body>
<!--#include virtual="/_include/header.asp" -->
<!--#include virtual = "/_include/sub_title.asp"-->

<div id="mypage">
	<div class="leave">
		<form name="cfrm" method="post" action="member_leaveOk.asp" onsubmit="return leaveChk(this)">
		<p class="t1"><span class="colors">- <%=DK_MEMBER_NAME%></span> 님, <span class="colors">회원 탈퇴</span>를 요청하시겠습니까?</p>
		<p class="t2">- 입력하신 정보는 회원 탈퇴 이외의 목적으로 사용하지 않습니다.</p>
		<p class="mtit"><%=viewImg(IMG_MYPAGE&"/mtit_leave_alert.gif",142,33,"")%></p>
		<ul class="leaveAlerts">
			<li class="tweight">회원탈퇴 요청 후 데이터 완전삭제 시 까지 회원 재가입을 할 수 없습니다.</li>
			<li class="tweight">데이터 완전 삭제후에도 '개인정보의 보유 및 이용기간' 에 따라 서비스 이용기록 및 결제 기록은 5년동안 보존됩니다.</li>
			<li class="tweight">데이터 완전 삭제 시 삭제되는 데이터입니다. 삭제된 데이터는 복구할 수 없습니다.</li>
			<li class="disc"><strong>포인트</strong> : 글 작성 및 기타 사유로 적립/사용된 포인트 삭제</li>
			<li class="disc"><strong>쪽지</strong> : 탈퇴한 회원과 주고 받은 쪽지</li>
			<li class="disc"><strong>스크랩</strong> : 탈퇴한 회원이 스크랩한 스크랩 자료</li>
			<li class="disc"><strong>게시글</strong> : 탈퇴한 회원이 작성한 게시글</li>
			<li class="disc"><strong>댓글</strong> : 탈퇴한 회원이 작성한 댓글</li>
			<li class="disc"><strong>문의</strong> : 고객센터 나 1:1 문의등의 문의글</li>
		</ul>
		<p class="mtit sectit"><%=viewImg(IMG_MYPAGE&"/mtit_leave_info.gif",142,33,"")%></p>
		<table <%=tableatt%> class="userCWidth2 step1">
			<colgroup>
				<col width="170" />
				<col width="500" />
			</colgroup>
			<tr>
				<td colspan="2" class="cause tweight"><span class="colors">본인 확인</span>을 위해 회원님의 <span class="colors">비밀번호</span>와 <span class="colors">주민등록번호</span>를 다시 한번 입력해주세요.</td>
			</tr><tr>
				<th>비밀번호 입력</th>
				<td><input type="password" name="strPass" class="input_text" style="width:240px;" /></td>
			</tr><tr>
				<th>주민등록번호 입력</th>
				<td><input type="text" name="strSSH1" class="input_text" style="width:140px;" maxlength="6" /> - <input type="password" name="strSSH2" class="input_text" style="width:180px;" maxlength="7" /></td>
			</tr>
		</table>
		<div class="btn_area p100"><input type="image" src="<%=IMG_MYPAGE%>/infoOk.gif" style="margin-top:20px;" /></div>
		</form>
	</div>
</div>
<!--#include virtual = "/_include/copyright.asp"-->
