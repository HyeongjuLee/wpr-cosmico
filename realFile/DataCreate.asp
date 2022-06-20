<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_lib/md5.asp"-->
<%
'한글 깨짐방지
'	Option Explicit


	Function random_strs(strDigit)
		Dim strT, strlen, r, i, ds, serialCode
		strT = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		strlen = Len(strT)

		Randomize
		For i = 1 To strDigit
			r = Int((strlen - 1 + 1) * Rnd + 1)
			serialCode = serialCode + Mid(strT,r,1)
		Next
		random_strs = serialCode
	End Function

	RText = random_strs(20)


	Set XTEncrypt = new XTclsEncrypt


	Call ResRW(Recordtime,"Recordtime")
	Call ResRW(RText,"RText")


	Text1 = XTEncrypt.MD5(XTEncrypt.SHA256(Recordtime))
	Text2 = XTEncrypt.MD5(XTEncrypt.SHA256(RText))

	Call ResRW(Text1,"Text1")
	Call ResRW(Text2,"Text2")
	Call ResRW(Text1&Text2,"DownloadKey")



'response.write ) & "<br>"


'strText = "superxt"
'response.write XTEncrypt.MD5(strText) & "<br>"
'response.write XTEncrypt.SHA256(strText) & "<br>"
'response.write XTEncrypt.SHA256(XTEncrypt.MD5(strText)) & "<br>"
'response.write XTEncrypt.MD5(XTEncrypt.SHA256(strText)) & "<br>"
'Set XTEncrypt = nothing
%>
