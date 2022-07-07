<%
	' *****************************************************************************
	' Function Name : MEMBER_AUTH_CHECK, ONLY_MEMBER
	' Discription : 회원 사용권한, 회원전용 페이지 설정
	' *****************************************************************************
		If Left(ThisPageURL,3) = "/m/" Then
			MOB_PATH = "/m"
		Else
			MOB_PATH = ""
		End If

		Function MEMBER_AUTH_CHECK(NOWLEVEL,CHECK_LEVEL)
			If NOWLEVEL < CHECK_LEVEL Then Call alerts(LNG_STRCHECK_TEXT01,"back","")
		End Function

		Function ONLY_MEMBER(NOWLEVEL)
			If NOWLEVEL <= 0 Then Call alerts(LNG_STRCHECK_TEXT02&"\n"&LNG_STRCHECK_TEXT03&"\n\n"&LNG_STRCHECK_TEXT04,"go", MOB_PATH&"/common/member_logout.asp")
		End Function


		Function M_ONLY_MEMBER(NOWLEVEL,URLS)
			If NOWLEVEL <= 0 Then Call alerts(LNG_STRCHECK_TEXT02,"go","/m/common/member_login.asp?backURL="&URLS)
		End Function

		Function M_ONLY_MEMBER_DETAILVIEW(NOWLEVEL,gidx)
			If NOWLEVEL <= 0 Then Call alerts(LNG_STRCHECK_TEXT02,"go","/m/shop/detailView.asp?gidx="&gidx)
		End Function

		Function ONLY_MEMBER_CONFIRM(NOWLEVEL)
			'If NOWLEVEL <= 0 Then Call CONFIRM("회원전용 페이지입니다. 로그인 하시겠습니까?","login2","","")
			If NOWLEVEL <= 0 Then Call CONFIRM(LNG_STRCHECK_TEXT02&"\n"&LNG_STRCHECK_TEXT05,"go_back", MOB_PATH&"/common/member_login.asp?backURL="&ThisPageURL&"","")
		End Function

		Function FNC_ONLY_CS_MEMBER()
			If DK_MEMBER_STYPE <> "0" Then Call CONFIRM(LNG_STRCHECK_TEXT06,"go_back","/m/common/member_login.asp","")
		End Function


		Function ONLY_BUSINESS_MEMBER(NOWLEVEL,CHECK_LEVEL)
			If NOWLEVEL < CHECK_LEVEL Then
				'Call CONFIRM(LNG_STRCHECK_TEXT02&"\n"&LNG_STRCHECK_TEXT05,"go_back", MOB_PATH&"/common/member_login.asp?backURL="&ThisPageURL&"","")
				Response.Redirect MOB_PATH&"/common/member_login.asp?backURL="&ThisPageURL
			End if
		End Function

		Function ONLY_MEMBER_CLOSE(NOWLEVEL)
			If NOWLEVEL <= 0 Or DK_MEMBER_ID = "GUEST" Then Call ALERTS(LNG_STRCHECK_TEXT02&"\n"&LNG_STRCHECK_TEXT03&"\n\n"&LNG_STRCHECK_TEXT04,"go", MOB_PATH&"/common/member_logout.asp")
		End Function



		'▣▣마이오피스(CS)▣▣
		Function ONLY_CS_MEMBER()
			''If (DK_MEMBER_ID1 = "" Or DK_MEMBER_ID2 = "" Or DK_MEMBER_STYPE <> 0) Then Call ALERTS(LNG_STRCHECK_TEXT06,"GO", MOB_PATH&"/index.asp")
			'If (DK_MEMBER_ID1 = "" Or DK_MEMBER_ID2 = "") AND DK_MEMBER_TYPE <> "COMPANY" Then Call ALERTS(LNG_STRCHECK_TEXT06,"GO","/index.asp")

			If (DK_MEMBER_ID1 = "" Or DK_MEMBER_ID2 = "" ) Then
				Call ALERTS(LNG_STRCHECK_TEXT06,"GO", MOB_PATH&"/index.asp")
			Else
				Select Case DK_MEMBER_STYPE
					Case "0"
					Case Else
						Call ALERTS(LNG_STRCHECK_TEXT06,"GO", MOB_PATH&"/index.asp")
				End Select
			End If

		End Function


		'◈판매원 or 소비자 조회
		Function ONLY_CS_MEMBER_ALL()
			If (DK_MEMBER_ID1 = "" Or DK_MEMBER_ID2 = "" ) Then
				Call ALERTS(LNG_STRCHECK_TEXT06,"GO", MOB_PATH&"/index.asp")
			Else
				Select Case DK_MEMBER_STYPE
					Case "0","1"
					Case Else
						Call ALERTS(LNG_STRCHECK_TEXT06,"GO", MOB_PATH&"/index.asp")
				End Select
			End If

		End Function


		Function ONLY_CS_MEMBER_CLOSE()
			If DK_MEMBER_ID1 = "" Or DK_MEMBER_ID2 = "" Then Call ALERTS(LNG_STRCHECK_TEXT02&"\n"&LNG_STRCHECK_TEXT03&"\n\n"&LNG_STRCHECK_TEXT04,"go","/common/member_logout.asp")
		End Function

		Function ONLY_BUSINESS(ByRef BUSINESS_CODE)
			'If DK_BUSINESS_CNT < 1 Then Call alerts(LNG_STRCHECK_TEXT01,"back","")
			arrParamsBC = Array(_
				Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
				Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
			)
			Set DKRSBC = Db.execRs("DKP_BUSINESS_BOSS_CHECK",DB_PROC,arrParamsBC,DB3)
			If Not DKRSBC.BOF And Not DKRSBC.EOF Then
				BUSINESS_CODE = DKRSBC("ncode")
			Else
				Call alerts(LNG_STRCHECK_TEXT01,"back","")
			End If
			Call closeRS(DKRSBC)
		End Function

		Function ONLY_CSMEMBER_CLOSE()
			If DK_MEMBER_ID1 = "" Or DK_MEMBER_ID2 = "" Then Call ALERTS(LNG_STRCHECK_TEXT02&"\n"&LNG_STRCHECK_TEXT03&"\n\n"&LNG_STRCHECK_TEXT04,"close",  MOB_PATH&"/common/member_logout.asp")
		End Function


		'잘못된 접근
		Function WRONG_ACCESS
			Call ALERTS(LNG_ALERT_WRONG_ACCESS,"BACK","")
		End Function

	' *****************************************************************************
	'	Function name	: checkNumeric
	'	Description		: 숫자체크(숫자가 아니면 0 으로 치환)
	' *****************************************************************************
		Function checkNumeric(ByVal value)
			If IsNumeric(value) Or VarType(value) = 14 Then ' VarType 14 : adDecimal
				checkNumeric = CDbl(value)
			Else
				checkNumeric = 0
			End If
		End Function


	' *****************************************************************************
	' Function Name : Auth_Admin_Check
	' Discription : 관리자 세션 체크
	' *****************************************************************************
		Function Auth_Admin_Check(ByVal CHECKS)
			If CHECKS = SESSION("ADMIN_ID") Then
				Call alerts("관리자 인증세션이 남아 있습니다.\n관리자 페이지로 이동합니다.","go","/admin/index.asp")
			End If
		End Function

' ######################################################################
'	Function name	: eRegiTest
'	Parameter		:
'			value					= 검사 문자열
'			pattern	 				= 정규식
'	Return				: Boolean
'	Description		: 문자열 정규식 Test
'			Pattern Ex)
'							[^가-힣]						: 한글
'							[^-0-9 ]						: 숫자
'							[^-a-zA-Z]					: 영어
'							[^-가-힣a-zA-Z0-9/ ]		: 한글,영어,숫자
'							<[^>]*>						: 태그
'							[^-a-zA-Z0-9/ ]			: 영어,숫자
' ######################################################################
	Function eRegiTest(ByVal value, ByVal pattern)
		Dim objRegExp
		Set objRegExp = New RegExp

		objRegExp.Pattern = pattern
		objRegExp.IgnoreCase = False		' 대/소문자를 구분하지 않도록 함
		objRegExp.Global = True					' 문자열 전체에서 검색

		eRegiTest = objRegExp.Test(value)
		Set objRegExp = Nothing
	End Function

' ####################################################################################################
'	Function name	: checkID
'	Parameter		:
'			value					= 아이디
'			min						= 최소길이
'			max						= 최대길이
'	Return				: Boolean
'	Description		: 아이디 유효성 검사
' ####################################################################################################
	Function checkID(ByVal value, ByVal min, ByVal max)
		checkID = eRegiTest(value, "^[a-zA-Z0-9\_]{"& min &","& max &"}$")
	End Function

' ####################################################################################################
'	Function name	: checkPass
'	Parameter		:
'			value					= 비밀번호
'			min						= 최소길이
'			max						= 최대길이
'	Return				: Boolean
'	Description		: 비밀번호 유효성 검사
' ####################################################################################################
	Function checkPass(ByVal value, ByVal min, ByVal max)
		checkPass = eRegiTest(value, "^[a-zA-Z0-9]{"& min &","& max &"}$")
		'checkPass = eRegiTest(value, "^[a-zA-Z0-9`~!@#$%^&*()-_=+{}\|?]{"& min &","& max &"}$")		'특수문자포함, check.js 동시변경
	End Function

' ####################################################################################################
'	Function name	: checkNameSearch
'	Description		: 추천/후원인 검색
' ####################################################################################################
	Function checkNameSearch(ByVal value, ByVal min, ByVal max)
		'checkNameSearch = eRegiTest(value, "^[가-힣a-zA-Z0-9_() ]{"& min &","& max &"}$")		'숫자허용
		checkNameSearch = eRegiTest(value, "^[가-힣a-zA-Z_() ]{"& min &","& max &"}$")
	End Function

' ####################################################################################################
'	Function name	: checkID_CSID
'	Parameter		:
'			value					= 아이디
'	Return			: Boolean
'	Description		: CS아이디 유효성 검사, value로 시작하는 id 금지
' ####################################################################################################
	Function checkID_CSID(ByVal value)
		checkID_CSID = eRegiTest(LCase(value), "^(test|cs_)")
	End Function


' ######################################################################
'	Function name	: checkResNo
'	Parameter		:
'			resno1						= 주민등록번호 앞자리
'			resno2						= 주민등록번호 뒷자리
'	Return				: Boolean
'	Description		: 주민등록번호 유효성 확인
' ######################################################################
	Function checkResNo(ByVal resno1, ByVal resno2)
		Dim resno
		Dim sKey, arrSKey
		Dim total, result
		Dim f

		checkResNo = False

		total = 0
		resno = resno1 & resno2

		If Len(resno) <> 13 Then Exit Function

		sKey = "2,3,4,5,6,7,8,9,2,3,4,5,"
		arrSKey = Split(sKey, ",")

		For f=1 To 12
			total = total + (CInt(Mid(resno, f, 1)) * CInt(arrSKey(f - 1)))
		Next

		result = (11 - (total Mod 11)) Mod 10

		If CStr(result) = Mid(resno, 13, 1) Then checkResNo = True
	End Function


	' *****************************************************************************
	'	Function name	: eRegiReplace
	'	Description		: 문자열 정규식 Replace
	' *****************************************************************************
		Function eRegiReplace(ByVal value, ByVal pattern, ByVal replacement)
			Dim objRegExp
			Set objRegExp = New RegExp

			objRegExp.Pattern = pattern
			objRegExp.IgnoreCase = True	 		' 대/소문자를 구분하지 않도록 함
			objRegExp.Global = True					' 문자열 전체에서 검색

			eRegiReplace = objRegExp.Replace(value, replacement)
			Set objRegExp = Nothing
		End Function




	' *****************************************************************************
	'	Function name	: rejectIjt
	'	Description		: Injection 방지 (Single Quote 변환 제외 : convSql 함수 이용)
	' *****************************************************************************
		Function rejectIjt(ByVal value)
			'value = eRegiReplace(value, ";", "&#59;")
			'value = eRegiReplace(value, "'", "&#39;")
			value = eRegiReplace(value, "--", "")
			value = eRegiReplace(value, "[[]", "&#91;")
			value = eRegiReplace(value, "[]]", "&#93;")
			'value = eRegiReplace(value, """", "&#34;")
			value = eRegiReplace(value, "select ", "")
			value = eRegiReplace(value, "union ", "")
			value = eRegiReplace(value, "insert ", "")
			value = eRegiReplace(value, "update ", "")
			value = eRegiReplace(value, "delete ", "")
			value = eRegiReplace(value, "create ", "")
			value = eRegiReplace(value, "alter ", "")
			value = eRegiReplace(value, "drop ", "")
			value = eRegiReplace(value, "exec ", "")
			value = eRegiReplace(value, "execute ", "")
			value = eRegiReplace(value, "windows ", "")
			value = eRegiReplace(value, "boot", "")

			'value = eRegiReplace(value, "script ", "")
			value = replace(value, "/* */", "")
			value = replace(value, "or 1=1", "")
			value = replace(value, "on error resume", "")
			value = replace(value, "../", "")
			value = replace(value, "unexisting", "")
			value = replace(value, "win.ini", "")
			rejectIjt  = value
		End Function

' *****************************************************************************
'	Function name	: convSql
'	Description		: Injection 방어용 치환자 설정
' *****************************************************************************
	Function convSql(ByVal value)
		If IsNull(value) Then value = ""

		value = Replace(value,"&","&amp;")
		value = Replace(value,"#","&#35;")
		value = Replace(value,"""","&amp;quot;")
		value = Replace(value,"'","&#39;")
		value = Replace(value,"""","&#34;")
		value = Replace(value,">","&amp;gt;")
		value = Replace(value,"<","&amp;lt;")
		value = Replace(value,"\r", "")
		value = Replace(value,"\n", "")
		value = Replace(value,vbcrlf, "<br />")
		value = Replace(value,chr(13)&chr(10), "<br />")

		value = rejectIjt(value)
		convSql = value
	End Function

' *****************************************************************************
'	Function name	: backword, backword_title
'	Description		: DB데이터 글자 역치환
' *****************************************************************************
		Function backword(s)
			s = Trim(s)
			If Not s = "" Or Not IsNull(s) Then
				's = Replace(s, "&#59;", ";")
				s = Replace(s, "&#35;", "#")
				s = Replace(s, "&#39;", "'")
				s = Replace(s, "&#34;", """")
				s = Replace(s, "&quot;", """")
				s = Replace(s, "&#38;", "&")
				s = Replace(s, "&#40;", "(")
				s = Replace(s, "&#41;", ")")
				s = Replace(s, "&lt;", "<" )
				s = Replace(s, "&gt;", ">")
				s = Replace(s, "&#91;", "[")
				s = Replace(s, "&#93;", "]")
				s = Replace(s, "&amp;", "&")
				s = Replace(s,"<script","&lt;script",1,-1,1)
				s = Replace(s,"</script","&lt;/script",1,-1,1)
			End If
			backword  = s
		End Function

		Function backword_Tag(s)
			s = Trim(s)
			If Not s = "" Or Not IsNull(s) Then
				s = backword(backword(s))
			End If
			backword_Tag  = s
		End Function

		Function backword_Area(s)
			s = Trim(s)
			If Not s = "" Or Not IsNull(s) Then
				s = backword(backword(s))
				s = replace(s, "<br />", vbcrlf,1,-1,1)
				s = replace(s, "<br/>", vbcrlf,1,-1,1)
				s = replace(s, "<br>",  vbcrlf,1,-1,1)
				s = Replace(s, vbcrlf, chr(13)&chr(10),1,-1,1)
			End If
			backword_Area  = s
		End Function

		Function backword_title(s)
			s = Trim(s)
			If Not s = "" Or Not IsNull(s) Then
				s = Replace(s, "&#39;", "'")
				s = Replace(s, "&#34;", """")
				s = Replace(s, "&#38;", "&")
				s = Replace(s, "&#40;", "(")
				s = Replace(s, "&#41;", ")")
				s = Replace(s, "&lt;", "<" )
				s = Replace(s, "&gt;", ">")
				s = Replace(s, "&#91;", "[")
				s = Replace(s, "&#93;", "]")
				s = Replace(s, "&", "&amp;")
			End If
			backword_title  = s
		End Function

		Function backword_br(s)
			s = Trim(s)
			If Not s = "" Or Not IsNull(s) Then
				s = Replace(s, vbcrlf, "")
				s = Replace(s, chr(13)&chr(10), "")
				s = Replace(s, chr(13), "")
				s = Replace(s, chr(10), "")
			End If
			backword_br  = s
		End Function
' *****************************************************************************



	' *****************************************************************************
	'	Function name	: CheckSpace
	'	Description		: 공백 없애기
	' *****************************************************************************
		 Function CheckSpace(CheckValue)
			 CheckValue = trim(CheckValue)                      '양쪽공백을 없애준다.
			 CheckValue = replace(CheckValue, "&nbsp;", "")  '  html &nbsp; <-공백  을  "" <과 같이 붙인다.
			 CheckValue = replace(CheckValue, " ", "")  '  " " <-공백을 "" <- 붙인다.
			 CheckSpace=CheckValue
		 End Function





	' *****************************************************************************
	'	Function name	: cutString
	'	Description		: Byte 체크 후 글자 자름
	' *****************************************************************************
		Function cutString(ByVal value, ByVal cutLen)
			Dim f
			Dim nLen : nLen = 0.00
			Dim result : result = ""
			Dim tmpStr, tmpLen

			If IsNull(value) Then value = ""

			value = value

			For f = 1 To Len(value)
				tmpStr = Mid(value, f, 1)
				tmpLen = Asc(tmpStr)

				If tmpLen < 0 Then ' 한글
					nLen = nLen + 1.4			' 한글일때 길이값 설정
					result = result & tmpStr
				ElseIf tmpLen >= 97 And tmpLen <= 122 Then ' 영문 소문자
					nLen = nLen + 0.75			' 영문소문자 길이값 설정
					result = result & tmpStr
				ElseIf tmpLen >= 65 And tmpLen <= 90 Then ' 영문 대문자
					nLen = nLen + 1				' 영문대문자 길이값 설정
					result = result & tmpStr
				Else ' 그외 키값
					nLen = nLen + 0.6			' 특수문자 기호값...
					result = result & tmpStr
				End If

				If nLen > cutLen Then
					result = result &".."
					Exit For
				End If
			Next

			cutString = result
		End Function
	' *****************************************************************************
	'	Function name	: calcTextLenByte
	'	Description		: Byte 체크 반환
	' *****************************************************************************
		Function calcTextLenByte(ByVal value)
			Dim strByte : strByte = 0

			If value <> "" Then
				strLen = Len(value)

				For csc = 1 To strLen
					tmpChar = ""

					strCut = Mid(value, csc, 1)
					tmpChar = Asc(strCut)
					tmpChar = Left(tmpChar, 1)

					If tmpChar = "-" Then				'"-"이면 2바이트 문자
						strByte = strByte + 2
					Else
						strByte = strByte + 1
					End If
				Next
			End If

			calcTextLenByte = strByte
		End Function

	' *****************************************************************************
	'	Function name	: cutString
	'	Description		: Byte 체크 후 글자 자름
	' *****************************************************************************
		Function calcStringLenByte(ByVal value)
			Dim a,f
			Dim nLen : nLen = 0.00
			Dim result : result = ""
			Dim tmpStr, tmpLen

			If IsNull(value) Then value = ""

			value = value

			For f = 1 To Len(value)
				tmpStr = Mid(value, f, 1)
				tmpLen = Asc(tmpStr)

				If(tmpStr >= "0" And tmpStr <="9") Then
					'nLen = ("0-9")
					nLen = nLen + 1.0		' 숫자일때 길이값 설정
				ElseIf(tmpStr >= "a" And tmpStr <="z") Then
					'nLen = ("영어소")
					nLen = nLen + 1.0			' 영문소문자 길이값 설정
				ElseIf(tmpStr >= "A" And tmpStr <="Z") Then
					'nLen = ("영어대")
					nLen = nLen + 1.5			' 영문대문자 길이값 설정
				ElseIf(tmpStr >= "ㄱ" And tmpStr <="힣") Then
					'nLen = ("한글")
					nLen = nLen + 2			' 한글일때 길이값 설정
				Else
					'nLen = ("기타")
					nLen = nLen + 1.0			' 특수문자 기호값..
				End If
			Next

			calcStringLenByte = nLen
		End Function


		Function cutString2(ByVal value, ByVal cutLen)
			Dim a,f
			Dim nLen : nLen = 0.00
			Dim result : result = ""
			Dim tmpStr, tmpLen

			If IsNull(value) Then value = ""

			value = value

			For f = 1 To Len(value)
				tmpStr = Mid(value, f, 1)
				tmpLen = Asc(tmpStr)

				If(tmpStr >= "0" And tmpStr <="9") Then
					'nLen = ("0-9")
					nLen = nLen + 1.0		' 숫자일때 길이값 설정
					result = result & tmpStr
				ElseIf(tmpStr >= "a" And tmpStr <="z") Then
					'nLen = ("영어소")
					nLen = nLen + 1.0			' 영문소문자 길이값 설정
					result = result & tmpStr
				ElseIf(tmpStr >= "A" And tmpStr <="Z") Then
					'nLen = ("영어대")
					nLen = nLen + 1.5			' 영문대문자 길이값 설정
					result = result & tmpStr
				ElseIf(tmpStr >= "ㄱ" And tmpStr <="힣") Then
					'nLen = ("한글")
					nLen = nLen + 2			' 한글일때 길이값 설정
					result = result & tmpStr
				Else
					'nLen = ("기타")
					nLen = nLen + 1.0			' 특수문자 기호값..
					result = result & tmpStr
				End If
				If nLen > cutLen Then
					result = result &".."
					Exit For
				End If
			Next



			cutString2 = result
		End Function

	' *****************************************************************************
	' Function Name		: isSelect
	' Discription		: 셀렉트 박스 셀렉트 확인용
	' *****************************************************************************
		Function isSelect(ByVal value, ByVal selected)
			isSelect = ""
			If UCase(value) = UCase(selected)  Then isSelect = " selected='selected'"
		End Function

	' *****************************************************************************
	' Function Name		: isChecked
	' Discription		: 인풋의 라디오나 체크박스등에 체크가 있는지 없는지 체크
	' *****************************************************************************
		Function isChecked(ByVal named, ByVal checked)
			isChecked = ""
			If UCase(named) = UCase(checked) Then isChecked = " checked='checked'"
		End Function

	' *****************************************************************************
	' Function Name		: checkRef
	' Discription		: 이동페이지가 지정된 페이지가 아니면 에러 출력
	' *****************************************************************************
		Function checkRef(ByVal pageUrl)
			Dim referer : referer = Request.ServerVariables("HTTP_REFERER")
			Dim result : result = False

			pageUrl = Replace(pageUrl, "https://", "")
			pageUrl = Replace(pageUrl, "http://", "")
			referer = Replace(referer, "https://", "")
			referer = Replace(referer, "http://", "")

			'Call ResRw(pageUrl,"서버")
			'Call ResRw(referer,"호스트")

			arrReferer = Split(referer, "?")
			If UBound(arrReferer) > -1 Then
				If Trim(arrReferer(0)) = Trim(pageUrl) Then result = True
			End If

			checkRef = result
		End Function

	' *****************************************************************************
	' Function Name		: getUserIP
	' Discription		: 유저 접속 아이피 확인 (아이피 체크)
	' *****************************************************************************
		Function getUserIP()
			Dim httpXForwardedFor, remoteAddr
			Dim result

			httpXForwardedFor = Request.ServerVariables("HTTP_X_FORWARDED_FOR")
			remoteAddr = Request.ServerVariables("REMOTE_ADDR")

			If httpXForwardedFor = "" OR InStr(httpXForwardedFor, "unknown") > 0 Then
				result = remoteAddr
			ElseIf InStr(httpXForwardedFor, ",") > 0 Then
				result = Mid(httpXForwardedFor, 1, InStr(httpXForwardedFor, ",")-1)
			ElseIf InStr(httpXForwardedFor, ";") > 0 Then
				result = Mid(httpXForwardedFor, 1, InStr(httpXForwardedFor, ";")-1)
			Else
				result = httpXForwardedFor
			End If

			getUserIP = Trim(Mid(result, 1, 30))
		End Function


	' *****************************************************************************
	' Function Name		: EmailCheck
	' Discription		: 이메일 형식 (이메일 형식 체크)
	' *****************************************************************************

		Function EmailCheck(ByVal stremail)
			emailpattern = "^[\w-\.]{1,}\@([\da-zA-Z-]{1,}\.){1,}[\da-zA-Z-]{2,3}$"
			If stremail = "" Then
				RegExpEmail = False
			Else
				Dim regEx, Matches
				Set regEx = New RegExp
				regEx.Pattern = emailpattern
				regEx.IgnoreCase = True
				regEx.Global = True
				Set Matches = regEx.Execute(stremail)

				If 0 < Matches.count Then
					EmailCheck = True
				Else
					EmailCheck = False
				End If
			End If
		End Function


		Public Function RegExpReplace2(Patrn, TrgtStr, RplcStr)
			Dim ObjRegExp
			On Error Resume Next

			Set ObjRegExp = New RegExp
				ObjRegExp.Pattern = Patrn
				ObjRegExp.Global = True
				ObjRegExp.IgnoreCase = True
				RegExpReplace2 = ObjRegExp.Replace(TrgtStr, RplcStr)
			Set ObjRegExp = Nothing

		End Function


	' *****************************************************************************
	'	Function name	: checkDataImages
	'	Description		: 문자형 이미지 체크(base64)
	' *****************************************************************************
		Function checkDataImages(ByRef value)
			checkDataImages = False
			valChk1 = InStr(LCase(value),"data:image")
			valChk1 = InStr(LCase(value),"base64")
			IF CDbl(valChk1) + CDbl(valChk2) > 1 Then
				checkDataImages = True
			End IF
		End Function

%>
<%
	'pv 보임 설정
	PV_VIEW_TF = ""
	BV_VIEW_TF = ""
	If (DK_MEMBER_TYPE = "COMPANY" And DK_MEMBER_STYPE = "0") Or DK_MEMBER_TYPE = "ADMIN" Then
		PV_VIEW_TF = "T"
		BV_VIEW_TF = "F"
	End IF
%>