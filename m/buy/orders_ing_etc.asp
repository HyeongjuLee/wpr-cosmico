<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MY_BUY"
	Call ONLY_MEMBER2()



	paysKind		= pRequestTF("paysKind",True)
	orderTempIDX	= pRequestTF("orderTempIDX",True)
	orderNum		= pRequestTF("orderNum",True)
	totalPrice		= pRequestTF("totalPrice",True)
	deliveryFee		= pRequestTF("deliveryFee",True)

	v_SellCode		= pRequestTF("v_SellCode",True)
	isSpecialSell	= pRequestTF("isSpecialSell",False)
'	v_Get_Etc1		= pRequestTF("v_Get_Etc1",False)		'SID(2013-09-23) : 배송테이블 비고내역(옵션 및 기타사항)
'	v_Receive_Method= pRequestTF("v_Receive_Method",False)	'워너 : 배송구분 2013-12-27

	strName			= pRequestTF("strName",True)
	strZip			= pRequestTF("strZip",True)
	strAddr1		= pRequestTF("strAddr1",True)
	strAddr2		= pRequestTF("strAddr2",True)
	strTel			= pRequestTF("strTel",False)
	strMobile		= pRequestTF("strMobile",True)
	strEmail		= pRequestTF("strEmail",True)






'PRINT orderTempIDX
'PRINT orderNum
'PRINT TOTALPRICE

'Response.End




	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,orderTempIDX), _
		Db.makeParam("@OrderNum",adVarChar,adParamInput,20,orderNum), _
		Db.makeParam("@totalPrice",adInteger,adParamInput,0,totalPrice), _
		Db.makeParam("@takeName",adVarWChar,adParamInput,100,strName), _
		Db.makeParam("@takeZip",adVarChar,adParamInput,10,strZip), _
		Db.makeParam("@takeADDR1",adVarWChar,adParamInput,512,strADDR1), _
		Db.makeParam("@takeADDR2",adVarWChar,adParamInput,512,strADDR2), _
		Db.makeParam("@takeMob",adVarChar,adParamInput,50,strMobile), _
		Db.makeParam("@takeTel",adVarChar,adParamInput,50,strTel), _
		Db.makeParam("@takeEmail",adVarWChar,adParamInput,200,strEmail), _
		Db.makeParam("@orderType",adVarChar,adParamInput,20,v_SellCode), _
		Db.makeParam("@deliveryFee",adInteger,adParamInput,0,deliveryFee), _
		Db.makeParam("@payType",adVarChar,adParamInput,20,paysKind), _
			Db.makeParam("@v_isSpecialSell",adChar,adParamInput,1,isSpecialSell),_

		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)
'	Call Db.exec("DKP_ORDER_OTHER_INFO_UPDATE2",DB_PROC,arrParams,DB3)
	Call Db.exec("DKP_ORDER_OTHER_INFO_UPDATE3",DB_PROC,arrParams,DB3)

	OUTPUT_VALUES = arrParams(Ubound(arrParams))(4)


	Select Case OUTPUT_VALUES
		Case "FINISH"
		Case "ERROR" : Call ALERTS("결제 중 에러가 발생하였습니다.","back","")
		Case "NOTORDER" : Call ALERTS("주문내용이 올바르지 않습니다.","back","")
		Case Else : Call ALERTS("결제 프로세스 중 예상치 못한 에러가 발생하였습니다.","back","")
	End Select




	nowTime = Now
	RegTime = Right("0000"&Year(nowTime),4) & Right("00"&Month(nowTime),2) & Right("00"&Day(nowTime),2)
	Recordtime = Left(nowTime,10) & " "& Right("00"&Hour(nowTime),2) &":"&Right("00"&Minute(nowTime),2) &":"&Right("00"&Second(nowTime),2)

	'v_C_Etc = CcCode &"/"&Installment&"/"&MxIssueNO
	v_C_Etc = memo1

	Select Case paysKind
		Case "inCash"
			v_C_Etc			= "현장결제예정"

		Case "inBank"
			C_codeName		= pRequestTF("C_codeName",True)
			C_NAME2			= pRequestTF("C_NAME2",True)
			memo1			= pRequestTF("memo1",True)
			v_C_Etc			= memo1
		Case "Card"
			Call ALERTS("카드 결제는 현재 페이지에서 결제되는 수단이 아닙니다.새로고침 후 정상적인 방법으로 시도해주세요","BACK","")
		Case Else
			Call ALERTS("결제 구분이 올바르지 않습니다.","BACK","")
	End Select


'	If payKind = "inBank" Then
	If paysKind = "inBank" Then
		arr_CcCode		= Split(C_codeName,",")
		CcCode			= arr_CcCode(0)					'은행코드
		'CcCode			= arr_CcCode(0)					'은행코드
		v_C_Number1		= arr_CcCode(2)					'계좌번호
		C_NAME2			= C_NAME2
	Else
		CcCode			= ""					'은행코드
		'CcCode			= ""					'은행코드
		v_C_Number1		= ""					'계좌번호
		C_NAME2			= ""
	End If




'	Call ResRW(orderNum,"@OrderNum")
'	Call ResRW(RegTime,"@v_SellDAte")
'	Call ResRW(v_C_Etc,"@v_Etc1")
'	Call ResRW("웹주문번호:"&orderNum,"@v_Etc2")
'	Call ResRW(CcCode,"@v_C_CodeName")
'	Call ResRW(v_C_Number1,"@v_C_Number1")
'	Call ResRW("","@v_C_Number2")
'	Call ResRW("","@v_C_Name1")
'	Call ResRW(C_NAME2,"@v_C_Name2")
'	Call ResRW("","@v_C_Period1")
'	Call ResRW("","@v_C_Period2")
'	Call ResRW("","@v_C_Installment_Period")
'	Call ResRW(v_C_Etc,"@v_C_Etc")
'	Response.End









	arrParams = Array(_
		Db.makeParam("@OrderNum",adVarChar,adParamInput,20,orderNum),_
		Db.makeParam("@v_SellDAte",adVarChar,adParamInput,10,RegTime),_

		Db.makeParam("@v_Etc1",adVarWChar,adParamInput,250,v_C_Etc),_
		Db.makeParam("@v_Etc2",adVarWChar,adParamInput,250,"웹주문번호:"&orderNum),_

		Db.makeParam("@v_C_CodeName",adVarChar,adParamInput,50,CcCode),_
		Db.makeParam("@v_C_Number1",adVarChar,adParamInput,50,v_C_Number1),_
		Db.makeParam("@v_C_Number2",adVarChar,adParamInput,20,""),_
		Db.makeParam("@v_C_Name1",adVarWChar,adParamInput,50,""),_
		Db.makeParam("@v_C_Name2",adVarWChar,adParamInput,50,C_NAME2),_

		Db.makeParam("@v_C_Period1",adVarChar,adParamInput,4,""),_
		Db.makeParam("@v_C_Period2",adVarChar,adParamInput,2,""),_
		Db.makeParam("@v_C_Installment_Period",adVarChar,adParamInput,10,""),_
		Db.makeParam("@v_C_Etc",adVarWChar,adParamInput,250,v_C_Etc),_

		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)

'	Call Db.exec("DKP_ORDER_TOTAL2",DB_PROC,arrParams,DB3)
	Call Db.exec("DKP_ORDER_TOTAL",DB_PROC,arrParams,DB3)
	OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)


	Select Case OUTPUT_VALUE
		Case "FINISH" : Call ALERTS("결제되었습니다","GO","order_list.asp")
		Case "ERROR" : Call ALERTS("결제 중 에러가 발생하였습니다.","back","")
	End Select





%>
<!--#include virtual = "/_inc/copyright.asp"-->