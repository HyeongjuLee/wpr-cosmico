
<%@Language="VBScript" CODEPAGE=65001%>

<%
' Turn off error Handling
On Error Resume Next

Response.CharSet="utf-8" 
Session.codepage="65001" 
Response.codepage="65001" 
Response.ContentType="text/html;charset=UTF-8"
%>




<%
servicecode     =   "PAYTAG"        '   필수 : 고정값
schtype			=   "202002"        '   필수 : 조회월
schvalue			=   "10"
paytag_apiurl   =   "https://api.paytag.kr/halbu"       ' 필수 : 고정값 ( rest 주소값 )

requestData = "schdate="&schdate&"&servicecode="&servicecode&"&schtype="&schtype&"&schvalue="&schvalue

           
                
'response.write "body:" & REQ_BODY_STR & "<br>"                
%>



<!--#include file="aspJSON1.17.asp" -->


<%
Set xmlClient = Server.CreateObject("Msxml2.ServerXMLHTTP.6.0")
xmlClient.setTimeouts 5000, 5000, 30000, 30000

xmlClient.open "POST", paytag_apiurl, FALSE

xmlClient.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
xmlClient.setRequestHeader "CharSet", "UTF-8" 
xmlClient.setRequestHeader "Accept-Language","ko"
xmlClient.send requestData


' 서버 다운이나.. 없는 도메인일 경우 
If Err.Number = 0 Then

    server_status = xmlClient.Status

    If server_status >= 400 And server_status <= 599 Then
        
        Err.Raise 1020, "error", "서버오류["&server_status&"]"
        call onErrorCheckDefault()
    else
    
        Set responseStrm = CreateObject("ADODB.Stream") 
        responseStrm.Open 
        responseStrm.Position = 0 
        responseStrm.Type = 1 
        responseStrm.Write xmlClient.responseBody 
        responseStrm.Position = 0 
        responseStrm.Type = 2 
        responseStrm.Charset = "UTF-8"
        resultStr = responseStrm.ReadText 

        responseStrm.Close
        Set responseStrm = Nothing

        'response.write resultstr 


        Set oJSON = New aspJSON
        oJSON.loadJSON(resultStr)
        resultcode=  oJSON.data("resultcode")
        errmsg    =  oJSON.data("errmsg")
        

        if resultcode <> "0000" then
            Err.Raise 999, "error", errmsg
            call onErrorCheckPage()  
        end if 

        
    End If
    

Else
    Err.Raise 9999, "error", err.description
    call onErrorCheckDefault()
End If

Set xmlClient = Nothing
%>


<%
'===========================================================================
' on error resumt Next 에러 처리 함수
'===========================================================================
sub onErrorCheckDefault()
    if err.number <> 0 Then

        errCode     =   err.number
        errMessage  =   err.description
        %>
            {
                "resultcode":"<%=errCode%>",
                "errmsg":"<%=errMessage%>"
            }
        <%       
        response.end 

    end if 
end sub 
%>


<%

' ######################################################################
'	getHalbuCardNAme		: 할부이벤트 카드사명
' ######################################################################
Function getHalbuCardNAme(ByVal cardcode)

	If cardcode = "BC" Then
		getHalbuCardNAme = "비씨카드"
	ElseIf cardcode = "KB" Then
		getHalbuCardNAme = "국민카드"
	ElseIf cardcode = "SH" Then
		getHalbuCardNAme = "신한카드 "
	ElseIf cardcode = "SS" Then
		getHalbuCardNAme = "삼성카드"
	ElseIf cardcode = "HD" Then
		getHalbuCardNAme = "현대카드"
	ElseIf cardcode = "NH" Then
		getHalbuCardNAme = "농협카드"
	ElseIf cardcode = "HA" Then
		getHalbuCardNAme = "하나카드"
	ElseIf cardcode = "LT" Then
		getHalbuCardNAme = "롯데카드"	
	Else
		getVbankName = value
	End if

End Function 
%>


             <h4 class="margin-bottom-30 text-bold text-green"><%=left(schdate,4)%>년 <%=right(schdate,2)%>월 신용카드할부행사 안내</span></h4>



        <h5 class="over-title margin-bottom-15 text-bold">1. 무이자할부행사</span></h5>
        <table class="table table-bordered table-condensed">
            <thead>
                <tr class="success">
                    <th class="text-center" style='min-width:1px; white-space:nowrap;'>카드사</th>
                    <th class="text-center" style='min-width:1px; white-space:nowrap;'>할부기간</th>
                    <th class="text-center" style='min-width:1px; white-space:nowrap;'>비고</th>
                </tr>
            </thead>
            <tbody>
       
                <%
                
                'Loop through collection
                For Each halbuinfo In oJSON.data("halbulist")
                    Set this = oJSON.data("halbulist").item(halbuinfo)

                    nonevent_cardgubun  =   this.item("cardgubun") 
                    nonevent_contents   =   this.item("contents")
                    nonevent_bigo       =   this.item("bigo")
                    %>
                    <tr>
                        <td><%=getHalbuCardNAme(nonevent_cardgubun)%></td>
                        <td><%=nonevent_contents%></td>
                        <td><%=nonevent_bigo%></td>
                    </tr>
                <%
                Next
                %>

            </tbody>
        </table>


        <h5 class="over-title margin-bottom-15 text-bold">2. 부분무이자할부행사</span></h5>
        <table class="table table-bordered table-condensed">
            <thead>
                <tr class="success">
                    <th class="text-center" style='min-width:1px; white-space:nowrap;'>카드사</th>
                    <th class="text-center" style='min-width:1px; white-space:nowrap;'>할부기간</th>
                    <th class="text-center" style='min-width:1px; white-space:nowrap;'>비고</th>
                </tr>
            </thead>
            <tbody>
       
                <%               
                'Loop through collection
                For Each halbuinfo In oJSON.data("slimlist")
                    Set this = oJSON.data("slimlist").item(halbuinfo)

                    nonevent_cardgubun  =   this.item("cardgubun") 
                    nonevent_contents   =   this.item("contents")
                    nonevent_bigo       =   this.item("bigo")
                    %>
                    <tr>
                        <td><%=getHalbuCardNAme(nonevent_cardgubun)%></td>
                        <td><%=nonevent_contents%></td>
                        <td><%=nonevent_bigo%></td>
                    </tr>
                <%
                Next
                %>

            </tbody>
        </table>

 <span class="text-danger">
 <%=oJSON.data("halbubigo")%>
</span>