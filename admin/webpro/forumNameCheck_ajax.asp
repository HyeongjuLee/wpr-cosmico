<!--#include virtual="/_lib/strFunc.asp"-->
<!--#include virtual = "/_lib/json2.asp"-->
<%



	strBoardName	 = pRequestTF_AJAX2("strBoardName",True)



	SQL = " SELECT COUNT([strBoardName]) FROM [DK_NBOARD_CONFIG]  WHERE [strBoardName] = ?"
	arrParams = Array(_
		Db.makeParam("@strID",adVarChar,adParamInput,50,strBoardName) _
	)
	intMemCnt = CInt(Db.execRsData(SQL,DB_TEXT,arrParams,Nothing))



	If Int(intMemCnt) = 0  Then
		Call ReturnAjaxMsg("SUCCESS","사용할 수 있는 게시판 이름입니다")
	Else
		Call ReturnAjaxMsg("FAIL","이미 있는 게시판 이름입니다. 다른 이름을 선택해주세요.")
	End If





%>