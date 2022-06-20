<%
    Function FnPushMessage(ByRef toList, ByVal message, ByVal url, ByVal method, ByVal sendTo)
        Dim JsonObj, dataObj, tokens(0)
        Set JsonObj = jsObject()
        Set dataObj = jsObject()

        JsonObj("apiKey") = FCM_API_KEY

        toArray = split(toList, ",")
        JsonObj("to") = toArray

        dataObj("title") = "프리먼스 알림"
        dataObj("body") = message
        dataObj("url") = url

        If len(url) > 0 Then
            dataObj("pushType") = "confirm"
        Else
            dataObj("pushType") = "alert"
        End If

        Set JsonObj("data") = dataObj

        '데이터 로그 쌓기
        arrParams = Array( _
            Db.makeParam("@method",adVarChar,adParamInput,100,method), _
            Db.makeParam("@pushdata",adLongVarWChar,adParamInput,10000,toJSON(JsonObj)), _
            Db.makeParam("@sender",adVarChar,adParamInput,30,sendTo) _
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
    End Function

%>