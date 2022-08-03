<%
	Function AdminMap(ByVal deli)

		PRINTABLE = ""
		PRINTABLE = PRINTABLE & "<div id=""admin_info"" class=""clear"">"
		PRINTABLE = PRINTABLE & "	<div class=""top""></div>"
		PRINTABLE = PRINTABLE & "	<ul>"
		If IsArray(deli) Then
			For m = 0 To UBound(deli)
				PRINTABLE = PRINTABLE & "		<li>"&Trim(deli(m)(1)) &"</li>"
			Next
		End If
		PRINTABLE = PRINTABLE & "	</ul>"
		PRINTABLE = PRINTABLE & "	<div class=""bottom""></div>"
		PRINTABLE = PRINTABLE & "</div>"
		Response.Write PRINTABLE

	End Function



'설정확인
	If ADMIN_LEFT_MODE <> "" Then
		Select Case INFO_MODE
'======================================================================================================================
			Case "STATISTICS1-1"
				MAP_DEPTH2 = "통계"
				MAP_DEPTH3 = "회원 현황"
				arrayLi = Array(_
					Array(True, "회원 가입현황을 볼 수 있습니다.") _
				)
			Case "STATISTICS1-2"
				MAP_DEPTH2 = "통계"
				MAP_DEPTH3 = "CS회원 현황"
				arrayLi = Array(_
					Array(True, "CS회원 가입현황을 볼 수 있습니다.") _
				)
'======================================================================================================================
'======================================================================================================================
			Case "CONFIG2-1"
				MAP_DEPTH2 = "정책관리"
				MAP_DEPTH3 = "온라인 이용약관"
				arrayLi = Array(_
					Array(True, "온라인 이용약관을 수정할 수 있습니다.") _
				)
			Case "CONFIG2-2"
				MAP_DEPTH2 = "정책관리"
				MAP_DEPTH3 = "개인정보 수집 및 이용"
				arrayLi = Array(_
					Array(True, "개인정보 수집 및 이용에 대한 안내를 수정할 수 있습니다.")_
				)
			Case "CONFIG2-3"
				MAP_DEPTH2 = "정책관리"
				MAP_DEPTH3 = "사업자회원 가입약관"
				arrayLi = Array(_
					Array(True, "사업자회원 가입약관에 대한 안내를 수정할 수 있습니다.")_
				)
			Case "CONFIG2-4"
				MAP_DEPTH2 = "정책관리"
				MAP_DEPTH3 = "임의적인 가공 및 재판매 금지서약"
				arrayLi = Array(_
					Array(True, "임의적인 가공 및 재판매 금지서약에 대한 안내를 수정할 수 있습니다.")_
				)
			Case "CONFIG2-5"
				MAP_DEPTH2 = "정책관리"
				MAP_DEPTH3 = "회원가입 전 확인사항"
				arrayLi = Array(_
					Array(True, "회원가입 전 확인사항에 대한 안내를 수정할 수 있습니다.")_
				)
			Case "CONFIG2-6"
				MAP_DEPTH2 = "정책관리"
				MAP_DEPTH3 = "납세관리인 설정신고"
				arrayLi = Array(_
					Array(True, "납세관리인 설정신고에 대한 안내를 수정할 수 있습니다.")_
				)
			Case "CONFIG2-7"
				MAP_DEPTH2 = "정책관리"
				MAP_DEPTH3 = "배송정책 관리"
				arrayLi = Array(_
					Array(True, "배송 정책에 대한 안내를 수정할 수 있습니다.")_
				)


			'PG 약관
			Case "CONFIGPTG-1"
				MAP_DEPTH2 = "PGAYTAG 약관"
				MAP_DEPTH3 = "전자금융거래이용약관"
			Case "CONFIGPTG-2"
				MAP_DEPTH2 = "PGAYTAG 약관"
				MAP_DEPTH3 = "개인정보취급방침"
			Case "CONFIGPTG-3"
				MAP_DEPTH2 = "PGAYTAG 약관"
				MAP_DEPTH3 = "서비스이용약관"

			Case "CONFIGKSNET-1"
				MAP_DEPTH2 = "KSNET 약관"
				MAP_DEPTH3 = "전자금융거래이용약관"



			Case "CONFIG3-1"
				MAP_DEPTH2 = "제한설정"
				MAP_DEPTH3 = "아이디제한 관리"
				arrayLi = Array(_
					Array(True, "사이트 가입 시 등록 불가능한 아이디를 설정할 수 있습니다."), _
					Array(True, "닉네임과 아이디 체크 두군데 모두에서 사용됩니다."),_
					Array(True, "구분은 쉼표(,)로 할 수 있습니다.")_
				)
			Case "CONFIG3-2"
				MAP_DEPTH2 = "제한설정"
				MAP_DEPTH3 = "아이피제한 관리"
				arrayLi = Array(_
					Array(True, "아이피를 차단할 수 있습니다."), _
					Array(True, "관리자가 접속하는 아이디가 차단된 경우 웹프로(1599-8807) 로 연락바랍니다.")_
				)

			Case "CONFIG3-3"
				MAP_DEPTH2 = "기본정보 설정"
				MAP_DEPTH3 = "회사계좌"
				arrayLi = Array(_
					Array(True, "회사의 계좌정보를 관리할 수 있습니다.")_
				)

			Case "CONFIG3-4"
				MAP_DEPTH2 = "기본정보 설정"
				MAP_DEPTH3 = "기본정보 설정"
				arrayLi = Array(_
					Array(True, "회사의 기본정보를 설정할 수 있습니다.")_
				)



			Case "CONFIG7-2"
				MAP_DEPTH2 = "국가별 배송비관리"
				MAP_DEPTH3 = "국가별 배송비관리"


'======================================================================================================================
'======================================================================================================================
			Case "ACADEMY1-1"
				MAP_DEPTH2 = "아카데미 관리"
				MAP_DEPTH3 = "아카데미목록"
				arrayLi = Array(_
					Array(True, "현재 사용중인 아카데미의 목록을 보실 수 있습니다."), _
					Array(True, "아카데미의 사용유무나 타이틀을 수정할 수 있습니다"), _
					Array(True, "현재 사이트 고유값은 서브도메인(고유값.도메인)으로 정해져있습니다.") _
				)

			Case "ACADEMY2-1"
				MAP_DEPTH2 = "강사 관리"
				MAP_DEPTH3 = "강사목록/삭제"
				arrayLi = Array(_
					Array(True, "현재 등록된 강사목록을 보실 수 있습니다. "), _
					Array(True, "리스트 기본 정렬은 아카데미고유값 -> 노출순서 로 되어있습니다 ") _
				)
			Case "ACADEMY2-2"
				MAP_DEPTH2 = "강사 관리"
				MAP_DEPTH3 = "강사입력"
				arrayLi = Array(_
					Array(True, "에듀킨 아카데미의 강사를 등록할 수 있습니다") _
				)
'======================================================================================================================
'======================================================================================================================

			Case "MANAGE1-1"
				MAP_DEPTH2 = "FAQ 관리"
				MAP_DEPTH3 = "FAQ 카테고리 관리"
				arrayLi = Array(_
					Array(True, "FAQ에 대한 관리모드입니다."), _
					Array(True, "FAQ의 카테고리를 설정할 수 있습니다.") _
				)
			Case "MANAGE1-2"
				MAP_DEPTH2 = "FAQ 관리"
				MAP_DEPTH3 = "FAQ 리스트"
				arrayLi = Array(_
					Array(True, "FAQ에 대한 관리모드입니다."), _
					Array(True, "FAQ를 볼 수 있습니다.") _
				)
			Case "MANAGE1-3"
				MAP_DEPTH2 = "FAQ 관리"
				MAP_DEPTH3 = "FAQ 작성"
				arrayLi = Array(_
					Array(True, "자주하는질문에 대한 관리모드입니다."), _
					Array(True, "FAQ를 작성할 수 있습니다.") _
				)
			Case "MANAGE1-4"
				MAP_DEPTH2 = "FAQ 관리"
				MAP_DEPTH3 = "FAQ 설정"
				arrayLi = Array(_
					Array(True, "자주하는질문에 대한 설정모드입니다."), _
					Array(True, "FAQ를 설정할 수 있습니다.") _
				)
'======================================================================================================================
			Case "MANAGE8-1"
				MAP_DEPTH2 = "1:1문의 관리"
				MAP_DEPTH3 = "1:1문의 카테고리"
				arrayLi = Array(_
					Array(True, viewAdminLangName & "의 1:1문의 카테고리를 관리할 수 있습니다.") _
				)
			Case "MANAGE8-2"
				MAP_DEPTH2 = "1:1문의 관리"
				MAP_DEPTH3 = "1:1문의 관리"
				arrayLi = Array(_
					Array(True, viewAdminLangName & "의 1:1문의를 관리할 수 있습니다.") _
				)
'======================================================================================================================

			Case "MANAGE4-1"
				MAP_DEPTH2 = "총판 관리"
				MAP_DEPTH3 = "총판 목록"
				arrayLi = Array(_
					Array(True, "총판 목록을 볼 수 있습니다.") _
				)
			Case "MANAGE4-2"
				MAP_DEPTH2 = "총판 관리"
				MAP_DEPTH3 = "총판 보기"
				arrayLi = Array(_
					Array(True, "선택하신 총판의 상세 내용입니다.") ,_
					Array(True, "선택하신 총판의 내용을 수정 및 삭제 할 수 있습니다.") _
				)
			Case "MANAGE4-3"
				MAP_DEPTH2 = "총판 관리"
				MAP_DEPTH3 = "총판 보기(수정)"
				arrayLi = Array(_
					Array(True, "선택하신 총판의 상세 내용입니다.") ,_
					Array(True, "선택하신 총판의 내용을 수정할 수 있습니다.") _
				)
			Case "MANAGE4-5"
				MAP_DEPTH2 = "총판 관리"
				MAP_DEPTH3 = "총판 입력"
				arrayLi = Array(_
					Array(True, "총판을 입력할 수 있습니다.") _
				)

'======================================================================================================================
			Case "MANAGE5-1"
				MAP_DEPTH2 = "로드샵 관리"
				MAP_DEPTH3 = "로드샵 목록"
				arrayLi = Array(_
					Array(True, "로드샵 목록을 볼 수 있습니다.") _
				)
			Case "MANAGE5-2"
				MAP_DEPTH2 = "로드샵 관리"
				MAP_DEPTH3 = "로드샵 보기"
				arrayLi = Array(_
					Array(True, "선택하신 로드샵의 상세 내용입니다.") ,_
					Array(True, "선택하신 로드샵의 내용을 수정 및 삭제 할 수 있습니다.") _
				)
			Case "MANAGE5-3"
				MAP_DEPTH2 = "로드샵 관리"
				MAP_DEPTH3 = "로드샵 보기(수정)"
				arrayLi = Array(_
					Array(True, "선택하신 로드샵의 상세 내용입니다.") ,_
					Array(True, "선택하신 로드샵의 내용을 수정할 수 있습니다.") _
				)
			Case "MANAGE5-5"
				MAP_DEPTH2 = "로드샵 관리"
				MAP_DEPTH3 = "로드샵 입력"
				arrayLi = Array(_
					Array(True, "로드샵을 입력할 수 있습니다.") _
				)
'======================================================================================================================
			Case "MANAGE6-1"
				MAP_DEPTH2 = "팝업 관리"
				MAP_DEPTH3 = "팝업 등록 / 설정"
				arrayLi = Array(_
					Array(True, viewAdminLangName & "의 팝업을 등록및 설정할 수 있습니다.") _
				)
			Case "MANAGE6-2"
				MAP_DEPTH2 = "모바일팝업 관리"
				MAP_DEPTH3 = "모바일팝업 등록 / 설정"
				arrayLi = Array(_
					Array(True, viewAdminLangName & "의 모바일팝업을 등록및 설정할 수 있습니다.") _
				)

			Case "MANAGE5-2"
				MAP_DEPTH2 = "로드샵 관리"
				MAP_DEPTH3 = "로드샵 보기"
				arrayLi = Array(_
					Array(True, "선택하신 로드샵의 상세 내용입니다.") ,_
					Array(True, "선택하신 로드샵의 내용을 수정 및 삭제 할 수 있습니다.") _
				)

			Case "MANAGE7-1"
				MAP_DEPTH2 = "배너관리"
				MAP_DEPTH3 = "파트너 배너관리"
				arrayLi = Array(_
					Array(True, "좌측 파트너 배너를 관리할 수 있습니다.") _
				)
'======================================================================================================================
'======================================================================================================================
			Case "COMMUNITY1-1"
				MAP_DEPTH2 = "게시판 관리"
				MAP_DEPTH3 = "게시판리스트"
				arrayLi = Array(_
					Array(True, "게시판 목록 및 설정을 할 수 있습니다.") _
				)
'======================================================================================================================
'======================================================================================================================
			Case "MEMBER1-1"
				MAP_DEPTH2 = "회원 관리"
				MAP_DEPTH3 = "회원리스트"
				arrayLi = Array(_
					Array(True, "홈페이지에 가입한 회원들을 볼 수 있습니다.") _
				)

			Case "MEMBER1-2"
				MAP_DEPTH2 = "회원 관리"
				MAP_DEPTH3 = "탈퇴요청회원"
				arrayLi = Array(_
					Array(True, "탈퇴를 요청한 회원들을 볼 수 있습니다.") _
				)

			Case "MEMBER1-3"
				MAP_DEPTH2 = "회원 관리"
				MAP_DEPTH3 = "탈퇴승인회원"
				arrayLi = Array(_
					Array(True, "탈퇴를 승인한 회원들을 볼 수 있습니다.") _
				)

			Case "MEMBER1-4"
				MAP_DEPTH2 = "회원 관리"
				MAP_DEPTH3 = "강제탈퇴회원"
				arrayLi = Array(_
					Array(True, "강제로 탈퇴된 회원들을 볼 수 있습니다.") _
				)

			Case "MEMBER1-5"
				MAP_DEPTH2 = "메세지 관리"
				MAP_DEPTH3 = "회원가입 메세지"
				arrayLi = Array(_
					Array(True, "전송되는 메시지를 관리할 수 있습니다."), _
					Array(True, "뿌리오 카톡 승인된 템플릿 기준 작성 (SMS/MMS/알림톡)") _
				)
			Case "MEMBER1-7"
				MAP_DEPTH2 = "메세지 관리"
				MAP_DEPTH3 = "상품주문 메세지"
				arrayLi = Array(_
					Array(True, "구매 시 전송되는 메시지를 관리할 수 있습니다."), _
					Array(True, "뿌리오 카톡 승인된 템플릿 기준 작성 (SMS/MMS/알림톡)") _
				)
			Case "MEMBER1-8"
				MAP_DEPTH2 = "메세지 관리"
				MAP_DEPTH3 = "회원가입 메세지(이메일)"
				arrayLi = Array(_
					Array(True, "이메일 전송 메시지를 관리할 수 있습니다.") _
				)

			Case "MEMBER1-9"
				MAP_DEPTH2 = "메세지 관리"
				MAP_DEPTH3 = "보안비번 초기화 메세지"
				arrayLi = Array(_
					Array(True, "보안비번 초기화 메세지 관리") _
				)

			Case "MEMBER1-6"
				MAP_DEPTH2 = "회원 관리"
				MAP_DEPTH3 = "푸시메세지관리"
				arrayLi = Array(_
					Array(True, "회원별 또는 그룹별 푸시메세지를 전송할 수 있습니다.") _
				)


			Case "MEMBER3-1"
				MAP_DEPTH2 = "CS회원 관리"
				MAP_DEPTH3 = "CS회원리스트"
				arrayLi = Array(_
					Array(True, "CS에 가입한 회원들을 볼 수 있습니다.") _
				)



'			Case "MEMBER2-1"
'				MAP_DEPTH2 = "이미지치환관리"
'				MAP_DEPTH3 = "금지작성자명"
'				arrayLi = Array(_
'					Array(True, "글 작성시 사용할 수 없는 작성자명을 지정합니다.") _
'				)
'			Case "MEMBER2-2"
'				MAP_DEPTH2 = "이미지치환관리"
'				MAP_DEPTH3 = "작성자매칭"
'				arrayLi = Array(_
'					Array(True, "글 작성시 이미지로 매칭할 아이디를 선택합니다.") _
'				)

'======================================================================================================================
'======================================================================================================================
			Case "ORDERSALL"
				MAP_DEPTH2 = "전체주문"
				MAP_DEPTH3 = "전체주문리스트"
				arrayLi = Array(_
					Array(True, INFO_TEXT & "의 전체주문리스트를 볼 수 있습니다.") _
				)
			Case "ORDERS1-0"
				MAP_DEPTH2 = "주문관리"
				MAP_DEPTH3 = "신규(입금확인 전) 주문 리스트"
				arrayLi = Array(_
					Array(True, "신규(입금확인 전) 주문 리스트를 볼 수 있습니다.") _
				)
			Case "ORDERS1-1"
				MAP_DEPTH2 = "주문관리"
				MAP_DEPTH3 = "입금확인(배송준비중인) 주문 리스트"
				arrayLi = Array(_
					Array(True, "입금확인(배송준비중인) 주문 리스트를 볼 수 있습니다.") _
				)
			Case "ORDERS1-2"
				MAP_DEPTH2 = "주문관리"
				MAP_DEPTH3 = "배송완료(배송중인) 주문 리스트"
				arrayLi = Array(_
					Array(True, "배송완료(배송중인) 주문 리스트를 볼 수 있습니다.") _
				)
			Case "ORDERS1-3"
				MAP_DEPTH2 = "주문관리"
				MAP_DEPTH3 = "구매확정(수취확인)된 주문 리스트"
				arrayLi = Array(_
					Array(True, "구매확정(수취확인)된 주문 리스트를 볼 수 있습니다.") _
				)
			Case "ORDERS2-1"
				MAP_DEPTH2 = "취소주문"
				MAP_DEPTH3 = "관리자 주문취소 리스트"
				arrayLi = Array(_
					Array(True, "관리자가 취소한 주문 리스트를 볼 수 있습니다.") _
				)
			Case "ORDERS3-1"
				MAP_DEPTH2 = "취소주문"
				MAP_DEPTH3 = "주문취소요청 리스트"
				arrayLi = Array(_
					Array(True, "구매자가 취소요청한 주문 리스트를 볼 수 있습니다.") _
				)
			Case "ORDERS3-2"
				MAP_DEPTH2 = "취소주문"
				MAP_DEPTH3 = "주문취소완료 리스트"
				arrayLi = Array(_
					Array(True, "주문취소가 완료되 리스트를 볼 수 있습니다.") _
				)


			Case "ORDERS4-1"
				MAP_DEPTH2 = "결제관리"
				MAP_DEPTH3 = "수동결제목록"
				arrayLi = Array(_
					Array(True, "수동결제된 리스트의 내역을 확인할 수 있습니다.") _
				)

			Case "ORDERS4-2"
				MAP_DEPTH2 = "결제관리"
				MAP_DEPTH3 = "수동결제"
				arrayLi = Array(_
					Array(True, "이 페이지는 I Safe Key IN 방식의 결제을 요청하는 페이지입니다."), _
					Array(True, """결제하기"" 버튼을 누르면 결제 정보를 안전하게 암호화하기 위한 플러그인 창이 출력됩니다."), _
					Array(True, "플러그인에서 제시하는 단계에 따라 정보를 입력한 후 <b>[결제 정보 확인]</b> 단계에서 ""확인"" 버튼을 누르면 결제처리가 시작됩니다."), _
					Array(True, "통신환경에 따라 다소 시간이 걸릴수도 있으니 결제결과가 표시될때까지 ""중지"" 버튼을 누르거나 브라우저를 종료하시지 말고 잠시만 기다려 주십시오."), _
					Array(True, "<span class=""red"">결제 중 오류가 발생 시 이니시스 파트너 페이지에서 결제가 진행되었는지 반드시 확인하시기 바랍니다.</span>"), _
					Array(True, "전자우편과 이동전화번호를 입력받는 것은 고객님의 결제성공 내역을 E-MAIL 또는 SMS 로 알려드리기 위함이오니 반드시 기입하시기 바랍니다.") _
				)

'======================================================================================================================
'======================================================================================================================
			Case "DESIGN_N01_A01"
				MAP_DEPTH2 = "배너관리"
				MAP_DEPTH3 = "홈페이지 메인 배너"
				arrayLi = Array(_
					Array(True, viewAdminLangName & " 홈페이지 메인 배너"), _
					Array(True, "<span>가로 "&IMG_WIDTH&"px, 세로 "&IMG_HEIGHT&"px</span>에 최적화 되어있으며, <span>총 "&TOPCNT&"개</span>의 이미지가 노출됩니다"), _
					Array(True, "최적 사이즈가 아닌 경우 가로축을 기준으로 리사이징 됩니다.") _
				)
			Case "DESIGN_N03_A01"
				MAP_DEPTH2 = "배너관리"
				MAP_DEPTH3 = "홈페이지 서브 배너"
				arrayLi = Array(_
					Array(True, viewAdminLangName & " 홈페이지 서브 배너 관리"), _
					Array(True, "<span>가로 "&IMG_WIDTH&"px, 세로 "&IMG_HEIGHT&"px</span>에 최적화 되어있으며, <span>총 "&TOPCNT&"개</span>의 이미지가 노출됩니다"), _
					Array(True, "최적 사이즈가 아닌 경우 가로축을 기준으로 리사이징 됩니다.") _
				)
			Case "DESIGN_M01_A01"
				MAP_DEPTH2 = "모바일 배너관리"
				MAP_DEPTH3 = "인덱스 롤링 배너"
				arrayLi = Array(_
					Array(True, viewAdminLangName & " 모바일 SHOP 롤링 배너 영역 관리"), _
					Array(True, "<span>가로 "&IMG_WIDTH&"px, 세로 "&IMG_HEIGHT&"px</span>에 최적화 되어있으며, <span>총 "&TOPCNT&"개</span>의 이미지가 노출됩니다"), _
					Array(True, "최적 사이즈가 아닌 경우 가로축을 기준으로 리사이징 됩니다.") _
				)
			Case "DESIGN_M02_A01"
				MAP_DEPTH2 = "모바일 배너관리"
				MAP_DEPTH3 = "배너 #1"
				arrayLi = Array(_
					Array(True, viewAdminLangName & " 모바일 SHOP 롤링 배너 영역 관리"), _
					Array(True, "<span>가로 "&IMG_WIDTH&"px, 세로 "&IMG_HEIGHT&"px</span>에 최적화 되어있으며, <span>총 "&TOPCNT&"개</span>의 이미지가 노출됩니다"), _
					Array(True, "최적 사이즈가 아닌 경우 가로축을 기준으로 리사이징 됩니다.") _
				)
			Case "DESIGN_M02_A02"
				MAP_DEPTH2 = "모바일 배너관리"
				MAP_DEPTH3 = "배너 #2"
				arrayLi = Array(_
					Array(True, viewAdminLangName & " 모바일 SHOP 롤링 배너 영역 관리"), _
					Array(True, "<span>가로 "&IMG_WIDTH&"px, 세로 "&IMG_HEIGHT&"px</span>에 최적화 되어있으며, <span>총 "&TOPCNT&"개</span>의 이미지가 노출됩니다"), _
					Array(True, "최적 사이즈가 아닌 경우 가로축을 기준으로 리사이징 됩니다.") _
				)
			Case "DESIGN_M02_A03"
				MAP_DEPTH2 = "모바일 배너관리"
				MAP_DEPTH3 = "배너 #3"
				arrayLi = Array(_
					Array(True, viewAdminLangName & " 모바일 SHOP 롤링 배너 영역 관리"), _
					Array(True, "<span>가로 "&IMG_WIDTH&"px, 세로 "&IMG_HEIGHT&"px</span>에 최적화 되어있으며, <span>총 "&TOPCNT&"개</span>의 이미지가 노출됩니다"), _
					Array(True, "최적 사이즈가 아닌 경우 가로축을 기준으로 리사이징 됩니다.") _
				)
			Case "DESIGN_S01_A01"
				MAP_DEPTH2 = "배너관리"
				MAP_DEPTH3 = "인덱스 롤링 배너"
				arrayLi = Array(_
					Array(True, viewAdminLangName & " 인덱스 롤링 배너"), _
					Array(True, "<span>가로 "&IMG_WIDTH&"px, 세로 "&IMG_HEIGHT&"px</span>에 최적화 되어있으며, <span>총 "&TOPCNT&"개</span>의 이미지가 노출됩니다"), _
					Array(True, "최적 사이즈가 아닌 경우 가로축을 기준으로 리사이징 됩니다.") _
				)
			Case "DESIGN_S02_A01"
				MAP_DEPTH2 = "배너관리"
				MAP_DEPTH3 = "인덱스 배너 #1"
				arrayLi = Array(_
					Array(True, viewAdminLangName & " 쇼핑몰 인덱스 배너 #1"), _
					Array(True, "<span>가로 "&IMG_WIDTH&"px, 세로 "&IMG_HEIGHT&"px</span>에 최적화 되어있으며, <span>총 "&TOPCNT&"개</span>의 이미지가 노출됩니다"), _
					Array(True, "최적 사이즈가 아닌 경우 가로축을 기준으로 리사이징 됩니다.") _
				)
			Case "DESIGN_S02_A02"
				MAP_DEPTH2 = "배너관리"
				MAP_DEPTH3 = "인덱스 배너 #2"
				arrayLi = Array(_
					Array(True, viewAdminLangName & " 쇼핑몰 인덱스 배너 #2"), _
					Array(True, "<span>가로 "&IMG_WIDTH&"px, 세로 "&IMG_HEIGHT&"px</span>에 최적화 되어있으며, <span>총 "&TOPCNT&"개</span>의 이미지가 노출됩니다"), _
					Array(True, "최적 사이즈가 아닌 경우 가로축을 기준으로 리사이징 됩니다.") _
				)
			Case "DESIGN_S02_A03"
				MAP_DEPTH2 = "배너관리"
				MAP_DEPTH3 = "인덱스 배너 #3"
				arrayLi = Array(_
					Array(True, viewAdminLangName & " 쇼핑몰 인덱스 배너 #3"), _
					Array(True, "<span>가로 "&IMG_WIDTH&"px, 세로 "&IMG_HEIGHT&"px</span>에 최적화 되어있으며, <span>총 "&TOPCNT&"개</span>의 이미지가 노출됩니다"), _
					Array(True, "최적 사이즈가 아닌 경우 가로축을 기준으로 리사이징 됩니다.") _
				)
			Case "DESIGN_S02_A04"
				MAP_DEPTH2 = "배너관리"
				MAP_DEPTH3 = "인덱스 배너 #4"
				arrayLi = Array(_
					Array(True, viewAdminLangName & " 쇼핑몰 인덱스 배너 #4"), _
					Array(True, "<span>가로 "&IMG_WIDTH&"px, 세로 "&IMG_HEIGHT&"px</span>에 최적화 되어있으며, <span>총 "&TOPCNT&"개</span>의 이미지가 노출됩니다"), _
					Array(True, "최적 사이즈가 아닌 경우 가로축을 기준으로 리사이징 됩니다.") _
				)
'======================================================================================================================
'======================================================================================================================
'======================================================================================================================
'======================================================================================================================
			'Case "GOODS1-1-1","GOODS1-1-2","GOODS1-1-3","GOODS1-1-4","GOODS1-1-5","GOODS1-1-6","GOODS1-1-7"
			Case "GOODS1-1"
				MAP_DEPTH2 = "카테고리관리"
				MAP_DEPTH3 = "카테고리 리스트"
				arrayLi = Array(_
					Array(True, viewAdminLangName & "의 쇼핑몰 카테고리를 관리할 수 있습니다.") _
				)
			Case "GOODS2-1"
				MAP_DEPTH2 = "자체 상품관리"
				MAP_DEPTH3 = "자체 상품목록"
				arrayLi = Array(_
					Array(True, viewAdminLangName & "의 노출될 상품의 목록을 보실 수 있습니다.") _
				)
			Case "GOODS3-1"
				MAP_DEPTH2 = "자체 상품관리"
				MAP_DEPTH3 = "자체 상품등록"
				arrayLi = Array(_
					Array(True, viewAdminLangName & "의 상품을 등록하실 수 있습니다.") _
				)
			'===========================================================

			Case "GOODS1-2"
				MAP_DEPTH2 = "메뉴관리"
				MAP_DEPTH3 = "메인메뉴 기본설정"
				arrayLi = Array(_
					Array(True, "메인메뉴의 기본값을 설정할 수 있습니다") _
				)
			Case "GOODS1-3"
				MAP_DEPTH2 = "메뉴관리"
				MAP_DEPTH3 = "메뉴관리"
				arrayLi = Array(_
					Array(True, "사이트 전반적인 메뉴를 설정할 수 있습니다."), _
					Array(True, "링크가 쇼핑몰이면 코드값만 입력해주세요"), _
					Array(True, "링크가 새창이거나 타 사이트의 경우 http:// 를 포함한 모든 주소를 넣어주세요") _
				)

			Case "GOODS3-1"
				MAP_DEPTH2 = "자체 상품관리"
				MAP_DEPTH3 = "자체 상품목록"
				arrayLi = Array(_
					Array(True, "상품의 목록을 보실 수 있습니다.") _
				)

			Case "GOODS3-2"
				MAP_DEPTH2 = "자체 상품관리"
				MAP_DEPTH3 = "자체 상품등록"
				arrayLi = Array(_
					Array(True, "상품을 등록하실 수 있습니다.") _
				)

			Case "GOODS3-3"
				MAP_DEPTH2 = "자체 상품관리"
				MAP_DEPTH3 = "자체 상품수정"
				arrayLi = Array(_
					Array(True, "상품을 수정하실 수 있습니다.") _
				)

			Case "GOODS3-5"
				MAP_DEPTH2 = "택배비관리"
				MAP_DEPTH3 = "유통사별 택배비 관리"
				arrayLi = Array(_
					Array(True, "유통사별 택배비 관리를 할 수 있습니다.") _
				)

			Case "GOODS3-6"
				MAP_DEPTH2 = "자체 상품관리"
				MAP_DEPTH3 = "자체 상품목록"
				arrayLi = Array(_
					Array(True, "재고수량이 일정수량 미만의 상품의 목록을 보실 수 있습니다.") _
				)

			Case "GOODS4-1"
				MAP_DEPTH2 = "카테고리관리"
				MAP_DEPTH3 = "카테고리 서브 이미지"
				arrayLi = Array(_
					Array(True, "쇼핑몰 카테고리 서브 이미지를 수정할 수 있습니다.") _
				)
			Case "GOODS5-1"
				MAP_DEPTH2 = "상품목록"
				MAP_DEPTH3 = "승인된 상품목록"
				arrayLi = Array(_
					Array(True, "물건을 등록하여 관리자의 승인이 완료되어 판매가 시작된 상품목록입니다.") _
				)
			Case "GOODS5-2"
				MAP_DEPTH2 = "상품목록"
				MAP_DEPTH3 = "승인대기 상품목록"
				arrayLi = Array(_
					Array(True, "물건을 등록하여 관리자의 승인을 기다리고 있는 상품입니다."), _
					Array(True, "상품을 승인전까지 자유롭게 수정할 수 있습니다.") _
				)
			Case "GOODS5-3"
				MAP_DEPTH2 = "상품목록"
				MAP_DEPTH3 = "재승인대기 상품목록"
				arrayLi = Array(_
					Array(True, "물건이 승인된 이후 가격이 수정되어 재승인을 기다리고 있는 상품입니다."), _
					Array(True, "상품을 승인전까지 자유롭게 수정할 수 있습니다.") _
				)
			Case "GOODS5-4"
				MAP_DEPTH2 = "상품목록"
				MAP_DEPTH3 = "승인반려 상품목록"
				arrayLi = Array(_
					Array(True, "물건을 등록하였으나 관리자가 반려한 상품입니다."), _
					Array(True, "반려사유를 보신 후 해당 조건을 수정하시기 바랍니다.") _
				)
			Case "GOODS5-5"
				MAP_DEPTH2 = "상품목록"
				MAP_DEPTH3 = "승인반려 재승인대기 상품목록"
				arrayLi = Array(_
					Array(True, "관리자가 반려한 상품중 재승인을 요청한 상품입니다."), _
					Array(True, "관리자가 상품을 재승인하기 전까지 자유롭게 수정할 수 있습니다.") _
				)


'======================================================================================================================
'======================================================================================================================
'======================================================================================================================
			Case "MYOFFICE1-1"
				MAP_DEPTH2 = "일정표관리"
				MAP_DEPTH3 = "일정관리"
				arrayLi = Array(_
					Array(True, "마이오피스 일정을 관리할 수 있습니다.") _
				)
'======================================================================================================================
			Case "MYOFFICE2-1"
				MAP_DEPTH2 = "게시판 관리"
				MAP_DEPTH3 = "공지사항 목록"
				arrayLi = Array(_
					Array(True, "마이오피스 공지사항을 관리할 수 있습니다."), _
					Array(True, "마이오피스 공지사항 목록을 볼 수 있습니다.") _
				)
			Case "MYOFFICE2-2"
				MAP_DEPTH2 = "게시판 관리"
				MAP_DEPTH3 = "공지사항 작성"
				arrayLi = Array(_
					Array(True, "마이오피스 공지사항을 작성할 수 있습니다.") _
				)
			Case "MYOFFICE2-3"
				MAP_DEPTH2 = "게시판 관리"
				MAP_DEPTH3 = "공지사항 수정 및 삭제"
				arrayLi = Array(_
					Array(True, "마이오피스 공지사항을 수정 또는 삭제 할 수 있습니다.") _
				)
			Case "MYOFFICE2-4"
				MAP_DEPTH2 = "게시판 관리"
				MAP_DEPTH3 = "공지사항 수정"
				arrayLi = Array(_
					Array(True, "마이오피스 공지사항을 수정 할 수 있습니다.") _
				)
'======================================================================================================================
			Case "MYOFFICE3-1"
				MAP_DEPTH2 = "자료실 관리"
				MAP_DEPTH3 = "자료실 목록"
				arrayLi = Array(_
					Array(True, "마이오피스 자료실을 관리할 수 있습니다."), _
					Array(True, "마이오피스 자료실 목록을 볼 수 있습니다.") _
				)
			Case "MYOFFICE3-2"
				MAP_DEPTH2 = "자료실 관리"
				MAP_DEPTH3 = "자료실 작성"
				arrayLi = Array(_
					Array(True, "마이오피스 자료실을 작성할 수 있습니다.") _
				)
			Case "MYOFFICE3-3"
				MAP_DEPTH2 = "자료실 관리"
				MAP_DEPTH3 = "자료실 수정 및 삭제"
				arrayLi = Array(_
					Array(True, "마이오피스 자료실을 수정 또는 삭제 할 수 있습니다.") _
				)
			Case "MYOFFICE3-4"
				MAP_DEPTH2 = "자료실 관리"
				MAP_DEPTH3 = "자료실 수정"
				arrayLi = Array(_
					Array(True, "마이오피스 자료실을 수정 할 수 있습니다.") _
				)
'======================================================================================================================
			Case "MYOFFICE4-1"
				MAP_DEPTH2 = "VIP Q&A"
				MAP_DEPTH3 = "VIP Q&A 관리"
				arrayLi = Array(_
					Array(True, "본인이 작성한 VIP Q&A 보거나 작성/수정 및 삭제를 할 수 있습니다.") ,_
					Array(True, "본인이 작성한 글은 <span class=""red"">관리자만</span> 확인할 수 있습니다.") _
			)

'======================================================================================================================
'인샵 마이오피스 게시판
			Case "MYOFFICE5-1"
				MAP_DEPTH2 = "게시판 관리"
				MAP_DEPTH3 = "공지사항 목록"
				arrayLi = Array(_
					Array(True, "마이오피스 공지사항을 관리할 수 있습니다.") _
				)
			Case "MYOFFICE5-2"
				MAP_DEPTH2 = "게시판 관리"
				MAP_DEPTH3 = "QNA 목록"
				arrayLi = Array(_
					Array(True, "마이오피스 QNA를 관리할 수 있습니다.") _
				)
			Case "MYOFFICE6-1"
				MAP_DEPTH2 = "자료실 관리"
				MAP_DEPTH3 = "자료실 목록"
				arrayLi = Array(_
					Array(True, "마이오피스 자료실을 관리할 수 있습니다.") _
				)


'======================================================================================================================
			Case "CBOARD1-0"
				MAP_DEPTH2 = "게시판 관리"
				MAP_DEPTH3 = "게시판"

			Case "CBOARD1-1"
				MAP_DEPTH2 = "게시판 관리"
				MAP_DEPTH3 = "공지사항"
			Case "CBOARD1-2"
				MAP_DEPTH2 = "게시판 관리"
				MAP_DEPTH3 = "자료실"

			Case "CBOARD2-1"
				MAP_DEPTH2 = "게시판 관리"
				MAP_DEPTH3 = "마이오피스 공지사항"
			Case "CBOARD2-2"
				MAP_DEPTH2 = "게시판 관리"
				MAP_DEPTH3 = "마이오피스 자료실"

'======================================================================================================================
'======================================================================================================================
'======================================================================================================================

		End Select
	End If


	Select Case ADMIN_LEFT_MODE
		Case "DEFAULT"		: MAP_DEPTH1 = "관리자모드 첫화면"
		Case "CONFIG"		: MAP_DEPTH1 = "기본설정"
		Case "MEMBER"		: MAP_DEPTH1 = "회원관리"
		Case "ACADEMY"		: MAP_DEPTH1 = "아카데미관리"
		Case "MANAGE"		: MAP_DEPTH1 = "운영관리"
		Case "COMMUNITY"	: MAP_DEPTH1 = "커뮤니티관리"
		Case "AICEDU"		: MAP_DEPTH1 = "산학협동교육관리"
		Case "BRANCH"		: MAP_DEPTH1 = "지구대관리"
		Case "GOODS"		: MAP_DEPTH1 = "상품관리"
		Case "ORDERS"		: MAP_DEPTH1 = "주문관리"
		Case "DESIGN"		: MAP_DEPTH1 = "디자인관리"
		Case "MYOFFICE"		: MAP_DEPTH1 = "마이오피스관리"
	End Select


	MAP_TITLE = MAP_DEPTH3
	If INFO_MODE = "" Then MAP_TITLE = MAP_DEPTH1

	MAP_DEPTH = ""
	If MAP_DEPTH1 <> "" Then MAP_DEPTH = MAP_DEPTH & MAP_DEPTH1
	If MAP_DEPTH2 <> "" Then MAP_DEPTH = MAP_DEPTH &" > "&MAP_DEPTH2
	If MAP_DEPTH3 <> "" Then MAP_DEPTH = MAP_DEPTH &" > "&MAP_DEPTH3

	PRINT "	<div id=""admin_maps"" class=""width100"" style=""padding:5px 0px 5px 0px;"">"
	PRINT "		<div class=""icon depth3title""><span class=""tweight text_red"">["&viewAdminLang&"]</span> "&MAP_TITLE&"</div>"
	PRINT "		<div class=""fright"" style=""padding-top:3px;""><i class=""fas fa-home""></i> > "&MAP_DEPTH&"</div>"
	PRINT "	</div>"

	If ADMIN_LEFT_MODE <> "" And INFO_MODE <> "" Then
		Call AdminMap(arrayLi)
	End If
%>
