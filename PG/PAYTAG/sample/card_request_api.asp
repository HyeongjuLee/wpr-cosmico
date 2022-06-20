
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
servicecode     =   "PAYTAG"        '   필수 : 고정값
reqtype			=   "L"				'   필수 : 'L'-API연동 고정값
restype			=   "J"					'   필수 : 'J'-JSON 결과 리턴
cmdtype         =   "PAYKEYIN"     '   필수 : 고정값
paytag_apiurl	=   "https://api.paytag.kr/pay/cardkeyin"       ' 필수 : 고정값 ( rest 주소값 )

' =========================================
' 페이태그로 부터 부여받은 값
' -------------------------------------------------------------------
shopcode        =   "1901110002"		'   필수 : 페이태그 가맹점 번호
loginid			=   "paytag"				'   필수 : 페이태그 로그인ID
api_key			=   "Q)6FpZdJ~PQJ*I[l5fs$I_ADN@BS#$h)"              '   필수 : 암호화 키값

' ========================================
' 주문정보
' -------------------------------------------------------------------
goods_name		=   "모나미볼펜"    '   필수 : 상품명
tran_amt			=   "1004"			'   필수 : 결제요청금액
taxfree_yn		=   "N"				'   N-과세, Y-면세

order_name		=   "홍길동"			'   필수 : 주문자-이름
order_hp			=   ""					'   필수 : 주문자-휴대폰번호
order_email		=   ""					'   선택 : 주문자-이메일

payer_name     =   "홍길동"			'   필수 : 결제자-이름
payer_hp			=   ""					'   필수 : 결제자-휴대폰번호
payer_email		=   ""					'   선택 : 결제자-이름

' ========================================
' 결제진행할 카드정보
' 구인증( 카유비생) 필수값 : card_certno, card_pwd
' -------------------------------------------------------------------
cardno			=   ""					'   필수 : 카드번호
expire_date		=   ""					'   필수 : 유효기간 (MMYY)
tran_inst			=   ""					'   필수 : 할부기간 00-일시불, 5만원이상, 12개월 이내
card_type		=   "0"				'   필수 : 0-개인카드, 1-사업자카드
card_certno		=   ""					'   (구인증/카유비생)필수 : 카드인증번호 / 개인카드=주민번호6자리 YYMMDD, 사업자카드:사업자번호10자리
card_pwd        =   ""					'   (구인증/카유비생)필수필수 : 비밀번호 앞2자리

' =======================================
' 가맹점 자체값
' -------------------------------------------------------------------
shop_orderno	=   ""              '   선택 : 가맹점 자체 주문번호
shop_member	=   ""              '   선택 : 가맹점 자체 회원번호
shop_field1		=   ""              '   선택 : 예비필드1
shop_field2		=   ""              '   선택 : 예비필드2
shop_field3		=   ""              '   선택 : 예비필드3



' =======================================
' 보안인증값생성
' 가맹점마다의 key값으로 암호화 한다.
' -------------------------------------------------------------------
cert_str =	servicecode & "|" & _
				cmdtype & "|" & _
				shopcode & "|" & _
				cardno & "|" & _
				expire_date & "|" & _
				tran_amt


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
REQ_BODY_STR =  "tran_amt=" & tran_amt & _
                "&taxfree_yn=" & server.urlencode(taxfree_yn) & _
                "&goods_name=" & server.urlencode(goods_name) & _
                "&order_name=" & server.urlencode(order_name) & _
                "&order_hp=" & order_hp & _
                "&order_email=" & server.urlencode(order_email) & _
                "&payer_name=" & server.urlencode(payer_name) & _
                "&payer_hp=" & payer_hp & _
                "&payer_email=" & server.urlencode(payer_email) & _
                "&loginid=" & server.urlencode(loginid) & _
                "&tran_inst=" & tran_inst & _
                "&card_type=" & card_type & _
                "&card_certno=" & server.urlencode(card_certno) & _
                "&card_pwd=" & server.urlencode(card_pwd) & _
                "&shop_orderno=" & server.urlencode(shop_orderno) & _
                "&shop_member=" & server.urlencode(shop_member) & _
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

        Err.Raise 1020, "error", "결제서버오류["&server_status&"]"
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

        recv_resultcode      =  oJSON.data("resultcode")
        recv_errmsg          =  oJSON.data("errmsg")
        recv_tran_amt        =  oJSON.data("tran_amt")
        recv_goods_name      =  oJSON.data("goods_name")
        recv_order_name      =  oJSON.data("order_name")
        recv_order_hp        =  oJSON.data("order_hp")
        recv_order_email     =  oJSON.data("order_email")
        recv_payer_name      =  oJSON.data("payer_name")
        recv_payer_hp        =  oJSON.data("payer_hp")
        recv_payer_email     =  oJSON.data("payer_email")
        recv_loginid         =  oJSON.data("loginid")
        recv_tran_inst       =  oJSON.data("tran_inst")
        recv_taxfree_yn      =  oJSON.data("taxfree_yn")
        recv_shop_orderno    =  oJSON.data("shop_orderno")
        recv_shop_member     =  oJSON.data("shop_member")
        recv_shop_field1     =  oJSON.data("shop_field1")
        recv_shop_field2     =  oJSON.data("shop_field2")
        recv_shop_field3     =  oJSON.data("shop_field3")

        recv_orderno         =  oJSON.data("orderno")           '       페이태그 거래보호로 디비에 저장하셔야 합니다. ( 결제취소 연동 )
        recv_tranno          =  oJSON.data("tranno")
        recv_apprno          =  oJSON.data("apprno")            '       승인번호 ( 정상결제시만 제공됨 )
        recv_trandate        =  oJSON.data("trandate")
        recv_trantime        =  oJSON.data("trantime")
        recv_cardno          =  oJSON.data("cardno")
        recv_cardname        =  oJSON.data("cardname")
        recv_transeq         =  oJSON.data("transeq")
        recv_receipt_url     =  oJSON.data("receipt_url")       '       전표주소 full url ( 정상결제시만 제공됨 )

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






<!DOCTYPE html>
<html>
	<head>
		<title>paytag sample</title>

		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0">

		<link rel="stylesheet" href="css/demo.css">
		<link rel="stylesheet" href="css/font-awesome.css">
		<link rel="stylesheet" href="css/sky-forms.css">
		<link rel="stylesheet" href="css/sky-forms-blue.css">
		<!--[if lt IE 9]>
			<link rel="stylesheet" href="css/sky-forms-ie8.css">
		<![endif]-->

		<script src="js/jquery.min.js"></script>
		<!--[if lt IE 10]>
			<script src="js/jquery.placeholder.min.js"></script>
		<![endif]-->
		<!--[if lt IE 9]>
			<script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
			<script src="js/sky-forms-ie8.js"></script>
		<![endif]-->

		<style>
		  table {
			width: 100%;
			border: 1px solid #444444;
			border-collapse: collapse;
		  }
		  th, td {
			border: 1px solid #444444;
		  }
		</style>

	</head>
	<body >
		<div class="body" >

        <form   class="sky-form" >

        <header><img src="./img/paytag.png"> API - 카드키인결제 </header>

        <fieldset>
        <table >
            <thead>
                <tr>
                    <th style='min-width:1px; white-space:nowrap;'>parameter</th>
                    <th style='min-width:1px; white-space:nowrap;'>name</th>
                    <th style='min-width:1px; white-space:nowrap;'>value</th>
                    <th style='min-width:1px; white-space:nowrap;'>설명</th>
                </tr>
            </thead>

            <tbody>
                <tr>
                        <td>recv_resultcode</td>
                        <td><strong>결과코드</strong></td>
                        <td><%=recv_resultcode%></td>
                        <td>'0000' or '00' 정상</td>
                </tr>
                <tr>
                        <td>recv_errmsg</td>
                        <td><strong>에러내용</strong></td>
                        <td><%=recv_errmsg%></td>
                        <td>실패시 오류내용</td>
                </tr>
                <tr>
                        <td>recv_tran_amt</td>
                        <td><strong>결제요청금액</strong></td>
                        <td><%=recv_tran_amt%></td>
                        <td></td>
                </tr>
                <tr>
                        <td>recv_goods_name</td>
                        <td><strong>상품명</strong></td>
                        <td><%=recv_goods_name%></td>
                        <td></td>
                </tr>
                <tr>
                        <td>recv_order_name</td>
                        <td><strong>주문자-이름</strong></td>
                        <td><%=recv_order_name%></td>
                        <td></td>
                </tr>
                <tr>
                        <td>recv_order_hp</td>
                        <td><strong>주문자-휴대폰번호</strong></td>
                        <td><%=recv_order_hp%></td>
                        <td></td>
                </tr>
                <tr>
                        <td>recv_order_email</td>
                        <td><strong>주문자-이메일</strong></td>
                        <td><%=recv_order_email%></td>
                        <td></td>
                </tr>
                <tr>
                        <td>recv_payer_name</td>
                        <td><strong>결제자-이름</strong></td>
                        <td><%=recv_payer_name%></td>
                        <td></td>
                </tr>
                <tr>
                        <td>recv_payer_hp</td>
                        <td><strong>결제자-휴대폰번호</strong></td>
                        <td><%=recv_payer_name%></td>
                        <td></td>
                </tr>
                <tr>
                        <td>recv_payer_email</td>
                        <td><strong>결제자-이메일</strong></td>
                        <td><%=recv_payer_email%></td>
                        <td></td>
                </tr>
                <tr>
                        <td>recv_tran_inst</td>
                        <td><strong>할부기간</strong></td>
                        <td><%=recv_tran_inst%></td>
                        <td></td>
                </tr>
                <tr>
                        <td>recv_orderno</td>
                        <td><strong>페이태그 주문번호</strong></td>
                        <td><%=recv_orderno%></td>
                        <td>결제취소시필요값( 저장 )</td>
                </tr>
                <tr>
                        <td>recv_transeq</td>
                        <td><strong>페이태그 거래번호</strong></td>
                        <td><%=recv_transeq%></td>
                        <td></td>
                </tr>
                <tr>
                        <td>recv_tranno</td>
                        <td><strong>PG거래번호</strong></td>
                        <td><%=recv_tranno%></td>
                        <td></td>
                </tr>
                <tr>
                        <td>recv_apprno</td>
                        <td><strong>승인번호</strong></td>
                        <td><%=recv_apprno%></td>
                        <td>결제성공시부여됨</td>
                </tr>
                <tr>
                        <td>recv_trandate</td>
                        <td><strong>거래일</strong></td>
                        <td><%=recv_trandate%></td>
                        <td></td>
                </tr>
                <tr>
                        <td>recv_trantime</td>
                        <td><strong>거래시간</strong></td>
                        <td><%=recv_trantime%></td>
                        <td></td>
                </tr>


                </tbody>
                </table>
        </fieldset>
        </form>


	</div>

	</body>
</html>