<%
	'모바일 레이어 팝업 NEW
	'draggable : axis: 'y' 세로스크롤

	P_MAX_WIDTH = 450		'최대가로px
	P_WRAP_BORDER = 1		'테두리
	P_WIDTH_RATIO = 0.9		'가로비율
%>
<style type="text/css">
	.popWrap {position:absolute; top:65px; z-index:999999; cursor:pointer; max-width:<%=P_MAX_WIDTH%>px; border:<%=P_WRAP_BORDER%>px solid #000; }
	.popTable td {padding: 0px; color:#fff; background-color:#fff;}
	.popTable td.bottomline {padding:5px 5px; color:#fff; background-color:#000; font-size:14px;}
	.popTable .checkbox {vertical-align:middle; width:18px; height:18px;}
	.popTable img {max-width:<%=P_MAX_WIDTH-2%>px;}
</style>
<%
	'모바일 레이어 팝업 NEW
	'draggable : axis: 'y' 세로스크롤!!

	SQL = "SELECT * FROM [DK_POPUP] WHERE [useTF] = 'T' AND [isViewCom] ='T' AND [isViewShop] = 'F' AND [strNation] = '"&Lang&"' AND isViewMobile = 'T' ORDER BY [intIDX] ASC"		'isViewShop(메인 or 쇼핑몰메인)

	arrList1 = Db.execRsList(SQL,DB_TEXT,Nothing,listLen1,Nothing)

	If IsArray(arrList1) Then
		For i = 0 To listLen1

			Layer_Name = "poplay_m_"&arrList1(1,i)
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
							'ImgModes = "<a href=""javascript:parentLink('"&linkUrl&"')"">"&viewImg(imgPath,imgWidth,imgHeight,imgAlt)&"</a>"
							ImgModes = aImg(arrList1(12,i),imgPath,imgWidth,imgHeight,imgAlt)
						Case "B"
							ImgModes = aImg2(arrList1(12,i),imgPath,imgWidth,imgHeight,imgAlt)
						Case Else
							ImgModes = viewImg(imgPath,imgWidth,imgHeight,imgAlt)
					End Select
				End If

%>
				<script type="text/javascript">

					$(function() {

						$( "#<%=Layer_Name%>" ).draggable({
							 axis: 'y',
							 //containment: 'window'
							 //,scroll: true
						});

						/*
						// 드래그 팝업이 항상 위
						$(".popWrap").mousedown(function(){
							var maxZIndex =0;
							var curZIndex =0;
							$(".popWrap").each(function(index){
								curZIndex = parseInt( $(this).css('z-index') );

								if(maxZIndex <curZIndex){
									 maxZIndex = curZIndex;
								}
							});
							$(this).css('z-index', maxZIndex+2);
						});
						*/

					});

				</script>
				<div id="<%=Layer_Name%>" class="popWrap">
					<table <%=tableatt%> class="popTable">
						<tr>
							<td colspan="2"><%=ImgModes%></td>
						</tr><tr>
							<td class="bottomline"><span><%=LNG_POPUP_TEXT01%></span><input type="checkbox" name="oleid" value="1" class="checkbox" onclick="closeToday('<%=Layer_Name%>');" ></td>
							<td class="bottomline tright"><span onclick="<%=Layer_Name%>.style.display='none';">X <%=LNG_BTN_CLOSE%></span></td>
						</tr>
					</table>
				</div>
<%
			End If

		Next
	End If
%>
<!-- <script src="/m/jquery/jquery-ui.js"></script> -->
<!-- <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script> -->
<script src="/m/jquery/jquery-ui.min.js"></script>
<script src="/m/jquery/jquery.ui.touch.js"></script>
<script type="text/javascript">

	$(document).ready(function() {
		//페이지 로딩 시 가로길이
		var ww = $(window).width();
		var pw = $("#page").width()* <%=P_WIDTH_RATIO%>;
		var l_per = (ww-pw) / 2;
		var lr_b = <%=P_WRAP_BORDER%>*2


		$(".popWrap").css({"width": pw+"px","left":+l_per+"px"});
		$(".popWrap img").css({"width":pw-lr_b+"px"});

		//화면사이즈 조정시 가로길이 재 조정
		$(window).resize(function() {
			var ww = $(window).width();
			var pw = $("#page").width()* <%=P_WIDTH_RATIO%>;
			var l_per = (ww-pw) / 2;
			var lr_b = <%=P_WRAP_BORDER%>*2

			$(".popWrap").css({"width": pw+"px","left":+l_per+"px"});
			$(".popWrap img").css({"width":pw-lr_b+"px"});
		});

	});

	function setCookie( name, value, expiredays )
	{
		var todayDate = new Date();
		todayDate.setDate( todayDate.getDate() + expiredays );
		document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";"
	}

	function closeToday(fs){
		setCookie(fs, "no" , 1);
		document.getElementById(fs).style.display = "none";
	}

</script>
