<%
'*******************************************************************************
' Function Name : SendMail
'	Description		: 이메일 전송
' Call SendMail(strTo, strTitle, strContent)
'	Print SendMail(strTo, strTitle, strContent) : 전송 + 처리결과 출력
'*******************************************************************************
	Function SendMail(strTo, strTitle, strContent)
		'On Error Resume Next
		If SMTP_ACCOUNTNAME = "" Or SMTP_SERVER = "" OR SMTP_SENDUSERNAME = "" OR SMTP_SENDPASSWORD = "" Then
			SendMail = "error : check mail transfer settings"
			Exit Function
		End If

		If Len(strTo) = 0 Then
			Exit Function
		End If

		Dim smtpaccountname                 : smtpaccountname = SMTP_ACCOUNTNAME
		Dim smtpserver                      : smtpserver = SMTP_SERVER
		Dim smtpserverport                  : smtpserverport = SMTP_SERVERPORT
		Dim sendusername                    : sendusername = SMTP_SENDUSERNAME
		Dim sendpassword                    : sendpassword = SMTP_SENDPASSWORD

		Set Smtp = Server.CreateObject("TABSUpload4.Smtp")
			'연결할 메일 서버를 지정
			Smtp.ServerName = smtpserver
			Smtp.ServerPort = smtpserverport
			Smtp.UseTLS = True
			Smtp.SmtpAuthID = sendusername
			Smtp.SmtpAuthPassword = sendpassword

			'메일 내용을 지정
			Smtp.FromAddress 	= smtpaccountname
			Smtp.AddToAddr 		strTo, ""
			Smtp.Subject			= strTitle
			Smtp.Encoding 		= "base64"
			Smtp.Charset 			= "utf-8"
			Smtp.BodyHtml 		= strContent

		Set Result = Smtp.Send()
		If Err.number <> 0 Then
			SendMail = LNG_AJAX_IDPW_PWD_TEXT11&" 본사 문의"			'오류가 발생하였습니다.
		Else

			If Result.Type = SmtpErrorSuccess Then
				SendMail = LNG_AJAX_IDPW_PWD_TEXT10			'메일이 전송되었습니다..."
			Else
				If webproIP = "T" Then
					SendMail = Result.Description
				Else
					SendMail = LNG_AJAX_ERROR_MSG_01&" 본사 문의!"
				End If
			End If

		End If
		'On Error GoTo 0
	End Function


' *****************************************************************************
' Function Name : FnWelComeMail
'	Description		: 템플릿 메세지 가져오기 추가 파라미터 변경/추가
' *****************************************************************************
	'Function FnWelComeMail(ByVal memEmail, ByVal memCode, ByVal linkCode)
	Function FnWelComeMail(ByVal memEmail, ByVal Mbid, ByVal Mbid2, ByVal strCate, ByVal linkCode)

		'템플릿 메세지 가져오기
		Call FN_GetMessageTemplate(Mbid, Mbid2, strCate,	sendTel_Ref, sendTitle_Ref, sendMsg_Ref)

		BASIC_SEND = ""
		If sendMsg_Ref <> "" Then
			sendMsg = LineFeedToBR(sendMsg_Ref)
		Else
			sendMsg = LNG_SITE_TITLE&" 의 회원이 되신것을 축하드립니다!"
			BASIC_SEND = "T"
			MemCode = Mbid&"-"&Mbid2
		End If

		emailHtml = ""
		emailHtml = emailHtml & "<html>"
		emailHtml = emailHtml & "   <head>"
		emailHtml = emailHtml & "       <meta http-equiv=""Content-Type"" content=""text/html; charset=UTF-8"">"
		emailHtml = emailHtml & "   </head>"
		emailHtml = emailHtml & "   <body>"
		emailHtml = emailHtml & "       <div style=""width: 650px; margin: 20px; border: 1px solid #ccc; padding: 15px; text-align: center; overflow: hidden; float: left;"">"
		emailHtml = emailHtml & "           <div style=""margin: 40px 0;float: left;width: 100%;"">"
		'emailHtml = emailHtml & "               <img src="""&HTTPS&"://"&MAIN_DOMAIN&"/images/share/logo.png"">"	'경로/형식 고정!! (svg 지메일인식 X)
		emailHtml = emailHtml & "               <a href="""&HTTPS&"://"&MAIN_DOMAIN&"/m"" target=""_blank""><img src="""&HTTPS&"://"&MAIN_DOMAIN&"/images/share/logo.png""></a>"	'경로/형식 고정!! (svg 지메일인식 X)
		emailHtml = emailHtml & "           </div>"
		emailHtml = emailHtml & "           <div style=""background: #f9f9f9; margin-top: 10px;float: left;width: 100%;border-top: 1px solid #ddd; text-align: left;"">"
		emailHtml = emailHtml & "               <h3 style=""color: #222;font-size: 16px;font-weight: 500;margin-bottom: 20px; padding: 30px 30px;"">"&sendMsg&"</h3>"

		If strCate = "join2" Then		'이메일 전송 전용(카피라이터 추가)
			emailHtml = emailHtml & "              <hr>"
			emailHtml = emailHtml & "               <h4 style=""font-weight: 600; margin: 5px; padding: 0px 20px;"">"&LNG_COPYRIGHT_COMPANY&"</h4>"
			emailHtml = emailHtml & "               <h4 style=""font-weight: 600; margin: 5px; padding: 0px 20px;""><a href=""tel:"&LNG_COPYRIGHT_CSTEL&""" class=""tel"">Tel : "&LNG_COPYRIGHT_CSTEL&"</a></h4>"
			emailHtml = emailHtml & "               <h4 style=""font-weight: 600; margin: 5px; padding: 0px 20px;"">Fax : "&LNG_COPYRIGHT_FAX&"</h4>"
			emailHtml = emailHtml & "               <h4 style=""font-weight: 600; margin: 5px; padding: 0px 20px;"">E-mail :"&LNG_COPYRIGHT_EMAIL&"</h4>"
			emailHtml = emailHtml & "               <h4 style=""font-weight: 600; margin: 5px; padding: 0px 20px;"">"&LNG_COPYRIGHT_ADDRESS&"</h4>"
			emailHtml = emailHtml & "               <h4 style=""font-weight: 600; margin: 5px; padding: 0px 20px;""><a href="&HTTPS&"://"&MAIN_DOMAIN&" target=""_blank"">"&MAIN_DOMAIN&"</h4>"
		End If

		If BASIC_SEND = "T" Then
			emailHtml = emailHtml & "              <h6 style=""color: #222;font-size: 18px;font-weight: 600;line-height: 150%;margin-bottom: 30px;"">"
			emailHtml = emailHtml & "                  회원번호는 <span style=""color: #244167;font-size: 22px;font-weight: 800;margin: 0 5px;line-height: 150%;"">"&MemCode&"</span> 입니다."
			emailHtml = emailHtml & "              </h6>"
		End If
		'emailHtml = emailHtml & "               <ul style=""font-size: 0; overflow: hidden; margin: 30px auto;width: 600px; padding: 0;"">"
		'emailHtml = emailHtml & "                   <li style=""display: inline-block;margin: 10px;width: 302px;""><a href="""" style=""font-size: 18px;padding: 10px 0; line-height: 150%; border: 1px solid #555;border-radius: 1px; background-size: 15px; text-decoration: none; display: inline-block; color: #465746; font-weight: 500; width: 300px;"">회원등록증<i style=""width: 15px; height: 15px; background: url(&#39;https://www.inqten.com/images/content/download.gif&#39;) no-repeat left center;margin-left: 5px; display: inline-block;""></i></a></li>"
		'emailHtml = emailHtml & "                   <li style=""display: inline-block;margin: 10px;width: 302px;""><a href="""" style=""font-size: 18px;padding: 10px 0; line-height: 150%; border: 1px solid #555;border-radius: 1px; background-size: 15px; text-decoration: none; display: inline-block; color: #465746; font-weight: 500; width: 300px; background-position: right 90px center;"">회원수첩<i style=""width: 15px; height: 15px;background: url(&#39;https://.gif&#39;) no-repeat left center; margin-left: 5px; display: inline-block;""></i></a></li>"
		'emailHtml = emailHtml & "                   <li style=""display: inline-block;margin: 10px;width: 302px;""><a href="""" style=""font-size: 18px;padding: 10px 0; line-height: 150%; border: 1px solid #555;border-radius: 1px; background-size: 15px; text-decoration: none; display: inline-block; color: #465746; font-weight: 500; width: 300px; background: #4CB945; border-color: #4CB945; color: #fff;"" target=""_blank"">홈페이지 바로가기</a></li>"
		'emailHtml = emailHtml & "               </ul>"
		'emailHtml = emailHtml & "               <p style=""font-size: 17px; color: #222;"">감사합니다.</p>"
		emailHtml = emailHtml & "           </div>"
		emailHtml = emailHtml & "       </div>"
		emailHtml = emailHtml & "   </body>"
		emailHtml = emailHtml & "</html>"

		'print emailHtml
		'Response.End

		Call SendMail(memEmail, LNG_SITE_TITLE&" 회원가입 안내 메일", emailHtml)

	End Function

%>
<%

' *****************************************************************************
' Function Name : FN_SMS_MOBILE_INFO_SEND
' Discription		: 메세지 전송(모바일 정보)
'	MSG_MMS_USE :  MMS도 사용시 T
'	Call FN_SMS_MOBILE_INFO_SEND(strMobile, strWebID, MMS_BODY, MMS_SUBJECT, strCate, MSG_MMS_USE)
' *****************************************************************************
	Function FN_SMS_MOBILE_INFO_SEND(ByVal strMobile, ByVal strWebID, ByVal MMS_BODY, ByVal MMS_SUBJECT, ByVal strCate, ByVal mmsUse)

			DEC_strMobile = strMobile
			MMS_SUBJECT = MMS_SUBJECT
			MMS_BODY = MMS_BODY
			MSG_MMS_USE = mmsUse

			If MSG_strComName = "" OR MSG_strCallback ="" Or DEC_strMobile = "" Then
				Call ALERTS("필수정보가 없습니다.","BACK","")
				Exit Function
			End If

			tran_comID = strWebID
			MSG_PRICE = MSG_LMS_PRICE
			TRAN_REFKEY = strCate

			If calcStringLenByte(MMS_BODY) > 80 And MSG_MMS_USE = "T" Then
				MSG_PRICE = MSG_LMS_PRICE

				arrParamsM1 = Array(_
					Db.makeParam("@strComName",adVarChar,adParamInput,20,MSG_strComName),_
					Db.makeParam("@tran_phone",adVarChar,adParamInput,15,DEC_strMobile),_
					Db.makeParam("@tran_callback",adVarChar,adParamInput,15,Replace(MSG_strCallback,"-","")),_
					Db.makeParam("@tran_comID",adVarChar,adParamInput,64,tran_comID), _
					Db.makeParam("@tran_refkey",adVarChar,adParamInput,40,TRAN_REFKEY), _

					Db.makeParam("@mms_body",adVarChar,adParamInput,2000,backword(MMS_BODY)),_
					Db.makeParam("@mms_subject",adVarChar,adParamInput,40,MMS_SUBJECT),_

					Db.makeParam("@tran_etc2",adVarChar,adParamInput,16,Left(getUserIP(),16)),_
					Db.makeParam("@tran_etc3",adVarChar,adParamInput,16,""),_

					Db.makeParam("@LMS_PRICE",adInteger,adParamInput,4,MSG_PRICE), _
					Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
				)
				Call Db.exec("DKP_WEBPRO_LMS_SEND",DB_PROC,arrParamsM1,DB5)
				OUTPUT_VALUEM1 = arrParamsM1(Ubound(arrParamsM1))(4)

			Else
				MSG_PRICE = MSG_SMS_PRICE

				arrParamsM1 = Array(_
					Db.makeParam("@strComName",adVarChar,adParamInput,20,MSG_strComName),_
					Db.makeParam("@tran_phone",adVarChar,adParamInput,15,DEC_strMobile),_
					Db.makeParam("@tran_callback",adVarChar,adParamInput,15,Replace(MSG_strCallback,"-","")),_
					Db.makeParam("@tran_comID",adVarChar,adParamInput,64,DK_MEMBER_ID), _
					Db.makeParam("@tran_refkey",adVarChar,adParamInput,40,TRAN_REFKEY), _

					Db.makeParam("@tran_msg",adVarChar,adParamInput,80,backword(MMS_BODY)),_

					Db.makeParam("@tran_etc2",adVarChar,adParamInput,16,Left(getUserIP(),16)),_
					Db.makeParam("@tran_etc3",adVarChar,adParamInput,16,""),_

					Db.makeParam("@LMS_PRICE",adInteger,adParamInput,4,MSG_PRICE), _
					Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
				)
				Call Db.exec("DKP_WEBPRO_SMS_SEND",DB_PROC,arrParamsM1,DB5)
				OUTPUT_VALUEM1 = arrParamsM1(Ubound(arrParamsM1))(4)

			End If

			Select Case OUTPUT_VALUEM1
				Case "ERROR" : Call ALERTS("메세지 전송중 오류가 발생했습니다.","BACK","")
				Case "FINISH"
				Case "NOTCNT" : Call ALERTS("메세지 전송 금액이 부족합니다.","BACK","")
				Case Else : Call ALERTS("메세지 전송중 알수없는 오류가 발생했습니다.","BACK","")
			End Select

	End Function
%>
<%

' *****************************************************************************
' Function Name : FN_MemMessage_Send
' Discription		: 통합 메세지 전송(회원)
'		Call FN_MemMessage_Send(Mbid, Mbid2, strCate)
'		관리자 페이지 템플릿 등록 확인 /admin/member/sms_list.asp?cate=join
'		strCate : join, order, ....pwd, spwd
'		requestInfos : 초기화 비밀번호(pwd, spwd)
' *****************************************************************************
	'Function FN_MemMessage_Send(ByVal Mbid, ByVal Mbid2, ByVal strCate)
	Function FN_MemMessage_Send(ByVal Mbid, ByVal Mbid2, ByVal strCate, requestInfos)

		If PPURIO_USE_TF = "T" Then			'비즈뿌리오 전송
			'기본 "sms", 함수 내에서 메세지 길이, 이미지첨부에 따른 분기(sms/lms,mms)

			'패스워드 초기화
			If Right(strCate,3) = "pwd" Then		'pwd, spwd
				requestInfos = requestInfos
			Else
				requestInfos = ""
			End If
			Call FN_PPURIO_MESSAGE(Mbid, Mbid2, strCate, "sms", "",requestInfos)

		Else	'문자모아 전송

			Call FN_GetMessageTemplate(Mbid, Mbid2, strCate,	sendTel_Ref, sendTitle_Ref, sendMsg_Ref)

			DEC_strMobile = sendTel_Ref
			MMS_SUBJECT = sendTitle_Ref
			MMS_BODY = sendMsg_Ref
			If MSG_strComName = "" OR MSG_strCallback ="" Or DEC_strMobile = "" Then Exit Function

			'패스워드 초기화
			If Right(strCate,3) = "pwd" Then		'pwd, spwd
				MMS_BODY =  FN_PPURIO_MESSAGE_VARIABLE_REPLACE(strCate, MMS_BODY, "", requestInfos)
				'Call ResRW2(MMS_BODY,"MMS_BODY")
			End If

			MSG_PRICE = MSG_LMS_PRICE
			TRAN_REFKEY = strCate

			If calcStringLenByte(MMS_BODY) > 80 Then
				MSG_PRICE = MSG_LMS_PRICE

				arrParamsM1 = Array(_
					Db.makeParam("@strComName",adVarChar,adParamInput,20,MSG_strComName),_
					Db.makeParam("@tran_phone",adVarChar,adParamInput,15,DEC_strMobile),_
					Db.makeParam("@tran_callback",adVarChar,adParamInput,15,Replace(MSG_strCallback,"-","")),_
					Db.makeParam("@tran_comID",adVarChar,adParamInput,64,DK_MEMBER_ID), _
					Db.makeParam("@tran_refkey",adVarChar,adParamInput,40,TRAN_REFKEY), _

					Db.makeParam("@mms_body",adVarChar,adParamInput,2000,backword(MMS_BODY)),_
					Db.makeParam("@mms_subject",adVarChar,adParamInput,40,MMS_SUBJECT),_

					Db.makeParam("@tran_etc2",adVarChar,adParamInput,16,Left(getUserIP(),16)),_
					Db.makeParam("@tran_etc3",adVarChar,adParamInput,16,""),_

					Db.makeParam("@LMS_PRICE",adInteger,adParamInput,4,MSG_PRICE), _
					Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
				)
				Call Db.exec("DKP_WEBPRO_LMS_SEND",DB_PROC,arrParamsM1,DB5)
				OUTPUT_VALUEM1 = arrParamsM1(Ubound(arrParamsM1))(4)

			Else
				MSG_PRICE = MSG_SMS_PRICE

				arrParamsM1 = Array(_
					Db.makeParam("@strComName",adVarChar,adParamInput,20,MSG_strComName),_
					Db.makeParam("@tran_phone",adVarChar,adParamInput,15,DEC_strMobile),_
					Db.makeParam("@tran_callback",adVarChar,adParamInput,15,Replace(MSG_strCallback,"-","")),_
					Db.makeParam("@tran_comID",adVarChar,adParamInput,64,DK_MEMBER_ID), _
					Db.makeParam("@tran_refkey",adVarChar,adParamInput,40,TRAN_REFKEY), _

					Db.makeParam("@tran_msg",adVarChar,adParamInput,80,backword(MMS_BODY)),_

					Db.makeParam("@tran_etc2",adVarChar,adParamInput,16,Left(getUserIP(),16)),_
					Db.makeParam("@tran_etc3",adVarChar,adParamInput,16,""),_

					Db.makeParam("@LMS_PRICE",adInteger,adParamInput,4,MSG_PRICE), _
					Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
				)
				Call Db.exec("DKP_WEBPRO_SMS_SEND",DB_PROC,arrParamsM1,DB5)
				OUTPUT_VALUEM1 = arrParamsM1(Ubound(arrParamsM1))(4)

			End If

			Select Case OUTPUT_VALUEM1
				Case "ERROR" : Call ALERTS("메세지 전송중 오류가 발생했습니다.","BACK","")
				Case "FINISH"
				Case "NOTCNT" : Call ALERTS("메세지 전송 금액이 부족합니다.","BACK","")
				Case Else : Call ALERTS("메세지 전송중 알수없는 오류가 발생했습니다.","BACK","")
			End Select

		End If


	End Function


' *****************************************************************************
' Function Name : FN_GetMessageTemplate		'관리자 저장된 메세지 템플릿 가져오기
' Discription		: 관리자 저장된 메세지 템플릿 가져오기(회원)
'		Call FN_GetMessageTemplate(Mbid, Mbid2, strCate, strSubject_Ref, smsContent_Ref)
'		관리자 페이지 템플릿 등록 확인 /admin/member/sms_list.asp?cate=join
'		strCate : join, order, ....
' *****************************************************************************
	Function FN_GetMessageTemplate(ByVal Mbid, ByVal Mbid2, ByVal strCate,		ByRef sendTel_Ref, ByRef sendTitle_Ref, ByRef sendMsg_Ref)

		If Mbid = "" OR Mbid2 ="" OR strCate ="" Then Exit Function

		'본인정보(탈퇴회원 제외)
		MYINFO_SQL = " SELECT M_Name, hptel, Saveid, Saveid2, Nominid, Nominid2, WebID, Sell_Mem_TF, Email FROM [tbl_Memberinfo] WITH(NOLOCK) "
		MYINFO_SQL = MYINFO_SQL & " WHERE [mbid] = ? AND [mbid2] = ? And [LeaveCheck] = 1 AND [LeaveDate] = '' "
		arrParams_SMS1 = Array(_
			Db.makeParam("@mbid",adVarChar,adParamInput,20,Mbid), _
			Db.makeParam("@mbid2",adInteger,adParamInput,0,Mbid2) _
		)
		Set MIRS = Db.execRs(MYINFO_SQL,DB_TEXT,arrParams_SMS1,DB3)
		If Not MIRS.BOF And Not MIRS.EOF Then
			MIRS_M_Name	= MIRS("M_Name")
			MIRS_hptel	= MIRS("hptel")
			MIRS_Saveid	= MIRS("Saveid")
			MIRS_Saveid2	= MIRS("Saveid2")
			MIRS_Nominid	= MIRS("Nominid")
			MIRS_Nominid2	= MIRS("Nominid2")
			MIRS_WebID	= MIRS("WebID")
			MIRS_Sell_Mem_TF	= MIRS("Sell_Mem_TF")
			MIRS_Email	= MIRS("Email")
		End If
		Call closeRS(MIRS)

		'제목, 내용 정보
		SELECT_SQL = " SELECT strSubject, smsContent FROM DK_SMS_CONTENT WITH(NOLOCK) WHERE delTF = 'F' "
		SELECT_SQL = SELECT_SQL & " AND strCate = ? "
		arrParamsCT = Array(Db.makeParam("@strCate",adVarChar,adParamInput,20,strCate))
		Set CTRS = Db.execRs(SELECT_SQL,DB_TEXT,arrParamsCT,DB3)

		If Not CTRS.EOF And Not CTRS.BOF Then
			strSubject = CTRS("strSubject")
			smsContent = CTRS("smsContent")
		Else
			smsContent = ""
		End If
		Call CloseRS(CTRS)

		If Len(smsContent) = 0 Then
			Exit Function
		End If

		SMS_MEM_CODE = Mbid & "-" & Mbid2
		SMS_MEM_NAME = MIRS_M_Name
		SMS_MEM_WEBID = MIRS_WebID
		SMS_COMPANY_URL = ""

		SELECT_SQL = " SELECT intIDX, smsCode, codeName, replaceCode FROM DK_SMS_CODE WITH(NOLOCK) WHERE delTF = 'F' ORDER BY codeName ASC "
		arrList = Db.execRsList(SELECT_SQL,DB_TEXT,Nothing,listLen,DB3)
		'Call ResRW(strCate,"strCate")
		'Call ResRW2(smsContent,"smsContent")

		If IsArray(arrList) then
			For i = 0 to listLen

				arrList_intIDX      = arrList(0, i)
				arrList_smsCode     = arrList(1, i)
				arrList_codeName    = arrList(2, i)
				arrList_replaceCode = arrList(3, i)

				smsContent = Replace(smsContent, arrList_smsCode, arrList_replaceCode)
			Next
		End If
		'Call ResRW2(smsContent,"smsContent")

		If SMS_MEM_CODE <> "" Then smsContent = Replace(smsContent, "SMS_MEM_CODE", SMS_MEM_CODE)
		If SMS_MEM_NAME <> "" Then smsContent = Replace(smsContent, "SMS_MEM_NAME", SMS_MEM_NAME)
		If SMS_MEM_WEBID <> "" Then smsContent = Replace(smsContent, "SMS_MEM_WEBID", SMS_MEM_WEBID)
		If SMS_COMPANY_URL <> "" Then smsContent = Replace(smsContent, "SMS_COMPANY_URL", SMS_COMPANY_URL)

		smsContent = Replace(smsContent, "#{고객명}", SMS_MEM_NAME)
		smsContent = Replace(smsContent, "#{마이오피스아이디}", SMS_MEM_WEBID)
		'Call ResRW2(smsContent,"smsContent")

		On Error Resume Next
		Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV
			On Error Resume Next
				If MIRS_hptel	<> "" Then DEC_strMobile	= objEncrypter.Decrypt(MIRS_hptel)
			On Error GoTo 0
		Set objEncrypter = Nothing
		On Error GoTo 0

		'If DEC_strMobile <> "" And IsNumeric(DEC_strMobile) Then
			sendTitle_Ref = strSubject
			sendMsg_Ref = smsContent
			sendTel_Ref = DEC_strMobile
		'Else
		'	sendTitle_Ref = ""
		'	sendMsg_Ref = ""
		'	sendTel_Ref = ""
		'End If

	End Function

%>
<!--#include virtual = "/_lib/json2.asp"-->
<%
' ***************************************************************************************************
' Function Name : FN_PPURIO_MESSAGE
'	Description		: 비즈뿌리오 타입별 메세지 전송 ("sms","lms","mms","at","ai","ft","rcs")
'	-	requestNumber : 요청번호(주문번호 등)
'	-	requestInfos : 요청정보들(정보1|정보2...)
'	'test... /API/ppurio/sample/send1_func.asp
' ***************************************************************************************************
	Function FN_PPURIO_MESSAGE(Mbid, Mbid2, strCate, strType, requestNumber, ByRef requestInfos)

			If Mbid = "" OR Mbid2 ="" OR strCate = "" Then Exit Function

			'#1 인증 토큰 발급을 요청
			Call FN_PPURIO_TOKEN_REQ(pTokenStatus, r_accesstoken, r_type)
			If pTokenStatus <> "200" Or r_accesstoken = "" Then Exit Function

			Select Case LCase(strType)
				Case "sms","lms","mms","at","ai","ft","rcs"
				Case Else : Exit Function
			End Select

			'수신번호, 제목, 메세지 값 가져오기
			Call FN_GetMessageTemplate(Mbid, Mbid2, strCate,	sendTel_Ref, sendTitle_Ref, sendMsg_Ref)
			sendTel = sendTel_Ref
			sendTitle = sendTitle_Ref
			sendMsg = sendMsg_Ref
			If sendTel = "" Or MSG_strComName = "" OR MSG_strCallback ="" Then Exit Function

			'필수 전송 정보
			YYMMDDHHMMSS = Right(Replace(Date(),"-",""),6)&Right("00"&Hour(nowTime),2)&Right("00"&Minute(nowTime),2)&Right("00"&Second(nowTime),2)
			PPURIO_MESSAGE_type			= LCase(strType)
			PPURIO_MESSAGE_from			= MSG_strCallback		' 발신 번호
			PPURIO_MESSAGE_to				= sendTel						' 수신 번호
			PPURIO_MESSAGE_conutry	= ""						' 국가 코드 * ● 국제 메시지 발송 참조
			PPURIO_MESSAGE_refkey		= YYMMDDHHMMSS&Left(PPURIO_ID,5)&DK_SES_MEMBER_IDX		'고객사에서 부여한 키
			PPURIO_MESSAGE_content_message = JSONEncode(sendMsg)			'JSONEncode	'▣HTML tag → json Encode
			PPURIO_MESSAGE_content_subject = sendTitle

			'MMS 이미지, kakao 템플릿코드, 버튼json 확인
			SELECT_CI = " SELECT [strImg],[kakaoTemplatecode],[kakaoButtonJson] FROM [DK_SMS_CONTENT] WITH(NOLOCK) WHERE [delTF] = 'F' AND [strCate] = ? "
			arrParamsCI = Array(Db.makeParam("@strCate",adVarChar,adParamInput,20,strCate))
			Set CIRS = Db.execRs(SELECT_CI,DB_TEXT,arrParamsCI,DB3)
			If Not CIRS.EOF And Not CIRS.BOF Then
				PPURIO_strImg = CIRS("strImg")
				PPURIO_MESSAGE_templatecode = CIRS("kakaoTemplatecode")
				PPURIO_kakaoButtonJson = CIRS("kakaoButtonJson")
				'가독성! (대괄호 삭제후 하단에서 다시 추가)
				PPURIO_kakaoButtonJson = Replace(PPURIO_kakaoButtonJson,"[","")
				PPURIO_kakaoButtonJson = Replace(PPURIO_kakaoButtonJson,"]","")
			Else
				PPURIO_strImg = ""
				PPURIO_MESSAGE_templatecode = ""
				PPURIO_kakaoButtonJson = ""
			End If
			Call CloseRS(CIRS)

			'기본 "sms", 메세지 길이, 이미지첨부에 따른 분기(sms/lms,mms)
			Select Case PPURIO_MESSAGE_type
				Case "sms","lms","mms"
					If calcStringLenByte(PPURIO_MESSAGE_content_message) <= 90 Then	'최대 90byte
						PPURIO_MESSAGE_type = "sms"
					Else
						PPURIO_MESSAGE_type = "lms"
					End If

					'file 이미지 등록 확인 strCate 기준
					'#MMS 발송에 사용될 이미지 파일을 업로드
					'1. 쇼핑몰 관리자에서 MMS 이미지 업로드
					'2. 뿌리오 서버에 이미지 등록/파일키 발급(MMS 전송 시마다 1회성 발급)
					'* 발급받은 파일키는 당일 00시에 무효화됨
					PPURIO_filekey = ""
					If PPURIO_strImg <> "" Then
						PPURIO_filekey = FN_PPURIO_FILEKEY(PPURIO_strImg)
						'Call ResRW(PPURIO_filekey,"PPURIO_filekey")
					End If

					'filekey 등록시 mms 변환
					If PPURIO_filekey <> "" Then
						PPURIO_MESSAGE_type = "mms"
						PPURIO_filekey = PPURIO_filekey
					End If

					'패스워드 초기화
					If Right(strCate,3) = "pwd" Then		'pwd, spwd
						PPURIO_MESSAGE_content_subject = Replace(PPURIO_MESSAGE_content_subject, "#{회사명}", LNG_COPYRIGHT_COMPANY)
						PPURIO_MESSAGE_content_message = FN_PPURIO_MESSAGE_VARIABLE_REPLACE(strCate, PPURIO_MESSAGE_content_message, "", requestInfos)
					End If

			End Select

			'Dim JsonObj	'뿌리오 JSON : 가독성/유지보수 안좋음 X
			'Set JsonObj = jsObject()
			'Dim JsonObj_content
			'Set JsonObj_content = jsObject()

			Dim jsonContent : jsonContent = ""

			Select Case PPURIO_MESSAGE_type
				Case "sms"		'5page
					If calcStringLenByte(PPURIO_MESSAGE_content_message) > 90 Then	'최대 90byte
						PPURIO_MESSAGE_content_message = cutString2(PPURIO_MESSAGE_content_message, 90-2)
					End If
					jsonContent = jsonContent& "	""message"": """&PPURIO_MESSAGE_content_message&""""

				Case "lms"		'6p
					If calcStringLenByte(PPURIO_MESSAGE_content_subject) > 64 Then	'최대 64byte
						PPURIO_MESSAGE_content_message = cutString2(PPURIO_MESSAGE_content_subject, 64-2)
					End If
					If calcStringLenByte(PPURIO_MESSAGE_content_message) > 2000 Then	'최대 2000byte
						PPURIO_MESSAGE_content_message = cutString2(PPURIO_MESSAGE_content_message, 2000-2)
					End If
					jsonContent = jsonContent& "	""subject"": """&PPURIO_MESSAGE_content_subject&""","
					jsonContent = jsonContent& "	""message"": """&PPURIO_MESSAGE_content_message&""""

				Case "mms"		'6-7p
					If calcStringLenByte(PPURIO_MESSAGE_content_subject) > 64 Then	'최대 64byte
						PPURIO_MESSAGE_content_message = cutString2(PPURIO_MESSAGE_content_subject, 64-2)
					End If
					If calcStringLenByte(PPURIO_MESSAGE_content_message) > 2000 Then	'최대 2000byte
						PPURIO_MESSAGE_content_message = cutString2(PPURIO_MESSAGE_content_message, 2000-2)
					End If
					jsonContent = jsonContent& "	""subject"": """&PPURIO_MESSAGE_content_subject&""","
					jsonContent = jsonContent& "	""message"": """&PPURIO_MESSAGE_content_message&""","
					jsonContent = jsonContent& "	""file"": ["
					jsonContent = jsonContent& "		{"
					jsonContent = jsonContent& "			""type"": ""IMG"","
					jsonContent = jsonContent& "			""key"": """&PPURIO_filekey&""" "
					jsonContent = jsonContent& "		}"
					jsonContent = jsonContent& "	]"

				Case "at"	'알림톡		'10p
					If strCate = "order" Then		'상품주문 템플릿 변수명 치환
						Call FN_PPURIO_MESSAGE_VARIABLE_REPLACE(strCate, PPURIO_MESSAGE_content_message, requestNumber, requestInfos)
						'Call ResRW2(PPURIO_MESSAGE_content_message,"REPLACE_PPURIO_MESSAGE_content_message")
					End If
					jsonContent = jsonContent& "	""senderkey"": """&PPURIO_MESSAGE_senderkey&""","
					jsonContent = jsonContent& "	""templatecode"": """&PPURIO_MESSAGE_templatecode&""","
					jsonContent = jsonContent& "	""message"": """&PPURIO_MESSAGE_content_message&""","
					jsonContent = jsonContent& "	""button"": ["
					jsonContent = jsonContent& 			PPURIO_kakaoButtonJson	'name,type,url_pc,url_mobile
					jsonContent = jsonContent& "	]"

				Case "ai"	'알림톡 이미지		'11p
					jsonContent = jsonContent& "	""senderkey"": """&PPURIO_MESSAGE_senderkey&""","
					jsonContent = jsonContent& "	""templatecode"": """&PPURIO_MESSAGE_templatecode&""","
					jsonContent = jsonContent& "	""message"": """&PPURIO_MESSAGE_content_message&""""

				Case "ft"	'친구톡		'10p
					jsonContent = jsonContent& "	""senderkey"": """&PPURIO_MESSAGE_senderkey&""","
					jsonContent = jsonContent& "	""adflag"": ""Y"","
					jsonContent = jsonContent& "	""message"": """&PPURIO_MESSAGE_content_message&""","
					jsonContent = jsonContent& "	""button"": ["
					'jsonContent = jsonContent& 			PPURIO_kakaoButtonJson	'name,type,url_pc,url_mobile
					jsonContent = jsonContent& "		{"
					jsonContent = jsonContent& "			""name"": ""1234567890123456789"","
					jsonContent = jsonContent& "			""type"": ""WL"","
					jsonContent = jsonContent& "			""url_pc"": ""http://www.bizppurio.com"","
					jsonContent = jsonContent& "			""url_mobile"": ""http://www.bizppurio.com"""
					jsonContent = jsonContent& "		},"
					jsonContent = jsonContent& "		{"
					jsonContent = jsonContent& "			""name"": ""1234567890123456789"","
					jsonContent = jsonContent& "			""type"": ""WL"","
					jsonContent = jsonContent& "			""url_pc"": ""http://www.bizppurio.com"","
					jsonContent = jsonContent& "			""url_mobile"": ""http://www.bizppurio.com"""
					jsonContent = jsonContent& "		}"
					jsonContent = jsonContent& "	],"
					jsonContent = jsonContent& "	""image"": {"
					jsonContent = jsonContent& "		""img_url"": ""url"","
					jsonContent = jsonContent& "		""imglink"": ""http//message.com"""
					jsonContent = jsonContent& "	}"

			End Select
			jsonContent = JsonNoSpaces(jsonContent)

			Dim jsonBody : jsonBody = ""
			jsonBody = jsonBody& "{"
			jsonBody = jsonBody& "	""account"": """&PPURIO_ID&""","
			jsonBody = jsonBody& "	""refkey"": """&PPURIO_MESSAGE_refkey&""","
			jsonBody = jsonBody& "	""type"": """&PPURIO_MESSAGE_type&""","
			jsonBody = jsonBody& "	""from"": """&PPURIO_MESSAGE_from&""","
			jsonBody = jsonBody& "	""to"": """&PPURIO_MESSAGE_to&""","
			jsonBody = jsonBody& "	""content"": {"
			jsonBody = jsonBody& "		"""&PPURIO_MESSAGE_type&""": {"
			jsonBody = jsonBody& 				jsonContent
			jsonBody = jsonBody& "		}"
			jsonBody = jsonBody& "	}"

			'Resend (at 실패시) 문자전송하기 S
			Dim jsonReContent : jsonReContent = ""
			If PPURIO_MESSAGE_type = "at" Then
				If calcStringLenByte(PPURIO_MESSAGE_content_message) <= 90 Then	'최대 90byte
					PPURIO_RESEND_MESSAGE_type = "sms"

					jsonReContent = jsonReContent& "	""message"": """&PPURIO_MESSAGE_content_message&""""

				Else
					PPURIO_RESEND_MESSAGE_type = "lms"

					If calcStringLenByte(PPURIO_MESSAGE_content_subject) > 64 Then	'최대 64byte
						PPURIO_MESSAGE_content_message = cutString2(PPURIO_MESSAGE_content_subject, 64-2)
					End If
					If calcStringLenByte(PPURIO_MESSAGE_content_message) > 2000 Then	'최대 2000byte
						PPURIO_MESSAGE_content_message = cutString2(PPURIO_MESSAGE_content_message, 2000-2)
					End If
					jsonReContent = jsonReContent& "	""subject"": """&PPURIO_MESSAGE_content_subject&""","
					jsonReContent = jsonReContent& "	""message"": """&PPURIO_MESSAGE_content_message&""""

				End If
				jsonBody = jsonBody& " ,""resend"": {"
				jsonBody = jsonBody& "		""first"": """&PPURIO_RESEND_MESSAGE_type&""""
				jsonBody = jsonBody& "	},"
				jsonBody = jsonBody& "	""recontent"": {"
				jsonBody = jsonBody& "		"""&PPURIO_RESEND_MESSAGE_type&""": {"
				jsonBody = jsonBody& 				jsonReContent
				jsonBody = jsonBody& "		}"
				jsonBody = jsonBody& "	}"
			End If
			'Resend (at 실패시) 문자전송하기 E

			jsonBody = jsonBody& "}"
			jsonBody = JsonNoSpaces(jsonBody)

			'뿌리오 중복 대괄호 syntax 오류체크 안됨!
			jsonBody = Replace(jsonBody,"[[","[")
			jsonBody = Replace(jsonBody,"]]","]")

			'Call ResRW2(PPURIO_MESSAGE_content_message,"content_message")
			'Call ResRW2(jsonBody,"jsonBody")
			'Call ResRW2(jsonContent,"jsonContent")

			'▣ LOG 입력 jsonBody
			arrParamsL = Array(_
				Db.makeParam("@MBID",adVarChar,adParamInput,20,Mbid),_
				Db.makeParam("@MBID2",adInteger,adParamInput,0,Mbid2),_
				Db.makeParam("@strUsePageName",adVarChar,adParamInput,50,Request.ServerVariables("URL")),_
				Db.makeParam("@strAccount",adVarChar,adParamInput,20,PPURIO_ID),_
				Db.makeParam("@strCate",adVarChar,adParamInput,20,strCate),_
				Db.makeParam("@strType",adChar,adParamInput,5,strType),_
				Db.makeParam("@requestBody",adVarWChar,adParamInput,2000,jsonBody),_
				Db.makeParam("@IDENTITY",adInteger,adParamOutput,0,0), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("HJP_PPURIO_LOG_INSERT",DB_PROC,arrParamsL,DB3)
			LOG_IDENTITY = arrParamsL(UBound(arrParamsL)-1)(4)
			LOG_OUTPUT_VALUE = arrParamsL(UBound(arrParamsL))(4)

			'#2 메시지 전송을 요청
			If pTokenStatus = "200" And r_accesstoken <> "" Then
				Call FN_PPURIO_MESSAGE_REQ(r_type, r_accesstoken, jsonBody, LOG_IDENTITY)
			End If

			'CS 에서 함수요청 시 LOG_IDENTITY 반환
			IF requestInfos = "CS" Then
				requestInfos = LOG_IDENTITY
			End IF
	End Function


' *****************************************************************************
' Function Name		: FN_PPURIO_TOKEN_REQ
' Discription		: /v1/token 인증 토큰 발급을 요청하는 기능입니다
' *****************************************************************************
	Function FN_PPURIO_TOKEN_REQ(byRef pTokenStatus, byRef r_accesstoken, byRef r_type)

		PPURIO_TOKEN_URL = PPURIO_URL&"/v1/token"
		PPURIO_BASE64_AUTH = BASE64_Encrypt(PPURIO_base64)
		PPURIO_TOCKEN_AUTH = "Basic "&PPURIO_BASE64_AUTH
		'Call ResRW(PPURIO_TOKEN_URL,"PPURIO_TOKEN_URL")
		'Call ResRW(PPURIO_BASE64_AUTH,"PPURIO_BASE64_AUTH")
		'Call ResRW2(PPURIO_TOCKEN_AUTH,"PPURIO_TOCKEN_AUTH")

		Set pToken = Server.CreateObject("Msxml2.ServerXMLHTTP")
			'Request
			pToken.open "POST", PPURIO_TOKEN_URL, False
			pToken.setRequestHeader "Content-Type", "application/json; charset=UTF-8"
			pToken.setRequestHeader "Authorization", PPURIO_TOCKEN_AUTH
			pToken.send ("")
			'Response
			pTokenResponse = pToken.responseText
			pTokenStatus = pToken.status
			'Call ResRW(pTokenResponse,"pTokenResponse")
			'Call ResRW2(pTokenStatus,"pTokenStatus")

		Set pToken = Nothing	'개체 소멸

		Dim json_token : Set json_token = JSON.parse(join(array(pTokenResponse)))
		Select Case pTokenStatus
			Case "200"
				r_accesstoken	= json_token.accesstoken		'인증 토큰
				r_type	= json_token.type			'Bearer
				r_expired	= json_token.expired	'type
				'Call ResRW(r_accesstoken,"r_accesstoken")
				'Call ResRW(r_type,"r_type")
				'Call ResRW(r_expired,"r_expired")
			Case Else
				r_accesstoken = ""
				r_type	= ""
				r_code	= json_token.code		'결과 코드
				r_description	= json_token.description		'디스크립션
				'Call ResRW(r_code,"r_code")
				'Call ResRW(r_description,"r_description")
		End Select

		'byRefs
		pTokenStatus = pTokenStatus
		r_accesstoken = r_accesstoken
		r_type = r_type
	End Function


' *****************************************************************************
' Function Name		: FN_PPURIO_MESSAGE_REQ
' Discription		: /v3/message 메시지 전송을 요청하는 기능입니다
' 	log Update
' *****************************************************************************
	Function FN_PPURIO_MESSAGE_REQ(r_type, r_accesstoken, jsonBody, LOG_IDENTITY)

		PPURIO_MESSAGE_URL = PPURIO_URL&"/v3/message"
		PPURIO_MESSAGE_AUTH = r_type&" "&r_accesstoken

		'jsonBody =	"{""account"":""metac21g_dev"",""refkey"":""test1234"",""type"":""sms"",""from"":""0215998800"",""to"":""01012341234"",""content"":{""sms"":{""message"":""content_message""}}}"
		'Call ResRW(jsonBody,"message body")
		Set pMessage = Server.CreateObject("Msxml2.ServerXMLHTTP")

			pMessage.open "POST", PPURIO_MESSAGE_URL, False
			pMessage.setRequestHeader "Content-Type", "application/json; charset=utf-8"			'PPURIO Header  Content-Type application/json; charset=utf-8 !!!
			pMessage.setRequestHeader "Authorization", PPURIO_MESSAGE_AUTH
			'pMessage.send toJSON(jsonBody)
			pMessage.send (jsonBody)

			pMessageResponse = pMessage.responseText
			pMessageStatus = pMessage.status
			'Call ResRW(pMessageResponse,"pMessageResponse")
			'Call ResRW2(pMessageStatus,"pMessageStatus")

		Set pMessage = Nothing	'개체 소멸

		Dim json_message : Set json_message = JSON.parse(join(array(pMessageResponse)))

		'19page
		r_messagekey = ""
		Select Case pMessageStatus
			Case "200"
				r_code	= json_message.code		'결과 코드
				r_description	= json_message.description		'결과 메시지
				r_messagekey	= json_message.messagekey		'메시지 키 * 고객 문의 및 리포트 재 요청 기준 키
				r_refkey	= json_message.refkey		'고객사에서 부여한 키
				'Call ResRW(r_code,"r_code")
				'Call ResRW(r_description,"r_description")
				'Call ResRW(r_messagekey,"r_messagekey")
				'Call ResRW(r_refkey,"r_refkey")
			Case "400"		'강제 Bad Request
				r_code	= json_message.code		'결과 코드
				r_description	= json_message.description		'결과 메시지
				'Call ResRW(r_code,"r_code")
				'Call ResRW(r_description,"r_description")
			Case Else
				r_code	= json_message.code		'결과 코드
				r_description	= json_message.description		'결과 메시지
				'Call ResRW(r_code,"r_code")
				'Call ResRW(r_description,"r_description")
		End Select

		If LOG_IDENTITY <> "" Then
			'▣ LOG 업데이트 responseBody
			arrParamsL2 = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,LOG_IDENTITY), _
				Db.makeParam("@responseBody",adVarWChar,adParamInput,2000,pMessageResponse),_
				Db.makeParam("@messagekey",adVarChar,adParamInput,32,r_messagekey),_
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("HJP_PPURIO_LOG_UPDATE",DB_PROC,arrParamsL2,DB3)

			''### ppurio receive Result(application/json) ###
			'전송 결과 확인(테트스시) : URL PUSH 결과 확인 delay 확인
			'Call Delay(1)		'TEST
			'Call Delay(4)			'REAL
			arrParamsLB = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,LOG_IDENTITY) _
			)
			Set HJRSLB = Db.execRs("HJP_PPURIO_LOG_RECEIVE_RESULTS",DB_PROC,arrParamsLB,DB3)
			If Not HJRSLB.BOF And Not HJRSLB.EOF Then
				r_RESULT  = Trim(HJRSLB(0))
				receiveResult = Trim(HJRSLB(1))
			Else
				r_RESULT  = ""
				receiveResult = ""
			End If
			Call closeRS(HJRSLB)

			'Call ResRW(LOG_IDENTITY,"LOG_IDENTITY")
			'Call ResRW(r_RESULT,"r_RESULT")
			'Call ResRW(receiveResult,"receiveResult")
		End If

	End Function


' ***************************************************************************************************
' Function Name : FN_PPURIO_MESSAGE_VARIABLE_REPLACE (업체별 strCate, 카카오 변수명 확인필요!!!!!!!!!!!!!)
'	Description		: 비즈뿌리오 템플릿 변수명 치환
' 	requestNumber : 요청번호(주문번호 등)
'		requestInfos : 필요정보 입력(구분자)
' ***************************************************************************************************
	Function FN_PPURIO_MESSAGE_VARIABLE_REPLACE(strCate, sendMsg, requestNumber, requestInfos)
		'metac 2022-04-25  at 주문
		If strCate = "order" Then

			if 1=2 then
				'requestInfos = "상품명|DK12345678999|2022-04-23|3,900|신용카드"
				If requestInfos <> "" Then
					On Error Resume Next
					arrRequestInfos = Split(requestInfos,"|")
					RPL_GOODS_NAME = arrRequestInfos(0)
					RPL_ORDER_NUMBER = arrRequestInfos(1)		'requestNumber
					RPL_ORDER_DATE = arrRequestInfos(2)
					RPL_ORDER_PRICE = arrRequestInfos(3)
					On Error GoTo 0
				End If
			End If

			'주문번호 기준 상품정보 가져오기
			If requestNumber <> "" Then
				arrParamsAT = Array(_
					Db.makeParam("@OrderNum",adVarChar,adParamInput,20,requestNumber) _
				)
				Set HJRSAT = Db.execRs("HJP_KAKAO_ORDER_INOFS",DB_PROC,arrParamsAT,DB3)		'카카오 알림톡 상품정보 업체별 커스텀!!(메타21)
				If Not HJRSAT.BOF And Not HJRSAT.EOF Then
					RPL_GOODS_NAME  = HJRSAT(0)
					RPL_ORDER_NUMBER  = HJRSAT(1)
					RPL_ORDER_DATE  = date8to10(HJRSAT(2))
					RPL_ORDER_PRICE  = num2cur(HJRSAT(3))
					RPL_InsuranceNumber  = HJRSAT(4)
				End If
				Call closeRS(HJRSAT)
			End If
			IF RPL_InsuranceNumber = "" Then RPL_InsuranceNumber = "입금/승인후 발급"

			sendMsg = Replace(sendMsg, "#{상품명}", RPL_GOODS_NAME)
			sendMsg = Replace(sendMsg, "#{주문번호}", RPL_ORDER_NUMBER)
			sendMsg = Replace(sendMsg, "#{주문일자}", RPL_ORDER_DATE)
			sendMsg = Replace(sendMsg, "#{결제금액}", RPL_ORDER_PRICE)
			sendMsg = Replace(sendMsg, "#{공제번호}", RPL_InsuranceNumber)

		End If

		'패스워드 초기화
		If strCate = "spwd" Then
			sendMsg = Replace(sendMsg, "#{회사명}", LNG_COPYRIGHT_COMPANY)
			sendMsg = Replace(sendMsg, "#{비밀번호}", requestInfos)
		End If

		FN_PPURIO_MESSAGE_VARIABLE_REPLACE = sendMsg
	End Function


' *****************************************************************************
' Function Name		: FN_PPURIO_FILEKEY
' Discription		: /v1/file 	MMS 발송에 사용될 이미지 파일을 업로드하는 기능입니다
'			multipart/mixed MIME
'			Charset = "ISO-8859-1"
'			fileSendResult : {"filekey":"1650012475_FD3904721247600000013.jpg"}
'			비즈뿌리오 MMS 이미지 파일 첨부시 리턴받은 filekey로 첨부!
' *****************************************************************************
	Function FN_PPURIO_FILEKEY(strImg)
		PPURIO_filekey = ""
		PPURIO_FILE_URL = PPURIO_URL&"/v1/file"
		PPURIO_FILE_BOUNDARY = "5d14GC42dS9N5BXQAKuhpRfd4VDV54RDDsTJO4"
		PPURIO_FILE_CHARSET = "ISO-8859-1"
		PPURIO_FILE_PATH = REAL_PATH("MMS_T")&"\"&BACKWORD(strImg)

		fileSendResult =  FN_SendFileData(PPURIO_FILE_PATH, PPURIO_ID, PPURIO_FILE_URL, PPURIO_FILE_BOUNDARY, PPURIO_FILE_CHARSET)
		'Call ResRW(fileSendResult,"fileSendResult")

		Dim json_filekey : Set json_filekey = JSON.parse(join(array(fileSendResult)))
		On Error Resume Next
			'200 success
			PPURIO_filekey	= json_filekey.filekey
			'Call ResRW(PPURIO_filekey,"PPURIO_filekey")
		On Error GoTo 0

		FN_PPURIO_FILEKEY = PPURIO_filekey
	End Function


' *****************************************************************************
' Function Name		: FN_SendFileData
' Discription		: 다른서버로 Multipart MIME 메시지 보내기(이미지 file 포함)
'			multipart/mixed MIME
'			Charset = "ISO-8859-1"
' *****************************************************************************
	Function FN_SendFileData(filePath, strAccount, SEND_URL, boundary, Charset)
		Dim objFile, fileName, fileExtension, contentType, fileByte
		'Dim boundary
		Dim payloadData
		Dim sendResult

		'파일체크
		With Server.CreateObject("Scripting.FileSystemObject")
			If .FileExists(filePath) Then
				Set objFile = .GetFile(filePath)

				fileName = objFile.Name
				fileExtension = .GetExtensionName(filePath)

				Set objFile = Nothing
			Else
				' 파일 없음???
				FN_SendFileData = "ERROR - 404"
			End If
		End With

		'확장자 체크
		Select Case Ucase(fileExtension)
			Case "JPG" : contentType = "image/jpeg"
			'Case "PNG" : contentType = "image/png"
			'Case "TXT" : contentType = "text/plain"
			Case Else : contentType = "application/octet-stream"
		End Select

		'boundary = String(6, "-") & Replace(Mid(Server.CreateObject("Scriptlet.TypeLib").Guid, 2, 36), "-", "")
		'boundary = "5d14GC42dS9N5BXQAKuhpRfd4VDV54RDDsTJO4"

		' 파일 스트림
		With Server.CreateObject("ADODB.Stream")
			.Type = 1
			.Mode = 3
			.Open
			.LoadFromFile filePath
			fileByte = .Read
		End With

		With Server.CreateObject("ADODB.Stream")
			.Mode = 3
			'.Charset = "UTF-8"					'{"code":2001,"description":"no Account"}
			.Charset = Charset	'	"ISO-8859-1"			'OK
			.Open
			.Type = 2

			.WriteText "--" & boundary & vbCrLf
			.WriteText "Content-Disposition: form-data; name=""account""" & vbCrLf & vbCrLf &_
				strAccount & vbCrlf &_
				vbCrLf  &_
				"--" & boundary & vbCrLf
			.WriteText "Content-Disposition: form-data; name=""file""; filename=""" & fileName & """" & vbCrLf
			.WriteText "Content-Type: """ & contentType & """" & vbCrLf & vbCrLf

				.Position = 0
				.Type = 1
				.Position = .Size
				.Write fileByte
				.Position = 0
				.Type = 2
				.Position = .Size
			.WriteText vbCrLf & "--" & boundary & "--"
				.Position = 0
				.Type = 1
			payloadData = .Read
		End With

		With Server.CreateObject("MSXML2.ServerXMLHTTP")
			.SetTimeouts 0, 60000, 300000, 300000
			.Open "POST", SEND_URL, False
			.SetRequestHeader "Content-type", "multipart/form-data; boundary=" & boundary
			.Send payloadData

			If .Status = "200" Then
				'sendResult = "OK"
				sendResult = .ResponseText
			Else
				sendResult = .ResponseText
			End If
		End With

		FN_SendFileData = sendResult

	End Function
%>
