<%



	IMG					= "/images_"&Lang

	'print IMG
	IMG_SHARE			= IMG & "/share"
	IMG_NAVI			= IMG & "/navi"
	IMG_LOGIN			= IMG & "/login"
	IMG_FLASH			= IMG & "/flash"
	IMG_INDEX			= IMG & "/index"
	IMG_LEFT			= IMG & "/left"
	IMG_JOIN			= IMG & "/join"
	IMG_FLOATING		= IMG & "/floating"
	IMG_ICON			= IMG & "/icon"
	IMG_BTN				= IMG & "/btn"
	IMG_CONTENT			= IMG & "/content"
	IMG_SHOP			= IMG &"/shop"
	IMG_TOP				= IMG & "/top"
	IMG_POP				= IMG & "/pop"
	IMG_POPUP			= IMG & "/popup"
	IMG_SMART_TALK		= IMG & "/smartTalk"
	IMG_APPINFO			= IMG & "/appinfo"
	IMG_MYPAGE			= IMG & "/mypage"
	IMG_POLICY			= IMG & "/policy"
	IMG_PAGE			= IMG & "/page"
	IMG_MOVIE			= IMG & "/movie"
	IMG_ETC				= IMG & "/etc"
	IMG_SHOW			= IMG & "/showroom"
	IMG_EVENT			= IMG & "/event"
	IMG_COM				= IMG & "/community"
	IMG_SEARCH			= IMG & "/search"
	IMG_FAQ				= IMG & "/faq"
	IMG_COUNSEL			= IMG & "/counsel"
	IMG_TEMPS			= IMG & "/temps"
	IMG_SHOP_SHARE		= IMG & "/shop_share"


	'다국어 공통이미지 경로
	IMG_KR				= "/images_kr"

	IMG_SHARE_KR		= IMG_KR &"/share"
	IMG_NAVI_KR			= IMG_KR & "/navi"
	IMG_LOGIN_KR		= IMG_KR & "/login"
	IMG_FLASH_KR		= IMG_KR & "/flash"
	IMG_INDEX_KR		= IMG_KR & "/index"
	IMG_LEFT_KR			= IMG_KR & "/left"
	IMG_JOIN_KR			= IMG_KR & "/join"
	IMG_FLOATING_KR		= IMG_KR & "/floating"
	IMG_ICON_KR			= IMG_KR & "/icon"
	IMG_BTN_KR			= IMG_KR & "/btn"
	IMG_CONTENT_KR		= IMG_KR & "/content"
	IMG_SHOP_KR			= IMG_KR &"/shop"
	IMG_TOP_KR			= IMG_KR & "/top"
	IMG_POP_KR			= IMG_KR & "/pop"
	IMG_POPUP_KR		= IMG_KR & "/popup"
	IMG_SMART_TALK_KR	= IMG_KR & "/smartTalk"
	IMG_APPINFO_KR		= IMG_KR & "/appinfo"
	IMG_MYPAGE_KR		= IMG_KR & "/mypage"
	IMG_POLICY_KR		= IMG_KR & "/policy"
	IMG_PAGE_KR			= IMG_KR & "/page"
	IMG_MOVIE_KR		= IMG_KR & "/movie"
	IMG_ETC_KR			= IMG_KR & "/etc"
	IMG_SHOW_KR			= IMG_KR & "/showroom"
	IMG_EVENT_KR		= IMG_KR & "/event"
	IMG_COM_KR			= IMG_KR & "/community"
	IMG_SEARCH_KR		= IMG_KR & "/search"
	IMG_FAQ_KR			= IMG_KR & "/faq"
	IMG_COUNSEL_KR		= IMG_KR & "/counsel"
	IMG_TEMPS_KR		= IMG_KR & "/temps"
	IMG_SHOP_SHARE_KR	= IMG_KR & "/shop_share"


	M_IMG				= "/m/images_"&Lang
	M_IMG_SHOP			= "/m/images_"&Lang&"/shop"
	IMG_ADMIN_TOP = "/images/admin/top"
	' ***********************************************************************************
	' 업로드 경로 관련 상수 시작
	' ***********************************************************************************
		Function BREAL_PATH(c_userno)
'			BREAL_PATH = "D:\Websites\real_stock\board\upload\"&c_userno
			BREAL_PATH = server.mappath("/shop/board/upload/"&c_userno)
		End Function

		'이미지 업로드 가상경로
		Function BVIR_PATH(c_userno)
			BVIR_PATH = "/shop/board/upload/"&c_userno
		End Function

		Function REAL_PATH(c_userno)
			REAL_PATH = server.mappath("/upload/"&c_userno)
		End Function

		'이미지 업로드 가상경로
		Function VIR_PATH(c_userno)
			VIR_PATH = "/upload/"&c_userno
		End Function

		Function REAL_PATH2(dir)
			REAL_PATH2 = server.mappath(dir)
		End Function



		IMG_BOARD = "/shop/board/images"


%>
