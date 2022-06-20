<!--#include virtual = "/_lib/strFunc.asp"-->
<%
    if getUserIP <> "106.243.121.208" Then
        Response.End
    End If

    startDate       = gRequestTF("startDate",False)
    endDate         = gRequestTF("endDate",False)
    jsonp           = gRequestTF("callback",False)

    arrParams = Array(_
        Db.makeParam("@startDate",adVarChar,adParamInput,10,replace(startDate,"-","") ), _
        Db.makeParam("@endDate",adVarChar,adParamInput,10,replace(endDate,"-","")) _
    )
    Set DKRS = Db.execRs("HWP_SELLCHECK",DB_PROC,arrParams,DB3)

    If Not DKRS.EOF And Not DKRS.BOF Then

        sumPV           = DKRS(0)
        sumPrice        = DKRS(1)
        sumOrderNum     = DKRS(2)
        sumMemCount     = DKRS(3)

        PRINT jsonp & "({""result"" : ""success"", ""resultMsg"" : ""success"", ""data"" : {""sumPrice"" : """&sumPrice&""", ""sumPV"" : """&sumPV&""", ""orderCnt"" : """&sumOrderNum&""", ""memCnt"" : """&sumMemCount&"""}})"
    Else

        sumPV           = 0
        sumPrice        = 0
        sumOrderNum     = 0
        sumMemCount     = 0

        PRINT jsonp & "({""result"" : ""success"", ""resultMsg"" : ""success"", ""data"" : {""sumPrice"" : """&sumPrice&""", ""sumPV"" : """&sumPV&""", ""orderCnt"" : """&sumOrderNum&""", ""memCnt"" : """&sumMemCount&"""}})"

    End If

%>