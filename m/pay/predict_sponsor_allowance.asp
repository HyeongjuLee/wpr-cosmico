<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "PAY"
	Call FNC_ONLY_CS_MEMBER()


'	*후원 예측 수당(2015-12-01)
'	- 보여주기 마감과 관계 없이 [최종 마감 종료 후]에서 [현재 까지]의 후원 수당만 예측 가능하게 부탁 드립니다.
'
'	예)  현재 보여주기 - 11/8~11/14
'		최종마감 - 11/15~11/21
'		후원예측 - 11/22~현재까지
'
'	- 만일 최종 마감인 11/15~11/21 까지의 마감을 풀었을 경우
'	  최종 마감은 11/14까지이며 후원 예측 수당은 11/15~현재까지의 예측 수당을 보여 주시면 될것 같습니다


	If SDATE = "" Then SDATE = ""
	EDATE = Left(now,10)


	'print EDATE



%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<script type="text/javascript" src="/m/js/calendar.js"></script>
<link rel="stylesheet" href="buy.css" />
</head>
<body  onunload="">
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual = "/m/_include/sub_header.asp"-->
<div id="subTitle" class="width100 tcenter text_noline" >예측 후원수당</div>

<p class="sub_title">리스트</p>
	<table <%=tableatt%> class="width100 pays purchase">
		<colgroup>
			<col width="25%" />
			<col width="25%" />
			<col width="25%" />
			<col width="25%" />
		</colgroup>
		<thead>
			<tr>
				<th>이월기준일<br />(라인)</th>
				<th class="">주마감이월</th>
				<th>예상하선BV</span></th>
				<th class="">예상하선 총BV</th>
				<!-- <th>예측후원수당</th> -->
			</tr>
		</thead>
		<%
			arrParams = Array(_
				Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
				Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2), _
				Db.makeParam("@EDATE",adVarChar,adParamInput,10,EDATE) _
			)
			arrList = Db.execRsList("DKP_CLOSEPAY_11_AFTER_PV",DB_PROC,arrParams,listLen,DB3)
			If IsArray(arrList) Then
				For i = 0 To listLen

				LineCnt		 = arrList(4,i)
				SUMPVP		 = arrList(5,i)
				SUMPVM		 = arrList(6,i)
				Sum_PV_1_2	 = arrList(7,i)			'마지막 주간마감 라인별 이월값
				SETDATE		 = arrList(8,i)			'마지막 마감일

				If Sum_PV_1_2 < 0 Then Sum_PV_1_2 = 0  '이월값 :마이너스값은 0으로처리

				REMAIN_SUMPV = SUMPVP + SUMPVM		'잔여pv
				REMAIN_SUMGV_Sum_PV_1_2 = REMAIN_SUMPV + Sum_PV_1_2

			'	If Sum_PV_1_2 = 0 Then
			'		SPON_PREDICT_ALLOWANCE = REMAIN_SUMGV_Sum_PV_1_2
			'	End If
			'	If Sum_PV_1_2 > 0 Then
			'		SPON_PREDICT_ALLOWANCE = 0
			'	End If


				If LineCnt = 1 Then REMAIN_SUMGV_Sum_PV_1 = REMAIN_SUMGV_Sum_PV_1_2
				If LineCnt = 2 Then REMAIN_SUMGV_Sum_PV_2 = REMAIN_SUMGV_Sum_PV_1_2

				If REMAIN_SUMGV_Sum_PV_1 < REMAIN_SUMGV_Sum_PV_2 Then
					SMALL_PRICE = REMAIN_SUMGV_Sum_PV_1
				ElseIf  REMAIN_SUMGV_Sum_PV_1 > REMAIN_SUMGV_Sum_PV_2 Then
					SMALL_PRICE = REMAIN_SUMGV_Sum_PV_2
				ElseIf  REMAIN_SUMGV_Sum_PV_1 = REMAIN_SUMGV_Sum_PV_2 Then
					SMALL_PRICE = 0
				End If

				SPON_PREDICT_ALLOWANCE = SMALL_PRICE

				'10	회원
				'20	브론즈				12%
				'30	실버				15%
				'40	골드				18%
				'50	플래티넘			20%
				If nowGradeCnt > 50 Then
					SPON_PREDICT_ALLOWANCE = SPON_PREDICT_ALLOWANCE * 0.2
				Else
					Select Case nowGradeCnt
						Case "10"
							SPON_PREDICT_ALLOWANCE = SPON_PREDICT_ALLOWANCE * 0
						Case "20"
							SPON_PREDICT_ALLOWANCE = SPON_PREDICT_ALLOWANCE * 0.12
						Case "30"
							SPON_PREDICT_ALLOWANCE = SPON_PREDICT_ALLOWANCE * 0.15
						Case "40"
							SPON_PREDICT_ALLOWANCE = SPON_PREDICT_ALLOWANCE * 0.18
						Case "50"
							SPON_PREDICT_ALLOWANCE = SPON_PREDICT_ALLOWANCE * 0.2
					End Select
				End If

				'If SPON_PREDICT_ALLOWANCE = 0 Then SPON_PREDICT_ALLOWANCE = ""

		%>
		<tr>
			<td class="tcenter">
				<%=date8to10(SETDATE)%>
				<br />( <%=arrList(4,i)%> )
			</td>
			<td class="tright"><%=num2cur(Sum_PV_1_2)%> <!-- BV --></td>
			<td class="tright"><%=num2cur(REMAIN_SUMPV)%> <!-- BV --></span></td>
			<td class="tright"><%=num2cur(REMAIN_SUMGV_Sum_PV_1_2)%> <!-- BV --></td>
		</tr>

		<%
					Next
				Else
					PRINT TABS(1)& "	<tr>"
					PRINT TABS(1)& "		<td colspan=""7"" class=""notData"">후원하선이 존재하지 않습니다</td>"
					PRINT TABS(1)& "	</tr>"
				End If
		%>
		<tfoot>
			<tr>
				<th class="tweight" colspan="3" style="line-height:35px;" >예측 후원수당</th>
				<th class="tweight blue"><%=num2cur(SPON_PREDICT_ALLOWANCE)%></th>
			</tr>
		</tfoot>

	</table>

<!--#include virtual = "/m/_include/copyright.asp"-->