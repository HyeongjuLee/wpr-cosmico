<script>
	function chartBase(chart){
		const $mainColor = '#2682c3';
		const $subColor = '#FFA024';
		var labels = new Array();
		var chartData = new Array();
	};

	function chartLoad(chart){
		window.onload = function() {
			var ctx = $('#chart').get(0).getContext("2d");
			window.theChart = new Chart(ctx, {
				type: 'bar',
				data: chartData,
				options: {
					scales: {
						xAxes: [{
							barPercentage: 0.5,
							ticks: {
								beginAtZero: true,
							}
						}],
						yAxes: [{
							ticks: {
								beginAtZero: true,
							}
						}]
					},
					legend: false,
					legendCallback: function(chart) {
						return drawCustomLegend(chart);
					} // 사용자 범례를 만들 때 쓰는 함수를 지정하거나 작성한다.
				}
			});
			$('#chartLegend').html(window.theChart.generateLegend());//사용자 범례 자리에 해당 차트에 대한 사용자 범례 코드를 넣는다.
		};
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