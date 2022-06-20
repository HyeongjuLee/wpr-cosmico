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

	SQL2 = "SELECT COUNT(*) FROM [DK_NBOARD_VOTE] WITH(NOLOCK) WHERE [bIDX] = ? AND [strUserID] = ? AND [mode] = 'vote' "
	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _
		Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID) _
	)
	ThisVoteCnt = Db.execRsData(SQL2,DB_TEXT,arrParams,Nothing)

	If ThisVoteCnt > 0 Then
		If ointIDX ="" Then

			Response.Write "{"
			Response.Write """returnData"":""ERROR2"",""returnMessage"":"""""
			Response.Write "}"
			Response.End

		''	SQL_D = "UPDATE [DK_NBOARD_VOTE] SET  [mode] = 'vote2' WHERE [bIDX] = ? AND [strUserID] = ? AND [mode] = ?"
			'추천 취소하기
			SQL_D = "DELETE FROM [DK_NBOARD_VOTE] WHERE [bIDX] = ? AND [strUserID] = ? AND [mode] = ?"
			arrParams_D = Array(_
				Db.makeParam("@bIDX",adInteger,adParamInput,0,intIDX), _
				Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID),_
				Db.makeParam("@mode",adVarChar,adParamInput,10,"vote")_
			)
			Call Db.exec(SQL_D,DB_TEXT,arrParams_D,Nothing)

			CANCEL_TF = "T"

		End If
	Else

		SQL1 = "INSERT INTO [DK_NBOARD_VOTE] ([bIDX],[strUserID],[mode]) VALUES (?,?,?)"
		arrParams = Array(_
			Db.makeParam("@bIDX",adInteger,adParamInput,0,intIDX), _
			Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID),_
			Db.makeParam("@mode",adVarChar,adParamInput,10,"vote")_
		)
		Call Db.exec(SQL1,DB_TEXT,arrParams,Nothing)
	End If

	SQL3 = "SELECT COUNT(*) FROM [DK_NBOARD_VOTE] WITH(NOLOCK) WHERE [bIDX] = ? AND [mode] = 'vote' "
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
			Response.Write """returnData"":""CANCEL"",""returnMessage"":""<a id=\""ClickVote\"" class=\""cp ClickVoteF\""><span class=\""heart3\""></span><span class=\""heartTxt2\""><!-- 추천취소 -->좋아요("&TotalVoteCnt&")</span></a>"",""rCnt"":"""&TotalVoteCnt&""""
			Response.Write "}"
			Response.End
		Else
			'▣ 글 작성자에게 포인트 지급 S
				SQL = "SELECT [strBoardName] FROM [DK_NBOARD_CONTENT] WHERE [intIDX] = ?"
				arrParams = array(_
					Db.makeParam("@intIDX",adVarChar,adParamInput,50,intIDX) _
				)
				ThisBoardName = Db.execRsData(SQL,DB_TEXT,arrParams,Nothing)

				SQL2 = "SELECT ISNULL([intPointVoteWriter],0) FROM [DK_NBOARD_POINT] WHERE [strBoardName] = ?"
				arrParams2 = array(_
					Db.makeParam("@intIDX",adVarChar,adParamInput,50,ThisBoardName) _
				)
				ThisVoteWriterPoint = CDbl(Db.execRsData(SQL2,DB_TEXT,arrParams2,Nothing))

				If ThisVoteWriterPoint > 0 Then
					SQL3 = "SELECT ISNULL(strUSerID,'') FROM [DK_NBOARD_CONTENT] WHERE [intIDX] = ?"
					arrParams3 = array(_
						Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX) _
					)
					ThisWriter = Db.execRsData(SQL3,DB_TEXT,arrParams3,Nothing)

					If ThisWriter <> "" And ThisWriter <> "GUEST" Then
						SQL4 = "INSERT INTO [DK_MEMBER_POINT_LOG]("
						SQL4 = SQL4 & " [strUserID],[intValue],[ValueComment],[dComment]"
						SQL4 = SQL4 & "	) VALUES ( "
						SQL4 = SQL4 & " ?,?,'게시물 추천받음',CONCAT(?,'에 ',?,'번 게시물을 사용자가 추천') "
						SQL4 = SQL4 & ")"
						arrParams4 = array(_
							Db.makeParam("@strUserID",adVarChar,adParamInput,20,ThisWriter), _
							Db.makeParam("@INT_WRITE_POINT",adInteger,adParamInput,4,ThisVoteWriterPoint), _
							Db.makeParam("@strBoardName",adVarChar,adParamInput,50,ThisBoardName), _
							Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX) _
						)
						Call Db.exec(SQL4,DB_TEXT,arrParams4,Nothing)
					End If
				End If

				arrParams9 = Array(_
					Db.makeParam("@strBoardName",adVarChar,adParamInput,50,ThisBoardName) _
				)
				Set DKRS9 = Db.execRs("DKPA_FORUM_CONFIG_POINT",DB_PROC,arrParams9,Nothing)

				If Not DKRS9.BOF And Not DKRS9.EOF Then
					DKRS9_isPointUse			= DKRS9("isPointUse")
					DKRS9_intPointView			= DKRS9("intPointView")
					DKRS9_intPointWrite			= DKRS9("intPointWrite")
					DKRS9_intPointReply			= DKRS9("intPointReply")
					DKRS9_intPointUpload		= DKRS9("intPointUpload")
					DKRS9_intPointDownload		= DKRS9("intPointDownload")
					DKRS9_intPointComment		= DKRS9("intPointComment")
					DKRS9_intPointVote			= DKRS9("intPointVote")
					DKRS9_isPointDelete			= DKRS9("isPointDelete")
					DKRS9_isPointDelComment		= DKRS9("isPointDelComment")
					DKRS9_intPointVoteWriter	= DKRS9("intPointVoteWriter")


					If DKRS9_isPointUse = "T" Then
						If DKRS9_intPointVoteWriter <> 0 Then
							Call FNC_CS_POINT_INPUT_WEB(ThisWriter,DKRS9_intPointVoteWriter,"911",0,"","WEB_POINT",ThisBoardName&" - "&intIDX&"번 게시물을 사용자가 추천",date10to8(DateAdd("d",now,CS_POINT_ADD_DATE)))
						End If
					End If
				End If
				Call closeRs(DKRS9)
				Call FNC_WEBGRADE_UPCHECK(ThisWriter)


			'▣ 글 작성자에게 포인트 지급 E





			Response.Write "{"
			'Response.Write """returnData"":""SUCCESS"",""returnMessage"":""<span class=\""heart2\""></span><span class=\""heartTxt2\"">추천함</span>"",""rCnt"":"""&TotalVoteCnt&""""
			Response.Write """returnData"":""SUCCESS"",""returnMessage"":"""",""rCnt"":"""&TotalVoteCnt&""""
			Response.Write "}"
			Response.End
		End If
	End If



%>