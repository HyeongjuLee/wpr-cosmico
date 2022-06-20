<!--#include virtual = "/_lib/strFunc.asp"-->
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual="/admin/_inc/adminPath.asp" -->
<%End If%>
<%
	Call ONLY_MEMBER(DK_MEMBER_LEVEL)

	mode			 = pRequestTF("mode",True)






	Select Case mode
		Case "SCRAP"
			strBoardName	 = pRequestTF("strBoardName",True)
			bidx			 = pRequestTF("bidx",True)
			strSubject		 = pRequestTF("strSubject",True)
			strMemo			 = pRequestTF("strMemo",False)

			arrParams = Array(_
				Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID),_
				Db.makeParam("@BoardType",adChar,adParamInput,1,"C"),_
				Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName),_
				Db.makeParam("@strSubject",adVarChar,adParamInput,200,strSubject),_
				Db.makeParam("@bIDX",adInteger,adParamInput,0,bidx),_
				Db.makeParam("@strMemo",adVarChar,adParamInput,200,strMemo),_
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR")_
			)
			Call Db.exec("DKP_SCRAP_INSERT",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

			Select Case OUTPUT_VALUE
				Case "ERROR" : Call ALERTS("데이터 저장 중 오류가 발생하였습니다","back","")
				Case "FINISH" : Call ALERTS("스크랩 되었습니다. 마이페이지에서 확인 가능합니다.","close","")
			End Select
	End Select




%>
