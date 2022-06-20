<%

	ADMIN_LANG = Request.form("ADMIN_LANG")

	If ADMIN_LANG = "" Then
		Response.Write "NO SELECT LANGUAGE"
	Else
		SESSION("ADMIN_LANG") = ADMIN_LANG
		Response.Write "OK"
	End If



%>