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
recv_canceltype		=	Trim( request.form("recv_canceltype") )		'	취소구분 '0'-전부취소 / '1'-부분취소
recv_cancelamt		=	Trim( request.form("recv_cancelamt") )		'	취소희망금액
recv_shop_field1	=	Trim( request.form("recv_shop_field1") )	'	업체 여유필드1
recv_shop_field2	=	Trim( request.form("recv_shop_field2") )	'	업체 여유필드2
recv_shop_field3	=	Trim( request.form("recv_shop_field3") )	'	업체 여유필드3

' =========================================================================
' PG 사의 응답파라메터값
' =========================================================================
recv_resultcode		=	Trim( request.form("recv_resultcode") )		'	취소결과코드 '00' or '0000' : 정상결제, 그외는 결제실패
recv_errmsg			=	Trim( request.form("recv_errmsg") )			'	취소실패사유

recv_goods_name		=	Trim( request.form("recv_goods_name") )		'	원거래의 상품명
recv_trandate		=	Trim( request.form("recv_trandate") )		'	거래일자 ( yyyymmdd )
recv_trantime		=	Trim( request.form("recv_trantime") )		'	거래시간 ( hhnnss )
recv_restamt    	=	Trim( request.form("recv_restamt") )		'	취소 후 결제 잔액
recv_apprno			=	Trim( request.form("recv_apprno") )			'	원거래의 승인번호
recv_transeq		=	Trim( request.form("recv_transeq") )		'	페이태그 취소거래 고유번호 ( 상세정보 조회시 필요값으로 DB에 저장이 되어야 합니다 )
recv_receipt_url    =	Trim( request.form("recv_receipt_url") )	'   신용카드 결제영수증 url ( full path )	

recv_shop_orderno	=	Trim( request.form("recv_shop_orderno") )	'	원거래의 업체(가맹점) 자체주문번호
recv_shop_member	=	Trim( request.form("recv_shop_member") )	'	원거래의 업체(가맹점) 자체회원번호 or 아이디



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
    _frm.cancelamt.value 	= "<%=recv_cancelamt%>";
    _frm.apprno.value 	    = "<%=recv_apprno%>";
    _frm.transeq.value 	    = "<%=recv_transeq%>";
    _frm.trandate.value 	= "<%=recv_trandate%>";    
    _frm.trantime.value 	= "<%=recv_trantime%>";
    _frm.restamt.value 	    = "<%=recv_restamt%>";
    _frm.shop_orderno.value = "<%=recv_shop_orderno%>";
    _frm.shop_member.value 	= "<%=recv_shop_member%>";
    _frm.goods_name.value 	= "<%=recv_goods_name%>";
    _frm.receipt_url.value 	= "<%=recv_receipt_url%>";

	_frm.submit();

</script>