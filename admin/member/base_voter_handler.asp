<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
</head>
<body>
<%
	ADMIN_LEFT_MODE = "MEMBER"
	INFO_MODE = "MEMBER2-1"


	mbid = pRequestTF("mbid",True)
	mbid2 = pRequestTF("mbid2",True)



	SQL = "UPDATE [DKT_BASE_VOTER] SET [isUse] = 'F'"
	Call Db.exec(SQL,DB_TEXT,Nothing,DB3)


	SQL = "INSERT INTO [DKT_BASE_VOTER] ([mbid],[mbid2]) VALUES (? ,? )"
	arrParams = Array(_
		Db.makeParam("@mbid",adVarChar,adParamInput,20,mbid),_
		Db.makeParam("@mbid2",adInteger,adParamInput,4,mbid2) _
	)
	Call Db.exec(SQL,DB_TEXT,arrParams,DB3)
	'OUTPUT_VALUE = arrParams(UBound(arrParams))(4)




	If Err.number = 0 Then
		Call ALERTS(DBFINISH,"go","base_voter.asp")
	Else
		Call ALERTS(DBERROR,"back","")
	End If



%>
<!--#include virtual = "/admin/_inc/header.asp"-->
<%


%>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
