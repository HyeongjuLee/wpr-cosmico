<!--#include virtual = "/_lib/strFunc.asp" -->
<!--#include virtual = "/_lib/json2.asp" -->
<%

	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1)
	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)

	AJAX_TF = "T"
%>
<!--#include virtual = "/Myoffice/autoship/_autoship_CONFIG.asp"-->
<%

    oIDX = pRequestTF_JSON("oIDX", True)
    INFO_CHANGE_TF = pRequestTF_JSON("INFO_CHANGE_TF", True)

    If INFO_CHANGE_TF <> "T" Then
        PRINT "{""result"":""error"",""message"":""결제 예정일 2일 전까지 수정 할 수 있습니다!""}"
        Response.End
    End If

    arrParams = Array(_
        Db.makeParam("@DK_MBID1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
        Db.makeParam("@DK_MBID2",adInteger,adParamInput,4,DK_MEMBER_ID2), _
        Db.makeParam("@oIDX",adInteger,adParamInput,0,oIDX) _
    )
    Call Db.exec("HJP_MEMBER_INFO_DELETE_CMS_AJAX",DB_PROC,arrParams,DB3)

    '이상없으면 OK
    If Err.Number = 0 Then
        PRINT "{""result"":""success"",""message"":""정상 처리되었습니다.""}"
    Else    '이상있으면...
        PRINT "{""result"":""error"",""message"":""수정처리 중 에러가 발생했습니다.""}"
    End If
%>