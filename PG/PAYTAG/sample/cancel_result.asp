
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
cancelamt     = Trim( request.form("cancelamt") )		'	결제취소금액 ( PG처리금액 )
req_cancelamt = Trim( request.form("req_cancelamt") )		'	취소요청금액 ( 사용자 입력금액 )
trandate      = Trim( request.form("trandate") )		'	거래일자 ( yyyymmdd )
trantime      = Trim( request.form("trantime") )		'	거래시간 ( hhnnss )
restamt       = Trim( request.form("restamt") )		    '	취소후 잔액(취소가능금액)

shop_orderno  = Trim( request.form("shop_orderno") )	'	원거래 - 업체(가맹점) 자체 주문번호
shop_member   = Trim( request.form("shop_member") )		'	원거래 - 업체(가맹점) 자체 회원번호(아이디)
shop_field1   = Trim( request.form("shop_field1") )		'	가맹점 여유필드1
shop_field2   = Trim( request.form("shop_field2") )		'	가맹점 여유필드2
shop_field3   = Trim( request.form("shop_field3") )		'	가맹점 여유필드3

transeq       = Trim( request.form("transeq") )		    '	페이태그 취소거래 고유번호
apprno        = Trim( request.form("apprno") )		    '	원거래 - 카드사 승인번호
orderno       = Trim( request.form("orderno") )		    '	원거래 - 페이태그 주문번호
orgpaydate    = Trim( request.form("orgpaydate") )		'	원거래 - 승인일자
orgtranamt    = Trim( request.form("orgtranamt") )		'	원거래 - 승인금액
canceltype    = Trim( request.form("canceltype") )		'	취소구분 : '0'-전체취소 / '1'-부분취소
goods_name    = Trim( request.form("goods_name") )		'	주문상품명
receipt_url   = Trim( request.form("receipt_url") )		'	신용카드 영수증 url ( full path )

%>


                                       


		<%if resultcode = "0000" then%>
				<div class="alert alert-success text-center">
					<h3><strong>정상취소완료</strong></h3>
				</div>      
			   
		<%else%>       
				<div class="alert alert-danger text-center">
					<h3><strong>취소실패!!!!! <small><%=errmsg%></small></strong></h3>
				</div>                                                                                      
		<%end if%>


        <table class="table">
          <tbody>
                <tr>
                    <td>거래일자</td>
                    <td><strong><%=trandate&trantime%></strong></td>
                </tr>        
                
             <tr>
                <td>원거래-페이태그주문번호</td>
                <td><%=orderno%></td>
            </tr>                
            <tr>
                <td>원거래-상품명</td>
                <td><%=goods_name%></td>
            </tr>
            <tr>
                <td>원거래-결제금액</td>
                <td><%=formatnumber(orgtranamt, 0, -1)%></td>
            </tr>

            <tr>
                <td>원거래-승인번호</td>
                <td><%=apprno%></td>
            </tr>
            <tr>
                <td>원거래-승인일자</td>
                <td><%=orgpaydate%></td>
            </tr>

            <tr>
                <td>취소실행금액</td>
                <td><%=formatnumber(cancelamt, 0, -1)%></td>
            </tr>
  
 

			</tbody>
			</table>


    	</body>
</html>


