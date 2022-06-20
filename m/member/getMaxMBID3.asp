<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"


	Dim styleValue,mode
		mode = Request("mode")
		cate = Request("cate")
		smbid1 = Request("smbid1")
		smbid2 = Request("smbid2")

		'ZJ 수당후원 테이블별 MAX 차수 불러오기(2015-05-28)
		arrParams = Array(_
			Db.makeParam("@SDK_MEMBER_ID1",adVarchar,adParamInput,20,smbid1) ,_
			Db.makeParam("@SDK_MEMBER_ID2",adInteger,adParamInput,0,smbid2) _
		)
		Set DKRS = Db.execRs("HJP_TREE_MAX_SPON_MBID3_SUB",DB_PROC,arrParams,DB3)
		If Not DKRS.BOF And Not DKRS.EOF Then
			RS_MAX_MBID3_01		= DKRS(0)
			RS_MAX_MBID3_02		= DKRS(1)
			RS_MAX_MBID3_03		= DKRS(2)
			RS_MAX_MBID3_04		= DKRS(3)
			RS_MAX_MBID3_05		= DKRS(4)
		Else
			RS_MAX_MBID3_01		= ""
			RS_MAX_MBID3_02		= ""
			RS_MAX_MBID3_03		= ""
			RS_MAX_MBID3_04		= ""
			RS_MAX_MBID3_05		= ""
		End If
		Call CloseRS(DKRS)

		Select Case cate
			Case "1"
				RS_MAX_MBID3 = RS_MAX_MBID3_01
			Case "2"
				RS_MAX_MBID3 = RS_MAX_MBID3_02
			Case "3"
				RS_MAX_MBID3 = RS_MAX_MBID3_03
			Case "4"
				RS_MAX_MBID3 = RS_MAX_MBID3_04
			Case "5"
				RS_MAX_MBID3 = RS_MAX_MBID3_05
		End Select



		If RS_MAX_MBID3 <> "" Then
			Response.Write "<option value="""">"&LNG_CS_GETMAXMBID3_TEXT01&"</option>"
			'Response.Write "<option value="""">"&LNG_CS_GETMAXMBID3_TEXT01_ZJ&"</option>"
			For i = 1 To RS_MAX_MBID3
				Response.Write "<option value="""&i&""">"&i&"</option>"
			Next
		Else
			Response.Write "<option value="""">"&LNG_CS_GETMAXMBID3_TEXT02&"</option>"
			'Response.Write "<option value="""">"&LNG_CS_GETMAXMBID3_TEXT02_ZJ&"</option>"
		End If

%>
