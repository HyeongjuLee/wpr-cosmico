<%
	'이미지 코드 간략화
	MEMBER = "<img src=""/images/content/plan_member.svg"" alt="""">"
	SELLER = "<img src=""/images/content/plan_seller.svg"" alt="""">"
	MANAGER = "<img src=""/images/content/plan_manager.svg"" alt="""">"
	GENERAL = "<img src=""/images/content/plan_general.svg"" alt="""">"
	DIRECTOR = "<img src=""/images/content/plan_director.svg"" alt="""">"
%>
<div class="plan">
	<%If ISLEFT="T" Then%>
	<div class="img"><img src="/images/content/marketing_plan01(1).jpg" alt=""></div>
	<%Else%>
	<div class="img"><img src="/m/images/content/marketing_plan01(1)_m.jpg" alt=""></div>
	<%End If%>
	<article class="article01">
		<section>
			<h2>용어</h2>
			<p>코즈미코코리아의 판매원은 Co-Workers 동료입니다.<br>코즈미코 만의 동료애를 가진 문화로 아름다운 비즈니스를 펼쳐갑니다.</p>
			<table>
				<thead>
					<tr>
						<th><b>용어</b></th>
						<th><b>용어 정리</b></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>소비자 / 회원</td>
						<td>판매원의 고객</td>
					</tr>
					<tr>
						<td>코즈미코워커스</td>
						<td>코즈미코의 판매원</td>
					</tr>
					<tr>
						<td>담당판매원</td>
						<td>선배 / 이끌어주는 동료</td>
					</tr>
					<tr>
						<td>책임판매원</td>
						<td>후배 / 책임지는 동료</td>
					</tr>
					<tr>
						<td>인센티브 계산</td>
						<td>PV [Product Vonus]</td>
					</tr>
					<tr>
						<td>소비자가</td>
						<td>가입하기 전 가격</td>
					</tr>
					<tr>
						<td>회원가</td>
						<td>회원 가입 후 가격</td>
					</tr>
					<tr>
						<td>판권가</td>
						<td><span class="blue">판권 달성 후 할인가격</span></td>
					</tr>
					<tr>
						<td>등급가</td>
						<td><span class="blue">판권 달성 전 회원가격 (누적)</span></td>
					</tr>
				</tbody>
			</table>
		</section>
		<section class="grade">
			<h2>COSMICO GRADE</h2>
			<ul>
				<li>
					<div class="img"><%=MEMBER%></div>
					<p>회원/VIP</p>
				</li>
				<li class="line"></li>
				<li>
					<div class="img"><%=SELLER%></div>
					<p>셀러</p>
				</li>
				<li>
					<div class="img"><%=MANAGER%></div>
					<p>매니저</p>
				</li>
				<li>
					<div class="img"><%=GENERAL%></div>
					<p>지점장</p>
				</li>
				<li>
					<div class="img"><%=DIRECTOR%></div>
					<p>본부장</p>
				</li>
			</ul>
		</section>
	</article>
	<article class="article02">
		<section>
			<h2><div class="img"><%=MEMBER%></div>회원가입 후 누적 VIP</h2>
			<table>
				<thead>
					<tr>
						<th><b>VIP 등급 취득 조건</b></th>
						<th><b>승급</b></th>
						<th>재 구매 할인</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<th><b>PV 누적</b> (회원 매출)</th>
						<th><b>40만 PV</b></th>
						<th>달성 후 10%</th>
					</tr>
					<tr>
						<td><b>PV 할인</b></td>
						<td><span class="red big">0%(누적)</span></td>
						<td><span class="red big">10%</span></td>
					</tr>
				</tbody>
			</table>
		</section>
	</article>
	<article class="article03">
		<section>
			<h2>
				<span>cosmico-workers</span>
				판매원 자격
			</h2>
			<p>능력에 따른 혜택, 인품에 따른 혜택, 관리에 따른 혜택</p>
			<ul>
				<li>
					<div class="img"><%=SELLER%></div>
					<h6>셀러</h6>
					<div>
						<p>추천수당</p>
						<p>재구매할인</p>
						<p>교육지원보수</p>
						<p>아카데미인센티브</p>
					</div>
				</li>
				<li>
					<div class="img"><%=MANAGER%></div>
					<h6>매니저</h6>
					<div>
						<p>추천수당</p>
						<p>재구매할인</p>
						<p>교육지원보수</p>
						<p>아카데미인센티브</p>
						<p>장려금</p>
					</div>
				</li>
				<li>
					<div class="img"><%=GENERAL%></div>
					<h6>지점장</h6>
					<div>
						<p>추천수당</p>
						<p>재구매할인</p>
						<p>교육지원보수</p>
						<p>아카데미인센티브</p>
						<p>장려금</p>
					</div>
				</li>
				<li>
					<div class="img"><%=DIRECTOR%></div>
					<h6>본부장</h6>
					<div>
						<p>추천수당</p>
						<p>재구매할인</p>
						<p>교육지원보수</p>
						<p>아카데미인센티브</p>
						<p>장려금</p>
						<p>본부장보너스</p>
					</div>
				</li>
			</ul>
			<p class="only_text">'쉽고 강력한 인센티브'</p>
		</section>
	</article>

	<article class="article04">
		<section>
			<div class="txt">
				<span>01_7Days</span>
				<h5>판권구매</h5>
				<p>취득한 판권 및 가격에 대한 할인구매</p>
			</div>
			<div class="img"><img src="/images/content/plan_img1.svg" alt=""></div>
		</section>
		<section>
			<div class="txt">
				<span>02_7Days</span>
				<h5>소개수당</h5>
				<p>일 한 것에 대한 보상</p>
			</div>
			<div class="img"><img src="/images/content/plan_img2.svg" alt=""></div>
		</section>
		<section>
			<div class="txt">
				<span>03_7Days</span>
				<h5>책임교육지원보수</h5>
				<p>담당 판매원을 잘 양성하면 받게 되는 보너스 인센티브 점수로 환산하여 회사에서 인센티브로 지급</p>
			</div>
			<div class="img num"><span>20%</span></div>
		</section>
		<section>
			<div class="txt">
				<span>04_30Days</span>
				<h5>장려금</h5>
				<p>코즈미코 동료들이 나누어 갖는 보너스 인센티브<br>*추후 장려금 제도 변경</p>
			</div>
			<div class="img">
				<table>
					<tr>
						<th>육성장려금<br>매니저</th>
						<td>3%</td>
					</tr>
					<tr>
						<th>직접판매 장려금<br>지점장</th>
						<td>2%</td>
					</tr>
					<tr>
						<th>후원장려금<br>본부장</th>
						<td>2%</td>
					</tr>
				</table>
			</div>
		</section>
		<section>
			<div class="txt">
				<span>05_30Days</span>
				<h5>아카데미 인센티브</h5>
				<p>셀러부터 자격 가능<br>뷰티 전문가들을 위한 특별 인센티브 정책<br><br>*월 1회 교육 필수</p>
			</div>
			<div class="img num"><span>3%</span></div>
		</section>
		<section>
			<div class="txt">
				<span>06_30Days</span>
				<h5>본부장 보너스</h5>
				<p>특별 본부장을 위한 보너스<br>-본사 홈페이지 등재</p>
			</div>
			<div class="img num"><span>4%</span></div>
		</section>
	</article>
	<article class="article05 section_last">
		<section>
			<div class="table">
				<table>
					<tbody>
						<tr>
							<th>마감</th>
							<th>소개</th>
							<td rowspan="8">
								<p>무료 가입 / VIP<br>(소비자 회원)<br>수당 없음<br>[회원가 구매]</p>
								<p>2세트 <br>구매 이후</p>
								<p>회원가에서<br>-10% 할인 구매 적용</p>
							</td>
							<th>셀러 (판매원)</th>
							<th>매니저 (판매원)</th>
							<th>지점장 (판매원)</th>
							<th>본부장 (판매원)</th>
						</tr>
						<tr>
							<th>1. 주마감</th>
							<td rowspan="2">판권구매 (재구매)</td>
							<td>300만 PV</td>
							<td>650만 PV</td>
							<td>300만 PV + (담당 매니저 8명)</td>
							<td>300만 PV+ (담당 지점장3명 또는 담당 매니저33명)</td>
						</tr>
						<tr>
							<th>재구매 할인율 (회원가 대비)</th>
							<td>-25%</td>
							<td>-35%</td>
							<td>-40%</td>
							<td>-45%</td>
						</tr>
						<tr>
							<th>2. 주마감</th>
							<td>소개수당 (첫구매 - 판권)</td>
							<td>40%</td>
							<td>45%</td>
							<td>50%</td>
							<td>55%</td>
						</tr>
						<tr>
							<th>3. 주마감</th>
							<td>책임교육 지원보수</td>
							<td colspan="4">담당 판매원 소개 수당 실적 20%</td>
						</tr>
						<tr>
							<th>4. 월마감</th>
							<td>장려금</td>
							<td>-</td>
							<td>육성장려금 3%</td>
							<td>직접판매장려금 2%</td>
							<td>후원장려금 2%</td>
						</tr>
						<tr>
							<th>5. 월마감</th>
							<td>아카데미 인센티브</td>
							<td colspan="4">아카데미 전체 매출 3% <br>샵 (사업자등록증) + 미용자격증 업로드 / 월1회 뷰티교육 필수</td>
						</tr>
						<tr>
							<th>6. 월마감</th>
							<td>본부장 보너스</td>
							<td colspan="3">-</td>
							<td>본부장그룹 전체 매출  4%</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="txt">
				<p>PV 기준 / 1번 수당 판권구매 할인율 차액 있을 경우, 지급</p>
				<p>*일주일 단위 마감 (수요일 시작 화요일 마감) , 10일 뒤 지급</p>
			</div>
		</section>
		<section class="only_text">
			<div>Thank You</div>
			<p>꼭 성공 시킵시다!</p>
		</section>
	</article>
</div>