<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_include/document.asp"-->
</style>
</head>
<body >
<%

	Call ONLY_MEMBER_CLOSE(DK_MEMBER_LEVEL)

	popWidth = 935
	popHeight = 850

	mode			= pRequestTF("mode",True)
	schType			= pRequestTF("stype",True)

%>
<!--#include file = "schedule_config.asp"-->
<%

'	sLocations		= pRequestTF("slocations",True)
'	If DK_MEMBER_TYPE = "SADMIN" Then
'		If UCase(DK_MEMBER_GROUP) <> UCase(sLocations) Then Call ALERTS("관리할 수 있는 지점이 아닙니다","BACK","")
'	End If


	Select Case UCase(mode)
		Case "REGIST"
			param			= pRequestTF("param",True)
			sYearDate		= pRequestTF("sYearDate",True)

			starthour		= pRequestTF("starthour",True)
			startminute		= pRequestTF("startminute",True)
			endhour			= pRequestTF("endhour",False)
			endminute		= pRequestTF("endminute",False)

			place			= pRequestTF("place",False)
			strSubject		= pRequestTF("strSubject",False)
			strContent		= pRequestTF("strContent",False)


			delTF			= pRequestTF("delTF",False)

			If IsDate(sYearDate) Then
				sYearDate = sYearDate
			Else
				Call alerts(LNG_SCHEDULE_CONTROL_HANDLER_ALERT01,"back","")
			End If

			StartTime = starthour & ":" & startminute
			EndTime = endhour & ":" & endminute


			arrParams = Array(_
				Db.makeParam("@Date",adVarChar,adParamInput,10,sYearDate),_
				Db.makeParam("@StartTime",adVarChar,adParamInput,5,StartTime),_
				Db.makeParam("@EndTime",adVarChar,adParamInput,5,EndTime),_
				Db.makeParam("@strSubject",adVarWChar,adParamInput,200,strSubject),_
				Db.makeParam("@Place",adVarWChar,adParamInput,100,Place),_
				Db.makeParam("@strContent",adVarWChar,adParamInput,MAX_LENGTH,strContent),_
				Db.makeParam("@strUserID",adVarchar,adParamInput,20,DK_MEMBER_ID) ,_
				Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(LANG)), _
				Db.makeParam("@strScheduleType",adVarchar,adParamInput,30,schType) ,_
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR")_
			)
			Call Db.exec("DKP_SCHEDULER_INSERT",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(UBound(arrParams))(4)
		Case "MODIFY"
			param			= pRequestTF("param",True)
			intIDX			= pRequestTF("intIDX",True)

			sYearDate		= pRequestTF("sYearDate",True)
			starthour		= pRequestTF("starthour",True)
			startminute		= pRequestTF("startminute",True)
			endhour			= pRequestTF("endhour",False)
			endminute		= pRequestTF("endminute",False)

			place			= pRequestTF("place",False)
			strSubject		= pRequestTF("strSubject",False)
			strContent		= pRequestTF("strContent",False)


			delTF			= pRequestTF("delTF",False)

			If IsDate(sYearDate) Then
				sYearDate = sYearDate
			Else
				Call alerts(LNG_SCHEDULE_CONTROL_HANDLER_ALERT01,"back","")
			End If

			StartTime = starthour & ":" & startminute
			EndTime = endhour & ":" & endminute

			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX),_
				Db.makeParam("@Date",adVarChar,adParamInput,10,sYearDate),_
				Db.makeParam("@StartTime",adVarChar,adParamInput,5,StartTime),_
				Db.makeParam("@EndTime",adVarChar,adParamInput,5,EndTime),_
				Db.makeParam("@strSubject",adVarWChar,adParamInput,200,strSubject),_
				Db.makeParam("@Place",adVarWChar,adParamInput,100,Place),_
				Db.makeParam("@strContent",adVarWChar,adParamInput,MAX_LENGTH,strContent),_
				Db.makeParam("@strUserID",adVarchar,adParamInput,20,DK_MEMBER_ID) ,_
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR")_
			)
			Call Db.exec("DKP_SCHEDULER_MODIFY",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(UBound(arrParams))(4)
		Case "DELETE"
			intIDX			= pRequestTF("intIDX",True)
			param			= pRequestTF("param",True)

			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX),_
				Db.makeParam("@strUserID",adVarchar,adParamInput,20,DK_MEMBER_ID) ,_
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR")_
			)
			Call Db.exec("DKP_SCHEDULER_DELETE",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(UBound(arrParams))(4)
		Case Else : Call ALERTS(LNG_SCHEDULE_CONTROL_HANDLER_ALERT02,"back","")
	End Select

	Select Case OUTPUT_VALUE
		'Case "FINISH"	: Call ALERTS(DBFINISH,"GO","scheduleControl.asp?"&param)
		Case "FINISH"


		GO_URL = "scheduleControl.asp?"&param
%>
<script type="text/javascript">
<!--
	//alert(opener.document.sfrm.action);
	//부모창 새로고침
	var f = opener.document.sfrm;
	opener.document.sfrm.action = "";
	opener.document.sfrm.submit();
	document.location.href = '<%=GO_URL%>';
	alert('<%=DBFINISH%>');

//-->
</script>

<%
		Case "ERROR"	: Call ALERTS(DBERROR,"BACK","")
		Case Else		: Call ALERTS(DBUNDEFINED,"BACK","")
	End Select


%>


</body>
</html>