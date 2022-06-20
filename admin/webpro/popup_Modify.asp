<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<%


	THISMODE = gRequestTF("thisMode",True)

	THISVALUE = gRequestTF("thisValue",False)
	intIDX = gRequestTF("idx",True)

	Select Case THISMODE
		Case "edit"
			SQL = "UPDATE [DK_POPUP] SET [useTF] = ? WHERE [intIDX] = ?"
			arrParams = Array(_
				Db.makeParam("@useTF",adChar,adParamInput,1,THISVALUE),_
				Db.makeParam("@useTF",adInteger,adParamInput,0,intIDX)_
			)
		Case "del"
			SQL = "DELETE FROM [DK_POPUP] WHERE [intIDX] = ?"
			arrParams = Array(_
				Db.makeParam("@useTF",adInteger,adParamInput,0,intIDX)_
			)

	End Select

	Call Db.beginTrans(Nothing)
	Call Db.exec(SQL,DB_TEXT,arrParams,Nothing)
	Call Db.finishTrans(Nothing)

	If Err.Number = 0 Then
		Call ALERTS("정상적으로 처리되었습니다.","p_reloadA","")
	Else
		Call ALERTS("변경프로세스중 문제가 발생하였습니다. 데이터 베이스를 롤백합니다.","p_reloadA","")
	End If


%>
