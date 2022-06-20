<%
'/* -------------------------------------------------------------------------- */
'/* ::: 노티수신                                                               */
'/* -------------------------------------------------------------------------- */
result_msg = ""

r_res_cd         = request( "res_cd"         )  '// 응답코드
r_res_msg        = request( "res_msg"        )  '// 응답 메시지
r_cno            = request( "cno"            )  '// PG거래번호
r_memb_id        = request( "memb_id"        )  '// 가맹점 ID
r_amount         = request( "amount"         )  '// 총 결제금액
r_order_no       = request( "order_no"       )  '// 주문번호
r_noti_type      = request( "noti_type"      )  '// 노티구분 변경(20), 입금(30), 에스크로 변경(40)
r_auth_no        = request( "auth_no"        )  '// 승인번호
r_tran_date      = request( "tran_date"      )  '// 승인일시
r_card_no        = request( "card_no"        )  '// 카드번호
r_issuer_cd      = request( "issuer_cd"      )  '// 발급사코드
r_issuer_nm      = request( "issuer_nm"      )  '// 발급사명
r_acquirer_cd    = request( "acquirer_cd"    )  '// 매입사코드
r_acquirer_nm    = request( "acquirer_nm"    )  '// 매입사명
r_install_period = request( "install_period" )  '// 할부개월
r_noint          = request( "noint"          )  '// 무이자여부
r_bank_cd        = request( "bank_cd"        )  '// 은행코드
r_bank_nm        = request( "bank_nm"        )  '// 은행명
r_account_no     = request( "account_no"     )  '// 계좌번호
r_deposit_nm     = request( "deposit_nm"     )  '// 입금자명
r_expire_date    = request( "expire_date"    )  '// 계좌사용만료일
r_cash_res_cd    = request( "cash_res_cd"    )  '// 현금영수증 결과코드
r_cash_res_msg   = request( "cash_res_msg"   )  '// 현금영수증 결과메시지
r_cash_auth_no   = request( "cash_auth_no"   )  '// 현금영수증 승인번호
r_cash_tran_date = request( "cash_tran_date" )  '// 현금영수증 승인일시
r_cp_cd          = request( "cp_cd"          )  '// 포인트사
r_used_pnt       = request( "used_pnt"       )  '// 사용포인트
r_remain_pnt     = request( "remain_pnt"     )  '// 잔여한도
r_pay_pnt        = request( "pay_pnt"        )  '// 할인/발생포인트 
r_accrue_pnt     = request( "accrue_pnt"     )  '// 누적포인트
r_escrow_yn      = request( "escrow_yn"      )  '// 에스크로 사용유무
r_canc_date      = request( "canc_date"      )  '// 취소일시
r_canc_acq_date  = request( "canc_acq_date"  )  '// 매입취소일시
r_refund_date    = request( "refund_date"    )  '// 환불예정일시
r_pay_type       = request( "pay_type"       )  '// 결제수단
r_auth_cno       = request( "auth_cno"       )  '// 인증거래번호
r_tlf_sno        = request( "tlf_sno"        )  '// 채번거래번호
r_account_type   = request( "account_type"   )  '// 채번계좌 타입 US AN 1 (V-일반형, F-고정형)

'/* -------------------------------------------------------------------------- */
'/* ::: 노티수신 - 에스크로 상태변경                                           */
'/* -------------------------------------------------------------------------- */
r_escrow_yn      = request( "escrow_yn "     )  '// 에스크로유무
r_stat_cd        = request( "stat_cd "       )  '// 변경에스크로상태코드
r_stat_msg       = request( "stat_msg"       )  '// 변경에스크로상태메세지

    if r_res_cd = "0000" then
	    '/* ---------------------------------------------------------------------- */
	    '/* ::: 가맹점 DB 처리                                                     */
	    '/* ---------------------------------------------------------------------- */
	    '/* DB처리 성공 시 : res_cd=0000, 실패 시 : res_cd=5001                    */
	    '/* ---------------------------------------------------------------------- */
		if 'DB처리 성공 시
			result_msg = "res_cd=" + r_res_cd + chr(31) + "res_msg=" + r_res_msg
    	else ' DB처리 실패 시
    		result_msg = "res_cd=" + r_res_cd + chr(31) + "res_msg=" + r_res_msg
    	end if
    end if

'/* -------------------------------------------------------------------------- */
'/* ::: 노티 처리결과 처리                                                     */
'/* -------------------------------------------------------------------------- */
response.Write result_msg
             
%>