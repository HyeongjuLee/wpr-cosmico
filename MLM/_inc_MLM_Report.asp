<%

	'##################################################################################################
	'############## [특판 신버전] CS주문 승인여부체크 / MLM 신고 S ####################################

	'처리 프로시져 확인!!!!!!
	'P_MLMUNION_ORDER_PROC = "p_mlmunion_Order_2"			'인자값으로 입력
	P_MLMUNION_ORDER_PROC = "p_mlmunion_Order_3"			'프로시져안에서  MLM_CmpCode 선언 또는 방판(프로시져 내에서 API 신고처리)

	If MLM_TF = "T" And OUT_ORDERNUMBER <> "" And MLM_CmpCode <> "" Then

		HJCS_ORDER_SELLTF = 0
		SQL_TF = "SELECT [SellTF] FROM [tbl_SalesDetail_TF] WHERE [OrderNumber] = ?"
		arrParams_TF = Array(_
			Db.makeParam("@OrderNumber",adVarChar,adParamInput,50,OUT_ORDERNUMBER) _
		)
		HJCS_ORDER_SELLTF = Db.execRsData(SQL_TF,DB_TEXT,arrParams_TF,DB3)
		'HJCS_ORDER_SELLTF = 1

		If HJCS_ORDER_SELLTF = 1 Then

			arrParams_MLM1 = Array(_
				Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
				Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
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
			Call Db.exec(P_MLMUNION_ORDER_PROC,DB_PROC,arrParams_MLM2,DB3)

		End If

	End If
	'############## [특판 신버전] CS주문 승인여부체크 / MLM 신고 S ####################################
	'##################################################################################################

%>
