<!--#include virtual="/_lib/strFunc.asp"-->
<!--#include virtual = "/_lib/json2.asp"-->
<%

'	DK_MEMBER_ID1 = "AL"
'	DK_MEMBER_ID2 = "10266298"

	SQL = "SELECT TOP(1) [Member_Code1],[Member_Code2] FROM [tbl_Config] WITH(NOLOCK) "
	Set DKRS = Db.execRs(SQL,DB_TEXT,Nothing,DB3)
	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_Member_Code1 = DKRS("Member_Code1")
		DKRS_Member_Code2 = DKRS("Member_Code2")
	Else
		'Call ReturnAjaxMsg("FAIL","기본설정값을 불러오지 못했습니다. 다시 시도해주세요.")
		Call ReturnAjaxMsg("FAIL",LNG_TEXT_FAILED_TO_LOAD_DEFAULTS)
	End If
	Call closeRs(DKRS)



    Dim JsonObj
    Set JsonObj = jsObject()

    Dim arrObj


	SQL = "SELECT * FROM [DKT_TREE_FAVORITE_SPON] WITH(NOLOCK) WHERE [MBID] = ? AND [MBID2] = ?"
	arrParams = Array(_
		Db.makeParam("@MBID1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		Db.makeParam("@MBID2",adInteger,adParamInput,4,DK_MEMBER_ID2) _
	)
	Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,DB3)
	If Not DKRS.BOF And Not DKRS.EOF Then

		JsonObj("result") = "SUCCESS"
		JsonObj("resultMsg") = "SUCCESS"
		Set JsonObj("FaData") = jsArray()
		Set arrObj = jsObject()


		DKRS_strFavorite = DKRS("strFavorite")
		S_DKRSD_strFavorite = Split(DKRS_strFavorite,",")
		U_DKRSD_strFavorite = UBound(S_DKRSD_strFavorite)


		'For i = 0 To U_DKRSD_strFavorite
		'	PRINT S_DKRSD_strFavorite(i)
		'Next

		For i = 0 To U_DKRSD_strFavorite
			Set arrObj = jsObject()

			mbids = S_DKRSD_strFavorite(i)
			mbid1 = Left(mbids,DKRS_Member_Code1)
			mbid2 = Mid(mbids,(DKRS_Member_Code1+1),Len(mbids))

			'print mbid1
			'print mbid2

			SQL2 = "SELECT [M_NAME],[Webid] FROM [tbl_memberinfo] WITH(NOLOCK) WHERE [MBID] = ? AND [MBID2] = ?"
			arrParams2 = Array(_
				Db.makeParam("@MBID1",adVarChar,adParamInput,20,mbid1), _
				Db.makeParam("@MBID2",adInteger,adParamInput,4,mbid2) _
			)
			Set DKRS2 = Db.execRs(SQL2,DB_TEXT,arrParams2,DB3)
			If Not DKRS2.BOF And Not DKRS2.EOF Then
				m_name = DKRS2("M_NAME")
				Webid = DKRS2("Webid")


				arrObj("Fa_mbid1")	= mbid1
				arrObj("Fa_mbid2")	= mbid2
				arrObj("Fa_name")	= m_name
				arrObj("Fa_Webid")	= Webid
				Set JsonObj("FaData")(i) = arrObj


			End If


		Next


        PRINT toJSON(JsonObj)
        Response.End



	Else
		Call ReturnAjaxMsg("NOTDATA","")


	End If




	'PRINT MODE
	'PRINT mbid

	'If UCase(DK_MEMBER_ID1&DK_MEMBER_ID2) <> UCase(MBID) Then
	'	Call ReturnAjaxMsg("FAIL","회원정보가 상이합니다. 새로고침 후 다시 시도해주세요")
	'End If
	Select Case MODE
		Case "ADD"
			SQL = "SELECT * FROM [DKT_TREE_FAVORITE_SPON] WITH(NOLOCK) WHERE [MBID] = ? AND [MBID2] = ?"
			arrParams = Array(_
				Db.makeParam("@MBID1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
				Db.makeParam("@MBID2",adInteger,adParamInput,4,DK_MEMBER_ID2) _
			)
			Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,DB3)
			faTF = False
			If Not DKRS.BOF And Not DKRS.EOF Then
				DKRS_strFavorite = DKRS("strFavorite")
				S_DKRSD_strFavorite = Split(DKRS_strFavorite,",")

				If FN_IN_ARRAY(mbid,S_DKRSD_strFavorite) = True Then
					'Call ReturnAjaxMsg("SUCCESS","이미 즐겨찾기에 등록된 회원입니다.")
					Call ReturnAjaxMsg("SUCCESS",LNG_TEXT_ALREADY_A_FAVORITE_MEMBER)
				Else
					Fa_Data_Set = DKRS_strFavorite & "," & MBID

					SQL2 = "UPDATE [DKT_TREE_FAVORITE_SPON] SET [strFavorite] = ? WHERE [MBID] = ? AND [MBID2] = ?"
					arrParams2 = Array(_
						Db.makeParam("@strFavorite",adVarChar,adParamInput,MAX_LENGTH,Fa_Data_Set), _
						Db.makeParam("@MBID1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
						Db.makeParam("@MBID2",adInteger,adParamInput,4,DK_MEMBER_ID2) _
					)
					Call Db.exec(SQL2,DB_TEXT,arrParams2,DB3)
					If Err.Number = 0 Then
						'Call ReturnAjaxMsg("SUCCESS","등록되었습니다")
						Call ReturnAjaxMsg("SUCCESS",LNG_TEXT_REGISTERED)
					Else
						'Call ReturnAjaxMsg("FAIL","데이터 저장 중 오류가 발생하였습니다. 새로고침 후 다시 시도해주세요.")
						Call ReturnAjaxMsg("FAIL",LNG_AJAX_IDPW_PWD_TEXT11 & LNG_STRTEXT_TEXT02)
					End If

					'Call ReturnAjaxMsg("SUCCESS","이미 즐겨찾기에 등록된 회원입니다.")

				End If

			Else
				SQL2 = "INSERT INTO [DKT_TREE_FAVORITE_SPON] (MBID,MBID2,strFavorite) VALUES (?,?,?)"
				arrParams2 = Array(_
					Db.makeParam("@MBID1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
					Db.makeParam("@MBID2",adInteger,adParamInput,4,DK_MEMBER_ID2), _
					Db.makeParam("@MBID2",adVarChar,adParamInput,MAX_LENGTH,mbid) _
				)
				Call Db.exec(SQL2,DB_TEXT,arrParams2,DB3)
				If Err.Number = 0 Then
					'Call ReturnAjaxMsg("SUCCESS","등록되었습니다")
					Call ReturnAjaxMsg("SUCCESS",LNG_TEXT_REGISTERED)
				Else
					'Call ReturnAjaxMsg("FAIL","데이터 저장 중 오류가 발생하였습니다. 새로고침 후 다시 시도해주세요.")
					Call ReturnAjaxMsg("FAIL",LNG_AJAX_IDPW_PWD_TEXT11 & LNG_STRTEXT_TEXT02)
				End If
			End If
		Case "DEL"
			SQL = "SELECT * FROM [DKT_TREE_FAVORITE_SPON] WITH(NOLOCK) WHERE [MBID] = ? AND [MBID2] = ?"
			arrParams = Array(_
				Db.makeParam("@MBID1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
				Db.makeParam("@MBID2",adInteger,adParamInput,4,DK_MEMBER_ID2) _
			)
			Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,DB3)
			faTF = False
			If Not DKRS.BOF And Not DKRS.EOF Then
				DKRS_strFavorite = DKRS("strFavorite")
				S_DKRSD_strFavorite = Split(DKRS_strFavorite,",")

				If FN_IN_ARRAY(mbid,S_DKRSD_strFavorite) = True Then
					Fa_Data_Set = Replace(Replace(DKRS_strFavorite,MBID,""),",,",",")

					SQL2 = "UPDATE [DKT_TREE_FAVORITE_SPON] SET [strFavorite] = ? WHERE [MBID] = ? AND [MBID2] = ?"
					arrParams2 = Array(_
						Db.makeParam("@strFavorite",adVarChar,adParamInput,MAX_LENGTH,Fa_Data_Set), _
						Db.makeParam("@MBID1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
						Db.makeParam("@MBID2",adInteger,adParamInput,4,DK_MEMBER_ID2) _
					)
					Call Db.exec(SQL2,DB_TEXT,arrParams2,DB3)
					If Err.Number = 0 Then
						'Call ReturnAjaxMsg("SUCCESS","삭제되었습니다")
						Call ReturnAjaxMsg("SUCCESS",LNG_TEXT_DELETED)
					Else
						'Call ReturnAjaxMsg("FAIL","데이터 저장 중 오류가 발생하였습니다. 새로고침 후 다시 시도해주세요.")
						Call ReturnAjaxMsg("FAIL",LNG_AJAX_IDPW_PWD_TEXT11 & LNG_STRTEXT_TEXT02)
					End If
				Else
					'Call ReturnAjaxMsg("SUCCESS","이미 삭제되었거나 즐겨찾기 되지 않은 회원입니다.")
					Call ReturnAjaxMsg("SUCCESS",LNG_TEXT_ALERDY_DELETED_OR_NOT_FAV)
				End If

			Else
				If Err.Number = 0 Then
					'Call ReturnAjaxMsg("SUCCESS","등록된 즐겨찾기가 없는 회원입니다. 즐겨찾기 후에 시도해주세요.")
					Call ReturnAjaxMsg("SUCCESS",LNG_TEXT_NO_REGISTERED_TO_FAVORITE)
				Else
					'Call ReturnAjaxMsg("FAIL","데이터 저장 중 오류가 발생하였습니다. 새로고침 후 다시 시도해주세요.")
					Call ReturnAjaxMsg("FAIL",LNG_AJAX_IDPW_PWD_TEXT11 & LNG_STRTEXT_TEXT02)
				End If
			End If




	End Select


%>