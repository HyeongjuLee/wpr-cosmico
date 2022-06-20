<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<!--#include file = "mmsConfig.asp"-->
<%
	ADMIN_LEFT_MODE = "MANAGE"
	INFO_MODE = "MANAGE9-1"


	arrParams = Array(_
		Db.makeParam("@strComName",adVarChar,adParamInput,20,MSG_strComName) _
	)
	Set DKRS = Db.execRs("DKP_MMS_STAT",DB_PROC,arrParams,DB5)

	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_intIDX				= DKRS("intIDX")
		DKRS_strComName			= DKRS("strComName")
		DKRS_intTotalPrice		= DKRS("intTotalPrice")
		DKRS_intSendPrice		= DKRS("intSendPrice")
	Else
		Call ALERTS("메세지 서비스를 사용을 하지 않는 사이트입니다.","BACK","")
	End If



%>
<link rel="stylesheet" href="mms.css" />

</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="sms" class="">
	<p class="titles">메세지 서비스 상태</p>
	<table <%=tableatt%> class="width100 config">
		<col width="180" />
		<col width="350" />
		<col width="*" />
		<tr>
			<th>메세지 전송아이디</th>
			<td class="content tweight"><%=MSG_strComName%></td>
			<td class="summary">메세지 전송에 사용하는 아이디입니다.</td>
		</tr><tr>
			<th>메세지 충전누적액</th>
			<td class="content"><strong><%=num2cur(DKRS_intTotalPrice)%></strong> 원 충전</td>
			<td class="summary">현재까지 총 누적된 메세지 충전금액입니다.</td>
		</tr><tr>
			<th>메세지 사용금액</th>
			<td class="content"><strong><%=num2cur(DKRS_intSendPrice)%></strong> 원 사용</td>
			<td class="summary">SMS 전송한 건수입니다.</td>
		</tr><tr>
			<th>메세지 전송가능액</th>
			<td class="content"><strong><%=num2cur((DKRS_intTotalPrice-DKRS_intSendPrice))%></strong> 원 사용가능</td>
			<td class="summary">메세지 전송 가능한 금액입니다. 0원이 되면 메세지 발송이 되지 않습니다.</td>
		</tr>
	</table>

	<p class="titles">메세지 서비스 가격표</p>
	<table <%=tableatt%> class="width100 price">
		<col width="180" />
		<col width="350" />
		<col width="180" />
		<col width="*" />
		<tr>
			<th>형식</th>
			<th>구분</th>
			<th>차감액</th>
			<th>비고</th>
		</tr><tr>
			<th>SMS</th>
			<td class="tcenter"><strong>80</strong> byte</td>
			<td class="tcenter"><%=MSG_SMS_PRICE%>원 / 건</td>
			<td>80 바이트 미만의 메세지 서비스</td>
		</tr><tr>
			<th>LMS</th>
			<td class="tcenter"><strong>2,000</strong> byte</td>
			<td class="tcenter"><%=MSG_LMS_PRICE%>원 / 건</td>
			<td>2,000 바이트 미만의 메세지 서비스</td>
		</tr><tr>
			<th>MMS</th>
			<td class="tcenter"><strong>LMS + IMAGE</strong></td>
			<td class="tcenter"><%=MSG_MMS_PRICE%>원 / 건</td>
			<td>이미지 단독첨부시에도 MMS 로 구분</td>
		</tr>
	</table>
	<p class="titles">메세지 서비스 비고</p>
	<ul class="tweight">
		<li>1. 최소 결제 금액은 <span class="red">충전시 500,000 원</span>입니다.</li>
		<li>2. 최소 결제 금액이상 충전 시 100,000원 단위로 추가충전이 가능합니다.</li>
		<li>3. 통신사 상관없이 차감금액은 동일합니다.</li>
		<li>4. 기존 SMS 방식은 건별 차감이였으나, 메세지 서비스는 구분에 따라 금액이 상이하여 상기가격표 대로 금액이 차감됩니다.</li>
		<li>5. 전송내역 조회는 최근 1년분의 데이터만 제공합니다.</li>
	</ul>
</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
