<%
	SQL = "SELECT * FROM [DK_POPUP] WHERE [useTF] = 'T' AND [popKind] = 'L' AND [isViewCom] ='T' AND [isViewShop] = 'F' AND [strNation] = '"&Lang&"' AND isViewMobile <> 'T' ORDER BY [intIDX] ASC"		'isViewShop(메인 or 쇼핑몰메인)
	arrList1 = Db.execRsList(SQL,DB_TEXT,Nothing,listLen1,Nothing)

	If IsArray(arrList1) Then
		For i = 0 To listLen1

		Layer_Name = "poplay_"&arrList1(1,i)
		Layer_Height = Int(arrList1(6,i)) + 80

		Layer_Cookies = Request.cookies(Layer_Name)
		If Layer_Cookies <> "no" Then

		imgPath = VIR_PATH("popup")&"/"&arrList1(4,i)
		imgWidth = 0
		imgHeight = 0
		Call imgInfo(imgPath,imgWidth,imgHeight,"")

	If arrList1(12,i) <> "#" Then
		Select Case arrList1(11,i)
			Case "S"
			'	ImgModes = "<a href=""javascript:parentLink('"&linkUrl&"')"">"&viewImg(imgPath,imgWidth,imgHeight,imgAlt)&"</a>"
				ImgModes = aImg(arrList1(12,i),imgPath,imgWidth,imgHeight,imgAlt)
			Case "B"
				ImgModes = aImg2(arrList1(12,i),imgPath,imgWidth,imgHeight,imgAlt)
			Case Else
				ImgModes = viewImg(imgPath,imgWidth,imgHeight,imgAlt)
		End Select
	End If

%>
<script type="text/javascript">
<!--
	$(function() {
		$( "#<%=Layer_Name%>" ).draggable({
			 containment: 'window'
			,scroll: false
		});

		$('.<%=Layer_Name%>').mousedown(function(){
			var maxZIndex =0;
			var curZIndex =0;
			$('.<%=Layer_Name%>').each(function(index){
				//숫자변환
				curZIndex = parseInt( $(this).css('z-index') );

				if(maxZIndex <curZIndex){
					 maxZIndex = curZIndex;
				}
			});
			// 드래그 팝업이 항상 위
			$(this).css('z-index', maxZIndex+2);
		});
	});
// -->
</script>
<link rel="stylesheet" type="text/css" href="/css/popupLayer.css">
<div id="<%=Layer_Name%>" class="popupLayer" style="position:absolute; left:<%=arrList1(9,i)%>px; top:<%=arrList1(8,i)%>px; width:<%=arrList1(3,i)%>px;z-index:9999;" onmouseover="dragObj=<%=Layer_Name%>; drag=1;move=0;" onmouseout="drag=0">
	<div class="popupLayer-close" onclick="<%=Layer_Name%>.style.display='none';"><i class="icon-cancel"></i></div>
	<div class="popupLayer-content">
		<%=ImgModes%>
	</div>
	<div class="popupLayer-close-today">
		<div class="close-today">
			<label>
				<span><%=LNG_POPUP_TEXT01%></span>
				<input type="checkbox" name="oleid" value="1" onclick="closeToday('<%=Layer_Name%>'); <%=Layer_Name%>.style.display='none';">
			</label>
		</div>
		<div class="close" onclick="<%=Layer_Name%>.style.display='none';"><%=LNG_BTN_CLOSE%></div>
	</div>
</div>
<!-- <div id="<%=Layer_Name%>" style="position:absolute; left:<%=arrList1(9,i)%>px; top:<%=arrList1(8,i)%>px; width:<%=arrList1(3,i)%>px;z-index:999999;cursor:hand;background-color:#000;" onmouseover="dragObj=<%=Layer_Name%>; drag=1;move=0;" onmouseout="drag=0">
	<table <%=tableatt%> id="popTable">
		<tr>
			<td colspan="2" style="padding:0px; background-color:#fff;"><%=ImgModes%></td>
		</tr><tr class="botline">
			<td style="padding:5px 0px; color:#fff;">&nbsp;&nbsp;<span class="todayClo"><%=LNG_POPUP_TEXT01%></span><input type="checkbox" name="oleid" value="1" onclick="closeToday('<%=Layer_Name%>');" style="vertical-align:middle;"></td>
			<td align="right" style="padding:5px 0px; color:#fff;"><span  class="todayClo" onclick="<%=Layer_Name%>.style.display='none';" style='cursor:pointer;'>X 닫기</span>&nbsp;&nbsp;</td>
		</tr>
	</table>
</div> -->

<%
			End If
		Next
	End If


%>
<!-- <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script> --><%'drag%>
<script type="text/javascript">
	var x =0;
	var y=0;
	drag = 0;
	move = 0;
	window.document.onmousemove = mouseMove;
	window.document.onmousedown = mouseDown;
	window.document.onmouseup = mouseUp;
	window.document.ondragstart = mouseStop;

	function mouseUp() {
		move = 0;
	}
	function mouseDown() {
		if (drag) {
			clickleft = window.event.x - parseInt(dragObj.style.left);
			clicktop = window.event.y - parseInt(dragObj.style.top);
			//alert(clicktop);
			dragObj.style.zIndex += 1;
			move = 1;
		}
	}
	function mouseMove() {
		if (move) {
			dragObj.style.left = window.event.x - clickleft;
			dragObj.style.top = window.event.y - clicktop;
		}
	}
	function mouseStop() {
		window.event.returnValue = false;
	}
	function Show(divid){
		divid.filters.blendTrans.apply();
		divid.style.visibility = "visible";
		divid.filters.blendTrans.play();
	}
	function Hide(divid) {
		divid.filters.blendTrans.apply();
		divid.style.visibility = "hidden";
		divid.filters.blendTrans.play();
	}


	function closeToday(fs){
		setCookie(fs, "no" , 1);
		document.getElementById(fs).style.display = "none";
	}



</script>


