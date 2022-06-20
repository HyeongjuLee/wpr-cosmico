<!-- #include file = "./inc/easypay_config.asp" --> <!-- ' 환경설정 파일 include -->
<!-- #include file = "./easypay_client.asp"     --> <!-- ' library [수정불가] -->
<%
'/* -------------------------------------------------------------------------- */
'/* ::: 처리구분 설정                                                          */
'/* -------------------------------------------------------------------------- */
TRAN_CD_NOR_PAYMENT    = "00101000"   '// 승인
TRAN_CD_NOR_MGR        = "00201000"   '// 변경

'/* -------------------------------------------------------------------------- */
'/* ::: 플러그인 응답정보 설정                                                 */
'/* -------------------------------------------------------------------------- */
tr_cd            = request("EP_tr_cd")            '// [필수]요청구분
trace_no         = request("EP_trace_no")         '// [필수]추적고유번호
sessionkey       = request("EP_sessionkey")       '// [필수]암호화키
encrypt_data     = request("EP_encrypt_data")     '// [필수]암호화 데이타
    
pay_type         = request("EP_ret_pay_type")     '// 결제수단
complex_yn       = request("EP_ret_complex_yn")   '// 복합결제유무
card_code        = request("EP_card_code")        '// 카드코드


'/* -------------------------------------------------------------------------- */
'/* ::: 결제 주문 정보 설정                                                    */
'/* -------------------------------------------------------------------------- */
order_no         = request("EP_order_no")         '// [필수]주문번호
user_type        = request("EP_user_type")        '// [선택]사용자구분구분[1:일반,2:회원]
memb_user_no     = request("EP_memb_user_no")     '// [선택]가맹점 고객일련번호
user_id          = request("EP_user_id")          '// [선택]고객 ID
user_nm          = request("EP_user_nm")          '// [필수]고객명
user_mail        = request("EP_user_mail")        '// [필수]고객 E-mail
user_phone1      = request("EP_user_phone1")      '// [선택]가맹점 고객 전화번호
user_phone2      = request("EP_user_phone2")      '// [선택]가맹점 고객 휴대폰
user_addr        = request("EP_user_addr")        '// [선택]가맹점 고객 주소
product_type     = request("EP_product_type")     '// [선택]상품정보구분[0:실물,1:컨텐츠]
product_nm       = request("EP_product_nm")       '// [필수]상품명
product_amt      = request("EP_product_amt")      '// [필수]상품금액

'/* -------------------------------------------------------------------------- */
'/* ::: 변경관리 정보 설정                                                     */
'/* -------------------------------------------------------------------------- */
mgr_txtype       = request("mgr_txtype")          '// [필수]거래구분
mgr_subtype      = request("mgr_subtype")         '// [선택]변경세부구분
org_cno          = request("org_cno")             '// [필수]원거래고유번호
mgr_amt          = request("mgr_amt")             '// [선택]부분취소/환불요청 금액
mgr_rem_amt      = request("mgr_rem_amt")         '// [선택]부분취소 잔액
mgr_tax_flg      = request("mgr_tax_flg")         '// [필수]과세구분 플래그(TG01:복합과세 변경거래)
mgr_tax_amt      = request("mgr_tax_amt")         '// [필수]과세부분취소 금액(복합과세 변경 시 필수)
mgr_free_amt     = request("mgr_free_amt")        '// [필수]비과세부분취소 금액(복합과세 변경 시 필수)
mgr_vat_amt      = request("mgr_vat_amt")         '// [필수]부가세 부분취소금액(복합과세 변경 시 필수)
mgr_bank_cd      = request("mgr_bank_cd")         '// [선택]환불계좌 은행코드
mgr_account      = request("mgr_account")         '// [선택]환불계좌 번호
mgr_depositor    = request("mgr_depositor")       '// [선택]환불계좌 예금주명
mgr_socno        = request("mgr_socno")           '// [선택]환불계좌 주민번호
mgr_telno        = request("mgr_telno")           '// [선택]환불고객 연락처
deli_cd          = request("deli_cd")             '// [선택]배송구분[자가:DE01,택배:DE02]
deli_corp_cd     = request("deli_corp_cd")        '// [선택]택배사코드
deli_invoice     = request("deli_invoice")        '// [선택]운송장 번호
deli_rcv_nm      = request("deli_rcv_nm")         '// [선택]수령인 이름
deli_rcv_tel     = request("deli_rcv_tel")        '// [선택]수령인 연락처
req_ip           = request("req_ip")              '// [필수]요청자 IP
req_id           = request("req_id")              '// [선택]가맹점 관리자 로그인 아이디
mgr_msg          = request("mgr_msg")             '// [선택]변경 사유

'/* -------------------------------------------------------------------------- */
'/* ::: IP 정보 설정                                                           */
'/* -------------------------------------------------------------------------- */
client_ip        = request.ServerVariables( "REMOTE_ADDR" )    '// [필수]결제고객 IP

'/* -------------------------------------------------------------------------- */
'/* ::: 요청전문                                                               */
'/* -------------------------------------------------------------------------- */
mgr_data    = ""     '// 변경정보
tx_req_data = ""     '// 요청전문

'/* -------------------------------------------------------------------------- */
'/* ::: 결제 결과                                                              */
'/* -------------------------------------------------------------------------- */
res_cd     = ""
res_msg    = ""

'/* -------------------------------------------------------------------------- */
'/* ::: EasyPayClient 인스턴스 생성 [변경불가 !!].                             */
'/* -------------------------------------------------------------------------- */
Set cLib = New EasyPay_Client              ' 전문처리용 Class (library에서 정의됨)
    cLib.InitMsg

Set Easypay = Server.CreateObject( "ep_cli_com.KICC" )
'Set Easypay = Server.CreateObject( "ep_cli64_com.KICC64" ) '64bit 경우
Easypay.EP_CLI_COM__init g_gw_url, g_gw_port, g_cert_file, g_log_dir, g_log_level

if TRAN_CD_NOR_PAYMENT = tr_cd then
	
	'/* ---------------------------------------------------------------------- */
    '/* ::: 승인요청                                                           */
    '/* ---------------------------------------------------------------------- */
    Easypay.EP_CLI_COM__set_enc_data trace_no, sessionkey, encrypt_data

elseif TRAN_CD_NOR_MGR = tr_cd then
	
    '/* ---------------------------------------------------------------------- */
    '/* ::: 변경관리 요청                                                      */
    '/* ---------------------------------------------------------------------- */
    mgr_data = cLib.SetEntry( "mgr_data" )
    mgr_data = cLib.SetValue( "mgr_txtype",    mgr_txtype,    chr(31) )
    mgr_data = cLib.SetValue( "mgr_subtype",   mgr_subtype,   chr(31) )
    mgr_data = cLib.SetValue( "org_cno",       org_cno,       chr(31) )
    mgr_data = cLib.SetValue( "order_no",      order_no,      chr(31) )
    mgr_data = cLib.SetValue( "pay_type",      pay_type,      chr(31) )
    mgr_data = cLib.SetValue( "mgr_amt",       mgr_amt,       chr(31) )
    mgr_data = cLib.SetValue( "mgr_rem_amt",   mgr_rem_amt,   chr(31) )
    mgr_data = cLib.SetValue( "mgr_tax_flg",   mgr_tax_flg,   chr(31) )
    mgr_data = cLib.SetValue( "mgr_tax_amt",   mgr_tax_amt,   chr(31) )
    mgr_data = cLib.SetValue( "mgr_free_amt",  mgr_free_amt,  chr(31) )
    mgr_data = cLib.SetValue( "mgr_vat_amt",   mgr_vat_amt,   chr(31) )
    mgr_data = cLib.SetValue( "mgr_bank_cd",   mgr_bank_cd,   chr(31) )
    mgr_data = cLib.SetValue( "mgr_account",   mgr_account,   chr(31) )
    mgr_data = cLib.SetValue( "mgr_depositor", mgr_depositor, chr(31) )
    mgr_data = cLib.SetValue( "mgr_socno",     mgr_socno,     chr(31) )
    mgr_data = cLib.SetValue( "mgr_telno",     mgr_telno,     chr(31) )
    mgr_data = cLib.SetValue( "deli_cd",       deli_cd,       chr(31) )
    mgr_data = cLib.SetValue( "deli_corp_cd",  deli_corp_cd,  chr(31) )
    mgr_data = cLib.SetValue( "deli_invoice",  deli_invoice,  chr(31) )
    mgr_data = cLib.SetValue( "deli_rcv_nm",   deli_rcv_nm,   chr(31) )
    mgr_data = cLib.SetValue( "deli_rcv_tel",  deli_rcv_tel,  chr(31) )        
    mgr_data = cLib.SetValue( "req_ip",        client_ip,     chr(31) )
    mgr_data = cLib.SetValue( "req_id",        req_id,        chr(31) )         
    mgr_data = cLib.SetValue( "mgr_msg",       mgr_msg,       chr(31) )
    mgr_data = cLib.SetDelim( chr(28) )
    cLib.InitMsg
    
    Easypay.EP_CLI_COM__set_plan_data mgr_data
    
end if

'/* -------------------------------------------------------------------------- */
'/* ::: 실행                                                                   */
'/* -------------------------------------------------------------------------- */   
if tr_cd <> "" then
    tx_res_data = Easypay.EP_CLI_COM__proc ( tr_cd, g_mall_id, client_ip, order_no )    
    res_cd      = Easypay.EP_CLI_COM__get_value( "res_cd"          )    '// 응답코드
    res_msg     = Easypay.EP_CLI_COM__get_value( "res_msg"         )    '// 응답메시지
else
    res_cd  = "M114"
    res_msg = "연동 오류|tr_cd값이 설정되지 않았습니다."
end if

'/* -------------------------------------------------------------------------- */
'/* ::: 결과 처리                                                              */
'/* -------------------------------------------------------------------------- */
r_cno             = Easypay.EP_CLI_COM__get_value( "cno"             )    '// PG거래번호 
r_amount          = Easypay.EP_CLI_COM__get_value( "amount"          )    '//총 결제금액
r_order_no        = Easypay.EP_CLI_COM__get_value( "order_no"        )    '//주문번호
r_auth_no         = Easypay.EP_CLI_COM__get_value( "auth_no"         )    '//승인번호
r_tran_date       = Easypay.EP_CLI_COM__get_value( "tran_date"       )    '//승인일시
r_pnt_auth_no     = Easypay.EP_CLI_COM__get_value( "pnt_auth_no"     )    '//포인트승인번호
r_pnt_tran_date   = Easypay.EP_CLI_COM__get_value( "pnt_tran_date"   )    '//포인트승인일시
r_cpon_auth_no    = Easypay.EP_CLI_COM__get_value( "cpon_auth_no"    )    '//쿠폰승인번호
r_cpon_tran_date  = Easypay.EP_CLI_COM__get_value( "cpon_tran_date"  )    '//쿠폰승인일시
r_card_no         = Easypay.EP_CLI_COM__get_value( "card_no"         )    '//카드번호
r_issuer_cd       = Easypay.EP_CLI_COM__get_value( "issuer_cd"       )    '//발급사코드
r_issuer_nm       = Easypay.EP_CLI_COM__get_value( "issuer_nm"       )    '//발급사명
r_acquirer_cd     = Easypay.EP_CLI_COM__get_value( "acquirer_cd"     )    '//매입사코드
r_acquirer_nm     = Easypay.EP_CLI_COM__get_value( "acquirer_nm"     )    '//매입사명
r_install_period  = Easypay.EP_CLI_COM__get_value( "install_period"  )    '//할부개월
r_noint           = Easypay.EP_CLI_COM__get_value( "noint"           )    '//무이자여부
r_bank_cd         = Easypay.EP_CLI_COM__get_value( "bank_cd"         )    '//은행코드
r_bank_nm         = Easypay.EP_CLI_COM__get_value( "bank_nm"         )    '//은행명
r_account_no      = Easypay.EP_CLI_COM__get_value( "account_no"      )    '//계좌번호
r_deposit_nm      = Easypay.EP_CLI_COM__get_value( "deposit_nm"      )    '//입금자명
r_expire_date     = Easypay.EP_CLI_COM__get_value( "expire_date"     )    '//계좌사용만료일
r_cash_res_cd     = Easypay.EP_CLI_COM__get_value( "cash_res_cd"     )    '//현금영수증 결과코드
r_cash_res_msg    = Easypay.EP_CLI_COM__get_value( "cash_res_msg"    )    '//현금영수증 결과메세지
r_cash_auth_no    = Easypay.EP_CLI_COM__get_value( "cash_auth_no"    )    '//현금영수증 승인번호
r_cash_tran_date  = Easypay.EP_CLI_COM__get_value( "cash_tran_date"  )    '//현금영수증 승인일시
r_auth_id         = Easypay.EP_CLI_COM__get_value( "auth_id"         )    '//PhoneID
r_billid          = Easypay.EP_CLI_COM__get_value( "billid"          )    '//인증번호
r_mobile_no       = Easypay.EP_CLI_COM__get_value( "mobile_no"       )    '//휴대폰번호
r_ars_no          = Easypay.EP_CLI_COM__get_value( "ars_no"          )    '//전화번호
r_cp_cd           = Easypay.EP_CLI_COM__get_value( "cp_cd"           )    '//포인트사/쿠폰사
r_used_pnt        = Easypay.EP_CLI_COM__get_value( "used_pnt"        )    '//사용포인트
r_remain_pnt      = Easypay.EP_CLI_COM__get_value( "remain_pnt"      )    '//잔여한도
r_pay_pnt         = Easypay.EP_CLI_COM__get_value( "pay_pnt"         )    '//할인/발생포인트
r_accrue_pnt      = Easypay.EP_CLI_COM__get_value( "accrue_pnt"      )    '//누적포인트
r_remain_cpon     = Easypay.EP_CLI_COM__get_value( "remain_cpon"     )    '//쿠폰잔액
r_used_cpon       = Easypay.EP_CLI_COM__get_value( "used_cpon"       )    '//쿠폰 사용금액
r_mall_nm         = Easypay.EP_CLI_COM__get_value( "mall_nm"         )    '//제휴사명칭
r_escrow_yn       = Easypay.EP_CLI_COM__get_value( "escrow_yn"       )    '//에스크로 사용유무
r_complex_yn      = Easypay.EP_CLI_COM__get_value( "complex_yn"      )    '//복합결제 유무
r_canc_acq_date   = Easypay.EP_CLI_COM__get_value( "canc_acq_date"   )    '//매입취소일시
r_canc_date       = Easypay.EP_CLI_COM__get_value( "canc_date"       )    '//취소일시
r_refund_date     = Easypay.EP_CLI_COM__get_value( "refund_date"     )    '//환불예정일시    


'/* -------------------------------------------------------------------------- */
'/* ::: 가맹점 DB 처리                                                         */
'/* -------------------------------------------------------------------------- */
'/* 응답코드(res_cd)가 "0000" 이면 정상승인 입니다.                            */
'/* r_amount가 주문DB의 금액과 다를 시 반드시 취소 요청을 하시기 바랍니다.     */
'/* DB 처리 실패 시 취소 처리를 해주시기 바랍니다.                             */
'/* -------------------------------------------------------------------------- */

if res_cd = "0000" then 
	   
    bDBProc = "true"     '// DB처리 성공 시 "true", 실패 시 "false"
    
    if bDBProc = "false" then
    
        '// 승인요청이 실패 시 아래 실행
        if TRAN_CD_NOR_PAYMENT = tr_cd then
        	
            tr_cd = TRAN_CD_NOR_MGR
            cLib.InitMsg
            
            mgr_data = cLib.SetEntry( "mgr_data" )
            
            if  r_escrow_yn <> "Y" then
                mgr_data = cLib.SetValue( "mgr_txtype",    "40",   chr(31) )
            else
            	mgr_data = cLib.SetValue( "mgr_txtype",    "61",   chr(31) )
                mgr_data = cLib.SetValue( "mgr_subtype",   "ES02", chr(31) )
            end if
            
            mgr_data = cLib.SetValue( "org_cno",       r_cno,    chr(31) )
            mgr_data = cLib.SetValue( "order_no",      order_no, chr(31) )
            mgr_data = cLib.SetValue( "req_ip",        client_ip, chr(31) )
            mgr_data = cLib.SetValue( "req_id",        "MALL_R_TRANS", chr(31) )
            mgr_data = cLib.SetValue( "mgr_msg",       "DB 처리 실패로 망취소", chr(31) )
            
            mgr_data = cLib.SetDelim( chr(28) )
            cLib.InitMsg
            
            Easypay.EP_CLI_COM__init g_gw_url, g_gw_port, g_cert_file, g_log_dir, g_log_level
            Easypay.EP_CLI_COM__set_plan_data mgr_data
            
            tx_res_data = Easypay.EP_CLI_COM__proc ( tr_cd, g_mall_id, client_ip, order_no )    
            res_cd      = Easypay.EP_CLI_COM__get_value( "res_cd"          )    '// 응답코드
            res_msg     = Easypay.EP_CLI_COM__get_value( "res_msg"         )    '// 응답메시지    
            r_cno       = Easypay.EP_CLI_COM__get_value( "cno"             )    '// PG거래번호 
            r_canc_date = Easypay.EP_CLI_COM__get_value( "canc_date"       )    '//취소일시    
        
        end if
    end if
 
 end if
 
'/* -------------------------------------------------------------------------- */
'/* ::: Library Cleanup                                                        */
'/* -------------------------------------------------------------------------- */
Easypay.EP_CLI_COM__cleanup
set Easypay = nothing
set cLib = nothing
             
%>
<html>
<meta name="robots" content="noindex, nofollow"> 
<script type="text/javascript">
    function f_submit(){
        document.frm.submit();
    }
</script>

<body onload="f_submit();">
<form name="frm" method="post" action="./result.asp">
    <input type="hidden" name="res_cd"          value="<%=res_cd%>">          <!-- 결과코드 //-->
    <input type="hidden" name="res_msg"         value="<%=res_msg%>">         <!-- 결과메시지 //-->
    <input type="hidden" name="order_no"        value="<%=order_no%>">        <!-- 주문번호 //-->
    <input type="hidden" name="cno"             value="<%=r_cno%>">           <!-- PG거래번호 //-->
    
    <input type="hidden" name="amount"          value="<%=r_amount%>">          <!-- 총 결제금액 //-->
    <input type="hidden" name="auth_no"         value="<%=r_auth_no%>">         <!-- 승인번호 //-->
    <input type="hidden" name="tran_date"       value="<%=r_tran_date%>">       <!-- 거래일시 //-->
    <input type="hidden" name="pnt_auth_no"     value="<%=r_pnt_auth_no%>">     <!-- 포인트 승인 번호 //-->
    <input type="hidden" name="pnt_tran_date"   value="<%=r_pnt_tran_date%>">   <!-- 포인트 승인 일시 //-->
    <input type="hidden" name="cpon_auth_no"    value="<%=r_cpon_auth_no%>">    <!-- 쿠폰 승인 번호 //-->
    <input type="hidden" name="cpon_tran_date"  value="<%=r_cpon_tran_date%>">  <!-- 쿠폰 승인 일시 //-->
    <input type="hidden" name="card_no"         value="<%=r_card_no%>">         <!-- 카드번호 //-->
    <input type="hidden" name="issuer_cd"       value="<%=r_issuer_cd%>">       <!-- 발급사코드 //-->
    <input type="hidden" name="issuer_nm"       value="<%=r_issuer_nm%>">       <!-- 발급사명 //-->
    <input type="hidden" name="acquirer_cd"     value="<%=r_acquirer_cd%>">     <!-- 매입사코드 //-->
    <input type="hidden" name="acquirer_nm"     value="<%=r_acquirer_nm%>">     <!-- 매입사명 //-->
    <input type="hidden" name="install_period"  value="<%=r_install_period%>">  <!-- 할부개월 //-->
    <input type="hidden" name="noint"           value="<%=r_noint%>">           <!-- 무이자여부 //-->
    <input type="hidden" name="bank_cd"         value="<%=r_bank_cd%>">         <!-- 은행코드 //-->
    <input type="hidden" name="bank_nm"         value="<%=r_bank_nm%>">         <!-- 은행명 //-->
    <input type="hidden" name="account_no"      value="<%=r_account_no%>">      <!-- 계좌번호 //-->
    <input type="hidden" name="deposit_nm"      value="<%=r_deposit_nm%>">      <!-- 입금자명 //-->
    <input type="hidden" name="expire_date"     value="<%=r_expire_date%>">     <!-- 계좌사용만료일시 //-->
    <input type="hidden" name="cash_res_cd"     value="<%=r_cash_res_cd%>">     <!-- 현금영수증 결과코드 //-->
    <input type="hidden" name="cash_res_msg"    value="<%=r_cash_res_msg%>">    <!-- 현금영수증 결과메세지 //-->
    <input type="hidden" name="cash_auth_no"    value="<%=r_cash_auth_no%>">    <!-- 현금영수증 승인번호 //-->
    <input type="hidden" name="cash_tran_date"  value="<%=r_cash_tran_date%>">  <!-- 현금영수증 승인일시 //-->
    <input type="hidden" name="auth_id"         value="<%=r_auth_id%>">         <!-- PhoneID //-->
    <input type="hidden" name="billid"          value="<%=r_billid%>">          <!-- 인증번호 //-->
    <input type="hidden" name="mobile_no"       value="<%=r_mobile_no%>">       <!-- 휴대폰번호 //-->
    <input type="hidden" name="ars_no"          value="<%=r_ars_no%>">          <!-- ARS 전화번호 //-->
    <input type="hidden" name="cp_cd"           value="<%=r_cp_cd%>">           <!-- 포인트사 //-->
    <input type="hidden" name="used_pnt"        value="<%=r_used_pnt%>">        <!-- 사용포인트 //-->
    <input type="hidden" name="remain_pnt"      value="<%=r_remain_pnt%>">      <!-- 잔여한도 //-->
    <input type="hidden" name="pay_pnt"         value="<%=r_pay_pnt%>">         <!-- 할인/발생포인트 //-->
    <input type="hidden" name="accrue_pnt"      value="<%=r_accrue_pnt%>">      <!-- 누적포인트 //-->
    <input type="hidden" name="remain_cpon"     value="<%=r_remain_cpon%>">     <!-- 쿠폰잔액 //-->
    <input type="hidden" name="used_cpon"       value="<%=r_used_cpon%>">       <!-- 쿠폰 사용금액 //-->
    <input type="hidden" name="mall_nm"         value="<%=r_mall_nm%>">         <!-- 제휴사명칭 //-->
    <input type="hidden" name="escrow_yn"       value="<%=r_escrow_yn%>">       <!-- 에스크로 사용유무 //-->
    <input type="hidden" name="complex_yn"      value="<%=r_complex_yn%>">      <!-- 복합결제 유무 //-->
    <input type="hidden" name="canc_acq_date"   value="<%=r_canc_acq_date%>">   <!-- 매입취소일시 //-->
    <input type="hidden" name="canc_date"       value="<%=r_canc_date%>">       <!-- 취소일시 //-->
    <input type="hidden" name="refund_date"     value="<%=r_refund_date%>">     <!-- 환불예정일시 //-->
    <input type="hidden" name="pay_type"        value="<%=pay_type%>">          <!-- 결제수단 //-->
    
    <input type="hidden" name="gw_url"          value="<%=g_gw_url%>">          <!--  //-->
    <input type="hidden" name="gw_port"         value="<%=g_gw_port%>">         <!--  //-->
</form>
</body>
</html>