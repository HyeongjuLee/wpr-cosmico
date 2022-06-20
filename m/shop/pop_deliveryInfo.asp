<!--#include virtual ="/_lib/strFunc.asp" -->
<!--#include virtual ="/m/_include/document.asp" -->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<%
	'jQuery Modal Dialog
	If Not (checkRef(houUrl &"/m/shop/pop_deliveryInfo.asp") _
			Or checkRef(houUrl &"/m/shop/order.asp") _
			Or checkRef(houUrl &"/m/buy/order.asp")) Then
		Call alerts(LNG_ALERT_WRONG_ACCESS,"close_p_modal","")
	End If
%>
<script type="text/javascript">
	//modal
	function insertThisAddress(val1,val2,val3,val4,val5,val6) {
		parent.$("input[name=takeName]").val(val1).addClass("readonly").attr("readonly",true);
		if (val5 != ""){
			parent.$("input[name=takeTel]").val(val5).addClass("readonly").attr("readonly",true);
		}else{
			parent.$("input[name=takeTel]").val(val5).removeClass("readonly").attr("readonly",false);;
		}
		if (val6 != ""){
			parent.$("input[name=takeMobile]").val(val6).addClass("readonly").attr("readonly",true);
		}else{
			parent.$("input[name=takeMobile]").val(val6).removeClass("readonly").attr("readonly",false);;
		}
		parent.$("input[name=takeZip]").val(val2);
		parent.$("input[name=takeADDR1]").val(val3);
		parent.$("input[name=takeADDR2]").val(val4).addClass("readonly").attr("readonly",true);
		parent.$("#takeZipBtn").hide();
		parent.$("#modal_view").dialog("close");
	}
</script>
<link rel="stylesheet" href="/m/css/modal.css?v0">
<style>
	#pop_search .tables th, #pop_search .tables td {border-right: 1px solid #ccc; font-size: 2.3rem;}
	#pop_search .tables th:last-of-type {border-right: none;}
	#pop_search .tables td:last-of-type {border-right: none;}
</style>
</head>
<body>
<div id="pop_search" class="width100">
	<div class="cleft width100 tables">
		<table <%=tableatt1%> class="width100">
			<colgroup>
				<col width="20%" />
				<col width="60%" />
				<col width="20%" />
			</colgroup>
			<thead>
				<tr>
					<th><%=LNG_TEXT_DELIVERY_NAME%></th>
					<th><%=LNG_TEXT_ADDRESS1%></th>
					<th><%=LNG_TEXT_CONTACT_NUMBER%></th>
				</tr>
			</thead>
			<%
				arrParams_R = Array(_
					Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
					Db.makeParam("@mbid2",adInteger,adParamInput,4,DK_MEMBER_ID2) _
				)
				arrList_R = Db.execRsList("HJP_DELIVERY_INFOS",DB_PROC,arrParams_R,listLen_R,DB3)
				If IsArray(arrList_R) Then
					Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
					objEncrypter.Key = con_EncryptKey
					objEncrypter.InitialVector = con_EncryptKeyIV
					On Error Resume Next
					For i = 0 To listLen_R
						arr_Get_Name1	=	arrList_R(0,i)
						arr_Get_ZipCode	=	arrList_R(1,i)
						arr_Get_Address1	=	arrList_R(2,i)
						arr_Get_Address2	=	arrList_R(3,i)
						arr_Get_Tel1 =	arrList_R(4,i)
						arr_Get_Tel2 =	arrList_R(5,i)

						If arr_Get_Address1	<> "" Then arr_Get_Address1	= objEncrypter.Decrypt(arr_Get_Address1)
						If arr_Get_Address2	<> "" Then arr_Get_Address2	= objEncrypter.Decrypt(arr_Get_Address2)
						If arr_Get_Tel1	<> "" Then arr_Get_Tel1	= objEncrypter.Decrypt(arr_Get_Tel1)
						If arr_Get_Tel2	<> "" Then arr_Get_Tel2	= objEncrypter.Decrypt(arr_Get_Tel2)

						brTag = ""
						If arr_Get_Tel1 <> "" Then
							arr_Get_Tel1 = Replace(arr_Get_Tel1,"-","")
							brTag = "<br />"
						End If
						If arr_Get_Tel2 <> "" Then
							arr_Get_Tel2 = Replace(arr_Get_Tel2,"-","")
						End IF

						Tr_OnclickMsg = "insertThisAddress('"&arr_Get_Name1&"','"&arr_Get_ZipCode&"','"&arr_Get_Address1&"','"&arr_Get_Address2&"','"&arr_Get_Tel1&"','"&arr_Get_Tel2&"')"
			%>
			<tr class="tron cp" onclick="<%=Tr_OnclickMsg%>" >
				<td><%=arr_Get_Name1%></td>
				<td class="tleft">
						<%=arr_Get_ZipCode%><br />
						<%=arr_Get_Address1%><br />
						<%=arr_Get_Address2%>
				</td>
				<td>
					<%=arr_Get_Tel1%><%=brTag%><%=arr_Get_Tel2%>
				</td>
			</tr>
			<%
					Next
					On Error GoTo 0
					Set objEncrypter = Nothing
				Else
			%>
			<tr>
				<td colspan="3" style="padding:30px 0px;"><%=LNG_TEXT_NO_DATA%></td>
			</tr>
			<%
				End If
			%>
		</table>
	</div>
</div>
</body>
</html>