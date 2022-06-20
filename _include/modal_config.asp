<%
	'추천인선택, 후원인선택, 산하회원정보, 후원산하정보, PG Policy, 빠른주문 상품상세
	'dialog-confirm : detailView 장바구니담기

	'modal width, height 설정
	MODAL_CONTENT_WIDTH_DEFAULT = "$(""#contain"").width() / 2"
	MODAL_CONTENT_HEIGHT_DEFAULT = "610"
	MODAL_BORDER_RADIOUS_DEFAULT = "6"		'0
	MODAL_BORDER_THICKNESS_DEFAULT = "0"	'4
	MODAL_OVERLAY_CLICK_CLOSE_DEFAULT = "F"	'외부영역 클릭	T/F
	MODAL_NO_CLOSE_BUTTON_DEFAULT = "F"	'닫기버튼

	If MODAL_CONTENT_WIDTH = "" Then MODAL_CONTENT_WIDTH = MODAL_CONTENT_WIDTH_DEFAULT
	If MODAL_CONTENT_HEIGHT = "" Then MODAL_CONTENT_HEIGHT = MODAL_CONTENT_HEIGHT_DEFAULT

	If MODAL_BORDER_RADIOUS = "" Then MODAL_BORDER_RADIOUS = MODAL_BORDER_RADIOUS_DEFAULT
	If MODAL_BORDER_THICKNESS = "" Then MODAL_BORDER_THICKNESS = MODAL_BORDER_THICKNESS_DEFAULT
	If MODAL_OVERLAY_CLICK_CLOSE = "" Then MODAL_OVERLAY_CLICK_CLOSE = MODAL_OVERLAY_CLICK_CLOSE_DEFAULT
	If MODAL_NO_CLOSE_BUTTON = "" Then MODAL_NO_CLOSE_BUTTON = MODAL_NO_CLOSE_BUTTON_DEFAULT

%>
<%If PAGE_SETTING <> "SHOP" Then		'datepicker .css 중복%>
<link rel="stylesheet" href="/jscript/jquery-ui-1.12.1/jquery-ui.css">
<%End If%>

<script type="text/javascript" src="/jscript/jquery-ui-1.12.1/jquery-ui.min.js?v0"></script>
<link rel="stylesheet" type="text/css" href="/css/modal.css?v0">
<script type="text/javascript">

	$(document).ready(function() {

		let cw = <%=MODAL_CONTENT_WIDTH%>;
		let ch = <%=MODAL_CONTENT_HEIGHT%>;
		if(isNaN(cw) == true || cw == "" || cw < 1) cw = 600;

		/*** a[name=modal]" ***/
		$("a[name=modal]").click(function() {
			let $this = $(this);
			let url = $this.attr('href');
			let dialogOpts = {
				title: ($this.attr('title')) ? $this.attr('title') : "",
				autoOpen: true,
				bgiframe: true,
				width: cw,
				height: ch-10,
				modal: true,
				resizable: false,
				autoResize: true,
				draggable: false,

				<%If MODAL_OVERLAY_CLICK_CLOSE = "T" Then%>
					open: function() {
						$('.ui-widget-overlay').on('click', function() {
							$('#modal_view').dialog('destroy');
						})
					},
				<%End If%>
				buttons: {
					"Close": function() {
						$("#modalIFrame").attr('src',"");
						$(this).dialog("destroy");
					}
				}
			};
			setTimeout(function() {
				$("#modal_view").dialog(dialogOpts);
				$(".ui-dialog").css({"position":"fixed", "top": "45%", "left": "50%", "transform": "translate(-50%, -50%)" , "width": cw+"px", "z-index":"999999" });
				$(".ui-dialog .ui-dialog-titlebar-close").html('<i class="icon-close-outline"></i>');
				$('.ui-dialog-title').wrapInner('<i></i>');

				<%If MODAL_NO_CLOSE_BUTTON = "T" Then%>
				$(".ui-dialog-titlebar-close").css({"visibility":"hidden"});
				//$(".ui-dialog-buttonset ").css({"visibility":"hidden"});
				<%End If%>
			},300);
			$("#modalIFrame").attr('src',url);
			return false;
		});


		/*** dialog-layer ***/
		$(".dialog-layer").dialog({
			autoOpen: false,
			bgiframe: true,
			width: cw,
			height: ch-10,
			modal: true,
			resizable: false,
			autoResize: true,
			draggable: false,
			<%If MODAL_OVERLAY_CLICK_CLOSE = "T" Then%>
				open: function() {
					$('.ui-widget-overlay').on('click', function() {
							$(".dialog-layer").dialog("close");
					})
				},
			<%End If%>
			buttons: {
				"Close": function() {
					$(this).dialog( "close" );
				}
			}
		});
		$(".dialog-layer-opener").click(function () {
			let openerid = $(this).data('openerid');
			//console.log(openerid);
			$(openerid).dialog("open");
			$(".dialog-layer").not(openerid).dialog("close");

			//검색 확장 가로
			if (openerid == '#dialog-layer-filter') {
				cw= 800;
			} else {
				cw = <%=MODAL_CONTENT_WIDTH%>;
			}

			$(".ui-dialog").css({"position":"fixed", "top": "45%", "left": "50%", "transform": "translate(-50%, -50%)" , "width": cw+"px", "z-index":"999999", "border-radius": "<%=MODAL_BORDER_RADIOUS%>px","overflow-y":"auto" });
			$(".ui-dialog .ui-dialog-titlebar-close").html('<i class="icon-close-outline"></i>');
				$('.ui-dialog-title').wrapInner('<i></i>');

			$(".dialog-rewidth").css({"width": cw+"px","height": ch*0.7+"px" ,"border": "none","padding":"0px 5px;" });
			<%If MODAL_NO_CLOSE_BUTTON = "T" Then%>
			$(".ui-dialog-titlebar-close").css({"visibility":"hidden"});
			//$(".ui-dialog-buttonset ").css({"visibility":"hidden"});
			<%End If%>
		});




		/*** dialog-confirm ***/
		$(".dialog-confirm").click(function() {
			$( "#dialog-confirm" ).dialog({
				title: ($(this).attr('title')) ? $(this).attr('title') : "",
				resizable: false,
				draggable: false,
				height: "auto",
				width: 400,
				modal: true,
				<%If MODAL_OVERLAY_CLICK_CLOSE = "T" Then%>
					open: function() {
						$('.ui-widget-overlay').on('click', function() {
							$('#dialog-confirm').dialog('destroy');
						})
					},
				<%End If%>
				buttons: {
					"<%=LNG_TEXT_CONFIRM%>": function() {
						$( this ).dialog( "close" );
						<%If DIALOG_CONFIRM_URL <> "" Then%>
							location.href= '<%=DIALOG_CONFIRM_URL%>'
						<%End If%>
					},
					"<%=LNG_TEXT_POINT_CANCEL%>": function() {
						$( this ).dialog( "close" );
					}
				}
			});
			$(".ui-dialog").css({"position":"fixed", "top":"15%", "z-index":"999999"});
			$(".ui-dialog .ui-dialog-titlebar-close").html('<i class="icon-close-outline"></i>');
			$('.ui-dialog-title').wrapInner('<i></i>');
			$('button').each(function(){
				if ($(this).text() == '<%=LNG_TEXT_CONFIRM%>') {
					$(this).addClass('confirm');
				}
			});

			$("#dialog-confirm").css({"margin":"30px 10px"});
		});
	});

</script>
<div id="modal_view" style="display:none;">
	<iframe src="/hiddens.asp"  id="modalIFrame" width="100%" height="99%" marginWidth="0" marginHeight="0" frameBorder="0" scrolling="yes" ></iframe>
</div>

<div id="dialog-confirm" title="" style="display:none;">
	<p class="message"></p>
</div>
