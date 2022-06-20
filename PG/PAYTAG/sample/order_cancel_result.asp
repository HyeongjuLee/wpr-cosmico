
<%@Language="VBScript" CODEPAGE=65001%>
<%
Response.CharSet="utf-8" 
Session.codepage="65001" 
Response.codepage="65001" 
Response.ContentType="text/html;charset=UTF-8"
%>



<%
servicecode   = Trim( request.form("servicecode") )
shopcode      = Trim( request.form("shopcode") )		'	페이태그 가맹점번호
pay_method    = Trim( request.form("pay_method") )		'	결제방법 'C'-카드 / 'R'-계좌이체 / 'V'-가상계좌
loginid       = Trim( request.form("loginid") )		'	페이태그 아이디
redirect_path = Trim( request.form("redirect_path") )		'	페이태그 아이디
alert_path    = Trim( request.form("alert_path") )		'	페이태그 아이디

resultcode    = Trim( request.form("resultcode") )		'	취소결과 : '00' or '0000' - 결제성공 / 나머지는 결제실패
errmsg        = Trim( request.form("errmsg") )		    '	취소실패사유
orderamt     = Trim( request.form("orderamt") )		    '	원주문그액
orderdate      = Trim( request.form("orderdate") )		'	원주문일자 ( yyyymmdd )
ordertime      = Trim( request.form("ordertime") )		'	원주문시간 ( hhnnss )

shop_orderno  = Trim( request.form("shop_orderno") )	'	원주문 - 업체(가맹점) 자체 주문번호
shop_member   = Trim( request.form("shop_member") )		'	원주문 - 업체(가맹점) 자체 회원번호(아이디)

orderno       = Trim( request.form("orderno") )		    '	원주문 - 페이태그 주문번호
goodsname    = Trim( request.form("goodsname") )		'	주문상품명
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
	<body>
		<div class="body">			
        
        

        <%if resultcode = "0000" then%>
                <div class="alert alert-success text-center">
                    <h3><strong>주문취소완료</strong></h3>
                </div>                                              

        <%else%>       
                <div class="alert alert-danger text-center">
                    <h3><strong>주문취소실패!!!!! <small><%=errmsg%></small></strong></h3>
                </div>
        <%end if%>

        <table class="table">
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
                        <td>resultcode</td>
                        <td><strong>결과코드</strong></td>
                        <td><%=resultcode%></td>
                        <td>'0000' or '00' 정상</td>
                </tr>
                <tr>
                        <td>errmsg</td>
                        <td><strong>에러내용</strong></td>
                        <td><%=errmsg%></td>
                        <td>실패시 오류내용</td>
                </tr>   
                <tr>
                        <td>orderno</td>
                        <td><strong>페이태그-주문번호</strong></td>
                        <td><%=orderno%></td>
                        <td></td>
                </tr>

                <%if resultcode = "0000" then%>
                    <tr>
                            <td>shop_orderno</td>
                            <td><strong>원거래-업체주문번호</strong></td>
                            <td><%=shop_orderno%></td>
                            <td></td>
                    </tr>   
                    <tr>
                            <td>shop_member</td>
                            <td><strong>원거래-업체회원번호</strong></td>
                            <td><%=shop_member%></td>
                            <td></td>
                    </tr> 
                    <tr>
                            <td>orderdate</td>
                            <td><strong>원거래-주문일자</strong></td>
                            <td><%=orderdate%></td>
                            <td></td>
                    </tr> 
                    <tr>
                            <td>ordertime</td>
                            <td><strong>원거래-주문시간</strong></td>
                            <td><%=ordertime%></td>
                            <td></td>
                    </tr> 
                    <tr>
                            <td>orderamt</td>
                            <td><strong>원거래-주문금액</strong></td>
                            <td><%=orderamt%></td>
                            <td></td>
                    </tr> 
                    <tr>
                            <td>goodsname</td>
                            <td><strong>원거래-상품명</strong></td>
                            <td><%=goodsname%></td>
                            <td></td>
                    </tr> 
                <%end if%>
    
            </tbody>
            <tfoot>
            </tfoot>
        </table>
        



	</body>
</html>


