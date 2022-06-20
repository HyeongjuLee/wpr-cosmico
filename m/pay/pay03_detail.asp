<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include file="payFunc.asp" -->
<%
	Call ONLY_MEMBER_CLOSE(DK_MEMBER_LEVEL)			'세션/쿠키 만료 체크

	MODES = Request("MODES")
	EDATE = Request("EDATE")
	PAGE = Request("PAGE")
	viewID = Request("viewID")
	AJAX_URL = Request("AJAX_URL")

	If PAGE = ""		Then PAGE = 1
	If PAGESIZE = ""	Then PAGESIZE = 5


	SORTORDER1 = MODES

	PROCEDURE_NAME = "DKPS_CS_PRICE03_DETAIL_NEW"

	Select Case MODES
		Case "1"
			TABLE_TITLE = LNG_TEXT_PAY_BONUS03_1
		Case "2"
			TABLE_TITLE = LNG_TEXT_PAY_BONUS03_2
		Case "3"
			TABLE_TITLE = LNG_TEXT_PAY_BONUS03_3
		Case "4"
			TABLE_TITLE = LNG_TEXT_PAY_BONUS03_4
		Case "5"
			TABLE_TITLE = LNG_TEXT_PAY_BONUS03_5
		Case "6"
			TABLE_TITLE = LNG_TEXT_PAY_BONUS03_6
		Case "7"
			TABLE_TITLE = LNG_TEXT_PAY_BONUS03_7
		Case "8"
			TABLE_TITLE = LNG_TEXT_PAY_BONUS03_8

	End Select

' print DK_MEMBER_ID1
' print DK_MEMBER_ID2
' print EDATE
' print SORTORDER1



	arrParams = Array(_
		Db.makeParam("@MBID1",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
		Db.makeParam("@MBID2",adInteger,adParamInput,4,DK_MEMBER_ID2),_
		Db.makeParam("@EDATE",adVarChar,adParamInput,10,EDATE),_
		Db.makeParam("@SORTORDER1",adVarChar,adParamInput,10,SORTORDER1),_
		Db.makeParam("@PAGE",adInteger,adParamInput,4,PAGE),_
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,4,PAGESIZE),_
		Db.makeParam("@ALL_Count",adInteger,adParamOutput,4,0)_
	)
	arrList = Db.execRsList(PROCEDURE_NAME,DB_PROC,arrParams,listLen,DB3)
	ALL_COUNT = arrParams(UBound(arrParams))(4)

	Dim PAGECOUNT,CNT
	PAGECOUNT = Int((CCur(ALL_COUNT) - 1 ) / CInt(PAGESIZE) ) + 1
	IF CCur(PAGE) = 1 Then
		CNT = ALL_COUNT
	Else
		CNT = ALL_COUNT - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
	End If


%>

					<script type="text/javascript">
					$(function(){
						$(".icon-cancel").on('click', function(){
							$('.payment_blocker').hide();
							$('#payment_detail_body').empty();
							$('.payment_detail').hide();
						});
					})
				</script>
				<div class="close"><i class="icon-cancel"></i></div>
				<h5><%=TABLE_TITLE%></h5>
				<div class="pay_inDivWrap width100">
					<% If IsArray(arrList) Then %>
					<table <%=tableatt%> class="width100 table1">
						<colgroup>
							<col width="32" />
							<col width="" />
							<col width="" />
							<col width="" />
							<col width="32" />
							<col width="32" />
						</colgroup>
						<thead>
							<tr>
								<th></th>
								<th><%=LNG_TEXT_MEMID%></th>
								<th><%=LNG_TEXT_NAME%></th>
								<th><%=LNG_TEXT_PAY_PRICE%></th>
								<th><%=LNG_TEXT_LEVEL%></th>
								<th><%=LNG_TEXT_LINE%></th>
							</tr>
						</thead>
						<%
							For i = 0 To listLen
						%>
						<tr>
							<td class="tcenter f12"><%=arrList(0,i)%></td>
							<td class="tcenter f12"><%=arrList(1,i)%>-<%=arrList(2,i)%></td>
							<td class="tcenter f12"><%=arrList(3,i)%></td>
							<td class="tright  f12"><%=num2cur(arrList(4,i))%></td>
							<td class="tcenter f12"><%=arrList(5,i)%></td>
							<td class="tcenter f12"><%=arrList(6,i)%></td>
						</tr>
						<%Next%>
					</tbody>
				</table>
				<div class="paging_area pagingNew"><%Call pageList_payM(PAGE,PAGECOUNT,MODES,EDATE,viewID,AJAX_URL)%></div>
				
				<%Else%>
				<table class="width100">
					<tbody>
						<tr class="nodata">
							<td class="nodata" colspan="6"><p><%=LNG_TEXT_NO_DATA%></p></td>
						</tr>
					</tbody>
				</table>
			<%End If%>
		</div>



