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
	<div class="img"><img src="/images/content/marketing_plan01.jpg" alt=""></div>
	<%Else%>
	<div class="img"><img src="/m/images/content/marketing_plan01_m.jpg" alt=""></div>
	<%End If%>
	<article class="article01">
		<section>
			<h2>용어</h2>
			<table>
				<thead>
					<tr>
						<th><b>용어</b></th>
						<th><b>용어 정리</b></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<th><b>추천한 사람</b></th>
						<th><b>담당 판매원</b></th>
					</tr>
					<tr>
						<td><b>소개한 사람</b></td>
						<td><b>책임 판매원</b></td>
					</tr>
					<tr>
						<td>인센티브 계산</td>
						<td>PV</td>
					</tr>
					<tr>
						<td>회원가</td>
						<td>소비자와 판매원 모두 가입하면 회원가 구매 <br>-> 소비자 누적시 VIP등급 할인 혜택</td>
						<!-- <td>소비자와 판매원 모두 가입하면 회원가 구매 -> 소비자 누적시 VIP등급 할인 혜택</td> -->
					</tr>
					<tr>
						<td>등급가</td>
						<td>자기 자격에 따라 할인 또는 인센티브 선택</td>
					</tr>
					<tr>
						<td>판권</td>
						<td>등급가를 받기위한 누적 PV 회원가 판권 구매</td>
					</tr>
				</tbody>
			</table>
			<ul>
				<li>■ 구매에 따라 회원 등급 할인 혜택</li>
				<!-- <li>■ 자격 유지조건 無/ 한 번 취득 시 영구적 (2022.06 기준)</li> -->
				<li>■ 소비자 구매 누적시 VIP등급 자동 할인율 적용</li>
				<li>■ PV가의 80% 인센티브 지급</li>
			</ul>
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
			<ul>
				<li>■ 구매에 따라 회원 등급 할인 혜택</li>
				<!-- <li>■ 자격 유지조건 無/ 한 번 취득 시 영구적</li> -->
				<li>■ 소비자 구매 누적시 VIP등급 자동 할인율 적용</li>
			</ul>
		</section>
	</article>
	<article class="article03">
		<section class="txts">
			<h2>판매원 구매 구분</h2>
			<ul>
				<li>■ 회원(등급) 매출 (PV 누적)
					<p>1. 소비자 회원 할인구매</p>
					<p>2. 판매원 등급자격 구매</p>
				</li>
				<li>■ 판매원 매출
					<p>[ 등급 혜택 판권 ]</p>
				</li>
			</ul>
		</section>
		<section>
			<h2><div class="img"><%=SELLER%></div>셀러 등급 달성 이후</h2>
			<table>
				<thead>
					<tr>
						<th><b>셀러 판매권 취득 조건</b></th>
						<th><b>조건</b></th>
						<th>이후 재 구매 셀러 인센티브</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<th><b>PV 누적</b><br>(회원등급 판권 매출기준)</th>
						<th><b>300만PV</b></th>
						<th><b>PV 40% 할인구매</b><br>(등급 누적 X)</th>
					</tr>
					<tr>
						<td><b>판매권</b><br>(달성 이후/점수대비)</td>
						<td><span class="red big">0%(누적)</span></td>
						<td><span class="red big">40% 할인 구매</span></td>
					</tr>
					<tr>
						<td>담당 판매원<br>(추천 1대 후원판매원)</td>
						<td><span class="red big">PV 40% 지급</span></td>
						<td><span class="red big">자기 등급과 차액 지급</span></td>
					</tr>
				</tbody>
			</table>
			<ul>
				<li>■ 원천징수 제외한 금액 수령</li>
				<li>■ 셀러부터 수당 지급, 등급 달성 후 <u>익주 부터 할인율 지급</u></li>
				<!-- <li>■ 자격 유지조건 無/ 한 번 취득 시 영구적 (*추후 누적 기간 적용 / 현재 적용 안함)</li> -->
			</ul>
		</section>
	</article>
	<article class="article04">
		<section>
			<h2><div class="img"><%=MANAGER%></div>매니저 판매권 달성 이후</h2>
			<table>
				<thead>
					<tr>
						<th><b>매니저 판매권 취득 조건</b></th>
						<th><b>조건</b></th>
						<th>이후 재 구매 매니저 인센티브</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<th><b>PV 누적</b><br>(회원등급 판권 매출기준)</th>
						<th><b>650만 PV</b></th>
						<th><b>PV 45% 할인구매</b><br>(등급 누적 X)</th>
					</tr>
					<tr>
						<td><b>판매권</b><br>(달성 이후/점수대비)</td>
						<td><span class="red big">0%(누적)</span></td>
						<td><span class="red big">45% 할인 구매</span></td>
					</tr>
					<tr>
						<td>담당 판매원 (추천 1대 후원판매원)</td>
						<td><span class="red big">PV 45% 지급</span></td>
						<td><span class="red big">자기 등급과 차액 지급</span></td>
					</tr>
				</tbody>
			</table>
			<ul>
				<li>■ 원천징수 제외한 금액 수령</li>
				<li>■ 셀러부터 수당 지급, 등급 달성 후 <u>익주 부터 할인율 지급</u></li>
				<!-- <li>■ 자격 유지조건 無/ 한 번 취득 시 영구적 (*추후 누적 기간 적용 / 현재 적용 안함)</li> -->
			</ul>
		</section>
	</article>
	<article class="article05">
		<section>
			<h2><div class="img"><%=GENERAL%></div>지점장 판매권 달성 이후</h2>
			<table>
				<thead>
					<tr>
						<th><b>지점장 판매권 취득 조건</b></th>
						<th><b>조건</b></th>
						<th>이후 재 구매 매니저 인센티브</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<th><b>PV 누적</b><br>(회원등급 판권 매출기준)</th>
						<th><b>300만 PV<br>책임판매원 매니저 8명</b></th>
						<th><b>PV 50% 할인구매</b><br>(등급 누적 X)</th>
					</tr>
					<tr>
						<td><b>판매권</b><br>(달성 이후/점수대비)</td>
						<td><span class="red big">0%(누적)</span></td>
						<td><span class="red big">50% 할인 구매</span></td>
					</tr>
					<tr>
						<td>담당 판매원 (추천 1대 후원판매원)</td>
						<td><span class="red big">PV 50% 지급</span></td>
						<td><span class="red big">자기 등급과 차액 지급</span></td>
					</tr>
				</tbody>
			</table>
			<ul>
				<li>■ 원천징수 제외한 금액 수령</li>
				<li>■ 셀러부터 수당 지급, 등급 달성 후 <u>익주 부터 할인율 지급</u></li>
				<!-- <li>■ 자격 유지조건 無/ 한 번 취득 시 영구적 (*추후 누적 기간 적용 / 현재 적용 안함)</li> -->
			</ul>
		</section>
		<section class="images general">
			<h2><div class="img"><%=GENERAL%></div>지점장 판매권 달성 이후</h2>
			<div class="grid-container">
				<div class="row1 item1"><div class="img"><img src="/images/content/plan_general.svg" alt=""></div><p>지점장</p></div>

				<div class="row2 item1"><div class="img"><img src="/images/content/plan_manager.svg" alt=""></div><p>매니저</p></div>
				<div class="row2 item2"><div class="img"><img src="/images/content/plan_manager.svg" alt=""></div><p>매니저</p></div>
				<div class="row2 item3"><div class="img"><img src="/images/content/plan_manager.svg" alt=""></div><p>매니저</p></div>
				<div class="row2 item4"><div class="img"><img src="/images/content/plan_manager.svg" alt=""></div><p>매니저</p></div>
				<div class="row2 item5"><div class="img"><img src="/images/content/plan_manager.svg" alt=""></div><p>매니저</p></div>
				<div class="row2 item6"><div class="img"><img src="/images/content/plan_manager.svg" alt=""></div><p>매니저</p></div>
				<div class="row2 item7"><div class="img"><img src="/images/content/plan_manager.svg" alt=""></div><p>매니저</p></div>
				<div class="row2 item8"><div class="img"><img src="/images/content/plan_manager.svg" alt=""></div><p>매니저</p></div>
			</div>
			<div class="txt">
				<p>최소자격조건 셀러</p>
				<span>-담당판매원 8명 매니저 달성 시, 지점장</span>
			</div>
		</section>
	</article>
	<article class="article06">
		<section>
			<h2><div class="img"><%=DIRECTOR%></div>본부장 판매권 달성 이후</h2>
			<table>
				<thead>
					<tr>
						<th><b>본부장 판매권 취득 조건</b></th>
						<th><b>조건</b></th>
						<th>이후 재 구매 매니저 인센티브</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<th><b>PV 누적</b><br>(회원등급 판권 매출기준)</th>
						<th><b>300만 PV<br>책임판매원 매니저 33명<br>(또는) 지점장 3명</b></th>
						<th><b>PV 55% 할인구매</b><br>(등급 누적 X)</th>
					</tr>
					<tr>
						<td><b>판매권</b><br>(달성 이후/점수대비)</td>
						<td><span class="red big">0%(누적)</span></td>
						<td><span class="red big">55% 할인 구매</span></td>
					</tr>
					<tr>
						<td>담당 판매원 (추천 1대 후원판매원)</td>
						<td><span class="red big">PV 55% 지급</span></td>
						<td><span class="red big">자기 등급과 차액 지급</span></td>
					</tr>
				</tbody>
			</table>
			<ul>
				<li>■ 원천징수 제외한 금액 수령</li>
				<li>■ 셀러부터 수당 지급, 등급 달성 후 <u>익주 부터 할인율 지급</u></li>
				<!-- <li>■ 자격 유지조건 無/ 한 번 취득 시 영구적 (*추후 누적 기간 적용/ 현재 적용 안함)</li> -->
			</ul>
		</section>
		<section class="txts">
			<h2><div class="img"><%=DIRECTOR%></div>본부장 보너스 ID ?!</h2>
			<div class="txt">
				<p>-본부장 보너스(센터)를 통한 매출</p>
				<span>4%</span>
			</div>
		</section>
		<section class="images director">
			<h2><div class="img"><%=DIRECTOR%></div>본부장 판매권 달성 이후</h2>
			<div class="grid-container">
				<div class="row1 item1"><div class="img"><img src="/images/content/plan_director.svg" alt=""></div><p>본부장</p></div>
				
				<div class="row2 item1"><div class="img"><img src="/images/content/plan_general.svg" alt=""></div><p>지점장</p></div>
				<div class="row2 item2"><div class="img"><img src="/images/content/plan_general.svg" alt=""></div><p>지점장</p></div>
				<div class="row2 item3"><div class="img"><img src="/images/content/plan_general.svg" alt=""></div><p>지점장</p></div>
				<div class="row2 item4"><div class="img"><img src="/images/content/plan_manager.svg" alt=""></div><p>매니저</p>
					<div class="memo">
						<b>⨯33</b>
						<span>담당판매원 33명 매니저 달성</span>
					</div>
				</div>
			</div>
			<div class="txt">
				<p>최소자격조건 셀러</p>
				<span>-담당판매원 33명 매니저 달성 시 또는 지점장 3명, 본부장</span>
			</div>
		</section>
		<section class="txts">
			<h2><div class="img"><%=DIRECTOR%></div>교육 지원 보수란?!</h2>
			<div class="txt">
				<p>담당 판매원의 자격으로 교육지원 수고비 지급</p>
				<span>20%</span>
				<span>책임 판매원의 주급의 20%</span>

				<ul>
					<li>■ 원천징수 제외한 금액 수령</li>
					<li>■ 익일 20일 예정 (변동가능)</li>
				</ul>
			</div>
		</section>
	</article>
	<article class="article07">
		<section class="only_text">
			Simple is Best.
		</section>
	</article>
	<article class="article08">
		<section class="section_last">
			
			<%If ISLEFT="T" Then%>
				<table>
					<thead>
						<tr>
							<th></th>
							<th></th>
							<th>무료가입 (소비자회원)</th>
							<th>VIP (우수 소비자회원)</th>
							<th>셀러 (판매원)</th>
							<th>매니저 (판매원)</th>
							<th>지점장 (판매원)</th>
							<th>본부장 (판매원)</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<th>1<br>주급</th>
							<td>판권 구매 (재구매)</td>
							<td rowspan="6"><div><p>수당 없음</p></div></td>
							<td rowspan="6"><div><p>수당 없음<br>-우수 고객 할인</p><p>40만 PV<br>-10% 할인</p></div></td>
							<td>300만 PV</td>
							<td>650만 PV</td>
							<td>300만 PV<br>담당 매니저 8명</td>
							<td>300만 PV<br>지점장 3명<br>(또는)<br>매니저 33명</td>
						</tr>
						<tr>
							<th>2<br>주급</th>
							<td>소개수당 (첫구매)</td>
							<td>40%</td>
							<td>45%</td>
							<td>50%</td>
							<td>55%</td>
						</tr>
						<tr>
							<th><span class="red">3</span><br>월급</th>
							<td>책임교육 (담당판매원)</td>
							<td colspan="4">담당 판매원 <span class="red">주급</span>의 20%</td>
						</tr>
						<tr>
							<th>4<br>월급</th>
							<td>장려금</td>
							<td>-</td>
							<td>3%</td>
							<td>2%</td>
							<td>2%</td>
						</tr>
						<tr>
							<th>5<br>월급</th>
							<td>아카데미 인센티브</td>
							<td colspan="4">아카데미 전체 매출 3%<br>샵(사업자등록증) + 미용자격증 업로드</td>
						</tr>
						<tr>
							<th>6<br>월급</th>
							<td>본부장 보너스 (센터)</td>
							<td>-</td>
							<td>-</td>
							<td>-</td>
							<td>본부장 그룹 전체 매출4%</td>
						</tr>
					</tbody>
				</table>
			<%Else%>
				<table>
					<thead>
						<tr>
							<th></th>
							<th>1<br>주급</th>
							<th>2<br>주급</th>
							<th><span class="red">3</span><br>월급</th>
							<th>4<br>월급</th>
							<th>5<br>월급</th>
							<th>6<br>월급</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<th></th>
							<td>판권 구매 (재구매)</td>
							<td>소개 수당 (첫구매)</td>
							<td>책임 교육 (담당 판매원)</td>
							<td>장려금</td>
							<td>아카데미 인센티브</td>
							<td>본부장 보너스 (센터)</td>
						</tr>
						<tr>
							<th>무료 가입 (소비자 회원)</th>
							<td colspan="6"><div><p>수당 없음</p></div></td>
						</tr>
						<tr>
							<th>VIP (우수 소비자 회원)</th>
							<td colspan="6"><div><p>수당 없음<br>-우수 고객 할인</p><p>40만 PV<br>-10% 할인</p></div></td>
						</tr>
						<tr>
							<th>셀러 (판매원)</th>
							<td>300만 PV</td>
							<td>40%</td>
							<td rowspan="4">담당 판매원 <span class="red">주급</span>의 20%</td>
							<td>-</td>
							<td rowspan="4">아카데미 전체 매출 3%<br>샵 (사업자 등록증) + 미용 자격증 업로드</td>
							<td>-</td>
						</tr>
						<tr>
							<th>매니저 (판매원)</th>
							<td>650만 PV</td>
							<td>45%</td>
							<td>3%</td>
							<td>-</td>
						</tr>
						<tr>
							<th>지점장 (판매원)</th>
							<td>300 만PV<br>담당 매니저 8명</td>
							<td>50%</td>
							<td>2%</td>
							<td>-</td>
						</tr>
						<tr>
							<th>본부장 (판매원)</th>
							<td>300만 PV<br>지점장 3명<br>(또는)<br>매니저 33명</td>
							<td>55%</td>
							<td>2%</td>
							<td>본부장 그룹 전체 매출4%</td>
						</tr>
					</tbody>
				</table>
			<%End If%>
			<div class="txt">
				<!-- <p>주급과 월급 수령</p> -->
				<p>3번 수당을 제외한 모든 수당은 PV 기준</p>
				<!-- <p>셀러는 가입 후 수당 받기 전 공정 판매 약속 서약서 제출</p> -->
				<!-- <span>-담당판매원 판권 본인 차액 지급</span> -->
			</div>
		</section>
	</article>
	<article class="article09">
		<section class="only_text">
			<div>Thank You</div>
			<p>꼭 성공 시킵시다!</p>
		</section>
	</article>
</div>