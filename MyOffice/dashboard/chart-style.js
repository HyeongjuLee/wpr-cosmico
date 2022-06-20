const $mainColor = '#2682c3';
const $subColor = '#FFA024';

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
				text.push('<li datasetIndex="' + i + '"><span class="bar"><i style="background:' + chart.data.datasets[i].backgroundColor + '"></i></span>');
				text.push('<span>' + chart.data.datasets[i].label + '</span>');
				text.push('<span class="value">' + chart.data.datasets[i].data + '</span>');
				text.push('<span>' + chart.data.datasets[i].arr + '</span>');
				text.push('</li>');
			}
		} //막대 형식 데이터셋의 범례를 먼저 그림

		for (i = 0; i < barIndex; i++) {
			if (!(chart.data.datasets[i].hideLegend) && chart.data.datasets[i].label) {
				text.push('<li datasetIndex="' + i + '"><span class="bar"><i style="background:' + chart.data.datasets[i].backgroundColor + '"></i></span>');
				text.push('<span>' + chart.data.datasets[i].label + '</span>');
				text.push('<span class="value">' + chart.data.datasets[i].data + '</span>');
				text.push('<span>' + chart.data.datasets[i].arr + '</span>');
				text.push('</li>');
			}
		} //막대 형식 데이터셋의 범례를 그린 후 라인 형식 데이터셋의 범례를 그림.

	} else if (chart.config.type == 'line') { //라인 차트일 경우
		for (i = 0; i < chart.data.datasets.length; i++) {
			if (!(chart.data.datasets[i].hideLegend) && chart.data.datasets[i].label) {
				text.push('<li datasetIndex="' + i + '"><span class="line"><i style="background:' + chart.data.datasets[i].borderColor + '"></i></span>');
				text.push('<span>' + chart.data.datasets[i].label + '</span>');
				text.push('</li>');
			}
		}
	} else if (chart.config.type == 'horizontalBar') { //가로 차트일 경우
		for (i = 0; i < chart.data.datasets.length; i++) {
			if (!(chart.data.datasets[i].hideLegend) && chart.data.datasets[i].label) {
				text.push('<li datasetIndex="' + i + '" class="dataset' + i + '">');
				text.push('<p class="titles">' + chart.data.labels[i] + '</p>');
				for (d = 0; d < chart.data.datasets.length; d++) {
					text.push('<div class="data' + d + '">');
					text.push('<span class="bar"><i></i></span>');
					text.push('<span>' + chart.data.datasets[d].label + '</span>');
					text.push('<span class="value">' + chart.data.datasets[d].data[i] + '</span>');
					text.push('<span>' + chart.data.datasets[i].arr + '</span>');
					text.push('</div>');
				}
				text.push('</li>');
			}
		}
	} else if (chart.config.type !== 'bar') { //바 차트가 아닐 경우
		for (i = 0; i < chart.data.datasets.length; i++) {
			if (!(chart.data.datasets[i].hideLegend) && chart.data.datasets[i].label) {
				text.push('<li datasetIndex="' + i + '"><span class="bar"><i style="background:' + chart.data.datasets[i].backgroundColor + '"></i></span>');
				text.push('<span>' + chart.data.datasets[i].label + '</span>');
				text.push('<span class="value">' + chart.data.datasets[i].data + '</span>');
				text.push('<span>' + chart.data.datasets[i].arr + '</span>');
				text.push('</li>');
			}
		}
	}
	text.push('</ul>');
	return text.join("");
}

function hexToRGB(hex, alpha) {
	var r = parseInt(hex.slice(1, 3), 16),
		g = parseInt(hex.slice(3, 5), 16),
		b = parseInt(hex.slice(5, 7), 16);

	if (alpha) {
		return "rgba(" + r + ", " + g + ", " + b + ", " + alpha + ")";
	} else {
		return "rgb(" + r + ", " + g + ", " + b + ")";
	}
}