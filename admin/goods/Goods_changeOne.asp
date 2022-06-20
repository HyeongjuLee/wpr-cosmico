<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	intIDX = Trim(gRequestTF("idx",True))
	types = Trim(gRequestTF("types",True))


'	PRINT intIDX
'	PRINT types

	If intIDX = "" Or IsNull(intIDX) Then Call alerts_c("상품고유값이 불분명합니다.","p_reload")

	Select Case types
		Case "flagBest","flagNew","FlagVote","flagMain","GoodsViewTF","GoodsStockType","flagEvent"
			MODE = UCase(types)
		Case Else
			Call ALRETS("타입이 불분명합니다.","p_reloadA","")
	End Select
	print types


	SUBSQL1 = "SELECT ["&types&"] FROM [DK_GOODS] WHERE [intIDX] = ?"
	arrParams1 = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX) _
	)
	THISVALUE = Db.execRsData(SUBSQL1,DB_TEXT,arrParams1,Nothing)

'thisvalue = "T"




'print "aa"
	SQL = ""
	SQL = SQL & "BEGIN TRANSACTION;"
	Select Case THISVALUE
		Case "T"
			SUBSQL = "UPDATE [DK_GOODS] SET ["&types&"] = 'F' WHERE [intIDX] = ?;"
		Case "F"
			SUBSQL = "UPDATE [DK_GOODS] SET ["&types&"] = 'T' WHERE [intIDX] = ?;"
		Case "S","N"
			SUBSQL = "UPDATE [DK_GOODS] SET ["&types&"] = 'I' WHERE [intIDX] = ?;"
		Case "I"
			SUBSQL = "UPDATE [DK_GOODS] SET ["&types&"] = 'S' WHERE [intIDX] = ?;"
	End Select
	SQL = SQL & SUBSQL
	SQL = SQL & "IF @@ERROR = 0" &VBCrlf
	SQL = SQL & "	BEGIN" &VBCrlf
	SQL = SQL & "		COMMIT TRANSACTION" &VBCrlf
	SQL = SQL & "		SET ? = 'FINISH'" &VBCrlf
	SQL = SQL & "	END" &VBCrlf
	SQL = SQL & "ELSE" &VBCrlf
	SQL = SQL & "	BEGIN" &VBCrlf
	SQL = SQL & "		ROLLBACK TRANSACTION" &VBCrlf
	SQL = SQL & "	END" &VBCrlf
	PRINT SUBSQL

	arrParams3 = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX), _
		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)
	Call Db.exec(SQL,DB_TEXT,arrParams3,Nothing)
	OUTPUT_VALUE = arrParams3(UBound(arrParams3))(4)

	PRINT OUTPUT_VALUE


	If OUTPUT_VALUE = "FINISH" Then
		Call ALERTS("수정되었습니다.","p_reloadA","")
	Else
		Call ALERTS("변경프로세스중 문제가 발생하였습니다. 데이터 베이스를 롤백합니다.","p_reloadA","")
	End If






%>
