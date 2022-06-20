<!-- #include file = "./inc/easypay_config.asp" --> <!-- ' ȯ�漳�� ���� include -->
<!-- #include file = "./easypay_client.asp"     --> <!-- ' library [�����Ұ�] -->
<%
'/* -------------------------------------------------------------------------- */
'/* ::: ó������ ����                                                          */
'/* -------------------------------------------------------------------------- */
TRAN_CD_NOR_PAYMENT    = "00101000"   '// ����
TRAN_CD_NOR_MGR        = "00201000"   '// ����

'/* -------------------------------------------------------------------------- */
'/* ::: �÷����� �������� ����                                                 */
'/* -------------------------------------------------------------------------- */
tr_cd            = request("EP_tr_cd")            '// [�ʼ�]��û����
trace_no         = request("EP_trace_no")         '// [�ʼ�]����������ȣ
sessionkey       = request("EP_sessionkey")       '// [�ʼ�]��ȣȭŰ
encrypt_data     = request("EP_encrypt_data")     '// [�ʼ�]��ȣȭ ����Ÿ
    
pay_type         = request("EP_ret_pay_type")     '// ��������
complex_yn       = request("EP_ret_complex_yn")   '// ���հ�������
card_code        = request("EP_card_code")        '// ī���ڵ�


'/* -------------------------------------------------------------------------- */
'/* ::: ���� �ֹ� ���� ����                                                    */
'/* -------------------------------------------------------------------------- */
order_no         = request("EP_order_no")         '// [�ʼ�]�ֹ���ȣ
user_type        = request("EP_user_type")        '// [����]����ڱ��б���[1:�Ϲ�,2:ȸ��]
memb_user_no     = request("EP_memb_user_no")     '// [����]������ ���Ϸù�ȣ
user_id          = request("EP_user_id")          '// [����]�� ID
user_nm          = request("EP_user_nm")          '// [�ʼ�]����
user_mail        = request("EP_user_mail")        '// [�ʼ�]�� E-mail
user_phone1      = request("EP_user_phone1")      '// [����]������ �� ��ȭ��ȣ
user_phone2      = request("EP_user_phone2")      '// [����]������ �� �޴���
user_addr        = request("EP_user_addr")        '// [����]������ �� �ּ�
product_type     = request("EP_product_type")     '// [����]��ǰ��������[0:�ǹ�,1:������]
product_nm       = request("EP_product_nm")       '// [�ʼ�]��ǰ��
product_amt      = request("EP_product_amt")      '// [�ʼ�]��ǰ�ݾ�

'/* -------------------------------------------------------------------------- */
'/* ::: ������� ���� ����                                                     */
'/* -------------------------------------------------------------------------- */
mgr_txtype       = request("mgr_txtype")          '// [�ʼ�]�ŷ�����
mgr_subtype      = request("mgr_subtype")         '// [����]���漼�α���
org_cno          = request("org_cno")             '// [�ʼ�]���ŷ�������ȣ
mgr_amt          = request("mgr_amt")             '// [����]�κ����/ȯ�ҿ�û �ݾ�
mgr_rem_amt      = request("mgr_rem_amt")         '// [����]�κ���� �ܾ�
mgr_tax_flg      = request("mgr_tax_flg")         '// [�ʼ�]�������� �÷���(TG01:���հ��� ����ŷ�)
mgr_tax_amt      = request("mgr_tax_amt")         '// [�ʼ�]�����κ���� �ݾ�(���հ��� ���� �� �ʼ�)
mgr_free_amt     = request("mgr_free_amt")        '// [�ʼ�]������κ���� �ݾ�(���հ��� ���� �� �ʼ�)
mgr_vat_amt      = request("mgr_vat_amt")         '// [�ʼ�]�ΰ��� �κ���ұݾ�(���հ��� ���� �� �ʼ�)
mgr_bank_cd      = request("mgr_bank_cd")         '// [����]ȯ�Ұ��� �����ڵ�
mgr_account      = request("mgr_account")         '// [����]ȯ�Ұ��� ��ȣ
mgr_depositor    = request("mgr_depositor")       '// [����]ȯ�Ұ��� �����ָ�
mgr_socno        = request("mgr_socno")           '// [����]ȯ�Ұ��� �ֹι�ȣ
mgr_telno        = request("mgr_telno")           '// [����]ȯ�Ұ� ����ó
deli_cd          = request("deli_cd")             '// [����]��۱���[�ڰ�:DE01,�ù�:DE02]
deli_corp_cd     = request("deli_corp_cd")        '// [����]�ù���ڵ�
deli_invoice     = request("deli_invoice")        '// [����]����� ��ȣ
deli_rcv_nm      = request("deli_rcv_nm")         '// [����]������ �̸�
deli_rcv_tel     = request("deli_rcv_tel")        '// [����]������ ����ó
req_ip           = request("req_ip")              '// [�ʼ�]��û�� IP
req_id           = request("req_id")              '// [����]������ ������ �α��� ���̵�
mgr_msg          = request("mgr_msg")             '// [����]���� ����

'/* -------------------------------------------------------------------------- */
'/* ::: IP ���� ����                                                           */
'/* -------------------------------------------------------------------------- */
client_ip        = request.ServerVariables( "REMOTE_ADDR" )    '// [�ʼ�]������ IP

'/* -------------------------------------------------------------------------- */
'/* ::: ��û����                                                               */
'/* -------------------------------------------------------------------------- */
mgr_data    = ""     '// ��������
tx_req_data = ""     '// ��û����

'/* -------------------------------------------------------------------------- */
'/* ::: ���� ���                                                              */
'/* -------------------------------------------------------------------------- */
res_cd     = ""
res_msg    = ""

'/* -------------------------------------------------------------------------- */
'/* ::: EasyPayClient �ν��Ͻ� ���� [����Ұ� !!].                             */
'/* -------------------------------------------------------------------------- */
Set cLib = New EasyPay_Client              ' ����ó���� Class (library���� ���ǵ�)
    cLib.InitMsg

Set Easypay = Server.CreateObject( "ep_cli_com.KICC" )
'Set Easypay = Server.CreateObject( "ep_cli64_com.KICC64" ) '64bit ���
Easypay.EP_CLI_COM__init g_gw_url, g_gw_port, g_cert_file, g_log_dir, g_log_level

if TRAN_CD_NOR_PAYMENT = tr_cd then
	
	'/* ---------------------------------------------------------------------- */
    '/* ::: ���ο�û                                                           */
    '/* ---------------------------------------------------------------------- */
    Easypay.EP_CLI_COM__set_enc_data trace_no, sessionkey, encrypt_data

elseif TRAN_CD_NOR_MGR = tr_cd then
	
    '/* ---------------------------------------------------------------------- */
    '/* ::: ������� ��û                                                      */
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
'/* ::: ����                                                                   */
'/* -------------------------------------------------------------------------- */   
if tr_cd <> "" then
    tx_res_data = Easypay.EP_CLI_COM__proc ( tr_cd, g_mall_id, client_ip, order_no )    
    res_cd      = Easypay.EP_CLI_COM__get_value( "res_cd"          )    '// �����ڵ�
    res_msg     = Easypay.EP_CLI_COM__get_value( "res_msg"         )    '// ����޽���
else
    res_cd  = "M114"
    res_msg = "���� ����|tr_cd���� �������� �ʾҽ��ϴ�."
end if

'/* -------------------------------------------------------------------------- */
'/* ::: ��� ó��                                                              */
'/* -------------------------------------------------------------------------- */
r_cno             = Easypay.EP_CLI_COM__get_value( "cno"             )    '// PG�ŷ���ȣ 
r_amount          = Easypay.EP_CLI_COM__get_value( "amount"          )    '//�� �����ݾ�
r_order_no        = Easypay.EP_CLI_COM__get_value( "order_no"        )    '//�ֹ���ȣ
r_auth_no         = Easypay.EP_CLI_COM__get_value( "auth_no"         )    '//���ι�ȣ
r_tran_date       = Easypay.EP_CLI_COM__get_value( "tran_date"       )    '//�����Ͻ�
r_pnt_auth_no     = Easypay.EP_CLI_COM__get_value( "pnt_auth_no"     )    '//����Ʈ���ι�ȣ
r_pnt_tran_date   = Easypay.EP_CLI_COM__get_value( "pnt_tran_date"   )    '//����Ʈ�����Ͻ�
r_cpon_auth_no    = Easypay.EP_CLI_COM__get_value( "cpon_auth_no"    )    '//�������ι�ȣ
r_cpon_tran_date  = Easypay.EP_CLI_COM__get_value( "cpon_tran_date"  )    '//���������Ͻ�
r_card_no         = Easypay.EP_CLI_COM__get_value( "card_no"         )    '//ī���ȣ
r_issuer_cd       = Easypay.EP_CLI_COM__get_value( "issuer_cd"       )    '//�߱޻��ڵ�
r_issuer_nm       = Easypay.EP_CLI_COM__get_value( "issuer_nm"       )    '//�߱޻��
r_acquirer_cd     = Easypay.EP_CLI_COM__get_value( "acquirer_cd"     )    '//���Ի��ڵ�
r_acquirer_nm     = Easypay.EP_CLI_COM__get_value( "acquirer_nm"     )    '//���Ի��
r_install_period  = Easypay.EP_CLI_COM__get_value( "install_period"  )    '//�Һΰ���
r_noint           = Easypay.EP_CLI_COM__get_value( "noint"           )    '//�����ڿ���
r_bank_cd         = Easypay.EP_CLI_COM__get_value( "bank_cd"         )    '//�����ڵ�
r_bank_nm         = Easypay.EP_CLI_COM__get_value( "bank_nm"         )    '//�����
r_account_no      = Easypay.EP_CLI_COM__get_value( "account_no"      )    '//���¹�ȣ
r_deposit_nm      = Easypay.EP_CLI_COM__get_value( "deposit_nm"      )    '//�Ա��ڸ�
r_expire_date     = Easypay.EP_CLI_COM__get_value( "expire_date"     )    '//���»�븸����
r_cash_res_cd     = Easypay.EP_CLI_COM__get_value( "cash_res_cd"     )    '//���ݿ����� ����ڵ�
r_cash_res_msg    = Easypay.EP_CLI_COM__get_value( "cash_res_msg"    )    '//���ݿ����� ����޼���
r_cash_auth_no    = Easypay.EP_CLI_COM__get_value( "cash_auth_no"    )    '//���ݿ����� ���ι�ȣ
r_cash_tran_date  = Easypay.EP_CLI_COM__get_value( "cash_tran_date"  )    '//���ݿ����� �����Ͻ�
r_auth_id         = Easypay.EP_CLI_COM__get_value( "auth_id"         )    '//PhoneID
r_billid          = Easypay.EP_CLI_COM__get_value( "billid"          )    '//������ȣ
r_mobile_no       = Easypay.EP_CLI_COM__get_value( "mobile_no"       )    '//�޴�����ȣ
r_ars_no          = Easypay.EP_CLI_COM__get_value( "ars_no"          )    '//��ȭ��ȣ
r_cp_cd           = Easypay.EP_CLI_COM__get_value( "cp_cd"           )    '//����Ʈ��/������
r_used_pnt        = Easypay.EP_CLI_COM__get_value( "used_pnt"        )    '//�������Ʈ
r_remain_pnt      = Easypay.EP_CLI_COM__get_value( "remain_pnt"      )    '//�ܿ��ѵ�
r_pay_pnt         = Easypay.EP_CLI_COM__get_value( "pay_pnt"         )    '//����/�߻�����Ʈ
r_accrue_pnt      = Easypay.EP_CLI_COM__get_value( "accrue_pnt"      )    '//��������Ʈ
r_remain_cpon     = Easypay.EP_CLI_COM__get_value( "remain_cpon"     )    '//�����ܾ�
r_used_cpon       = Easypay.EP_CLI_COM__get_value( "used_cpon"       )    '//���� ���ݾ�
r_mall_nm         = Easypay.EP_CLI_COM__get_value( "mall_nm"         )    '//���޻��Ī
r_escrow_yn       = Easypay.EP_CLI_COM__get_value( "escrow_yn"       )    '//����ũ�� �������
r_complex_yn      = Easypay.EP_CLI_COM__get_value( "complex_yn"      )    '//���հ��� ����
r_canc_acq_date   = Easypay.EP_CLI_COM__get_value( "canc_acq_date"   )    '//��������Ͻ�
r_canc_date       = Easypay.EP_CLI_COM__get_value( "canc_date"       )    '//����Ͻ�
r_refund_date     = Easypay.EP_CLI_COM__get_value( "refund_date"     )    '//ȯ�ҿ����Ͻ�    


'/* -------------------------------------------------------------------------- */
'/* ::: ������ DB ó��                                                         */
'/* -------------------------------------------------------------------------- */
'/* �����ڵ�(res_cd)�� "0000" �̸� ������� �Դϴ�.                            */
'/* r_amount�� �ֹ�DB�� �ݾװ� �ٸ� �� �ݵ�� ��� ��û�� �Ͻñ� �ٶ��ϴ�.     */
'/* DB ó�� ���� �� ��� ó���� ���ֽñ� �ٶ��ϴ�.                             */
'/* -------------------------------------------------------------------------- */

if res_cd = "0000" then 
	   
    bDBProc = "true"     '// DBó�� ���� �� "true", ���� �� "false"
    
    if bDBProc = "false" then
    
        '// ���ο�û�� ���� �� �Ʒ� ����
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
            mgr_data = cLib.SetValue( "mgr_msg",       "DB ó�� ���з� �����", chr(31) )
            
            mgr_data = cLib.SetDelim( chr(28) )
            cLib.InitMsg
            
            Easypay.EP_CLI_COM__init g_gw_url, g_gw_port, g_cert_file, g_log_dir, g_log_level
            Easypay.EP_CLI_COM__set_plan_data mgr_data
            
            tx_res_data = Easypay.EP_CLI_COM__proc ( tr_cd, g_mall_id, client_ip, order_no )    
            res_cd      = Easypay.EP_CLI_COM__get_value( "res_cd"          )    '// �����ڵ�
            res_msg     = Easypay.EP_CLI_COM__get_value( "res_msg"         )    '// ����޽���    
            r_cno       = Easypay.EP_CLI_COM__get_value( "cno"             )    '// PG�ŷ���ȣ 
            r_canc_date = Easypay.EP_CLI_COM__get_value( "canc_date"       )    '//����Ͻ�    
        
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
    <input type="hidden" name="res_cd"          value="<%=res_cd%>">          <!-- ����ڵ� //-->
    <input type="hidden" name="res_msg"         value="<%=res_msg%>">         <!-- ����޽��� //-->
    <input type="hidden" name="order_no"        value="<%=order_no%>">        <!-- �ֹ���ȣ //-->
    <input type="hidden" name="cno"             value="<%=r_cno%>">           <!-- PG�ŷ���ȣ //-->
    
    <input type="hidden" name="amount"          value="<%=r_amount%>">          <!-- �� �����ݾ� //-->
    <input type="hidden" name="auth_no"         value="<%=r_auth_no%>">         <!-- ���ι�ȣ //-->
    <input type="hidden" name="tran_date"       value="<%=r_tran_date%>">       <!-- �ŷ��Ͻ� //-->
    <input type="hidden" name="pnt_auth_no"     value="<%=r_pnt_auth_no%>">     <!-- ����Ʈ ���� ��ȣ //-->
    <input type="hidden" name="pnt_tran_date"   value="<%=r_pnt_tran_date%>">   <!-- ����Ʈ ���� �Ͻ� //-->
    <input type="hidden" name="cpon_auth_no"    value="<%=r_cpon_auth_no%>">    <!-- ���� ���� ��ȣ //-->
    <input type="hidden" name="cpon_tran_date"  value="<%=r_cpon_tran_date%>">  <!-- ���� ���� �Ͻ� //-->
    <input type="hidden" name="card_no"         value="<%=r_card_no%>">         <!-- ī���ȣ //-->
    <input type="hidden" name="issuer_cd"       value="<%=r_issuer_cd%>">       <!-- �߱޻��ڵ� //-->
    <input type="hidden" name="issuer_nm"       value="<%=r_issuer_nm%>">       <!-- �߱޻�� //-->
    <input type="hidden" name="acquirer_cd"     value="<%=r_acquirer_cd%>">     <!-- ���Ի��ڵ� //-->
    <input type="hidden" name="acquirer_nm"     value="<%=r_acquirer_nm%>">     <!-- ���Ի�� //-->
    <input type="hidden" name="install_period"  value="<%=r_install_period%>">  <!-- �Һΰ��� //-->
    <input type="hidden" name="noint"           value="<%=r_noint%>">           <!-- �����ڿ��� //-->
    <input type="hidden" name="bank_cd"         value="<%=r_bank_cd%>">         <!-- �����ڵ� //-->
    <input type="hidden" name="bank_nm"         value="<%=r_bank_nm%>">         <!-- ����� //-->
    <input type="hidden" name="account_no"      value="<%=r_account_no%>">      <!-- ���¹�ȣ //-->
    <input type="hidden" name="deposit_nm"      value="<%=r_deposit_nm%>">      <!-- �Ա��ڸ� //-->
    <input type="hidden" name="expire_date"     value="<%=r_expire_date%>">     <!-- ���»�븸���Ͻ� //-->
    <input type="hidden" name="cash_res_cd"     value="<%=r_cash_res_cd%>">     <!-- ���ݿ����� ����ڵ� //-->
    <input type="hidden" name="cash_res_msg"    value="<%=r_cash_res_msg%>">    <!-- ���ݿ����� ����޼��� //-->
    <input type="hidden" name="cash_auth_no"    value="<%=r_cash_auth_no%>">    <!-- ���ݿ����� ���ι�ȣ //-->
    <input type="hidden" name="cash_tran_date"  value="<%=r_cash_tran_date%>">  <!-- ���ݿ����� �����Ͻ� //-->
    <input type="hidden" name="auth_id"         value="<%=r_auth_id%>">         <!-- PhoneID //-->
    <input type="hidden" name="billid"          value="<%=r_billid%>">          <!-- ������ȣ //-->
    <input type="hidden" name="mobile_no"       value="<%=r_mobile_no%>">       <!-- �޴�����ȣ //-->
    <input type="hidden" name="ars_no"          value="<%=r_ars_no%>">          <!-- ARS ��ȭ��ȣ //-->
    <input type="hidden" name="cp_cd"           value="<%=r_cp_cd%>">           <!-- ����Ʈ�� //-->
    <input type="hidden" name="used_pnt"        value="<%=r_used_pnt%>">        <!-- �������Ʈ //-->
    <input type="hidden" name="remain_pnt"      value="<%=r_remain_pnt%>">      <!-- �ܿ��ѵ� //-->
    <input type="hidden" name="pay_pnt"         value="<%=r_pay_pnt%>">         <!-- ����/�߻�����Ʈ //-->
    <input type="hidden" name="accrue_pnt"      value="<%=r_accrue_pnt%>">      <!-- ��������Ʈ //-->
    <input type="hidden" name="remain_cpon"     value="<%=r_remain_cpon%>">     <!-- �����ܾ� //-->
    <input type="hidden" name="used_cpon"       value="<%=r_used_cpon%>">       <!-- ���� ���ݾ� //-->
    <input type="hidden" name="mall_nm"         value="<%=r_mall_nm%>">         <!-- ���޻��Ī //-->
    <input type="hidden" name="escrow_yn"       value="<%=r_escrow_yn%>">       <!-- ����ũ�� ������� //-->
    <input type="hidden" name="complex_yn"      value="<%=r_complex_yn%>">      <!-- ���հ��� ���� //-->
    <input type="hidden" name="canc_acq_date"   value="<%=r_canc_acq_date%>">   <!-- ��������Ͻ� //-->
    <input type="hidden" name="canc_date"       value="<%=r_canc_date%>">       <!-- ����Ͻ� //-->
    <input type="hidden" name="refund_date"     value="<%=r_refund_date%>">     <!-- ȯ�ҿ����Ͻ� //-->
    <input type="hidden" name="pay_type"        value="<%=pay_type%>">          <!-- �������� //-->
    
    <input type="hidden" name="gw_url"          value="<%=g_gw_url%>">          <!--  //-->
    <input type="hidden" name="gw_port"         value="<%=g_gw_port%>">         <!--  //-->
</form>
</body>
</html>