<%
'/* -------------------------------------------------------------------------- */
'/* ::: ��Ƽ����                                                               */
'/* -------------------------------------------------------------------------- */
result_msg = ""

r_res_cd         = request( "res_cd"         )  '// �����ڵ�
r_res_msg        = request( "res_msg"        )  '// ���� �޽���
r_cno            = request( "cno"            )  '// PG�ŷ���ȣ
r_memb_id        = request( "memb_id"        )  '// ������ ID
r_amount         = request( "amount"         )  '// �� �����ݾ�
r_order_no       = request( "order_no"       )  '// �ֹ���ȣ
r_noti_type      = request( "noti_type"      )  '// ��Ƽ���� ����(20), �Ա�(30), ����ũ�� ����(40)
r_auth_no        = request( "auth_no"        )  '// ���ι�ȣ
r_tran_date      = request( "tran_date"      )  '// �����Ͻ�
r_card_no        = request( "card_no"        )  '// ī���ȣ
r_issuer_cd      = request( "issuer_cd"      )  '// �߱޻��ڵ�
r_issuer_nm      = request( "issuer_nm"      )  '// �߱޻��
r_acquirer_cd    = request( "acquirer_cd"    )  '// ���Ի��ڵ�
r_acquirer_nm    = request( "acquirer_nm"    )  '// ���Ի��
r_install_period = request( "install_period" )  '// �Һΰ���
r_noint          = request( "noint"          )  '// �����ڿ���
r_bank_cd        = request( "bank_cd"        )  '// �����ڵ�
r_bank_nm        = request( "bank_nm"        )  '// �����
r_account_no     = request( "account_no"     )  '// ���¹�ȣ
r_deposit_nm     = request( "deposit_nm"     )  '// �Ա��ڸ�
r_expire_date    = request( "expire_date"    )  '// ���»�븸����
r_cash_res_cd    = request( "cash_res_cd"    )  '// ���ݿ����� ����ڵ�
r_cash_res_msg   = request( "cash_res_msg"   )  '// ���ݿ����� ����޽���
r_cash_auth_no   = request( "cash_auth_no"   )  '// ���ݿ����� ���ι�ȣ
r_cash_tran_date = request( "cash_tran_date" )  '// ���ݿ����� �����Ͻ�
r_cp_cd          = request( "cp_cd"          )  '// ����Ʈ��
r_used_pnt       = request( "used_pnt"       )  '// �������Ʈ
r_remain_pnt     = request( "remain_pnt"     )  '// �ܿ��ѵ�
r_pay_pnt        = request( "pay_pnt"        )  '// ����/�߻�����Ʈ 
r_accrue_pnt     = request( "accrue_pnt"     )  '// ��������Ʈ
r_escrow_yn      = request( "escrow_yn"      )  '// ����ũ�� �������
r_canc_date      = request( "canc_date"      )  '// ����Ͻ�
r_canc_acq_date  = request( "canc_acq_date"  )  '// ��������Ͻ�
r_refund_date    = request( "refund_date"    )  '// ȯ�ҿ����Ͻ�
r_pay_type       = request( "pay_type"       )  '// ��������
r_auth_cno       = request( "auth_cno"       )  '// �����ŷ���ȣ
r_tlf_sno        = request( "tlf_sno"        )  '// ä���ŷ���ȣ
r_account_type   = request( "account_type"   )  '// ä������ Ÿ�� US AN 1 (V-�Ϲ���, F-������)

'/* -------------------------------------------------------------------------- */
'/* ::: ��Ƽ���� - ����ũ�� ���º���                                           */
'/* -------------------------------------------------------------------------- */
r_escrow_yn      = request( "escrow_yn "     )  '// ����ũ������
r_stat_cd        = request( "stat_cd "       )  '// ���濡��ũ�λ����ڵ�
r_stat_msg       = request( "stat_msg"       )  '// ���濡��ũ�λ��¸޼���

    if r_res_cd = "0000" then
	    '/* ---------------------------------------------------------------------- */
	    '/* ::: ������ DB ó��                                                     */
	    '/* ---------------------------------------------------------------------- */
	    '/* DBó�� ���� �� : res_cd=0000, ���� �� : res_cd=5001                    */
	    '/* ---------------------------------------------------------------------- */
		if 'DBó�� ���� ��
			result_msg = "res_cd=" + r_res_cd + chr(31) + "res_msg=" + r_res_msg
    	else ' DBó�� ���� ��
    		result_msg = "res_cd=" + r_res_cd + chr(31) + "res_msg=" + r_res_msg
    	end if
    end if

'/* -------------------------------------------------------------------------- */
'/* ::: ��Ƽ ó����� ó��                                                     */
'/* -------------------------------------------------------------------------- */
response.Write result_msg
             
%>