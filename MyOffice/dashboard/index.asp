<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MYOFFICE"
	INFO_MODE	 = "DASHBOARD"

	ISLEFT = "T"
	ISSUBTOP = "T"

	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,2)
	'Call ONLY_CS_MEMBER()
	Call ONLY_CS_MEMBER_ALL()											'◈(소비자) 조회 허용 DK_MEMBER_STYPE
	Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)

	If DK_MEMBER_STYPE = 1 Then Response.Redirect "/MyOffice/buy/order_list.asp"

	SDATE = pRequestTF("SDATE",False)
	EDATE = pRequestTF("EDATE",False)

	PAGE = pRequestTF("PAGE",False)
	PAGESIZE = 15
	If PAGE = "" Then PAGE = 1

	ThisM_1stDate = Left(Date(),8)&"01"				'이번달 1일

%>
<!--#include virtual = "/_include/document.asp"-->
<link rel="stylesheet" href="/css/myoffice.css?v1" />
<!-- <script type="text/javascript" src="/jscript/calendar.js"></script> -->
<script type="text/javascript" src="/jscript/Chart.2.1.4.min.js"></script>
<script type="text/javascript" src="chart-style.js"></script>
<script type="text/javascript">
<!--

// -->
</script>
</head>

<body>
	<!--#include virtual = "/_include/header.asp"-->
	<div class="dashboard">
		<div class="datepicker">
			<p>
				<%=LNG_DASHBOARD_SALES_PERIOD%> :</p>
			<!-- <input type="text" name="" class="datepicker"> -->
			<!-- <input type="text" name="" class="datepicker-here"> -->
			<input type="text" class="datepicker-here" value="2020.07.02 - 2021.08.02">
			<!-- <input type="text" id="SDATE" name="SDATE" value="<%=SDATE%>" readonly="readonly" onclick="openCalendar(event, this, 'YYYY-MM-DD');" />
		<span>-</span>
		<input type="text" id="EDATE" name="EDATE" value="<%=EDATE%>" readonly="readonly" onclick="openCalendar(event, this, 'YYYY-MM-DD');" /> -->
			<i class="icon-angle-down"></i>
		</div>
		<script>
			$('.datepicker-here').datepicker({
				multipleDates: 2,
				multipleDatesSeparator: ' - ',
			});
		</script>
		<!-- <input type="submit" class="txtBtn small2 radius3" value="<%=LNG_TEXT_SEARCH%>"/> -->
		<div class="info">
			<h5>
				<i class="icon-info"></i>
				<span>My Information</span>
			</h5>
			<div class="position"><span>
					<%=LNG_TEXT_POSITION%></span>
				<p>
					<%=className%>
				</p>
			</div>
			<div class="regtime"><span>
					<%=LNG_TEXT_REGTIME%></span>
				<p>
					<%=regDate%>
				</p>
			</div>
		</div>
		<div class="payout">
			<div class="graph">
				<p></p>
				<span></span>
			</div>
			<p class="current">
				<%=LNG_DASHBOARD_PAYOUT%>
			</p>
			<div class="rate">
				<span>
					<% 
		If sumPrice > 0 Then 
			PRINT FormatNumber((MINUS_TOTAL_MILEAGE / sumPrice * 100), 2)
		Else
			PRINT "0"
		End If
		%>
				</span> %
			</div>
			<% '<span class="eos">1 EOS : 4.7792/USD</span> %>
		</div>
		<div class="total">
			<div class="total-sales">
				<h6>
					<%=LNG_DASHBOARD_SALES%>
				</h6>
				<p>$ <span>
						<%=num2Cur(sumPrice)%></span></p>
			</div>
			<div class="total-bonus">
				<h6>
					<%=LNG_DASHBOARD_BONUS%>
				</h6>
				<p>$ <span>
						<%=num2CurG(PLUS_TOTAL_MILEAGE_AVAIL)%></span></p>
			</div>
			<div class="total-withdrawal">
				<h6>
					<%=LNG_DASHBOARD_WITHDRAWAL%>
				</h6>
				<p>$ <span>
						<%=num2CurG(MINUS_TOTAL_MILEAGE)%></span></p>
			</div>
			<div class="total-coinpoint">
				<h6>
					<%=LNG_DASHBOARD_COINPOINT%>
				</h6>
				<p>$ <span>
						<%=num2CurG(caionPoint)%></span></p>
			</div>
		</div>
		<%If true Then%>
		<script type="text/javascript">
			$(function(){
				var labelsB = ['내 실적']; //LNG_TEXT_MY_RECORD
				var performance = {
					labels: labelsB,
					datasets: [{
							type: 'bar',
							label: '본인 누계매출',
							data: [675300],
							backgroundColor: $mainColor,
							arr: '원',
						},
						{
							type: 'bar',
							label: '당월 소실적 매출',
							data: [100000],
							backgroundColor: $subColor,
							arr: 'PV',
						},
					],
				};
				
				var labelsD = ['추천 1대']; //LNG_TEXT_MY_RECORD
				var performanceD = {
					labels: labelsD,
					datasets: [
						{
							type: 'doughnut',
							label: '매출',
							class: 'doughnutOuter',
							data: [100230],
							backgroundColor: $mainColor,
							//backdropColor: '#eeeeee',
							arr: 'PV',
							borderWidth: 0,
						},
						{
							type: 'doughnut',
							label: '반품',
							class: 'doughnutInner',
							data: [14000],
							backgroundColor: $subColor,
							arr: 'PV',
							borderWidth: 0,
						},
					],
				};

				var labelsV = ['1라인', '2라인']; //LNG_TEXT_MY_RECORD
				var data1 = [2576884, 4068420];
				var data2 = [-104000, -560000];
				var data1bg = ['#f28d8d', '#ffea81'];
				var data2bg = ['#e61a1a', '#ffd501'];
				var performanceV = {
					labels: labelsV,
					datasets: [
						{
							type: 'horizontalBar',
							label: '매출',
							data: data1,
							backgroundColor: data1bg,
							arr: 'PV',
							borderWidth: 0,
						},
						{
							type: 'horizontalBar',
							label: '반품',
							data: data2,
							backgroundColor: data2bg,
							arr: 'PV',
							borderWidth: 0,
						},
					],
				};

				var labelsLines = ['3STAR', '4STAR', '골드디렉트', '루비디렉트', '에메랄드디렉트', '다이아몬드디렉트', '더블다이아몬드'];
				var data1 = [49, 29, 7, 3, 1, 0, 0];
				var data2 = [13, 4, 1, 0, 1, 0, 0];
				var chartFillLines = {
					labels: labelsLines,
					datasets: [
						{
							type: 'line',
							label: '1라인',
							data: data1,
							borderColor: $mainColor,
							backgroundColor: hexToRGB($mainColor, 0.1),
							pointBackgroundColor: $mainColor,
							//borderWidth: 1,
						},
						{
							type: 'line',
							label: '2라인',
							data: data2,
							borderColor: $subColor,
							backgroundColor: hexToRGB($subColor, 0.1),
							pointBackgroundColor: $subColor,
							//borderWidth: 0,
							z: 1,
						},
					],
				};

				window.onload = function() {
					var ctxB = $('.chartB').get(0).getContext("2d");
					window.barChart = new Chart(ctxB, {
						type: 'bar',
						data: performance,
						options: {
							responsive: true,
							maintainAspectRatio: false,
							scales: {
								xAxes: [{
									barPercentage: 0.7,
									ticks: {
										beginAtZero: true,
										display: false,
									},
									gridLines: {
										display: false,
										color: '#cfd8dc',
										//drawBorder: false,
										//drawTicks: false,
										//drawOnChartArea: false,
									},
								}],
								yAxes: [{
									ticks: {
										//display: false,
										beginAtZero: true,
										stepSize: 100000,
										fontColor: '#90A4AE',
										fontSize: 12,
										padding: 10,
									},
									gridLines: {
										//display: false,
										color: '#cfd8dc',
										drawBorder: false,
										drawTicks: false,
										//drawOnChartArea: false,
									},
								}]
							},
							legend: false,
							legendCallback: function(chart) {
								return drawCustomLegend(chart);
							} // 사용자 범례를 만들 때 쓰는 함수를 지정하거나 작성한다.
						}
					});

					var ctxD = $('.chartD').get(0).getContext("2d");
					window.doughnutChart = new Chart(ctxD, {
						type: 'doughnut',
						data: performanceD,
						options: {
							responsive: true,
							maintainAspectRatio: false,
							cutoutPercentage: 70,
							scales: {
								backgroundColor: '#eeeeee',
							},
							legend: false,
							legendCallback: function(chart) {
								return drawCustomLegend(chart);
							}
						}
					});

					var ctxV = $('.chartV').get(0).getContext("2d");
					window.verticalChart = new Chart(ctxV, {
						type: 'horizontalBar',
						data: performanceV,
						options: {
							responsive: true,
							maintainAspectRatio: false,
							scales: {
								xAxes: [{
									categoryPercentage: 0.5,
									barPercentage: 0.5,
									stacked: true,
									ticks: {
										//display: false,
										beginAtZero: true,
										stepSize: 1000000,
										fontColor: '#90A4AE',
										fontSize: 12,
										padding: 10,
									},
									gridLines: {
										//display: false,
										color: '#cfd8dc',
										drawBorder: false,
										drawTicks: false,
										//drawOnChartArea: false,
									},
								}],
								yAxes: [{
									categoryPercentage: 0.5,
									barPercentage: 0.5,
									stacked: true,
									backgroundColor: '#eeeeee',
									ticks: {
										//display: false,
										beginAtZero: true,
										stepSize: 100000,
										fontColor: '#90A4AE',
										fontSize: 12,
										padding: 10,
									},
									gridLines: {
										display: false,
										color: '#cfd8dc',
										drawBorder: false,
										drawTicks: false,
										//drawOnChartArea: false,
									},
								}]
							},
							legend: false,
							legendCallback: function(chart) {
								return drawCustomLegend(chart);
							} // 사용자 범례를 만들 때 쓰는 함수를 지정하거나 작성한다.
						}
					});

					var minNum = function(array){
						return Math.min.apply( Math, array )-1;
					};
					var maxNum = function(array){
						return Math.max.apply( Math, array )+1;
					};

					var ctxFL = $('.chartFillLines').get(0).getContext("2d");
					window.chartFillLines = new Chart(ctxFL, {
						type: 'line',
						data: chartFillLines,
						options: {
							responsive: true,
							maintainAspectRatio: false,
							hover: {
								mode: null,
							},
							clip: true,
							scales: {
								categoryPercentage: 1,
								xAxes: [{
									offset: true,
									ticks: {
										//beginAtZero: true,
										padding: 10,
										//display: false,
										suggestedMin: minNum(data1),
										suggestedMax: maxNum(data2),
									},
									gridLines: {
										display: false,
										color: '#cfd8dc',
										//drawBorder: false,
										//drawTicks: false,
										//drawOnChartArea: false,
									},
								}],
								yAxes: [{
									ticks: {
										offset: true,
										//display: false,
										beginAtZero: true,
										stepSize: 10,
										fontColor: '#90A4AE',
										fontSize: 12,
										padding: 10,
									},
									gridLines: {
										//display: false,
										color: '#cfd8dc',
										drawBorder: false,
										drawTicks: false,
										//drawOnChartArea: false,
									},
								}]
							},
							legend: false,
							legendCallback: function(chart) {
								return drawCustomLegend(chart);
							} // 사용자 범례를 만들 때 쓰는 함수를 지정하거나 작성한다.
						}
					});
					
					$('#chartLegend1').html(window.barChart.generateLegend());//사용자 범례 자리에 해당 차트에 대한 사용자 범례 코드를 넣는다.
					$('#chartLegend2').html(window.doughnutChart.generateLegend());
					$('#chartLegend3').html(window.verticalChart.generateLegend());
					$('#chartLegend4').html(window.chartFillLines.generateLegend());

					Chart.helpers.each(Chart.instances, function(instance){
						console.log(instance);
						console.log(instance.config.type);
						console.log(instance.data);
						console.log(instance.data.datasets[1].class);
					});

				};
			});
		</script>

		<div class="performance">
			<h5>
				<%=LNG_TEXT_MY_RECORD%>
			</h5>
			<!--https://www.chartjs.org/docs/latest/charts/bar.html-->
			<div id="chartArea1">
				<canvas class="chartB"></canvas>
				<div id="chartLegend1" class="chartjs-legend"></div>
			</div>
		</div>
		<div class="performance-doughnut">
			<h5>
				<%=LNG_TEXT_MY_RECORD%>2
			</h5>
			<!--https://www.chartjs.org/docs/latest/samples/other-charts/doughnut.html-->

			<div id="chartArea2">
				<canvas class="chartD"></canvas>
				<div id="chartLegend2" class="chartjs-legend"></div>
			</div>
		</div>
		<div class="performance-vertical">
			<h5>
				<%=LNG_TEXT_MY_RECORD%>3
			</h5>
			<!--https://www.chartjs.org/docs/latest/samples/other-charts/doughnut.html-->

			<div id="chartArea3">
				<canvas class="chartV"></canvas>
				<div id="chartLegend3" class="chartjs-legend"></div>
			</div>
		</div>
		<div class="performance-fillLines">
			<h5>
				<%=LNG_TEXT_MY_RECORD%>4
			</h5>
			<!--https://www.chartjs.org/docs/latest/samples/other-charts/doughnut.html-->

			<div id="chartArea4">
				<canvas class="chartFillLines"></canvas>
				<div id="chartLegend4" class="chartjs-legend"></div>
			</div>
		</div>
		<% End If %>
		<div class="voter">
			<h5>
				<%=LNG_DASHBOARD_VOTER%>
			</h5>
			<div class="link">
				<p>https://nt.w-pro.kr/</p>
				<button>Copy</button>
			</div>
		</div>

		<div class="notice">
			<h5>
				<%=LNG_MYOFFICE_NOTICE%>
				<button class="more"><%=LNG_TEXT_MORE%><i class="icon-right-dir"></i></button>
			</h5>
			<ul>
				<li class="title">
					<p><%=LNG_BOARD_TYPE_BOARD_TEXT02%></p>
					<span><%=LNG_BOARD_TYPE_BOARD_TEXT04%></span>
				</li>
				<li>
					<a href="#">
						<p>마이오피스 공지사항입니다.</p>
						<span>21.08.02</span>
					</a>
				</li>
				<li>
					<a href="#">
						<p>마이오피스 공지사항입니다. 마이오피스 공지사항입니다.</p>
						<span>21.08.02</span>
					</a>
				</li>
				<li>
					<a href="#">
						<p>마이오피스 공지사항입니다.</p>
						<span>21.08.02</span>
					</a>
				</li>
				<li>
					<a href="#">
						<p>마이오피스 공지사항 공지사항 공지사항</p>
						<span>21.08.02</span>
					</a>
				</li>
			</ul>
		</div>

		<div class="order-list">
			<h5>
				<%=LNG_MYOFFICE_BUY%>
				<button class="more"><%=LNG_TEXT_MORE%><i class="icon-right-dir"></i></button>
			</h5>
			<table>
				<thead>
					<tr>
						<th><%=LNG_BOARD_TYPE_BOARD_TEXT01%></th>
						<th><%=LNG_TEXT_ORDER_DATE%></th>
						<th><%=LNG_TEXT_ORDER_NUMBER%></th>
						<th><%=LNG_TEXT_PAY_PRICE%></th>
						<th><%=LNG_STRTEXT_TEXT_PV%></th>
						<th><%=LNG_TEXT_ORDER_APPROVAL_TF%></th>
						<th><%=LNG_TEXT_PAY_CATEGORY%></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>5</td>
						<td>2021-08-04</td>
						<td>20210804112548904982</td>
						<td>1,002,500</td>
						<td>1,002</td>
						<td>
							<span class="sq-red"><%=LNG_TEXT_ORDER_DISAPPROVAL%></span>
						</td>
						<td>
							<span class="sq-yellow"><%=LNG_TEXT_RETURN%></span>
						</td>
					</tr>
					<tr>
						<td>4</td>
						<td>2021-08-04</td>
						<td>20210804112548904982</td>
						<td>1,002,500</td>
						<td>1,002</td>
						<td>
							<span class="sq-red"><%=LNG_TEXT_ORDER_DISAPPROVAL%></span>
						</td>
						<td>
							<span class="sq-indigo"><%=LNG_TEXT_EXCHANGE%></span>
						</td>
					</tr>
					<tr>
						<td>3</td>
						<td>2021-08-04</td>
						<td>20210804112548904982</td>
						<td>1,002,500</td>
						<td>1,002</td>
						<td>
							<span class="sq-blue"><%=LNG_TEXT_ORDER_APPROVAL%></span>
						</td>
						<td>
							<span class="sq-yellow"><%=LNG_TEXT_RETURN%></span>
						</td>
					</tr>
					<tr>
						<td>2</td>
						<td>2021-08-04</td>
						<td>20210804112548904982</td>
						<td>20,100,000</td>
						<td>20,100</td>
						<td>
							<span class="sq-blue"><%=LNG_TEXT_ORDER_APPROVAL%></span>
						</td>
						<td>
							<span class="sq-green"><%=LNG_TEXT_ORDER%></span>
						</td>
					</tr>
					<tr>
						<td>1</td>
						<td>2021-08-04</td>
						<td>20210804112548904982</td>
						<td>20,100,000</td>
						<td>20,100</td>
						<td>
							<span class="sq-blue"><%=LNG_TEXT_ORDER_APPROVAL%></span>
						</td>
						<td>
							<span class="sq-green"><%=LNG_TEXT_ORDER%></span>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
	<!--#include virtual = "/_include/copyright.asp"-->