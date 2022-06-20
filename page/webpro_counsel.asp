<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "BEAUTY"
	ISLEFT = "T"
	ISSUBTOP = "T"

	view = gRequestTF("view",True)
	mNum = 1


%>
<!--#include virtual = "/_include/document.asp"-->
<link rel="stylesheet" href="/css/webpro_style.css?v0">
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<div id="pages">
<%Select Case view%>
	<%Case "1"%>
			<div id="counsel02" style="font-family: 'Pretendard', sans-serif;" class="homepage09_1">
				<div class="counsel_list">
					<div class="box">
						<img src="https://www.webpro.kr/images/counsel/price01.png" alt="">
						<p>관리 이용료</p>
					</div>
					<img src="https://www.webpro.kr/images/counsel/plus.png" alt="">
					<div class="box">
						<img src="https://www.webpro.kr/images/counsel/price02.png" alt="">
						<p>유지 보수비</p>
					</div>
					<img src="https://www.webpro.kr/images/counsel/equal.png" alt="">
					<div class="box">
						<img src="https://www.webpro.kr/images/counsel/price03.png" alt="">
						<p>월 청구액</p>
					</div>
				</div>
				<div class="co02_2">
					<dl>
						<dt class="title">[관리이용료, 유지보수, 하자보수 및 추가개발의 설명]</dt>
						<dd>관리이용료는 매월 발생하는 서버비를 포함하여 관리에 필요한 입력배치 비용 및 그 밖에 매월 정상적인 서비스가 이루어기 위해 투입되는 모든 제반 비용을 포함한 것입니다. (이 때 외부에서 구입하는 라이센스 등의 비용 발생 시의 비용은 별도입니다.)</dd>
						<dd>유지보수는 기존 납품된 프로그램을 정상적으로 사용할 수 있도록 유지하는 것을 말하며, 고객님의 추가 요청 사항은 하자보수와 추가개발로 분류됩니다.</dd>
						<dd>하자보수는 제공된 프로그램에서 발생한 에러에 대하여 처리하는 것으로 기본적으로 무상으로 적용됩니다.</dd>
						<dd>추가개발은 견적서에 명시되지 않은 그 회사만의 특별한 요청으로 기능 변경 및 추가에 대하여 발생하는 것으로 작업량에 따라 무상 또는 유상으로 진행됩니다.</dd>
					</dl>
				</div>
				<div class="co02_3">
					<table>
						<tr>
							<td rowspan="2" class="td01">
								<div></div>
								<ul>
									<li class="li01">유지보수요청</li>
								</ul>
							</td>
							<td rowspan="2" class="arrow_img"></td>
							<td class="td02">
								<div></div>
								<ul>
									<li class="li01">하자보수</li>
									<li class="li02">제공된 프로그램에<br />발생한 에러에 대하여 처리</li>
								</ul>
								<em>
									<i></i><u></u>
								</em>
							</td>
							<td class="td03">
								<div></div>
								<ul>
									<li class="li01">무상진행</li>
								</ul>
							</td>
						</tr>
						<tr>
							<td class="td04">
								<div></div>
								<ul>
									<li class="li01">추가개발</li>
									<li class="li02">견적서에 명시되지 않은 <br />회사만의 특별한 요청으로 <br />기능 변경 및 추가에 대하여 발생하는 것</li>
								</ul>
								<em>
									<i></i><u></u>
								</em>
							</td>
							<td class="td05">
								<div></div>
								<ul>
									<li class="li01">유상 또는 무상진행</li>
								</ul>
							</td>
						</tr>
					</table>
				</div>
				<div class="co02_1 table">
					<dl>
						<dt class="title">[관리이용료]</dt>
						<dd class="table tb3">
							<table>
								<thead>
									<tr>
										<th>월 매출 기준</th>
										<th>월 청구비용</th>
										<th>비고</th>
									</tr>
								</thead>
								<tbody>
									<tr class="odd">
										<td class="tweight">1억 미만</td>
										<td>500,000</td>
										<td></td>
									</tr>
									<tr class="even">
										<td class="tweight">1억 이상 5억 미만</td>
										<td>800,000</td>
										<td>-</td>
									</tr>
									<tr class="odd">
										<td class="tweight">5억 이상</td>
										<td>1,000,000</td>
										<td class="red">월 30억 이상 매출 발생 시 별도 협의</td>
									</tr>
								</tbody>
							</table>
							<div class="txt">
								<p>* &nbsp;상기 금액으로 정책을 정한 배경은, 초기 시작하는 업체들의 월 고정 지급비를 최소화하여 부담을 줄여주고 차후 회사 발전 시 서로 상생할 수 있는 구조를 생각하여 만든 것입니다.<br>이 때 서버는 웹프로에서 제공하는 호스팅 서버를 기본으로 사용하며 차후 단독서버 구축 시에도 관리 이용료는 동일하게 적용됩니다.</p>
								<i></i>
							</div>
						</dd>
						<!-- <dt><span>월 관리 이용료의 기본 적용 내역과 추가개발 요청 시 적용 규정<i></i></span></dt> -->
						<dd class="management_fee">
							<ul>
								<li>1. 프로그램 하자 보수	</li>
								<li>2. 내부 호스팅 서비스 (기본 서비스 진행)
									<ol>
										<li>- 누적회원 2만명 OR 누적 매출 수 5만건 이하인 경우 내부 호스팅 사용가능</li>
										<li>- 독립서버 사용시 별도 비용 추가</li>
									</ol>
								</li>
								<li>3. 매일 1회 DB Full 백업서비스 (7일보관)</li>
								<li>4. 매일 1회 개발소스 증분 백업 (변경사항 백업)</li>
								<li>5. 보안 관련 서비스
									<ol>
										<li>- 프로그램 접속 OTP / IP 인증 서비스</li>
										<li>- UTM 보완 장비 및 WAF 보완 장비 적용</li>
										<li>- SSL 인증서 기본 적용 (1개의 도메인기준)</li>
									</ol>
								</li>
								<li>6. 기타 서버운영에 필요한 기본적인 관리 서비스</li>
								<li>7. 로그 파일 및 정크 파일 정장 및 삭제 관리 서비스</li>
								<li>8. 단독 서버 운영에 대한 기본 컴퍼넌트 기간 완료 관리</li>
								<li>9. 트래픽 초과에 대한 분산 기술적용으로 운영의 안정성 확보 검토</li>
								<li>10. 납품된 프로그램에서 에러 발생시 즉각대응 시스템 구축</li>
								<li>11. 사용자 프로그램 미숙지로 인한 고충 접수 시 담당자와 상담 후 즉각적인 사용교육을 통한 문제점을 해결</li>
							</ul>
						</dd>
					</dl>
				</div>
				<div class="co02_1 table">
					<dl>
						<dt class="title">[유지보수비]</dt>
						<dd>1. 월 관리는 기존에 개발된 프로그램이 정상적으로 작동하게 하는 하자 보수와 데이터를 안전하게 관리하는 데이터 백업과 보안 서비스를 포함합니다.</dd>
						<dd>2. 유지보수(추가개발)는 기본에 개발된 것에 수정 및 변경 작업을 통하여 원하는 데이터 값 및 원하는 모습을 표현하기 위하여 추가인력을 투입하여 작업하는 것을 말합니다.</dd>
						<dd>3. 매달 선택한 유지 보수제로 매월 25일에 자동이체 선불로 청구됩니다.</dd>
						<dd class="table tb1">
							4. 유지보수 타입 미 선택 시 유지보수는 개별비용으로 청구됩니다.
							<span>(일 인건비 30만원 기준)</span>
							<table>
								<thead>
									<tr>
										<th>타입</th>
										<th>비용</th>
										<th>유지보수 지원내역</th>
										<th>실발생비용</th>
										<th>회사 이익 발생 금액</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<th>베이직</th>
										<td>월 10만원</td>
										<td>수당관련 단순 수정작업 + 디자인 관련 이미지 및 문구변경<br>월 최대 2회 지원</td>
										<td>30만원</td>
										<td>20만원 추가 이익</td>
									</tr>
									<tr>
										<th>라이트</th>
										<td>월30만원</td>
										<td>수당관련 단순 수정작업 + 디자인 관련 이미지 및 문구변경<br>월 최대 10회 지원 및 팝업 이미지 디자인 월 최대 1회 제공</td>
										<td>180만원</td>
										<td>150만원 추가이익</td>
									</tr>
									<tr>
										<th>레귤러</th>
										<td>월 50만원</td>
										<td>수당관련 단순 수정작업 + 디자인 관련 이미지 및 문구변경<br>월 최대 20회 지원 및 팝업 이미지 디자인 월 최대 2회 제공</td>
										<td>360만원</td>
										<td>310만원 추가이익</td>
									</tr>
									<tr>
										<th>플러스</th>
										<td>월 100만원</td>
										<td>수당관련 단순 수정작업 + 디자인 관련 이미지 및 문구변경<br>무제한 지원 및 팝업 이미지 디자인 월 최대 5회 제공</td>
										<td>∞</td>
										<td>∞</td>
									</tr>
								</tbody>
							</table>
							<p>* 수당 관련 단순 수정 작업의 경우 마케팅플랜과 관련하여 지급률 및 기준금액 변경과 같은 기본적인 사항의 변경을 말합니다.</p>
							<p>* 디자인 원본소스는 저작권 관계로 제공되지 않습니다.</p>
						</dd>
					</dl>
				</div>
				<div class="co02_1 table">
					<dl>
						<dt class="title">[추가개발 요청 시 적용 규정]</dt>
						<dd class="table tb2">
							<div>추가 유지보수 요청 시 요청사항의 작업량을 고려하여 작업량이 월 납부된 관리이용료 내에 있으면 무상으로 지원되며, 작업량이 월 관리이용료를 초과할 시 초과된 금액만큼 소프트웨어 노임 단가가 전년도 기준으로 적용되어 청구됩니다.</div>
							<table>
								<thead>
									<tr>
										<th>추가작업비 산정기준</th>
										<th>발생액</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>프로그램및 디자인 변경 - 0.5일 기준(1회)</td>
										<td rowspan="2">15만원</td>
									</tr>
									<tr>
										<td>수당 지급률 변경 - 0.5일 기준(1회) </td>
									</tr>
									<tr>
										<td>수당 지급방식 추가 - 2일(1건당)</td>
										<td>60만원</td>
									</tr>
									<tr>
										<td>수당 추가개발 - 3일 (1건당) (난이도 "하" 일 경우)</td>
										<td>90만원</td>
									</tr>
								</tbody>
							</table>
							<p>* 수당추가개발은 개발난이도에 따라 상,중,하,최상 으로 나누어 별도 산정 됩니다.</p>
							<p>* 그외 추가개발사항은 개발 일정에 따라 비용이 산정 됩니다.</p>
						</dd>
						<dd>1. 유지보수서비스의 신청은 6개월의 약정기간을 가지며, 중도 해지 시 위약금이 발생합니다.<br>단, 상위 타입으로의 서비스 변경의 경우 약정기간의 변경 없이 변경 가능합니다.</dd>
						<dd>2. 중도 해지 시 잔여 약정 기간 동안 유지보수 비용의 20% 가 위약금으로 청구됩니다.
							<span>예시) 라이트 타입 3개월 사용 후 해지시 [3개월*30만원*20% = 18만원] 발생 및 청구</span>
						</dd>
						<dd>3. 납품 완료일 기준으로 3개월 동안은 라이트 타입으로 유지보수를 무상 지원합니다. 해당 서비스의 경우 유지보수서비스가 신청된 상태여야 합니다.</dd>
						<dd>4. 3개월 서비스 이후 6개월 동안 선택한 서비스로 약정됩니다. 단, 서비스기간 만료 전 해지가 가능합니다.</dd>
					</dl>
				</div>
			
			</div>
	<%Case Else Call ALERTS(LNG_PAGE_ALERT01,"BACK","")%>
<%End Select%>
</div>
<!--#include virtual = "/_include/copyright.asp"-->
