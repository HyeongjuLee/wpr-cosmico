
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
loginid       = Trim( request.form("loginid") )		    '	페이태그 아이디
redirect_path = Trim( request.form("redirect_path") )	'	페이태그 아이디
alert_path    = Trim( request.form("alert_path") )		'	페이태그 아이디

resultcode    = Trim( request.form("resultcode") )		'	결제결과 : '00' or '0000' - 결제성공 / 나머지는 결제실패
errmsg        = Trim( request.form("errmsg") )		'	결제실패사유
orderno       = Trim( request.form("orderno") )		'	페이태그 주문번호

orderinfo_path   = Trim( request.form("orderinfo_path") )		
orderinfo_ars   = Trim( request.form("orderinfo_ars") )		
orderinfo_expiredt   = Trim( request.form("orderinfo_expiredt") )		

vbankcode   = Trim( request.form("vbankcode") )		
vbankno   = Trim( request.form("vbankno") )		
vbankowner   = Trim( request.form("vbankowner") )		
vbankname      = Trim( request.form("vbankname") )	

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


contents_title = "정상적으로 주문서가 전달되었습니다."
fail_title = "주문서전달실패!"
if pay_method = "V" then 
    contents_title = "입금계좌가 정상발급되었습니다."
    fail_title = "입금계좌발급 실패!"
end if 
%>





                                <%if resultcode = "0000" then%>
                                        <div class="alert alert-success text-center">
                                            <h3><strong><%=contents_title%></strong></h3>
                                        </div>                                              
                                <%else%>       
                                        <div class="alert alert-danger text-center">
                                            <h3><strong><%=fail_title%> <small><%=errmsg%></small></strong></h3>
                                        </div>                                                                                     
                                <%end if%>

        <table class="table">
          <tbody>
     
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

            <%if resultcode = "0000" then%>
                <tr>
                    <td>페이태그주문번호</td>
                    <td><strong><%=orderno%></strong></td>
                </tr>
                <tr>
                    <td>주문만기일</td>
                    <td class="font-red"><strong><%=orderinfo_expiredt%></strong>
                    </td>
                </tr>

                <%
                if pay_method = "V" then 
                %>

                <tr>
                    <td>입금은행</td>
                    <td><strong><%=vbankname%></strong></td>
                </tr>
                <tr>
                    <td>계좌정보</td>
                    <td><strong><%=vbankno%> (<%=vbankowner%>)</strong></td>
                </tr>                
                <%
                end if
                %>
                <tr>
                    <td colspan="2">
                                                <ul>
<li>주문서는 <code>카카오톡</code> 또는 문자로 전송이됩니다.
<li>내용중 <code>URL로 주문서확인</code> 링크 연결 후 결제 진행이 됩니다.
<li>만기일 이후까지 미결제시는 자동 주문취소 됩니다.
</ul>                    
                    </td>
                </tr>
            <%end if%>
 
    
            </tbody>
        </table>
        



	</body>
</html>


