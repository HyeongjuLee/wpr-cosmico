<!--#include virtual="/_lib/strFunc.asp" -->

<!-- #include file = "easypay_config.asp" --> <!-- ' 환경설정 파일 include -->
<!-- #include file = "easypay_client.asp"     --> <!-- ' library [수정불가] -->
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

if res_cd = "0000" Then


OrderNum = order_no



' 개별 변수 받아오기
	Dim inUidx : inUidx = Trim(pRequestTF("cuidx",False))

	'기본 정보
		Dim strName : strName = Trim(pRequestTF("strName",False))
		Dim strTel1 : strTel1 = Trim(pRequestTF("strTel1",False))
		Dim strTel2 : strTel2 = Trim(pRequestTF("strTel2",False))
		Dim strTel3 : strTel3 = Trim(pRequestTF("strTel3",False))
		Dim strMob1 : strMob1 = Trim(pRequestTF("strMob1",False))
		Dim strMob2 : strMob2 = Trim(pRequestTF("strMob2",False))
		Dim strMob3 : strMob3 = Trim(pRequestTF("strMob3",False))
		Dim strEmail : strEmail = Trim(pRequestTF("strEmail",False))
		Dim strZip : strZip = Trim(pRequestTF("strZip",False))
		Dim strADDR1 : strADDR1 = Trim(pRequestTF("strADDR1",False))
		Dim strADDR2 : strADDR2 = Trim(pRequestTF("strADDR2",False))
	'배송 정보
		Dim takeName : takeName = Trim(pRequestTF("takeName",False))
		Dim takeTel1 : takeTel1 = Trim(pRequestTF("takeTel1",False))
		Dim takeTel2 : takeTel2 = Trim(pRequestTF("takeTel2",False))
		Dim takeTel3 : takeTel3 = Trim(pRequestTF("takeTel3",False))
		Dim takeMob1 : takeMob1 = Trim(pRequestTF("takeMob1",False))
		Dim takeMob2 : takeMob2 = Trim(pRequestTF("takeMob2",False))
		Dim takeMob3 : takeMob3 = Trim(pRequestTF("takeMob3",False))
		Dim takeZip : takeZip = Trim(pRequestTF("takeZip",False))
		Dim takeADDR1 : takeADDR1 = Trim(pRequestTF("takeADDR1",False))
		Dim takeADDR2 : takeADDR2 = Trim(pRequestTF("takeADDR2",False))

	'금액 관련
		Dim totalPrice : totalPrice = Trim(pRequestTF("totalPrice",False))
		Dim totalDelivery : totalDelivery = Trim(pRequestTF("totalDelivery",False))
		Dim DeliveryFeeType : DeliveryFeeType = Trim(pRequestTF("DeliveryFeeType",False))
		Dim GoodsPrice : GoodsPrice = Trim(pRequestTF("GoodsPrice",False))

		Dim totalOptionPrice : totalOptionPrice = Trim(pRequestTF("totalOptionPrice",False))
		Dim totalOptionPrice2 : totalOptionPrice2 = Trim(pRequestTF("totalOptionPrice2",False))
		Dim totalPoint : totalPoint = Trim(pRequestTF("totalPoint",False))

		Dim usePoint : usePoint = Trim(pRequestTF("useCmoney",False))
		Dim totalVotePoint : totalVotePoint = Trim(pRequestTF("totalVotePoint",False))

		If usePoint = Null Or usePoint = "" Then usePoint = 0



	'기타 정보
		Dim orderMemo : orderMemo = Trim(pRequestTF("orderMemo",False))
		Dim state : state = "100"
		Dim input_mode : input_mode = Trim(pRequestTF("input_mode",False))
		Dim orderEaD : orderEaD = Trim(pRequestTF("ea",False))
		Dim strOption : strOption = Trim(pRequestTF("strOption",False))


	' 미사용 필드
		Dim strSSH1 : strSSH1 = Trim(pRequestTF("strSSH1",False))
		Dim strSSH2 : strSSH2 = Trim(pRequestTF("strSSH2",False))


	'특이사항 필드
		Dim BusCode : BusCode = Trim(pRequestTF("BusCode",False))		'2013-03-14, 엘라이프3 특아사항 : 주문시 판매센터 필수 입력, order.asp / order_direct.asp

	'무통장 필드
		Dim bankidx : bankidx = Trim(pRequestTF("bankidx",False))
		Dim bankingName : bankingName = Trim(pRequestTF("bankingName",False))


	If orderMemo <> "" Then orderMemo = Left(orderMemo,100)		'배송메세지 길이 제한(param 길이 확인!!)

'	OrderNum = ordersNumber



	payway = "card"
	strDomain = strHostA
	strIDX = DK_SES_MEMBER_IDX
	strUserID = DK_MEMBER_ID

	takeTel = ""
	takeMob = ""
	strTel = ""
	strMob = ""

	If strTel1 <> "" And strTel2 <> "" And strTel3 <> "" Then strTel = strTel1 & "-" & strTel2 & "-" & strTel3
	If strMob1 <> "" And strMob2 <> "" And strMob3 <> "" Then strMob = strMob1 & "-" & strMob2 & "-" & strMob3
	If takeTel1 <> "" And takeTel2 <> "" And takeTel3 <> "" Then takeTel = takeTel1 & "-" & takeTel2 & "-" & takeTel3
	If takeMob1 <> "" And takeMob2 <> "" And takeMob3 <> "" Then takeMob = takeMob1 & "-" & takeMob2 & "-" & takeMob3

	CARD_ACP_TIME = ApplDate&" "&ApplTime

	state = "101"



'	Call Db.beginTrans(Nothing)


	'주문자가 정보수정을 원할 시
		If DKCONF_SITE_ENC = "T" Then
			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				If strADDR1		<> "" Then strADDR1			= objEncrypter.Encrypt(strADDR1)
				If strADDR2		<> "" Then strADDR2			= objEncrypter.Encrypt(strADDR2)
				If strTel		<> "" Then strTel			= objEncrypter.Encrypt(strTel)
				If strMob		<> "" Then strMob			= objEncrypter.Encrypt(strMob)
				If takeTel		<> "" Then takeTel			= objEncrypter.Encrypt(takeTel)
				If takeMob		<> "" Then takeMob			= objEncrypter.Encrypt(takeMob)
				If takeADDR1	<> "" Then takeADDR1		= objEncrypter.Encrypt(takeADDR1)
				If takeADDR2	<> "" Then takeADDR2		= objEncrypter.Encrypt(takeADDR2)
			Set objEncrypter = Nothing
		End If


		If infoChg = "T" And (DK_MEMBER_TYPE <> "GUEST" And DK_MEMBER_TYPE="COMPANY") Then
			SQL = "UPDATE [DK_MEMBER] SET "
			SQL = SQL & " [strMobile] = ?"
			SQL = SQL & ",[strEmail] = ?"
			SQL = SQL & ",[strZip] = ?"
			SQL = SQL & ",[strADDR1] = ?"
			SQL = SQL & ",[strADDR2] = ?"
			SQL = SQL & " WHERE [strUserID] = ?"
			arrParams = Array(_
				Db.makeParam("@strMobile",adVarChar,adParamInput,50,strMob), _
				Db.makeParam("@strEmail",adVarChar,adParamInput,512,strEmail), _
				Db.makeParam("@strZip",adVarChar,adParamInput,10,strZip), _
				Db.makeParam("@strADDR1",adVarWChar,adParamInput,512,strADDR1), _
				Db.makeParam("@strADDR2",adVarWChar,adParamInput,512,strADDR2), _
				Db.makeParam("@strUserID",adVarchar,adParamInput,20,DK_MEMBER_ID) _
			)
			Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)

			SQL = "UPDATE [DK_MEMBER_ADDINFO] SET "
			SQL = SQL & " [strTel] = ?"
			SQL = SQL & " WHERE [strUserID] = ?"
			arrParams = Array(_
				Db.makeParam("@strTel",adVarChar,adParamInput,50,strTel), _
				Db.makeParam("@strUserID",adVarchar,adParamInput,20,strUserID) _
			)
			Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
		End If

		' 은행정보 가져오기
			SQL = "SELECT * FROM [DK_BANK] WHERE [intIDX] = ?"
			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,4,bankidx)_
			)
			Set DKRS_BANK = Db.execRs(SQL,DB_TEXT,arrParams,Nothing)
			If Not DKRS_BANK.BOF And Not DKRS_BANK_EOF Then
				DKRS_BANK_BankName		= DKRS_BANK("BankName")
				DKRS_BANK_BankNumber	= DKRS_BANK("BankNumber")
				DKRS_BANK_BankOwner		= DKRS_BANK("BankOwner")
			End If
			Call closeRS(DKRS_BANK)




	'print paykind
	Select Case UCase(paykind)
		Case "CARD"
			state = "101"							'입금확인
			payway = "card"
			PGCardNum		= CARD_Num				'카드번호 12자리
			PGAcceptNum		= ApplNum				'신용카드 승인번호
			PGinstallment	= CARD_Quota			'할부기간
			PGCardCode		= CARD_Code				'카드코드
			PGCardCom		= CARD_BankCode			'신용카드발급사
			status101Date	= CARD_ACP_TIME			'이니시스승인날짜/시각

		Case "DIRECTBANK"
			state = "101"							'입금확인
			payway = "dbank"
			PGCardNum		= ""
			PGAcceptNum		= ""
			PGinstallment	= CSHR_Type				'	현금영수증 발행구분코드
			PGCardCode		= CSHR_ResultCode		'	현금영수증결과코드
			PGCardCom		= ACCT_BankCode			'	은행코드
			status101Date	= CARD_ACP_TIME			'	이니시스승인날짜/시각

		Case "VBANK"
			state = "100"
			payway = "vbank"
			PGCardNum		= VACT_Num				'	입금 계좌번호
			PGAcceptNum		= VACT_InputName		'	송금자명
			PGinstallment	= VACT_BankCode			'	입금은행코드
			PGCardCode		= VACT_Date&VACT_Time	'	입금예정날짜/시간
			PGCardCom		= VACT_Name				'	예금주명
			status101Date	= ""
	End Select

	SQL = " INSERT INTO [DK_ORDER] ( "
		SQL = SQL & " [strDomain],[OrderNum],[strIDX],[strUserID],[payWay] "
		SQL = SQL & " ,[totalPrice],[totalDelivery],[totalOptionPrice],[totalPoint],[strName] "
		SQL = SQL & " ,[strTel],[strMob],[strEmail],[strZip],[strADDR1] "
		SQL = SQL & " ,[strADDR2],[takeName],[takeTel],[takeMob],[takeZip] "
		SQL = SQL & " ,[takeADDR1],[takeADDR2],[status],[orderMemo],[strSSH1] "
		SQL = SQL & " ,[strSSH2],[bankIDX],[BankingName],[usePoint],[totalVotePoint] "

		SQL = SQL & " ,[PGorderNum],[PGCardNum],[PGAcceptNum],[PGinstallment],[PGCardCode]"
		SQL = SQL & " ,[PGCardCom]"

		SQL = SQL & " ) VALUES ( "
		SQL = SQL & " ?,?,?,?,? "
		SQL = SQL & " ,?,?,?,?,? "
		SQL = SQL & " ,?,?,?,?,? "
		SQL = SQL & " ,?,?,?,?,? "
		SQL = SQL & " ,?,?,?,?,? "
		SQL = SQL & " ,?,?,?,?,? "
		SQL = SQL & " ,?,?,?,?,? "
		SQL = SQL & " ,?"
		SQL = SQL & " ); "
		SQL = SQL & "SELECT ? = @@IDENTITY"
		arrParams = Array( _
			Db.makeParam("@strDomain",adVarchar,adParamInput,50,strDomain), _
			Db.makeParam("@OrderNum",adVarchar,adParamInput,20,OrderNum), _
			Db.makeParam("@strIDX",adVarchar,adParamInput,50,strIDX), _
			Db.makeParam("@strUserID",adVarchar,adParamInput,20,strUserID), _
			Db.makeParam("@payWay",adVarchar,adParamInput,6,payWay), _

			Db.makeParam("@totalPrice",adInteger,adParamInput,0,totalPrice), _
			Db.makeParam("@totalDelivery",adInteger,adParamInput,0,totalDelivery), _
			Db.makeParam("@totalOptionPrice",adInteger,adParamInput,0,totalOptionPrice), _
			Db.makeParam("@totalPoint",adInteger,adParamInput,0,totalPoint), _
			Db.makeParam("@strName",adVarWChar,adParamInput,50,strName), _

			Db.makeParam("@strTel",adVarchar,adParamInput,50,strTel), _
			Db.makeParam("@strMob",adVarchar,adParamInput,50,strMob), _
			Db.makeParam("@strEmail",adVarWChar,adParamInput,500,strEmail), _
			Db.makeParam("@strZip",adVarchar,adParamInput,50,strZip), _
			Db.makeParam("@strADDR1",adVarchar,adParamInput,512,strADDR1), _

			Db.makeParam("@strADDR2",adVarchar,adParamInput,512,strADDR2), _
			Db.makeParam("@takeName",adVarWChar,adParamInput,50,takeName), _
			Db.makeParam("@takeTel",adVarchar,adParamInput,50,takeTel), _
			Db.makeParam("@takeMob",adVarchar,adParamInput,50,takeMob), _
			Db.makeParam("@takeZip",adVarchar,adParamInput,10,takeZip), _

			Db.makeParam("@takeADDR1",adVarchar,adParamInput,512,takeADDR1), _
			Db.makeParam("@takeADDR2",adVarchar,adParamInput,512,takeADDR2), _
			Db.makeParam("@state",adChar,adParamInput,3,state), _
			Db.makeParam("@orderMemo",adVarWChar,adParamInput,100,orderMemo), _
			Db.makeParam("@strSSH1",adVarchar,adParamInput,6,strSSH1), _

			Db.makeParam("@strSSH2",adVarchar,adParamInput,7,strSSH2), _
			Db.makeParam("@bankIDX",adInteger,adParamInput,4,bankidx), _
			Db.makeParam("@bankingName",adVarWChar,adParamInput,50,bankingName), _
			Db.makeParam("@usePoint",adInteger,adParamInput,4,usePoint), _
			Db.makeParam("@totalVotePoint",adInteger,adParamInput,4,totalVotePoint), _

			Db.makeParam("@PGorderNum",adVarchar,adParamInput,50,r_cno), _
			Db.makeParam("@PGCardNum",adVarchar,adParamInput,50,r_card_no), _
			Db.makeParam("@PGAcceptNum",adVarchar,adParamInput,50,r_auth_no), _
			Db.makeParam("@PGinstallment",adVarchar,adParamInput,50,r_install_period), _
			Db.makeParam("@PGCardCode",adVarchar,adParamInput,50,r_issuer_cd), _
			Db.makeParam("@PGCardCom",adVarchar,adParamInput,50,r_issuer_nm), _


			Db.makeParam("@identity",adInteger,adParamOutput,0,0) _
		)
		Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
		identity = arrParams(UBound(arrParams))(4)

		If state = "101" Then
			SQL = "UPDATE [DK_ORDER] SET [status] = '101', [status101Date] = getDate() WHERE [intIDX] = ?"
			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,identity) _
			)
			Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
		End If

	' 적립금 차감 및 적립금 사용 필드 업데이트
		'#####################################
		' 2014-02-27 : 회원인 경우에 CS 회원을 고려하여 FINANCIAL 에 회원이 있는 지 조회 후 없는 경우 FINANCIAL에 회원정보를 기입한다.
		'#####################################
		If DK_MEMBER_TYPE <> "GUEST" Then
			SQL = " SELECT * FROM [DK_MEMBER_FINANCIAL] WHERE [strUserID] = ?"
			arrParams = Array(_
				Db.makeParam("@strUserID",adVarchar,adParamInput,20,strUserID) _
			)
			Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,Nothing)
			If DKRS.BOF Or DKRS.EOF Then
				SQL2 = "INSERT INTO [DK_MEMBER_FINANCIAL] ([strUserID]) VALUES (?)"
				Call Db.exec(SQL2,DB_TEXT,arrParams,Nothing)
			End If
			Call closeRS(DKRS)
		End If

	'적립금 차감
		SQL = "SELECT [intPoint] FROM [DK_MEMBER_FINANCIAL] WHERE [strUserID] = ?"
		arrParams = Array(_
			Db.makeParam("@strUserID",adVarchar,adParamInput,20,strUserID) _
		)
		nowMemberPoint = Db.execRsData(SQL,DB_TEXT,arrParams,Nothing)


		SQL = "INSERT INTO [DK_MEMBER_POINT_LOG] ("
		SQL = SQL & " [strUserID],[intValue],[intRemain],[ValueComment],[dComment] "
		SQL = SQL & " ) VALUES ( "
		SQL = SQL & " ?,?,?,?,? "
		SQL = SQL & " )"
		arrParams = Array(_
			Db.makeParam("@strUserID",adVarchar,adParamInput,20,strUserID), _
			Db.makeParam("@intValue",adInteger,adParamInput,0,-usePoint), _
			Db.makeParam("@intRemain",adInteger,adParamInput,0,nowMemberPoint-usePoint), _
			Db.makeParam("@ValueComment",adVarChar,adParamInput,50,"ORDER2"), _
			Db.makeParam("@dComment",adVarChar,adParamInput,800,OrderNum&"주문 시 사용") _
		)
		Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)

		SQL = "UPDATE [DK_MEMBER_FINANCIAL] SET [intPoint] = [intPoint] - ? WHERE [strUserID] = ?"
		arrParams = Array(_
			Db.makeParam("@intPoint",adInteger,adParamInput,0,usePoint), _
			Db.makeParam("@strUserID",adVarchar,adParamInput,20,strUserID) _
		)
		Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)




	If input_mode = "direct" Then
		If strOption = "" Or IsNull(strOption) Then strOption = ""
		Dim SellerID : 	SellerID = Trim(pRequestTF("SellerID",True))
		'Call ALERTS("","BACK","")

		Dim thisPrice, thisOptionPrice, thisPoint
		thisPrice				= GoodsPrice / orderEaD
		thisOptionPrice			= totalOptionPrice / orderEaD
		thisOptionPrice2		= totalOptionPrice2 / orderEaD
		thisPoint				= totalPoint / orderEaD



		'상품 정보(수량) 확인
			SQL = "SELECT "
			SQL = SQL & " [DelTF],[GoodsStockType],[GoodsStockNum],[GoodsViewTF],[isAccept]"
			SQL = SQL & ",[GoodsName],[imgThum],[GoodsPrice],[GoodsCustomer],[GoodsCost]"
			SQL = SQL & ",[GoodsPoint],[GoodsDeliveryType],[GoodsDeliveryFee],[intPriceNot],[intPriceAuth]"
			SQL = SQL & ",[intPriceDeal],[intPriceVIP],[intMinNot],[intMinAuth],[intMinDeal]"
			SQL = SQL & ",[intMinVIP],[intPointNot],[intPointAuth],[intPointDeal],[intPointVIP]"
			SQL = SQL & ",[isImgType]"
			SQL = SQL & " FROM [DK_GOODS] WHERE [intIDX] = ?"
			arrParams = Array(_
				Db.makeParam("@GoodIDX",adInteger,adParamInput,4,inUidx) _
			)
			Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,Nothing)
			If Not DKRS.BOF And Not DKRS.EOF Then
				DKRS_DelTF					= DKRS("DelTF")
				DKRS_GoodsStockType			= DKRS("GoodsStockType")
				DKRS_GoodsStockNum			= DKRS("GoodsStockNum")
				DKRS_GoodsViewTF			= DKRS("GoodsViewTF")
				DKRS_isAccept				= DKRS("isAccept")
				DKRS_GoodsName				= DKRS("GoodsName")
				DKRS_imgThum				= DKRS("imgThum")

				DKRS_GoodsPrice				= DKRS("GoodsPrice")
				DKRS_GoodsCustomer			= DKRS("GoodsCustomer")
				DKRS_GoodsCost				= DKRS("GoodsCost")
				DKRS_GoodsPoint				= DKRS("GoodsPoint")

				DKRS_GoodsDeliveryType		= DKRS("GoodsDeliveryType")
				DKRS_GoodsDeliveryFee		= DKRS("GoodsDeliveryFee")

				DKRS_intPriceNot				= DKRS("intPriceNot")
				DKRS_intPriceAuth				= DKRS("intPriceAuth")
				DKRS_intPriceDeal				= DKRS("intPriceDeal")
				DKRS_intPriceVIP				= DKRS("intPriceVIP")
				DKRS_intMinNot					= DKRS("intMinNot")
				DKRS_intMinAuth					= DKRS("intMinAuth")
				DKRS_intMinDeal					= DKRS("intMinDeal")
				DKRS_intMinVIP					= DKRS("intMinVIP")
				DKRS_intPointNot				= DKRS("intPointNot")
				DKRS_intPointAuth				= DKRS("intPointAuth")
				DKRS_intPointDeal				= DKRS("intPointDeal")
				DKRS_intPointVIP				= DKRS("intPointVIP")
				DKRS_isImgType					= DKRS("isImgType")

				Select Case DK_MEMBER_LEVEL
					Case 0,1 '비회원, 일반회원
						DKRS_GoodsPrice = DKRS_intPriceNot
						DKRS_GoodsPoint = DKRS_intPointNot
						DKRS_intMinimum = DKRS_intMinNot
					Case 2 '인증회원
						DKRS_GoodsPrice = DKRS_intPriceAuth
						DKRS_GoodsPoint = DKRS_intPointAuth
						DKRS_intMinimum = DKRS_intMinAuth
					Case 3 '딜러회원
						DKRS_GoodsPrice = DKRS_intPriceDeal
						DKRS_GoodsPoint = DKRS_intPointDeal
						DKRS_intMinimum = DKRS_intMinDeal
					Case 4,5 'VIP 회원
						DKRS_GoodsPrice = DKRS_intPriceVIP
						DKRS_GoodsPoint = DKRS_intPointVIP
						DKRS_intMinimum = DKRS_intMinVIP
					Case 9,10,11
						DKRS_GoodsPrice = DKRS_intPriceVIP
						DKRS_GoodsPoint = DKRS_intPointVIP
						DKRS_intMinimum = DKRS_intMinVIP
				End Select
			Else
				Call ALERTS("존재하지 않는 상품구입을 시도했습니다.","BACK","")
			End If
			Call closeRS(DKRS)

			If DKRS_DelTF = "T" Then Call ALERTS("삭제된 상품의 구매를 시도했습니다. 새로고침 후 다시 시도해주세요.","BACK","")
			If DKRS_isAccept <> "T" Then Call ALERTS("승인되지 않은 상품의 구매를 시도했습니다. 새로고침 후 다시 시도해주세요.","BACK","")
			If DKRS_GoodsViewTF <> "T" Then Call ALERTS("더이상 판매되지 않는 상품의 구매를 시도했습니다. 새로고침 후 다시 시도해주세요.","BACK","")

			Select Case DKRS_GoodsStockType
				Case "I"
				Case "N"
					If Int(DKRS_GoodsStockNum) < Int(orderEaD) Then
						Call ALERTS("남아있는 수량이 현재 구입하시려는 수량보다 많습니다. 새로고침 후 다시 시도해주세요.","BACK","")
					Else
						SQL = "UPDATE [DK_GOODS] SET [GoodsStockNum] = [GoodsStockNum] - ? WHERE [intIDX] = ?"
						arrParams = Array(_
							Db.makeParam("@ea",adInteger,adParamInput,4,orderEaD), _
							Db.makeParam("@intIDX",adInteger,adParamInput,4,inUidx) _
						)
						Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
					End If
				Case "S" : Call ALERTS("품절상품. 새로고침 후 다시 시도해주세요.","BACK","")
				Case Else : Call ALERTS("수량정보가 올바르지 않습니다. 새로고침 후 다시 시도해주세요.","BACK","")
			End Select

			' 배송비 타입 확인
				If DKRS_GoodsDeliveryType = "SINGLE" Then
					GoodsDeliveryFeeType	= "선결제"
					GoodsDeliveryFee		= Int(DKRS_orderEa) * Int(DKRS_GoodsDeliveryFee)
					GoodsDeliveryLimit		= 0
				ElseIf DKRS_GoodsDeliveryType = "BASIC" Then
					arrParams2 = Array(_
						Db.makeParam("@strShopID",adVarChar,adParamInput,30,SellerID) _
					)
					Set DKRS2 = DB.execRs("DKP_DELIVERY_FEE_VIEW",DB_PROC,arrParams2,Nothing)
					If Not DKRS2.BOF And Not DKRS2.EOF Then
						DKRS2_FeeType			= DKRS2("FeeType")
						DKRS2_intFee			= Int(DKRS2("intFee"))
						DKRS2_intLimit			= Int(DKRS2("intLimit"))
					Else
						DKRS2_FeeType			= ""
						DKRS2_intFee			= ""
						DKRS2_intLimit			= ""
					End If
					Select Case LCase(DKRS2_FeeType)
						Case "free"
							GoodsDeliveryFeeType	= "무료배송"
							GoodsDeliveryFee		= Int(DKRS_orderEa) * Int(DKRS2_intFee)
							GoodsDeliveryLimit		= DKRS2_intLimit
						Case "prev"
							GoodsDeliveryFeeType	= "선결제"
							GoodsDeliveryFee		= Int(DKRS2_intFee)
							GoodsDeliveryLimit		= DKRS2_intLimit
						Case "next"
							GoodsDeliveryFeeType	= "착불"
							GoodsDeliveryFee		= Int(DKRS2_intFee)
							GoodsDeliveryLimit		= DKRS2_intLimit
					End Select

				End If


		'구매정보(상품) 입력
			SQL = " INSERT INTO [DK_ORDER_GOODS] ( "
			SQL = SQL & " [orderIDX],[GoodIDX],[strOption],[orderEa],[goodsPrice]"
			SQL = SQL & ",[goodsOptionPrice],[goodsPoint],[GoodsCost],[isShopType],[strShopID]"
			SQL = SQL & ",[GoodsName],[ImgThum],[GoodsDeliveryType],[GoodsDeliveryFeeType],[GoodsDeliveryFee]"
			SQL = SQL & ",[GoodsDeliveryLimit],[status],[isImgType],[goodsOPTcost],[OrderNum]"
			SQL = SQL & " ) VALUES ( "
			SQL = SQL & " ?, ?, ?, ?, ?"
			SQL = SQL & ",?, ?, ?, ?, ?"
			SQL = SQL & ",?, ?, ?, ?, ?"
			SQL = SQL & ",?, ?, ?, ?, ?"
			SQL = SQL & " ) "
			arrParams = Array(_
				Db.makeParam("@orderIDX",adInteger,adParamInput,4,identity), _
				Db.makeParam("@GoodIDX",adInteger,adParamInput,4,inUidx), _
				Db.makeParam("@strOption",adVarWChar,adParamInput,512,strOption), _
				Db.makeParam("@orderEa",adInteger,adParamInput,4,orderEaD),_
				Db.makeParam("@goodsPrice",adInteger,adParamInput,4,thisPrice),_

				Db.makeParam("@thisOptionPrice",adInteger,adParamInput,4,thisOptionPrice),_
				Db.makeParam("@goodsPoint",adInteger,adParamInput,4,thisPoint),_
				Db.makeParam("@GoodsCost",adInteger,adParamInput,4,DKRS_GoodsCost),_

				Db.makeParam("@isShopType",adChar,adParamInput,1,DKRS_isShopType),_
				Db.makeParam("@strShopID",adVarChar,adParamInput,50,SellerID),_
				Db.makeParam("@GoodsName",adVarWChar,adParamInput,100,DKRS_GoodsName),_
				Db.makeParam("@imgThum",adVarWChar,adParamInput,512,DKRS_imgThum),_

				Db.makeParam("@GoodsDeliveryType",adVarChar,adParamInput,6,DKRS_GoodsDeliveryType),_
				Db.makeParam("@GoodsDeliveryFeeType",adVarWChar,adParamInput,20,GoodsDeliveryFeeType),_
				Db.makeParam("@GoodsDeliveryFee",adInteger,adParamInput,4,GoodsDeliveryFee),_
				Db.makeParam("@GoodsDeliveryLimit",adInteger,adParamInput,4,GoodsDeliveryLimit),_
				Db.makeParam("@status",adChar,adParamInput,3,state),_
				Db.makeParam("@isImgType",adChar,adParamInput,1,DKRS_isImgType),_
				Db.makeParam("@goodsOPTcost",adInteger,adParamInput,4,thisOptionPrice2),_

				Db.makeParam("@OrderNum",adVarchar,adParamInput,20,OrderNum) _
			)
			Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
	Else

		arrUidx = Split(inUidx,",")

		For i = 0 To UBound(arrUidx)

			'print arrUidx(i)
			SQL = "SELECT * FROM [DK_CART] WHERE [intIDX] = ?"
			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,4,arrUidx(i)) _
			)
			Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,Nothing)

			If Not DKRS.BOF Or Not DKRS.EOF Then
				DKRS_GoodIDX	= DKRS("GoodIDX")
				DKRS_strOption	= DKRS("strOption")
				DKRS_orderEa	= DKRS("orderEa")
				DKRS_isShopType	= DKRS("isShopType")
				DKRS_strShopID	= DKRS("strShopID")
			End If
			Call closeRS(DKRS)
			If strOption = "" Or IsNull(strOption) Then strOption = ""


			'상품 정보(수량) 확인
				SQL = "SELECT "
				SQL = SQL & " [DelTF],[GoodsStockType],[GoodsStockNum],[GoodsViewTF],[isAccept]"
				SQL = SQL & ",[GoodsName],[imgThum],[GoodsPrice],[GoodsCustomer],[GoodsCost]"
				SQL = SQL & ",[GoodsPoint],[GoodsDeliveryType],[GoodsDeliveryFee],[intPriceNot],[intPriceAuth]"
				SQL = SQL & ",[intPriceDeal],[intPriceVIP],[intMinNot],[intMinAuth],[intMinDeal]"
				SQL = SQL & ",[intMinVIP],[intPointNot],[intPointAuth],[intPointDeal],[intPointVIP]"
				SQL = SQL & ",[isImgType]"
				SQL = SQL & " FROM [DK_GOODS] WHERE [intIDX] = ?"
				arrParams = Array(_
					Db.makeParam("@GoodIDX",adInteger,adParamInput,4,DKRS_GoodIDX) _
				)
				Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,Nothing)
				If Not DKRS.BOF And Not DKRS.EOF Then
					DKRS_DelTF					= DKRS("DelTF")
					DKRS_GoodsStockType			= DKRS("GoodsStockType")
					DKRS_GoodsStockNum			= DKRS("GoodsStockNum")
					DKRS_GoodsViewTF			= DKRS("GoodsViewTF")
					DKRS_isAccept				= DKRS("isAccept")
					DKRS_GoodsName				= DKRS("GoodsName")
					DKRS_imgThum				= DKRS("imgThum")

					DKRS_GoodsPrice				= DKRS("GoodsPrice")
					DKRS_GoodsCustomer			= DKRS("GoodsCustomer")
					DKRS_GoodsCost				= DKRS("GoodsCost")
					DKRS_GoodsPoint				= DKRS("GoodsPoint")

					DKRS_GoodsDeliveryType		= DKRS("GoodsDeliveryType")
					DKRS_GoodsDeliveryFee		= DKRS("GoodsDeliveryFee")

					DKRS_intPriceNot				= DKRS("intPriceNot")
					DKRS_intPriceAuth				= DKRS("intPriceAuth")
					DKRS_intPriceDeal				= DKRS("intPriceDeal")
					DKRS_intPriceVIP				= DKRS("intPriceVIP")
					DKRS_intMinNot					= DKRS("intMinNot")
					DKRS_intMinAuth					= DKRS("intMinAuth")
					DKRS_intMinDeal					= DKRS("intMinDeal")
					DKRS_intMinVIP					= DKRS("intMinVIP")
					DKRS_intPointNot				= DKRS("intPointNot")
					DKRS_intPointAuth				= DKRS("intPointAuth")
					DKRS_intPointDeal				= DKRS("intPointDeal")
					DKRS_intPointVIP				= DKRS("intPointVIP")
					DKRS_isImgType					= DKRS("isImgType")

					Select Case DK_MEMBER_LEVEL
						Case 0,1 '비회원, 일반회원
							DKRS_GoodsPrice = DKRS_intPriceNot
							DKRS_GoodsPoint = DKRS_intPointNot
							DKRS_intMinimum = DKRS_intMinNot
						Case 2 '인증회원
							DKRS_GoodsPrice = DKRS_intPriceAuth
							DKRS_GoodsPoint = DKRS_intPointAuth
							DKRS_intMinimum = DKRS_intMinAuth
						Case 3 '딜러회원
							DKRS_GoodsPrice = DKRS_intPriceDeal
							DKRS_GoodsPoint = DKRS_intPointDeal
							DKRS_intMinimum = DKRS_intMinDeal
						Case 4,5 'VIP 회원
							DKRS_GoodsPrice = DKRS_intPriceVIP
							DKRS_GoodsPoint = DKRS_intPointVIP
							DKRS_intMinimum = DKRS_intMinVIP
						Case 9,10,11
							DKRS_GoodsPrice = DKRS_intPriceVIP
							DKRS_GoodsPoint = DKRS_intPointVIP
							DKRS_intMinimum = DKRS_intMinVIP
					End Select
				Else
					Call ALERTS("존재하지 않는 상품구입을 시도했습니다.","BACK","")
				End If
				Call closeRS(DKRS)

				If DKRS_DelTF = "T" Then Call ALERTS("삭제된 상품의 구매를 시도했습니다. 새로고침 후 다시 시도해주세요.","BACK","")
				If DKRS_isAccept <> "T" Then Call ALERTS("승인되지 않은 상품의 구매를 시도했습니다. 새로고침 후 다시 시도해주세요.","BACK","")
				If DKRS_GoodsViewTF <> "T" Then Call ALERTS("더이상 판매되지 않는 상품의 구매를 시도했습니다. 새로고침 후 다시 시도해주세요.","BACK","")

				Select Case DKRS_GoodsStockType
					Case "I"
					Case "N"
						If Int(DKRS_GoodsStockNum) < Int(DKRS_orderEa) Then
							Call ALERTS("남아있는 수량이 현재 구입하시려는 수량보다 많습니다. 새로고침 후 다시 시도해주세요.","BACK","")
						Else
							SQL = "UPDATE [DK_GOODS] SET [GoodsStockNum] = [GoodsStockNum] - ? WHERE [intIDX] = ?"
							arrParams = Array(_
								Db.makeParam("@ea",adInteger,adParamInput,4,DKRS_orderEa), _
								Db.makeParam("@intIDX",adInteger,adParamInput,4,DKRS_GoodIDX) _
							)
							Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
						End If
					Case "S" : Call ALERTS("품절상품. 새로고침 후 다시 시도해주세요.","BACK","")
					Case Else : Call ALERTS("수량정보가 올바르지 않습니다. 새로고침 후 다시 시도해주세요.","BACK","")
				End Select

			' 배송비 타입 확인
				If DKRS_GoodsDeliveryType = "SINGLE" Then
					GoodsDeliveryFeeType	= "선결제"
					GoodsDeliveryFee		= Int(DKRS_orderEa) * Int(DKRS_GoodsDeliveryFee)
					GoodsDeliveryLimit		= 0
				ElseIf DKRS_GoodsDeliveryType = "BASIC" Then
					arrParams2 = Array(_
						Db.makeParam("@strShopID",adVarChar,adParamInput,30,DKRS_strShopID) _
					)
					Set DKRS2 = DB.execRs("DKP_DELIVERY_FEE_VIEW",DB_PROC,arrParams2,Nothing)
					If Not DKRS2.BOF And Not DKRS2.EOF Then
						DKRS2_FeeType			= DKRS2("FeeType")
						DKRS2_intFee			= Int(DKRS2("intFee"))
						DKRS2_intLimit			= Int(DKRS2("intLimit"))
					Else
						DKRS2_FeeType			= ""
						DKRS2_intFee			= ""
						DKRS2_intLimit			= ""
					End If
					Select Case LCase(DKRS2_FeeType)
						Case "free"
							GoodsDeliveryFeeType	= "무료배송"
							GoodsDeliveryFee		= Int(DKRS_orderEa) * Int(DKRS2_intFee)
							GoodsDeliveryLimit		= DKRS2_intLimit
						Case "prev"
							GoodsDeliveryFeeType	= "선결제"
							GoodsDeliveryFee		= Int(DKRS2_intFee)
							GoodsDeliveryLimit		= DKRS2_intLimit
						Case "next"
							GoodsDeliveryFeeType	= "착불"
							GoodsDeliveryFee		= Int(DKRS2_intFee)
							GoodsDeliveryLimit		= DKRS2_intLimit
					End Select

				End If
			'옵션가격 확인
				GoodsOptionPrice = 0
				GoodsOptionPrice2 = 0
				arrResult = Split(CheckSpace(DKRS_strOption),",")
				For j = 0 To UBound(arrResult)
					arrOption = Split(Trim(arrResult(j)),"\")
					arrOptionTitle = Split(arrOption(0),":")

					GoodsOptionPrice = Int(GoodsOptionPrice) + Int(arrOption(1))
					GoodsOptionPrice2 = Int(GoodsOptionPrice2) + Int(arrOption(2))

				Next


			'구매정보(상품) 입력
				SQL = " INSERT INTO [DK_ORDER_GOODS] ( "
				SQL = SQL & " [orderIDX],[GoodIDX],[strOption],[orderEa],[goodsPrice]"
				SQL = SQL & ",[goodsOptionPrice],[goodsPoint],[GoodsCost],[isShopType],[strShopID]"
				SQL = SQL & ",[GoodsName],[ImgThum],[GoodsDeliveryType],[GoodsDeliveryFeeType],[GoodsDeliveryFee]"
				SQL = SQL & ",[GoodsDeliveryLimit],[status],[isImgType],[GoodsOPTcost],[OrderNum]"
				SQL = SQL & " ) VALUES ( "
				SQL = SQL & " ?, ?, ?, ?, ?"
				SQL = SQL & ",?, ?, ?, ?, ?"
				SQL = SQL & ",?, ?, ?, ?, ?"
				SQL = SQL & ",?, ?, ?, ?, ?"
				SQL = SQL & " ) "
				arrParams = Array(_
					Db.makeParam("@orderIDX",adInteger,adParamInput,4,identity), _
					Db.makeParam("@GoodIDX",adInteger,adParamInput,4,DKRS_GoodIDX), _
					Db.makeParam("@strOption",adVarWChar,adParamInput,512,DKRS_strOption), _
					Db.makeParam("@OrderEa",adInteger,adParamInput,4,DKRS_orderEa),_
					Db.makeParam("@GoodsPrice",adInteger,adParamInput,4,DKRS_GoodsPrice),_

					Db.makeParam("@GoodsOptionPrice",adInteger,adParamInput,4,GoodsOptionPrice),_
					Db.makeParam("@GoodsPoint",adInteger,adParamInput,4,DKRS_GoodsPoint),_
					Db.makeParam("@GoodsCost",adInteger,adParamInput,4,DKRS_GoodsCost),_
					Db.makeParam("@isShopType",adChar,adParamInput,1,DKRS_isShopType),_
					Db.makeParam("@strShopID",adVarChar,adParamInput,50,DKRS_strShopID),_

					Db.makeParam("@GoodsName",adVarWChar,adParamInput,100,DKRS_GoodsName),_
					Db.makeParam("@imgThum",adVarWChar,adParamInput,512,DKRS_imgThum),_
					Db.makeParam("@GoodsDeliveryType",adVarChar,adParamInput,6,DKRS_GoodsDeliveryType),_
					Db.makeParam("@GoodsDeliveryFeeType",adVarWChar,adParamInput,20,GoodsDeliveryFeeType),_
					Db.makeParam("@GoodsDeliveryFee",adInteger,adParamInput,4,GoodsDeliveryFee),_

					Db.makeParam("@GoodsDeliveryLimit",adInteger,adParamInput,4,GoodsDeliveryLimit),_
					Db.makeParam("@status",adChar,adParamInput,3,state),_
					Db.makeParam("@isImgType",adChar,adParamInput,1,DKRS_isImgType),_
					Db.makeParam("@GoodsOPTcost",adInteger,adParamInput,4,GoodsOptionPrice2),_

					Db.makeParam("@OrderNum",adVarchar,adParamInput,20,OrderNum) _
				)
				Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)

		Next
	End If


	'전산입력

	If Err.Number <> 0 Then
		Call alerts("자료를 등록하는 도중 에러가 발생하였습니다.\n\n관리자에게 문의하여 주십시오.","back","")
	Else
		Call gotoURL("/shop/order_finish.asp?orderNum="&OrderNum)
	End If


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

<%

%>
<body>
<form name="frm" method="post" action="./result.asp">
    <input type="hidden " name="res_cd"          value="<%=res_cd%>">          <!-- 결과코드 //-->
    <input type="hidden " name="res_msg"         value="<%=res_msg%>">         <!-- 결과메시지 //-->
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