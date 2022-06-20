<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual="/_lib/json2.asp" -->
<%
	Call ONLY_MEMBER(DK_MEMBER_LEVEL)

'http://starcnb.webpro.kr/PG/YESPAY/cancels.asp
Response.end
Response.end

	Dim PGID				: PGID = "181817"		'(스타CNB 181817, 2020-11-10~)
	Dim PGorderNum			: PGorderNum = "20111121281416001391"				 'OrderID
	Dim totalPrice			: totalPrice = "1180"
	Dim orderNum			: orderNum = "DK203167722670_2" '우리 주문번호

	cXmlParam = ""
	cXmlParam = cXmlParam & "orgOrderNo="&PGorderNum		'pg주문번호
	cXmlParam = cXmlParam & "&orgPayAmount="&totalPrice		'결제금액
	cXmlParam = cXmlParam & "&orgComOrderNo="&orderNum		'업체주문번호
	cXmlParam = cXmlParam & "&memManageNo="&PGID			'
	cXmlParam = cXmlParam & "&receiveType=json"				'결과 return 방식 json, xml, url
	cXmlParam = cXmlParam & "&receiveUrl="					'결과를 url 로 전송받을 경우 결과를 받을 주소입니다. http://를 포함한 full 주소를 입력하세요
	cXmlParam = cXmlParam & "&sendSMS=N"					'결제성공시 구매자휴대폰 번호로 SMS 발신여부 'Y' or 'N' ,  기본 발송안함

	cXmlURL = "http://yespay.kr/extLink/requestCancel_utf8.asp"

	set cXmlhttp = Server.CreateObject("Msxml2.ServerXMLHTTP")

		cXmlhttp.setOption 2, 13056
		cXmlhttp.open "POST", cXmlURL, False
		cXmlhttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded;charset=UTF-8"
		cXmlhttp.setRequestHeader "Accept-Language","UTF-8"
		cXmlhttp.setRequestHeader "CharSet", "UTF-8"
		cXmlhttp.setRequestHeader "Content", "text/html;charset=UTF-8"
		cXmlhttp.setRequestHeader "Content-Length", Len(cXmlParam)
		cXmlhttp.send cXmlParam

		cResponse = cXmlhttp.responseText
		cXmlStatus = cXmlhttp.status

	Set cXmlhttp = Nothing '개체 소멸


	print cResponse&"<br />"



	Dim cInfo : Set cInfo = JSON.parse(Join(Array(cResponse)))

	'print cXmlStatus
	If cXmlStatus >= 400 And cXmlStatus <= 599 Then
		'dim Info : set Info = JSON.parse(join(array(postData)))
		errorMsg = cInfo.resMessage
		PRINT errorMsg&"<br />"
		Response.Write "<script type='text/javascript'>"
		Response.Write "alert('PG 결제취소 연결에 문제가 발생했습니다.1 \n\n에러내용은 : "&errorMsg&" 입니다');"
		'Response.Write "history.back();"
	'	Response.Write "location.href="""&chgPage&"/shop"";"
		Response.Write "</script>"
	Else

		pg_success = cInfo.resCode
		errorMsg   = cInfo.resMessage

		'로그기록생성 4
		Dim Fso4 : Set  Fso4=CreateObject("Scripting.FileSystemObject")
		Dim LogPath4 : LogPath4 = Server.MapPath("cardCancel/adminCResult_") & Replace(Date(),"-","") & ".log"
		Dim Sfile4 : Set  Sfile4 = Fso4.OpenTextFile(LogPath4,8,true)

		Sfile4.WriteLine chr(13)
		Sfile4.WriteLine "Date : " & now()
		Sfile4.WriteLine "Domain : " & Request.ServerVariables("HTTP_HOST")
		Sfile4.WriteLine "THIS_PAGE_URL	: " & Request.ServerVariables("URL")
		Sfile4.WriteLine "--- Card REFUND(ADMIN_CANCEL) --------------------"
		Sfile4.WriteLine "PGID	: " & PGID
		Sfile4.WriteLine "getUserIP	: " & getUserIP
		Sfile4.WriteLine "cXmlStatus	: " & cXmlStatus
		Sfile4.WriteLine "cResponse	: " &Replace(Replace(cResponse,"	",""),vbCrLf,"")

		If LCase(pg_success) <> "00" Then
			'PRINT "결제취소 오류"
			Sfile4.WriteLine "cancelMsg	: 결제가 취소 되지 않았습니다. 관리자에게 문의해주세요."
			'Sfile4.WriteLine "cancelMsg	: 결제가 실패하였습니다. 결제가 취소 되지 않았습니다. 관리자에게 문의해주세요."
			'Call ALERTS("결제가 실패하였습니다. 결제가 취소 되지 않았습니다. 관리자에게 문의해주세요.","BACK","")
		Else
			Sfile4.WriteLine "cancelMsg	: 결제가 취소되었습니다. 결제가 취소 되지 않은 경우 관리자에게 문의해주세요."
			'Sfile4.WriteLine "cancelMsg	: 결제가 실패하였습니다. 결제가 취소되었습니다. 결제가 취소 되지 않은 경우 관리자에게 문의해주세요."
			'Call ALERTS("결제가 실패하였습니다. 결제가 취소되었습니다. 결제가 취소 되지 않은 경우 관리자에게 문의해주세요.","BACK","")
		End If

		Sfile4.WriteLine chr(13)
		Sfile4.Close
		Set Fso4= Nothing
	End If
%>