<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_lib/strPGFunc.asp"-->
<%

	'ONOFFKOREA 입금통보 수신 DB처리
	'https://www.metac21g.com/PG/ONOFFKOREA/vBankResult.asp		2022-04-29



'vBankSetDate = "202204292106"
	'vBankSetDate = "실입금자"
	'vBankTRX = "20220429973061"
	'vBankAmt = "1980000"
	'dep_noti_id = ""

	'**********************************************************************************
	' 구매자가 입금하면 결제데이터 통보를 수신하여 DB 처리
	'**********************************************************************************
	vBankSetDate	= Request("dep_tx_dt")			'입금시간
	vBankDepName	= Request("dep_name")			'실 입금자
	vBankTRX		= Request("tno")				'거래번호
	vBankAmt		= Request("dep_ipgm_mnyx")		'실 입금액
	dep_noti_id		= Request("dep_noti_id")		'노티 id		(노티아이디는 따로 저장 안 하셔도 무방 합니다)


	''OrderNum		= Request("ordr_idxx")			'가맹점 주문번호(요청후 추가)  , 값이 안 넘어올 때도 있어 빼버림!!  ㅡ.,ㅡ

	CardLogss = "vBankShopAPI"

	On Error Resume Next
	Dim  Fso : Set  Fso=CreateObject("Scripting.FileSystemObject")
	Dim LogPath : LogPath = Server.MapPath (CardLogss&"/vBankR_") & Replace(Date(),"-","") & ".log"
	Dim Sfile : Set  Sfile = Fso.OpenTextFile(LogPath,8,true)

		Sfile.WriteLine chr(13)
		Sfile.WriteLine "Date			: "	& now()
		Sfile.WriteLine "Domain			: "	& Request.ServerVariables("HTTP_HOST")
		Sfile.WriteLine "=== Result Info ============================="
		Sfile.WriteLine "--- vBank Request (FINISH)---------------------"
		Sfile.WriteLine "vBankSetDate		: " & vBankSetDate
		Sfile.WriteLine "vBankDepName		: " & vBankDepName
		Sfile.WriteLine "vBankTRX			: " & vBankTRX
		Sfile.WriteLine "vBankAmt			: " & vBankAmt
		Sfile.WriteLine "dep_noti_id		: " & dep_noti_id
		'Sfile.WriteLine "OrderNum			: " & OrderNum

		If vBankSetDate = "" Or vBankTRX = "" Or  vBankAmt = "" Then
			Sfile.WriteLine "No Data Received"
			Response.End
		End If

		'Call ResRW(	vBankSetDate	,"		vBankSetDate ")
		'Call ResRW(	vBankDepName	,"		vBankDepName ")
		'Call ResRW(	vBankTRX		,"		vBankTRX	 ")
		'Call ResRW(	vBankAmt		,"		vBankAmt	 ")
		'Call ResRW(	dep_noti_id		,"		dep_noti_id	 ")

		'	Response.End

	'	vBankTRX ="20200617511565"
	'	vBankAmt = 1

		If vBankTRX <> "" Then

			''SQL = SQL &" WHERE [payType] = 'vBank' AND [OrderNum] = ? AND [vBankTRX] = ? "
			''	Db.makeParam("@orderNum",adVarChar,adParamInput,20,OrderNum), _

			'▣ 기등록 주문 체크
			arrParams = Array(_
				Db.makeParam("@vBankTRX",adVarChar,adParamInput,20,vBankTRX), _
				Db.makeParam("@payType",adVarChar,adParamInput,20,"vBank") _
			)
			Set HJRS = DB.execRs("DKSP_ORDER_TEMP_CHECK",DB_PROC,arrParams,DB3)
			If Not HJRS.BOF And Not HJRS.EOF Then
				HJRS_OrderNum		= HJRS("OrderNum")
				HJRS_MBID			= HJRS("MBID")
				HJRS_MBID2			= HJRS("MBID2")
				HJRS_totalPrice		= HJRS("totalPrice")
				HJRS_CSORDERNUM		= HJRS("CSORDERNUM")
			End IF
			Call closeRS(HJRS)

			Sfile.WriteLine "WEB_OrderNum		: " & HJRS_OrderNum
			Sfile.WriteLine "CSORDERNUM		: " & HJRS_CSORDERNUM


			If HJRS_OrderNum <> "" And CStr(CDbl(vBankAmt)) = CStr(CDbl(HJRS_totalPrice)) Then
			Sfile.WriteLine "UPDATE ~"

				'▣ 가상계좌 정보 업데이트 [SHOP]
					arrParamsS = array(_
						Db.makeParam("@orderNum",adVarChar,adParamInput,20,HJRS_OrderNum), _
						Db.makeParam("@vBankAmt",adDouble,adParamInput,16,vBankAmt), _
						Db.makeParam("@vBankSetDate",adVarChar,adParamInput,20,vBankSetDate), _
						Db.makeParam("@vBankTRX",adVarChar,adParamInput,20,vBankTRX) _
					)
					Call Db.exec("HJSP_VBANK_STATUS_UPDATE2_SHOP",DB_PROC,arrParamsS,Nothing)

				'▣ 가상계좌 정보 업데이트 [CS]
					arrParamsCS = array(_
						Db.makeParam("@orderNum",adVarChar,adParamInput,20,HJRS_OrderNum), _
						Db.makeParam("@vBankAmt",adDouble,adParamInput,16,vBankAmt), _
						Db.makeParam("@vBankSetDate",adVarChar,adParamInput,20,vBankSetDate), _
						Db.makeParam("@vBankTRX",adVarChar,adParamInput,20,vBankTRX) _
					)
					Call Db.exec("HJSP_VBANK_STATUS_UPDATE2_CS",DB_PROC,arrParamsCS,DB3)



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

					Sfile.WriteLine "CS_ORDER_SellTF		: " & CS_ORDER_SellTF

					IF CS_ORDER_SellTF = 1 Then

						'=== 직판공제번호발급 ====
						If isMACCO = "T" Then
							mbid1 = HJRS_MBID
							mbid2 = HJRS_MBID2
							Sfile.WriteLine "isMACCO	: " & isMACCO
							Sfile.WriteLine "mbid1	: " & mbid1
							Sfile.WriteLine "mbid2	: " & mbid1
						%>
							<!--#include virtual = "/MACCO/_inc_MACCO_Report.asp"-->
						<%
							End if

							'=== 특판공제번호발급 ====
							If MLM_TF = "T" Then
								OUT_ORDERNUMBER = HJRS_CSORDERNUM
								DK_MEMBER_ID1 = HJRS_MBID
								DK_MEMBER_ID2 = HJRS_MBID2
								Sfile.WriteLine "MLM_TF	: " & MLM_TF
								Sfile.WriteLine "OUT_ORDERNUMBER	: " & OUT_ORDERNUMBER
								Sfile.WriteLine "DK_MEMBER_ID1	: " & DK_MEMBER_ID1
								Sfile.WriteLine "DK_MEMBER_ID2	: " & DK_MEMBER_ID2
						%>
							<!--#include virtual = "/MLM/_inc_MLM_Report.asp"-->
						<%
							End if

								'알림톡 전송, (메타21, 가상계좌 입금시에만 2022-05-27)
								requestInfos = ""
								Call FN_PPURIO_MESSAGE(DK_MEMBER_ID1, DK_MEMBER_ID2, "order", "at", OUT_ORDERNUMBER, requestInfos)

							'♠온오프코리아 현금영수증 발급(가상계좌 입금시)
							Call PG_ONOFFKOREA_CASH_RECEIPT(TX_ONOFF_TID, vBankAmt, HJRS_CSORDERNUM)

					End IF


			End If

		End If


	Sfile.Close
	Set Fso= Nothing
	Set objError= Nothing
	On Error GoTo 0

	Response.end
%>
