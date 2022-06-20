<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	'NICEPAY 입금통보 수신 DB처리 'http://ssangfamily.com/PG/NICEPAY/vBankResult.asp  2019-02-18~


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


	AuthCode        = Request("AuthCode")           '승인번호(추가)


	'	Set objFSO      = CreateObject("Scripting.FileSystemObject")
	'
	'	'**********************************************************************************
	'	'이부분에 로그파일 경로를 수정해주세요.
	'	'로그는 문제발생시 오류 추적의 중요데이터 이므로 반드시 적용해주시기 바랍니다.
	'	Set fs = objFSO.OpenTextFile("C:\NICEPAY20\log\nice_vacct_noti_result.log",8,True)
	'	'**********************************************************************************
	'
	'	fs.WriteLine("************************************************")
	'	fs.WriteLine("PayMethod     : " + PayMethod)
	'	fs.WriteLine("M_ID          : " + M_ID)
	'	fs.WriteLine("MallUserID    : " + MallUserID)
	'	fs.WriteLine("Amt           : " + Amt)
	'	fs.WriteLine("name          : " + name)
	'	fs.WriteLine("GoodsName     : " + GoodsName)
	'	fs.WriteLine("TID           : " + TID)
	'	fs.WriteLine("MOID          : " + MOID)
	'	fs.WriteLine("AuthDate      : " + AuthDate)
	'	fs.WriteLine("ResultCode    : " + ResultCode)
	'	fs.WriteLine("ResultMsg     : " + ResultMsg)
	'	fs.WriteLine("VbankNum      : " + VbankNum)
	'	fs.WriteLine("FnCd          : " + FnCd)
	'	fs.WriteLine("VbankName     : " + VbankName)
	'	fs.WriteLine("VbankInputName : " + VbankInputName)
	'	fs.WriteLine("RcptTID       : " + RcptTID)
	'	fs.WriteLine("RcptType      : " + RcptType)
	'	fs.WriteLine("RcptAuthCode  : " + RcptAuthCode)
	'	fs.WriteLine("CancelDate    : " + CancelDate)
	'	fs.WriteLine("************************************************")
	'	fs.WriteLine("")
	'	fs.Close

'	MOID	= "DK190488438909"
'	Amt		= 1430
'	AuthCode= "AuthCode"
'	FnCd	= "081"
'	name    = "테스트223344"




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

	Sfile22.Close
	Set Fso22= Nothing
	Set objError= Nothing
	On Error GoTo 0

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





		orderNum			= MOID		'웹주문번호
		DKCS_TOTAL_PRICE	= Amt		'금액
		PGorderNum			= TID		'거래번호
		PGCardNum			= ""
		PGAcceptNum			= AuthCode	'승인번호
		PGinstallment		= ""		'입금은행코드
		PGCardCode			= FnCd		'가상계좌은행코드
		PGCardCom			= ""
		strName				= name		'구매자명

		nowTime = Now
		RegTime = Right("0000"&Year(nowTime),4) & Right("00"&Month(nowTime),2) & Right("00"&Day(nowTime),2)
		Recordtime = Left(nowTime,10) & " "& Right("00"&Hour(nowTime),2) &":"&Right("00"&Minute(nowTime),2) &":"&Right("00"&Second(nowTime),2)

		v_Etc1 = "NICEPAY_"&num2cur(DKCS_TOTAL_PRICE)&"원_"&orderNum

		arrParams = Array(_
			Db.makeParam("@identity",adInteger,adParamInput,4,CS_IDENTITY), _

			Db.makeParam("@OrderNum",adVarChar,adParamInput,20,orderNum),_
			Db.makeParam("@v_SellDate",adVarChar,adParamInput,10,RegTime),_

			Db.makeParam("@v_Etc1",adVarWChar,adParamInput,250,v_Etc1),_
			Db.makeParam("@v_Etc2",adVarWChar,adParamInput,250,"웹주문번호:"&orderNum),_

			Db.makeParam("@v_C_Code",adVarChar,adParamInput,50,PGCardCode),_
			Db.makeParam("@v_C_Number1",adVarWChar,adParamInput,100,PGCardNum),_
			Db.makeParam("@v_C_Number2",adVarWChar,adParamInput,100,PGAcceptNum),_
			Db.makeParam("@v_C_Name1",adVarWChar,adParamInput,50,strName),_
			Db.makeParam("@v_C_Name2",adVarWChar,adParamInput,50,""),_

			Db.makeParam("@v_C_Period1",adVarChar,adParamInput,4,""),_
			Db.makeParam("@v_C_Period2",adVarChar,adParamInput,2,""),_
			Db.makeParam("@v_C_Installment_Period",adVarChar,adParamInput,10,PGinstallment),_

			Db.makeParam("@OUT_ORDERNUMBER",adVarChar,adParamOutput,50,""), _
			Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
		)
		Call Db.exec("DKP_ORDER_TOTAL_NEW",DB_PROC,arrParams,DB3)
		'Call Db.exec("DKP_ORDER_TOTAL_NEW_test",DB_PROC,arrParams,DB3)
		OUT_ORDERNUMBER = arrParams(UBound(arrParams)-1)(4)
		OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
		'Sfile.WriteLine OUTPUT_VALUE

		'■주문정보에서 CS주문번호를 삽입한다.
		SQL10 = "UPDATE [DK_ORDER] SET [CSORDERNUM] = ? WHERE [OrderNum] = ?"
		arrParams10 = Array(_
			Db.makeParam("@CSORDERNUM",adVarChar,adParamInput,50,OUT_ORDERNUMBER), _
			Db.makeParam("@ORDERNUMBER",adVarChar,adParamInput,20,orderNum) _
		)
		Call Db.exec(SQL10,DB_TEXT,arrParams10,Nothing)

		'◆ #9. 임시주문정보에서 CS주문번호를 삽입한다. S
		SQL11 = "UPDATE [DK_ORDER_TEMP] SET [CSORDERNUM] = ? WHERE [OrderNum] = ?"
		arrParams11 = Array(_
			Db.makeParam("@CSORDERNUM",adVarChar,adParamInput,50,OUT_ORDERNUMBER), _
			Db.makeParam("@ORDERNUMBER",adVarChar,adParamInput,20,orderNum) _
		)
		Call Db.exec(SQL11,DB_TEXT,arrParams11,Nothing)
		'◆ #9. 임시주문정보에서 CS주문번호를 삽입한다. E


		On Error Resume Next
		Dim Fso6 : Set  Fso6=CreateObject("Scripting.FileSystemObject")
		Dim LogPath6 : LogPath6 = Server.MapPath (CardLogss&"/np_") & Replace(Date(),"-","") & ".log"
		Dim Sfile6 : Set  Sfile6 = Fso6.OpenTextFile(LogPath6,8,true)

			'■배송시 요청사항 CS입력
			If orderMemo <> "" Then
				SQL_RECE = "UPDATE [tbl_Sales_Rece] SET [Pass_Msg] = ? WHERE [OrderNumber] = ? "  'nvarchar(500)
				arrParams_RECE = Array(_
					Db.makeParam("@Pass_Msg",adVarWChar,adParamInput,500,orderMemo) ,_
					Db.makeParam("@OUT_ORDERNUMBER",adVarChar,adParamInput,50,OUT_ORDERNUMBER) _
				)
				Call Db.exec(SQL_RECE,DB_TEXT,arrParams_RECE,DB3)
			End If

			Sfile6.WriteLine "CS_ORDERNUM : " & OUT_ORDERNUMBER

			If OUT_ORDERNUMBER <> "" Then
				Sfile6.WriteLine "OK"
				Response.write "OK"
			Else
				Sfile6.WriteLine "FAIL"
				Response.write "FAIL"
			End If

		Sfile6.Close
		Set Fso6= Nothing
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

