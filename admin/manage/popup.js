$(document).ready(function() {

	var fileTarget = $('.filebox .upload-hidden');

	fileTarget.on('change', function(){
		if(window.FileReader){ // 파일명 추출
			var filename = $(this)[0].files[0].name;
		} else { // Old IE 파일명 추출
			var filename = $(this).val().split('/').pop().split('\\').pop();
		};
		$(this).siblings('.upload-name').val(filename);
	});


	$("input[name=popKind]").on("click",function() {
		var values = $(this).val();
		//alert(values);
		switch (values)
		{
			case "L" :
				$("#layerTD").css({"display":""});
				$("#topTD").css({"display":"none"});
				break;
			case "T" :
				$("#layerTD").css({"display":"none"});
				$("#topTD").css({"display":""});
				break;

		}
	});

});

	function popupRegist() {
		$("#ModalScrollable1").modal('show');

	}

function chkPopupRegist(f) {

	if (f.popTitle.value == '')
	{
		alert("팝업타이틀을 입력해주세요. ");
		f.popTitle.focus();
		return false;
	}

	if (f.popKind.value == '')
	{
		alert("팝업의 종류를 선택해주세요.");
		f.popKind[0].focus();
		return false;
	}


	if (f.popKind.value == 'L') {
		if (f.imgName.value == '')
		{
			alert("팝업이미지를 선택해주세요.");
			return false;
		}
		if (f.marginTop.value == '')
		{
			alert("팝업창이 열릴 위치(상단)을 PX(픽셀) 단위로 입력해주세요.");
			f.marginTop.focus();
			return false;
		}
		if (f.marginLeft.value == '')
		{
			alert("팝업창이 열릴 위치(좌측)을 PX(픽셀) 단위로 입력해주세요.");
			f.marginLeft.focus();
			return false;
		}
		if (f.popKind.value == '')
		{
			alert("팝업의 종류를 선택해주세요.");
			f.popKind.focus();
			return false;
		}
	} else {
		if (f.strScontent.value == '')
		{
			alert("짧은 설명은 입력해주세요.");
			f.strScontent.focus();
			return false;
		}
	}

	if (f.linkType.value != 'F') {
		if (f.linkType.value == '')
		{
			alert("링크를 적용하실 윈도우(창)을 선택해주세요.");
			f.linkType.focus();
			return false;
		}
		if (f.linkUrl.value == '')
		{
			alert("링크주소를 입력해주세요.");
			f.linkUrl.focus();
			return false;
		}
	}

}