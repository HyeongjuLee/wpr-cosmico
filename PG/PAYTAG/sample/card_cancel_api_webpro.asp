
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
reqtype			=   "L"             '   필수 : 'L'-API연동 고정값
restype			=   "J"             '   필수 : 'J'-JSON 결과 리턴
cmdtype         =   "CARDCANCEL"    '   필수 : 고정값
pay_method		=   "C"             '   필수 : 고정값
paytag_apiurl	=   "https://api.paytag.kr/pay/cardcancel"       ' 필수 : 고정값 ( rest 주소값 )

' ========================================
' 페이태그로 부터 부여받은 값
' ----------------------------------------
shopcode        =   "1901110002"         '   필수 : 페이태그 가맹점 번호
'shopcode        =   "2101012640"         '   필수 : 페이태그 가맹점 번호        '바이온

' 본사권한으로 실행 ! - 대리점에 관계없이 취소실행 가능
'loginid			=   ""                   '  필수 : 로그인ID
'loginpwd		=   ""                   '  blank
'api_key			=   ""                   '  필수 : 암호화 키값
'reqLink			=   ""                   '


' 가맹점권한으로 결제취소 실행시는
 'loginid         =   "1901110002"       '  필수 : 가맹점 로그인ID                       '#4
 loginid         =   "paytag"       '  필수 : 가맹점 로그인ID                       '#4
 'loginid         =   "byonglobal"       '  필수 : 가맹점 로그인ID                       '#4
 loginpwd        =   ""						'  blank
 api_key         =   "Q)6FpZdJ~PQJ*I[l5fs$I_ADN@BS#$h)"              '   필수 : 가맹점 암호화 키값
 'api_key         =   "bKQ8C24zqI1w7NVu0eTAKV2TLf9iAjBq"              '   필수 : 가맹점 암호화 키값
 reqLink         =   ""

%>
<%
'Response.end


  orderno = "20210219837584"
  orgpaydate = "20210219"               'recv_trandate
  orgtranamt = 1001                     'recv_tran_amt
%>
<%
' ========================================
' 취소정보
' ----------------------------------------
orderno				=   orderno              '   필수 : 페이태그 거래번호                    '#1
orgpaydate			=   orgpaydate             '   필수 : 원거래 승인일자 ( YYYYMMDD )         '#2
orgtranamt			=   orgtranamt              '   팔수 : 원거래 승인금액                      '#3
canceltype			=   "0"             '   필수 : 0-전체잔액취소 / 1-부분취소           '#5
req_cancelamt		=   orgtranamt              '   필수 : 취소희망금액                         '#6 ??? cancelamt


' ========================================
' 가맹점 자체값
' ----------------------------------------
shop_field1     =   ""              '   선택 : 예비필드1                                '#7
shop_field2     =   ""              '   선택 : 예비필드2                                '#8
shop_field3     =   ""              '   선택 : 예비필드3                                '#9



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

        response.write resultstr


        Set oJSON = New aspJSON
        oJSON.loadJSON(resultstr)

        recv_resultcode     =  oJSON.data("resultcode")
        recv_errmsg         =  oJSON.data("errmsg")
        recv_orderno        =  oJSON.data("orderno")
        recv_orgpaydate     =  oJSON.data("orgtrandate")
        recv_orgtranamt     =  oJSON.data("orgtranamt")
        recv_goods_name     =  oJSON.data("goods_name")
        recv_loginid        =  oJSON.data("loginid")
        recv_canceltype     =  oJSON.data("canceltype")
        recv_cancelamt      =  oJSON.data("cancelamt")
        recv_shop_orderno   =  oJSON.data("shop_orderno")
        recv_shop_member    =  oJSON.data("shop_member")
        recv_shop_field1    =  oJSON.data("shop_field1")
        recv_shop_field2    =  oJSON.data("shop_field2")
        recv_shop_field3    =  oJSON.data("shop_field3")
        recv_tranno         =  oJSON.data("tranno")
        recv_trandate       =  oJSON.data("trandate")
        recv_trantime       =  oJSON.data("trantime")
        recv_restamt        =  oJSON.data("restamt")
        recv_apprno         =  oJSON.data("apprno")
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

        <header><img src="./img/paytag.png"> API - 카드결제취소 </header>

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
                        <td>recv_orderno</td>
                        <td><strong>페이태그-주문번호</strong></td>
                        <td><%=recv_orderno%></td>
                        <td></td>
                </tr>
                <tr>
                        <td>recv_trandate</td>
                        <td><strong>거래일자</strong></td>
                        <td><%=recv_trandate%></td>
                        <td></td>
                </tr>
                <tr>
                        <td>recv_trantime</td>
                        <td><strong>거래시간</strong></td>
                        <td><%=recv_trantime%></td>
                        <td></td>
                </tr>

                <tr>
                        <td>recv_orgpaydate</td>
                        <td><strong>원거래-승인일자</strong></td>
                        <td><%=recv_orgpaydate%></td>
                        <td></td>
                </tr>
                <tr>
                        <td>recv_goods_name</td>
                        <td><strong>원거래-상품명</strong></td>
                        <td><%=recv_goods_name%></td>
                        <td></td>
                </tr>
                <tr>
                        <td>recv_orgtranamt</td>
                        <td><strong>원거래-승인금액</strong></td>
                        <td><%=recv_orgtranamt%></td>
                        <td></td>
                </tr>
                <tr>
                        <td>recv_canceltype</td>
                        <td><strong>취소type</strong></td>
                        <td><%=recv_canceltype%></td>
                        <td></td>
                </tr>
                <tr>
                        <td>recv_cancelamt</td>
                        <td><strong>취소금액</strong></td>
                        <td><%=recv_cancelamt%></td>
                        <td></td>
                </tr>
                <tr>
                        <td>recv_restamt</td>
                        <td><strong>취소후잔액</strong></td>
                        <td><%=recv_restamt%></td>
                        <td></td>
                </tr>

                <tr>
                        <td>recv_apprno</td>
                        <td><strong>원거래-승인번호</strong></td>
                        <td><%=recv_apprno%></td>
                        <td></td>
                </tr>
                <tr>
                        <td>recv_shop_orderno</td>
                        <td><strong>원거래-업체주문번호</strong></td>
                        <td><%=recv_shop_orderno%></td>
                        <td></td>
                </tr>
                <tr>
                        <td>recv_shop_member</td>
                        <td><strong>원거래-업체회원번호</strong></td>
                        <td><%=recv_shop_member%></td>
                        <td></td>
                </tr>
                <tr>
                        <td>recv_shop_field1</td>
                        <td><strong>예비필드1</strong></td>
                        <td><%=recv_shop_field1%></td>
                        <td></td>
                </tr>
                <tr>
                        <td>recv_shop_field2</td>
                        <td><strong>예비필드2</strong></td>
                        <td><%=recv_shop_field2%></td>
                        <td></td>
                </tr>
                <tr>
                        <td>recv_shop_field3</td>
                        <td><strong>예비필드3</strong></td>
                        <td><%=recv_shop_field3%></td>
                        <td></td>
                </tr>

                </tbody>
                </table>
        </fieldset>
        </form>


	</div>

	</body>
</html>