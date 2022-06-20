<!--#include virtual="/_lib/strFunc.asp" -->
<%
	On Error Resume Next
	kakaoID = pRequestTF2("uid",True)
	'kakaoID = "1317653085"
	strUserID = kakaoID

'웹체크
	arrParams = Array(_
		Db.makeParam("@strUserID",adVarChar,adParamInput,100,strUserID) _
	)
	ID_CNT1 = Db.execRsData("DKPA_TOTAL_ID_CHECK",DB_PROC,arrParams,Nothing)


'CS체크
	arrParams = Array(_
		Db.makeParam("@strUserID",adVarChar,adParamInput,100,strUserID) _
	)
	ID_CNT2 = Db.execRsData("[DKSP_SNSID_CNT]",DB_PROC,arrParams,DB3)

	' 차단 아이디 확인
		SQL1 = " SELECT [strBlockID] FROM [DK_SITE_CONFIG] WHERE [strSiteID] = ?"
		arrParams1 = Array(_
			Db.makeParam("@strSiteID",adVarchar,adParamInput,20,"www") _
		)
		Set DKRS1 = Db.execRs(SQL1,DB_TEXT,arrParams1,Nothing)
		BLOCKID = ""
		If Not DKRS1.BOF And Not DKRS1.EOF Then
			BLOCKID = DKRS1(0)
		End If
		Call closeRS(DKRS1)

		ID_CNT3 = InStr(","& BLOCKID &",",","& strUserID &",")

		ID_CNT0 = ID_CNT1 + ID_CNT2 + ID_CNT3
'		print BLOCKID
		Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV

			kakaoID2 = objEncrypter.Encrypt(strUserID)

			If ID_CNT0 > 0 Then
				'RS_strUserID = DKRS("strUserID")
				SESSION("KAKAO_SESSION") = ""
				SESSION("KAKAO_ID") = ""
				'Response.Cookies(COOKIES_NAME)("KAKAO_SESSION")  = ""
				'Response.Cookies(COOKIES_NAME)("KAKAO_ID")  = ""
				PRINT "{""statusCode"":""9998"",""message"":"""&server.urlencode("FAIL")&""",""result"":""이미 등록된 아이디입니다""}"
			Else
				SESSION("KAKAO_SESSION") = "T"
				SESSION("KAKAO_ID") = kakaoID2
				'Response.Cookies(COOKIES_NAME)("KAKAO_SESSION")  = "T"
				'Response.Cookies(COOKIES_NAME)("KAKAO_ID")  = objEncrypter.Encrypt(strUserID)
				PRINT "{""statusCode"":""0000"",""message"":"""&server.urlencode("OK")&""",""result"":"""&server.urlEncode(kakaoID2)&"""}"
			End If
		Set objEncrypter = Nothing


%>