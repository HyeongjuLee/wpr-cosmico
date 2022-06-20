
$(function() {
	var ThisNc = "KR"; //$("#selfncCode").val();
	var icon_text01,icon_text02,icon_text03,icon_text04
	switch (ThisNc)
	{
		case "KR" :
			icon_text01 = '고객센터';
			//icon_text02 = '마이오피스';
			icon_text02 = '마이페이지';
			icon_text03 = '쇼핑몰';
			icon_text04 = '장바구니';
			break;
		default :
			icon_text01 = 'CS CENTER';
			icon_text02 = 'MYOFFICE';
			icon_text03 = 'SHOPPING';
			icon_text04 = 'CART';
			break;
	}


	$('nav#menu').mmenu({
		extensions	: [ 'shadow-page', 'shadow-panels',"multiline","border-full","effect-menu-slide", "pagedim-black" ],
		counters	: true,
		navbar 		: {
			title		: 'Advanced menu'
		},
		slidingSubmenus : false
	});
	$('nav#menu-right').mmenu({
		offCanvas: {
			position  : "right"
		},
		extensions	: [ 'shadow-page', 'shadow-panels',"multiline","border-full","effect-menu-slide", "pagedim-black" ],
		counters	: true,
		navbar 		: {
			title		: 'Advanced menu'
		},
		slidingSubmenus : false
	});

});
