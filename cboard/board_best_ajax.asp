<!--#include virtual="/_lib/strFunc.asp" -->
<%
    Response.ContentType="text/html;charset=utf-8"


	If DK_MEMBER_TYPE <> "ADMIN" Then
		Response.Write "{"
		Response.Write """returnData"":""ERROR"",""returnMessage"":""관리자만 게시물을 선택할 수 있습니다."",""rCnt"":""0"""
		Response.Write "}"
		Response.End
	End If

	intIDX = Request("ointIDX")
	If intIDX = "" Then
		Response.Write "{"
		Response.Write """returnData"":""ERROR"",""returnMessage"":""게시물 번호가 전송되지 않았습니다."",""rCnt"":""0"""
		Response.Write "}"
		Response.End
	End If



	CANCEL_TF = ""

	SQL2 = "SELECT isMainView FROM [DK_NBOARD_CONTENT] WITH(NOLOCK) WHERE [intIDX] = ?"
	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX) _
	)
	ThisTF = Db.execRsData(SQL2,DB_TEXT,arrParams,Nothing)

	If ThisTF = "T" Then
		chgTF = "F"
		rData = "SUCCESS2"
	Else
		chgTF = "T"
		rData = "SUCCESS"
	End If


	SQL3 = "UPDATE [DK_NBOARD_CONTENT] SET [isMainView] = ? WHERE [intIDX] = ? "
	arrParams3 = Array(_
		Db.makeParam("@isMainView",adChar,adParamInput,1,chgTF), _
		Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX) _
	)
	Call Db.exec(SQL3,DB_TEXT,arrParams3,Nothing)


			'▣ 글 작성자에게 포인트 지급 E





	Response.Write "{"
	'Response.Write """returnData"":""SUCCESS"",""returnMessage"":""<span class=\""heart2\""></span><span class=\""heartTxt2\"">추천함</span>"",""rCnt"":"""&TotalVoteCnt&""""
	Response.Write """returnData"":"""&rData&""",""returnMessage"":"""",""rCnt"":"""&TotalVoteCnt&""""
	Response.Write "}"
	Response.End




%>