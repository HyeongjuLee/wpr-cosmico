<%



		arrParams = Array(_
			Db.makeParam("@GoodsIDX",adInteger,adParamInput,0,intIDX)_
		)
		arrList = Db.execRsList("DKPA_GOODS_OPTIONAL_M",DB_PROC,arrParams,listLen,Nothing)


%>

<script type="text/javascript">
 function fncINPUTADD(form,key)
 {
	var form = document.gform;
  if(key == 1)
  {
  if (form.rowss.value >= 7)
	{
		alert("옵션값은 7개까지 추가 가능합니다.");
		return false;
	}
   var oRow = idUTILCOST.insertRow(-1);
   oRow.onmouseover=function(){idUTILCOST.clickedRowIndex=this.rowIndex};
   var oCell1 = oRow.insertCell(0);
   var oCell2 = oRow.insertCell(1);
   oCell1.innerHTML = "<input type = \"hidden\" name = \"oIDX\" value=\"0\" /><input type = \"text\" name = \"optiontitle\" class=\"input_text\" size=\"24\" maxlength = \"200\" />";
   oCell2.innerHTML = "<input type = \"text\" name = \"optionValues\" class=\"input_text\" size=\"80\" style=\"width:555px\" />";
	form.rowss.value = parseInt(form.rowss.value)+1;
  }
  else
  {
  if (form.rowss.value <= 1)
	{
		alert("옵션값을 없애시려면 상단의 옵션없음을 눌러주세요.");
		return false;
	}
   var oRow = idUTILCOST.deleteRow(-1);
	form.rowss.value = parseInt(form.rowss.value)-1;
  }
 }
</script>
<input type="hidden" id="rowss" name="rowss" value="<%=listLen+1%>" />
<table <%=tableatt%> style="width:780px;">
	<tr>
		<td style="text-align:right;">
			<img src="<%=img_icon%>/color_add_i.gif" width="37" height="17" onclick="fncINPUTADD(document.frmUNITCOST,1)" style="cursor:pointer;" />
			<img src="<%=img_icon%>/color_del_i.gif" width="37" height="17" onclick="fncINPUTADD(document.frmUNITCOST,0)" style="cursor:pointer;" />
		</td>
	</tr><tr>
		<td>
			<table border="1" bordercolor="#D9D9D9" cellspacing="0" cellpadding="0" frame="hsides" id="idUTILCOST" style="width:760px;">
				<thead>
				<tr>
					<th style="height:30px; text-align:center;">옵션명</th>
					<th style="height:30px; text-align:center;">옵션값</th>
				</tr>
				</thead>
				<tbody>
				<%
					If IsArray(arrList) Then
						For i = 0  To listLen
				%>
				<tr>
					<td width="170"><input type="hidden" name="oIDX" value="<%=arrList(0,i)%>" /><input type="text" name="optiontitle" value ="<%=arrList(2,i)%>" class="input_text" size="24" maxlength="200" /></td>
					<td width="*"><input type="text" name="optionValues" class="input_text" size="80" style="width:555px" value ="<%=arrList(3,i)%>" /></td>
				</tr>
				<%
						next
					End If
				%>
				</tbody>
			</table>
		</td>
	</tr><tr>
		<td>
			<ul>
				<li>- 상품 옵션을 선택할 수 있습니다.</li>
				<li>- 상품 옵션은 <strong>옵션값:가격:공급가\옵션값:가격:공급가</strong> 형태로 적어주시면 됩니다. <strong>예) 빨강:3500:2500\파랑:4500:3500 형식</strong></li>
				<li>- 상품 가격이 없을 경우에는 0 으로 기입해주시면 됩니다.</li>
				<li>- 옵션의 모든 값이 0일 경우에는 가격 추가 표시는 뜨지 않습니다.</li>
			</ul>
		</td>
	</tr>
</table>
