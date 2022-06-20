<!-- #include file=KSPayWebHost.inc -->
<%
	dim rcid   : rcid	= Request.Form("reCommConId"		)
	dim rctype : rctype	= Request.Form("reCommType"			)
	dim rhash  : rhash	= Request.Form("reHash"				)

  'rcid 없으면 결제를 끝까지 진행하지 않고 중간에 결제취소

	dim authyn
	dim trno
	dim trddt
	dim trdtm
	dim amt
	dim authno
	dim msg1
	dim msg2
	dim ordno
	dim isscd
	dim aqucd
	dim result
	dim resultcd

	KSPayWebHost rcid, Null		'KSNET 결제결과 중 아래에 나타나지 않은 항목이 필요한 경우 Null 대신 필요한 항목명을 설정할 수 있습니다.
'여기까지 실결제안됨
	if kspay_send_msg("1") then	'현재 결제대기 상태이며 kspay_send_msg("1")을 호출하셔야 결제가 처리됩니다.
'여기서부터 실결제됨
		authyn	 = kspay_get_value("authyn")
		trno	 = kspay_get_value("trno"  )
		trddt	 = kspay_get_value("trddt" )
		trdtm	 = kspay_get_value("trdtm" )
		amt	     = kspay_get_value("amt"   )
		authno	 = kspay_get_value("authno")
		msg1	 = kspay_get_value("msg1"  )
		msg2	 = kspay_get_value("msg2"  )
		ordno	 = kspay_get_value("ordno" )
		isscd	 = kspay_get_value("isscd" )
		aqucd	 = kspay_get_value("aqucd" )
		result	 = kspay_get_value("result")

		if False = IsNull(authyn) and 1 = Len(authyn) then

			if authyn = "O" then
				resultcd = "0000"
			else
				resultcd = trim(authno)
			end if

			kspay_send_msg "3"	'정상처리가 완료되었을 경우 호출합니다.(이 과정이 없으면 일시적으로 kspay_send_msg("1")을 호출하여 거래내역 조회가 가능합니다.)
		end if
	end if

'업체에서 추가하신 인자값을 받는 부분입니다

dim ECHA : ECHA= request.form("ECHA")
dim ECHB : ECHB= request.form("ECHB")
dim ECHC : ECHC= request.form("ECHC")
dim ECHD : ECHD= request.form("ECHD")

'ECH로 시작하는 파라미터는 전송/응답 가능
dim ECH_strName : ECH_strName= request.form("ECH_strName")
dim ECH_strTel : ECH_strTel= request.form("ECH_strTel")
dim ECH_strZip : ECH_strZip= request.form("ECH_strZip")
dim ECH_Ordernumber : ECH_Ordernumber= request.form("ECH_Ordernumber")
dim ECH_intIDX : ECH_intIDX= request.form("ECH_intIDX")
dim ECH_strGoodsName : ECH_strGoodsName= request.form("ECH_strGoodsName")

dim ECH_isDirect : ECH_isDirect= request.form("ECH_isDirect")
dim ECH_IDX		 : ECH_IDX= request.form("ECH_IDX")


'ECH~  말고 파라미터전송 안됨
dim strTel   : strTel	= request.form("strTel")	'XXX
dim strTEST  : strTEST	= request.form("strTEST")	'XXX


%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>호스트방식(APP) 결제샘플</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0" />
<style type="text/css">
	BODY{font-size:9pt; line-height:100%}
	TD{font-size:9pt; line-height:100%}
	A {color:blue;line-height:100%; background-color:#E0EFFE}
	INPUT{font-size:9pt;}
	SELECT{font-size:9pt;}
</style>
</head>
<body bgcolor=#ffffff onload="">

<CENTER><B><font size=4 color="blue">성공페이지 내역.</font></B></CENTER>
<br>
<TABLE  width=100% border="1" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td align="center" colspan=4>
			<br>
			이페이지는 <font color = "red">승인성공시</font>에 업체측으로 리턴되는 결과 값들을 나타내고 있읍니다.
			<br>
			아래와 같은 리턴 항목들중에서 귀사에서 필요하신 부분만 받으셔서 사용하시면 됩니다.
			<br>
			<br>
		</td>
	</tr>
<TR>
	<TD><B>항목명</B></TD>
	<TD><B>변수명</B></TD>
	<TD><B>결과값</B></TD>
	<TD><B>비고</B></TD>
</TR>
<TR>
	<TD>승인구분</TD>
	<TD>authyn</TD>
	<TD> <%if authyn = "O" then response.write "승인" else response.write "거절" end if%> </TD>
	<TD>승인요청에 대하여 승인이 허락되던지 <br>거절되던지 리턴값의 항목은 같읍니다.</TD>
</TR>
<TR>
	<TD>거래번호</TD>
	<TD>trno</TD>
	<TD><%=trno%></TD>
	<TD>거래번호는 중요합니다. <br>결재정보중 유니크키로 사용하는값으로 사후 승인취소등의 처리시 꼭 필요합니다.</TD>
</TR>
<TR>
	<TD>거래일자</TD>
	<TD>trddt</TD>
	<TD><%=trddt%></TD>
	<TD>&nbsp;</TD>
</TR>
<TR>
	<TD>거래시간</TD>
	<TD>trdtm</TD>
	<TD><%=trdtm%></TD>
	<TD>&nbsp;</TD>
</TR>
<TR>
	<TD>카드사 승인번호/은행 코드번호</TD>
	<TD>authno</TD>
	<TD><%=authno%></TD>
	<TD>승인번호는 카드사에서 발급하는 것으로 유니크하지 않을수도 있음에 주의하십시요.</TD>
</TR>
<TR>
	<TD>발급사코드/가상계좌번호/계좌이체번호</TD>
	<TD>isscd</TD>
	<TD><%=isscd%></TD>
	<TD></TD>
</TR>
<TR>
	<TD>매입사코드</TD>
	<TD>aqucd</TD>
	<TD><%=aqucd%></TD>
	<TD></TD>
</TR>
<TR>
	<TD>주문번호</TD>
	<TD>ordno</TD>
	<TD><%=ordno%></TD>
	<TD>주문번호는 업체측에서 넘겨주신 값을 그대로 리턴해드립니다.</TD>
</TR>
<TR>
	<TD>금액</TD>
	<TD>amt</TD>
	<TD><%=amt%></TD>
	<TD>&nbsp;</TD>
</TR>
<TR>
	<TD>메세지1</TD>
	<TD>msg1</TD>
	<TD><%=msg1%></TD>
	<TD>메세지는 카드사에서 보내는 것을 그대로 리턴해 드리는것으로<br> KSNET에서 생성된 내용은 아닙니다.</TD>
</TR>
<TR>
	<TD>메세지2</TD>
	<TD>msg2</TD>
	<TD><%=msg2%></TD>
	<TD>승인성공시 이부분엔 OK와 승인번호가 표시됩니다.</TD>
</TR>
<TR>
    <TD>결제수단</TD>
    <TD>result</TD>
    <TD><%=result%></TD>
    <TD>결제수단이 표시됩니다.</TD>
</TR>
<TR>
    <TD>strTel</TD>
    <TD><%=strTel%></TD>
    <TD>strTEST</TD>
    <TD><%=strTEST%></TD>
</TR>
<TR>
    <TD>ECHA</TD>
    <TD><%=ECHA%></TD>
    <TD>ECHB</TD>
    <TD><%=ECHB%></TD>
</TR><TR>
    <TD>ECHC</TD>
    <TD><%=ECHC%></TD>
    <TD>ECHD</TD>
    <TD><%=ECHD%></TD>
</TR><TR>
    <TD>ECH_strName</TD>
    <TD><%=ECH_strName%></TD>
    <TD>ECH_strTel</TD>
    <TD><%=ECH_strTel%></TD>
</TR><TR>
    <TD>ECH_strZip</TD>
    <TD><%=ECH_strZip%></TD>
    <TD>ECH_Ordernumber</TD>
    <TD><%=ECH_Ordernumber%></TD>
</TR><TR>
    <TD>ECH_intIDX</TD>
    <TD><%=ECH_intIDX%></TD>
    <TD>ECH_strGoodsName</TD>
    <TD><%=ECH_strGoodsName%></TD>
</TR>

<TR>
    <TD>rcid</TD>
    <TD><%=rcid%></TD>
    <TD>rctype</TD>
    <TD><%=rhash%></TD>
</TR><TR>
    <TD>authyn</TD>
    <TD><%=authyn%></TD>
    <TD></TD>
    <TD></TD>
</TR>
<TR>
    <TD>ECH_isDirect</TD>
    <TD><%=ECH_isDirect%></TD>
    <TD>ECH_IDX</TD>
    <TD><%=ECH_IDX%></TD>
</TR>

<%
	dim GO_BACK_ADDR
	Response.write ECH_isDirect
	Response.write ECH_IDX
If rcid = "" Then
	'isDirect or Cart 체크 (GO_BACK_ADDR)
	If ECH_isDirect = "T" Then
		GO_BACK_ADDR = "/m/shop/detailView.asp?gidx="&ECH_IDX
	Else
		GO_BACK_ADDR = "/m/shop/cart.asp"
	End If
	Response.redirect GO_BACK_ADDR
	'Call ALERTS("결제가 취소되었습니다.","GO",GO_BACK_ADDR)
End If
%>

	<tr>
		<td align="center" colspan=4>
			<br>
			<br>
			<br>
		</td>
	</tr>
</TABLE>
</body>
</html>