<%@Language="VBScript" CODEPAGE=65001%>
<%
Response.CharSet="utf-8" 
Session.codepage="65001" 
Response.codepage="65001" 
Response.ContentType="text/html;charset=UTF-8"
'Response.CharSet="euc-kr" 
'Session.codepage="949" 
'Response.codepage="949"
%>




<%
' =========================================================================
' 해당페이지에 대한 자체 권한을 체크합니다.
' 로그인유지 여부 / 주문번호에 따른 가격등이 맞는지를 확인하시기 바랍니다.
' 실행 언어는 가맹점이 사용하시는 개발언어에 맞게 수정하시기 바랍니다. 
' 단순, 폼 값을 받아오는 부분이라 쉽게 처리가 가능합니다.
' =========================================================================
%>



<%
' =========================================================================
' 업체에서 결제시 요청한 값들
' =========================================================================
recv_goods_name		=	Trim( request.form("recv_goods_name") )		'	상품명
recv_order_name		=	Trim( request.form("recv_order_name") )		'	주문자 이름
recv_order_hp		=	Trim( request.form("recv_order_hp") )		'	주문자 휴대폰번호
recv_order_email	=	Trim( request.form("recv_order_email") )	'	주문자 이메일
recv_payer_name		=	Trim( request.form("recv_payer_name") )		'	결제자 이름
recv_payer_hp		=	Trim( request.form("recv_payer_hp") )		'	결제자 휴대폰번호
recv_payer_email	=	Trim( request.form("recv_payer_email") )	'	결제자 이메일
recv_shop_field1	=	Trim( request.form("recv_shop_field1") )	'	업체 여유필드1
recv_shop_field2	=	Trim( request.form("recv_shop_field2") )	'	업체 여유필드2
recv_shop_field3	=	Trim( request.form("recv_shop_field3") )	'	업체 여유필드3
recv_loginid		=	Trim( request.form("recv_loginid") )		'	페이태그 아이디
recv_shop_orderno	=	Trim( request.form("recv_shop_orderno") )	'	업체(가맹점) 자체주문번호
recv_shop_member	=	Trim( request.form("recv_shop_member") )	'	업체(가맹점) 자체회원번호 or 아이디

' =========================================================================
' PG 사의 응답파라메터값
' =========================================================================
recv_resultcode		=	Trim( request.form("recv_resultcode") )		'	결제결과코드 '00' or '0000' : 정상결제, 그외는 결제실패
recv_errmsg			=	Trim( request.form("recv_errmsg") )			'	결제실패사유

recv_pay_method		=	Trim( request.form("recv_pay_method") )		'	결제방법  'C'-신용카드 / 'R' - 계좌이체 / 'V' - 가상계좌
recv_taxfree_yn		=	Trim( request.form("recv_taxfree_yn") )		'	면세구분 'Y' : 면세, 그외는 과세물품

recv_tran_inst		=	Trim( request.form("recv_tran_inst") )		'	할부개월
recv_orderno		=	Trim( request.form("recv_orderno") )		'	페이태그 주문번호 ( 취소시 필요값으로 DB에 저장이 되어야 합니다 )
'recv_tranno			=	Trim( request.form("recv_tranno") )			'	PG 거래고유번호
'recv_apprno			=	Trim( request.form("recv_apprno") )			'	카드사 승인번호
'recv_trandate		=	Trim( request.form("recv_trandate") )		'	거래일자 ( yyyymmdd )
'recv_trantime		=	Trim( request.form("recv_trantime") )		'	거래시간 ( hhnnss )
'recv_cardno			=	Trim( request.form("recv_cardno") )			'	결제 카드번호
'recv_cardname		=	Trim( request.form("recv_cardname") )		'	결제 카드사명

recv_orderinfo_path			=	Trim( request.form("recv_orderinfo_path") )			'	상세거래내역 주소
recv_orderinfo_ars			=	Trim( request.form("recv_orderinfo_ars") )			'	ARS결제번호(신용카드만 해당됨/가상계좌는 X)
recv_orderinfo_expiredt		=	Trim( request.form("recv_orderinfo_expiredt") )		'	주문 만기일자

recv_vbancode 	=  Trim( request.form("recv_vbankcode") ) 
recv_vbankowner =  Trim( request.form("recv_vbankowner") ) 
recv_vbankno    =  Trim( request.form("recv_vbankno") ) 
recv_vbankname	=  Trim( request.form("recv_vbankname") ) 

' =========================================================================
' 아래 부분에서 업체의 데이터베이스를 처리합니다.
' 위 결과값으로 자체 주문처리를 하시면 됩니다.
' =========================================================================





' ------------------------------------------------------------------------
%>



<script>
	// ===================================================================
	// 본 스크립트에서 호출 폼에 결과값을 세팅해줍니다.
	// 값 세팅후 폼의 redirect_path 필드값에 지정한 url 로 이동 시킵니다.
	// ==================================================================
	var _frm = parent.opener.parent.PayTagPayForm;

	_frm.target		= "_top";
	_frm.action		=	_frm.redirect_path.value;

    _frm.resultcode.value = "<%=recv_resultcode%>";
    _frm.errmsg.value 	= "<%=recv_errmsg%>";
    _frm.orderno.value 	= "<%=recv_orderno%>";
    _frm.orderinfo_path.value 	    = "<%=recv_orderinfo_path%>";
    _frm.orderinfo_ars.value 	    = "<%=recv_orderinfo_ars%>";
    _frm.orderinfo_expiredt.value 	= "<%=recv_orderinfo_expiredt%>";

	_frm.vbankcode.value 	= "<%=recv_vbancode%>";
	_frm.vbankowner.value 	= "<%=recv_vbankowner%>";
	_frm.vbankno.value 	= "<%=recv_vbankno%>";
	_frm.vbankname.value 	= "<%=recv_vbankname%>";

	_frm.submit();

</script>