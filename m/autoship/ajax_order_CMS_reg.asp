<!--#include virtual = "/_lib/strFunc.asp" -->
<!--#include virtual = "/_lib/json2.asp" -->
<%

	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1)
	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)

	AJAX_TF = "T"
	AUTOSHIP_CNT_PAGE = "T"
%>
<!--#include virtual = "/Myoffice/autoship/_autoship_CONFIG.asp"-->
<%

    strName                 = pRequestTF_JSON("strName", True)
    strZip                  = pRequestTF_JSON("strZip", True)
    strADDR1                = pRequestTF_JSON("strADDR1", True)
    strADDR2                = pRequestTF_JSON("strADDR2", True)
    strMobile               = pRequestTF_JSON("strMobile", True)
    strTel                  = pRequestTF_JSON("strTel", False)
    cardInfoChk             = pRequestTF_JSON("cardInfoChk", False)

    A_CardCode               = pRequestTF_JSON("A_CardCode", True)
    A_CardNumber             = pRequestTF_JSON("A_CardNumber", False)			'F
    A_Period1                = pRequestTF_JSON("A_Period1", False)				'F
    A_Period2                = pRequestTF_JSON("A_Period2", False)				'F
    A_Card_Name_Number       = pRequestTF_JSON("A_Card_Name_Number", False)		'F
    A_Birth                  = pRequestTF_JSON("A_Birth", False)				'F
    chkA_Card_Dongle         = pRequestTF_JSON("chkA_Card_Dongle", True)
    chkA_Card_DongleIDX      = pRequestTF_JSON("chkA_Card_DongleIDX", False)	'추가
    A_Start_Date             = pRequestTF_JSON("A_Start_Date", True)
    A_AutoCnt                = pRequestTF_JSON("A_AutoCnt", True)
    'A_ETC                    = pRequestTF_JSON("A_ETC", False)

    indexArray              = pRequestTF_JSON("indexArray", True)
    countArray              = pRequestTF_JSON("countArray", True)
    itemArray               = pRequestTF_JSON("itemArray", True)


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
    A_Start_Date		= Replace(A_Start_Date,"-","")
    If A_Start_Date <> "" Then
        A_Month_Date	= CDbl(Right(A_Start_Date,2))				'매월 결제일
    End If

    '▣오토쉽 월 결제일 체크 (config)
	If FN_AUTOSHIP_PAYABLE_DAYS(A_Month_Date) = False Then
        PRINT "{""result"":""error"",""message"":"""&AUTOSHIP_PAYABLE_DAYS_ALERT&"""}"
        Response.end
	End If

    If indexArray <> "" Then
        Dim itemIdxData : Set itemIdxData = JSON.parse(join(array(indexArray)))
    End If

    If countArray <> "" Then
        Dim itemCountData : Set itemCountData = JSON.parse(join(array(countArray)))
    End If

    If itemArray <> "" Then
        Dim itemCodeData : Set itemCodeData = JSON.parse(join(array(itemArray)))
    End If


    '정보 가져왔으면 여기서부터 업데이트 시작

    '승인된  카드키젠 암호화
    Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
        objEncrypter.Key = con_EncryptKey
        objEncrypter.InitialVector = con_EncryptKeyIV

		If strMobile		<> "" Then strMobile		= objEncrypter.Encrypt(strMobile)
        If strTel			<> "" Then strTel			= objEncrypter.Encrypt(strTel)
        If strADDR1			<> "" Then strADDR1			= objEncrypter.Encrypt(strADDR1)
        If strADDR2			<> "" Then strADDR2			= objEncrypter.Encrypt(strADDR2)
        'If A_CardNumber     <> "" Then A_CardNumber		= objEncrypter.Encrypt(A_CardNumber)
		''If chkA_Card_Dongle	<> "" Then chkA_Card_Dongle	= objEncrypter.Encrypt(chkA_Card_Dongle)		'KSNET X
    Set objEncrypter = Nothing

    '임시 금액 처리
    TOTAL_A_ProcAmt = 0

    strZip = Replace(strZip,"-","")

    'Tbl_Memberinfo_A 등록처리
    arrParams = Array(_
        Db.makeParam("@DK_MBID1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
        Db.makeParam("@DK_MBID2",adInteger,adParamInput,4,DK_MEMBER_ID2), _
        Db.makeParam("@strName",adVarWChar,adParamInput,100,strName),_
        Db.makeParam("@strMobile",adVarChar,adParamInput,100,strMobile),_
        Db.makeParam("@strTel",adVarChar,adParamInput,100,strTel),_
        Db.makeParam("@strZip",adVarChar,adParamInput,10,strZip),_
        Db.makeParam("@strADDR1",adVarWChar,adParamInput,700,strADDR1),_
        Db.makeParam("@strADDR2",adVarWChar,adParamInput,700,strADDR2),_

        Db.makeParam("@A_CardCode",adVarChar,adParamInput,20,A_CardCode),_
        Db.makeParam("@A_CardNumber",adVarChar,adParamInput,50,A_CardNumber),_
        Db.makeParam("@A_Period1",adVarChar,adParamInput,25,A_Period1),_
        Db.makeParam("@A_Period2",adVarChar,adParamInput,25,A_Period2),_
        Db.makeParam("@A_Card_Name_Number",adVarWChar,adParamInput,100,A_Card_Name_Number),_
        Db.makeParam("@A_Birth",adVarChar,adParamInput,100,A_Birth),_

        Db.makeParam("@A_Card_Dongle",adVarWChar,adParamInput,100,chkA_Card_Dongle),_

        Db.makeParam("@A_Start_Date",adVarChar,adParamInput,20,A_Start_Date),_
        Db.makeParam("@A_Month_Date",adVarChar,adParamInput,20,A_Month_Date),_
        Db.makeParam("@A_AutoCnt",adInteger,adParamInput,4,A_AutoCnt),_
        Db.makeParam("@A_ProcAmt",adInteger,adParamInput,0,TOTAL_A_ProcAmt), _

        Db.makeParam("@RecodTime",adVarChar,adParamInput,19,Recordtime),_

        Db.makeParam("@A_IDENTITY",adInteger,adParamOutput,0,0), _

        Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
    )
    Call Db.exec("HJP_CMS_INFO_REGIST",DB_PROC,arrParams,DB3)
    oIDX		 = arrParams(UBound(arrParams)-1)(4)
    OUTPUT_VALUE = arrParams(UBound(arrParams))(4)


    '등록 물품들 처리하기
    For i = 0 to (itemCountData.length-1)
        itemCount   = itemCountData.get(cdbl(i))
        itemCode    = itemCodeData.get(cdbl(i))

        arrParams = Array(_
            Db.makeParam("@DK_MBID1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
            Db.makeParam("@DK_MBID2",adInteger,adParamInput,4,DK_MEMBER_ID2), _
            Db.makeParam("@oIDX",adInteger,adParamInput,0,oIDX), _
            Db.makeParam("@ItemCode",adVarchar,adParamInput,20,ItemCode), _
            Db.makeParam("@ItemCount",adInteger,adParamInput,0,ItemCount), _
            Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
        )
        Call Db.exec("HJP_GOODS_INFO_REGIST_CMS_AJAX",DB_PROC,arrParams,DB3)
    Next

    '물건정보에 대한 합계금액 업데이트 S

        arrParams = Array(_
            Db.makeParam("@DK_MBID1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
            Db.makeParam("@DK_MBID2",adInteger,adParamInput,4,DK_MEMBER_ID2), _
            Db.makeParam("@oIDX",adInteger,adParamInput,0,oIDX), _
            Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
        )
        Call Db.exec("HWP_GOODS_INFO_UPDATE_CMS_AJAX",DB_PROC,arrParams,DB3)

    ' 물건정보에 대한 합계금액 업데이트 E

    '이상없으면 OK
    If Err.Number = 0 Then
        PRINT "{""result"":""success"",""message"":""정상 처리되었습니다.""}"
		Response.End
    Else    '이상있으면...
        PRINT "{""result"":""error"",""message"":""수정처리 중 에러가 발생했습니다.""}"
		Response.End
    End If
%>