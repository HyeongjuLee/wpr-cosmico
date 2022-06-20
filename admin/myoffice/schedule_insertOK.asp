<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
</head>
<body>
<%
	ADMIN_LEFT_MODE = "MYOFFICE"
	INFO_MODE = "MYOFFICE1-1"

	mode			= pRequestTF("mode",True)
	sloc			= pRequestTF("sloc",false)
	lm				= pRequestTF("lm",false)


	Select Case UCase(mode)
		Case "REGIST"
			param			= pRequestTF("param",True)
			starthour		= pRequestTF("starthour",True)
			startminute		= pRequestTF("startminute",True)
			endhour			= pRequestTF("endhour",False)
			endminute		= pRequestTF("endminute",False)

			place			= pRequestTF("place",False)
			strSubject		= pRequestTF("strSubject",False)
			strContent		= pRequestTF("strContent",False)


			delTF			= pRequestTF("delTF",False)
			If IsDate(param) Then
				param = param
			Else
				Call alerts("일자형식이 맞지 않습니다.","back","")
			End If

			StartTime = starthour & ":" & startminute
			EndTime = endhour & ":" & endminute


			arrParams = Array(_
				Db.makeParam("@Date",adVarChar,adParamInput,10,Param),_
				Db.makeParam("@StartTime",adVarChar,adParamInput,5,StartTime),_
				Db.makeParam("@EndTime",adVarChar,adParamInput,5,EndTime),_
				Db.makeParam("@strSubject",adVarChar,adParamInput,200,strSubject),_
				Db.makeParam("@Place",adVarChar,adParamInput,100,Place),_
				Db.makeParam("@strContent",adVarChar,adParamInput,MAX_LENGTH,strContent),_
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR")_
			)
			Call Db.exec("DKPA_SCHEDULER_INSERT",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(UBound(arrParams))(4)
		Case "MODIFY"
			intIDX			= pRequestTF("idx",True)
			param			= pRequestTF("param",True)
			starthour		= pRequestTF("starthour",True)
			startminute		= pRequestTF("startminute",True)
			endhour			= pRequestTF("endhour",False)
			endminute		= pRequestTF("endminute",False)

			place			= pRequestTF("place",False)
			strSubject		= pRequestTF("strSubject",False)
			strContent		= pRequestTF("strContent",False)


			delTF			= pRequestTF("delTF",False)

			If IsDate(param) Then
				param = param
			Else
				Call alerts("일자형식이 맞지 않습니다.","back","")
			End If

			StartTime = starthour & ":" & startminute
			EndTime = endhour & ":" & endminute

			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX),_
				Db.makeParam("@Date",adVarChar,adParamInput,10,Param),_
				Db.makeParam("@StartTime",adVarChar,adParamInput,5,StartTime),_
				Db.makeParam("@EndTime",adVarChar,adParamInput,5,EndTime),_
				Db.makeParam("@strSubject",adVarChar,adParamInput,200,strSubject),_
				Db.makeParam("@Place",adVarChar,adParamInput,100,Place),_
				Db.makeParam("@strContent",adVarChar,adParamInput,MAX_LENGTH,strContent),_

				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR")_
			)
			Call Db.exec("DKPA_SCHEDULER_MODIFY",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(UBound(arrParams))(4)
		Case "DELETE"
			intIDX			= pRequestTF("idx",True)
			param			= pRequestTF("param",True)

			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX),_
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR")_
			)
			Call Db.exec("DKPA_SCHEDULER_DELETE",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(UBound(arrParams))(4)
		Case Else : Call ALERTS("입력/수정에 대한 정보가 넘어오지 않았습니다.","back","")
	End Select



	Select Case lm
		Case "cal" : go_linked = "schedule"
		Case "list" : go_linked = "schedule_week"
	End Select

	Select Case OUTPUT_VALUE
		Case "ERROR"	: Call ALERTS(DBERROR,"BACK","")
		Case "FINISH"	: Call ALERTS(DBFINISH,"GO",go_linked&".asp?syear="&Year(param)&"&amp;smonth="&Month(param)&"&amp;sloc="&sLocations)
		Case Else		: Call ALERTS(DBUNDEFINED,"BACK","")
	End Select


%>

<!--#include virtual = "/admin/_inc/header.asp"-->


<!--#include virtual = "/admin/_inc/copyright.asp"-->
