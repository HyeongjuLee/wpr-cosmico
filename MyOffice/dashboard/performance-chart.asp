<style type="text/css"> .chartjs-legend ol, .chartjs-legend ul { list-style: none; margin:0; padding:0; text-align:right; } .chartjs-legend li { cursor:pointer; display: inline-table; margin: 10px 4px; } .chartjs-legend li span.bar{ position:relative; padding: 0px 10px; margin: 5px; border-radius:100px; color:white; } .chartjs-legend li span.line{ position:relative; padding: 1px 10px; margin: 5px; color:white; } .chartjs-legend li div.line{ float:left; height:2px; background:#000; font-size:0; line-height:0; width:25px; padding:1px 0px; border-radius:100px; margin: 9px 5px; } </style>

<script>
	var barChartData = {
		labels: ["January", "February", "March", "April", "May", "June", "July"],
		datasets: [{
				type: 'line',
				label: 'line',
				borderColor: "#1E90FF",
				fill: false,
				data: [
					Math.random() * 90000,
					Math.random() * 90000,
					Math.random() * 90000,
					Math.random() * 90000,
					Math.random() * 90000,
					Math.random() * 90000,
					Math.random() * 90000
				]
			},
			{
				type: 'bar',
				label: 'bar',
				backgroundColor: "#F7464A",
				data: [
					Math.random() * 90000,
					Math.random() * 90000,
					Math.random() * 90000,
					Math.random() * 90000,
					Math.random() * 90000,
					Math.random() * 90000,
					Math.random() * 90000
				]
			}
		]
	};

	window.onload = function() {
		var ctx = $('#chart').get(0).getContext("2d");
		window.theChart = new Chart(ctx, {
			type: 'bar',
			data: barChartData,
			options: {
				legend: false,
				legendCallback: function(chart) {
					return drawCustomLegend(chart);
				} // 사용자 범례를 만들 때 쓰는 함수를 지정하거나 작성한다.
			}
		});
		$('#chartLegend').html(window.theChart.generateLegend()); //사용자 범례 자리에 해당 차트에 대한 사용자 범례 코드를 넣는다.
	};

	function drawCustomLegend(chart) {
		var text = [];
		text.push('<ul class="' + chart.id + '-legend">');
		if (chart.config.type == 'bar') { //막대차트, 막대라인차트일 경우
			var barIndex = chart.data.datasets.length;
			for (var i = 0; i < chart.data.datasets.length; i++) {
				if (chart.data.datasets[i].type == 'line' == false) {
					barIndex = i;
					break;
				}
			} //라인 형식 데이터셋이 어디까지인지 확인 
			// -> 막대 형식의 데이터셋을 라인 형식의 데이터셋보다 앞에 둘 경우 라인이 막대에 묻히기 때문에 라인 형식이 먼저 올 수 밖에 없다.
			//그러나 막대 형식의 데이터셋의 범례를 먼저 그리고 싶었기 때문에 해당 작업을 했다. 

			for (i = barIndex; i < chart.data.datasets.length; i++) {
				if (!(chart.data.datasets[i].hideLegend) && chart.data.datasets[i].label) {
					text.push('<li datasetIndex="' + i + '"><span class="bar" style="background-color:' + chart.data.datasets[i].backgroundColor + '" ></span>');
					text.push('<span>' + chart.data.datasets[i].label + '</span>');
					text.push('</li>');
				}
			} //막대 형식 데이터셋의 범례를 먼저 그림

			for (i = 0; i < barIndex; i++) {
				if (!(chart.data.datasets[i].hideLegend) && chart.data.datasets[i].label) {
					text.push('<li datasetIndex="' + i + '"><div class="line" style="background:' + chart.data.datasets[i].borderColor + '"></div>');
					text.push('<span>' + chart.data.datasets[i].label + '</span>');
					text.push('</li>');
				}
			} //막대 형식 데이터셋의 범례를 그린 후 라인 형식 데이터셋의 범례를 그림.

		} else if (chart.config.type == 'line') { //라인 차트일 경우
			for (i = 0; i < chart.data.datasets.length; i++) {
				if (!(chart.data.datasets[i].hideLegend) && chart.data.datasets[i].label) {
					text.push('<li datasetIndex="' + i + '"><span class="line" style="background-color:' + chart.data.datasets[i].borderColor + '"></span>');
					text.push('<span>' + chart.data.datasets[i].label + '</span>');
					text.push('</li>');
				}
			}
		}
		text.push('</ul>');
		return text.join("");
	}
</script>
<div id="chartArea" style="width:700px;">
	<div id="chartLegend" class="chartjs-legend"></div>
	<canvas id="chart"></canvas>
</div>
</div>



<!-- <script>
			var ctx = document.getElementById('myChart').getContext('2d');
			var labels = ['<%=LNG_DASHBOARD_DISEM_LEFT%>', '<%=LNG_DASHBOARD_DISEM_RIGHT%>'];
			var data1 = {
				labels: labels,
				datasets: [
					{
						label: '<%=LNG_DASHBOARD_DISEM_LEFT%> 1324',
						data: [675300],
						backgroundColor: [
							'#1F3BB3',
						],
						borderColor: [
							'#1F3BB3',
						],
					},
					{
						label: '<%=LNG_DASHBOARD_DISEM_RIGHT%>',
						data: [156000],
						backgroundColor: [
							'#FFB70F',
						],
						borderColor: [
							'#FFB70F',
						],
					},
				]
			};
			var myChart = new Chart(ctx, {
				type: 'bar',
				data: data1, 
				options: {
					legend: {
						display: false,
					},
					maintainAspectRatio: false,
					scales: {
						ticks: {
							display: false,
							beginAtZero: true,
						},
						grid: {
							display: false,
							drawBorder: false,
						},
						xAxes: [{
							grid: {
								color: '#111111',
								lineWidth: 2,
							},
						}],

					},

					plugins: {
						labels: {
							renter: 'percentage',
							showZero: true,
							arc: true,
							textShadow: true,
						}
					}
				}
			});
			</script> -->