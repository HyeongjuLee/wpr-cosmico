<!--#include virtual = "/_lib/strFunc.asp" -->
<!--#include virtual = "/_lib/strFuncJoin.asp"-->
<!--#include virtual = "/_include/document.asp"-->
</head>
<body>
<%
	Call ONLY_MEMBER_CONFIRM(DK_MEMBER_LEVEL)

	strPass = Trim(pRequestTF("strPass",True))
	strSSH1 = Trim(pRequestTF("strSSH1",True))
	strSSH2 = Trim(pRequestTF("strSSH2",True))



	'If checkResNo(strSSH1,strSSH2) = False Then Call ALERTS("주민등록번호가 올바르지 않습니다.1","BACK","")

	arrParams = Array(_
		Db.makeParam("@strUserID",adVarChar,adParamInput,30,DK_MEMBER_ID)_
	)
	Set DKRS = Db.execRs("DKP_MEMBER_INFO_FOR_LEAVE",DB_PROC,arrParams,Nothing)
	If Not DKRS.BOF And Not DKRS.EOF Then
		RS_SSH1		= DKRS("strSSH1")
		RS_SSH2		= DKRS("strSSH2")
		RS_PASS		= Trim(DKRS("strPass"))
		RS_TYPE		= UCase(DKRS("memberType"))
	Else
		Call ALERTS("회원정보가 로드되지 못하였습니다. 다시 로그인 해주세요.","go","/common/member_logout.asp")
	End If
	Call closeRs(DKRS)


	If strPass <> RS_PASS Then Call ALERTS("비밀번호가 틀립니다. 현재 사용하시는 비밀번호를 입력해주세요.","BACK","")
	If strSSH1 <> RS_SSH1 Then Call ALERTS("가입시 기입하신 주민번호와 일치하지 않습니다.1","BACK","")
	If strSSH2 <> RS_SSH2 Then Call ALERTS("가입시 기입하신 주민번호와 일치하지 않습니다.2","BACK","")
	If RS_TYPE = "COMPANY" Then Call ALERTS("파트너쉽회원은 탈퇴할 수 없습니다. 고객센터로 문의해주세요.","BACK","")

	arrParams = Array(_
		Db.makeParam("@strUserID",adVarChar,adParamInput,30,DK_MEMBER_ID),_
		Db.makeParam("@strState",adVarChar,adParamInput,3,"443") ,_
		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)
	Call Db.exec("DKP_MEMBER_LEAVE_OK",DB_PROC,arrParams,Nothing)
	OUTPUT_VALUE = arrParams(UBound(arrParams))(4)


	Select Case OUTPUT_VALUE
		Case "ERROR" : Call ALERTS(DBERROR,"BACK","")
		Case "FINISH" : Call ALERTS("탈퇴신청이 정상적으로 이루어졌습니다. 로그아웃 처리 됩니다.","GO","/common/member_logout.asp")
	End Select





%>
