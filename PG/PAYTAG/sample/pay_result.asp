
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
order_send_type    = Trim( request.form("order_send_type") )

loginid       = Trim( request.form("loginid") )		'	페이태그 아이디
redirect_path = Trim( request.form("redirect_path") )		'	페이태그 아이디
alert_path    = Trim( request.form("alert_path") )		'	페이태그 아이디

resultcode    = Trim( request.form("resultcode") )		'	결제결과 : '00' or '0000' - 결제성공 / 나머지는 결제실패
errmsg        = Trim( request.form("errmsg") )		'	결제실패사유
orderno       = Trim( request.form("orderno") )		'	페이태그 주문번호
tranno        = Trim( request.form("tranno") )		'	PG 거래번호
apprno        = Trim( request.form("apprno") )		'	카드사 승인번호
trandate      = Trim( request.form("trandate") )		'	거래일자 ( yyyymmdd )
trantime      = Trim( request.form("trantime") )		'	거래시간 ( hhnnss )
cardno        = Trim( request.form("cardno") )		'	카드번호
tran_inst     = Trim( request.form("tran_inst") )		'	할부개월 ( '00'-일시불 )
cardname      = Trim( request.form("cardname") )		'	카드명
payer_name    = Trim( request.form("payer_name") )		'	결제자 이름
payer_hp      = Trim( request.form("payer_hp") )		'	결제자 휴대폰
payer_email   = Trim( request.form("payer_email") )		'	결제자 이메일

goods_name    = Trim( request.form("goods_name") )		'	주문상품명
tran_amt      = Trim( request.form("tran_amt") )		'	거래금액
taxfree_yn    = Trim( request.form("taxfree_yn") )		'	면세여부 'Y'-면세 / 그외 과세물품
order_name    = Trim( request.form("order_name") )		'	주문자 이름
order_hp      = Trim( request.form("order_hp") )		'	주문자 휴대폰
order_email   = Trim( request.form("order_email") )		'	주문자 이메일
shop_orderno  = Trim( request.form("shop_orderno") )		'	업체(가맹점) 자체 주문번호
shop_member   = Trim( request.form("shop_member") )		'	업체(가맹점) 자체 회원번호(아이디)
shop_field1   = Trim( request.form("shop_field1") )		'	가맹점 여유필드1
shop_field2   = Trim( request.form("shop_field2") )		'	가맹점 여유필드2
shop_field3   = Trim( request.form("shop_field3") )		'	가맹점 여유필드3
%>


                                       


		<%if resultcode = "0000" then%>
				<div class="alert alert-success text-center">
					<h3><strong>정상결제</strong></h3>
				</div>      
			   
		<%else%>       
				<div class="alert alert-danger text-center">
					<h3><strong>결제실패 <small><%=errmsg%></small></strong></h3>
				</div>                                                                                      
		<%end if%>


        <table class="table">
          <tbody>
                <tr>
                    <td>거래일자</td>
                    <td><strong><%=trandate&trantime%></strong></td>
                </tr>              
            <tr>
                <td>상품명</td>
                <td><%=goods_name%></td>
            </tr>
            <tr>
                <td>금액</td>
                <td><%=formatnumber(tran_amt, 0, -1)%></td>
            </tr>

            <tr>
                <td>주문자이름</td>
                <td><%=order_name%></td>
            </tr>  
            <tr>
                <td>주문자휴대폰</td>
                <td><%=order_hp%></td>
            </tr>  
            <tr>
                <td>주문자이메일</td>
                <td><%=order_email%></td>
            </tr>
            <tr>
                <td>결제자이름</td>
                <td><%=payer_name%></td>
            </tr>  
            <tr>
                <td>결제자휴대폰</td>
                <td><%=payer_hp%></td>
            </tr>  
            <tr>
                <td>결제자이메일</td>
                <td><%=payer_email%></td>
            </tr>   

            <%if resultcode = "0000" then%>
                <tr>
                    <td>페이태그주문번호</td>
                    <td><strong><%=orderno%></strong></td>
                </tr>
                <tr>
                    <td>PG거래번호</td>
                    <td><strong><%=tranno%></strong></td>
                </tr>
                <tr>
                    <td>승인번호</td>
                    <td><strong><%=apprno%></strong></td>
                </tr>
                <tr>
                    <td>카드번호</td>
                    <td><%=cardno%></td>
                </tr>
                <tr>
                    <td>카드명</td>
                    <td><%=cardname%></td>
                </tr>
                <tr>
                    <td>할부</td>
                    <td><%=tran_inst%></td>
                </tr>
            <%end if%>
 

			</tbody>
			</table>


    	</body>
</html>


