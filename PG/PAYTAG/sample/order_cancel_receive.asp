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
recv_orderno		=	Trim( request.form("recv_orderno") )		'	페이태그 원거래 주문번호
recv_orgpaydate		=	Trim( request.form("recv_orgpaydate") )		'	원거래 승인일자
recv_orgtranamt		=	Trim( request.form("recv_orgtranamt") )		'	원거래 결제금액
recv_loginid		=	Trim( request.form("recv_loginid") )		'	페이태그 아이디


' =========================================================================
' PG 사의 응답파라메터값
' =========================================================================
recv_resultcode		=	Trim( request.form("recv_resultcode") )		'	취소결과코드 '00' or '0000' : 정상결제, 그외는 결제실패
recv_errmsg			=	Trim( request.form("recv_errmsg") )			'	취소실패사유

recv_goods_name		=	Trim( request.form("recv_goods_name") )		'	원주문의 상품명
recv_orderdate		=	Trim( request.form("recv_orderdate") )		'	원주문일자 ( yyyymmdd )
recv_ordertime		=	Trim( request.form("recv_ordertime") )		'	원주문시간 ( hhnnss )
recv_orderamt    	=	Trim( request.form("recv_orderamt") )		'	원주문금액

recv_shop_orderno	=	Trim( request.form("recv_shop_orderno") )	'	원주문의 업체(가맹점) 자체주문번호
recv_shop_member	=	Trim( request.form("recv_shop_member") )	'	원주문의 업체(가맹점) 자체회원번호 or 아이디


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

    _frm.resultcode.value   = "<%=recv_resultcode%>";
    _frm.errmsg.value 	    = "<%=recv_errmsg%>";  
    _frm.shop_orderno.value = "<%=recv_shop_orderno%>";
    _frm.shop_member.value 	= "<%=recv_shop_member%>";
    _frm.orderdate.value 	= "<%=recv_orderdate%>";
    _frm.ordertime.value 	= "<%=recv_ordertime%>";
    _frm.orderamt.value 	= "<%=recv_orderamt%>";
    _frm.goodsname.value 	= "<%=recv_goods_name%>";   
    
	_frm.submit();

</script>