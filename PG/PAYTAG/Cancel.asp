<%@Language="VBScript" CODEPAGE=65001%>
<%
	' Turn off error Handling
	On Error Resume Next

	Response.CharSet="utf-8"
	Session.codepage="65001"
	Response.codepage="65001"
	Response.ContentType="text/html;charset=UTF-8"
%>

<%
	TX_PAYTAG_shopcode	= Request.Form("TX_PAYTAG_shopcode")	'페이태그 가맹점 번호
	TX_PAYTAG_loginid	= Request.Form("TX_PAYTAG_loginid")		'가맹점 로그인ID
	TX_PAYTAG_api_key	= Request.Form("TX_PAYTAG_api_key")		'가맹점 암호화 키값
	recv_orderno		= Request.Form("recv_orderno")			'페이태그 거래번호
	recv_trandate		= Request.Form("recv_trandate")			'원거래 승인일자 ( YYYYMMDD )
	recv_tran_amt		= Request.Form("recv_tran_amt")			'원거래 승인금액
%>
<%
	servicecode     =   "PAYTAG"        '   필수 : 고정값
	reqtype			=   "L"             '   필수 : 'L'-API연동 고정값
	restype			=   "J"             '   필수 : 'J'-JSON 결과 리턴
	cmdtype         =   "CARDCANCEL"    '   필수 : 고정값
	pay_method		=   "C"             '   필수 : 고정값
	paytag_apiurl	=   "https://api.paytag.kr/pay/cardcancel"       ' 필수 : 고정값 ( rest 주소값 )

	' ========================================
	' 페이태그로 부터 부여받은 값
	' ----------------------------------------
	 shopcode        =   TX_PAYTAG_shopcode		'   필수 : 페이태그 가맹점 번호

		' 본사권한으로 실행 ! - 대리점에 관계없이 취소실행 가능
		'loginid			=   ""					'  필수 : 로그인ID
		'loginpwd			=   ""					'  blank
		'api_key			=   ""					'  필수 : 암호화 키값
		'reqLink			=   ""					'


	' 가맹점권한으로 결제취소 실행시는
	 loginid         =   TX_PAYTAG_loginid		'	필수 : 가맹점 로그인ID
	 loginpwd        =   ""						'	blank
	 api_key         =   TX_PAYTAG_api_key		'	필수 : 가맹점 암호화 키값
	 reqLink         =   ""


	' ========================================
	' 취소정보
	' ----------------------------------------
	orderno				=   recv_orderno	'   필수 : 페이태그 거래번호
	orgpaydate			=   recv_trandate	'   필수 : 원거래 승인일자 ( YYYYMMDD )
	orgtranamt			=   recv_tran_amt	'   팔수 : 원거래 승인금액
	canceltype			=   "0"             '   필수 : 0-전체잔액취소 / 1-부분취소
	req_cancelamt		=   recv_tran_amt	'   필수 : 취소희망금액


	' ========================================
	' 가맹점 자체값
	' ----------------------------------------
	shop_field1     =   ""              '   선택 : 예비필드1
	shop_field2     =   ""              '   선택 : 예비필드2
	shop_field3     =   ""              '   선택 : 예비필드3



	' ========================================
	' 보안인증값생성
	' 가맹점마다의 key값으로 암호화 한다.
	' ----------------------------------------
	cert_str =  servicecode & "|" & _
					cmdtype & "|" & _
					shopcode & "|" & _
					loginid & "|" & _
					loginpwd & "|" & _
					orderno & "|" & _
					req_cancelamt


	' ######################################################################
	' AES256 암/복호화 DLL
	' ######################################################################
	set aesCom = server.createobject("PayTagCom.EncryptDecrypt")
	certval = aesCom.Aes256Encrypt(cert_str, api_key)

	if Err.Number <> 0 then
		Err.Raise 9999, "error", err.description
		call onErrorCheckDefault()
	end if


	' ========================================
	' header 파라메터 정의
	' -------------------------------------------------------------------
	REQ_HEADER_STR  = "servicecode=" & servicecode & _
					"&reqtype=" & reqtype & _
					"&restype=" & restype & _
					"&shopcode=" & shopcode & _
					"&apiver=1" & _
					"&cmdtype=" & cmdtype & _
					"&certval=" & server.urlencode(certval)


	' ========================================
	' body 파라메터 정의
	' -------------------------------------------------------------------
	REQ_BODY_STR =  "orderno=" & orderno & _
					"&orgpaydate=" & server.urlencode(orgpaydate) & _
					"&orgtranamt=" & server.urlencode(orgtranamt) & _
					"&loginid=" & server.urlencode(loginid) & _
					"&reqlink=" & server.urlencode(reqlink) & _
					"&canceltype=" & canceltype & _
					"&cancelamt=" & server.urlencode(req_cancelamt) & _
					"&shop_field1=" & server.urlencode(shop_field1) & _
					"&shop_field2=" & server.urlencode(shop_field2) & _
					"&shop_field3=" & server.urlencode(shop_field3)


	'response.write "body:" & REQ_BODY_STR & "<br>"
%>



<!--#include file="aspJSON1.17.asp" -->


<%
	Set xmlClient = Server.CreateObject("Msxml2.ServerXMLHTTP.6.0")
	xmlClient.setTimeouts 5000, 5000, 30000, 30000

	xmlClient.open "POST", paytag_apiurl, FALSE

	xmlClient.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
	xmlClient.setRequestHeader "CharSet", "UTF-8"
	xmlClient.setRequestHeader "Accept-Language","ko"
	xmlClient.send REQ_HEADER_STR&"&"&REQ_BODY_STR


	' 서버 다운이나.. 없는 도메인일 경우
	If Err.Number = 0 Then

		server_status = xmlClient.Status

		If server_status >= 400 And server_status <= 599 Then

			Err.Raise 1020, "error", "서버오류["&server_status&"]"
			call onErrorCheckDefault()
		else

			Set responseStrm = CreateObject("ADODB.Stream")
			responseStrm.Open
			responseStrm.Position = 0
			responseStrm.Type = 1
			responseStrm.Write xmlClient.responseBody
			responseStrm.Position = 0
			responseStrm.Type = 2
			responseStrm.Charset = "UTF-8"
			resultStr = responseStrm.ReadText

			responseStrm.Close
			Set responseStrm = Nothing

			'response.write resultstr


			Set oJSON = New aspJSON
			oJSON.loadJSON(resultstr)

			recv_resultcode     =  oJSON.data("resultcode")				'결과코드 0000' or '00' 정상
			recv_errmsg         =  oJSON.data("errmsg")					'에러내용(실패시 오류내용)
			recv_orderno        =  oJSON.data("orderno")				'페이태그-주문번호
			recv_orgpaydate     =  oJSON.data("orgtrandate")			'거래일자
			recv_orgtranamt     =  oJSON.data("orgtranamt")				'원거래-승인금액
			recv_goods_name     =  oJSON.data("goods_name")				'원거래-상품명
			recv_loginid        =  oJSON.data("loginid")
			recv_canceltype     =  oJSON.data("canceltype")				'취소type
			recv_cancelamt      =  oJSON.data("cancelamt")				'취소금액
			recv_shop_orderno   =  oJSON.data("shop_orderno")			'원거래-업체주문번호
			recv_shop_member    =  oJSON.data("shop_member")			'원거래-업체회원번호
			recv_shop_field1    =  oJSON.data("shop_field1")			'예비필드1
			recv_shop_field2    =  oJSON.data("shop_field2")
			recv_shop_field3    =  oJSON.data("shop_field3")
			recv_tranno         =  oJSON.data("tranno")
			recv_trandate       =  oJSON.data("trandate")
			recv_trantime       =  oJSON.data("trantime")				'거래시간
			recv_restamt        =  oJSON.data("restamt")				'취소후잔액
			recv_apprno         =  oJSON.data("apprno")					'원거래-승인번호
			recv_transeq        =  oJSON.data("transeq")
			recv_receipt_url    =  oJSON.data("receipt_url")


		End If


	Else
		Err.Raise 9999, "error", err.description
		call onErrorCheckDefault()
	End If

	Set xmlClient = Nothing
%>
<%
	'===========================================================================
	' on error resumt Next 에러 처리 함수
	'===========================================================================
	sub onErrorCheckDefault()
		if err.number <> 0 Then

			errCode     =   err.number
			errMessage  =   err.description
			%>
				{
					"resultcode":"<%=errCode%>",
					"errmsg":"<%=errMessage%>"
				}
			<%
			response.end

		end if
	end sub
%>
<%

	'▣ 로그 기록 S
		On Error Resume Next
			Dim Fso2 : Set  Fso2=CreateObject("Scripting.FileSystemObject")
			Dim LogPath2 : LogPath2 = Server.MapPath ("cardCancel/cancel_") & Replace(Date(),"-","") & ".log"
			Dim Sfile2 : Set  Sfile2 = Fso2.OpenTextFile(LogPath2,8,true)

			Sfile2.WriteLine chr(13)
			Sfile2.WriteLine "--- Card Cancel.asp -------------------------------"
			Sfile2.WriteLine "Date : " & now()
			Sfile2.WriteLine "URL : " & Request.ServerVariables("URL")
			Sfile2.WriteLine "TX_PAYTAG_shopcode : "	& TX_PAYTAG_shopcode
			Sfile2.WriteLine "TX_PAYTAG_loginid	: "	& TX_PAYTAG_loginid
			'Sfile2.WriteLine "TX_PAYTAG_api_key	: "	& TX_PAYTAG_api_key
			Sfile2.WriteLine "recv_orderno	: "	& recv_orderno
			Sfile2.WriteLine "recv_trandate	: "	& recv_trandate
			Sfile2.WriteLine "recv_tran_amt	: "	& recv_tran_amt
			Sfile2.WriteLine "recv_resultcode  : "	& recv_resultcode
			Sfile2.WriteLine "recv_errmsg      : "	& recv_errmsg

			If recv_resultcode = "0000" Or recv_resultcode = "00" Then
				Sfile2.WriteLine "recv_orderno     : "	& recv_orderno
				Sfile2.WriteLine "recv_orgpaydate  : "	& recv_orgpaydate
				Sfile2.WriteLine "recv_orgtranamt  : "	& recv_orgtranamt
				Sfile2.WriteLine "recv_goods_name  : "	& recv_goods_name
				Sfile2.WriteLine "recv_loginid     : "	& recv_loginid
				Sfile2.WriteLine "recv_canceltype  : "	& recv_canceltype
				Sfile2.WriteLine "recv_cancelamt   : "	& recv_cancelamt
				'Sfile2.WriteLine "recv_shop_orderno: "	& recv_shop_orderno
				'Sfile2.WriteLine "recv_shop_member : "	& recv_shop_member
				'Sfile2.WriteLine "recv_shop_field1 : "	& recv_shop_field1
				'Sfile2.WriteLine "recv_shop_field2 : "	& recv_shop_field2
				'Sfile2.WriteLine "recv_shop_field3 : "	& recv_shop_field3
				Sfile2.WriteLine "recv_tranno      : "	& recv_tranno
				Sfile2.WriteLine "recv_trandate    : "	& recv_trandate
				Sfile2.WriteLine "recv_trantime    : "	& recv_trantime
				Sfile2.WriteLine "recv_restamt     : "	& recv_restamt
				Sfile2.WriteLine "recv_apprno      : "	& recv_apprno
				Sfile2.WriteLine "recv_transeq     : "	& recv_transeq
				Sfile2.WriteLine "recv_receipt_url : "	& recv_receipt_url
				Sfile2.WriteLine "---------------------------------------------"
			End If

			Sfile2.Close
			Set Fso2= Nothing
			Set objError= Nothing
		On Error Goto 0
	'▣ 로그 기록 E


	Response.Write "{""recv_resultcode"":"""&Trim(recv_resultcode)&""",""recv_apprno"":"""&Trim(recv_apprno)&""",""recv_errmsg"":"""&recv_errmsg&"""}"




%>


