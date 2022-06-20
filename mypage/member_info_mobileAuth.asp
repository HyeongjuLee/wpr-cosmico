<%
	'본인회원정보 - 휴대폰인증 / 수정

	'*************************************************************************************************************

		'NICE평가정보 Copyright(c) KOREA INFOMATION SERVICE INC. ALL RIGHTS RESERVED

		'서비스명 :  체크플러스 - 안심본인인증 서비스
		'페이지명 :  체크플러스 - 메인 호출 페이지
		'보안을 위해 제공해드리는 샘플페이지는 서비스 적용 후 서버에서 삭제해 주시기 바랍니다.

	'*************************************************************************************************************

		Dim clsCPClient
		Dim iRtn, sEncData, sPlainData
		Dim sRequestNO, sSiteCode, sSitePassword , sReturnUrl , sErrorUrl, popgubun, GENDER

		SET clsCPClient  = SERVER.CREATEOBJECT("CPClient.Kisinfo")

		sSiteCode       = NICE_MOBILE_AUTH_ID		'NICE로부터 부여받은 사이트 코드
		sSitePassword   = NICE_MOBILE_AUTH_PWD		'NICE로부터 부여받은 사이트 패스워드

		sAuthType = "M"				'없으면 기본 선택화면, M: 핸드폰, C: 카드, X: 공인인증서

		popgubun 	= "N"			'Y : 취소버튼 있음, N : 취소버튼 없음

		sGender = "" 				'없으면 기본 선택 값, 0 : 여자, 1 : 남자

		'CheckPlus(본인인증) 처리 후, 결과 데이타를 리턴 받기위해 다음예제와 같이 http부터 입력합니다.
		'리턴url은 인증 전 인증페이지를 호출하기 전 url과 동일해야 합니다. ex) 인증 전 url : http://www.~ 리턴 url : http://www.~
		sReturnUrl	= NICE_MOBILE_AUTH_URL&"/changeAuth_s.asp?stype=m"	'성공시 이동될 URL										style = [MODIFY]
		sErrorUrl	= NICE_MOBILE_AUTH_URL&"/changeAuth_f.asp"			'실패시 이동될 URL

		'sRequestNO = makeOrderNo()'"REQ0000000001"			'요청 번호, 이는 성공/실패후에 같은 값으로 되돌려주게 되므로
											'업체에 적절하게 변경하여 쓰거나, 아래와 같이 생성한다.
		iRtn = clsCPClient.fnRequestNO(sSiteCode)

		'Call ResRW(sRequestNO,"sRequestNO")

		IF iRtn = 0 THEN
			sRequestNO = clsCPClient.bstrRandomRequestNO
			session("REQ_SEQ") = sRequestNO		'해킹등의 방지를 위하여 세션을 사용한다면, 세션에 요청번호를 넣는다.
			session("MO_CHECK") = ""			'only Mobile(MOBILEAUTH 분기)
		END IF
		'Call ResRW(sRequestNO,"sRequestNO")
		'Call ResRW(iRtn,"iRtn")
		'PRINT sRequestNO & " <br />"
		sPlainData = fnGenPlainData(sRequestNO, sSiteCode, sAuthType, sReturnUrl, sErrorUrl, popgubun, sGender)

		'실제적인 암호화
		iRtn = clsCPClient.fnEncode(sSiteCode, sSitePassword, sPlainData)

		IF iRtn = 0 THEN
			sEncData = clsCPClient.bstrCipherData
		ELSE
			RESPONSE.WRITE "요청정보_암호화_오류:" & iRtn & "<br>"
			' -1 : 암호화 시스템 에러입니다.
			' -2 : 암호화 처리오류입니다.
			' -3 : 암호화 데이터 오류입니다.
			' -4 : 입력 데이터 오류입니다.
		END IF

		Set clsCPClient = Nothing
	'**************************************************************************************
	'문자열 생성
	'**************************************************************************************
	Function fnGenPlainData(aRequestNO, aSiteCode, aAuthType, aReturnUrl, aErrorUrl, popgubun, GENDER)

		'입력 파라미터로 plaindata 생성
		retPlainData  = "7:REQ_SEQ" & fnGetDataLength(aRequestNO) & ":" & aRequestNO & _
						"8:SITECODE" & fnGetDataLength(aSiteCode) & ":" & aSiteCode & _
						"9:AUTH_TYPE" & fnGetDataLength(aAuthType) & ":" & aAuthType & _
						"7:RTN_URL" & fnGetDataLength(aReturnUrl) & ":" & aReturnUrl & _
						"7:ERR_URL" & fnGetDataLength(aErrorUrl) & ":" & aErrorUrl	& _
						"11:POPUP_GUBUN" & fnGetDataLength(popgubun) & ":" & popgubun & _
						"6:GENDER" & fnGetDataLength(sGender) & ":" & sGender
		fnGenPlainData = retPlainData

	End Function

	'**************************************************************************************
	'입력파라미터의 문자열길이 추출
	'**************************************************************************************
	Function fnGetDataLength(aData)
		Dim iData_len
		if (len(aData) > 0) then
			for i = 1 to len(aData)
				if (ASC(mid(aData,i,1)) < 0) then	'한글인경우
					iData_len = iData_len + 2
				else			'한글이아닌경우
					iData_len = iData_len + 1
				end if
			next
		else
			iData_len = 0
		end if

		fnGetDataLength = iData_len
	End Function
%>
<script>
	function fnAuthPhone(){
		window.open('', 'popupChk', 'width=500, height=550, top=100, left=100, fullscreen=no, menubar=no, status=no, toolbar=no, titlebar=yes, location=no, scrollbar=no');
		document.form_chk.action = "https://nice.checkplus.co.kr/CheckPlusSafeModel/checkplus.cb";
		document.form_chk.target = "popupChk";
		document.form_chk.submit();
	}
</script>
