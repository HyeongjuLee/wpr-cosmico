<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_lib/json2.asp"-->
<%
'한글 깨짐방지

	Response.CharSet = "UTF-8"
	Response.AddHeader "Expires","-1"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "cache-control", "no-store"

	If DK_MEMBER_TYPE <> "ADMIN" Then 
		PRINT "{""result"" : ""error"", ""resultMsg"" : ""권한이 없습니다. 다시 로그인 후 이용 바랍니다.""}"
		Response.End
	End If

    centerType = Request.Form("centerType")
    centerCode = Request.Form("centerCode")
    message = Request.Form("centerCode")
    url = Request.Form("url")
    
    if centerType = "" Then
        PRINT "{""result"" : ""error"", ""resultMsg"" : ""필수 정보가 없습니다.[centerType]""}"
		Response.End
    End If

    If centerCode = "" Then
        PRINT "{""result"" : ""error"", ""resultMsg"" : ""필수 정보가 없습니다.[centerCode]""}"
		Response.End
    End If

    If message = "" Then
        PRINT "{""result"" : ""error"", ""resultMsg"" : ""필수 정보가 없습니다.[message]""}"
		Response.End
    End If

    Dim JsonObj, dataObj, tokens(0)
    Set JsonObj = jsObject()
    Set dataObj = jsObject()
    
    JsonObj("apiKey") = FCM_API_KEY
    
    '센터별 회원 정보 가져오기
    arrParams = Array( _
		Db.makeParam("@CENTER_CODE",adVarChar,adParamInput,30,centerCode) _
	)
	arrList = Db.execRsList("DKP_MEMBER_PUSH_CENTER_INFO",DB_PROC,arrParams,listLen,DB3)

    strToken = ""

    If IsArray(arrList) Then
        For i=0 To listLen
            If Len(strToken) > 0 Then
                strToken = strToken&","
            End If

            strToken = strToken & arrList(0, i)
        Next
    End If

    JsonObj("to") = split(strToken, ",")

    dataObj("title") = DKCONF_SITE_TITLE & " 알림"
    dataObj("body") = message
    dataObj("url") = url
    
    If centerType = "D" Then
        pushType = ""
    ElseIf centerType = "N" Then
        pushType = "alert"
    ElseIf centerType = "N" Then
        pushType = "confirm"
    End If
    
    dataObj("pushType") = pushType

    Set JsonObj("data") = dataObj

    '데이터 로그 쌓기
     arrParams = Array( _
        Db.makeParam("@method",adVarChar,adParamInput,100,"center"), _
		Db.makeParam("@pushdata",adLongVarWChar,adParamInput,10000,toJSON(JsonObj)), _
        Db.makeParam("@sender",adVarChar,adParamInput,30,DK_MEMBER_ID) _
	)
	Call Db.exec("HWP_PUSH_LOG_INSERT",DB_PROC,arrParams,DB3)

    Set oXmlhttp = server.CreateObject("Msxml2.ServerXMLHTTP.3.0")

        oXmlhttp.setOption 2, 13056
        oXmlhttp.open "POST", FCM_SEND_URL, False
'        oXmlhttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded;charset=UTF-8"
        oXmlhttp.setRequestHeader "Accept-Language","UTF-8"
        oXmlhttp.setRequestHeader "CharSet", "UTF-8"
        oXmlhttp.setRequestHeader "Content", "text/html;charset=UTF-8"
        oXmlhttp.SetRequestHeader "Content-Type", "application/json"
        oXmlhttp.setRequestHeader "Content-Length", Len(oXmlParam)
        oXmlhttp.send toJSON(JsonObj)

        oResponse  = oXmlhttp.responseText
        oXmlStatus = oXmlhttp.status

    Set oXmlhttp = Nothing '개체 소멸

    if oXmlStatus <> "200" Then
        PRINT "{""result"" : ""error"", ""resultMsg"" : ""푸시메세지 전송 중 오류가 발생했습니다.""}"
	    Response.End
    Else
        Dim jsonData : Set jsonData = JSON.parse(join(array(oResponse)))

        If jsonData.result = "success" Then
            PRINT "{""result"" : ""success"", ""resultMsg"" : ""전송이 완료되었습니다.""}"
	        Response.End
        Else
            PRINT "{""result"" : ""error"", ""resultMsg"" : ""푸시메세지 전송 중 오류가 발생했습니다.""}"
	        Response.End
        End If
    End If
%>
