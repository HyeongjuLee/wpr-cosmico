<%@ CodePage="65001" Language="VBScript"%>
<%
	Session.CodePage = 65001
	Response.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Expires","0"
	'쿠키 미 사용시
		Response.AddHeader "Pragma","no-cache"
	'쿠키 사용시
		'Response.AddHeader "Pragma", "private"
		'Response.AddHeader "Cache-Control", "private, must-revalidate"

	'Response.AddHeader "Set-Cookie", "cookie_name=cookie_value;	SameSite=None;"

%>
<!--#include virtual = "/_lib/strText.asp"-->
<!--#include virtual = "/_lib/strFuncPath.asp"-->
<!--#include virtual = "/_lib/mem_auth.asp"-->
<!--#include virtual = "/_lib/DBclass.asp"-->
<!--#include virtual = "/_lib/strCheck.asp"-->
<!--#include virtual = "/_lib/strFuncData.asp"-->
<!--#include virtual = "/_lib/strFuncFile.asp"-->
<!--#include virtual = "/_lib/strFuncSite.asp"-->
<!--#include virtual = "/_lib/strPGDefault.asp"-->
<!--#include virtual = "/_lib/JSON_2.0.4.asp"-->
<!--#include virtual = "/_lib/strFuncADD.asp"-->
<!--#include virtual = "/_lib/strFuncMessage.asp"-->
<%

' *****************************************************************************
' Function Name : ReadFromTextFile
' *****************************************************************************
	Function ReadFromTextFile (FileUrl,CharSet)
		Dim Str
		Set stm = server.CreateObject("adodb.stream")
		stm.Type=2 'for text type
		stm.mode=3
		stm.charset=CharSet
		stm.open
		stm.loadfromfile Server.MapPath(FileUrl)
		Str = stm.readtext
		' response.write str
		stm.Close
		Set stm = Nothing
		ReadFromTextFile = Str
	End Function
' *****************************************************************************

' *****************************************************************************
' Function Name : ResRW,
' Discription : Response.Write 쓰기 귀찮아서 만듬
' *****************************************************************************
	Function ResRW(ByVal keys, ByVal Name)
		If webproIP="T" Then
			If Name = Null Or Name = "" Then
			Response.Write keys & "<br />"
			Else
			'Response.Write Name & " : " & keys & "<br />"
			Response.Write Name & " : <span style=""color:blue"">" & keys & "</span><br />"
			End If
		End If
	End Function

	Function ResRW2(ByVal keys, ByVal Name)
		If webproIP="T" Then
			If Name = Null Or Name = "" Then
			Response.Write keys & "<br />"
			Else
			'Response.Write Name & " : " & keys & "<br />"
			Response.Write Name & " : <span style=""color:blue"">" & keys & "</span><hr />"
			End If
		End If
	End Function

	Function PRINT(ByVal value)
		Response.Write value & VbCrLf
	End Function

	Function PRINTS(ByVal value)
		Response.Write value
	End Function

	Function Tabs(ByVal nums)
		value = ""
		num = checkNumeric(nums)
		num = num + 1
		For loops = 1 To nums
			value = value & VbTab
		Next
		Tabs = value
	End Function
' *****************************************************************************



	' *****************************************************************************
	' Function Name : DomainAlert,DomainAlertP
	' Discription : 도메인 틀릴 시 경고 및 도메인 이동 (P는 페이지요청용)
	' *****************************************************************************
		Function DomainAlert(loginMode,portalDomain)
			Dim jsAlert
			jsAlert = "<script type='text/javascript'>" & VbCrLf
			Select Case loginMode
				Case "pop"
					'jsAlert = jsAlert & "	alert('로그인을 시도한 도메인과 가입 도메인이 틀립니다. 가입 도메인으로 이동합니다.\n\n(보안을 위해 도메인 간 로그인 정보를 공유하지 않습니다. 재 로그인 해주세요)');" & VbCrLf
					jsAlert = jsAlert & "	alert('"&LNG_STRFUNC_TEXT01&"\n\n"&LNG_STRFUNC_TEXT02&"');" & VbCrLf
					jsAlert = jsAlert & "	opener.location.href='"&portalDomain&"';" & VbCr
					jsAlert = jsAlert & "	opener.focus();" & VbCrLf
					jsAlert = jsAlert & "	self.close();" & VbCrLf
				Case "page"
					'jsAlert = jsAlert & "	alert('로그인을 시도한 도메인과 가입 도메인이 틀립니다. 가입 도메인으로 이동합니다.\n\n(보안을 위해 도메인 간 로그인 정보를 공유하지 않습니다. 재 로그인 해주세요)');" & VbCrLf
					jsAlert = jsAlert & "	alert('"&LNG_STRFUNC_TEXT01&"\n\n"&LNG_STRFUNC_TEXT02&"');" & VbCrLf
					jsAlert = jsAlert & "	location.href=""" & portalDomain & """;" & vbCrLf
			End Select
			jsAlert = jsAlert & "</script>" & VbCrLf
			response.write jsAlert
			response.End
		End Function

		Function DomainAlertH(loginMode,portalDomain)
			Dim jsAlert
			jsAlert = "<script type='text/javascript'>" & VbCrLf
			Select Case loginMode
				Case "pop"
					'jsAlert = jsAlert & "	alert('분양회원입니다. 분양된 도메인으로 이동합니다.\n\n(보안을 위해 도메인 간 로그인 정보를 공유하지 않습니다. 재 로그인 해주세요)');" & VbCrLf
					jsAlert = jsAlert & "	alert('"&LNG_STRFUNC_TEXT03&"\n\n"&LNG_STRFUNC_TEXT02&"');" & VbCrLf
					jsAlert = jsAlert & "	opener.location.href='"&portalDomain&"';" & VbCr
					jsAlert = jsAlert & "	opener.focus();" & VbCrLf
					jsAlert = jsAlert & "	self.close();" & VbCrLf
				Case "page"
					jsAlert = jsAlert & "	alert('"&LNG_STRFUNC_TEXT03&"\n\n"&LNG_STRFUNC_TEXT02&"');" & VbCrLf
					jsAlert = jsAlert & "	location.href=""" & portalDomain & """;" & vbCrLf
			End Select
			jsAlert = jsAlert & "</script>" & VbCrLf
			response.write jsAlert
			response.End
		End Function



		Function DomainAlertP(portalDomain)
			Dim jsAlert
			jsAlert = "<script type='text/javascript'>" & VbCrLf
			'jsAlert = jsAlert & "	alert('요청하신 페이지와 회원님의 가입 도메인이 틀립니다. 가입 도메인으로 이동합니다1.\n\n(보안을 위해 도메인 간 로그인 정보를 공유하지 않습니다.\n\n로그아웃 상태인 경우 로그인을 다시 해주세요)');" & VbCrLf
			jsAlert = jsAlert & "	alert('"&LNG_STRFUNC_TEXT04&"\n\n"&LNG_STRFUNC_TEXT05&"');" & VbCrLf
			jsAlert = jsAlert & "	location.href=""" & portalDomain & """;" & vbCrLf
			jsAlert = jsAlert & "</script>" & VbCrLf
			response.write jsAlert
			response.End
		End Function
	' *****************************************************************************
	' Function Name : alerts
	' Discription : 자바스크립트 경고창
	' *****************************************************************************
		Function ALERTS(alertMsg,method,linked)
			Dim jsAlert
			jsAlert = "<script type='text/javascript'>" & VbCrLf
			Select Case LCase(method)
				Case "back"
					jsAlert = jsAlert & "	alert(""" & alertMsg & """);" & VbCrLf
					jsAlert = jsAlert & "	history.back(-1);" & VbCrLf
				Case "go"
					jsAlert = jsAlert & "	alert(""" & alertMsg & """);" & VbCrLf
					jsAlert = jsAlert & "	location.href=""" & linked & """;" & vbCrLf
				'팝업 로그인
				Case "login"
					jsAlert = jsAlert & "	alert(""" & alertMsg & """);" & VbCrLf
					jsAlert = jsAlert & "	popLogin();" & VbCrLf
				Case "login2"
					jsAlert = jsAlert & "	alert(""" & alertMsg & """);" & VbCrLf
					jsAlert = jsAlert & "	popLogin();" & VbCrLf
					jsAlert = jsAlert & "	history.back(-1);" & VbCrLf
'					jsAlert = jsAlert & "	location.href='/page/business.asp?view=2&sview=1';" & VbCrLf


				Case "login3"
					jsAlert = jsAlert & "	alert(""" & alertMsg & """);" & VbCrLf
					jsAlert = jsAlert & "	popLogin2();" & VbCrLf
					jsAlert = jsAlert & "	history.back(-1);" & VbCrLf

				Case "silentgo"
					jsAlert = jsAlert & "	location.href=""" & linked & """;" & vbCrLf
				Case "close"
					jsAlert = jsAlert & "	alert(""" & alertMsg & """);" & VbCrLf
					jsAlert = jsAlert & "	self.close();" & VbCrLf
				Case "closepop"
					jsAlert = jsAlert & "	alert(""" & alertMsg & """);" & VbCrLf
					jsAlert = jsAlert & "	window.open('about:blank', '_self');" & VbCrLf
					jsAlert = jsAlert & "	opener=window;;" & VbCrLf
					jsAlert = jsAlert & "	window.close();" & VbCrLf
				Case "p_reload"
					jsAlert = jsAlert & "	parent.location.reload();" & VbCrLf
					jsAlert = jsAlert & "	parent.focus();" & VbCrLf
					jsAlert = jsAlert & "	location.href='/hiddens.asp';" & VbCrLf
				Case "p_reloada"
					jsAlert = jsAlert & "	alert(""" & alertMsg & """);" & VbCrLf
					jsAlert = jsAlert & "	parent.location.reload();" & VbCrLf
					jsAlert = jsAlert & "	parent.focus();" & VbCrLf
					jsAlert = jsAlert & "	location.href='/hiddens.asp';" & VbCr
				Case "o_relaod"
					jsAlert = jsAlert & "	opener.location.reload();" & VbCrLf
					jsAlert = jsAlert & "	opener.focus();" & VbCrLf
					jsAlert = jsAlert & "	self.close();" & VbCrLf
				Case "o_reloada"
					jsAlert = jsAlert & "	alert(""" & alertMsg & """);" & VbCrLf
					jsAlert = jsAlert & "	opener.location.reload();" & VbCrLf
					jsAlert = jsAlert & "	opener.focus();" & VbCrLf
					jsAlert = jsAlert & "	self.close();" & VbCrLf
				Case "o_relaodb"
					jsAlert = jsAlert & "	opener.location.href='"&alertMsg&"';" & VbCr
					jsAlert = jsAlert & "	opener.focus();" & VbCrLf
					jsAlert = jsAlert & "	self.close();" & VbCrLf
				Case "o_reload_go"
					jsAlert = jsAlert & "	alert(""" & alertMsg & """);" & VbCrLf
					jsAlert = jsAlert & "	self.close();" & VbCrLf
					jsAlert = jsAlert & "	opener.location.href=""" & linked & """;" & vbCrLf
				Case "close_p_modal"
					jsAlert = jsAlert & "	alert(""" & alertMsg & """);" & VbCrLf
					jsAlert = jsAlert & "	parent.$('#modal_view').dialog('close');" & VbCrLf

			End Select

			jsAlert = jsAlert & "</script>" & VbCrLf
			response.write jsAlert
			response.End
		End Function


		Function CONFIRM(alertMsg,method,linked1,linked2)
'		Function CONFIRM(alertMsg,method,linked1)
			Dim jsAlert
			jsAlert = "<script type='text/javascript'>" & VbCrLf
			Select Case LCase(method)
				Case "close"
					jsAlert = jsAlert & "	if (confirm("""&alertMsg&""")) {"
					jsAlert = jsAlert & "		location.href="""&linked1&""";"
					jsAlert = jsAlert & "	} else {"
					jsAlert = jsAlert & "		self.close();"
					jsAlert = jsAlert & "	}" & VbCrLf
				'팝업로그인(CS 사업자회원)
				Case "login2"
					jsAlert = jsAlert & "	if (confirm("""&alertMsg&""")) {"
					jsAlert = jsAlert & "	popLogin();" & VbCrLf
					jsAlert = jsAlert & "	history.back(-1);" & VbCrLf
					jsAlert = jsAlert & "	} else {"
					jsAlert = jsAlert & "	history.back(-1);" & VbCrLf
					jsAlert = jsAlert & "	}" & VbCrLf

				Case "go_back"
					jsAlert = jsAlert & "	if (confirm("""&alertMsg&""")) {"
					jsAlert = jsAlert & "		location.href="""&linked1&""";"
					jsAlert = jsAlert & "	} else {"
					jsAlert = jsAlert & "		history.back();"
					jsAlert = jsAlert & "	}" & VbCrLf

				Case "go_select"
					jsAlert = jsAlert & "	if (confirm("""&alertMsg&""")) {"
					jsAlert = jsAlert & "		location.href="""&linked1&""";"
					jsAlert = jsAlert & "	} else {"
					jsAlert = jsAlert & "		location.href="""&linked2&""";"
					jsAlert = jsAlert & "	}" & VbCrLf

			End Select

			jsAlert = jsAlert & "</script>" & VbCrLf
			response.write jsAlert
			response.End
		End Function


	' *****************************************************************************
	' Function Name : gotoUrl
	' Discription : 페이지 이동
	' *****************************************************************************
		Sub gotoUrl(ByVal linked)
			Dim jsAlert
			linked = Replace(linked, "'", "\'")
			jsAlert = "<script type='text/javascript'><!--" & VbCrLf
			jsAlert = jsAlert & "		var url = '" & linked & "';" & vbCrLf
			jsAlert = jsAlert & "		location.href=url;" & vbCrLf

			jsAlert = jsAlert & "//--></script>" & VbCrLf
			response.write jsAlert

			If Not Db Is Nothing Then Set Db = Nothing
			Response.End
		End Sub

	' *****************************************************************************
	' Function Name : gRequestTF
	' Discription : 리퀘스트 값 코드 변환 (필수값 체크 추가)
	' *****************************************************************************
		Function gRequestTF(ByVal key, ByVal TFs)
			Dim value
				value = Request.QueryString(key)
			If TFs = False Then
				If value = "" Or value = Null Then
					gRequestTF = ""
				Else
					value = convSql(value)
					gRequestTF = Trim(value)
				End If
			ElseIf TFs = True Then
				If value = "" Or value = Null Then
					Call alerts("필수값이 없습니다."&key,"back","")
					Response.End
				Else
					value = convSql(value)
					gRequestTF = Trim(value)
				End If
			End If
		End Function

	' *****************************************************************************
	' Function Name : RequestLoopCheck
	' Discription : 리퀘스트 반복 설정 체크
	' *****************************************************************************
		Function RequestLoopCheck(ByVal Base, ByVal TFs)
			For i = 1 To Request.Form(base).count
				If TFs Then
					If Trim(Request.Form(base)(i)) = "" Then
						Call ALERTS(i&"번째 "&"["&Base&"]의 항목 값은 필수값입니다","back","")
					End If
				End If
			Next
		End Function


	' *****************************************************************************
	' Function Name : pRequestTF
	' Discription : 리퀘스트 값 코드 변환 (필수값 체크 추가)
	' *****************************************************************************
		Function pRequestTF(ByVal key, ByVal TFs)
			Dim value
				value = Request.Form(key)
			If TFs = False Then
				If value = "" Or IsNull(value) Then
					values = ""
				Else
					value = convSql(value)
					values = value
				End If
			ElseIf TFs = True Then
				If value = "" Or IsNull(value) Then
					'Call alerts("필수값이 없습니다."&key,"back","")
					Call alerts(LNG_STRFUNC_TEXT06&key,"back","")
					Response.End
				Else
					value = convSql(value)
					values = value
				End If
			End If
			pRequestTF = Trim(values)
		End Function

		Function pRequestTF_AJAX(ByVal key, ByVal TFs)
			Dim value
				value = Request.Form(key)
			If TFs = False Then
				If value = "" Or IsNull(value) Then
					values = ""
				Else
					value = convSql(value)
					values = value
				End If
			ElseIf TFs = True Then
				If value = "" Or IsNull(value) Then
					PRINT "FORMERROR,"&key
					Response.End
				Else
					value = convSql(value)
					values = value
				End If
			End If
			pRequestTF_AJAX = values
		End Function

		Function pRequestTF_AJAX2(ByVal key, ByVal TFs)
			Dim value
				value = Request.Form(key)
			If TFs = False Then
				If value = "" Or IsNull(value) Then
					values = ""
				Else
					value = convSql(value)
					values = value
				End If
			ElseIf TFs = True Then
				If value = "" Or IsNull(value) Then
					Call ReturnAjaxMsg("FAIL", key&"값이 누락되었습니다.")
				Else
					value = convSql(value)
					values = value
				End If
			End If
			pRequestTF_AJAX2 = values
		End Function


		'Autoship
		Function pRequestTF_JSON(ByVal key, ByVal TFs)
			Dim value
				value = Request.Form(key)
			If TFs = False Then
				If value = "" Or IsNull(value) Then
					values = ""
				Else
					'value = convSql(value)
					values = value
				End If
			ElseIf TFs = True Then
				If value = "" Or IsNull(value) Then
					'PRINT "[{""codes"":""FORMERROR"",""datas"":""필수값 \"""&Key&"\"" (이)가 없습니다.""}]"
					PRINT "{""result"":""error"",""message"":"""&LNG_STRFUNC_TEXT07&"\"""&Key&"\"" ""}"
					Response.End
				Else
					'value = convSql(value)
					values = value
				End If
			End If
			pRequestTF_JSON = values
		End Function

	' *****************************************************************************

		Function pRequestTF_JSON2(ByVal key, ByVal TFs)
			Dim value
				value = Request.Form(key)
			If TFs = False Then
				If value = "" Or IsNull(value) Then
					values = ""
				Else
					value = convSql(value)
					values = value
				End If
			ElseIf TFs = True Then
				If value = "" Or IsNull(value) Then
					PRINT "{""statusCode"":""9900"",""message"":""No Value of \"""&Key&"\"" "",""result"":""""}"
					Response.End
				Else
					value = convSql(value)
					values = value
				End If
			End If
			pRequestTF_JSON2 = values
		End Function
	' *****************************************************************************
	' Function Name : pRequestTF2 (API용도)
	' Discription : 리퀘스트 값 코드 변환 (필수값 체크 추가)
	' *****************************************************************************
		Function pRequestTF2(ByVal key, ByVal TFs)
			Dim value
				value = Trim(Request.Form(key))
			If TFs = False Then
				If value = "" Or IsNull(value) Then
					values = ""
				Else
					value = convSql(value)
					values = value
				End If
			ElseIf TFs = True Then
				If value = "" Or IsNull(value) Then
					'Call alerts("필수값이 없습니다."&key,"back","")
					Response.Write "{""statusCode"":""9977"",""message"":"""&server.urlencode("필수값이 전송되지 않았습니다. 필수값 :"&key)&""",""result"":""""}"
					Response.End
				Else
					value = convSql(value)
					values = value
				End If
			End If
			pRequestTF2 = values
		End Function

	' *****************************************************************************




	' *****************************************************************************
	' Function Name		: reSizeImg
	' Discription		: 이미지 리사이징(큰 파일을 뿌릴때 과부하 걸릴 수 있음)
	' *****************************************************************************
		Function reSizeImg(ByVal ImgPath, ByRef ImgWidth, ByRef ImgHeight, ByVal ImgMaxWidth, ByVal ImgMaxHeight)
			ImgWidth = 0
			ImgHeight = 0
			target = Server.MapPath("/")&ImgPath

			Dim Image, Status
			Set Image = Server.CreateObject("TABSUpload4.Image")
			Status = Image.Load(target)
			If Status = Ok Then
				ImgWidth = Image.Width
				ImgHeight = Image.Height
				Image.Close
				If ImgWidth > ImgMaxWidth Then
					ImgHeight = (ImgHeight / ImgWidth) * ImgMaxWidth
					ImgWidth = ImgMaxWidth
				End If
				If ImgHeight > ImgMaxHeight Then
					ImgWidth = (ImgWidth / ImgHeight) * ImgMaxHeight
					ImgHeight = ImgMaxHeight
				End If
			Else
				'PRINT("지정한 이미지를 열 수 없습니다. 오류 코드는 "&status&"입니다.")
				PRINT(LNG_STRFUNC_TEXT08 &status&"입니다.")
			End If
		End Function

	' *****************************************************************************
	' Function Name		: ImgInfo
	' Discription		: 이미지 가로세로 정보 받아오기
	' *****************************************************************************
		Function ImgInfo(ByVal ImgPath, ByRef ImgWidth, ByRef ImgHeight, ByRef ImgErrors)
			ImgWidth = 0
			ImgHeight = 0
			target = Server.MapPath("/")&ImgPath
			'PRINT target
			Dim Image, Status
			Set Image = Server.CreateObject("TABSUpload4.Image")
			Status = Image.Load(target)
			If Status = Ok Then
				ImgWidth = Image.Width
				ImgHeight = Image.Height
				ImgErrors = "T"
			Else
				'ImgErrors = ("지정한 이미지를 열 수 없습니다. 오류 코드는 "&status&"입니다.")
				ImgErrors = (LNG_STRFUNC_TEXT08 &status&"입니다.")
			End If
		End Function
	' *****************************************************************************
	' Function Name		: ImgInfoNew
	' Discription		: 이미지 가로세로 정보 받아오기 + 기준길이에 맞게 리사이징
	' *****************************************************************************
		Function ImgInfoNew(ByVal ImgPath, ByRef newimgWidth, ByRef newimgHeight, ByRef ImgErrors, ByRef NEW_LENGTH)
			ImgWidth = 0
			ImgHeight = 0

			target = Server.MapPath("/")&ImgPath
			'PRINT target
			Dim Image, Status
			Set Image = Server.CreateObject("TABSUpload4.Image")
			Status = Image.Load(target)
			If Status = Ok Then
				ImgWidth = Image.Width
				ImgHeight = Image.Height
				ImgErrors = "T"

				If imgWidth > NEW_LENGTH Or imgHeight > NEW_LENGTH Then
					If imgHeight > imgWidth Then
						newimgHeight = NEW_LENGTH
						newimgWidth	 = newimgHeight * (imgWidth/imgHeight)
					ElseIf imgHeight < imgWidth Then
						newimgWidth = NEW_LENGTH
						newimgHeight = newimgWidth  * (imgHeight/imgWidth)
					ElseIf imgHeight = imgWidth Then
						newimgWidth	 = NEW_LENGTH
						newimgHeight = NEW_LENGTH
					End if
				Else
					newimgWidth   = imgWidth
					newimgHeight  = imgHeight
				End If

			Else
				ImgErrors = (LNG_STRFUNC_TEXT08 &status&"입니다.")
			End If
		End Function
	' *****************************************************************************
	' Function Name		: imgResizeView
	' Discription		: 이미지 가로세로 리사이즈 처리 뿌리기
	' *****************************************************************************
		Function imgResizeView(ByRef ReWidth, ByRef ReHeight, ByVal imgWidth, ByVal imgHeight)
			Dim rateX : rateX = 0
			Dim rateY : rateY = 0

			If Not IsNumeric(ReWidth) Then ReWidth = 0
			If Not IsNumeric(ReHeight) Then ReHeight = 0

			If ReWidth > 0 Then rateX = imgWidth / ReWidth
			If ReHeight > 0 Then rateY = imgHeight / ReHeight

			If rateX > rateY Then rate = rateX Else rate = rateY
			If rate < 1 Then rate = 1

			ReWidth = Int(imgWidth / rate)
			ReHeight = Int(imgHeight / rate)

		End Function

	' *****************************************************************************
	' Function Name		: ImgInfo
	' Discription		: 페이지 카운트 서브 함수
	' *****************************************************************************
		Sub pageListn(ByVal page, ByVal total_page,ByVal idname)
			Dim page_len, pre_page, pre_part, next_part
			Dim strPageList,page_name
			If page > 10 Then
				pre_page = Left(page,Len(page)-1)
				If (page Mod 10) = 0 Then pre_page = CCur(pre_page) - 1
			End If
			If pre_page = "" Then
				pre_part  = 0
				next_part = 11
			Else
				pre_part   = ( pre_page - 1 ) * 10 + 1
				next_part  = ( pre_page + 1 ) * 10 + 1
			End If

			If next_part > total_page Then next_part = 0
			strPageList = ""
			strPageList = strPageList & "<div id="""&idname&""">"
			If pre_part <> 0 Then strPageList = strPageList & "<span class=""arrow left margin""><a href='javascript:pagegoto("&pre_part&")'><i class=""icon-angle-left""></i></a></span>"

			For i=1 To 10
				If pre_page = "" Then
					page_num = i
				Else
					page_num   = (pre_page * 10) + i
				End If

				If total_page < page_num Then Exit For
				If page_num = ccur(page) Then
					strPageList = strPageList & "<span class='currentPage'>" &page_num& "</span>"
				Else
					strPageList = strPageList & "<span><a href='javascript:pagegoto("&page_num&");'>" &page_num& "</a></span>"
				End If
			Next

			If next_part <> 0 Then strPageList = strPageList & "<span class=""arrow right margin""><a href='javascript:pagegoto("&next_part&")'><i class=""icon-angle-right""></i></a></span>"

			strPageList = strPageList & "</div>"
			If total_page <> 0 Then 	Response.Write strPageList



		End Sub
		Sub pageList(ByVal page, ByVal total_page)
			Dim page_len, pre_page, pre_part, next_part
			Dim strPageList,page_name
			If page > 10 Then
				pre_page = Left(page,Len(page)-1)
				If (page Mod 10) = 0 Then pre_page = CCur(pre_page) - 1
			End If
			If pre_page = "" Then
				pre_part  = 0
				next_part = 11
			Else
				pre_part   = ( pre_page - 1 ) * 10 + 1
				next_part  = ( pre_page + 1 ) * 10 + 1
			End If

			If next_part > total_page Then next_part = 0
			strPageList = ""

			If pre_part <> 0 Then strPageList = strPageList & "<span class='arrow left margin'><a href='javascript:pagegoto("&pre_part&")'><i class=""icon-angle-left""></i></a></span>"

			For i=1 To 10
				If pre_page = "" Then
					page_num = i
				Else
					page_num   = (pre_page * 10) + i
				End If

				If total_page < page_num Then Exit For
				If page_num = ccur(page) Then
					strPageList = strPageList & "<span class='currentPage'>" &page_num& "</span>"
				Else
					strPageList = strPageList & "<span><a href='javascript:pagegoto("&page_num&");'>" &page_num& "</a></span>"
				End If
			Next

			If next_part <> 0 Then strPageList = strPageList & "<span class='arrow right margin'><a href='javascript:pagegoto("&next_part&")'><i class=""icon-angle-right""></i></a></span>"


			If total_page <> 0 Then 	Response.Write strPageList




		End Sub

		Sub pageListNew(ByVal page, ByVal total_page)
			Dim page_len, pre_page, pre_part, next_part
			Dim strPageList,page_name
			If page > 10 Then
				pre_page = Left(page,Len(page)-1)
				If (page Mod 10) = 0 Then pre_page = CCur(pre_page) - 1
			End If
			If pre_page = "" Then
				pre_part  = 0
				next_part = 11
			Else
				pre_part   = ( pre_page - 1 ) * 10 + 1
				next_part  = ( pre_page + 1 ) * 10 + 1
			End If

			If next_part > total_page Then next_part = 0
			strPageList = ""


			If pre_part <> 0 Then strPageList = strPageList & "<span class=""arrow left""><a href='javascript:pagegoto(1)'><i class=""icon-angle-double-left""></i></a></span>"
			If pre_part <> 0 Then strPageList = strPageList & "<span class=""arrow left margin""><a href='javascript:pagegoto("&pre_part&")'><i class=""icon-angle-left""></i></a></span>"

			For i=1 To 10
				If pre_page = "" Then
					page_num = i
				Else
					page_num   = (pre_page * 10) + i
				End If

				If total_page < page_num Then Exit For

				If page_num = ccur(page) Then
					If page_num < 10 Then
						strPageList = strPageList & "<span class='currentPage' >" &page_num& "</span>"
					Else
						strPageList = strPageList & "<span class='currentPage'>" &page_num& "</span>"
					End If
				Else
					If page_num < 10 Then
						strPageList = strPageList & "<span><a href='javascript:pagegoto("&page_num&");' >" &page_num& "</a></span>"
					Else
						strPageList = strPageList & "<span><a href='javascript:pagegoto("&page_num&");'>" &page_num& "</a></span>"
					End If
				End If

			Next

			If next_part <> 0 Then strPageList = strPageList & "<span class=""arrow right margin""><a href='javascript:pagegoto("&next_part&")'><i class=""icon-angle-right""></i></a></span>"
			If next_part <> 0 Then strPageList = strPageList & "<span class=""arrow right""><a href='javascript:pagegoto("&total_page&")'><i class=""icon-angle-double-right""></i></a></span>"

			If total_page <> 0 Then 	Response.Write strPageList

		End Sub

		'상품페이징 Gray
		Sub pageListNew3(ByVal page, ByVal total_page)
			Dim page_len, pre_page, pre_part, next_part
			Dim strPageList,page_name
			If page > 10 Then
				pre_page = Left(page,Len(page)-1)
				If (page Mod 10) = 0 Then pre_page = CCur(pre_page) - 1
			End If
			If pre_page = "" Then
				pre_part  = 0
				next_part = 11
			Else
				pre_part   = ( pre_page - 1 ) * 10 + 1
				next_part  = ( pre_page + 1 ) * 10 + 1
			End If

			If next_part > total_page Then next_part = 0
			strPageList = ""


			If pre_part <> 0 Then strPageList = strPageList & "<span><a href='javascript:pagegoto(1)'><<</a></span>"
			If pre_part <> 0 Then strPageList = strPageList & "<span style=""padding-right:8px;""><a href='javascript:pagegoto("&pre_part&")'><</a></span>"

			For i=1 To 10
				If pre_page = "" Then
					page_num = i
				Else
					page_num   = (pre_page * 10) + i
				End If

				If total_page < page_num Then Exit For

				If page_num = ccur(page) Then
					If page_num < 10 Then
						strPageList = strPageList & "<span class='currentPage' style=''>" &page_num& "</span>"
					Else
						strPageList = strPageList & "<span class='currentPage'>" &page_num& "</span>"
					End If
				Else
					If page_num < 10 Then
						strPageList = strPageList & "<span><a href='javascript:pagegoto("&page_num&");' style=''>" &page_num& "</a></span>"
					Else
						strPageList = strPageList & "<span><a href='javascript:pagegoto("&page_num&");'>" &page_num& "</a></span>"
					End If
				End If

			Next

			If next_part <> 0 Then strPageList = strPageList & "<span style=""padding-left:8px;""><a href='javascript:pagegoto("&next_part&")'  >></a></span>"
			If next_part <> 0 Then strPageList = strPageList & "<span><a href='javascript:pagegoto("&total_page&")'>>></a></span>"

			If total_page <> 0 Then 	Response.Write strPageList

		End Sub


		' 상품 QNA 용 페이징
		Sub pageList1(ByVal page, ByVal total_page)
			Dim page_len, pre_page, pre_part, next_part
			Dim strPageList,page_name
			If page > 10 Then
				pre_page = Left(page,Len(page)-1)
				If (page Mod 10) = 0 Then pre_page = CCur(pre_page) - 1
			End If
			If pre_page = "" Then
				pre_part  = 0
				next_part = 11
			Else
				pre_part   = ( pre_page - 1 ) * 10 + 1
				next_part  = ( pre_page + 1 ) * 10 + 1
			End If

			If next_part > total_page Then next_part = 0
			strPageList = ""
			If pre_part <> 0 Then strPageList = strPageList & "<span class='pagers2'><a href='javascript:qnaPageGo("&pre_part&","&goodsIDX&")'>◀ 이전</a></span>"

			For i=1 To 10
				If pre_page = "" Then
					page_num = i
				Else
					page_num   = (pre_page * 10) + i
				End If

				If total_page < page_num Then Exit For
				If page_num = ccur(page) Then
					strPageList = strPageList & "<span class='pagers'>" &page_num& "</span>"
				Else
					strPageList = strPageList & "<span class='pagers'><a href='javascript:qnaPageGo("&page_num&","&goodsidx&");'>" &page_num& "</a></span>"
				End If
			Next

			If next_part <> 0 Then strPageList = strPageList & "<span class='pagers2'><a href='javascript:qnaPageGo("&next_part&","&goodsidx&")'>다음 ▶</a></span>"


			If total_page <> 0 Then 	Response.Write strPageList



		End Sub

		' 상품 ReView 용 페이징
		Sub pageList2(ByVal page, ByVal total_page)
			Dim page_len, pre_page, pre_part, next_part
			Dim strPageList,page_name
			If page > 10 Then
				pre_page = Left(page,Len(page)-1)
				If (page Mod 10) = 0 Then pre_page = CCur(pre_page) - 1
			End If
			If pre_page = "" Then
				pre_part  = 0
				next_part = 11
			Else
				pre_part   = ( pre_page - 1 ) * 10 + 1
				next_part  = ( pre_page + 1 ) * 10 + 1
			End If

			If next_part > total_page Then next_part = 0
			strPageList = ""
			If pre_part <> 0 Then strPageList = strPageList & "<span class='pagers2'><a href='javascript:ReviewPageGo("&pre_part&","&goodsIDX&")'>◀ 이전</a></span>"

			For i=1 To 10
				If pre_page = "" Then
					page_num = i
				Else
					page_num   = (pre_page * 10) + i
				End If

				If total_page < page_num Then Exit For
				If page_num = ccur(page) Then
					strPageList = strPageList & "<span class='pagers'>" &page_num& "</span>"
				Else
					strPageList = strPageList & "<span class='pagers'><a href='javascript:ReviewPageGo("&page_num&","&goodsIDX&");'>" &page_num& "</a></span>"
				End If
			Next

			If next_part <> 0 Then strPageList = strPageList & "<span class='pagers2'><a href='javascript:ReviewPageGo("&next_part&","&goodsIDX&")'>다음 ▶</a></span>"


			If total_page <> 0 Then 	Response.Write strPageList



		End Sub



	' *****************************************************************************
	' Function Name		: ImgInfo
	' Discription		: 페이지 카운트 서브 함수 모바일리스팅(5)
	' *****************************************************************************
		Sub pageListMob5(ByVal page, ByVal total_page)
			Dim page_len, pre_page, pre_part, next_part
			Dim strPageList,page_name
			If page > 5 Then

				pageFix  = Fix(page/5)						'소숫점이하제거
				pre_page = Left(pageFix,Len(pageFix))

				If (page Mod 5) = 0 Then pre_page = CCur(pre_page) - 1
			End If
			If pre_page = "" Then
				pre_part  = 0
				next_part = 6
			Else
				pre_part   = ( pre_page * 5 ) -	4
				next_part  = ( pre_page * 5 ) + 6
			End If

			If next_part > total_page Then next_part = 0
			strPageList = ""


			'If pre_part <> 0 Then strPageList = strPageList & "<span><a href='javascript:pagegoto(1)'><<</a></span>"
			If pre_part <> 0 Then strPageList = strPageList & "<span class='defalut'><a href='javascript:pagegoto("&pre_part&")'><</a></span>"

			For i=1 To 5
				If pre_page = "" Then
					page_num = i
				Else
					page_num   = (pre_page * 5) + i
				End If

				If total_page < page_num Then Exit For

				If page_num = ccur(page) Then
					If page_num < 10 Then
						strPageList = strPageList & "<span class='currentPage' >" &page_num& "</span>"
					ElseIf page_num >= 10 And page_num < 100 Then
						strPageList = strPageList & "<span class='currentPage' >" &page_num& "</span>"					'2자리숫자 넓이
					ElseIf page_num >= 100 Then
						strPageList = strPageList & "<span class='currentPage' >" &page_num& "</span>"	'3자리숫자 넓이
					End If
				Else
					If page_num < 10 Then
						strPageList = strPageList & "<span class='defalut'><a href='javascript:pagegoto("&page_num&");' >" &page_num& "</a></span>"
					ElseIf page_num >= 10 And page_num < 100 Then
						strPageList = strPageList & "<span class='defalut'><a href='javascript:pagegoto("&page_num&");' >" &page_num& "</a></span>"
					ElseIf page_num >= 100 Then
						strPageList = strPageList & "<span class='defalut'><a href='javascript:pagegoto("&page_num&");' >" &page_num& "</a></span>"
					End If
				End If

			Next

			If next_part <> 0 Then strPageList = strPageList & "<span class='defalut'><a href='javascript:pagegoto("&next_part&")'>></a></span>"

			If total_page <> 0 Then 	Response.Write strPageList

		End Sub

		Sub pageListMob5n(ByVal page, ByVal total_page)
			Dim page_len, pre_page, pre_part, next_part
			Dim strPageList,page_name
			If page > 5 Then

				pageFix  = Fix(page/5)						'소숫점이하제거
				pre_page = Left(pageFix,Len(pageFix))

				If (page Mod 5) = 0 Then pre_page = CCur(pre_page) - 1
			End If
			If pre_page = "" Then
				pre_part  = 0
				next_part = 6
			Else
				pre_part   = ( pre_page * 5 ) -	4
				next_part  = ( pre_page * 5 ) + 6
			End If

			If next_part > total_page Then next_part = 0
			strPageList = ""


			'If pre_part <> 0 Then strPageList = strPageList & "<span><a href='javascript:pagegoto(1)'><<</a></span>"
			If pre_part <> 0 Then strPageList = strPageList & "<span class='defalut'><a href='javascript:pagegoto("&pre_part&")'><</a></span>"

			For i=1 To 5
				If pre_page = "" Then
					page_num = i
				Else
					page_num   = (pre_page * 5) + i
				End If

				If total_page < page_num Then Exit For

				If page_num = ccur(page) Then
					If page_num < 10 Then
						strPageList = strPageList & "<span class='currentPage'>" &page_num& "</span>"
					ElseIf page_num >= 10 And page_num < 100 Then
						strPageList = strPageList & "<span class='currentPage num2'>" &page_num& "</span>"					'2자리숫자 넓이
					ElseIf page_num >= 100 Then
						strPageList = strPageList & "<span class='currentPage num3'>" &page_num& "</span>"	'3자리숫자 넓이
					End If
				Else
					If page_num < 10 Then
						strPageList = strPageList & "<span class='defalut'><a href='javascript:pagegoto("&page_num&");'>" &page_num& "</a></span>"
					ElseIf page_num >= 10 And page_num < 100 Then
						strPageList = strPageList & "<span class='defalut num2'><a href='javascript:pagegoto("&page_num&");'>" &page_num& "</a></span>"
					ElseIf page_num >= 100 Then
						strPageList = strPageList & "<span class='defalut num3'><a href='javascript:pagegoto("&page_num&");'>" &page_num& "</a></span>"
					End If
				End If

			Next

			If next_part <> 0 Then strPageList = strPageList & "<span class='defalut'><a href='javascript:pagegoto("&next_part&")'>></a></span>"
			'If next_part <> 0 Then strPageList = strPageList & "<span><a href='javascript:pagegoto("&total_page&")'>>></a></span>"

			If total_page <> 0 Then 	Response.Write strPageList

		End Sub


	' *****************************************************************************
	' Function Name		: pagingMobNew
	' Discription		: '모바일 페이징NEW ex) 2/10
	' *****************************************************************************
		Sub pagingMobNew(ByVal page, ByVal total_page)
			'board.js
			'function pagegoto(PG,recordcnt)
			'function pagegotoMove(PG,recordcnt)

			Dim page_len, pre_page, pre_part, next_part
			Dim strPageList,page_name

			If page > 10 Then
				pre_page = Left(page,Len(page)-1)
				If (page Mod 10) = 0 Then pre_page = CCur(pre_page) - 1
			End If
			If pre_page = "" Then
				pre_part  = 0
				next_part = 11
			Else
				pre_part   = ( pre_page - 1 ) * 10 + 1
				next_part  = ( pre_page + 1 ) * 10 + 1
			End If

			If next_part > total_page Then next_part = 0
			strPageList = ""

			If CDbl(page) > CDbl(1) Then
				strPageList = strPageList & "<div class=""page_number"">"
				strPageList = strPageList & "	<a href='javascript:pagegoto("&page-1&")'><i class=""left"" style=""""></i></a>"
			Else
				strPageList = strPageList & "<div class=""page_number"">"
				strPageList = strPageList & "	<a><i class=""left first""></i></a>"
			End If
			strPageList = strPageList & "		<span><em>"&page&"</em> / "&total_page&"</span>"

			If CDbl(page) < CDbl(total_page) Then
				strPageList = strPageList & "	<a href='javascript:pagegoto("&page+1&")'><i class=""right""></i></a>"
				strPageList = strPageList & "</div>"
			Else
				strPageList = strPageList & "	<a><i class=""right last""></i></a>"
				strPageList = strPageList & "</div>"
			End If

			If total_page <> 0 Then 	Response.Write strPageList
		End Sub
	' *****************************************************************************
	' Function Name		: pagingMobNewMOVE
	' Discription		: '모바일 페이징NEW ex) 2/10
	' *****************************************************************************
		Sub pagingMobNewMOVE(ByVal page, ByVal total_page)
			'board.js
			'function pagegotoMove(PG,recordcnt)

			Dim page_len, pre_page, pre_part, next_part
			Dim strPageList,page_name

			If page > 10 Then
				pre_page = Left(page,Len(page)-1)
				If (page Mod 10) = 0 Then pre_page = CCur(pre_page) - 1
			End If
			If pre_page = "" Then
				pre_part  = 0
				next_part = 11
			Else
				pre_part   = ( pre_page - 1 ) * 10 + 1
				next_part  = ( pre_page + 1 ) * 10 + 1
			End If

			If next_part > total_page Then next_part = 0
			strPageList = ""

			If CDbl(page) > CDbl(1) Then
				strPageList = strPageList & "<div class=""page_number"">"
				strPageList = strPageList & "	<a href='javascript:pagegotoMove("&page-1&")'><i class=""left"" style=""""></i></a>"
			Else
				strPageList = strPageList & "<div class=""page_number"">"
				strPageList = strPageList & "	<a><i class=""left first""></i></a>"
			End If
			strPageList = strPageList & "		<span><em>"&page&"</em> / "&total_page&"</span>"

			If CDbl(page) < CDbl(total_page) Then
				strPageList = strPageList & "	<a href='javascript:pagegotoMove("&page+1&")'><i class=""right""></i></a>"
				strPageList = strPageList & "</div>"
			Else
				strPageList = strPageList & "	<a><i class=""right last""></i></a>"
				strPageList = strPageList & "</div>"
			End If

			If total_page <> 0 Then 	Response.Write strPageList
		End Sub


	' *****************************************************************************
	'	Function name	: dateFormat
	'	Description		: 날짜/시간 형식 변환
	' *****************************************************************************
		Function dateFormat(ByVal pdate, ByVal format)
			Dim result : result = ""
			Dim myear, mmonth, mday, mhour, mminute, msecond

			If IsDate(pdate) Then
				If format = "yyyy-mm-dd" Then
					result = FormatDateTime(pdate, 2)
				Else
					myear = Year(pdate)
					mmonth = Month(pdate)
					mday = Day(pdate)
					mhour = Hour(pdate)
					mminute = Minute(pdate)
					msecond = Second(pdate)

					result = format

					If InStr(result, "yyyy") > 0 Then result = Replace(result, "yyyy", myear)
					If InStr(result, "yy") > 0 Then result = Replace(result, "yy", Right(myear, 2))
					If InStr(result, "mm") > 0 Then result = Replace(result, "mm", Right("0"& mmonth, 2))
					If InStr(result, "m") > 0 Then result = Replace(result, "m", mmonth)
					If InStr(result, "dd") > 0 Then result = Replace(result, "dd", Right("0"& mday, 2))
					If InStr(result, "d") > 0 Then result = Replace(result, "d", mday)
					If InStr(result, "hh") > 0 Then result = Replace(result, "hh", Right("0"& mhour, 2))
					If InStr(result, "h") > 0 Then result = Replace(result, "h", mhour)
					If InStr(result, "nn") > 0 Then result = Replace(result, "nn", Right("0"& mminute, 2))
					If InStr(result, "n") > 0 Then result = Replace(result, "n", mminute)
					If InStr(result, "ss") > 0 Then result = Replace(result, "ss", Right("0"& msecond, 2))
					If InStr(result, "s") > 0 Then result = Replace(result, "s", msecond)
				End If
			End If

			dateFormat = result
		End Function

		Function strTime(strValue)
			strTime = Right("0"&strValue,2)
		End function

	' *****************************************************************************
	'	Function name	: dateFormat
	'	Description		: 날짜/시간 형식 변환
	' *****************************************************************************
		Function date8to10(ByVal pdate)
			value = pdate
			years = Left(value,4)
			months = Mid(value,5,2)
			dates = Right(value,2)
			date8to10 = years&"-"&months&"-"&dates
		End Function
	' *****************************************************************************
	'	Function name	: dateFormat
	'	Description		: 날짜/시간 형식 변환 2
	' *****************************************************************************
		Function date8to11(ByVal pdate)
			value = pdate
			years = Left(value,4)
			months = Mid(value,5,2)
			dates = Right(value,2)
			date8to11 = years&"/"&months&"/"&dates
		End Function
	' *****************************************************************************
	'	Function name	: dateFormat
	'	Description		: 날짜/시간 형식 변환 3
	' *****************************************************************************
		Function date8to12(ByVal pdate)
			value = pdate
			years = Left(value,4)
			months = Mid(value,5,2)
			dates = Right(value,2)
			date8to12 = years&"년 "&months&"월 "&dates&"일"
		End Function
	' *****************************************************************************
	'	Function name	: dateFormat
	'	Description		: 날짜/시간 형식 변환 4
	' *****************************************************************************
		Function date8to13(ByVal pdate)
			value = pdate
			years = Left(value,4)
			months = Mid(value,5,2)
			dates = Right(value,2)
			date8to13 = years&"."&months&"."&dates
		End Function

	' *****************************************************************************
	'	Function name	: datetoText
	'	Description		: 날짜/시간 형식 변환   20190929235959 → 2019-09-29 23:35:59
	' *****************************************************************************
		Function datetoText(ByVal pdate)
			value = Left(pdate,8)
			years = Left(value,4)
			months = Mid(value,5,2)
			dates = Right(value,2)

			value2 	= Right(pdate,6)
			hours 	= Left(value2,2)
			minutes = Mid(value2,2,2)
			seconds = Right(value2,2)

			datetoText = years&"-"&months&"-"&dates&" "&hours&":"&minutes&":"&seconds
		End Function

	' *****************************************************************************
	'	Function name	: setZeroFill
	'	Description		: 자릿수에 맞춰서 숫자 앞에  붙이기
	' *****************************************************************************
	Function setZeroFill(ByVal num, ByVal numLen)
		Dim i, zeros

		For i=1 To numLen
			zeros = zeros &"0"
		Next

		setZeroFill = Right(zeros & num, numLen)
	End Function

	' *****************************************************************************
	'	Function name	: iif
	'	Description		: 3항 연산자
	' *****************************************************************************
		Function iif(ByVal condition, ByVal val1, ByVal val2)
			If condition Then
				iif = val1
			Else
				iif = val2
			End If
		End Function






	' *****************************************************************************
	' Function Name : Print
	' Discription : Response.Write 쓰기 귀찮아서 만듬
	' *****************************************************************************
		Function RandomChar(ByVal resNum)
			Dim L(), Rci
			S_num = 65 '시작수 :chr(65) 는 A
			E_num = 90 '마지막 수 :chr(90)은 Z
			RND_num = Int(resNum) '생성 개수
			ReDim L(E_num - S_num + 1)
			Randomize
			For Rci = 0 To (E_num - S_num) '초기화
				L(Rci)=0
			Next
				cnt=0
			Do
				temp = round(rnd(1)*(E_num - S_num),0)+1
				For Rci=0 To cnt
					If L(Rci) = temp Then Exit For  '중복 체크
				Next
				If Rci = cnt + 1 Then
					L(cnt) = temp
					cnt = cnt + 1
				End If
			Loop While cnt <= RND_num-1
			For Rci = 0 To RND_num-1
				result = result & Chr(L(Rci)+S_num-1)
			Next
			RandomChar = result
		End Function


	' *****************************************************************************
	' Function Name : RANDOM_STRPASS
	'	랜덤문자 발생
	' *****************************************************************************
		Function RANDOM_STRPASS(lenNum)
			Dim strChar, strLen, r, i,SERIALCODE

			strChar	= "123456789abcdefghijklmnopqrstuvwxyz"		'랜덤으로 사용될 문자 또는 숫자

			strLen	= lenNum									'랜덤으로 출력될 값의 자릿수 ex)해당 구문에서 10자리의 랜덤 값 출력

			Randomize											'랜덤 초기화
			For i = 1 To strLen									'위에 선언된 strlen만큼 랜덤 코드 생성
				r = Int((Len(strChar) - 1 + 1) * Rnd + 1)
				SERIALCODE = SERIALCODE + Mid(strChar,r,1)
			Next
			RANDOM_STRPASS = SERIALCODE
		End Function

	' *****************************************************************************
	' Function Name : RandomNum
	'	랜덤숫자 발생
	' *****************************************************************************
		Function RandomNum(lenNum)
			num = ""
			For i = 1 to lenNum
				Randomize					 '//랜덤을 초기화 한다.
				num = num & CInt(Rnd*9)		 '//랜덤 숫자를 만든다.
			Next
			RandomNum = num
		End Function




		Function RoundUp(val)
			If CInt(val) < val Then
				RoundUp = CInt(val)+1
			Else
				RoundUp = CInt(val)
			End If
		End Function


	' *****************************************************************************
	'	Function name	: Fn_DistinctData
	'	Description		: 중복값제거
	'	order.asp		: CS 매출구분 체크
	' *****************************************************************************
		Function Fn_DistinctData(ByVal aData)
			Dim dicObj, items, returnValue

			Set dicObj = CreateObject("Scripting.dictionary")
			dicObj.removeall
			dicObj.CompareMode = 0

			For Each items In aData
				 If not dicObj.Exists(items) Then dicObj.Add items, items
			Next

			returnValue = dicObj.keys
			Set dicObj = Nothing
			Fn_DistinctData = returnValue
		End Function


	' *****************************************************************************
	'	Function name	: FN_MEMBER_LOGOUT
	'	Description		: (탈퇴)회원로그아웃
	' *****************************************************************************
		Function FN_MEMBER_LOGOUT(ByVal ALERT_MSG)
			If isCOOKIES_TYPE_LOGIN = "T" Then
				Response.Cookies(COOKIES_NAME).path = "/"
				Response.Cookies(COOKIES_NAME)("DKMEMBERID") = ""
				Response.Cookies(COOKIES_NAME)("DKMEMBERNAME") = ""
				Response.Cookies(COOKIES_NAME)("DKMEMBERLEVEL") = ""
				Response.Cookies(COOKIES_NAME)("DKMEMBERTYPE") = ""
				Response.Cookies(COOKIES_NAME)("DKMEMBERID1") = ""
				Response.Cookies(COOKIES_NAME)("DKMEMBERID2") = ""
				Response.Cookies(COOKIES_NAME)("DKMEMBERWEBID") = ""
				Response.Cookies(COOKIES_NAME)("DKBUSINESSCNT") = ""
				Response.Cookies(COOKIES_NAME)("DKMEMBERSTYPE") = ""
				Response.Cookies(COOKIES_NAME)("DKCSNATIONCODE") = ""
				Response.Cookies(COOKIES_NAME)("DK_MEMBER_VOTER_ID") = ""
			Else
				SESSION("DK_MEMBER_ID")			= Null
				SESSION("DK_MEMBER_NAME")		= Null
				SESSION("DK_MEMBER_LEVEL")		= Null
				SESSION("DK_MEMBER_TYPE")		= Null
				SESSION("DK_MEMBER_ID1")		= Null
				SESSION("DK_MEMBER_ID2")		= Null
				SESSION("DK_MEMBER_WEBID")		= Null
				SESSION("DK_BUSINESS_CNT")		= Null
				SESSION("DK_MEMBER_STYPE")		= Null
				SESSION("DK_MEMBER_NATIONCODE")	= Null
				SESSION("DK_MEMBER_VOTER_ID")	= Null
			End If
			DK_MEMBER_ID	 = ""
			DK_MEMBER_NAME	 =  ""
			DK_MEMBER_LEVEL	 =  0
			DK_MEMBER_TYPE	 =  ""
			DK_MEMBER_ID1	 =  ""
			DK_MEMBER_ID2	 =  ""
			DK_MEMBER_WEBID	 =  ""
			DK_BUSINESS_CNT  =  ""
			DK_MEMBER_STYPE  =  ""
			DK_MEMBER_NATIONCODE = ""
			DK_MEMBER_VOTER_ID = ""

			Call ALERTS(ALERT_MSG,"GO",MOB_PATH&"/index.asp")
		End Function





	Function ReturnAjaxMsg(ByVal result, ByVal resultMsg)
		Dim JsonRet
			Set JsonRet = jsObject()

		JsonRet("result") = result
				JsonRet("resultMsg") = resultMsg
				JsonRet("data") = ""

		PRINT toJSON(JsonRet)
				Response.End
	End Function

	'********************************************************


	'▣ Array Check S
		Function FN_IN_ARRAY(element, arr)
			Dim nArrCnt
			FN_IN_ARRAY = False
			For nArrCnt = 0 To Ubound(arr)
				If Trim(arr(nArrCnt)) = Trim(element) Then
					FN_IN_ARRAY = True
					Exit Function
				End If
			Next
		End Function

		FUNCTION URLDecode(str)
			'// This function:
			'// - decodes any utf-8 encoded characters into unicode characters eg. (%C3%A5 = å)
			'// - replaces any plus sign separators with a space character
			'//
			'// IMPORTANT:
			'// Your webpage must use the UTF-8 character set. Easiest method is to use this META tag:
			'// <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
			'//
				Dim objScript
			Set objScript = Server.CreateObject("ScriptControl")
				objScript.Language = "JavaScript"
				URLDecode = objScript.Eval("decodeURIComponent(""" & str & """.replace(/\+/g,"" ""))")
			Set objScript = NOTHING

		END FUNCTION

		Function FnCpnoSplit(ByVal cpno)
			Dim firstCpno, secondCpno
			If Len(cpno) = 13 Then
				firstCpno = Left(cpno, 6)
				secondCpno = Right(cpno, 7)

				FnCpnoSplit = firstCpno&"-"&secondCpno
			ElseIf Len(cpno) > 6 Then
				firstCpno = Left(cpno, 6)
				secondCpno = Right(Left(cpno, 7), 1)&"000000"

				FnCpnoSplit = firstCpno&"-"&secondCpno
			ElseIf Len(cpno) = 6 Then
				firstCpno = Left(cpno, 6)
				secondCpno = "0000000"

				FnCpnoSplit = firstCpno&"-"&secondCpno
			Else
				FnCpnoSplit = ""
			End If

		End Function




	' *****************************************************************************
	'	Function name	: Delay
	'	Description		: 지연
	' *****************************************************************************
		Sub Delay(DelaySeconds)
			SecCount = 0
			Sec2 = 0
			While SecCount < DelaySeconds + 1
				Sec1 = Second(Time())
				If Sec1 <> Sec2 Then
					Sec2 = Second(Time())
					SecCount = SecCount + 1
				End If
			Wend
		End Sub




	' *****************************************************************************
	'	Function name	: dateFormatBack
	'	Description		: 날짜/시간 형식 변환
	' *****************************************************************************
		Function dateFormatBack(ByVal pdate)
			result = ""
			If Len(pDate) = 14 Then
				result = result & Left(pDate,4) & "-"
				result = result & mid(pDate,5,2) & "-"
				result = result & mid(pDate,7,2) & " "
				result = result & mid(pDate,9,2) & ":"
				result = result & mid(pDate,11,2) & ":"
				result = result & mid(pDate,13,2)

			End If
			dateFormatBack = result


		End Function



	' *****************************************************************************
	' Function Name : UrlDecode_GBToUtf8
	' Discription : URL DECODE UTF8
	' *****************************************************************************
		Function UrlDecode_GBToUtf8(ByVal str)
			Dim B,ub
			Dim UtfB
			Dim UtfB1, UtfB2, UtfB3
			Dim i, n, s
			n=0
			ub=0
			For i = 1 To Len(str)
				B=Mid(str, i, 1)
				Select Case B
					Case "+"
						s=s & " "
					Case "%"
						ub=Mid(str, i + 1, 2)
						UtfB = CInt("&H" & ub)
						If UtfB<128 Then
							i=i+2
							s=s & ChrW(UtfB)
						Else
							UtfB1=(UtfB And &H0F) * &H1000
							UtfB2=(CInt("&H" & Mid(str, i + 4, 2)) And &H3F) * &H40
							UtfB3=CInt("&H" & Mid(str, i + 7, 2)) And &H3F
							s=s & ChrW(UtfB1 Or UtfB2 Or UtfB3)
							i=i+8
						End If
					Case Else
						s=s & B
				End Select
			Next
			UrlDecode_GBToUtf8 = s
		End Function
	' *****************************************************************************


	' *****************************************************************************
	' Function Name		: FN_ONLY_PAGEURL
	' Discription		: 기본URL 제외, 현재 페이지 주소만 호출
	' *****************************************************************************
		Function FN_ONLY_PAGEURL(ByVal thisURL)

			thisURL = Replace(LCase(thisURL), "www.", "")
			houUrl	= Replace(LCase(houUrl), "www.", "")

			If InStr(thisURL, houUrl) > 0 Then
				thisURL = Replace(thisURL, "http://", "")
				thisURL = Replace(thisURL, "https://", "")
				thisURL = Replace(thisURL, LCase(houUrl), "")
				FN_ONLY_PAGEURL = thisURL
			Else
				FN_ONLY_PAGEURL = thisURL
			End If

		End Function


	' *****************************************************************************
	' Function Name		: WRONG_ACCESS
	' Discription		: 잘못된 접근
	' *****************************************************************************
		Function WRONG_ACCESS()
			Call ALERTS(LNG_ALERT_WRONG_ACCESS,"back","")
		End Function



	' *****************************************************************************
	' Function Name : FN_URLDecode
	' Description : URL DECODE 함수 (EUC-KR 형식에서 사용됨)
	' :: EUC-KR 에서 데이터가 날아오는 경우 변환전
	' :: 	Session.CodePage = "949"
	' ::	Response.CharSet = "EUC-KR"
	' :: 을 지정한 후 해당 함수로 DECODE 시킨후 CodePage 와 CharSet 을 다시 utf 로 변경하도록 한다
	' *****************************************************************************
		Function FN_URLDecode(sStr)
			Dim sRet, reEncode, sChar
			Dim i

			If isnull(sStr) Then
				sStr = ""
			Else
				Set reEncode = New RegExp
					reEncode.IgnoreCase = True
					reEncode.Pattern = "^%[0-9a-f][0-9a-f]$"
					sStr = Replace(sStr, "+", " ")
					sRet = ""

					For i = 1 To Len(sStr)
						sChar = Mid(sStr, i, 3)
						If reEncode.Test(sChar) Then
							If CInt("&H" & Mid(sStr, i + 1, 2)) < 128 Then
								sRet = sRet & Chr(CInt("&H" & Mid(sStr, i + 1, 2)))
								i = i + 2
							Elseif mid(sStr, i+3, 1) ="%" Then
								sRet = sRet & Chr(CInt("&H" & Mid(sStr, i + 1, 2) & Mid(sStr, i + 4, 2)))
								i = i + 5
							Else
								sRet = sRet & Chr(CInt("&H" & Mid(sStr, i + 1, 2) & "00") + asc(mid(sStr,i+3,1)))
								i = i + 3
							End If
						Else
							sRet = sRet & Mid(sStr, i, 1)
						End If
					Next
			End If
			FN_URLDecode = sRet
		End Function
	' *****************************************************************************

	' *****************************************************************************
	' Function Name : FN_TraceLog
	' Description : 로그기록 함수
	' sLogfile : 경로 (경로 뒤에 _YYYY_MM 이 자동으로 붙게 됨
	' strLogMsg : 로그 메세지 처리
	' *****************************************************************************
		Function FN_TraceLog(sLogfile, strLogMsg)

			Dim	strLogFile,	strRecord, LOG_PATH
			Dim	fs,	f

			Dim nowYM : nowYM = Year(now)&"_"&Right("00"&Month(now),2)

			LOG_PATH = sLogfile&"_"&nowYM
			Call ChkPathToCreate(LOG_PATH)
			strLogFile = Server.MapPath (LOG_PATH&"/Log_") & Replace(Date(),"-","") & ".log"
			'*************************************************************************
			' Logging 할 Record	생성
			'*************************************************************************
			If strLogMsg <> "" Then
				strRecord =	"["	& CStr(FormatDateTime(time(),0)) & "]	"
				strRecord =	strRecord &	": " & CStr(strLogMsg) & " "
			End If
			'*************************************************************************
			' 화일에 Logging
			'*************************************************************************
			Set	fs = CreateObject("Scripting.FileSystemObject")

			Set	f =	fs.OpenTextFile(strLogFile,	8, True)
			f.WriteLine(strRecord)
			f.Close

			Err.Clear
		End	Function
	' *****************************************************************************

	' *****************************************************************************
	' Function Name : FN_HR_DEC / FN_HR_ENC
	' Description : HyeongRyeol 복호화 / 암호화
	' Description : 내용이 반드시 있을 경우를 산정하여 사용
	' values : 암(복)호화 시킬 데이터
	' *****************************************************************************
		Function FN_HR_DEC(ByVal values)
			errorTF = "F"
			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				'objEncrypter.Key = con_EncryptKey
				'objEncrypter.InitialVector = con_EncryptKeyIV
				objEncrypter.Key = con_EncryptKey_FD
				objEncrypter.InitialVector = con_EncryptKeyIV_FD
				On Error Resume Next
					If values <> ""	Then values	= objEncrypter.Decrypt(values)
					If Err.Number <> 0 Then	errorTF = "T"
				On Error GoTo 0
			Set objEncrypter = Nothing
			If errorTF = "F" Then
				FN_HR_DEC = values
			Else
				FN_HR_DEC = "암호화 오류"
			End If
		End Function

		Function FN_HR_ENC(ByVal values)
			errorTF = "F"
			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				'objEncrypter.Key = con_EncryptKey
				'objEncrypter.InitialVector = con_EncryptKeyIV
				objEncrypter.Key = con_EncryptKey_FD
				objEncrypter.InitialVector = con_EncryptKeyIV_FD
				On Error Resume Next
					If values <> ""	Then values	= objEncrypter.Encrypt(values)
					If Err.Number <> 0 Then	errorTF = "T"
				On Error GoTo 0
			Set objEncrypter = Nothing
			If errorTF = "F" Then
				FN_HR_ENC = values
			Else
				FN_HR_ENC = "암호화 오류"
			End If
		End Function

	' *****************************************************************************
	' Function Name : FN_HR_DEC / FN_HR_ENC  (기본)
	' Description : HyeongRyeol 복호화 / 암호화
	' Description : 내용이 반드시 있을 경우를 산정하여 사용
	' values : 암(복)호화 시킬 데이터
	' *****************************************************************************
		Function FN_HR_Decrypt(ByVal values)
			errorTF = "F"
			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				On Error Resume Next
					If values <> ""	Then values	= objEncrypter.Decrypt(values)
					If Err.Number <> 0 Then	errorTF = "T"
				On Error GoTo 0
			Set objEncrypter = Nothing
			If errorTF = "F" Then
				FN_HR_Decrypt = values
			Else
				FN_HR_Decrypt = "Encryption Error"
			End If
		End Function

		Function FN_HR_Encrypt(ByVal values)
			errorTF = "F"
			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				On Error Resume Next
					If values <> ""	Then values	= objEncrypter.Encrypt(values)
					If Err.Number <> 0 Then	errorTF = "T"
				On Error GoTo 0
			Set objEncrypter = Nothing
			If errorTF = "F" Then
				FN_HR_Encrypt = values
			Else
				FN_HR_Encrypt = "Encryption Error"
			End If
		End Function
	' *****************************************************************************



	' *****************************************************************************
	' Function Name		: autoLink
	' Discription		: URL 자동링크 (textArea 입력)
	'	/cboard/board_view.asp
	' *****************************************************************************
		Function autoLink(ByVal content)
			strRegExp = "http(s)?://([a-zA-Z0-9\~\!\@\#\$\%\^\&\*\(\)_\-\=\+\\\/\?\.\:\;\'\,]*)?"
			strOutput = "<a href='http$1://$2' target='_blank'>http$1://$2</a>"
			autoLink= reg_replace(content,strRegExp,strOutput,true)
		End Function

		Function reg_replace(strOriginalString, strPattern, strReplacement, varIgnoreCase)
			'Function replaces pattern with replacement
			'varIgnoreCase must be TRUE (match is case insensitive) or FALSE (match is case sensitive)
			dim objRegExp : set objRegExp = new RegExp
			with objRegExp
			.Pattern = strPattern
			.IgnoreCase = varIgnoreCase
			.Global = True
			end with

			reg_replace = objRegExp.replace(strOriginalString, strReplacement)
			set objRegExp = nothing
		End Function


	' *****************************************************************************
	' Function Name : Fn_MBID2
	' Description : 회원번호2 표기
	'	full_mbid2  : True / False
	' *****************************************************************************
		Function Fn_MBID2(ByVal mbid2)
			'full_mbid2 = True
			full_mbid2 = False
			If full_mbid2 = True Then
				Fn_MBID2 = Right("0000000000000"&mbid2, MBID2_LEN)
			Else
				Fn_MBID2 = mbid2
			End If
		End Function
%>
<%
	' ######################################################################
	'	Class name		: base64Crypt
	'	Description		: use with Function BASE64_Encrypt
	'								: biz PPurio
	' ######################################################################
		Class base64Crypt

			Function Base64Encode(sText)
				Dim oXML, oNode
				Set oXML = CreateObject("Msxml2.DOMDocument.3.0")
				Set oNode = oXML.CreateElement("base64")
				oNode.dataType = "bin.base64"
				oNode.nodeTypedValue = Stream_StringToBinary(sText)
				Base64Encode = oNode.text
				Set oNode = Nothing
				Set oXML = Nothing
			End Function

			Function Base64Decode(ByVal vCode)
				Dim oXML, oNode
				Set oXML = CreateObject("Msxml2.DOMDocument.3.0")
				Set oNode = oXML.CreateElement("base64")
				oNode.dataType = "bin.base64"
				oNode.text = vCode
				Base64Decode = Stream_BinaryToString(oNode.nodeTypedValue)
				Set oNode = Nothing
				Set oXML = Nothing
			End Function

			Private Function Stream_StringToBinary(sText)
				Const adTypeText = 2
				Const adTypeBinary = 1
				Dim BinaryStream 'As New Stream
				Set BinaryStream = CreateObject("ADODB.Stream")
				BinaryStream.Type = adTypeText
				BinaryStream.CharSet = "utf-8"
				BinaryStream.Open
				BinaryStream.WriteText sText
				BinaryStream.Position = 0
				BinaryStream.Type = adTypeBinary
				Stream_StringToBinary = BinaryStream.Read
				Set BinaryStream = Nothing
			End Function

			Private Function Stream_BinaryToString(sBinary)
				Const adTypeText = 2
				Const adTypeBinary = 1
				Dim BinaryStream 'As New Stream
				Set BinaryStream = CreateObject("ADODB.Stream")
				BinaryStream.Type = adTypeBinary
				BinaryStream.Open
				BinaryStream.Write sBinary
				BinaryStream.Position = 0
				BinaryStream.Type = adTypeText
				BinaryStream.CharSet = "utf-8"
				Stream_BinaryToString = BinaryStream.ReadText
				Set BinaryStream = Nothing
			End Function
		End Class

		'Set Crypt = New base64Crypt
		'test = "metac21g_dev:metac21g!com"
		'Response.write Crypt.Base64Encode(test) & "<Br>"
		'Response.write Replace(Crypt.Base64Encode(test), "77u/", "") & "<Br>"
		'Response.write Crypt.Base64Decode(Replace(Crypt.Base64Encode(test), "77u/", "")) & "<Br>"
		'Response.write Crypt.Base64Decode(Crypt.Base64Encode(test)) & "<Br>"
		'Response.write "<hr>"
		'Response.write "<hr>"


	' ######################################################################
	'	BASE64_Encrypt		'BASE64_Encrypt(test)
	' ######################################################################
		Public Function BASE64_Encrypt(value)
			Set Crypt = New base64Crypt
			BASE64_Encrypt = Crypt.Base64Encode(value)
			BASE64_Encrypt = Replace(BASE64_Encrypt, "77u/", "")
		End Function


	' *****************************************************************************
	'	Function name	: JsonNoSpaces
	'	Description		: Json Tab, Space 제거
	' *****************************************************************************
		Function JsonNoSpaces(str)
			value = str
			value = Replace(value, Chr(9), "")		'tab
			value = Replace(value, ", ", ",")
			value = Replace(value, " ,", ",")
			value = Replace(value, ": ", ":")
			value = Replace(value, " :", ":")

			'추가(관리자 kakao button json 공백, 개행처리 추가)
			'value = Replace(value,Chr(32)&Chr(32)&Chr(32),"")	'3spaces 제거
			value = Replace(value,Chr(32)&Chr(32),"")		'2spaces 제거

			value = Replace(value, vbcrlf, "")
			value = Replace(value, chr(13)&chr(10), "")
			value = Replace(value, chr(13), "")
			value = Replace(value, chr(10), "")

			JsonNoSpaces = value
		End Function


	' *****************************************************************************
	'	Function name	: JSONEncode
	'	Description		:
	' *****************************************************************************
		Function JSONEncode(ByVal val)
			value = val
			value = Replace(value, "\", "\\")
			value = Replace(value, """", "\""")
			'value = Replace(value, "/", "\/")
			value = Replace(value, Chr(8), "\b")
			value = Replace(value, Chr(12), "\f")
			value = Replace(value, Chr(10), "\n")
			value = Replace(value, Chr(13), "\r")
			value = Replace(value, Chr(9), "\t")
			JSONEncode = Trim(value)
		End Function


	' *****************************************************************************
	'	Function name	: BytesToStr
	'	Description		:
	' *****************************************************************************
		Function BytesToStr(bytes)
			Dim Stream
			Set Stream = Server.CreateObject("Adodb.Stream")
			Stream.Type = 1 'adTypeBinary
			Stream.Open
			Stream.Write bytes
			Stream.Position = 0
			Stream.Type = 2 'adTypeText
			Stream.Charset = "UTF-8"
			BytesToStr = Stream.ReadText
			Stream.Close
			Set Stream = Nothing
		End Function


	' *****************************************************************************
	'	Function name	: BinaryToText
	'	Description		: 바이너리 형태의 데이터를 텍스트로 변환 + CharSet 선택
	' *****************************************************************************
		Function BinaryToText(BinaryData, CharSet)
			Dim BinaryStream
			Set BinaryStream = CreateObject("ADODB.Stream")

			'원본 데이터 타입
			BinaryStream.Type = 1
			BinaryStream.Open
			BinaryStream.Write BinaryData

			'binary -> text
			BinaryStream.Position = 0
			BinaryStream.Type = 2

			'변환할 데이터 캐릭터셋
			BinaryStream.CharSet = CharSet

			'변환한 데이터 반환
			BinaryToText = BinaryStream.ReadText

			BinaryStream.Close
			Set BinaryStream = Nothing
		End Function



	' *****************************************************************************
	'	Function name	: LineFeedToBR
	'	Description		: 개행 br로 치환
	' *****************************************************************************
		Function LineFeedToBR(ByVal val)
			value = val
			value = Replace(value, vbcrlf, "<br />")
			value = Replace(value, Chr(10), "<br />")
			value = Replace(value, Chr(13), "<br />")
			value = Replace(value, chr(13)&chr(10), "<br />")
			LineFeedToBR = Trim(value)
		End Function

%>
