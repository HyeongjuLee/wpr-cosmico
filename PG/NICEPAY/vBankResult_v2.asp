<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	'NICEPAY 입금통보 수신 DB처리 'https://www.onmong.co.kr/PG/NICEPAY/vBankResult.asp  2021-08-04~
	'V2 : 입금시 주문 승인, 입금일자 업데이트


	'**********************************************************************************
	' 구매자가 입금하면 결제데이터 통보를 수신하여 DB 처리 하는 부분 입니다.
	' 수신되는 필드에 대한 DB 작업을 수행하십시오.
	' 수신필드 자세한 내용은 메뉴얼 참조
	'**********************************************************************************

	PayMethod       = Request("PayMethod")          '지불수단
	M_ID            = Request("MID")                '상점ID
	MallUserID      = Request("MallUserID")         '회원사 ID
	Amt             = Request("Amt")                '금액
	name            = Request("name")               '구매자명
	GoodsName       = Request("GoodsName")          '상품명
	TID             = Request("TID")                '거래번호
	MOID            = Request("MOID")               '주문번호
	AuthDate        = Request("AuthDate")           '입금일시 (yyMMddHHmmss)
	ResultCode      = Request("ResultCode")         '결과코드 ('4110' 경우 입금통보)
	ResultMsg       = Request("ResultMsg")          '결과메시지
	VbankNum        = Request("VbankNum")           '가상계좌번호
	FnCd            = Request("FnCd")               '가상계좌 은행코드
	VbankName       = Request("VbankName")          '가상계좌 은행명
	VbankInputName  = Request("VbankInputName")     '입금자 명
	CancelDate      = Request("CancelDate")         '취소일시

	'**********************************************************************************
	'가상계좌, 계좌이체의 경우 현금영수증 자동발급신청이 되었을경우 전달되며
	'RcptTID 에 값이 있는경우만 발급처리 됨
	'**********************************************************************************
	RcptTID         = Request("RcptTID")            '현금영수증 거래번호
	RcptType        = Request("RcptType")           '현금 영수증 구분(0:미발행, 1:소득공제용, 2:지출증빙용)
	RcptAuthCode    = Request("RcptAuthCode")       '현금영수증 승인번호


	AuthCode        = Request("AuthCode")           '승인번호(추가) / 안 넘겨줄는 경우도 있음


	If TID ="" Or MOID = "" Then Response.End

	CardLogss = "log_vBank"

	On Error Resume Next
	Dim Fso22 : Set  Fso22=CreateObject("Scripting.FileSystemObject")
	Dim LogPath22 : LogPath22 = Server.MapPath (CardLogss&"/np_") & Replace(Date(),"-","") & ".log"
	Dim Sfile22 : Set  Sfile22 = Fso22.OpenTextFile(LogPath22,8,true)

		Sfile22.WriteLine "=========== VBANK AUTH ============= "
		Sfile22.WriteLine "Date : " & now()
		Sfile22.WriteLine "PayMethod     	: " & PayMethod
		Sfile22.WriteLine "M_ID          	: " & M_ID
		Sfile22.WriteLine "MallUserID    	: " & MallUserID
		Sfile22.WriteLine "Amt           	: " & Amt
		Sfile22.WriteLine "name          	: " & name
		Sfile22.WriteLine "GoodsName     	: " & GoodsName
		Sfile22.WriteLine "TID           	: " & TID
		Sfile22.WriteLine "MOID          	: " & MOID
		Sfile22.WriteLine "AuthDate      	: " & AuthDate
		Sfile22.WriteLine "ResultCode    	: " & ResultCode
		Sfile22.WriteLine "ResultMsg     	: " & ResultMsg
		Sfile22.WriteLine "VbankNum      	: " & VbankNum
		Sfile22.WriteLine "FnCd          	: " & FnCd
		Sfile22.WriteLine "VbankName     	: " & VbankName
		Sfile22.WriteLine "VbankInputName	: " & VbankInputName
		Sfile22.WriteLine "RcptTID			: " & RcptTID
		Sfile22.WriteLine "RcptType		: " & RcptType
		Sfile22.WriteLine "RcptAuthCode	: " & RcptAuthCode
		Sfile22.WriteLine "AuthCode	: " & AuthCode
		'Sfile22.WriteLine "CancelDate    	: " & CancelDate


	'가맹점 DB처리

	'**************************************************************************************************
	'**************************************************************************************************
	'결제 데이터 통보 설정 > “OK” 체크박스에 체크한 경우" 만 처리 하시기 바랍니다.
	'**************************************************************************************************
	'TCP인 경우 OK 문자열 뒤에 라인피드 추가
	'위에서 상점 데이터베이스에 등록 성공유무에 따라서 성공시에는 "OK"를 NICEPAY로
	'리턴하셔야합니다. 아래 조건에 데이터베이스 성공시 받는 FLAG 변수를 넣으세요
	'(주의) OK를 리턴하지 않으시면 NICEPAY 서버는 "OK"를 수신할때까지 계속 재전송을 시도합니다
	'기타 다른 형태의 PRINT(response.write)는 하지 않으시기 바랍니다


		vBankTRX		= TID		'거래번호
		vBankAmt		= Amt		'실 입금액
		vBankSetDate	= AuthDate	'입금일시 (yyMMddHHmmss)
		PGAcceptNum		= AuthCode	'승인번호

%>
<%
	'입금시 주문 승인, 입금일자 업데이트
	If ResultCode = "4110" And vBankTRX <> "" Then

		'▣ 기등록 주문 체크 vBankTRX 자릿수(50) 확인!!
		SQL = "SELECT [OrderNum],[MBID],[MBID2],[totalPrice],[CSORDERNUM] FROM [DK_ORDER_TEMP] WITH(NOLOCK)"
		SQL = SQL &" WHERE [payType] = 'vBank' AND [vBankTRX] = ? "
		arrParams = Array(_
			Db.makeParam("@vBankTRX",adVarChar,adParamInput,50,vBankTRX) _
		)
		Set HJRS = DB.execRs(SQL,DB_TEXT,arrParams,DB3)
		If Not HJRS.BOF And Not HJRS.EOF Then
			HJRS_OrderNum		= HJRS("OrderNum")
			HJRS_MBID			= HJRS("MBID")
			HJRS_MBID2			= HJRS("MBID2")
			HJRS_totalPrice		= HJRS("totalPrice")
			HJRS_CSORDERNUM		= HJRS("CSORDERNUM")		'*** 입력여부 확인!
		End IF
		Call closeRS(HJRS)

		Sfile22.WriteLine "WEB_OrderNum		: " & HJRS_OrderNum
		Sfile22.WriteLine "CSORDERNUM		: " & HJRS_CSORDERNUM


		If HJRS_OrderNum <> "" And CStr(CDbl(vBankAmt)) = CStr(CDbl(HJRS_totalPrice)) Then
			Sfile22.WriteLine "UPDATE ~"

			'*** vBankStatus = 'ISSUE' 저장 확인!!


			'▣ 가상계좌 정보 업데이트 [SHOP]
				arrParamsS = array(_
					Db.makeParam("@orderNum",adVarChar,adParamInput,20,HJRS_OrderNum), _
					Db.makeParam("@PGAcceptNum",adVarChar,adParamInput,100,PGAcceptNum),_
					Db.makeParam("@vBankAmt",adDouble,adParamInput,16,vBankAmt), _
					Db.makeParam("@vBankSetDate",adVarChar,adParamInput,20,vBankSetDate), _
					Db.makeParam("@vBankTRX",adVarChar,adParamInput,50,vBankTRX) _
				)
				Call Db.exec("HJSP_VBANK_STATUS_UPDATE2_SHOP",DB_PROC,arrParamsS,Nothing)

			'▣ 가상계좌 정보 업데이트 [CS]
				arrParamsCS = array(_
					Db.makeParam("@orderNum",adVarChar,adParamInput,20,HJRS_OrderNum), _
					Db.makeParam("@PGAcceptNum",adVarChar,adParamInput,100,PGAcceptNum),_
					Db.makeParam("@vBankAmt",adDouble,adParamInput,16,vBankAmt), _
					Db.makeParam("@vBankSetDate",adVarChar,adParamInput,20,vBankSetDate), _
					Db.makeParam("@vBankTRX",adVarChar,adParamInput,50,vBankTRX) _
				)
				Call Db.exec("HJSP_VBANK_STATUS_UPDATE2_CS",DB_PROC,arrParamsCS,DB3)

			'◆ CS 승인번호 UPDATE
				SQL_SCU = "UPDATE [tbl_Sales_Cacu] SET [C_Number2] = ? WHERE [OrderNumber] = ?"
				arrParamsSCU = Array(_
					Db.makeParam("@C_Number2",adVarWChar,adParamInput,100,PGAcceptNum), _
					Db.makeParam("@ORDERNUMBER",adVarChar,adParamInput,20,HJRS_CSORDERNUM) _
				)
				Call Db.exec(SQL_SCU,DB_TEXT,arrParamsSCU,DB3)

			'◆ CS 주문번호 승인
				SQL_STF = "UPDATE [tbl_SalesDetail_TF] SET [SellTF] = 1 WHERE [OrderNumber] = ?"
				arrParamsSTF = Array(_
					Db.makeParam("@ORDERNUMBER",adVarChar,adParamInput,20,HJRS_CSORDERNUM) _
				)
				Call Db.exec(SQL_STF,DB_TEXT,arrParamsSTF,DB3)


			'◆ CS 주문번호 판매일자 UPDATE
				SQL_STF = "UPDATE [tbl_SalesDetail] SET [SellDate] = ? , [SellDate_2] = ? WHERE [OrderNumber] = ?"
				arrParamsSTF = Array(_
					Db.makeParam("@SellDate",adVarChar,adParamInput,10,RegTime), _
					Db.makeParam("@SellDate_2",adVarChar,adParamInput,10,RegTime), _
					Db.makeParam("@ORDERNUMBER",adVarChar,adParamInput,20,HJRS_CSORDERNUM) _
				)
				Call Db.exec(SQL_STF,DB_TEXT,arrParamsSTF,DB3)


			'◆ 승인체크
				SQL_STF = "SELECT [SellTF] FROM [tbl_SalesDetail_TF] WITH(NOLOCK) WHERE [OrderNumber] = ? "
				arrParams_STF = Array(_
					Db.makeParam("@orderNum",adVarChar,adParamInput,20,HJRS_CSORDERNUM) _
				)
				CS_ORDER_SellTF = DB.execRsData(SQL_STF,DB_TEXT,arrParams_STF,DB3)

				Sfile22.WriteLine "CS_ORDER_SellTF		: " & CS_ORDER_SellTF

				If CS_ORDER_SellTF = 1 Then
					Sfile22.WriteLine "OK"
					Response.Write "OK"
				Else
					Sfile22.WriteLine "FAIL"
					Response.Write "FAIL"
				End If

		End If

	End If


	Sfile22.Close
	Set Fso22= Nothing
	Set objError= Nothing
	On Error GoTo 0

	Response.End


	'IF (데이터베이스 등록 성공 유무 조건변수 = true) THEN
	'Response.write "OK"                ' 절대로 지우지마세요
	'ELSE
	'Response.write "FAIL"              ' 절대로 지우지마세요
	'END IF
	'*************************************************************************************************
	'*************************************************************************************************
%>

