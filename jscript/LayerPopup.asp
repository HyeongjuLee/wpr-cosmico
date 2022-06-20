<%
'Top 레이어팝업
	SQL = "SELECT TOP(1) * FROM [DK_POPUP] WITH(NOLOCK) WHERE [popKind] = 'T' AND [useTF] = 'T' AND [isViewCom] = 'T' AND [strNation] = '"&Lang&"' ORDER BY [intIDX] DESC "
	Set DKRS = Db.execRs(SQL,DB_TEXT,Nothing,Nothing)
	If Not DKRS.BOF And Not DKRS.EOF Then
		popTitle	 = DKRS("popTitle")
		linkType	 = DKRS("linkType")
		linkUrl		 = DKRS("linkUrl")
		strScontent	 = DKRS("strScontent")
	Else
		popTitle	 = ""
	End If
	Call CloseRS(DKRS)

	Select Case linkType
		Case "S" : targets = " target=""_self"""
		Case "B" : targets = " target=""_blank"""
	End Select
%>