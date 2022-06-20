<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MY_MEMBER"
	Call FNC_ONLY_CS_MEMBER()


	Dim CATEGORYS1	:	CATEGORYS1 = Request("cate1")
	Dim CATEGORYS2	:	CATEGORYS2 = Request("cate2")


	SDK_MEMBER_ID1 = Request("sid1")
	SDK_MEMBER_ID2 = Request("sid2")
	SDK_MEMBER_ID3 = Request("sid3")


	If CATEGORYS1 = "" Then CATEGORYS1 = 1
	If CATEGORYS2 = "" Then CATEGORYS2 = 1

	If SDK_MEMBER_ID1 = "" Then SDK_MEMBER_ID1 = DK_MEMBER_ID1
	If SDK_MEMBER_ID2 = "" Then SDK_MEMBER_ID2 = DK_MEMBER_ID2
	If SDK_MEMBER_ID3 = "" Then SDK_MEMBER_ID3 = DK_MEMBER_ID3

'	PRINT DK_MEMBER_ID1
'	PRINT DK_MEMBER_ID2
'	PRINT SDK_MEMBER_ID1
'	PRINT SDK_MEMBER_ID2

	arrParams = Array(_
		Db.makeParam("@DK_MEMBER_ID",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
		Db.makeParam("@DK_MEMBER_ID2",adInteger,adParamInput,0,DK_MEMBER_ID2),_
		Db.makeParam("@SDK_MEMBER_ID",adVarChar,adParamInput,20,SDK_MEMBER_ID1),_
		Db.makeParam("@SDK_MEMBER_ID2",adInteger,adParamInput,0,SDK_MEMBER_ID2)_
	)
	arrChkData = CInt(Db.execRsData("DKP_TREE_CHECK_SUB01",DB_PROC,arrParams,DB3))
	If arrChkData < 1 Then
		Call ALERTS(LNG_CS_T_TREE_ALLOWANCE_SS_V1_ALERT01,"BACK","")
	End If

%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->

<script type="text/javascript" src="/m/js/Oc.js"></script>
<script type="text/javascript">
<!--

	$(document).ready(function(){
		$('#cate1')
		  .change(function(){
			chg_category();
		  })
		 .change();
	});

	function chg_category() {
		createRequest();
		var url = 'getMaxMBID3.asp';

		mode = "category2";
		cate = $('#cate1').val();
		smbid1 = '<%=SDK_MEMBER_ID1%>'
		smbid2 = '<%=SDK_MEMBER_ID2%>'
		//alert(smbid1);
		//alert(smbid2);
		postParams = "mode=" + mode;
		postParams += "&cate=" + cate;
		postParams += "&smbid1=" + smbid1;
		postParams += "&smbid2=" + smbid2;

		if (cate.length == 0)
		{
			$("#cate2").attr("disabled",true);
			//$("#cate2").html("<option value=''><%=LNG_CS_T_TREE_ALLOWANCE_SS_V1_JS01%></option>");
			$("#cate2").html("<option value=''><%=LNG_CS_T_TREE_ALLOWANCE_SS_V1_JS01_ZJ%></option>");
		} else {
			request.open("POST",url,true);
			request.onreadystatechange = function ChgContent() {
				if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
					if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
						var newContent = request.responseText;
						$("#cate2").attr("disabled",false);
						$("#cate2").html(newContent);
						$("#cate2").val("<%=CATEGORYS2%>");
						//alert(document.getElementById("innerMask").innerHTML);
					} else {
						alert("ajax error");
					}
				  }
				}
			request.setRequestHeader("Content-Type","application/x-www-form-urlencoded;charset=utf-8");
			request.send(postParams);
			return;
		}
	}

/*
	function submitSearch() {
		var f = document.sfrm;
			f.action = "";
			f.submit();
	}
*/

//-->
</script>
<link type="text/css" rel="stylesheet" href="/m/css/oc.css"  />
</head>
<body onunload="" >
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual = "/m/_include/sub_header.asp"-->
<div id="subTitle" class="width100 tcenter text_noline" ><%=LNG_LEFT_MYOFFICE_TEXT_02_07%></div>

<div class="cleft" style="width:100%; position:absolute; margin-top:40px;">
<!-- <div class="fleft"><a href="javascript:goScrolls('left');" data-ajax="false" ><img src="<%=IMG%>/go_left.png" width="56" height="56" style="margin-top:20px;margin-left:20px;" /></a></div>
<div class="fright"><a href="javascript:goScrolls('right');" data-ajax="false"><img src="<%=IMG%>/go_right.png" width="56" height="56" style="margin-top:20px;;margin-right:20px;" /></a></div> -->
</div>

<!--  -->
		<form name="sfrm" action="T_tree_allowance_ss_V1.asp" method="post" data-ajax="false">
			<input type="hidden" name="sid1" value="<%=SDK_MEMBER_ID1%>" />
			<input type="hidden" name="sid2" value="<%=SDK_MEMBER_ID2%>" />
			<input type="hidden" name="sid3" value="<%=SDK_MEMBER_ID3%>" />
			<!-- <input type="hidden" name="CATEGORYS1" value="<%=CATEGORYS1%>" />
			<input type="hidden" name="CATEGORYS2" value="<%=CATEGORYS2%>" /> -->
			<%
				'ZJ 각 수당후원 테이블별 존재확인
				arrParams = Array(_
					Db.makeParam("@SDK_MEMBER_ID1",adVarchar,adParamInput,20,DK_MEMBER_ID1) ,_
					Db.makeParam("@SDK_MEMBER_ID2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
				)
				Set DKRS = Db.execRs("HJP_TREE_MAX_SPON_SUB_CHECK",DB_PROC,arrParams,DB3)
				If Not DKRS.BOF And Not DKRS.EOF Then
					RS_SPON_SUB_CHK01 = DKRS(0)
					RS_SPON_SUB_CHK02 = DKRS(1)
					RS_SPON_SUB_CHK03 = DKRS(2)
					RS_SPON_SUB_CHK04 = DKRS(3)
					RS_SPON_SUB_CHK05 = DKRS(4)
				Else
					RS_SPON_SUB_CHK01 = 0
					RS_SPON_SUB_CHK02 = 0
					RS_SPON_SUB_CHK03 = 0
					RS_SPON_SUB_CHK04 = 0
					RS_SPON_SUB_CHK05 = 0
				End If
				Call CloseRS(DKRS)
			%>
			<div id="cheack_area" class="fleft" style="height:50px;background:#efefef;width:97%;">
				<div class="fleft" style="width:100%;margin-left:10px;">
					<!-- <%=LNG_CS_T_TREE_ALLOWANCE_SS_V1_TEXT02%> -->
					<%=LNG_CS_T_TREE_ALLOWANCE_SS_V1_TEXT02_ZJ%>
					<select id="cate1" name="cate1">
						<option value="" ><%=LNG_CS_T_TREE_ALLOWANCE_SS_V1_TEXT03_ZJ%><!-- <%=LNG_CS_T_TREE_ALLOWANCE_SS_V1_TEXT03%> --></option>
							<%If RS_SPON_SUB_CHK01 > 0 Then%><option value="1" <%=isSelect(CATEGORYS1,1)%>>MT 1</option><%End If%>
							<%If RS_SPON_SUB_CHK02 > 0 Then%><option value="2" <%=isSelect(CATEGORYS1,2)%>>MT 2</option><%End If%>
							<%If RS_SPON_SUB_CHK03 > 0 Then%><option value="3" <%=isSelect(CATEGORYS1,3)%>>MT 3</option><%End If%>
							<%If RS_SPON_SUB_CHK04 > 0 Then%><option value="4" <%=isSelect(CATEGORYS1,4)%>>MT 4</option><%End If%>
							<%If RS_SPON_SUB_CHK05 > 0 Then%><option value="5" <%=isSelect(CATEGORYS1,5)%>>MT 5</option><%End If%>
							<!-- <%For i= 1 To 5 %>
								<option value=<%=i%><%=isSelect(CATEGORYS1,i)%>>MT <%=i%></option>
							<%Next%> -->
					</select>
				</div>
				<div class="fleft" style="width:70%;margin-left:10px;"><!-- <%=LNG_CS_T_TREE_ALLOWANCE_SS_V1_TEXT04%> -->
					<%=LNG_CS_T_TREE_ALLOWANCE_SS_V1_TEXT04_ZJ%>
					<select id="cate2" name="cate2" disabled="disabled" onchange="submitSearch()"><option value=""></option></select>
				</div>
				<div class="fleft" style="width:20%">
					<input type="image" src="<%=IMG%>/tree/tree_search2.png" width="70" height="21" class="vmiddle cp" />
				</div>
			</div>
		</form>


<!--  -->
<ul id="org" style="display:none; width:98%;">
<%
	Select Case CATEGORYS1
		Case "1"
			PROCEDURE_NAME = "HJP_ALLOWANCE_SPON_SUB01"
			PRINT_SELLTYPE = "MT-1"
		Case "2"
			PROCEDURE_NAME = "HJP_ALLOWANCE_SPON_SUB02"
			PRINT_SELLTYPE = "MT-2"
		Case "3"
			PROCEDURE_NAME = "HJP_ALLOWANCE_SPON_SUB03"
			PRINT_SELLTYPE = "MT-3"
		Case "4"
			PROCEDURE_NAME = "HJP_ALLOWANCE_SPON_SUB04"
			PRINT_SELLTYPE = "MT-4"
		Case "5"
			PROCEDURE_NAME = "HJP_ALLOWANCE_SPON_SUB05"
			PRINT_SELLTYPE = "MT-5"
			'PROCEDURE_NAME = "HJP_BOARD_CHART_SUB05"
	End Select

	arrParams = Array(_
		Db.makeParam("@mbid1",adVarChar,adParamInput,20,SDK_MEMBER_ID1),_
		Db.makeParam("@mbid2",adInteger,adParamInput,0,SDK_MEMBER_ID2),_
		Db.makeParam("@mbid3",adInteger,adParamInput,0,CATEGORYS2),_
		Db.makeParam("@DEPTH",adInteger,adParamInput,0,2)_
	)
	arrList = Db.execRsList(PROCEDURE_NAME,DB_PROC,arrParams,listLen,DB3)

Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
	objEncrypter.Key = con_EncryptKey
	objEncrypter.InitialVector = con_EncryptKeyIV
	If IsArray(arrList) Then
		thisLevel = 0
		prevLevel = 0
		For i = 0 To listLen
			TrID = arrList(0,i)&arrList(1,i)&arrList(2,i)
			PaID = arrList(4,i)&arrList(5,i)&arrList(6,i)

			'arrList(2,i) = arrList(2,i) - 1

			'WebID
			arrParams = Array(_
				Db.makeParam("@mbid",adVarChar,adParamInput,20,arrList(0,i)), _
				Db.makeParam("@mbid2",adInteger,adParamInput,0,arrList(1,i)) _
			)
			Set DKRS = Db.execRs("DKP_MEMBER_INFO",DB_PROC,arrParams,DB3)
			If Not DKRS.BOF And Not DKRS.EOF Then
				DKRS_WebID		= DKRS("WebID")
				On Error Resume Next
					'If DKRS_WebID	<> "" Then DKRS_WebID	= objEncrypter.Decrypt(DKRS_WebID)
				On Error GoTo 0
			Else
				'Call ALERTS(LNG_MYPAGE_INFO_COMPANY_TEXT02,"back","")
			End If
			Call closeRS(DKRS)


			If i = 0 Then
				PRINT "<li class=""fnode w100""><p class=""sellType_"&CATEGORYS1&""">"&PRINT_SELLTYPE&"</p><p style=""font-weight:bold;"" "&liClass&"><a href=""?sid1="&arrList(4,i)&"&amp;sid2="&arrList(5,i)&"&amp;sid3="&arrList(6,i)&"&CATE1="&CATEGORYS1&"&CATE2="&arrList(6,i)&""">"&LNG_CS_T_TREE_ALLOWANCE_SS_V1_TEXT05&"</a></p>"
				PRINT "<p style=""font-weight:bold;"" "&liClass&"><a href=""?sid1="&arrList(0,i)&"&amp;sid2="&arrList(1,i)&"&amp;sid3="&arrList(6,i)&"&CATE1="&CATEGORYS1&"&CATE2="&CATEGORYS2&""">"&arrList(0,i)&"-"&Fn_MBID2(arrList(1,i))&"-"&arrList(2,i)&"</a></p>"
				'PRINT "<br />"
				PRINT "<p "&liClass&"><!-- "&LNG_CS_T_TREE_ALLOWANCE_SS_V1_TEXT06&" :  -->"&arrList(3,i)&"</p>"
				'PRINT "<p "&liClass&" style=""height:13px;"">"&objEncrypter.Decrypt(arrList(10,i))&"</p>"
				PRINT "<p "&liClass&" style=""height:13px;"">"&DKRS_WebID&"</p>"
				PRINT "<p "&liClass&">"&date8to10(arrList(11,i))&"</p>"
				'PRINT "<p "&liClass&">"&arrList(2,i)&"차</p>"
				PRINT "<ul id=""T"&TrID&"""></ul></li>"
			Else
				innerHTML = "<li class=""fnode2 w100""><p class=""sellType_"&CATEGORYS1&""">"&PRINT_SELLTYPE&"</p><p  style=""font-weight:bold;"" "&liClass&"><a href=""?sid1="&arrList(0,i)&"&amp;sid2="&arrList(1,i)&"&amp;sid3="&arrList(2,i)&"&CATE1="&CATEGORYS1&"&CATE2="&arrList(2,i)&""">"&arrList(0,i)&"-"&Fn_MBID2(arrList(1,i))&"-"&arrList(2,i)&"</a></p>"
				'innerHTML = innerHTML & "<br />"
				innerHTML = innerHTML & "<p "&liClass&"><!-- "&LNG_CS_T_TREE_ALLOWANCE_SS_V1_TEXT06&" :  -->"&arrList(3,i)&"</p>"
				'innerHTML = innerHTML & "<p "&liClass&" style=""height:13px;"">"&objEncrypter.Decrypt(arrList(10,i))&"</p>"
				innerHTML = innerHTML & "<p "&liClass&" style=""height:13px;"">"&DKRS_WebID&"</p>"
				innerHTML = innerHTML & "<p "&liClass&">"&date8to10(arrList(11,i))&"</p>"
				'innerHTML = innerHTML & "<p "&liClass&">"&LNG_CS_T_TREE_ALLOWANCE_SS_V1_TEXT07&" : "&arrList(2,i)&"차</p>"
				innerHTML = innerHTML & "<ul id=""T"&TrID&"""></ul></li>"
				trees = trees & "$(""#T"&PaID&""").append('"&innerHTML&"');"&VbCrlf
			End If
		Next
	End If
	Set objEncrypter = Nothing

%>
</ul>
<div id="chart" class="orgChart"></div>
<script type="text/javascript" language="JScript.Encode">
	//waiting.style.visibility="hidden"
	<%=trees%>

	jQuery(document).ready(function() {

		$('#list-html').text($('#org').html());
		$("#org").bind("DOMSubtreeModified", function() {
			$('#list-html').text('');
			$('#list-html').text($('#org').html());
		});

		var ftableWidth = $("div.jOrgChart table:first-child").width();
		var moveWidth = (ftableWidth/2)-($(window).width()/2)
		$("div.jOrgChart").scrollLeft(moveWidth);
		//alert(moveWidth);
	});


	function goScrolls(moveS) {
		var nowXC = $("div.jOrgChart").scrollLeft();

		var movXC = 100
		var brwXC = $(window).width();
		// alert(brwXC);
		if (moveS == 'left')
		{
			$("div.jOrgChart").scrollLeft(nowXC-brwXC+movXC);

		} else {
			$("div.jOrgChart").scrollLeft(nowXC+brwXC-movXC);


		}



	}
</script>


<!--#include virtual = "/m/_include/copyright.asp"-->