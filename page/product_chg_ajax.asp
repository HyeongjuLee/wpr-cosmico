<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"



	Dim MODE1, MODE2
		MODE1 = Request.Form("MODE1")
		MODE2 = Request.Form("MODE2")


	If MODE1 = "01" Then
		Select Case MODE2
			Case "01" : PRINT viewImg(IMG_CONTENT&"/product_01_01.jpg",780,500,"")
			Case "02" : PRINT viewImg(IMG_CONTENT&"/ready.jpg",780,600,"")
			Case "03" : PRINT viewImg(IMG_CONTENT&"/ready.jpg",780,600,"")
			Case "04" : PRINT viewImg(IMG_CONTENT&"/ready.jpg",780,600,"")
			Case "05" : PRINT viewImg(IMG_CONTENT&"/ready.jpg",780,600,"")
		End Select
	End If


	If MODE1 = "02" Then
		Select Case MODE2
			Case "01" : PRINT viewImg(IMG_CONTENT&"/product_02_01.jpg",780,500,"")
			Case "02" : PRINT viewImg(IMG_CONTENT&"/product_02_02.jpg",780,500,"")
			Case "03" : PRINT viewImg(IMG_CONTENT&"/product_02_03.jpg",780,500,"")
			Case "04" : PRINT viewImg(IMG_CONTENT&"/product_02_04.jpg",780,500,"")
			Case "05" : PRINT viewImg(IMG_CONTENT&"/product_02_05.jpg",780,500,"")
		End Select
	End If

	If MODE1 = "03" Then
		Select Case MODE2
			Case "01" : PRINT viewImg(IMG_CONTENT&"/product_03_01.jpg",780,500,"")
		End Select
	End If

	If MODE1 = "04" Then
		Select Case MODE2
			Case "01" : PRINT viewImg(IMG_CONTENT&"/product_04_01.jpg",780,500,"")
			Case "02" : PRINT viewImg(IMG_CONTENT&"/product_04_02.jpg",780,500,"")
		End Select
	End If

	If MODE1 = "05" Then
		Select Case MODE2
			Case "01" : PRINT viewImg(IMG_CONTENT&"/product_05_01.jpg",780,500,"")
			Case "02" : PRINT viewImg(IMG_CONTENT&"/product_05_02.jpg",780,500,"")
			Case "03" : PRINT viewImg(IMG_CONTENT&"/product_05_03.jpg",780,500,"")
			Case "04" : PRINT viewImg(IMG_CONTENT&"/product_05_04.jpg",780,500,"")
			Case "05" : PRINT viewImg(IMG_CONTENT&"/product_05_05.jpg",780,500,"")
		End Select
	End If

	If MODE1 = "06" Then
		Select Case MODE2
			Case "01" : PRINT viewImg(IMG_CONTENT&"/product_06_01.jpg",780,1000,"")
			Case "02" : PRINT viewImg(IMG_CONTENT&"/product_06_02.jpg",780,800,"")
		End Select
	End If

	If MODE1 = "07" Then
		Select Case MODE2
			Case "01" : PRINT viewImg(IMG_CONTENT&"/product_01_01.jpg",780,600,"")
			Case "02" : PRINT viewImg(IMG_CONTENT&"/product_01_02.jpg",780,600,"")
			Case "03" : PRINT viewImg(IMG_CONTENT&"/product_01_03.jpg",780,600,"")
			Case "04" : PRINT viewImg(IMG_CONTENT&"/product_01_04.jpg",780,600,"")
			Case "05" : PRINT viewImg(IMG_CONTENT&"/product_01_05.jpg",780,600,"")
		End Select
	End If

	If MODE1 = "08" Then
		Select Case MODE2
			Case "01" : PRINT viewImg(IMG_CONTENT&"/product_01_01.jpg",780,600,"")
			Case "02" : PRINT viewImg(IMG_CONTENT&"/product_01_02.jpg",780,600,"")
			Case "03" : PRINT viewImg(IMG_CONTENT&"/product_01_03.jpg",780,600,"")
			Case "04" : PRINT viewImg(IMG_CONTENT&"/product_01_04.jpg",780,600,"")
			Case "05" : PRINT viewImg(IMG_CONTENT&"/product_01_05.jpg",780,600,"")
		End Select
	End If

%>