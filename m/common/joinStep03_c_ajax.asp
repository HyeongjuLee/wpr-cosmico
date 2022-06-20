<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/_lib/md5.asp" -->
<%
'	Option Explicit


	Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"



	Dim niceUid, svcPwd, strResId, strNm, strBankCode, strAccountNo, strGbn, svcGbn, strOrderNo, service, svc_cls, inq_rsn

	'##################################################
	'###### ▣ 회원사 ID 설정   - 계약시에 발급된 회원사 ID를 설정하십시오. ▣
	'###### ▣ 회원사 PW 설정   - 계약시에 발급된 회원사 PASSWORD를 설정하십시오. ▣
	'###### ▣ 조회사유  설정   - 10:회원가입 20:기존회원가입 30:성인인증 40:비회원확인 90:기타사유 ▣
	'###### ▣ 개인/사업자 설정 - 1:개인 2:사업자 ▣
	'##################################################
	niceUid			=	"Nhealthy"								'한국신용정보에서 고객사에 부여한 구분 id
	svcPwd			=	"123qweasd"								'한국신용정보에서 고객사에 부여한 서비스 이용 패스워드
	inq_rsn			=	"10"										'조회사유 - 10:회원가입 20:기존회원가입 30:성인인증 40:비회원확인 90:기타사유
	strGbn			=	"1"											'1 : 개인, 2: 사업자
	'##################################################

'	strResId		=	Request("JUMINNO")			' 주민번호
'	strNm			=	Request("USERNM")				' 성명
'	strBankCode		=	Request("strBankCode")	' 은행코드
'	strAccountNo	=	Request("strAccountNo")	' 계좌번호
'	service			=	Request("service")			' 서비스 구분
'	svcGbn			=	Request("svcGbn") 			' 업무구분
'	svc_cls			=	Request("svc_cls")			' 내-외국인구분
'	strOrderNo		=	makeOrderNo()						' 주문번호

	Set XTEncrypt = new XTclsEncrypt
	RChar = XTEncrypt.MD5(RandomChar(10))



	TempDataNum		= RChar
	centerName		= Request.form("centerName")
	centerCode		= Request.form("centerCode")
'	strName			= Request.form("strName")
'	TempDataNum		= Request.form("TempDataNum")
	strSSH1			= Request.form("strSSH1")
	strSSH2			= Request.form("strSSH2")

	strBankCode		= Request.form("strBankCode")
	strBankNum		= Request.form("strBankNum")
	strBankOwner	= Request.form("strBankOwner")


	strBankNum2	= Replace(strBankNum,"-","")

	'##################################################
	'###### ▣ 계좌인증용 내용 변환
	'##################################################
	strResId		= strSSH1&strSSH2
	strNm			= strBankOwner
	strBankCode		= strBankCode
	strAccountNo	= strBankNum2
	service			= 1
	svcGbn			= 5
	svc_cls			= ""
	strOrderNo		= makeOrderNo()

	'▣기존 은행정보와 비교 - 1이면 튕김
	strBankCodeVARCHAR = Right("000"&strBankCode,3)


	'▣ CS 계좌번호중복체크
	'SQL = "SELECT COUNT([mbid]) FROM [tbl_memberinfo] WHERE [bankcode] = ? AND [bankaccnt] = ?"
	'arrParams = Array(_
	'	Db.makeParam("@strBankCode",adVarChar,adParamInput,10,strBankCodeVARCHAR), _
	'	Db.makeParam("@bankaccnt",adVarchar,adParamInput,100,Enc_strBankNum) _
	')
	'DbCheckMember = Db.execRsData(SQL,DB_TEXT,arrParams,DB3)

	'▣ CS 이름 + 생년월일 중복체크(탈퇴회원 중복대상제외, 2017-03-17~)
	SQL = "SELECT COUNT([mbid]) FROM [tbl_memberinfo] WHERE [M_Name] = ? And [BirthDay] = ? And [BirthDay_M] = ? And [BirthDay_D] = ? And [LeaveCheck] = 1"
	arrParams = Array(_
		Db.makeParam("@M_Name",adVarWchar,adParamInput,100,strBankOwner), _
		Db.makeParam("@BirthDay",adVarchar,adParamInput,4,birthYY), _
		Db.makeParam("@BirthDay_M",adVarchar,adParamInput,2,birthMM), _
		Db.makeParam("@BirthDay_D",adVarchar,adParamInput,2,birthDD) _
	)
	DbCheckMember = Db.execRsData(SQL,DB_TEXT,arrParams,DB3)

	If DbCheckMember > 0 Then
		Response.Write "<span class=""red"">이미 등록된 회원입니다. 본인이 회원가입을 하지 않았다면 본사로 문의해주세요.</span>"
		Response.End
	End If



	Call GetMLBMCode()	' 함수 CALL

	Public Sub GetMLBMCode()

		Dim ServerXMLHTTP, oHttp
		Dim strMLBResponseText
		Dim strParam, strTargetURL, strResponseText, strParamLength
		Dim strRetcd, OrderNum, ResultCD, DetailCD, Msg

		strResponseText = ""
		'strTargetURL = "https://secure.nuguya.com/nuguya/service/realname/sprealnameactconfirm.do"
		strTargetURL = "https://secure.nuguya.com/nuguya2/service/realname/sprealnameactconfirm.do"		'UTF-8 URL

		strParam = "niceUid="&niceUid&"&svcPwd="&svcPwd&"&strResId="&strResId&"&strNm="&strNm&"&strBankCode="&strBankCode&"&strAccountNo="&strAccountNo&"&service="&service&"&strGbn="&strGbn&"&svcGbn="&svcGbn&"&strOrderNo="&strOrderNo&"&svc_cls="&svc_cls&"&inq_rsn="&inq_rsn&"&seq=0000001"

		strParamLength = Len(strParam)

		set oHttp = Server.CreateObject("MSXML2.ServerXMLHTTP")
		'타임아웃
		Dim lngResolveTimeout, lngConnectTimeout, lngSendTimeout, lngReceiveTimeout
		lngResolveTimeout = 1000 * 10	'10초
		lngConnectTimeout = 1000 * 10	'10초
		lngSendTimeout  	= 1000 * 10	'10초
		lngReceiveTimeout = 1000 * 10	'10초
		oHttp.SetTimeouts lngResolveTimeout, lngConnectTimeout, lngSendTimeout, lngReceiveTimeout


		With oHttp
			.setOption 2, 13056
			.open "POST", strTargetURL, false
			.setRequestHeader "Host", "secure.nuguya.com"
			.setRequestHeader "Connection", "Keep-Alive"
			.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
			.setRequestHeader "Content-Length", "&strParamLength&"
			.send strParam

			strResponseText = .responseText
		End With

		strMLBResponseText = strResponseText

		strRetcd = Split(strMLBResponseText,"|")

		OrderNum	= strRetcd(0)		' 주문번호
		ResultCD	= strRetcd(1)		' 결과코드
		Msg			= strRetcd(2)		' 메세지

'		Response.Write "주문번호 : " & OrderNum & "<br>"
'		Response.Write "결과코드 : " & ResultCD & "<br>"
'		Response.Write "메세지   : " & Msg      & "<br>"
'		Response.End



		'결과값이 정상인 경우
		If ResultCD = "0000" Then
			arrParams = Array(_
				Db.makeParam("@TempDataNum",adVarChar,adParamInput,50,TempDataNum),_
				Db.makeParam("@strName",adVarWChar,adParamInput,50,strBankOwner),_
				Db.makeParam("@strSSH1",adVarChar,adParamInput,6,strSSH1),_
				Db.makeParam("@strSSH2",adVarChar,adParamInput,7,strSSH2),_
				Db.makeParam("@strCenterName",adVarChar,adParamInput,30,centerName),_
				Db.makeParam("@strCenterCode",adVarChar,adParamInput,30,centerCode),_
				Db.makeParam("@strBankCode",adVarChar,adParamInput,10,strBankCode),_
				Db.makeParam("@strBankNum",adVarChar,adParamInput,100,strBankNum),_
				Db.makeParam("@strBankOwner",adVarWChar,adParamInput,100,strBankOwner),_
				Db.makeParam("@strOrderNum",adVarChar,adParamInput,30,strOrderNo), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("DKP_MEMBER_JOIN_BANK_INSERT",DB_PROC,arrParams,DB3)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)

			If OUTPUT_VALUE = "FINISH" Then

				'▣ CS 주민번호중복체크
				strSSH = strSSH1&strSSH2
				SQL = "SELECT COUNT([mbid]) FROM [tbl_memberinfo] WHERE [cpno] = ?"
				arrParams = Array(_
					Db.makeParam("@strSSH1",adVarchar,adParamInput,100,strSSH) _
				)
				CSDBJoinCnt = Db.execRsData(SQL,DB_TEXT,arrParams,DB3)

				'▣ CS2 주민번호중복체크(헬씨B)
				strSSH = strSSH1&strSSH2
				SQL = "SELECT COUNT([mbid]) FROM [tbl_memberinfo] WHERE [cpno] = ?"
				arrParams = Array(_
					Db.makeParam("@strSSH1",adVarchar,adParamInput,100,strSSH) _
				)
				CSDBJoinCnt2 = Db.execRsData(SQL,DB_TEXT,arrParams,DB4)

				If Int(CSDBJoinCnt) > 0 Then
					PRINT "<span class=""text_red tweight"">이미 보상플랜-A에 가입된 주민등록번호 입니다. 다시한번 확인해주세요.</span>"
					PRINT "<input type=""hidden"" name=""ajaxTF"" value=""F"" readonly=""readonly"" />"
				ElseIf Int(CSDBJoinCnt2) > 0 Then
					PRINT "<span class=""text_red tweight"">이미 보상플랜-B에 가입된 주민등록번호 입니다. 다시한번 확인해주세요.</span>"
					PRINT "<input type=""hidden"" name=""ajaxTF"" value=""F"" readonly=""readonly"" />"
				Else
					PRINT "<span class=""tweight"" style=""color:green"">본인인증에 성공하였습니다. 다음단계로 진행해주세요.</span>"

					PRINT "<input type=""hidden"" name=""strBankCodeCHK"" value="""&strBankCode&""" readonly=""readonly"" />"
					PRINT "<input type=""hidden"" name=""strBankNumCHK"" value="""&strBankNum&""" readonly=""readonly"" />"
					PRINT "<input type=""hidden"" name=""strBankOwnerCHK"" value="""&strBankOwner&""" readonly=""readonly"" />"
					PRINT "<input type=""hidden"" name=""strSSH1CHK"" value="""&strSSH1&""" readonly=""readonly"" />"
					PRINT "<input type=""hidden"" name=""strSSH2CHK"" value="""&strSSH2&""" readonly=""readonly"" />"

					PRINT "<input type=""hidden"" name=""TempDataNum"" value="""&TempDataNum&""" readonly=""readonly"" />"
					PRINT "<input type=""hidden"" name=""ajaxTF"" value=""T"" readonly=""readonly"" />"
				End If

			Else

				PRINT "<span class=""text_red tweight"">데이터베이스 입력에 실패하였습니다. "&Msg&"</span>"

				PRINT "<input type=""hidden"" name=""strBankCodeCHK"" value="""&strBankCode&""" readonly=""readonly"" />"
				PRINT "<input type=""hidden"" name=""strBankNumCHK"" value="""&strBankNum&""" readonly=""readonly"" />"
				PRINT "<input type=""hidden"" name=""strBankOwnerCHK"" value="""&strBankOwner&""" readonly=""readonly"" />"
				PRINT "<input type=""hidden"" name=""strSSH1CHK"" value="""&strSSH1&""" readonly=""readonly"" />"
				PRINT "<input type=""hidden"" name=""strSSH2CHK"" value="""&strSSH2&""" readonly=""readonly"" />"

				PRINT "<input type=""hidden"" name=""TempDataNum"" value="""" readonly=""readonly"" />"
				PRINT "<input type=""hidden"" name=""ajaxTF"" value=""F"" readonly=""readonly"" />"


			End If

		Else
				PRINT "<span class=""text_red tweight"">본인인증에 실패하였습니다. "&Msg&"</span>"

				PRINT "<input type=""hidden"" name=""strBankCodeCHK"" value="""&strBankCode&""" readonly=""readonly"" />"
				PRINT "<input type=""hidden"" name=""strBankNumCHK"" value="""&strBankNum&""" readonly=""readonly"" />"
				PRINT "<input type=""hidden"" name=""strBankOwnerCHK"" value="""&strBankOwner&""" readonly=""readonly"" />"
				PRINT "<input type=""hidden"" name=""strSSH1CHK"" value="""&strSSH1&""" readonly=""readonly"" />"
				PRINT "<input type=""hidden"" name=""strSSH2CHK"" value="""&strSSH2&""" readonly=""readonly"" />"

				PRINT "<input type=""hidden"" name=""TempDataNum"" value="""" readonly=""readonly"" />"
				PRINT "<input type=""hidden"" name=""ajaxTF"" value=""F"" readonly=""readonly"" />"

		End If


	End Sub

	function makeOrderNo()
		Dim yyyymmdd, yyyy, mm, dd
		yyyy = Year(Now)
		mm   = Right("0" & Month(Now), 2)
		dd   = Right("0" & Day(Now), 2)
		yyyymmdd = yyyy & mm & dd
		Dim rand_num,max,min
		min = 1000000000
		max = 9999999999
		Randomize
		rand_num = int((max-min+1)*rnd+min)
		makeOrderNo	=	yyyymmdd & rand_num		' 주문번호

	end function
%>