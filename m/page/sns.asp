<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "SNS"
	PAGE_SETTING2 = "SUBPAGE"
	ISLEFT = "F"
	ISSUBTOP = "T"

	' view = gRequestTF("view",True)
	'sview = gRequestTF("sview",True)
	mNum = 9
	sNum = view
	sVar = sNum

%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->

<link rel="stylesheet" href="/m/css/sns.css?v0">
</head>
<body>
<!--#include virtual = "/m/_include/header.asp"-->
<%
	strBoardName = "sns_k"
	arrParams = Array(_
		Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName)_
	)
	Set DKRS = Db.execRs("DKSP_NBOARD_CONFIG",DB_PROC,arrParams,Nothing)
	If Not DKRS.BOF And Not DKRS.EOF Then
		PAGE_SETTING				= DKRS("strCateCode")
		strBoardTitle				= DKRS("strBoardTitle")
		strBoardType				= DKRS("strBoardType")
		isImg						= DKRS("isImg")
		strImg						= BACKWORD(DKRS("strImg"))
		intLevelList				= DKRS("intLevelList")
		intLevelView				= DKRS("intLevelView")
		intLevelWrite				= DKRS("intLevelWrite")
	Else
		Call ALERTS(LNG_TEXT_INCORRECT_BOARD_SETTING,"back","")
	End If
	Call closeRs(DKRS)
%>
<style>
	.edit { outline: none; cursor: pointer; text-align: center; text-decoration: none; font-family: inherit; padding: 0.5rem 1rem; display: inline-flex; justify-content: center; align-items: center; -moz-border-radius: 0; -webkit-border-radius: 0; border-radius: 0; color: #fff; font-weight: 400; border: solid 1px #1d276b; background: #283593; display: inline-flex; justify-content: center; align-items: center; margin-top: 10px; width: 8rem; font-size: 1.3rem; display: none;}
	.edit:hover { color: #fff; text-decoration: none; background: #2d3ca7; }
	.edit:active { color: #fff; background: #232e7f; }
	.edit:hover { text-decoration: underline; }
	.edit:link { color: #fff !important; }
	.edit:visited { color: #fff !important; }
</style>
<div id="pages">
	<div class="sns_wrap">
		<article>
			<section class="kakao">
				<div class="tit">KAKAO
					<%If DK_MEMBER_TYPE = "ADMIN" Then%><a class="edit" href="/cboard/board_list.asp?bname=sns_k"><%=LNG_BOARD_BTN_MODIFY%></a><%End If%>
				</div>
				<ul>
					<%
						arrParams = Array( _
							Db.makeParam("@strBoardName",adVarChar,adParamInput,50,"sns_k"), _
							Db.makeParam("@strDomain",adVarChar,adParamInput,50,UCase(DK_MEMBER_NATIONCODE)) _
						)
						arrList = Db.execRsList("HJSP_NBOARD_SNS_TOP",DB_PROC,arrParams,listLen,Nothing)
						If IsArray(arrList) Then
							For i = 0 To listLen
								arrList_intIDX				= arrList(1,i)
								arrList_strUserID			= arrList(2,i)
								arrList_strName				= arrList(3,i)
								arrList_regDate				= arrList(4,i)
								arrList_readCnt				= arrList(5,i)
								arrList_strSubject			= arrList(6,i)
								arrList_strPic				= arrList(7,i)
								arrList_TOTALSCORE			= arrList(8,i)
								arrList_TOTALVOTE			= arrList(9,i)
								arrList_strPic1			= arrList(10,i)
								arrList_strContent			= arrList(11,i)
								arrList_strLink			= arrList(12,i)			'SNS link
								arrList_strHashtag			= arrList(13,i)			'SNS strHashtag
								arrList_regDate = Replace(Left(arrList_regDate,10),"-",".")

								imgPath = VIR_PATH("board/thum")&"/"&backword(arrList_strPic)
								thumbImg = "<img src="""&imgPath&""" width="""&newimgWidth&""" height="""&newimgHeight&""" alt="""" style=""""/>"

								If DK_MEMBER_LEVEL < intLevelView Then
									link = MOB_PATH&"/common/member_login.asp?backURL="&ThisPageURL
									target = ""
								Else
									link = arrList_strLink
									target = " target=""_blank"""
								End If
					%>
					<li>
						<a href="<%=link%>" <%=target%>>
							<div class="img"><%=thumbImg%></div>
							<div class="title"><%=backword_tag(arrList_strHashtag)%></div>
						</a>
					</li>
					<%
							Next
						End If
					%>
				</ul>
				<a href="http://pf.kakao.com/_njcWb" class="link" target="_blank">공식 카카오톡 채널<i class="icon-right-small"></i></a>
			</section>
			<section class="insta">
				<div class="tit">INSTAGRAM
					<%If DK_MEMBER_TYPE = "ADMIN" Then%><a class="edit" href="/cboard/board_list.asp?bname=sns_i"><%=LNG_BOARD_BTN_MODIFY%></a><%End If%>
				</div>
				<ul>
					<%
						arrParams = Array( _
							Db.makeParam("@strBoardName",adVarChar,adParamInput,50,"sns_i"), _
							Db.makeParam("@strDomain",adVarChar,adParamInput,50,UCase(DK_MEMBER_NATIONCODE)) _
						)
						arrList = Db.execRsList("HJSP_NBOARD_SNS_TOP",DB_PROC,arrParams,listLen,Nothing)
						If IsArray(arrList) Then
							For i = 0 To listLen
								arrList_intIDX				= arrList(1,i)
								arrList_strUserID			= arrList(2,i)
								arrList_strName				= arrList(3,i)
								arrList_regDate				= arrList(4,i)
								arrList_readCnt				= arrList(5,i)
								arrList_strSubject			= arrList(6,i)
								arrList_strPic				= arrList(7,i)
								arrList_TOTALSCORE			= arrList(8,i)
								arrList_TOTALVOTE			= arrList(9,i)
								arrList_strPic1			= arrList(10,i)
								arrList_strContent			= arrList(11,i)
								arrList_strLink			= arrList(12,i)			'SNS link
								arrList_strHashtag			= arrList(13,i)			'SNS strHashtag
								arrList_regDate = Replace(Left(arrList_regDate,10),"-",".")

								imgPath = VIR_PATH("board/thum")&"/"&backword(arrList_strPic)
								thumbImg = "<img src="""&imgPath&""" width="""&newimgWidth&""" height="""&newimgHeight&""" alt="""" style=""""/>"

								If DK_MEMBER_LEVEL < intLevelView Then
									link = MOB_PATH&"/common/member_login.asp?backURL="&ThisPageURL
									target = ""
								Else
									link = arrList_strLink
									target = " target=""_blank"""
								End If
					%>
					<li>
						<a href="<%=link%>" <%=target%>>
							<div class="img"><%=thumbImg%></div>
							<div class="title"><%=backword_tag(arrList_strHashtag)%></div>
						</a>
					</li>
					<%
							Next
						End If
					%>
				</ul>
				<a href="https://www.instagram.com/invites/contact/?i=18zd8wmn77rse&utm_content=nyal2vb" class="link" target="_blank">공식 인스타그램 채널<i class="icon-right-small"></i></a>
			</section>
			<section class="facebook">
				<div class="tit">FACEBOOK
					<%If DK_MEMBER_TYPE = "ADMIN" Then%><a class="edit" href="/cboard/board_list.asp?bname=sns_f"><%=LNG_BOARD_BTN_MODIFY%></a><%End If%>
				</div>
				<ul>
					<%
						arrParams = Array( _
							Db.makeParam("@strBoardName",adVarChar,adParamInput,50,"sns_f"), _
							Db.makeParam("@strDomain",adVarChar,adParamInput,50,UCase(DK_MEMBER_NATIONCODE)) _
						)
						arrList = Db.execRsList("HJSP_NBOARD_SNS_TOP",DB_PROC,arrParams,listLen,Nothing)
						If IsArray(arrList) Then
							For i = 0 To listLen
								arrList_intIDX				= arrList(1,i)
								arrList_strUserID			= arrList(2,i)
								arrList_strName				= arrList(3,i)
								arrList_regDate				= arrList(4,i)
								arrList_readCnt				= arrList(5,i)
								arrList_strSubject			= arrList(6,i)
								arrList_strPic				= arrList(7,i)
								arrList_TOTALSCORE			= arrList(8,i)
								arrList_TOTALVOTE			= arrList(9,i)
								arrList_strPic1			= arrList(10,i)
								arrList_strContent			= arrList(11,i)
								arrList_strLink			= arrList(12,i)			'SNS link
								arrList_strHashtag			= arrList(13,i)			'SNS strHashtag
								arrList_regDate = Replace(Left(arrList_regDate,10),"-",".")

								imgPath = VIR_PATH("board/thum")&"/"&backword(arrList_strPic)
								thumbImg = "<img src="""&imgPath&""" width="""&newimgWidth&""" height="""&newimgHeight&""" alt="""" style=""""/>"

								If DK_MEMBER_LEVEL < intLevelView Then
									link = MOB_PATH&"/common/member_login.asp?backURL="&ThisPageURL
									target = ""
								Else
									link = arrList_strLink
									target = " target=""_blank"""
								End If
					%>
					<li>
						<a href="<%=link%>" <%=target%>>
							<div class="img"><%=thumbImg%></div>
							<div class="title"><%=backword_tag(cutString(arrList_strHashtag,38))%></div>
						</a>
					</li>
					<%
							Next
						End If
					%>
				</ul>
				<a href="https://www.facebook.com/100107105973193/posts/111825651468005/?substory_index=0 " class="link" target="_blank">공식 페이스북 페이지<i class="icon-right-small"></i></a>
			</section>
		</article>
	</div>
</div>

<!--#include virtual = "/m/_include/copyright.asp"-->