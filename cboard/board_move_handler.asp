<!--#include virtual = "/_lib/strFunc.asp"-->
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual="/admin/_inc/adminPath.asp" -->
<%End If%>
<%

	If DK_MEMBER_TYPE <> "ADMIN" And DK_MEMBER_TYPE <> "OPERATOR" Then
		Call ALERTS("관리자 혹은 오퍼레이터만 사용가능한 기능입니다.","CLOSE","")
	End If
	moveIDX = Trim(pRequestTF("mchk",True))
	strDomain = Trim(pRequestTF("slocations",True))
	mode2 = Trim(pRequestTF("mode2",True))
	bnames =  Trim(pRequestTF("bnames",True))

	Set StrCipher = Server.CreateObject("Hoyasoft.StrCipher")
		moveIDXencoe		= Trim(StrCipher.Decrypt(moveIDX,EncTypeKey1,EncTypeKey2))		'아이디
	Set StrCipher = Nothing

	moveIDXs = Split(moveIDXencoe,",")
	moveIDXc = UBound(moveIDXs)

	Select Case mode2
		Case "xmove"
			For i = 0 To moveIDXc
				arrParams = Array(_
					Db.makeParam("@strDomain",adVarChar,adParamInput,50,strDomain),_
					Db.makeParam("@intIDX",adInteger,adParamInput,0,moveIDXs(i))_
				)
				Call Db.exec("DKP_NBOARD_CONTENT_MOVE",DB_PROC,arrParams,Nothing)
			Next
		Case "xcopy"
			For i = 0 To moveIDXc
				arrParams = Array(_
					Db.makeParam("@strDomain",adVarChar,adParamInput,50,strDomain),_
					Db.makeParam("@strBoardName",adVarChar,adParamInput,50,bnames),_
					Db.makeParam("@intIDX",adInteger,adParamInput,0,moveIDXs(i))_
				)
				Call Db.exec("DKP_NBOARD_CONTENT_COPY",DB_PROC,arrParams,Nothing)
			Next

	End Select

	Call ALERTS("처리되었습니다.","o_reloada","")
%>
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual = "/admin/_inc/document.asp"-->
<%Else%>
<!--#include virtual = "/_include/document.asp"-->
<%End If%>
</head>
<body>

</body>
</html>
