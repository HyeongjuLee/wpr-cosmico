<html>
<title>KICC EASYPAY7.0 SAMPLE</title>
<meta name="robots" content="noindex, nofollow"> 
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link href="./css/style.css" rel="stylesheet" type="text/css">
<script language="javascript" src="./js/default.js" type="text/javascript"></script>
<%
res_cd			= request("res_cd")
res_msg			= request("res_msg")
cno				= request("cno")
amount			= request("amount")
msg_type		= request("msg_type")
order_no		= request("order_no")
auth_no			= request("auth_no")
tran_date		= request("tran_date")
pnt_auth_no		= request("pnt_auth_no")
pnt_tran_date	= request("pnt_tran_date")
cpon_auth_no	= request("cpon_auth_no")
cpon_tran_date	= request("cpon_tran_date")
card_no			= request("card_no")
issuer_cd		= request("issuer_cd")
issuer_nm		= request("issuer_nm")
acquirer_cd		= request("acquirer_cd")
acquirer_nm		= request("acquirer_nm")
install_period	= request("install_period")
noint			= request("noint")
bank_cd			= request("bank_cd")
bank_nm			= request("bank_nm")
account_no		= request("account_no")
deposit_nm		= request("deposit_nm")
expire_date		= request("expire_date")
vacct_rt_val	= request("vacct_rt_val")
cash_res_cd		= request("cash_res_cd")
cash_res_msg	= request("cash_res_msg")
cash_auth_no	= request("cash_auth_no")
cash_tran_date	= request("cash_tran_date")
auth_id			= request("auth_id")
billid			= request("billid")
mobile_no		= request("mobile_no")
ars_no			= request("ars_no")
cp_cd			= request("cp_cd")
used_pnt		= request("used_pnt")
remain_pnt		= request("remain_pnt")
pay_pnt			= request("pay_pnt")
accrue_pnt		= request("accrue_pnt")
remain_cpon		= request("remain_cpon")
used_cpon		= request("used_cpon")
mall_nm			= request("mall_nm")
escrow_yn		= request("escrow_yn")
complex_yn		= request("complex_yn")
canc_acq_date	= request("canc_acq_date")
canc_date		= request("canc_date")
refund_date		= request("refund_date")
pay_type		= request("pay_type")
gw_url			= request("gw_url")
gw_port			= request("gw_port")
	
gw_name = ""
	if "testgw.easypay.co.kr" = gw_url then
	    gw_name = "�׽�Ʈ"
    elseif "gw.easypay.co.kr" = gw_url then
        gw_name = "����"
    end if
%>
<body> 
<table border="0" width="910" cellpadding="10" cellspacing="0">
<tr>
    <td>
    <table border="0" width="900" cellpadding="0" cellspacing="0">
	<tr>
		<td height="30" bgcolor="#FFFFFF" align="left">&nbsp;<img src="./img/arow3.gif" border="0" align="absmiddle">&nbsp;<b>���</b></td>
	</tr>
	<tr>
		<td height="2" bgcolor="#2D4677"></td>
	</tr>
	</table>
	<table border="0" width="900" cellpadding="0" cellspacing="0">
	<tr>
		<td height="5"></td>
	</tr>
	</table>
    <table border="0" width="900" cellpadding="0" cellspacing="1" bgcolor="#DCDCDC">
    <tr height="25">
        <td bgcolor="#EDEDED" width="150">&nbsp;����</td>
        <td bgcolor="#FFFFFF" width="300">&nbsp;<%=gw_name%>[<%=gw_url%>]</td>
        <td bgcolor="#EDEDED" width="150">&nbsp;����PORT</td>
        <td bgcolor="#FFFFFF" width="300">&nbsp;<%=gw_port%></td>
    </tr>
    <tr height="25">
        <td bgcolor="#EDEDED" width="150">&nbsp;�����ڵ�</td>
        <td bgcolor="#FFFFFF" width="300">&nbsp;<%=res_cd%></td>
        <td bgcolor="#EDEDED" width="150">&nbsp;����޽���</td>
        <td bgcolor="#FFFFFF" width="300">&nbsp;<%=res_msg%></td>
    </tr>
    <tr height="25">
        <td bgcolor="#EDEDED">&nbsp;PG�ŷ���ȣ</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=cno%></td>
        <td bgcolor="#EDEDED">&nbsp;�� �����ݾ�</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=amount%></td>
    </tr>
    <tr height="25">
        <td bgcolor="#EDEDED">&nbsp;�ŷ�����</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=msg_type%></td>
        <td bgcolor="#EDEDED">&nbsp;�ֹ���ȣ</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=order_no%></td>
    </tr>
    <tr height="25">
        <td bgcolor="#EDEDED">&nbsp;���ι�ȣ</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=auth_no%></td>
        <td bgcolor="#EDEDED">&nbsp;�����Ͻ�</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=tran_date%></td>
    </tr>
    <tr height="25">
        <td bgcolor="#EDEDED">&nbsp;����Ʈ���ι�ȣ</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=pnt_auth_no%></td>
        <td bgcolor="#EDEDED">&nbsp;����Ʈ�����Ͻ�</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=pnt_tran_date%></td>
	</tr>
    <tr height="25">
        <td bgcolor="#EDEDED">&nbsp;�������ι�ȣ</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=cpon_auth_no%></td>
        <td bgcolor="#EDEDED">&nbsp;���������Ͻ�</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=cpon_tran_date%></td>
    </tr>
    <tr height="25">
        <td bgcolor="#EDEDED">&nbsp;ī���ȣ</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=card_no%></td>
        <td bgcolor="#EDEDED">&nbsp;�߱޻��ڵ�</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=issuer_cd%></td>
    </tr>
    <tr>
        <td bgcolor="#EDEDED">&nbsp;�߱޻��</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=issuer_nm%></td>
        <td bgcolor="#EDEDED">&nbsp;���Ի��ڵ�</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=acquirer_cd%></td>
    </tr>
    <tr height="25">
        <td bgcolor="#EDEDED">&nbsp;���Ի��</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=acquirer_nm%></td>
        <td bgcolor="#EDEDED">&nbsp;�Һΰ���</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=install_period%></td>
    </tr>
    <tr height="25">
        <td bgcolor="#EDEDED">&nbsp;�����ڿ���</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=noint%></td>
        <td bgcolor="#EDEDED">&nbsp;�����ڵ�</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=bank_cd%></td>
    </tr>
    <tr height="25">
        <td bgcolor="#EDEDED">&nbsp;�����</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=bank_nm%></td>
        <td bgcolor="#EDEDED">&nbsp;���¹�ȣ</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=account_no%></td>
    </tr>
    <tr height="25">
        <td bgcolor="#EDEDED">&nbsp;�Ա��ڸ�</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=deposit_nm%></td>
        <td bgcolor="#EDEDED">&nbsp;���»�븸����</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=expire_date%></td>
    </tr>
    <tr height="25">
        <td bgcolor="#EDEDED">&nbsp;�Ա��뺸�� ��ü ��뿵��</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=vacct_rt_val%></td>
        <td bgcolor="#EDEDED">&nbsp;���ݿ����� ����ڵ�</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=cash_res_cd%></td>
    </tr>
    <tr height="25">
        <td bgcolor="#EDEDED">&nbsp;���ݿ����� ����޼���</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=cash_res_msg%></td>
        <td bgcolor="#EDEDED">&nbsp;���ݿ����� ���ι�ȣ</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=cash_auth_no%></td>
    </tr>
    <tr height="25">
        <td bgcolor="#EDEDED">&nbsp;���ݿ����� �����Ͻ�</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=cash_tran_date%></td>
        <td bgcolor="#EDEDED">&nbsp;PhoneID</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=auth_id%></td>
    </tr>
    <tr height="25">
        <td bgcolor="#EDEDED">&nbsp;������ȣ</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=billid%></td>
        <td bgcolor="#EDEDED">&nbsp;�޴�����ȣ</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=mobile_no%></td>
    </tr>
    <tr>
        <td height="25" bgcolor="#EDEDED">&nbsp;��ȭ��ȣ</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=ars_no%></td>
        <td bgcolor="#EDEDED">&nbsp;����Ʈ��</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=cp_cd%></td>
    </tr>
    <tr height="25">
        <td bgcolor="#EDEDED">&nbsp;�������Ʈ</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=used_pnt%></td>
        <td bgcolor="#EDEDED">&nbsp;�ܿ��ѵ�</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=remain_pnt%></td>
    </tr>
    <tr height="25">
        <td bgcolor="#EDEDED">&nbsp;����/�߻�����Ʈ</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=pay_pnt%></td>
        <td bgcolor="#EDEDED">&nbsp;��������Ʈ</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=accrue_pnt%></td>
    </tr>
    <tr height="25">
        <td bgcolor="#EDEDED">&nbsp;�����ܾ�</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=remain_cpon%></td>
        <td bgcolor="#EDEDED">&nbsp;���� ���ݾ�</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=used_cpon%></td>
    </tr>
    <tr height="25">
        <td bgcolor="#EDEDED">&nbsp;���޻��Ī</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=mall_nm%></td>
        <td bgcolor="#EDEDED">&nbsp;����ũ�� �������</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=escrow_yn%></td>
    </tr>
    <tr height="25">
        <td bgcolor="#EDEDED">&nbsp;���հ��� ����</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=complex_yn%></td>
        <td bgcolor="#EDEDED">&nbsp;��������Ͻ�</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=canc_acq_date%></td>
    </tr>
    <tr height="25">
        <td bgcolor="#EDEDED">&nbsp;����Ͻ�</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=canc_date%></td>
        <td bgcolor="#EDEDED">&nbsp;ȯ�ҿ����Ͻ�</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=refund_date%></td>
    </tr>
    <tr height="25">
        <td bgcolor="#EDEDED">&nbsp;��������</td>
        <td bgcolor="#FFFFFF">&nbsp;<%=pay_type%></td>
        <td bgcolor="#EDEDED">&nbsp;</td>
        <td bgcolor="#FFFFFF">&nbsp;</td>
    </tr>
    </table>
    </td>
</tr>
</table>
</form>
</body>
</html>
