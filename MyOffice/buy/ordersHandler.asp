<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_include/document.asp"-->
<%
	ADMIN_LEFT_MODE = "MENU5"
	INFO_MODE = "MENU5-1-1"

	Call ONLY_CS_MEMBER()
'	Call MEMBER_AUTH_CHECK(nowGradeCnt,3)


	

	Dim inUidx		: inUidx		= Trim(pRequestTF("cuidx",True))

	Dim strName		: strName		= Trim(pRequestTF("strName",True))

	Dim strTel1		: strTel1		= Trim(pRequestTF("tel_num1",False))
	Dim strTel2		: strTel2		= Trim(pRequestTF("tel_num2",False))
	Dim strTel3		: strTel3		= Trim(pRequestTF("tel_num3",False))

	Dim strMob1		: strMob1		= Trim(pRequestTF("mob_num1",True))
	Dim strMob2		: strMob2		= Trim(pRequestTF("mob_num2",True))
	Dim strMob3		: strMob3		= Trim(pRequestTF("mob_num3",True))

	Dim strZip		: strZip		= Trim(pRequestTF("strZip",False))
	Dim strADDR1	: strADDR1		= Trim(pRequestTF("strADDR1",False))
	Dim strADDR2	: strADDR2		= Trim(pRequestTF("strADDR2",False))


'	Dim totalPrice	: totalPrice	= Trim(pRequestTF("totalPrice",True))
	Dim v_SellCode	: v_SellCode	= Trim(pRequestTF("v_SellCode",True))

	Dim payKind		: payKind		= Trim(pRequestTF("payKind",True))
	Dim C_codeName	: C_codeName	= Trim(pRequestTF("C_codeName",False))
	Dim C_NAME2		: C_NAME2		= Trim(pRequestTF("C_NAME2",False))
	Dim memo1		: memo1			= Trim(pRequestTF("memo1",False))
	Dim ordersNumber : ordersNumber = Trim(pRequestTF("OrdNo",True))
	Dim totalPrice	: totalPrice	= Trim(pRequestTF("totalPrice",True))




'	strMobile = strMobile1 &"-"& strMobile2 &"-"& strMobile3
	strMobile = strMob1 &"-"& strMob2 &"-"& strMob3
	strTel = strTel1 &"-"& strTel2 &"-"& strTel3
	strZip = Replace(strZip,"-","")

	nowTime = Now
	RegTime = Right("0000"&Year(nowTime),4) & Right("00"&Month(nowTime),2) & Right("00"&Day(nowTime),2)
	Recordtime = Left(nowTime,10) & " "& Right("00"&Hour(nowTime),2) &":"&Right("00"&Minute(nowTime),2) &":"&Right("00"&Second(nowTime),2)
	If C_codeName <> "" Then
		arr_C_codeName = Split(C_codeName,",")
		C_codeName1 = arr_C_codeName(0)
		v_C_Number1 = arr_C_codeName(1)
		v_C_Number2 = ""
	Else
		C_codeName1 = ""
		v_C_Number1 = ""
		v_C_Number2 = ""
	End If

	Select Case payKind
		Case "card"
			v_InputCash = 0
			v_InputPassbook = 0
			v_InputCard = totalPrice
			v_TT_C_TF ="카드"
		Case "inbank"
			v_InputCash = 0
			v_InputPassbook = totalPrice
			v_InputCard = 0
			v_TT_C_TF = "무통장"
		Case Else
			v_InputCash = totalPrice
			v_InputPassbook = 0
			v_InputCard = 0
			v_TT_C_TF = "현금"
	End Select


	'결제시 : 주문한 데이터(inUidx)는 장바구니 테이블(DK_CART)에서 삭제 (2013-07-16)
	arrParams = Array(_
		Db.makeParam("@orderNum",adVarChar,adParamInput,20,ordersNumber), _
		Db.makeParam("@inUidx",adInteger,adParamInput,0,inUidx) _
	)
	arrList = Db.execRsList("DKP_ORDER_FINISH_LIST",DB_PROC,arrParams,listLen,Nothing)

	Call Db.beginTrans(Nothing)
	If IsArray(arrList) Then
		For i = 0 To listLen
			Select Case LCase(payKind)
				Case "card"
					v_InputCash = 0
					v_InputPassbook = 0
					v_InputCard = Int(arrList(10,i)) * Int(arrList(12,i))
					v_TT_C_TF ="카드"
				Case "inbank"
					v_InputCash = 0
					v_InputPassbook = Int(arrList(10,i)) * Int(arrList(12,i))
					v_InputCard = 0
					v_TT_C_TF = "무통장"
				Case Else
					v_InputCash = Int(arrList(10,i)) * Int(arrList(12,i))
					v_InputPassbook = 0
					v_InputCard = 0
					v_TT_C_TF = "현금"
			End Select
			v_C_Price1 = 0
			v_C_Price1 = v_InputCash + v_InputPassbook + v_InputCard

			arrParams = Array(_
				Db.makeParam("@v_Mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
				Db.makeParam("@v_Mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2), _
				Db.makeParam("@v_Name",adVarChar,adParamInput,60,DK_MEMBER_NAME), _
				Db.makeParam("@v_SellDAte",adVarChar,adParamInput,10,RegTime), _
				Db.makeParam("@v_SellCode",adVarChar,adParamInput,6,v_SellCode), _
				Db.makeParam("@v_InputCash",adDouble,adParamInput,0,v_InputCash), _
				Db.makeParam("@v_InputPassbook",adDouble,adParamInput,0,v_InputPassbook), _
				Db.makeParam("@v_InputCard",adDouble,adParamInput,0,v_InputCard), _
				Db.makeParam("@Etc1",adVarChar,adParamInput,500,memo1&" 입금예정") _
			)
			ORDERNUMBERS = Db.execRsData("Usp_Insert_Tbl_SalesDetail_DK",DB_PROC,arrParams,Nothing)


			arrParams = Array(_
				Db.makePAram("@v_OrderNumber",adVarChar,adParamInput,40,ORDERNUMBERS), _
				Db.makePAram("@v_SellDate",adVarChar,adParamInput,10,RegTime), _
				Db.makePAram("@v_ItemCode",adVarChar,adParamInput,10,arrList(9,i)), _
				Db.makePAram("@v_ItemCount",adSmallInt,adParamInput,0,arrList(12,i)), _
				Db.makePAram("@v_Get_Name1",adVarChar,adParamInput,60,strName), _
				Db.makePAram("@v_Get_ZipCode",adVarChar,adParamInput,20,strZip), _
				Db.makePAram("@v_Get_Address1",adVarChar,adParamInput,200,strADDR1), _
				Db.makePAram("@v_Get_Address2",adVarChar,adParamInput,200,strADDR2), _
				Db.makePAram("@v_Get_Tel1",adVarChar,adParamInput,30,strMobile), _
				Db.makePAram("@v_Get_Tel2",adVarChar,adParamInput,30,strTel), _
				Db.makePAram("@v_Get_Etc1",adVarChar,adParamInput,200,""), _
				Db.makePAram("@v_Get_Date2",adVarChar,adParamInput,10,""), _
				Db.makePAram("@v_Pass_Pay",adSmallInt,adParamInput,0,"") _

			)
			Call Db.exec("Usp_Insert_Tbl_SalesitemDetail_DK",DB_PROC,arrParams,Nothing)

			arrParams = Array(_
				Db.makeParam("@v_OrderNumber",adVarChar,adParamInput,20,ORDERNUMBERS),_
				Db.makeParam("@v_SellDate",adVarChar,adParamInput,10,RegTime),_
				Db.makeParam("@v_TT_C_TF",adVarChar,adParamInput,30,v_TT_C_TF),_
				Db.makeParam("@v_C_Price1",adDouble,adParamInput,8,v_C_Price1),_
				Db.makeParam("@v_C_CodeName",adVarChar,adParamInput,50,C_codeName1),_
				Db.makeParam("@v_C_Number1",adVarChar,adParamInput,50,v_C_Number1),_
				Db.makeParam("@v_C_Number2",adVarChar,adParamInput,20,v_C_Number2),_
				Db.makeParam("@v_C_Name1",adVarChar,adParamInput,50,""),_
				Db.makeParam("@v_C_Name2",adVarChar,adParamInput,50,C_NAME2),_
				Db.makeParam("@v_C_Period1",adVarChar,adParamInput,4,""),_
				Db.makeParam("@v_C_Period2",adVarChar,adParamInput,2,""),_
				Db.makeParam("@v_C_Installment_Period",adVarChar,adParamInput,50,"")_
			)
			Call Db.exec("Usp_Insert_tbl_Sales_Cacu_DK",DB_PROC,arrParams,Nothing)
		Next
	End If
	Call Db.finishTrans(Nothing)
	If Err.Number <> 0 Then
		Call ALERTS("자료를 등록하는 도중 에러가 발생하였습니다.\n\n관리자에게 문의하여 주십시오.","back","")
	Else
		Call ALERTS(DK_MEMBER_NAME&"님 구매 감사드립니다.관리자 승인 후 정상적인 정산이 이루어집니다.","go","order_list.asp")
	End If

%>
