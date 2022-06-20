<!--#include virtual="/_lib/strFunc.asp"-->
<!--#include virtual = "/_lib/json2.asp"-->
<%

		sname = pRequestTF_AJAX2("sNameSearch",True)


'	DK_MEMBER_ID1 = "AL"
'	DK_MEMBER_ID2 = "10266298"





	SQL = "SELECT TOP(1) [Member_Code1],[Member_Code2] FROM [tbl_Config] WITH(NOLOCK)"
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


	arrParams = Array(_
		Db.makeParam("@DK_MEMBER_ID",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
		Db.makeParam("@DK_MEMBER_ID2",adInteger,adParamInput,0,DK_MEMBER_ID2),_
		Db.makeParam("@SNAME",adVarWChar,adParamInput,20,sname)_
	)
	arrList = Db.execRsList("DKSP_TREE_NAME_LIST",DB_PROC,arrParams,listLen,DB3)
	'arrList = Db.execRsList("HJSP_TREE_WEBID_LIST",DB_PROC,arrParams,listLen,DB3)

	If IsArray(arrList) Then
		JsonObj("result") = "SUCCESS"
		JsonObj("resultMsg") = "SUCCESS"
		Set JsonObj("FaData") = jsArray()
		Set arrObj = jsObject()

		For i = 0 To listLen
			Set arrObj = jsObject()
			mbid1	= arrList(0,i)
			mbid2	= arrList(1,i)
			m_name	= arrList(2,i)
			webid	= arrList(3,i)
			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				On Error Resume Next
					If webid <> "" Then webid	= objEncrypter.Decrypt(webid)
				On Error GoTo 0
			Set objEncrypter = Nothing


			arrObj("Fa_mbid1")	= mbid1
			arrObj("Fa_mbid2")	= mbid2
			arrObj("Fa_name")	= m_name
			arrObj("Fa_Webid")	= Webid

			Set JsonObj("FaData")(i) = arrObj

		Next
	Else
		Call ReturnAjaxMsg("NOTDATA","")
	End If


        PRINT toJSON(JsonObj)
        Response.End


%>