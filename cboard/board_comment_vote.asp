<!--#include virtual="/_lib/strFunc.asp" -->
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual="/admin/_inc/adminPath.asp" -->
<%End If%>
<%
    Response.ContentType="text/html;charset=utf-8"


	If DK_MEMBER_LEVEL < 1 Then
		Response.Write "{"
		Response.Write """returnData"":""ERROR"",""returnMessage"":""회원만 게시물을 추천할 수 있습니다."",""rCnt"":""0"""
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

	SQL2 = "SELECT COUNT(*) FROM [DK_NBOARD_COMMENT_VOTE] WITH(NOLOCK) WHERE [bIDX] = ? AND [strUserID] = ? AND [mode] = 'vote' "
	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _
		Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID) _
	)
	ThisVoteCnt = Db.execRsData(SQL2,DB_TEXT,arrParams,Nothing)

	If ThisVoteCnt > 0 Then
		If ointIDX ="" Then

		''	Response.Write "{"
		''	Response.Write """returnData"":""ERROR2"",""returnMessage"":""<span class=\""heart2\""></span><span class=\""heartTxt2\"">추천함</span>"""
		''	Response.Write "}"
		''	Response.End

		''	SQL_D = "UPDATE [DK_NBOARD_COMMENT_VOTE] SET  [mode] = 'vote2' WHERE [bIDX] = ? AND [strUserID] = ? AND [mode] = ?"
			'추천 취소하기
			SQL_D = "DELETE FROM [DK_NBOARD_COMMENT_VOTE] WHERE [bIDX] = ? AND [strUserID] = ? AND [mode] = ?"
			arrParams_D = Array(_
				Db.makeParam("@bIDX",adInteger,adParamInput,0,intIDX), _
				Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID),_
				Db.makeParam("@mode",adVarChar,adParamInput,10,"vote")_
			)
			Call Db.exec(SQL_D,DB_TEXT,arrParams_D,Nothing)

			CANCEL_TF = "T"

		End If
	Else

		SQL1 = "INSERT INTO [DK_NBOARD_COMMENT_VOTE] ([bIDX],[strUserID],[mode]) VALUES (?,?,?)"
		arrParams = Array(_
			Db.makeParam("@bIDX",adInteger,adParamInput,0,intIDX), _
			Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID),_
			Db.makeParam("@mode",adVarChar,adParamInput,10,"vote")_
		)
		Call Db.exec(SQL1,DB_TEXT,arrParams,Nothing)
	End If

	SQL3 = "SELECT COUNT(*) FROM [DK_NBOARD_COMMENT_VOTE] WITH(NOLOCK) WHERE [bIDX] = ? AND [mode] = 'vote' "
	arrParams3 = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX) _
	)
	TotalVoteCnt = Db.execRsData(SQL3,DB_TEXT,arrParams3,Nothing)

	If Err.Number <> 0 Then
		Response.Write "{"
		Response.Write """returnData"":""ERROR"",""returnMessage"":""오류"",""rCnt"":""0"""
		Response.Write "}"
		Response.End
	Else
		If CANCEL_TF = "T" Then
			Response.Write "{"
			Response.Write """returnData"":""CANCEL"",""returnMessage"":""<a id=\""ClickVote_2\"" class=\""cp ClickVoteF\"" onclick=\""thisArticleVote('"&intIDX&"')\""><span class=\""thumbsUp3\""></span><span class=\""heartTxt2\"" style=\""vertical-align:0px;\"">"&TotalVoteCnt&"</span></a>"",""rCnt"":"""&TotalVoteCnt&""""
			Response.Write "}"
			Response.End
		Else
			Response.Write "{"
			Response.Write """returnData"":""SUCCESS"",""returnMessage"":""<a id=\""ClickVote_2\"" class=\""cp ClickVoteT\"" onclick=\""thisArticleVote('"&intIDX&"')\""><span class=\""thumbsUp2\""></span><span class=\""heartTxt2_T\"" style=\""vertical-align:0px;\"">"&TotalVoteCnt&"</span></a>"",""rCnt"":"""&TotalVoteCnt&""""
			Response.Write "}"
			Response.End
		End If
	End If


%>