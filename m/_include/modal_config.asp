

<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">

<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<link rel="stylesheet" href="/m/css/modal.css?v0">
<style type="text/css">
	.ui-widget-content .ui-state-default {border: none; background: #ffffff;font-weight: normal; /* for datepicker */}
	.ui-widget-overlay {background: #414141; opacity: 0.6;}
</style>
<script type="text/javascript">

	$(document).ready(function() {

		let ww = $(window).width();
		let cw = $("#page").width()* 0.95;
		if (cw > 550) {
			cw = 550;
		}
		let l_per = (ww-cw) / 2;
		let ch = $(window).height();

		$("a[name=modal]").click(function() {

			let $this = $(this);
			let url = $this.attr('href');
			let dialogOpts = {
				title: ($this.attr('title')) ? $this.attr('title') : "",

				autoOpen: true,
				bgiframe: true,
				width: cw,
				height: ch-20,

				modal: true,
				resizable: false,
				autoResize: true,
				draggable: false,
				buttons: {
					"Close": function() {
						$("#modalIFrame").attr('src',"");
						//$(this).dialog("close");
						$(this).dialog("destroy");
					}
				}
			};

			setTimeout(function() {
				$("#modal_view").dialog(dialogOpts);
				//$(".ui-dialog").css({"position":"fixed", "top":"5px", "left":"2%", "width":"95%", "z-index":"999999"});
				$(".ui-dialog").css({"position":"fixed", "top":"5px", "left":+l_per+"px", "width":cw+"px", "z-index":"999999"});		//mob
				$(".ui-dialog .ui-dialog-titlebar-close").html('<i class="icon-close-outline"></i>');
				$('.ui-dialog-title').wrapInner('<i></i>');
			},300);
			$("#modalIFrame").attr('src',url);

			//화면사이즈 조정시 가로길이 재 조정
			$(window).resize(function() {
				let ww_r = $(window).width();
				let cw_r = $("#page").width()* 0.95;
				if (cw_r > 550) {
					cw_r = 550;
				}
				let l_per_r = (ww_r-cw_r) / 2;
				$(".ui-dialog").css({"position":"fixed", "top":"5px", "left":+l_per_r+"px", "width":cw_r+"px", "z-index":"999999"});		//mob
			});
			return false;
		});

		/*** dialog-layer ***/
		$(".dialog-layer").dialog({
			autoOpen: false,
			bgiframe: true,
			width: cw,
			height: ch-20,
			modal: true,
			resizable: false,
			autoResize: true,
			draggable: false,

			open: function() {
				$('.ui-widget-overlay, .ui-button').on('click', function() {
					$(".dialog-layer").dialog("close");
					$('.ui-dialog-title>i').contents().unwrap('');		//타이틀 형광펜 삭제
				})
			},
			buttons: {
				"Close": function() {
					$(this).dialog( "close" );
					$('.ui-dialog-title>i').contents().unwrap('');
				}
			}

		});
		$(".dialog-layer-opener").click(function () {
			let openerid = $(this).data('openerid');
			//console.log(openerid);
			$(openerid).dialog("open");
			setTimeout(function() {
				$('.dialog-layer').scrollTop(0);
				$(".dialog-layer").not(openerid).dialog("close");
				$(".ui-dialog").css({"position":"fixed", "top":"5px", "left":+l_per+"px", "width":cw+"px", "z-index":"999999"});		//mob
				$(".ui-dialog .ui-dialog-titlebar-close").html('<i class="icon-close-outline"></i>');
				$('.ui-dialog-title').wrapInner('<i></i>');
			},100);
		});

		//화면사이즈 조정시 가로길이 재 조정
		$(window).resize(function() {
			let ww_r = $(window).width();
			let cw_r = $("#page").width()* 0.95;
			if (cw_r > 550) {
				cw_r = 550;
			}
			let l_per_r = (ww_r-cw_r) / 2;
			$(".ui-dialog").css({"position":"fixed", "top":"5px", "left":+l_per_r+"px", "width":cw_r+"px", "z-index":"999999"});		//mob
		});
		return false;

	});

</script>
<div id="modal_view" style="display:none;">
	<iframe src="/hiddens.asp"  id="modalIFrame" width="100%" height="99%" marginWidth="0" marginHeight="0" frameBorder="0" scrolling="yes" ></iframe>
</div>
