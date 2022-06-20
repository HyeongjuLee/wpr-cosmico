<!--#include virtual = "/_lib/strFunc.asp" -->
<!--#include virtual = "/_lib/json2.asp" -->
<%

	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1)
	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)

	AJAX_TF = "T"
%>
<!--#include virtual = "/Myoffice/autoship/_autoship_CONFIG.asp"-->
<%

	oIDX                    = pRequestTF_JSON("oIDX", True)
	A_ProcDay               = pRequestTF_JSON("A_ProcDay", True)
	Ori_A_ProcDay           = pRequestTF_JSON("Ori_A_ProcDay", True)
	'A_Month_Date            = pRequestTF_JSON("A_Month_Date", True)
	'Ori_A_Month_Date        = pRequestTF_JSON("Ori_A_Month_Date", True)
	A_AutoCnt               = pRequestTF_JSON("A_AutoCnt", True)
	Ori_A_AutoCnt           = pRequestTF_JSON("Ori_A_AutoCnt", True)
	cardInfoChk             = pRequestTF_JSON("cardInfoChk", True)

	indexArray              = pRequestTF_JSON("indexArray", True)
	countArray              = pRequestTF_JSON("countArray", True)
	itemArray               = pRequestTF_JSON("itemArray", True)
	uptArray                = pRequestTF_JSON("uptArray", True)

	recvChk                 = pRequestTF_JSON("recvChk", True)
	strName                 = pRequestTF_JSON("strName", True)
	strZip                  = pRequestTF_JSON("strZip", True)
	strADDR1                = pRequestTF_JSON("strADDR1", True)
	strADDR2                = pRequestTF_JSON("strADDR2", True)
	strMobile               = pRequestTF_JSON("strMobile", True)
	strTel                  = pRequestTF_JSON("strTel", False)

	INFO_CHANGE_TF          = pRequestTF_JSON("INFO_CHANGE_TF", True)

	'데이터 체크
	arrParams = Array(_
		Db.makeParam("@mbid1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2), _
		Db.makeParam("@oIDX",adInteger,adParamInput,4,oIDX) _
	)
	Set HJRS = Db.execRs("HJP_ORDER_LIST_CMS_DETAIL_CHK",DB_PROC,arrParams,DB3)
	If Not HJRS.BOF And Not HJRS.EOF Then
		RS_mbid				= HJRS("mbid")
		RS_mbid2			= HJRS("mbid2")
		RS_ApplyDay			= HJRS("ApplyDay")
		RS_A_Start_Date		= HJRS("A_Start_Date")			'정기결제 시작일
		RS_A_StopDay		= HJRS("A_StopDay")				'중지 시작일
		RS_A_ProcDay		= HJRS("A_ProcDay")				'다음 정기결제일자
		RS_A_ProcAmt		= HJRS("A_ProcAmt")				'총 합계금
		RS_A_Seq			= HJRS("A_Seq")					'상품테이블 일련번호
		RS_A_Card_Dongle	= HJRS("A_Card_Dongle")			'카드승인(키젠)
		RS_A_AutoCnt		= HJRS("A_AutoCnt")				'정기결제 주기(개월)
		RS_A_Month_Date		= HJRS("A_Month_Date")			'기준일자

		If CDbl(RS_A_ProcAmt) < 1  Then PRINT "{""result"":""error"",""message"":""정기결제 결제금액 미설정""}" :  Response.End

		If RS_A_Card_Dongle = "" Then PRINT "{""result"":""error"",""message"":""카드 인증작업이 이루어지지 않았습니다.\n\n본사로 문의해주세요.""}" :  Response.End
		If RS_A_Start_Date = "" Or RS_A_Month_Date = "" Or RS_A_ProcDay = "" Then
			PRINT "{""result"":""error"",""message"":""정기결제 일자 정보가 입력되지 않았습니다.\n\n본사로 문의해주세요..""}" :  Response.End
		End If

		Ori_A_ProcDay = RS_A_ProcDay
		Ori_A_AutoCnt = RS_A_AutoCnt

	Else
		PRINT "{""result"":""error"",""message"":""등록된 정보가 없습니다.""}" :  Response.End
	End If
	Call CloseRS(HJRS)

	If Date() > DateAdd("d", -2, date8to10(RS_A_ProcDay)) Or INFO_CHANGE_TF <> "T" Then
		PRINT "{""result"":""error"",""message"":""결제 예정일 2일 전까지 수정 할 수 있습니다.""}"
		Response.End
	End If

	'▣오토쉽 월 결제일 체크 (config)
	A_ProcDay_CHK = CDbl(Right(A_ProcDay,2))
	If FN_AUTOSHIP_PAYABLE_DAYS(A_ProcDay_CHK) = False Then
		PRINT "{""result"":""error"",""message"":"""&AUTOSHIP_PAYABLE_DAYS_ALERT&"""}"
		Response.end
	End If

	'print indexArray
	'print countArray
	'print itemArray
	'print uptArray
	'Response.End

	If indexArray <> "" Then
		Dim itemIdxData : Set itemIdxData = JSON.parse(join(array(indexArray)))
	End If

	If countArray <> "" Then
		Dim itemCountData : Set itemCountData = JSON.parse(join(array(countArray)))
	End If

	If itemArray <> "" Then
		Dim itemCodeData : Set itemCodeData = JSON.parse(join(array(itemArray)))
	End If

	If uptArray <> "" Then
		Dim itemUptData : Set itemUptData = JSON.parse(join(array(uptArray)))
	End If

	'배송정보를 변경한다고 했으면 UPDATE
	If recvChk = "T" Then

	'UPDATE_SQL = ""
	'UPDATE_SQL = UPDATE_SQL & " UPDATE Tbl_Memberinfo_A SET "
	'UPDATE_SQL = UPDATE_SQL & " A_Rec_Name = ?, "
	'UPDATE_SQL = UPDATE_SQL & " A_Addcode1 = ?, "
	'UPDATE_SQL = UPDATE_SQL & " A_Address1 = ?, "
	'UPDATE_SQL = UPDATE_SQL & " A_Address2 = ?, "
	'UPDATE_SQL = UPDATE_SQL & " A_hptel = ?, "
	'UPDATE_SQL = UPDATE_SQL & " A_hptel2 = ? "
	'UPDATE_SQL = UPDATE_SQL & " WHERE A_Seq = ? "

		'암호화
		Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV
			If strMobile		<> "" Then strMobile		= objEncrypter.Encrypt(strMobile)
			If strTel			<> "" Then strTel			= objEncrypter.Encrypt(strTel)
			If strADDR1			<> "" Then strADDR1			= objEncrypter.Encrypt(strADDR1)
			If strADDR2			<> "" Then strADDR2			= objEncrypter.Encrypt(strADDR2)
		Set objEncrypter = Nothing

		arrUpdateParams = Array(_
			Db.makeParam("@DK_MBID1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
			Db.makeParam("@DK_MBID2",adInteger,adParamInput,4,DK_MEMBER_ID2), _
			Db.makeParam("@A_Rec_Name",adVarWchar,adParamInput,50,strName), _
			Db.makeParam("@A_Addcode1",adVarWchar,adParamInput,50,strZip), _
			Db.makeParam("@A_Address1",adVarWchar,adParamInput,500,strADDR1), _
			Db.makeParam("@A_Address2",adVarWchar,adParamInput,500,strADDR2), _
			Db.makeParam("@A_hptel",adVarWchar,adParamInput,50,strMobile), _
			Db.makeParam("@A_hptel2",adVarWchar,adParamInput,50,strTel), _
			Db.makeParam("@A_Seq",adInteger,adParamInput,20,oIDX), _
			Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
		)
		Call Db.exec("HJP_MEMBER_INFO_MODIFY_CMS_RECE_AJAX",DB_PROC,arrUpdateParams,DB3)
	End If

	'정기결제 기준일자 / 정기결제 주기 비교해서 변경내역 있으면 UPDATE
	'If (A_Month_Date <> Ori_A_Month_Date) or (A_AutoCnt <> Ori_A_AutoCnt) or (A_ProcDay <> Ori_A_ProcDay) Then
	If (A_AutoCnt <> Ori_A_AutoCnt) or (A_ProcDay <> Ori_A_ProcDay) Then
	'    UPDATE_SQL = ""
	'    UPDATE_SQL = UPDATE_SQL & " UPDATE Tbl_Memberinfo_A SET "
	'    UPDATE_SQL = UPDATE_SQL & " A_ProcDay = ?, "
	'    UPDATE_SQL = UPDATE_SQL & " A_Month_Date = ?, "
	'    UPDATE_SQL = UPDATE_SQL & " A_AutoCnt = ? "
	'    UPDATE_SQL = UPDATE_SQL & " WHERE A_Seq = ? "

	'    A_ProcDay = replace(A_ProcDay, "-", "")

	'    arrUpdateParams = Array(_
	'        Db.makeParam("@A_ProcDay",adVarWchar,adParamInput,10,A_ProcDay), _
	'        Db.makeParam("@A_Month_Date",adInteger,adParamInput,20,cdbl(Right(A_ProcDay, 2))), _
	'        Db.makeParam("@A_AutoCnt",adInteger,adParamInput,4,A_AutoCnt), _
	'        Db.makeParam("@A_Seq",adInteger,adParamInput,20,oIDX)_
	'    )
	'    Call Db.exec(UPDATE_SQL,DB_TEXT,arrUpdateParams,DB3)

		A_ProcDay = replace(A_ProcDay, "-", "")
		A_Month_Date = cdbl(Right(A_ProcDay, 2))

		arrUpdateParams = Array(_
			Db.makeParam("@DK_MBID1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
			Db.makeParam("@DK_MBID2",adInteger,adParamInput,4,DK_MEMBER_ID2), _
			Db.makeParam("@A_ProcDay",adVarWchar,adParamInput,10,A_ProcDay), _
			Db.makeParam("@A_Month_Date",adVarChar,adParamInput,20,A_Month_Date), _
			Db.makeParam("@A_AutoCnt",adInteger,adParamInput,4,A_AutoCnt), _
			Db.makeParam("@A_Seq",adInteger,adParamInput,20,oIDX), _
			Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
		)
		Call Db.exec("HJP_MEMBER_INFO_MODIFY_CMS_DATE_AJAX",DB_PROC,arrUpdateParams,DB3)
	End If

	'정보 가져왔으면 여기서부터 업데이트 시작
	' ** 카드결제정보 변경 요청했을경우 S
	If cardInfoChk = "T" Then

		A_CardCode          = pRequestTF_JSON("A_CardCode", True)
		A_CardNumber        = pRequestTF_JSON("A_CardNumber", False)			'F
		A_Period1           = pRequestTF_JSON("A_Period1", False)				'F
		A_Period2           = pRequestTF_JSON("A_Period2", False)				'F
		A_Card_Name_Number  = pRequestTF_JSON("A_Card_Name_Number", False)		'F
		A_Birth             = pRequestTF_JSON("A_Birth", False)					'F
		chkA_Card_Dongle    = pRequestTF_JSON("chkA_Card_Dongle", True)
		chkA_Card_DongleIDX = pRequestTF_JSON("chkA_Card_DongleIDX", False)		'추가
%>
<%
		'동글 위변조 체크
		If chkA_Card_DongleIDX <> "" Then
			On Error Resume Next
			Set StrCipher = Server.CreateObject("Hoyasoft.StrCipher")
				chkA_Card_DongleIDX = Trim(StrCipher.Decrypt(chkA_Card_DongleIDX,EncTypeKey1,EncTypeKey2))
			Set StrCipher = Nothing
			On Error GoTo 0

			If Not IsNumeric(chkA_Card_DongleIDX) Then
				PRINT "{""result"":""error"",""message"":"""&LNG_ALERT_WRONG_ACCESS&"""}"
				Response.End
			End If

			A_Card_Dongle_ENC = ""
			SQLCK = "SELECT [A_Card_Dongle] FROM [HJ_tbl_Memberinfo_A_Dongle_Chk] WITH(NOLOCK) WHERE [intIDX] = ? AND [MBID]= ? AND [MBID2] = ? "
			arrParamsCK = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,chkA_Card_DongleIDX), _
				Db.makeParam("@mbid1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
				Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
			)
			A_Card_Dongle_CHK = Db.execRsData(SQLCK,DB_TEXT,arrParamsCK,DB3)

			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				On Error Resume Next
					If A_Card_Dongle_CHK <> "" Then A_Card_Dongle_CHK = objEncrypter.Decrypt(A_Card_Dongle_CHK)
				On Error GoTo 0
			Set objEncrypter = Nothing

			If CStr(chkA_Card_Dongle) <> CStr(A_Card_Dongle_CHK) Then
				PRINT "{""result"":""error"",""message"":""인증값이 변조되었습니다. 다시 인증해주세요""}"
				Response.End
			End If
		Else
			'인증시 동글값 저장여부 확인! HJ_tbl_Memberinfo_A_Dongle_Chk
			PRINT "{""result"":""error"",""message"":""인증값이 변조되었습니다. 다시 인증해주세요!""}"
			Response.End
		End If
%>
<%
		'승인된  카드키젠 암호화
		Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV

			'If A_CardNumber     <> "" Then A_CardNumber       = objEncrypter.Encrypt(A_CardNumber)
			''If chkA_Card_Dongle	<> "" Then chkA_Card_Dongle	  = objEncrypter.Encrypt(chkA_Card_Dongle)		'KSNET X

		Set objEncrypter = Nothing

		arrParams = Array(_
			Db.makeParam("@DK_MBID1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
			Db.makeParam("@DK_MBID2",adInteger,adParamInput,4,DK_MEMBER_ID2), _

			Db.makeParam("@A_CardCode",adVarChar,adParamInput,20,A_CardCode),_
			Db.makeParam("@A_CardNumber",adVarChar,adParamInput,200,A_CardNumber),_
			Db.makeParam("@A_Period1",adVarChar,adParamInput,25,A_Period1),_
			Db.makeParam("@A_Period2",adVarChar,adParamInput,25,A_Period2),_
			Db.makeParam("@A_Card_Name_Number",adVarChar,adParamInput,50,A_Card_Name_Number),_
			Db.makeParam("@A_Birth",adVarChar,adParamInput,100,A_Birth),_

			Db.makeParam("@A_Card_Dongle",adVarWChar,adParamInput,200,chkA_Card_Dongle),_
			Db.makeParam("@oIDX",adInteger,adParamInput,0,oIDX), _

			Db.makeParam("@RecodTime",adVarChar,adParamInput,19,Recordtime),_
			Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
		)
		Call Db.exec("HJP_MEMBER_INFO_MODIFY_CMS_AJAX",DB_PROC,arrParams,DB3)
		OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

	End If
	' ** 카드결제정보 변경 요청했을경우 E

	' ** 물건정보 변경 요청했을경우 S

	For i = 0 to (itemIdxData.length-1)
		itemUpt     = itemUptData.get(cdbl(i))
		itemIdx     = itemIdxData.get(cdbl(i))
		itemCount   = itemCountData.get(cdbl(i))
		itemCode    = itemCodeData.get(cdbl(i))

		If itemIdx <> "" Then '순번이 있으면 이미 있던 정보				'function addThis() (".selItemIndex").val(''); 확인!
			arrParams = Array(_
				Db.makeParam("@DK_MBID1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
				Db.makeParam("@DK_MBID2",adInteger,adParamInput,4,DK_MEMBER_ID2), _
				Db.makeParam("@oIDX",adInteger,adParamInput,0,oIDX), _
				Db.makeParam("@intIDX",adInteger,adParamInput,0,itemIdx), _
				Db.makeParam("@ItemCount",adInteger,adParamInput,0,ItemCount), _
				Db.makeParam("@ItemCode",adVarChar,adParamInput,10,itemCode), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("HJP_GOODS_INFO_MODIFY_CMS_AJAX",DB_PROC,arrParams,DB3)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)

		Else '순번이 없으면 신규정보			'itemUpt = "T"

			arrParams = Array(_
				Db.makeParam("@DK_MBID1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
				Db.makeParam("@DK_MBID2",adInteger,adParamInput,4,DK_MEMBER_ID2), _
				Db.makeParam("@oIDX",adInteger,adParamInput,0,oIDX), _
				Db.makeParam("@ItemCode",adVarchar,adParamInput,20,ItemCode), _
				Db.makeParam("@ItemCount",adInteger,adParamInput,0,ItemCount), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("HJP_GOODS_INFO_REGIST_CMS_AJAX",DB_PROC,arrParams,DB3)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)

		End If
	Next
'Response.End
	' ** 물건정보 변경 요청했을경우 E

	' ** 물건정보에 대한 합계금액 업데이트 S

		arrParams = Array(_
			Db.makeParam("@DK_MBID1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
			Db.makeParam("@DK_MBID2",adInteger,adParamInput,4,DK_MEMBER_ID2), _
			Db.makeParam("@oIDX",adInteger,adParamInput,0,oIDX), _
			Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
		)
		Call Db.exec("HWP_GOODS_INFO_UPDATE_CMS_AJAX",DB_PROC,arrParams,DB3)

	' ** 물건정보에 대한 합계금액 업데이트 E

	'이상없으면 OK
	If Err.Number = 0 Then
		PRINT "{""result"":""success"",""message"":""정상 처리되었습니다.""}"
	Else    '이상있으면...
		PRINT "{""result"":""error"",""message"":""수정처리 중 에러가 발생했습니다.""}"
	End If
%>
