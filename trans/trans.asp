<!--#include virtual = "/_lib/strFunc.asp"-->
<%
'한글 깨짐방지
'	Option Explicit


	'Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Expires","-1"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "cache-control", "no-store"


	'▣ 파일명 받아오기 S
		filename = Request("filename")
		path	 = Request("path")
		Encrypter = "T"

		'Call ResRW(filename,"filename1")
		'Call ResRW(path,"path1")
	'▣ 파일명 받아오기 E

	'◆ Tabs 파일다운로드 체크 (파일명복호화, 파일명, 경로데이터, 다운로드 가능 체크) 2021-12-03
		Call FN_chkFileTabsDownload(fileName, path, Encrypter)
		Response.End

%>
