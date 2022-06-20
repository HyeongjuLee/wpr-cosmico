<!--METADATA TYPE="typelib" NAME="ADODB Type Library" FILE="C:\Program Files\Common Files\System\ado\msado15.dll"-->
<!--#include file = "DAOU_FUNCTION.ASP"-->

<%

	'스피나 신버전 쇼핑몰구매(cs연동) (MYOFFICE, SHOP 구매) [키인] 2017-05-16 ~

	'로그저장폴더
	LOG_cardCS		= "cardCS"
	LOG_cardShop	= "cardShop"

	DAOU_PAYMETHOD				= Request("PAYMETHOD")					'10	결제수단(CARD)	상수
	DAOU_CPID					= Request("CPID")						'20	상점ID 	다우페이에서 부여
	DAOU_DAOUTRX				= Request("DAOUTRX")					'20	다우거래번호
	DAOU_ORDERNO				= Request("ORDERNO")					'50	주문번호
	DAOU_AMOUNT					= Request("AMOUNT")						'10	결제금액
	DAOU_SETTDATE				= Request("SETTDATE")					'14	결제일자(YYYYMMDDhh24miss)
	DAOU_EMAIL					= Request("EMAIL")						'100	고객 E-MAIL(고객이 입력한 경우)
	DAOU_CARDCODE				= Request("CARDCODE")					'4	카드사코드
	DAOU_CARDNAME				= Request("CARDNAME")					'20	카드사명
	DAOU_USERID					= Request("USERID")						'30	고객 ID
	DAOU_USERNAME				= Request("USERNAME")					'50	구매자명
	DAOU_PRODUCTCODE			= Request("PRODUCTCODE")				'10	상품코드
	DAOU_PRODUCTNAME			= Request("PRODUCTNAME")				'50	상품명
	DAOU_RESERVEDINDEX1			= Request("RESERVEDINDEX1")				'20	예약항목1(내부에서 INDEX로 관리)		'다온샵 OrdNo
	DAOU_RESERVEDINDEX2			= Request("RESERVEDINDEX2")				'20	예약항목2(내부에서 INDEX로 관리)		'다온샵 DK_MEMBER_ID
'	DAOU_RESERVEDSTRING			= Request("RESERVEDSTRING")				'1024	예약항목
	DAOU_AUTHNO					= Request("AUTHNO")						'신용카드 승인번호
	DAOU_CARDNO					= Request("CARDNO")						'신용카드 번호

	Select Case UCase(DAOU_RESERVEDINDEX1)
		'▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣
		Case "MYOFFICE","MYOFFICE_MOB"

		DAOU_RESERVEDSTRING		= Request("RESERVEDSTRING")				'1024	예약항목 | 웹프로에서는 데이터전송용으로 사용

			'로그기록생성 S ============================================================================================
				If LOG_TF = "T" Then
					Dim  Fso : Set  Fso=CreateObject("Scripting.FileSystemObject")
				'	Dim LogPath : LogPath = Server.MapPath ("/PG/DAOU3/cxcLogsCS/te_") & Replace(Date(),"-","") & ".log"
				'	Dim LogPath : LogPath = Server.MapPath ("cardCS/te_") & Replace(Date(),"-","") & ".log"
					Dim LogPath : LogPath = Server.MapPath (LOG_cardCS&"/te_") & Replace(Date(),"-","") & ".log"
					Dim Sfile : Set  Sfile = Fso.OpenTextFile(LogPath,8,true)

					Sfile.WriteLine "Date : " & now()
					Sfile.WriteLine "Domain : " & Request.ServerVariables("HTTP_HOST")
					Sfile.WriteLine "Browser : " & Request.ServerVariables("HTTP_USER_AGENT")

					Sfile.WriteLine "THIS_PAGE_URL		 : " & Request.ServerVariables("URL")&"?"&Request.ServerVariables("QUERY_STRING")
					Sfile.WriteLine "DAOU_PAYMETHOD		 : " & DAOU_PAYMETHOD
					Sfile.WriteLine "DAOU_CPID			 : " & DAOU_CPID
					Sfile.WriteLine "DAOU_DAOUTRX		 : " & DAOU_DAOUTRX
					Sfile.WriteLine "DAOU_ORDERNO		 : " & DAOU_ORDERNO
					Sfile.WriteLine "DAOU_AMOUNT		 : " & DAOU_AMOUNT
					Sfile.WriteLine "DAOU_SETTDATE		 : " & DAOU_SETTDATE
					Sfile.WriteLine "DAOU_EMAIL			 : " & DAOU_EMAIL
					Sfile.WriteLine "DAOU_CARDCODE		 : " & DAOU_CARDCODE
					'Sfile.WriteLine "DAOU_CARDNAME		 : " & DAOU_CARDNAME
					Sfile.WriteLine "DAOU_USERID		 : " & DAOU_USERID
					Sfile.WriteLine "DAOU_USERNAME		 : " & DAOU_USERNAME
					Sfile.WriteLine "DAOU_PRODUCTCODE	 : " & DAOU_PRODUCTCODE
					Sfile.WriteLine "DAOU_PRODUCTNAME	 : " & DAOU_PRODUCTNAME
					Sfile.WriteLine "DAOU_RESERVEDINDEX1 : " & DAOU_RESERVEDINDEX1
					Sfile.WriteLine "DAOU_RESERVEDINDEX2 : " & DAOU_RESERVEDINDEX2
					Sfile.WriteLine "DAOU_RESERVEDSTRING : " & DAOU_RESERVEDSTRING
					Sfile.WriteLine "DAOU_AUTHNO		 : " & DAOU_AUTHNO
					Sfile.WriteLine "DAOU_CARDNO		 : " & Left(DAOU_CARDNO,6)&"**********"

					DAOU_SPLIT = Split(DAOU_RESERVEDSTRING,"☞")
					DAOU_UBOUND = Ubound(DAOU_SPLIT)

					Sfile.WriteLine "takeName			 : " & Trim(DAOU_SPLIT(0))
					Sfile.WriteLine "mbid1				 : " & Trim(DAOU_SPLIT(1))
					Sfile.WriteLine "mbid2				 : " & Trim(DAOU_SPLIT(2))
					Sfile.WriteLine "takeTel			 : " & Trim(DAOU_SPLIT(3))
					Sfile.WriteLine "takeMob			 : " & Trim(DAOU_SPLIT(4))
					Sfile.WriteLine "strEmail			 : " & Trim(DAOU_SPLIT(5))
					Sfile.WriteLine "takeZip			 : " & Trim(DAOU_SPLIT(6))
					Sfile.WriteLine "takeADDR1			 : " & Trim(DAOU_SPLIT(7))
					Sfile.WriteLine "takeADDR2			 : " & Trim(DAOU_SPLIT(8))
					Sfile.WriteLine "totalPrice			 : " & Trim(DAOU_SPLIT(9))
					Sfile.WriteLine "totalDelivery		 : " & Trim(DAOU_SPLIT(10))
					Sfile.WriteLine "totalOptionPrice	 : " & Trim(DAOU_SPLIT(11))
					Sfile.WriteLine "totalPoint			 : " & Trim(DAOU_SPLIT(12))
					Sfile.WriteLine "strOption			 : " & Trim(DAOU_SPLIT(13))
					Sfile.WriteLine "totalVotePoint		 : " & Trim(DAOU_SPLIT(14))
					Sfile.WriteLine "cuidx				 : " & Trim(DAOU_SPLIT(15))
					Sfile.WriteLine "paykind			 : " & Trim(DAOU_SPLIT(16))
					Sfile.WriteLine "v_SellCode			 : " & Trim(DAOU_SPLIT(17))
					Sfile.WriteLine "usePoint			 : " & Trim(DAOU_SPLIT(18))
					Sfile.WriteLine "isDownOrder		 : " & Trim(DAOU_SPLIT(19))
					Sfile.WriteLine "DtoD				 : " & Trim(DAOU_SPLIT(20))

					Sfile.WriteLine chr(13)
					Sfile.Close
					Set Fso= Nothing
					Set objError= Nothing
				End If
			'로그기록생성 E ============================================================================================



			OrderNum = DAOU_ORDERNO
			OIDX = DAOU_RESERVEDINDEX2


		'	Select Case UCase(DAOU_RESERVEDINDEX2)
		'		Case "CARD"
					DAOU_SPLIT = Split(DAOU_RESERVEDSTRING,"☞")
					DAOU_UBOUND = Ubound(DAOU_SPLIT)

					Dim takeName			: takeName				= Trim(DAOU_SPLIT(0))

					Dim mbid1				: mbid1					= Trim(DAOU_SPLIT(1))		'본인 or 직하선 소비자 번호
					Dim mbid2				: mbid2					= Trim(DAOU_SPLIT(2))
					Dim takeTel				: takeTel				= Trim(DAOU_SPLIT(3))
					Dim takeMob				: takeMob				= Trim(DAOU_SPLIT(4))
					Dim strEmail			: strEmail				= Trim(DAOU_SPLIT(5))

					Dim takeZip				: takeZip				= Trim(DAOU_SPLIT(6))
					Dim takeADDR1			: takeADDR1				= Trim(DAOU_SPLIT(7))
					Dim takeADDR2			: takeADDR2				= Trim(DAOU_SPLIT(8))
					Dim totalPrice			: totalPrice			= Trim(DAOU_SPLIT(9))
					Dim totalDelivery		: totalDelivery			= Trim(DAOU_SPLIT(10))		'배송비

					Dim totalOptionPrice	: totalOptionPrice		= Trim(DAOU_SPLIT(11))
					Dim totalPoint			: totalPoint			= Trim(DAOU_SPLIT(12))
					Dim strOption			: strOption				= Trim(DAOU_SPLIT(13))
					Dim totalVotePoint		: totalVotePoint		= Trim(DAOU_SPLIT(14))
				'	Dim inUidx				: inUidx				= Trim(DAOU_SPLIT(15))
					Dim cuidx				: cuidx					= Trim(DAOU_SPLIT(15))		'카트 idx

					Dim paykind				: paykind				= Trim(DAOU_SPLIT(16))
					Dim v_SellCode			: v_SellCode			= Trim(DAOU_SPLIT(17))
					Dim usePoint			: usePoint				= CDbl(Trim(DAOU_SPLIT(18)))
					Dim isDownOrder			: isDownOrder			= Trim(DAOU_SPLIT(19))
					Dim DtoD				: DtoD					= Trim(DAOU_SPLIT(20))

					If usePoint = Null Or usePoint = "" Then usePoint = 0
					If DtoD = Null Or DtoD = "" Then DtoD = "T"

					totalPrice = CDbl(totalPrice) + CDbl(usePoint)		'▣주문임시테이블 합계금 업데이트


					arrUidx = Split(cuidx,",")

					'OrderNum = DAOU_ORDERNO
					'OIDX = DAOU_RESERVEDINDEX1

					'If usePoint = Null Or usePoint = "" Then usePoint = 0

					'If v_SellCode = "02" And nowGradeCnt < 20  Then Call ALERTS("비지니스 회원 매출은 메니져 이상만 가능합니다..","back","")

					Select Case UCase(paykind)
						Case "CARD"
							v_C_Etc = DAOUPAY_CARDCODE(DAOU_CARDCODE) &"/"&DAOU_DAOUTRX&"/"&OrderNum ' 카드사코드/다우거래번호/내부거래번호
							payState = "103"

							PGCardNum_MACCO		= Left(DAOU_CARDNO,6)				'카드번호 6자리(직판신고용 ,2016-09-19)
							PGCardNum			= DAOU_CARDNO						'카드번호 12자리
							'카드번호* 처리
							C_Number_LEN = 0
							C_Number_LEFT = ""
							C_Number_LEN = Len(PGCardNum)
							C_Number_LEFT = Left(PGCardNum,(C_Number_LEN-12))
							PGCardNum = C_Number_LEFT & "************"

							PGAcceptNum			= DAOU_AUTHNO						'신용카드 승인번호
							PGinstallment		= ""								'할부기간
							PGCardCode			= DAOUPAY_CARDCODE(DAOU_CARDCODE)	'신용카드사코드
							PGCardCom			= ""								'신용카드발급사
							PGACP_TIME			= DAOU_SETTDATE						'이니시스승인날짜/시각

							If CARD_Quota = "00" Then CARD_Quota = "일시불"

							' 이하 카드결제시 필요없는 변수
							DIR_CSHR_Type		= ""
							DIR_CSHR_ResultCode	= ""
							DIR_ACCT_BankCode	= ""
							payBankCode			= ""
							payBankAccNum		= ""
							payBankDate			= ""
							payBankSendName		= ""
							payBankAcceptName	= ""

							Select Case isDownOrder		'F : 본인매출,	T : 본인직하선매출
								Case "F"
									DKP_ORDER_UPDATE_PROCEDURE = "DKP_ORDER_CARD_INFO_UPDATE_NEW"
									DKP_ORDER_TOTAL_PROCEDURE  = "DKP_ORDER_TOTAL_NEW"
								Case "T"
									DKP_ORDER_UPDATE_PROCEDURE = "HJP_ORDER_4DOWN_CARD_INFO_UPDATE"
									DKP_ORDER_TOTAL_PROCEDURE  = "DKP_ORDER_TOTAL_NEW_4DOWN"
							End Select

							'◈CS신버전 암호화!!
							If DKCONF_SITE_ENC = "T" And DKCONF_ISCSNEW = "T" Then
								Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
									objEncrypter.Key = con_EncryptKey
									objEncrypter.InitialVector = con_EncryptKeyIV
									If takeADDR1			<> "" Then takeADDR1			= objEncrypter.Encrypt(takeADDR1)
									If takeADDR2			<> "" Then takeADDR2			= objEncrypter.Encrypt(takeADDR2)
									If takeMob				<> "" Then takeMob				= objEncrypter.Encrypt(takeMob)
									If takeTel				<> "" Then takeTel				= objEncrypter.Encrypt(takeTel)
									If PGAcceptNum			<> "" Then PGAcceptNum			= objEncrypter.Encrypt(PGAcceptNum)
								Set objEncrypter = Nothing
							End If

							arrParams = Array(_
								Db.makeParam("@intIDX",adInteger,adParamInput,0,OIDX), _
								Db.makeParam("@OrderNum",adVarChar,adParamInput,20,orderNum), _
								Db.makeParam("@totalPrice",adInteger,adParamInput,0,totalPrice), _
								Db.makeParam("@takeName",adVarWChar,adParamInput,100,takeName), _
								Db.makeParam("@takeZip",adVarChar,adParamInput,10,takeZip), _
								Db.makeParam("@takeADDR1",adVarWChar,adParamInput,512,takeADDR1), _
								Db.makeParam("@takeADDR2",adVarWChar,adParamInput,512,takeADDR2), _
								Db.makeParam("@takeMob",adVarChar,adParamInput,50,takeMob), _
								Db.makeParam("@takeTel",adVarChar,adParamInput,50,takeTel), _

								Db.makeParam("@orderType",adVarChar,adParamInput,20,v_SellCode), _
								Db.makeParam("@deliveryFee",adInteger,adParamInput,0,totalDelivery), _
								Db.makeParam("@payType",adVarChar,adParamInput,20,payKind), _
								Db.makeParam("@payState",adChar,adParamInput,3,payState), _

								Db.makeParam("@PGCardNum",adVarChar,adParamInput,100,PGCardNum), _
								Db.makeParam("@PGAcceptNum",adVarChar,adParamInput,100,PGAcceptNum), _
								Db.makeParam("@PGinstallment",adVarChar,adParamInput,50,PGinstallment), _
								Db.makeParam("@PGCardCode",adVarChar,adParamInput,50,PGCardCode), _
								Db.makeParam("@PGCardCom",adVarChar,adParamInput,50,PGCardCom), _
								Db.makeParam("@PGACP_TIME",adVarChar,adParamInput,20,PGACP_TIME), _

								Db.makeParam("@DIR_CSHR_Type",adVarChar,adParamInput,50,DIR_CSHR_Type), _
								Db.makeParam("@DIR_CSHR_ResultCode",adVarChar,adParamInput,50,DIR_CSHR_ResultCode), _
								Db.makeParam("@DIR_ACCT_BankCode",adVarChar,adParamInput,20,DIR_ACCT_BankCode), _

								Db.makeParam("@payBankCode",adVarWChar,adParamInput,50,payBankCode), _
								Db.makeParam("@payBankAccNum",adVarChar,adParamInput,100,payBankAccNum), _
								Db.makeParam("@payBankDate",adVarChar,adParamInput,50,payBankDate), _
								Db.makeParam("@payBankSendName",adVarWChar,adParamInput,100,payBankSendName), _
								Db.makeParam("@payBankAcceptName",adVarWChar,adParamInput,50,payBankAcceptName), _

								Db.makeParam("@PGorderNum",adVarchar,adParamInput,50,DAOU_DAOUTRX), _
								Db.makeParam("@InputMileage",adInteger,adParamInput,4,usePoint), _
								Db.makeParam("@DtoD",adChar,adParamInput,1,DtoD), _

								Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
							)
							Call Db.exec(DKP_ORDER_UPDATE_PROCEDURE,DB_PROC,arrParams,DB3)
							ORDER_TEMP_OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
							Select Case ORDER_TEMP_OUTPUT_VALUE
								Case "FINISH"
								Case "ERROR"
									Response.Write DAOU_ERROR : Response.End
								Case "NOTORDER"
									Response.Write DAOU_ERROR : Response.End
								Case Else
									Response.Write DAOU_ERROR : Response.End
							End Select



							nowTime = Now
							RegTime = Right("0000"&Year(nowTime),4) & Right("00"&Month(nowTime),2) & Right("00"&Day(nowTime),2)
							Recordtime = Left(nowTime,10) & " "& Right("00"&Hour(nowTime),2) &":"&Right("00"&Minute(nowTime),2) &":"&Right("00"&Second(nowTime),2)



							arrParams = Array(_
								Db.makeParam("@identity",adInteger,adParamInput,4,CS_IDENTITY), _

								Db.makeParam("@OrderNum",adVarChar,adParamInput,20,orderNum),_
								Db.makeParam("@v_SellDAte",adVarChar,adParamInput,10,RegTime),_

								Db.makeParam("@v_Etc1",adVarWChar,adParamInput,250,v_C_Etc),_
								Db.makeParam("@v_Etc2",adVarWChar,adParamInput,250,"웹주문번호:"&orderNum),_

								Db.makeParam("@v_C_Code",adVarChar,adParamInput,50,PGCardCode),_
								Db.makeParam("@v_C_Number1",adVarChar,adParamInput,100,PGCardNum),_
								Db.makeParam("@v_C_Number2",adVarChar,adParamInput,100,PGAcceptNum),_
								Db.makeParam("@v_C_Name1",adVarWChar,adParamInput,50,takeName),_
								Db.makeParam("@v_C_Name2",adVarWChar,adParamInput,50,payBankSendName),_

								Db.makeParam("@v_C_Period1",adVarChar,adParamInput,4,""),_
								Db.makeParam("@v_C_Period2",adVarChar,adParamInput,2,""),_
								Db.makeParam("@v_C_Installment_Period",adVarChar,adParamInput,10,PGinstallment),_

								Db.makeParam("@OUT_ORDERNUMBER",adVarChar,adParamOutput,50,""), _
								Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
							)
							Call Db.exec(DKP_ORDER_TOTAL_PROCEDURE,DB_PROC,arrParams,DB3)
							OUT_ORDERNUMBER = arrParams(UBound(arrParams)-1)(4)
							OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)

							'■직판용 Cacu테이블 신용/체크 구분자 [C_Card_Sort] Update (web Card결제시, 월드글로벌이후 20160919 ~)■
							If MACCO_TF = "T" And insNUM4PassBook = "T" And PGCardNum_MACCO <> "" Then
								SQL_ST1 = "SELECT [Card_Sort_Code] FROM [tbl_Sales_Cacu_CardBin] WHERE [BinNumber] = ? "
								arrParams_ST1 = Array(_
									Db.makeParam("@Card_Sort_Code",adInteger,adParamInput,4,PGCardNum_MACCO)_
								)
								RS_Card_Sort_Code = Db.execRsData(SQL_ST1,DB_TEXT,arrParams_ST1,DB3)

								Select Case RS_Card_Sort_Code		'C_Card_Sort 신용카드 '0' 체크카드는 '1' 나머지 ''
									Case "0","1"
										RS_Card_Sort_Code = RS_Card_Sort_Code
									Case Else
										RS_Card_Sort_Code = ""
								End Select

								SQL_ST2 = "UPDATE [tbl_Sales_Cacu] SET [C_Card_Sort] = ? WHERE [OrderNumber] = ? And [C_TF] = 3 And [RecordID] = 'web' "
								arrParams_ST2 = Array(_
									Db.makeParam("@C_Card_Sort",adVarChar,adParamInput,6,RS_Card_Sort_Code) ,_
									Db.makeParam("@OUT_ORDERNUMBER",adVarChar,adParamInput,50,OUT_ORDERNUMBER) _
								)
								Call Db.exec(SQL_ST2,DB_TEXT,arrParams_ST2,DB3)
							End If

							If MACCO_TF = "T" And insNUM4PassBook = "T" Then		'암호화/직판 CS상품구매일때/▣▣▣ 무통장구매시 공제번호 실시간 발생!! ▣▣▣
%>
							<!--#include virtual = "/MACCO/_inc_MACCO_Report.asp"-->
<%
							End If

							Select Case OUTPUT_VALUE
								Case "FINISH" : Response.Write DAOU_SUCCESS
								'Case "FINISH"
								'	'카트삭제
								'	For i = 0 To UBound(arrUidx)
								'		SQL = "DELETE FROM [DK_CART] WHERE [intIDX] = ? AND [MBID] = ? AND [MBID2] = ?"
								'		arrParams = Array(_
								'			Db.makeParam("@intIDX",adInteger,adParamInput,0,arrUidx(i)), _
								'			Db.makeParam("@MBID",adVarChar,adParamInput,20,mbid1),_
								'			Db.makeParam("@MBID2",adInteger,adParamInput,0,mbid2)_
								'		)
								'		Call Db.exec(SQL,DB_TEXT,arrParams,DB3)
								'	Next
								'	Response.Write DAOU_SUCCESS
								Case Else : Response.Write DAOU_ERROR
							End Select


						Case Else
							Response.Write DAOU_ERROR
							Response.End
					End Select

		'▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣▣
		Case "SHOP"

			DAOU_RESERVEDSTRING		= Request("RESERVEDSTRING")				'1024	예약항목 | 웹프로에서는 데이터전송용으로 사용


			Dim  Fso2 : Set  Fso2=CreateObject("Scripting.FileSystemObject")
		'	Dim LogPath2 : LogPath2 = Server.MapPath ("/PG/DAOU/cardShop/te_") & Replace(Date(),"-","") & ".log"
		'	Dim LogPath2 : LogPath2 = Server.MapPath ("cardShop/te_") & Replace(Date(),"-","") & ".log"
			Dim LogPath2 : LogPath2 = Server.MapPath (LOG_cardShop&"/te_") & Replace(Date(),"-","") & ".log"
			Dim Sfile2 : Set  Sfile2 = Fso2.OpenTextFile(LogPath2,8,true)

			Sfile2.WriteLine chr(13)
			Sfile2.WriteLine "Date : " & now()
			Sfile2.WriteLine "Domain : " & Request.ServerVariables("HTTP_HOST")
			Sfile2.WriteLine "Browser : " & Request.ServerVariables("HTTP_USER_AGENT")

			Sfile2.WriteLine "THIS_PAGE_URL		 : " & Request.ServerVariables("URL")&"?"&Request.ServerVariables("QUERY_STRING")
			Sfile2.WriteLine "strName : " & strName
		'	Sfile2.WriteLine "var1: " & var1
			Sfile2.WriteLine "DAOU_DAOUTRX		 : " & DAOU_DAOUTRX
			Sfile2.WriteLine "DAOU_ORDERNO		 : " & DAOU_ORDERNO
			Sfile2.WriteLine "DAOU_AMOUNT		 : " & DAOU_AMOUNT
			Sfile2.WriteLine "DAOU_SETTDATE		 : " & DAOU_SETTDATE
			Sfile2.WriteLine "DAOU_EMAIL			 : " & DAOU_EMAIL
			Sfile2.WriteLine "DAOU_CARDCODE		 : " & DAOU_CARDCODE
			Sfile2.WriteLine "DAOU_USERID		 : " & DAOU_USERID
			Sfile2.WriteLine "DAOU_USERNAME		 : " & DAOU_USERNAME
			Sfile2.WriteLine "DAOU_PRODUCTCODE	 : " & DAOU_PRODUCTCODE
			Sfile2.WriteLine "DAOU_PRODUCTNAME	 : " & DAOU_PRODUCTNAME
			Sfile2.WriteLine "DAOU_RESERVEDINDEX1 : " & DAOU_RESERVEDINDEX1
			Sfile2.WriteLine "DAOU_RESERVEDINDEX2 : " & DAOU_RESERVEDINDEX2
			Sfile2.WriteLine "DAOU_RESERVEDSTRING : " & DAOU_RESERVEDSTRING
			Sfile2.WriteLine "DAOU_AUTHNO		 : " & DAOU_AUTHNO
			Sfile2.WriteLine "DAOU_CARDNO		 : " & Left(DAOU_CARDNO,6)&"**********"

			Function CheckSpace(CheckValue)
			 CheckValue = trim(CheckValue)                      '양쪽공백을 없애준다.
			 CheckValue = replace(CheckValue, "&nbsp;", "")  '  html &nbsp; <-공백  을  "" <과 같이 붙인다.
			 CheckValue = replace(CheckValue, " ", "")  '  " " <-공백을 "" <- 붙인다.
			 CheckSpace=CheckValue
			End Function

		'	DAOU_RESERVEDSTRING			= UrlDecode_GBToUtf8(DAOU_RESERVEDSTRING)


			DAOU_SPLIT = Split(DAOU_RESERVEDSTRING,"☞")
			DAOU_UBOUND = Ubound(DAOU_SPLIT)

			strName						= Trim(DAOU_SPLIT(0))
			strTel						= Trim(DAOU_SPLIT(1))
			strMob						= Trim(DAOU_SPLIT(2))
			strEmail					= Trim(DAOU_SPLIT(3))
			strZip						= Trim(DAOU_SPLIT(4))
			strADDR1					= Trim(DAOU_SPLIT(5))
			strADDR2					= Trim(DAOU_SPLIT(6))

			takeName					= Trim(DAOU_SPLIT(7))
			takeTel						= Trim(DAOU_SPLIT(8))
			takeMob						= Trim(DAOU_SPLIT(9))
			takeZip						= Trim(DAOU_SPLIT(10))
			takeADDR1					= Trim(DAOU_SPLIT(11))
			takeADDR2					= Trim(DAOU_SPLIT(12))

			totalPrice					= Trim(DAOU_SPLIT(13))
			totalDelivery				= Trim(DAOU_SPLIT(14))
			totalOptionPrice			= Trim(DAOU_SPLIT(15))
			totalPoint					= Trim(DAOU_SPLIT(16))
			orderMemo					= Trim(DAOU_SPLIT(17))

			input_mode					= Trim(DAOU_SPLIT(18))
			strOption					= Trim(DAOU_SPLIT(19))
			totalVotePoint				= Trim(DAOU_SPLIT(20))
			inUidx						= Trim(DAOU_SPLIT(21))
			paykind						= Trim(DAOU_SPLIT(22))

			usePoint					= Trim(DAOU_SPLIT(23))
			totalOptionPrice2			= Trim(DAOU_SPLIT(24))
			Daou_MEMBER_ID				= Trim(DAOU_SPLIT(25))
			Daou_MEMBER_ID1				= Trim(DAOU_SPLIT(26))
			Daou_MEMBER_ID2				= Trim(DAOU_SPLIT(27))

			Daou_MEMBER_WEBID			= Trim(DAOU_SPLIT(28))
			Daou_MEMBER_NAME			= Trim(DAOU_SPLIT(29))
			Daou_MEMBER_LEVEL			= Trim(DAOU_SPLIT(30))
			Daou_MEMBER_TYPE			= Trim(DAOU_SPLIT(31))
			Daou_MEMBER_STYPE			= Trim(DAOU_SPLIT(32))
			Daou_MEMBER_NATIONCODE		= Trim(DAOU_SPLIT(33))			'Daou_MEMBER_NATIONCODE
			DK_MEMBER_NATIONCODE		= Daou_MEMBER_NATIONCODE

			isSpecialSell				= Trim(DAOU_SPLIT(34))
			CSGoodCnt					= Trim(DAOU_SPLIT(35))
			v_SellCode					= Trim(DAOU_SPLIT(36))
			SalesCenter       			= Trim(DAOU_SPLIT(37))
			DtoD              			= Trim(DAOU_SPLIT(38))
			ea							= Trim(DAOU_SPLIT(39))




			Sfile2.WriteLine "strName			: " & strName
			Sfile2.WriteLine "strTel			: " & strTel
			Sfile2.WriteLine "strMob			: " & strMob
			Sfile2.WriteLine "strEmail			: " & strEmail
			Sfile2.WriteLine "strZip			: " & strZip
			Sfile2.WriteLine "strADDR1			: " & strADDR1
			Sfile2.WriteLine "strADDR2			: " & strADDR2

			Sfile2.WriteLine "takeName			: " & takeName
			Sfile2.WriteLine "takeTel			: " & takeTel
			Sfile2.WriteLine "takeMob			: " & takeMob
			Sfile2.WriteLine "takeZip			: " & takeZip
			Sfile2.WriteLine "takeADDR1			: " & takeADDR1
			Sfile2.WriteLine "takeADDR2			: " & takeADDR2

			Sfile2.WriteLine "totalPrice		: " & totalPrice
			Sfile2.WriteLine "totalDelivery		: " & totalDelivery
			Sfile2.WriteLine "totalOptionPrice	: " & totalOptionPrice
			Sfile2.WriteLine "totalPoint		: " & totalPoint
			Sfile2.WriteLine "orderMemo			: " & orderMemo

			Sfile2.WriteLine "input_mode		: " & input_mode
			Sfile2.WriteLine "strOption			: " & strOption
			Sfile2.WriteLine "totalVotePoint	: " & totalVotePoint
			Sfile2.WriteLine "inUidx			: " & inUidx
			Sfile2.WriteLine "paykind			: " & paykind

			Sfile2.WriteLine "usePoint			: " & usePoint
			Sfile2.WriteLine "totalOptionPrice2	: " & totalOptionPrice2
			Sfile2.WriteLine "Daou_MEMBER_ID	: " & Daou_MEMBER_ID
			Sfile2.WriteLine "Daou_MEMBER_ID1	: " & Daou_MEMBER_ID1
			Sfile2.WriteLine "Daou_MEMBER_ID2	: " & Daou_MEMBER_ID2

			Sfile2.WriteLine "Daou_MEMBER_WEBID	: " & Daou_MEMBER_WEBID
			Sfile2.WriteLine "Daou_MEMBER_NAME	: " & Daou_MEMBER_NAME
			Sfile2.WriteLine "Daou_MEMBER_LEVEL	: " & Daou_MEMBER_LEVEL
			Sfile2.WriteLine "Daou_MEMBER_TYPE	: " & Daou_MEMBER_TYPE
			Sfile2.WriteLine "Daou_MEMBER_STYPE	: " & Daou_MEMBER_STYPE
			Sfile2.WriteLine "Daou_MEMBER_NATIONCODE: " & Daou_MEMBER_NATIONCODE

			Sfile2.WriteLine "isSpecialSell		: " & isSpecialSell
			Sfile2.WriteLine "CSGoodCnt			: " & CSGoodCnt
			Sfile2.WriteLine "v_SellCode		: " & v_SellCode
			Sfile2.WriteLine "SalesCenter       : " & SalesCenter
			Sfile2.WriteLine "DtoD              : " & DtoD
			Sfile2.WriteLine "ea				: " & ea

			ordersNumber = DAOU_ORDERNO


			Dim bankidx : bankidx = ""
			Dim bankingName : bankingName = ""

			Dim strSSH1 : strSSH1 = ""
			Dim strSSH2 : strSSH2 = ""

			'CS 관련 & 특이사항
			'If daou_MEMBER_TYPE = "COMPANY" And Daou_MEMBER_STYPE = "0" Then
			If daou_MEMBER_TYPE = "COMPANY" And CSGoodCnt > 0 Then

				v_SellCode		= v_SellCode	'CS상품 구매종류
				SalesCenter		= SalesCenter	'판매센터
				DtoD			= DtoD			'배송구분
			Else
				v_SellCode		= ""
				SalesCenter		= ""
				DtoD			= "T"
			End If

			If usePoint = Null Or usePoint = "" Then usePoint = 0

			OrderNum = ordersNumber

			payway		 = "card"
			strDomain	 = strHostA
			strIDX		 = DK_SES_MEMBER_IDX
			strUserID	 = DAOU_RESERVEDINDEX2


		'	If strTel1 <> "" And strTel2 <> "" And strTel3 <> "" Then strTel = strTel1 & "-" & strTel2 & "-" & strTel3
		'	If strMob1 <> "" And strMob2 <> "" And strMob3 <> "" Then strMob = strMob1 & "-" & strMob2 & "-" & strMob3
		'	If takeTel1 <> "" And takeTel2 <> "" And takeTel3 <> "" Then takeTel = takeTel1 & "-" & takeTel2 & "-" & takeTel3
		'	If takeMob1 <> "" And takeMob2 <> "" And takeMob3 <> "" Then takeMob = takeMob1 & "-" & takeMob2 & "-" & takeMob3
		'	If takeTel = "" Then takeTel = ""
		'	If takeMob = "" Then takeMob = ""

			CARD_ACP_TIME = SETTDATE

			state = "101"


			'/*-- 카드사 정보 -------------*/
			state = "101"							'입금확인
			payway = "card"

			PGCardNum_MACCO	= Left(DAOU_CARDNO,6)	'카드번호 6자리(직판신고용 ,2016-09-19)
			PGCardNum		= DAOU_CARDNO			'카드번호 12자리
			'카드번호* 처리
			C_Number_LEN = 0
			C_Number_LEFT = ""
			C_Number_LEN = Len(PGCardNum)
			C_Number_LEFT = Left(PGCardNum,(C_Number_LEN-12))
			PGCardNum = C_Number_LEFT & "************"

			PGAcceptNum		= DAOU_AUTHNO			'신용카드 승인번호
			PGinstallment	= ""					'할부기간
			PGCardCode		= DAOUPAY_CARDCODE(DAOU_CARDCODE)	'신용카드사코드
			PGCardCom		= ""					'신용카드발급사
			status101Date	= CARD_ACP_TIME			'승인날짜/시각




		'		Call ResRW(inUidx,"장바구니 확인")
		'
		'		Call ResRw(strDomain,"도메인")
		'		Call ResRw(OrderNum,"주문번호")
		'		Call ResRw(strIDX,"쿠키값")
		'		Call ResRw(strUserID,"유저아이디")
		'		Call ResRw(payWay,"결제방식")
		'		Call ResRw(totalPrice,"총 결제금액")
		'		Call ResRw(totalDelivery,"총 배송비")
		'		Call ResRw(totalOptionPrice,"총 옵션가")
		'		Call ResRw(totalPoint,"총 포인트")
		'		Call ResRw(strName,"이름")
		'		Call ResRw(strTel,"전화")
		'		Call ResRw(strMob,"휴대전화")
		'		Call ResRw(strEmail,"이메일")
		'		Call ResRw(strZip,"우편번호")
		'		Call ResRw(strADDR1,"주소1")
		'		Call ResRw(strADDR2,"주소2")
		'		Call ResRw(takeName,"받는이")
		'		Call ResRw(takeTel,"받는이 연락처")
		'		Call ResRw(takeMob,"받는이 휴대전화")
		'		Call ResRw(takeZip,"받는이 우편번호")
		'		Call ResRw(takeADDR1,"받는이 주소1")
		'		Call ResRw(takeADDR2,"받는이 주소2")
		'		Call ResRw(state,"상태")
		'		Call ResRw(orderMemo,"배송메모")
		'		Call ResRw(strSSH1,"주민등록번호1")
		'		Call ResRw(strSSH2,"주민등록번호2")


			'▣주문정보 암호화
			'	If DKCONF_SITE_ENC = "T" AND Daou_MEMBER_TYPE <> "COMPANY" Then
				If DKCONF_SITE_ENC = "T" And DKCONF_ISCSNEW = "T" Then
					Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
						objEncrypter.Key = con_EncryptKey
						objEncrypter.InitialVector = con_EncryptKeyIV
						If strADDR1				<> "" Then strADDR1					= objEncrypter.Encrypt(strADDR1)
						If strADDR2				<> "" Then strADDR2					= objEncrypter.Encrypt(strADDR2)
						If strTel				<> "" Then strTel					= objEncrypter.Encrypt(strTel)
						If strMob				<> "" Then strMob					= objEncrypter.Encrypt(strMob)
						If takeTel				<> "" Then takeTel					= objEncrypter.Encrypt(takeTel)
						If takeMob				<> "" Then takeMob					= objEncrypter.Encrypt(takeMob)
						If takeADDR1			<> "" Then takeADDR1				= objEncrypter.Encrypt(takeADDR1)
						If takeADDR2			<> "" Then takeADDR2				= objEncrypter.Encrypt(takeADDR2)
						If strEmail				<> "" Then strEmail					= objEncrypter.Encrypt(strEmail)
						If PGAcceptNum			<> "" Then PGAcceptNum				= objEncrypter.Encrypt(PGAcceptNum)
					Set objEncrypter = Nothing
				End If



			'	If infoChg = "T" And (Daou_MEMBER_TYPE <> "GUEST" And Daou_MEMBER_TYPE="COMPANY") Then
				If infoChg = "T" And (Daou_MEMBER_TYPE = "MEMBER" Or Daou_MEMBER_TYPE = "ADMIN") Then
					SQL = "UPDATE [DK_MEMBER] SET "
					SQL = SQL & " [strMobile] = ?"
					SQL = SQL & ",[strEmail] = ?"
					SQL = SQL & ",[strZip] = ?"
					SQL = SQL & ",[strADDR1] = ?"
					SQL = SQL & ",[strADDR2] = ?"
					SQL = SQL & " WHERE [strUserID] = ?"
					arrParams = Array(_
						Db.makeParam("@strMobile",adVarChar,adParamInput,100,strMob), _
						Db.makeParam("@strEmail",adVarChar,adParamInput,512,strEmail), _
						Db.makeParam("@strZip",adVarChar,adParamInput,10,strZip), _
						Db.makeParam("@strADDR1",adVarWChar,adParamInput,512,strADDR1), _
						Db.makeParam("@strADDR2",adVarWChar,adParamInput,512,strADDR2), _
						Db.makeParam("@strUserID",adVarchar,adParamInput,20,Daou_MEMBER_ID) _
					)
					Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)

					SQL = "UPDATE [DK_MEMBER_ADDINFO] SET "
					SQL = SQL & " [strTel] = ?"
					SQL = SQL & " WHERE [strUserID] = ?"
					arrParams = Array(_
						Db.makeParam("@strTel",adVarChar,adParamInput,100,strTel), _
						Db.makeParam("@strUserID",adVarchar,adParamInput,20,strUserID) _
					)
					Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
				End If


			SQL = " INSERT INTO [DK_ORDER] ( "
				SQL = SQL & " [strDomain],[OrderNum],[strIDX],[strUserID],[payWay] "
				SQL = SQL & " ,[totalPrice],[totalDelivery],[totalOptionPrice],[totalPoint],[strName] "
				SQL = SQL & " ,[strTel],[strMob],[strEmail],[strZip],[strADDR1] "
				SQL = SQL & " ,[strADDR2],[takeName],[takeTel],[takeMob],[takeZip] "
				SQL = SQL & " ,[takeADDR1],[takeADDR2],[status],[orderMemo],[strSSH1] "
				SQL = SQL & " ,[strSSH2],[bankIDX],[BankingName],[usePoint],[totalVotePoint] "

				SQL = SQL & " ,[PGorderNum],[PGCardNum],[PGAcceptNum],[PGinstallment],[PGCardCode]"
				SQL = SQL & " ,[PGCardCom],[PGCOMPANY]"
				SQL = SQL & " ,[strNationCode]"													'국가코드추가

				SQL = SQL & " ) VALUES ( "
				SQL = SQL & " ?,?,?,?,? "
				SQL = SQL & " ,?,?,?,?,? "
				SQL = SQL & " ,?,?,?,?,? "
				SQL = SQL & " ,?,?,?,?,? "
				SQL = SQL & " ,?,?,?,?,? "
				SQL = SQL & " ,?,?,?,?,? "

				SQL = SQL & " ,?,?,?,?,? "
				SQL = SQL & " ,?,? "
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

					Db.makeParam("@strTel",adVarchar,adParamInput,150,strTel), _
					Db.makeParam("@strMob",adVarchar,adParamInput,150,strMob), _
					Db.makeParam("@strEmail",adVarWChar,adParamInput,512,strEmail), _
					Db.makeParam("@strZip",adVarchar,adParamInput,50,strZip), _
					Db.makeParam("@strADDR1",adVarchar,adParamInput,512,strADDR1), _

					Db.makeParam("@strADDR2",adVarchar,adParamInput,512,strADDR2), _
					Db.makeParam("@takeName",adVarWChar,adParamInput,50,takeName), _
					Db.makeParam("@takeTel",adVarchar,adParamInput,150,takeTel), _
					Db.makeParam("@takeMob",adVarchar,adParamInput,150,takeMob), _
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

					Db.makeParam("@PGorderNum",adVarchar,adParamInput,50,DAOU_DAOUTRX), _
					Db.makeParam("@PGCardNum",adVarchar,adParamInput,100,PGCardNum), _
					Db.makeParam("@PGAcceptNum",adVarchar,adParamInput,100,PGAcceptNum), _
					Db.makeParam("@PGinstallment",adVarchar,adParamInput,20,PGinstallment), _
					Db.makeParam("@PGCardCode",adVarchar,adParamInput,20,PGCardCode), _

					Db.makeParam("@PGCardCom",adVarchar,adParamInput,20,PGCardCom), _
					Db.makeParam("@PGCOMPANY",adVarchar,adParamInput,50,PGCOMPANY), _
					Db.makeParam("@strNationCode",adVarChar,adParamInput,10,UCase(DK_MEMBER_NATIONCODE)), _

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
			'일동 포인트 사용 CS처리
			'	If Daou_MEMBER_TYPE <> "GUEST" Then
			'		SQL = " SELECT * FROM [DK_MEMBER_FINANCIAL] WHERE [strUserID] = ?"
			'		arrParams = Array(_
			'			Db.makeParam("@strUserID",adVarchar,adParamInput,20,strUserID) _
			'		)
			'		Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,Nothing)
			'		If DKRS.BOF Or DKRS.EOF Then
			'			SQL2 = "INSERT INTO [DK_MEMBER_FINANCIAL] ([strUserID]) VALUES (?)"
			'			Call Db.exec(SQL2,DB_TEXT,arrParams,Nothing)
			'		End If
			'		Call closeRS(DKRS)
			'	End If
			'
			'적립금 차감
			'	SQL = "SELECT [intPoint] FROM [DK_MEMBER_FINANCIAL] WHERE [strUserID] = ?"
			'	arrParams = Array(_
			'		Db.makeParam("@strUserID",adVarchar,adParamInput,20,strUserID) _
			'	)
			'	nowMemberPoint = Db.execRsData(SQL,DB_TEXT,arrParams,Nothing)
			'
			'
			'		SQL = "INSERT INTO [DK_MEMBER_POINT_LOG] ("
			'		SQL = SQL & " [strUserID],[intValue],[intRemain],[ValueComment],[dComment] "
			'		SQL = SQL & " ) VALUES ( "
			'		SQL = SQL & " ?,?,?,?,? "
			'		SQL = SQL & " )"
			'		arrParams = Array(_
			'		Db.makeParam("@strUserID",adVarchar,adParamInput,20,strUserID), _
			'		Db.makeParam("@intValue",adInteger,adParamInput,0,-usePoint), _
			'		Db.makeParam("@intRemain",adInteger,adParamInput,0,nowMemberPoint-usePoint), _
			'		Db.makeParam("@ValueComment",adVarChar,adParamInput,50,"ORDER2"), _
			'		Db.makeParam("@dComment",adVarChar,adParamInput,800,OrderNum&"주문 시 사용") _
			'	)
			'	Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
			'
			'	SQL = "UPDATE [DK_MEMBER_FINANCIAL] SET [intPoint] = [intPoint] - ? WHERE [strUserID] = ?"
			'	arrParams = Array(_
			'		Db.makeParam("@intPoint",adInteger,adParamInput,0,usePoint), _
			'		Db.makeParam("@strUserID",adVarchar,adParamInput,20,strUserID) _
			'	)
			'	Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)



			CSGoodCnt = 0

			If input_mode = "direct" Then

				If strOption = "" Or IsNull(strOption) Then strOption = ""
				'Dim SellerID : 	SellerID = Trim(pRequestTF("SellerID",True))
				'Call ALERTS("","BACK","")

				GoodsPrice = totalPrice - totalDelivery

				Dim thisPrice, thisOptionPrice, thisPoint
				'thisPrice			= GoodsPrice / orderEaD
				thisOptionPrice		= totalOptionPrice / orderEaD
				thisOptionPrice2	= 0	'totalOptionPrice2 / orderEaD
				thisPoint			= totalPoint / orderEaD

				'상품 정보(수량) 확인
					SQL = "SELECT "
					SQL = SQL & " [DelTF],[GoodsStockType],[GoodsStockNum],[GoodsViewTF],[isAccept]"
					SQL = SQL & ",[GoodsName],[imgThum],[GoodsPrice],[GoodsCustomer],[GoodsCost]"
					SQL = SQL & ",[GoodsPoint],[GoodsDeliveryType],[GoodsDeliveryFee],[intPriceNot],[intPriceAuth]"
					SQL = SQL & ",[intPriceDeal],[intPriceVIP],[intMinNot],[intMinAuth],[intMinDeal]"
					SQL = SQL & ",[intMinVIP],[intPointNot],[intPointAuth],[intPointDeal],[intPointVIP]"
					SQL = SQL & ",[strShopID]"
					SQL = SQL & ",[isCSGoods]"
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

						DKRS_intPriceNot			= DKRS("intPriceNot")
						DKRS_intPriceAuth			= DKRS("intPriceAuth")
						DKRS_intPriceDeal			= DKRS("intPriceDeal")
						DKRS_intPriceVIP			= DKRS("intPriceVIP")
						DKRS_intMinNot				= DKRS("intMinNot")
						DKRS_intMinAuth				= DKRS("intMinAuth")
						DKRS_intMinDeal				= DKRS("intMinDeal")
						DKRS_intMinVIP				= DKRS("intMinVIP")
						DKRS_intPointNot			= DKRS("intPointNot")
						DKRS_intPointAuth			= DKRS("intPointAuth")
						DKRS_intPointDeal			= DKRS("intPointDeal")
						DKRS_intPointVIP			= DKRS("intPointVIP")
						DKRS_strShopID				= DKRS("strShopID")
						DKRS_isCSGoods				= DKRS("isCSGoods")
						DKRS_isImgType				= DKRS("isImgType")

						If DKRS_isCSGoods = "T" Then CSGoodCnt = 1

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
						Sfile2.WriteLine "존재하지 않는 상품구입을 시도했습니다.1"
					End If
					Call closeRS(DKRS)

					If DKRS_DelTF = "T" Then Sfile2.WriteLine "삭제된 상품의 구매를 시도했습니다. 새로고침 후 다시 시도해주세요."
					If DKRS_isAccept <> "T" Then Sfile2.WriteLine "승인되지 않은 상품의 구매를 시도했습니다. 새로고침 후 다시 시도해주세요."
					If DKRS_GoodsViewTF <> "T" Then Sfile2.WriteLine "더이상 판매되지 않는 상품의 구매를 시도했습니다. 새로고침 후 다시 시도해주세요."

					Select Case DKRS_GoodsStockType
						Case "I"
						Case "N"
							If Int(DKRS_GoodsStockNum) < Int(orderEaD) Then
								Sfile2.WriteLine "남아있는 수량이 현재 구입하시려는 수량보다 많습니다. 새로고침 후 다시 시도해주세요."
							Else
								SQL = "UPDATE [DK_GOODS] SET [GoodsStockNum] = [GoodsStockNum] - ? WHERE [intIDX] = ?"
								arrParams = Array(_
									Db.makeParam("@ea",adInteger,adParamInput,4,orderEaD), _
									Db.makeParam("@intIDX",adInteger,adParamInput,4,inUidx) _
								)
								Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
							End If
						Case "S" : Sfile2.WriteLine "품절상품. 새로고침 후 다시 시도해주세요."
						Case Else : Sfile2.WriteLine "수량정보가 올바르지 않습니다. 새로고침 후 다시 시도해주세요."
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

					thisPrice = DKRS_GoodsPrice		'▣다우키인 수정!! (중복)


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
						Db.makeParam("@strShopID",adVarChar,adParamInput,50,DKRS_strShopID),_
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

				'PRINT arrUidx

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
						SQL = SQL & ",[isCSGoods]"
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

							DKRS_intPriceNot			= DKRS("intPriceNot")
							DKRS_intPriceAuth			= DKRS("intPriceAuth")
							DKRS_intPriceDeal			= DKRS("intPriceDeal")
							DKRS_intPriceVIP			= DKRS("intPriceVIP")
							DKRS_intMinNot				= DKRS("intMinNot")
							DKRS_intMinAuth				= DKRS("intMinAuth")
							DKRS_intMinDeal				= DKRS("intMinDeal")
							DKRS_intMinVIP				= DKRS("intMinVIP")
							DKRS_intPointNot			= DKRS("intPointNot")
							DKRS_intPointAuth			= DKRS("intPointAuth")
							DKRS_intPointDeal			= DKRS("intPointDeal")
							DKRS_intPointVIP			= DKRS("intPointVIP")
							DKRS_isCSGoods				= DKRS("isCSGoods")
							DKRS_isImgType				= DKRS("isImgType")

							If DKRS_isCSGoods = "T" Then CSGoodCnt = CSGoodCnt + 1


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

							'▣스피나 소비자 가격, 쇼핑몰가/CS가 비교(2017-05-16)
							If Daou_MEMBER_STYPE = "1" And DKRS_isCSGoods = "T" Then
								DKRS_GoodsPrice	 = DKRS_GoodsCustomer
							End If

						Else
							Sfile2.WriteLine "존재하지 않는 상품구입을 시도했습니다.!"
						End If
						Call closeRS(DKRS)

						If DKRS_DelTF = "T" Then Sfile2.WriteLine "삭제된 상품의 구매를 시도했습니다. 새로고침 후 다시 시도해주세요."
						If DKRS_isAccept <> "T" Then Sfile2.WriteLine "승인되지 않은 상품의 구매를 시도했습니다. 새로고침 후 다시 시도해주세요."
						If DKRS_GoodsViewTF <> "T" Then Sfile2.WriteLine "더이상 판매되지 않는 상품의 구매를 시도했습니다. 새로고침 후 다시 시도해주세요."

						Select Case DKRS_GoodsStockType
							Case "I"
							Case "N"
								If Int(DKRS_GoodsStockNum) < Int(DKRS_orderEa) Then
									Sfile2.WriteLine "남아있는 수량이 현재 구입하시려는 수량보다 많습니다. 새로고침 후 다시 시도해주세요."
								Else
									SQL = "UPDATE [DK_GOODS] SET [GoodsStockNum] = [GoodsStockNum] - ? WHERE [intIDX] = ?"
									arrParams = Array(_
										Db.makeParam("@ea",adInteger,adParamInput,4,DKRS_orderEa), _
										Db.makeParam("@intIDX",adInteger,adParamInput,4,DKRS_GoodIDX) _
									)
									Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
								End If
							Case "S" : Sfile2.WriteLine "품절상품. 새로고침 후 다시 시도해주세요."
							Case Else : Sfile2.WriteLine  "수량정보가 올바르지 않습니다. 새로고침 후 다시 시도해주세요."
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
							'Set DKRS2 = DB.execRs("DKPA_DELIVEY_FEE_VIEW",DB_PROC,arrParams2,Nothing)
							Set DKRS2 = DB.execRs("DKP_DELIVERY_FEE_VIEW",DB_PROC,arrParams2,Nothing)
							If Not DKRS2.BOF And Not DKRS2.EOF Then
								DKRS2_FeeType		= DKRS2("FeeType")
								DKRS2_intFee		= Int(DKRS2("intFee"))
								DKRS2_intLimit		= Int(DKRS2("intLimit"))
							Else
								DKRS2_FeeType		= ""
								DKRS2_intFee		= ""
								DKRS2_intLimit		= ""
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
							If arrOption(1) > 0 Then
								OptionPrice = " / + " & num2cur(arrOption(1)) &" 원"
							ElseIf arrOption(1) < 0 Then
								OptionPrice = "/ - " & num2cur(arrOption(1)) &" 원"
							ElseIf arrOption(1) = 0 Then
								OptionPrice = ""
							End If
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

		'=============================================================================================================================
		'===  CS전산입력 =============================================================================================================
			nowTime = Now
			RegTime = Right("0000"&Year(nowTime),4) & Right("00"&Month(nowTime),2) & Right("00"&Day(nowTime),2)
			Recordtime = Left(nowTime,10) & " "& Right("00"&Hour(nowTime),2) &":"&Right("00"&Minute(nowTime),2) &":"&Right("00"&Second(nowTime),2)

			If daou_MEMBER_TYPE = "COMPANY" And CSGoodCnt > 0 Then 'CS회원이고 cs연동상품이 1개 이상 있는 경우

				v_C_Etc = DAOUPAY_CARDCODE(DAOU_CARDCODE) &"/"&DAOU_DAOUTRX&"/"&orderNum ' 카드사코드/다우거래번호/주문번호

			'	SQL = "SELECT * FROM [tbl_Memberinfo] WHERE [WebID] = ?"		'DK_MEMBER_WEBID!!!
			'	arrParams = Array(_
			'		Db.makeParam("@strUserID",adVarChar,adParamInput,30,Daou_MEMBER_WEBID) _
			'	)
				SQL = "SELECT * FROM [tbl_Memberinfo] WHERE [mbid] = ? AND [mbid2] = ? "
				arrParams = Array(_
					Db.makeParam("@MBID1",adVarChar,adParamInput,20,Daou_MEMBER_ID1) , _
					Db.makeParam("@MBID2",adInteger,adParamInput,4,Daou_MEMBER_ID2) _
				)
				Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,DB3)
				If Not DKRS.BOF And Not DKRS.EOF Then
					MBID1		= DKRS("mbid")
					MBID2		= DKRS("mbid2")
					Sell_Mem_TF = DKRS("Sell_Mem_TF")		'1:소비자, 0:판매원

				'	SQL4 = "SELECT [GoodIDX],[orderEa],[orderIDX] FROM [DK_ORDER_GOODS] WHERE [orderIDX] = ? "
				'	arrParams = Array(_
				'		Db.makeParam("@orderIDX",adInteger,adParamInput,0,identity) _


				'마일리지 다시 체크
				'	If usePoint > 0 Then
				'	' CS포인트정보(소비자회원만)
				'		CS_WebID = Replace(Daou_MEMBER_ID,"CS_","")
				'		CarrParams = Array(_
				'			Db.makeParam("@WebID",adVarWChar,adParamInput,30,CS_WebID) _
				'		)
				'		Set HJRSC = Db.execRs("HJP_MILEAGE_INFO_TOTAL_C",DB_PROC,CarrParams,DB3)
				'		If Not HJRSC.BOF And Not HJRSC.EOF Then
				'			PLUS_TOTAL_MILEAGE  = HJRSC(0)
				'			MINUS_TOTAL_MILEAGE = HJRSC(1)
				'		Else
				'			PLUS_TOTAL_MILEAGE  = 0
				'			MINUS_TOTAL_MILEAGE = 0
				'		End If
				'		Call closeRS(HJRSC)
				'		MILEAGE_TOTAL = PLUS_TOTAL_MILEAGE - MINUS_TOTAL_MILEAGE
				'		If MILEAGE_TOTAL < usePoint Then
				'			Response.End
				'		End If
				'	End If




				' CS상품 갯수체크
					If CSGoodCnt > 0 Then

						orderType = v_SellCode      'CS상품 구매종류선택

						'GoodsDeliveryFee = totalDelivery	'**배송비**

						'스피나(2017-05-16)
						Select Case DtoD
							Case "T","C"	'택배수령, 센터수령(스피나)
								GoodsDeliveryFee = totalDelivery
							Case "F"		'직접수령
								GoodsDeliveryFee = 0
							Case Else
								GoodsDeliveryFee = totalDelivery
						End Select

						' 주문내용을 CS TEMP에 입력
						SQL2 = "INSERT INTO [DK_ORDER_TEMP] ("
						SQL2 = SQL2 & "  [OrderNum],[sessionIDX],[MBID],[MBID2],[totalPrice]"
						SQL2 = SQL2 & " ,[takeName],[takeZip],[takeADDR1],[takeADDR2],[takeMob]"
						SQL2 = SQL2 & " ,[takeTel],[orderType],[payType],[payBankCode],[payBankAccNum]"
						SQL2 = SQL2 & " ,[payBankDate],[payBankSendName],[payBankAcceptName],[PayState]" '4개
						SQL2 = SQL2 & " ,[orderMemo],[M_NAME],[deliveryFee],[takeEmail],[PGorderNum]"
						SQL2 = SQL2 & " ,[PGCardNum],[PGAcceptNum],[PGinstallment],[PGCardCode],[PGCardCom]"
						SQL2 = SQL2 & " ,[PGACP_TIME],[DIR_CSHR_Type],[DIR_CSHR_ResultCode],[DIR_ACCT_BankCode],[InputMileage]"
						SQL2 = SQL2 & " ,[SalesCenter],[DtoD]"
						SQL2 = SQL2 & " ) VALUES ("
						SQL2 = SQL2 & "  ?,?,?,?,?"
						SQL2 = SQL2 & " ,?,?,?,?,?"
						SQL2 = SQL2 & " ,?,?,?,?,?"
						SQL2 = SQL2 & " ,?,?,?,?"	'4개
						SQL2 = SQL2 & " ,?,?,?,?,?"
						SQL2 = SQL2 & " ,?,?,?,?,?"
						SQL2 = SQL2 & " ,?,?,?,?,?"
						SQL2 = SQL2 & " ,?,?"
						SQL2 = SQL2 & " )"
						SQL2 = SQL2 & " SELECT ? = @@IDENTITY"

						arrParams2 = Array(_
							Db.makeParam("@OrderNum",adVarChar,adParamInput,20,OrderNum),_
							Db.makeParam("@sessionIDX",adVarChar,adParamInput,50,strIDX),_
							Db.makeParam("@MBID",adVarChar,adParamInput,20,MBID1),_
							Db.makeParam("@MBID2",adInteger,adParamInput,4,MBID2),_
							Db.makeParam("@totalPrice",adInteger,adParamInput,4,totalPrice),_

							Db.makeParam("@takeName",adVarWChar,adParamInput,100,takeName),_
							Db.makeParam("@takeZip",adVarChar,adParamInput,10,Replace(takeZip,"-","")),_
							Db.makeParam("@takeADDR1",adVarWChar,adParamInput,700,takeADDR1),_
							Db.makeParam("@takeADDR2",adVarWChar,adParamInput,700,takeADDR2),_
							Db.makeParam("@takeMob",adVarChar,adParamInput,100,takeMob),_

							Db.makeParam("@takeTel",adVarChar,adParamInput,100,takeTel),_
							Db.makeParam("@orderType",adVarChar,adParamInput,20,orderType),_
							Db.makeParam("@payType",adVarChar,adParamInput,20,"card"),_
							Db.makeParam("@payBankCode",adVarWChar,adParamInput,50,""),_
							Db.makeParam("@payBankAccNum",adVarChar,adParamInput,50,""),_

							Db.makeParam("@payBankDate",adVarChar,adParamInput,50,""),_
							Db.makeParam("@payBankSendName",adVarWChar,adParamInput,100,""),_
							Db.makeParam("@payBankAcceptName",adVarWChar,adParamInput,50,""),_
							Db.makeParam("@PayState",adChar,adParamInput,3,"101"),_

							Db.makeParam("@orderMemo",adVarWChar,adParamInput,100,orderMemo),_
							Db.makeParam("@M_NAME",adVarWChar,adParamInput,50,Daou_MEMBER_NAME),_
							Db.makeParam("@deliveryFee",adInteger,adParamInput,4,GoodsDeliveryFee),_
							Db.makeParam("@takeEmail",adVarWChar,adParamInput,200,strEmail),_
							Db.makeParam("@PGorderNum",adVarChar,adParamInput,50,DAOU_DAOUTRX),_

							Db.makeParam("@PGCardNum",adVarChar,adParamInput,100,PGCardNum),_
							Db.makeParam("@PGAcceptNum",adVarChar,adParamInput,100,PGAcceptNum),_
							Db.makeParam("@PGinstallment",adVarChar,adParamInput,50,""),_
							Db.makeParam("@PGCardCode",adVarChar,adParamInput,50,PGCardCode),_
							Db.makeParam("@PGCardCom",adVarChar,adParamInput,50,""),_

							Db.makeParam("@PGACP_TIME",adVarChar,adParamInput,20,DAOU_SETTDATE),_
							Db.makeParam("@DIR_CSHR_Type",adVarChar,adParamInput,50,""),_
							Db.makeParam("@DIR_CSHR_ResultCode",adVarChar,adParamInput,50,""),_
							Db.makeParam("@DIR_ACCT_BankCode",adVarChar,adParamInput,50,""),_
							Db.makeParam("@InputMileage",adInteger,adParamInput,4,usePoint), _

							Db.makeParam("@SalesCenter",adVarChar,adParamInput,30,SalesCenter), _

								Db.makeParam("@DtoD",adChar,adParamInput,1,DtoD), _

							Db.makeParam("@CS_IDENTITY",adInteger,adParamOutPut,4,0) _
						)
						Call Db.exec(SQL2,DB_TEXT,arrParams2,DB3)
						CS_IDENTITY = arrParams2(Ubound(arrParams2))(4)
						'print CS_IDENTITY

						'주문정보에서 CS상품을 검색한다
						SQL3 = "SELECT [GoodIDX],[OrderEa] FROM [DK_ORDER_GOODS] WHERE [orderIDX] = ?"
						arrParams3 = Array(_
							Db.makeParam("@identity",adInteger,adParamInput,4,identity) _
						)
						arrList3 = Db.execRsList(SQL3,DB_TEXT,arrParams3,listLen3,Nothing)
						If IsArray(arrList3) Then
							For i = 0 To listLen3
								arrList3_GoodIDX		= arrList3(0,i)
								arrList3_OrderEa		= arrList3(1,i)

								'상품 정보(수량) 확인
								SQL4 = "SELECT "
								SQL4 = SQL4 & " [isCSGoods],[CSGoodsCode] "
								SQL4 = SQL4 & " FROM [DK_GOODS] WHERE [intIDX] = ?"
								arrParams4 = Array(_
									Db.makeParam("@GoodIDX",adInteger,adParamInput,4,arrList3_GoodIDX) _
								)
								Set DKRS4 = Db.execRs(SQL4,DB_TEXT,arrParams4,Nothing)
								If Not DKRS4.BOF And Not DKRS4.EOF Then
									DKRS4_isCSGoods		= DKRS4("isCSGoods")
									DKRS4_CSGoodsCode	= DKRS4("CSGoodsCode")
								End If
								Call closeRs(DKRS4)

								If DKRS4_isCSGoods = "T" Then

									'상품가
									SQL5 = "SELECT [ncode],[name],[price],[price2],[price4],[price5],[Sell_VAT_Price],[Except_Sell_VAT_Price],[price6] "
									SQL5 = SQL5 & " FROM [tbl_Goods] "
									SQL5 = SQL5 & " WHERE [ncode] = ? "
									arrParams5 = Array(_
										Db.makeParam("@ncode",adVarChar,adParamInput,20,DKRS4_CSGoodsCode) _
									)
									Set DKRS5 = Db.execRs(SQL5,DB_TEXT,arrParams5,DB3)
									'Set DKRS5 = Db.execRs("DKP_GOODS_INFO_USE",DB_PROC,arrParams5,DB3)
									If Not DKRS5.BOF And Not DKRS5.EOF Then
										DKRS5_ncode		= DKRS5("ncode")
										DKRS5_name		= DKRS5("name")
										DKRS5_price		= DKRS5("price")	'소비자가
										DKRS5_price2	= DKRS5("price2")	'회원가
										DKRS5_price4	= DKRS5("price4")
										DKRS5_price6	= DKRS5("price6")
									End If
									Call closeRs(DKRS5)

									'상품가 변경내역 체크
									SQL6 = "SELECT TOP(1)[ncode],[name],[price1],[price2],[price4],[price5],[Sell_VAT_Price],[Except_Sell_VAT_Price],[price6] "
									SQL6 = SQL6 & " FROM [tbl_Goods_change] "
									SQL6 = SQL6 & " WHERE [ncode] = ? AND [applyDate] <= '"&RegTime&"' ORDER BY [ApplyDate] DESC "
									arrParams6 = Array(_
										Db.makeParam("@ncode",adVarChar,adParamInput,20,DKRS4_CSGoodsCode) _
									)
									Set DKRS6 = Db.execRs(SQL6,DB_TEXT,arrParams6,DB3)
									'Set DKRS6 = Db.execRs("DKP_GOODS_CHANGE",DB_PROC,arrParams6,DB3)
									If Not DKRS6.BOF And Not DKRS6.EOF Then
										DKRS6_ncode		= DKRS6("ncode")
										DKRS6_name		= DKRS6("name")
										DKRS6_price 	= DKRS6("price1")	'소비자가
										DKRS6_price2	= DKRS6("price2")	'회원가
										DKRS6_price4	= DKRS6("price4")
										DKRS6_price6	= DKRS6("price6")
									Else
										DKRS6_ncode		= DKRS5_ncode
										DKRS6_name		= DKRS5_name
										DKRS6_price		= DKRS5_price
										DKRS6_price2	= DKRS5_price2
										DKRS6_price4	= DKRS5_price4
										DKRS6_price6	= DKRS5_price6
									End If
									Call closeRs(DKRS6)

									'▣스피나 소비자 가격, 쇼핑몰가/CS가 비교(2017-05-16)
									If Daou_MEMBER_STYPE = "1" And DKRS_isCSGoods = "T" Then
										DKRS6_price2	= DKRS6_price
									End If

									'PRINT CS_IDENTITY
									'PRINT DKRS4_CSGoodsCode
									'PRINT DKRS6_price2
									'PRINT DKRS6_price4
									'PRINT arrList3_OrderEa

									SQL7 = "INSERT INTO [DK_ORDER_TEMP_GOODS] ( "
									SQL7 = SQL7 & " [OrderIDX],[GoodsCode],[GoodsPrice],[GoodsPV],[ea] "
									SQL7 = SQL7 & " ) VALUES ("
									SQL7 = SQL7 & " ?,?,?,?,?"
									SQL7 = SQL7 & " )"
									arrParams7 = Array(_
										Db.makeParam("@orderIDX",adInteger,adParamInput,4,CS_IDENTITY), _
										Db.makeParam("@GoodsCode",adVarChar,adParamInput,20,DKRS4_CSGoodsCode), _
										Db.makeParam("@GoodsPrice",adInteger,adParamInput,4,DKRS6_price2), _
										Db.makeParam("@GoodsPV",adInteger,adParamInput,4,DKRS6_price4), _
										Db.makeParam("@ea",adInteger,adParamInput,4,arrList3_OrderEa) _
									)
									Call Db.exec(SQL7,DB_TEXT,arrParams7,DB3)
								End If
							Next

								'전체상품 가격 체크
									SQL8 = "SELECT SUM([GoodsPrice]*[ea]) FROM [DK_ORDER_TEMP_GOODS] WHERE [orderIDX] = ?"
									arrParams8 = Array(_
										Db.makeParam("@identity",adInteger,adParamInput,4,CS_IDENTITY) _
									)
									DKCS_TOTAL_PRICE = Db.execRsData(SQL8,DB_TEXT,arrParams8,DB3)

									'■■ CS상품 옵션X, 총결제금액(배송비포함)
									DKCS_TOTAL_PRICE = DKCS_TOTAL_PRICE + GoodsDeliveryFee

									'■전체상품 가격 변경■
									SQL9 = "UPDATE [DK_ORDER_TEMP] SET [totalPrice] = ? WHERE [intIDX] = ?"
									arrParams9 = Array(_
										Db.makeParam("@orderIDX",adInteger,adParamInput,4,DKCS_TOTAL_PRICE), _
										Db.makeParam("@GoodsCode",adVarChar,adParamInput,20,CS_IDENTITY) _
									)
									Call Db.exec(SQL9,DB_TEXT,arrParams9,DB3)

							'◈@v_C_Number1,	@v_C_Number2 신버전CS암호화!!
									arrParams = Array(_
										Db.makeParam("@OrderNum",adVarChar,adParamInput,20,orderNum),_
										Db.makeParam("@v_SellDate",adVarChar,adParamInput,10,RegTime),_

										Db.makeParam("@v_Etc1",adVarWChar,adParamInput,250,v_C_Etc),_
										Db.makeParam("@v_Etc2",adVarWChar,adParamInput,250,"웹주문번호:"&orderNum),_

										Db.makeParam("@v_C_Code",adVarChar,adParamInput,50,PGCardCode),_
										Db.makeParam("@v_C_Number1",adVarChar,adParamInput,100,PGCardNum),_
										Db.makeParam("@v_C_Number2",adVarChar,adParamInput,100,PGAcceptNum),_
										Db.makeParam("@v_C_Name1",adVarWChar,adParamInput,50,Daou_MEMBER_NAME),_
										Db.makeParam("@v_C_Name2",adVarWChar,adParamInput,50,""),_

										Db.makeParam("@v_C_Period1",adVarChar,adParamInput,4,""),_
										Db.makeParam("@v_C_Period2",adVarChar,adParamInput,2,""),_
										Db.makeParam("@v_C_Installment_Period",adVarChar,adParamInput,10,PGinstallment),_

										Db.makeParam("@OUT_ORDERNUMBER",adVarChar,adParamOutput,50,""), _
										Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
									)
									Call Db.exec("DKP_ORDER_TOTAL_NEW",DB_PROC,arrParams,DB3)
									OUT_ORDERNUMBER = arrParams(UBound(arrParams)-1)(4)
									OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)

									'■주문정보에서 CS주문번호를 삽입한다.
									SQL10 = "UPDATE [DK_ORDER] SET [CSORDERNUM] = ? WHERE [OrderNum] = ?"
									arrParams10 = Array(_
										Db.makeParam("@CSORDERNUM",adVarChar,adParamInput,50,OUT_ORDERNUMBER), _
										Db.makeParam("@ORDERNUMBER",adVarChar,adParamInput,20,orderNum) _
									)
									Call Db.exec(SQL10,DB_TEXT,arrParams10,Nothing)

									'■배송시 요청사항 CS입력
									If orderMemo <> "" Then
										SQL_RECE = "UPDATE [tbl_Sales_Rece] SET [Pass_Msg] = ? WHERE [OrderNumber] = ? "  'nvarchar(500)
										arrParams_RECE = Array(_
											Db.makeParam("@Pass_Msg",adVarWChar,adParamInput,500,orderMemo) ,_
											Db.makeParam("@OUT_ORDERNUMBER",adVarChar,adParamInput,50,OUT_ORDERNUMBER) _
										)
										Call Db.exec(SQL_RECE,DB_TEXT,arrParams_RECE,DB3)
									End If

									Sfile2.WriteLine "CS_ORDERNUM : " & OUT_ORDERNUMBER

									'##################################################################################################
									'############## [특판 신버전] CS주문 승인여부체크 / MLM 신고 S ####################################
									If MLM_TF = "T" Then

										HJCS_ORDER_SELLTF = 0
										SQL_TF = "SELECT [SellTF] FROM [tbl_SalesDetail_TF] WHERE [OrderNumber] = ?"
										arrParams_TF = Array(_
											Db.makeParam("@OrderNumber",adVarChar,adParamInput,50,OUT_ORDERNUMBER) _
										)
										HJCS_ORDER_SELLTF = Db.execRsData(SQL_TF,DB_TEXT,arrParams_TF,DB3)

										If HJCS_ORDER_SELLTF = 1 Then

											arrParams_MLM1 = Array(_
												Db.makeParam("@mbid",adVarChar,adParamInput,20,Daou_MEMBER_ID1), _
												Db.makeParam("@mbid2",adInteger,adParamInput,0,Daou_MEMBER_ID2) _
											)
											Set DKRS = Db.execRs("DKP_MEMBER_INFO",DB_PROC,arrParams_MLM1,DB3)
											If Not DKRS.BOF And Not DKRS.EOF Then
												DKRS_cpno		= DKRS("cpno")
												DKRS_Address1	= DKRS("Address1")
												DKRS_Address2	= DKRS("Address2")
												DKRS_hometel	= DKRS("hometel")
												DKRS_hptel		= DKRS("hptel")

												Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
													objEncrypter.Key = con_EncryptKey
													objEncrypter.InitialVector = con_EncryptKeyIV
													On Error Resume Next
														If DKRS_cpno		<> "" Then DKRS_cpno		= objEncrypter.Decrypt(DKRS_cpno)
														If DKRS_Address1	<> "" Then DKRS_Address1	= objEncrypter.Decrypt(DKRS_Address1)
														If DKRS_Address2	<> "" Then DKRS_Address2	= objEncrypter.Decrypt(DKRS_Address2)
														If DKRS_hometel		<> "" Then DKRS_hometel		= objEncrypter.Decrypt(DKRS_hometel)
														If DKRS_hptel		<> "" Then DKRS_hptel		= objEncrypter.Decrypt(DKRS_hptel)
													On Error GoTo 0
												Set objEncrypter = Nothing

											End If

											'MLM_CmpCode = "4492"	'특판조합사코드 : 모태로한국(2017-04-28)
											MLM_CmpCode = "4422"	'특판조합사코드 : 스피나(2017-05-16)

											arrParams_MLM2 = Array(_
												Db.makeParam("@CmpCode",adVarChar,adParamInput,10,MLM_CmpCode),_
												Db.makeParam("@OrderNo",adVarChar,adParamInput,40,OUT_ORDERNUMBER),_
												Db.makeParam("@_Cpno",adVarWChar,adParamInput,40,DKRS_cpno),_
												Db.makeParam("@_Hptel",adVarWChar,adParamInput,40,DKRS_hptel),_
												Db.makeParam("@_HomeTel",adVarWChar,adParamInput,40,DKRS_hometel),_
												Db.makeParam("@_Address1",adVarWChar,adParamInput,700,DKRS_Address1),_
												Db.makeParam("@_Address2",adVarWChar,adParamInput,700,DKRS_Address2),_
												Db.makeParam("@mlmunionSeq",adInteger,adParamOutput,4,1) _
											)
											Call Db.exec("p_mlmunion_Order_2",DB_PROC,arrParams_MLM2,DB3)

										End If

									End If
									'############## [특판 신버전] CS주문 승인여부체크 / MLM 신고 S ####################################
									'##################################################################################################



									'■직판용 Cacu테이블 신용/체크 구분자 [C_Card_Sort] Update (web Card결제시, 월드글로벌이후 20160919 ~)■
									If MACCO_TF = "T" And insNUM4PassBook = "T" And PGCardNum_MACCO <> "" Then
										SQL_ST1 = "SELECT [Card_Sort_Code] FROM [tbl_Sales_Cacu_CardBin] WHERE [BinNumber] = ? "
										arrParams_ST1 = Array(_
											Db.makeParam("@Card_Sort_Code",adInteger,adParamInput,4,PGCardNum_MACCO)_
										)
										RS_Card_Sort_Code = Db.execRsData(SQL_ST1,DB_TEXT,arrParams_ST1,DB3)

										Select Case RS_Card_Sort_Code		'C_Card_Sort 신용카드 '0' 체크카드는 '1' 나머지 ''
											Case "0","1"
												RS_Card_Sort_Code = RS_Card_Sort_Code
											Case Else
												RS_Card_Sort_Code = ""
										End Select

										SQL_ST2 = "UPDATE [tbl_Sales_Cacu] SET [C_Card_Sort] = ? WHERE [OrderNumber] = ? And [C_TF] = 3 And [RecordID] = 'web' "
										arrParams_ST2 = Array(_
											Db.makeParam("@C_Card_Sort",adVarChar,adParamInput,6,RS_Card_Sort_Code) ,_
											Db.makeParam("@OUT_ORDERNUMBER",adVarChar,adParamInput,50,OUT_ORDERNUMBER) _
										)
										Call Db.exec(SQL_ST2,DB_TEXT,arrParams_ST2,DB3)
									End If

									'마일리지 사용 입력 (위에서 마일리지를 체크했다고 판단함)
								'	If usePoint > 0 Then
								'		arrParams = Array(_
								'			Db.makeParam("@T_Time",adVarChar,adParamInput,35,nowTime), _
								'			Db.makeParam("@mbid",adVarChar,adParamInput,20,Daou_MEMBER_ID1), _
								'			Db.makeParam("@mbid2",adInteger,adParamInput,4,Daou_MEMBER_ID2), _
								'			Db.makeParam("@M_Name",adVarChar,adParamInput,30,Daou_MEMBER_NAME), _
								'			Db.makeParam("@PlusValue",adInteger,adParamInput,4,""), _
								'			Db.makeParam("@PlusKind",adVarChar,adParamInput,2,0), _
								'			Db.makeParam("@MinusValue",adInteger,adParamInput,4,usePoint), _
								'			Db.makeParam("@MinusKind",adVarChar,adParamInput,2,"12"), _
								'			Db.makeParam("@Plus_OrderNumber",adVarChar,adParamInput,30,""), _
								'			Db.makeParam("@Minus_OrderNumber",adVarChar,adParamInput,30,OUT_ORDERNUMBER), _
								'			Db.makeParam("@User_id",adVarChar,adParamInput,30,"Web_Shop"), _
								'			Db.makeParam("@Use_End_Date",adVarChar,adParamInput,8,""), _
								'			Db.makeParam("@Use_End_Date_BT",adVarChar,adParamInput,8,""), _
								'			Db.makeParam("@ETC1",adVarChar,adParamInput,300,"웹:"&OrderNum&"사용"), _
								'			Db.makeParam("@PlusSellDate",adVarChar,adParamInput,8,""), _
								'			Db.makeParam("@MinusSellDate",adVarChar,adParamInput,8,RegTime), _
								'			Db.makeParam("@PayDate",adVarChar,adParamInput,8,""), _
								'			Db.makeParam("@FromEndDate",adVarChar,adParamInput,8,""), _
								'			Db.makeParam("@U_mbid",adVarChar,adParamInput,20,""), _
								'			Db.makeParam("@U_mbid2",adInteger,adParamInput,4,0), _
								'			Db.makeParam("@U_M_Name",adVarChar,adParamInput,30,"") _
								'		)
								'		Call Db.exec("DKP_MEMBER_MILEAGE_USE",DB_PROC,arrParams,DB3)
								'	End If


						End If


					End If



				End If
				Call closeRS(DKRS)
			Else
				Response.Write DAOU_SUCCESS
			End If
		'=== CS 전산입력 종료 =========================================================================================================
		'==============================================================================================================================



		'=== 직판공제번호발급 =========================================================================================================
			If DKCONF_SITE_ENC = "T" And MACCO_TF = "T" And Daou_MEMBER_TYPE = "COMPANY" And CSGoodCnt > 0  Then		'암호화/직판 CS상품구매일때
%>
			<!--#include virtual = "/MACCO/_inc_MACCO_Report.asp"-->
<%
			End If
		'=============================================================================================================================


		Select Case OUTPUT_VALUE
			Case "FINISH"
				'▣쇼핑몰 카트삭제(DelTF)
				If CART_DELETE_TF = "T" Then
					If inUidx <> "" Then
						arrUidx = Split(inUidx,",")
						For c = 0 To UBound(arrUidx)
							SQL_C = "UPDATE [DK_CART] SET [DelTF] = 'T', [DeleteDate] = GETDATE() WHERE [intIDX] = ? AND [strMemID] = ? AND [DelTF] = 'F' "
							arrParams = Array(_
								Db.makeParam("@intIDX",adInteger,adParamInput,0,arrUidx(c)), _
								Db.makeParam("@strUserID",adVarChar,adParamInput,30,DK_MEMBER_ID) _
							)
							Call Db.exec(SQL_C,DB_TEXT,arrParams,Nothing)
						Next
					End If
				End If

				Response.Write DAOU_SUCCESS
				'Sfile2.WriteLine "finish"
				Sfile2.WriteLine DAOU_SUCCESS
				Response.End

			Case Else
			Response.Write DAOU_ERROR
			Sfile2.WriteLine DAOU_ERROR
			Response.End

		End Select

		Sfile2.WriteLine chr(13)
		Sfile2.WriteLine chr(13)
		Sfile2.Close
		Set Fso2= Nothing
		Set objError= Nothing


		Case Else

	End Select


%>