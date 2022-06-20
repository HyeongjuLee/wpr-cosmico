<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<%


	Call noCache



		MaxFileAbort = 150 * 1024 * 1024 ' 최대파일 크기 업로드 거부(각 파일 별 공통 사항 / 하단의 파일 업로드 사이즈중 가장 큰 값으로 설정)
		MaxDataSize1 = 10 * 1024 * 1024 ' 실제 썸네일의 업로드 시킬 파일 사이즈

		Set Upload = Server.CreateObject("TABSUpload4.Upload")
		Upload.MaxBytesToAbort = MaxFileAbort
		Upload.Start REAL_PATH("Temps")


		If Upload.Form("strThum") <> "" Then strImg = uploadImg("strThum",REAL_PATH("product"),REAL_PATH("product"),250,250) Else strThum = o_strThum End If


		OUTPUT_VALUE = "FINISH"


	Select Case OUTPUT_VALUE
		Case "FINISH": Call ALERTS("정상처리되었습니다..","go","product.asp")
		Case "ERROR" : Call ALERTS("업로드 중 문제가 발생하였습니다.팝업이 정상적으로 설정되지 않았습니다.","back","")
	End Select


%>
