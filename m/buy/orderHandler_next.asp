<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_inc/document.asp"-->
</head>
<body>
<%
	Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"

	Dim P_STATUS		: P_STATUS		= Trim(Request.Form("P_STATUS"))
	Dim P_TID			: P_TID			= Trim(Request.Form("P_TID"))
	Dim P_TYPE			: P_TYPE		= Trim(Request.Form("P_TYPE"))
	Dim P_RMESG1		: P_RMESG1		= Trim(Request.Form("P_RMESG1"))
	Dim P_REQ_URL		: P_REQ_URL		= Trim(Request.Form("P_REQ_URL"))
	Dim P_NOTI			: P_NOTI		= Trim(Request.Form("P_NOTI"))
'	Dim P_MID			: P_MID			= "llife365co"
	Dim P_MID			: P_MID			= "healthyli4"


'	P_STATUS = Request("P_STATUS")
'	P_RMESG1 = Request("P_RMESG1")
'	P_TID = Request("P_TID")
'	P_REQ_URL = Request("P_REQ_URL")
'	P_MID = "INIpayTest"
'	P_NOTI = Request("P_NOTI")
'	P_MID = "llife365co"






	P_REQ_URL = Request("P_REQ_URL")
'	Response.WRITE P_STATUS
'	Response.WRITE P_STATUS
'	Response.WRITE P_MID
'	Response.Write P_RMESG1
'	Response.Write unescape(P_RMESG1)
IF(P_STATUS = "00") THEN  '인증성공시
	'Response.write P_STATUS
	'statusTxt = "11"
	Call startAction(statusTxt) '이니시스 승인요청
'	Response.Write statusTxt

	P_STATUS_SPLIT = Split(statusTxt,"&")
	P_STATUS_UBOUND = Ubound(P_STATUS_SPLIT)
	For i = 0 To P_STATUS_UBOUND
		P_STATUS_CONTENT = Split(P_STATUS_SPLIT(i),"=")
		' 순차 미적용 사유 : 정확한 데이터를 위해서 SPLIT 앞의 필드명을 재차확인한다.
		If P_STATUS_CONTENT(0) = "P_STATUS"				Then RETURN_P_STATUS			 = P_STATUS_CONTENT(1) ' 에러 상태
		If P_STATUS_CONTENT(0) = "P_AUTH_DT"			Then RETURN_P_AUTH_DT			 = P_STATUS_CONTENT(1) ' 승일일자
		If P_STATUS_CONTENT(0) = "P_AUTH_NO"			Then RETURN_P_AUTH_NO			 = P_STATUS_CONTENT(1) ' 승인번호
		If P_STATUS_CONTENT(0) = "P_RMESG1"				Then RETURN_P_RMESG1			 = P_STATUS_CONTENT(1) ' 지불결과메세지
		If P_STATUS_CONTENT(0) = "P_RMESG2"				Then RETURN_P_RMESG2			 = P_STATUS_CONTENT(1) ' 신용카드 할부 개월
		If P_STATUS_CONTENT(0) = "P_TID"				Then RETURN_P_TID				 = P_STATUS_CONTENT(1) ' 거래번호 (이니시스)
		If P_STATUS_CONTENT(0) = "P_FN_CD1"				Then RETURN_P_FN_CD1			 = P_STATUS_CONTENT(1) ' 카드코드
		If P_STATUS_CONTENT(0) = "P_AMT"				Then RETURN_P_AMT				 = P_STATUS_CONTENT(1) ' 거래금액
		If P_STATUS_CONTENT(0) = "P_TYPE"				Then RETURN_P_TYPE				 = P_STATUS_CONTENT(1) ' 지불수단 (ISP,CARD,VBANK)
		If P_STATUS_CONTENT(0) = "P_UNAME"				Then RETURN_P_UNAME				 = P_STATUS_CONTENT(1) ' 주문자명
		If P_STATUS_CONTENT(0) = "P_MID"				Then RETURN_P_MID				 = P_STATUS_CONTENT(1) ' 상점아이디
		If P_STATUS_CONTENT(0) = "P_OID"				Then RETURN_P_OID				 = P_STATUS_CONTENT(1) ' 상점주문번호 (고객사측)
		If P_STATUS_CONTENT(0) = "P_NOTI"				Then RETURN_P_NOTI				 = P_STATUS_CONTENT(1) ' 주문정보 (개별입력값)
		If P_STATUS_CONTENT(0) = "P_NEXT_URL"			Then RETURN_P_NEXT_URL			 = P_STATUS_CONTENT(1) ' NEXT URL 값
		If P_STATUS_CONTENT(0) = "P_MNAME"				Then RETURN_P_MNAME				 = P_STATUS_CONTENT(1) ' 쇼핑몰명
		If P_STATUS_CONTENT(0) = "P_NOTEURL"			Then RETURN_P_NOTEURL			 = P_STATUS_CONTENT(1) ' NOTI URL 값
		If P_STATUS_CONTENT(0) = "P_CARD_MEMBER_NUM"	Then RETURN_P_CARD_MEMBER_NUM	 = P_STATUS_CONTENT(1) ' 가맹점번호 (자체가맹점)
		If P_STATUS_CONTENT(0) = "P_CARD_NUM"			Then RETURN_P_CARD_NUM			 = P_STATUS_CONTENT(1) ' 카드번호
		If P_STATUS_CONTENT(0) = "P_CARD_ISSUER_CODE"	Then RETURN_P_CARD_ISSUER_CODE	 = P_STATUS_CONTENT(1) ' 발급사코드
		If P_STATUS_CONTENT(0) = "P_CARD_PURCHASE_CODE"	Then RETURN_P_CARD_PURCHASE_CODE = P_STATUS_CONTENT(1) ' 매입사코드 (자체가맹점)
		If P_STATUS_CONTENT(0) = "P_CARD_PRTC_CODE"		Then RETURN_P_CARD_PRTC_CODE	 = P_STATUS_CONTENT(1) ' 부분취소 가능여부 (1:가능, 0:불가능)
		If P_STATUS_CONTENT(0) = "P_CARD_INTEREST"		Then RETURN_P_CARD_INTEREST		 = P_STATUS_CONTENT(1) ' ? 무이자로 예상
		If P_STATUS_CONTENT(0) = "P_CARD_CHECKFLAG"		Then RETURN_P_CARD_CHECKFLAG	 = P_STATUS_CONTENT(1) ' ?
	Next

	Call ResRW(RETURN_P_STATUS								,"RETURN_P_STATUS				")
	Call ResRW(RETURN_P_AUTH_DT								,"RETURN_P_AUTH_DT				")
	Call ResRW(RETURN_P_AUTH_NO								,"RETURN_P_AUTH_NO				")
	Call ResRW(RETURN_P_RMESG1								,"RETURN_P_RMESG1				")
	Call ResRW(RETURN_P_RMESG2								,"RETURN_P_RMESG2				")
	Call ResRW(RETURN_P_TID									,"RETURN_P_TID					")
	Call ResRW(RETURN_P_FN_CD1								,"RETURN_P_FN_CD1				")
	Call ResRW(RETURN_P_AMT									,"RETURN_P_AMT					")
	Call ResRW(RETURN_P_TYPE								,"RETURN_P_TYPE					")
	Call ResRW(RETURN_P_UNAME								,"RETURN_P_UNAME				")
	Call ResRW(RETURN_P_MID									,"RETURN_P_MID					")
	Call ResRW(RETURN_P_OID									,"RETURN_P_OID					")
	Call ResRW(RETURN_P_NOTI								,"RETURN_P_NOTI					")
	Call ResRW(RETURN_P_NEXT_URL							,"RETURN_P_NEXT_URL				")
	Call ResRW(RETURN_P_MNAME								,"RETURN_P_MNAME				")
	Call ResRW(RETURN_P_NOTEURL								,"RETURN_P_NOTEURL				")
	Call ResRW(RETURN_P_CARD_MEMBER_NUM						,"RETURN_P_CARD_MEMBER_NUM		")
	Call ResRW(RETURN_P_CARD_NUM							,"RETURN_P_CARD_NUM				")
	Call ResRW(RETURN_P_CARD_ISSUER_CODE					,"RETURN_P_CARD_ISSUER_CODE		")
	Call ResRW(RETURN_P_CARD_PURCHASE_CODE					,"RETURN_P_CARD_PURCHASE_CODE	")
	Call ResRW(RETURN_P_CARD_PRTC_CODE						,"RETURN_P_CARD_PRTC_CODE		")
	Call ResRW(RETURN_P_CARD_INTEREST						,"RETURN_P_CARD_INTEREST		")
	Call ResRW(RETURN_P_CARD_CHECKFLAG						,"RETURN_P_CARD_CHECKFLAG		")


	If RETURN_P_STATUS = "00" Then


		nowTime = Now
		RegTime = Right("0000"&Year(nowTime),4) & Right("00"&Month(nowTime),2) & Right("00"&Day(nowTime),2)
		Recordtime = Left(nowTime,10) & " "& Right("00"&Hour(nowTime),2) &":"&Right("00"&Minute(nowTime),2) &":"&Right("00"&Second(nowTime),2)
		v_C_Etc = RETURN_P_CARD_ISSUER_CODE &"/"&RETURN_P_RMESG2&"/"&RETURN_P_OID


		arrParams = Array(_
			Db.makeParam("@OrderNum",adVarChar,adParamInput,20,RETURN_P_OID),_
			Db.makeParam("@v_SellDAte",adVarChar,adParamInput,10,RegTime),_

			Db.makeParam("@v_Etc1",adVarWChar,adParamInput,250,v_C_Etc),_
			Db.makeParam("@v_Etc2",adVarWChar,adParamInput,250,"웹주문번호:"&RETURN_P_OID),_

			Db.makeParam("@v_C_CodeName",adVarChar,adParamInput,50,RETURN_P_CARD_ISSUER_CODE),_
			Db.makeParam("@v_C_Number1",adVarChar,adParamInput,50,RETURN_P_CARD_NUM),_
			Db.makeParam("@v_C_Number2",adVarChar,adParamInput,20,RETURN_P_AUTH_NO),_
			Db.makeParam("@v_C_Name1",adVarWChar,adParamInput,50,RETURN_P_UNAME),_
			Db.makeParam("@v_C_Name2",adVarWChar,adParamInput,50,""),_

			Db.makeParam("@v_C_Period1",adVarChar,adParamInput,4,""),_
			Db.makeParam("@v_C_Period2",adVarChar,adParamInput,2,""),_
			Db.makeParam("@v_C_Installment_Period",adVarChar,adParamInput,10,RETURN_P_RMESG2),_
			Db.makeParam("@v_C_Etc",adVarWChar,adParamInput,50,v_C_Etc),_

			Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
		)
		Call Db.exec("DKP_ORDER_TOTAL",DB_PROC,arrParams,DB3)
		OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)

	Else
		'Call ALERTS("PG결제 인증에 실패하였습니다. 오류 : &"RETURN_P_STATUS&"(&"RETURN_P_RMESG1&")","CLOSE","")
	End If

'	Response.WRITE RETURN_P_STATUS



Else      '인증실패시

	Call ALERTS("PG결제 인증에 실패하였습니다","CLOSE","")

End IF





Function startAction(ByRef statusTxt)


	postdata = "P_MID=" & P_MID & "&P_TID=" & P_TID

	On Error Resume Next

	Set xmlHttp = CreateObject("Msxml2.XMLHTTP")

	url = P_REQ_URL

	xmlHttp.open "post",url, False
	xmlHttp.setRequestHeader "Connection", "close"
	xmlHttp.setRequestHeader "Content-Length", Len(postdata)
	xmlHttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded;charset=euc_kr"
	xmlHttp.Send postdata	'post data send




	statusText = xmlHttp.responseBody  '응답 결과메시지(binary data)
	statusTxt = BinaryToText(statusText, "euc-kr")
'	Response.Write(statusTxt)
'	Response.binaryWrite(statusText)   'binary 데이터를 직접 출력


	'Response.Write("<br><br><br><br><br><br>")


	'strData = BinaryToText(statusText, "euc-kr") ' binary data 를 string으로 변환


	'Response.Write(strData)   'string으로 변환한 결과전문 출력


	Set xmlHttp = nothing

End Function




'바이너리 데이터를 원하는 캐릭터셋으로 변환해주는 함수



Function BinaryToText(BinaryData, CharSet)
	Const adTypeText = 2
	Const adTypeBinary = 1

	Dim BinaryStream
	Set BinaryStream = CreateObject("ADODB.Stream")

	'원본 데이터 타입
	BinaryStream.Type = adTypeBinary
	BinaryStream.Open
	BinaryStream.Write BinaryData

	  ' binary -> text
	BinaryStream.Position = 0
	BinaryStream.Type = adTypeText

	' 변환할 데이터 캐릭터셋
	BinaryStream.CharSet = CharSet

	'변환한 데이터 반환
	BinaryToText = BinaryStream.ReadText
End Function


%>