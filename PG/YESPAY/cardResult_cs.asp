<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual="/_lib/json2.asp" -->
<%

'PG 설정
	Dim PGID				: PGID = "170332"		'파인애플(2017-01-26)

'공통 필드
	Dim paykind				: paykind			= pRequestTF("paykind",False)
	Dim orderNum			: orderNum			= pRequestTF("OrdNo",False)
	Dim inUidx				: inUidx			= pRequestTF("cuidx",False)
	Dim gopaymethod			: gopaymethod		= pRequestTF("gopaymethod",False)
	Dim OIDX				: OIDX				= pRequestTF("OIDX",False)
	Dim orderMode			: orderMode			= Trim(pRequestTF("orderMode",False))

' 주문정보필드 받아오기

	Dim takeName			: takeName			= pRequestTF("takeName",True)
	Dim takeTel				: takeTel			= pRequestTF("takeTel",False)
	Dim takeMob				: takeMob		= pRequestTF("takeMob",True)
	Dim takeZip				: takeZip			= pRequestTF("takeZip",True)
	Dim takeADDR1			: takeADDR1			= pRequestTF("takeADDR1",True)
	Dim takeADDR2			: takeADDR2			= pRequestTF("takeADDR2",True)



' 금액 관련
	Dim totalPrice			: totalPrice		= pRequestTF("totalPrice",False)
	Dim totalDelivery		: totalDelivery		= pRequestTF("totalDelivery",False)
	Dim DeliveryFeeType		: DeliveryFeeType	= pRequestTF("DeliveryFeeType",False)
	Dim GoodsPrice			: GoodsPrice		= pRequestTF("GoodsPrice",False)

	Dim totalOptionPrice	: totalOptionPrice  = pRequestTF("totalOptionPrice",False)
	Dim totalOptionPrice2	: totalOptionPrice2 = pRequestTF("totalOptionPrice2",False)		'goodsOPTcost
	Dim totalPoint			: totalPoint		= pRequestTF("totalPoint",False)

	Dim usePoint			: usePoint			= pRequestTF("useCmoney",False)			: 	If usePoint = Null Or usePoint = "" Then usePoint = 0
	Dim totalVotePoint		: totalVotePoint	= pRequestTF("totalVotePoint",False)

	Dim GoodsName			: GoodsName			= pRequestTF("GoodsName",True)


'기타 필드
	Dim orderMemo			: orderMemo			= pRequestTF("orderMemo",False)

'CS관련
	Dim v_SellCode			: v_SellCode		= pRequestTF("v_SellCode",False)				'CS상품 구매종류
	Dim BusCode				: BusCode			= pRequestTF("BusCode",False)


' 무통장 관련 필드
	Dim bankidx				: bankidx			= pRequestTF("bankidx",False)
	Dim bankingName			: bankingName		= pRequestTF("bankingName",False)

'카드 추가필드 S
	Dim cardNo1				: cardNo1 = pRequestTF("cardNo1",True)
	Dim cardNo2				: cardNo2 = pRequestTF("cardNo2",True)
	Dim cardNo3				: cardNo3 = pRequestTF("cardNo3",True)
	Dim cardNo4				: cardNo4 = pRequestTF("cardNo4",True)
	Dim card_mm				: card_mm = pRequestTF("card_mm",True)
	Dim card_yy				: card_yy = pRequestTF("card_yy",True)
	Dim quotabase			: quotabase = pRequestTF("quotabase",True)

	card_mm = Right("00"&card_mm,2)


	If orderMemo <> "" Then orderMemo = Left(orderMemo,100)		'배송메세지 길이 제한(param 길이 확인!!)

'치환
	strDomain = strHostA
	strIDX = DK_SES_MEMBER_IDX
	strUserID = DK_MEMBER_ID

	cardNo = cardNo1 & cardNo2 & cardNo3 & cardNo4
	cardYYMM = Right(card_yy,2) & card_mm

	paystate = "103"

'확인
'	call ResRW(PGID					,"PGID				")
'	call ResRW(PGPWD				,"PGPWD				")
'	call ResRW(paykind				,"paykind				")
'	call ResRW(orderNum				,"orderNum			")
'	call ResRW(inUidx				,"inUidx				")
'	call ResRW(gopaymethod			,"gopaymethod			")
'	call ResRW(strName				,"strName				")
'	call ResRW(strTel				,"strTel				")
'	call ResRW(strMobile			,"strMobile			")
'	call ResRW(strEmail				,"strEmail			")
'	call ResRW(strZip				,"strZip				")
'	call ResRW(strADDR1				,"strADDR1			")
'	call ResRW(strADDR2				,"strADDR2			")
'	call ResRW(takeName				,"takeName			")
'	call ResRW(takeTel				,"takeTel				")
'	call ResRW(takeMobile			,"takeMobile			")
'	call ResRW(takeZip				,"takeZip				")
'	call ResRW(takeADDR1			,"takeADDR1			")
'	call ResRW(takeADDR2			,"takeADDR2			")
'	call ResRW(infoChg				,"infoChg				")
'	call ResRW(totalPrice			,"totalPrice			")
'	call ResRW(totalDelivery		,"totalDelivery		")
'	call ResRW(DeliveryFeeType		,"DeliveryFeeType		")
'	call ResRW(GoodsPrice			,"GoodsPrice			")
'	call ResRW(totalOptionPrice		,"totalOptionPrice	")
'	call ResRW(totalOptionPrice2	,"totalOptionPrice2	")
'	call ResRW(totalPoint			,"totalPoint			")
'
'	call ResRW(usePoint				,"usePoint			")
'	call ResRW(totalVotePoint		,"totalVotePoint		")
'
'	call ResRW(orderMemo			,"orderMemo			")
'
'	call ResRW(v_SellCode			,"v_SellCode			")
'	call ResRW(BusCode				,"BusCode				")
'
'	call ResRW(cardNo1				,"cardNo1				")
'	call ResRW(cardNo2				,"cardNo2				")
'	call ResRW(cardNo3				,"cardNo3				")
'	call ResRW(cardNo4				,"cardNo4				")
'	call ResRW(card_mm				,"card_mm				")
'	call ResRW(card_yy				,"card_yy				")
'	call ResRW(quotabase			,"quotabase			")
'	print "<hr />"
'	call ResRW(strDomain			,"strDomain			")
'	call ResRW(strIDX				,"strIDX			")
'	call ResRW(strUserID			,"strUserID			")
'	call ResRW(cardNo				,"cardNo			")
'	call ResRW(cardYYMM				,"cardYYMM			")
'	call ResRW(GoodsName			,"GoodsName			")





'카드결제 시작 (실결제)
' test_yn : Y 으로 보내면 실결제 안됨.
		bXmlParam = ""
		bXmlParam = bXmlParam & "productName="&GoodsName									'상품명(*)
		bXmlParam = bXmlParam & "&payAmount="&totalPrice									'결제할금액(*)
		bXmlParam = bXmlParam & "&cardNo="&cardNo											'카드번호(*)
		bXmlParam = bXmlParam & "&cardValidityPeriod="&cardYYMM								'카드유효기간(*) (YYMM  형식)
		bXmlParam = bXmlParam & "&installment="&quotabase									'할부기간(*)
		bXmlParam = bXmlParam & "&orderUserName="&takeName									'주문자(*)
		bXmlParam = bXmlParam & "&orderTel="&Replace(takeMob,"-","")										'휴대폰(*)
		bXmlParam = bXmlParam & "&orderEmail="&strEmail										'이메일
		bXmlParam = bXmlParam & "&comOrderNo="&orderNum										'업체주문번호
		bXmlParam = bXmlParam & "&comMemID="&DK_MEMBER_ID									'업체회원번호
		bXmlParam = bXmlParam & "&memManageNo="&PGID										'가맹점코드
		bXmlParam = bXmlParam & "&receiveType=json"											'return방식 (url, xml, json)
		bXmlParam = bXmlParam & "&receiveUrl="												'결과를 url 로 전송받을 경우 결과를 받을 주소입니다. http://를 포함한 full 주소를 입력하세요
		bXmlParam = bXmlParam & "&sendSMS=N"												'결제성공시 구매자휴대폰 번호로 SMS 발신여부 'Y' or 'N' ,  기본 발송안함
		bXmlParam = bXmlParam & "&sendSMSType=1"											'
		bXmlParam = bXmlParam & "&sendSMSName="												'


		bXmlURL = "http://yespay.kr/extlink/requestpay_utf8.asp"

		set bXmlhttp = Server.CreateObject("Msxml2.ServerXMLHTTP")

			bXmlhttp.setOption 2, 13056
			bXmlhttp.open "POST", bXmlURL, False
			bXmlhttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded;charset=UTF-8"
			bXmlhttp.setRequestHeader "Accept-Language","UTF-8"
			bXmlhttp.setRequestHeader "CharSet", "UTF-8"
			bXmlhttp.setRequestHeader "Content", "text/html;charset=UTF-8"
			bXmlhttp.setRequestHeader "Content-Length", Len(bXmlParam)
			bXmlhttp.send bXmlParam

			bResponse = bXmlhttp.responseText
			bXmlStatus = bXmlhttp.status

		Set bXmlhttp = Nothing '개체 소멸

		'로그기록생성 1
			Dim Fso2 : Set  Fso2=CreateObject("Scripting.FileSystemObject")
			Dim LogPath2 : LogPath2 = Server.MapPath("CardLogss/Result_") & Replace(Date(),"-","") & ".log"
			Dim Sfile2 : Set  Sfile2 = Fso2.OpenTextFile(LogPath2,8,true)

			Sfile2.WriteLine ""
			Sfile2.WriteLine "Date : " & now()
			Sfile2.WriteLine "Domain : " & Request.ServerVariables("HTTP_HOST")
			Sfile2.WriteLine "Browser : " & Request.ServerVariables("HTTP_USER_AGENT")
			Sfile2.WriteLine "orderMode  : " & orderMode

			Sfile2.WriteLine "DATAS(3) : " &Replace(Replace(bResponse,"	",""),vbCrLf,"")
			Sfile2.Close
			Set Fso2= Nothing

		Dim bInfo : Set bInfo = JSON.parse(Join(Array(bResponse)))

		'print bXmlStatus
		If bXmlStatus >= 400 And bXmlStatus <= 599 Then
			'dim Info : set Info = JSON.parse(join(array(postData)))
			errorMsg = bInfo.resMessage
			'PRINT errorMsg
			Response.Write "<script type='text/javascript'>"
			Response.Write "alert('PG 연결에 문제가 발생했습니다. \n\n에러내용은 : "&errorMsg&" 입니다');"
			Response.Write "history.back();"
			Response.Write "</script>"
		Else

			pg_success = bInfo.resCode
			errorMsg = bInfo.resMessage

			'PRINT bResponse & "<hr />"
			If LCase(pg_success) <> "00" Then
				'PRINT "결제오류"
				Response.Write "<script type='text/javascript'>"
				Response.Write "alert('PG 연결에 문제가 발생했습니다. \n\n에러내용은 : "&errorMsg&" 입니다');"
				Response.Write "history.back();"
				Response.Write "</script>"
			Else


				'"comOrderNo":"업체주문번호",
				'"comMemID":"업체회원아이디",
				'"payAmount":"금액",
				'"cardNo":"카드번호",
				'"installment":"할부기간",
				'"orderUserName":"주문자명",
				'"orderTel":"주문자휴대폰번호",
				'"orderEmail":"이메일",
				'"productName":"상품명",
				'"orderId":"yesmecha주문번호",
				'"resCode":"결과코드(00-정상, 나마저는 메세지 참고)",
				'"resMessage":"결과메세지",
				'"apprNo":"카드승인번호",
				'"payDate":"결제일자(yyyyMMdd)",
				'"payTime":"결제시간(HHmmss)",
				'"cardCode":"카드사코드"


				PGorderNum				= bInfo.orderId
				PGCardNum				= bInfo.cardNo
				PGAcceptNum				= bInfo.apprNo
				PGinstallment			= bInfo.installment
				PGCardCode				= bInfo.cardCode

				If PGinstallment = "" Or IsNull(PGinstallment) Then PGinstallment = "00"

				Call Db.beginTrans(Nothing)


				'▣주문정보 암호화
				'	If DKCONF_SITE_ENC = "T" AND DK_MEMBER_TYPE <> "COMPANY" Then
					If DKCONF_SITE_ENC = "T" Then
						Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
							objEncrypter.Key = con_EncryptKey
							objEncrypter.InitialVector = con_EncryptKeyIV
							If DKRS_BANK_BankNumber	<> "" Then DKRS_BANK_BankNumber	= objEncrypter.Encrypt(DKRS_BANK_BankNumber)	'cacu. C_Number1

							If DKCONF_ISCSNEW = "T" Then
								If takeTel			<> "" Then takeTel				= objEncrypter.Encrypt(takeTel)
								If takeMob			<> "" Then takeMob				= objEncrypter.Encrypt(takeMob)
								If takeADDR1		<> "" Then takeADDR1			= objEncrypter.Encrypt(takeADDR1)
								If takeADDR2		<> "" Then takeADDR2			= objEncrypter.Encrypt(takeADDR2)
								If strEmail			<> "" Then strEmail				= objEncrypter.Encrypt(strEmail)

							End If
						Set objEncrypter = Nothing
					End If

					DKP_ORDER_UPDATE_PROCEDURE = "DKP_ORDER_CARD_INFO_UPDATE_NEW"
					DKP_ORDER_TOTAL_PROCEDURE  = "DKP_ORDER_TOTAL_NEW"

					PGCardCodeS = YESPAY_CARDCODE(PGCardCode)
					PGCardCodeN= YESPAY_CARDNAME(PGCardCode)

											If PGinstallment = "00" Then PGinstallmentN = "일시불" Else PGinstallmentN = PGinstallment

							' 이하 카드결제시 필요없는 변수
							DIR_CSHR_Type		= ""
							DIR_CSHR_ResultCode	= ""
							DIR_ACCT_BankCode	= ""
							payBankCode			= ""
							payBankAccNum		= ""
							payBankDate			= ""
							payBankSendName		= ""
							payBankAcceptName	= ""


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
						Db.makeParam("@PGCardCode",adVarChar,adParamInput,50,PGCardCodeS), _
						Db.makeParam("@PGCardCom",adVarChar,adParamInput,50,PGCardCodeN), _
						Db.makeParam("@PGACP_TIME",adVarChar,adParamInput,20,""), _

						Db.makeParam("@DIR_CSHR_Type",adVarChar,adParamInput,50,DIR_CSHR_Type), _
						Db.makeParam("@DIR_CSHR_ResultCode",adVarChar,adParamInput,50,DIR_CSHR_ResultCode), _
						Db.makeParam("@DIR_ACCT_BankCode",adVarChar,adParamInput,20,DIR_ACCT_BankCode), _

						Db.makeParam("@payBankCode",adVarWChar,adParamInput,50,payBankCode), _
						Db.makeParam("@payBankAccNum",adVarChar,adParamInput,100,payBankAccNum), _
						Db.makeParam("@payBankDate",adVarChar,adParamInput,50,payBankDate), _
						Db.makeParam("@payBankSendName",adVarWChar,adParamInput,100,payBankSendName), _
						Db.makeParam("@payBankAcceptName",adVarWChar,adParamInput,50,payBankAcceptName), _

						Db.makeParam("@PGorderNum",adVarchar,adParamInput,50,PGorderNum), _
						Db.makeParam("@InputMileage",adInteger,adParamInput,4,usePoint), _
						Db.makeParam("@DtoD",adChar,adParamInput,1,"F"), _


						Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
					)
					Call Db.exec(DKP_ORDER_UPDATE_PROCEDURE,DB_PROC,arrParams,DB3)
					ORDER_TEMP_OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
				'Db.makeParam("@DtoD",adChar,adParamInput,1,DtoD), _

					nowTime = Now
					RegTime = Right("0000"&Year(nowTime),4) & Right("00"&Month(nowTime),2) & Right("00"&Day(nowTime),2)
					Recordtime = Left(nowTime,10) & " "& Right("00"&Hour(nowTime),2) &":"&Right("00"&Minute(nowTime),2) &":"&Right("00"&Second(nowTime),2)

					v_C_Etc = PGorderNum&"/"&orderNum ' 카드사코드/다우거래번호/주문번호


					arrParams = Array(_
						Db.makeParam("@OrderNum",adVarChar,adParamInput,20,orderNum),_
						Db.makeParam("@v_SellDAte",adVarChar,adParamInput,10,RegTime),_

						Db.makeParam("@v_Etc1",adVarWChar,adParamInput,250,v_C_Etc),_
						Db.makeParam("@v_Etc2",adVarWChar,adParamInput,250,"웹주문번호:"&orderNum),_

						Db.makeParam("@v_C_Code",adVarChar,adParamInput,50,PGCardCodeS),_
						Db.makeParam("@v_C_Number1",adVarChar,adParamInput,100,PGCardNum),_
						Db.makeParam("@v_C_Number2",adVarChar,adParamInput,100,PGAcceptNum),_
						Db.makeParam("@v_C_Name1",adVarWChar,adParamInput,50,takeName),_
						Db.makeParam("@v_C_Name2",adVarWChar,adParamInput,50,""),_

						Db.makeParam("@v_C_Period1",adVarChar,adParamInput,4,card_yy),_
						Db.makeParam("@v_C_Period2",adVarChar,adParamInput,2,card_mm),_
						Db.makeParam("@v_C_Installment_Period",adVarChar,adParamInput,10,PGinstallmentN),_

						Db.makeParam("@OUT_ORDERNUMBER",adVarChar,adParamOutput,50,""), _
						Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
					)
					Call Db.exec(DKP_ORDER_TOTAL_PROCEDURE,DB_PROC,arrParams,DB3)
					OUT_ORDERNUMBER = arrParams(UBound(arrParams)-1)(4)
					OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)



				Call Db.finishTrans(Nothing)
				If LCase(orderMode) = "mobile" Then
					chgPage = "/m"
				Else
					chgPage = "/myoffice"
				End If

				If Err.Number <> 0 Then
					Call alerts("자료를 등록하는 도중 에러가 발생하였습니다.\n\n관리자에게 문의하여 주십시오.","back","")
				Else

					'카트삭제
					If CART_DELETE_TF = "T" Then
						arrUidx = Split(inUidx,",")
						For i = 0 To UBound(arrUidx)
							SQL = "DELETE FROM [DK_CART] WHERE [intIDX] = ? AND [MBID] = ? AND [MBID2] = ?"
							arrParams = Array(_
								Db.makeParam("@intIDX",adInteger,adParamInput,0,arrUidx(i)), _
								Db.makeParam("@MBID",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
								Db.makeParam("@MBID2",adInteger,adParamInput,0,DK_MEMBER_ID2)_
							)
							Call Db.exec(SQL,DB_TEXT,arrParams,DB3)
						Next
					End If

					Call ALERTS("구매가 성공적으로 이루어졌습니다.\n\n"&ALERTS_MESSAGE,"GO",chgPage&"/buy/order_list.asp")
				'	Call gotoURL("/shop/order_finish.asp?orderNum="&OrderNum)
				End If


			End If
		End If






	Response.End




%>
