
/* ##################################### */
	/* webpro Table sorter custom 2022-05-30 */
	/* table, ajax table sorter */
	/*	플러그인 호출
			<table  id="sortTable">

			$("#sortTable").wprTablesorter({
				firstColFix : true,	//첫번째열 고정
				firstColasc : false,	//첫번째열 오름차순 여부	//firstColFix=true일 경우 필수값
				noSortColumns : [8]		//정렬안하는 컬럼
			});
	*/
	/* ##################################### */

	(function($) {
		$.fn.wprTablesorter = function(options) {

			// default options. Start
			var settings = $.extend({
				// These are the defaults.
				color: "#333",
				firstColFix : false,
				firstColasc : true,
				noSortColumns: [],
			}, options );

			let firstColFix = settings.firstColFix
			let firstColasc = settings.firstColasc
			let noSortColumns = settings.noSortColumns

			//2행 이하 중단~
			let $tableRowCnt = $(this).find('tbody tr').length;
			//console.log($tableRowCnt);
			if ($tableRowCnt < 2) {return false;}

			//2행 이상일경우 ~
			let tableID = this.attr('id');

			//title css 효과  firstCol
			if (firstColFix == false) {
				$('#'+tableID+' thead th').eq(0).addClass('headerAsc');
				for (i=0, len=noSortColumns.length; i<len; i++) {
					if (noSortColumns[i] != 0) {
						$('#'+tableID+' thead th').eq(0).addClass('headerAsc');
					}
				}
			}

			//선택한 columns highlight
			$('#'+tableID+' thead th').on('click', function() {
				let $currentTable = $(this).closest('table');
				let index = $(this).index();
				//clean
				$currentTable.find('td').removeClass('highlightCol');
				//select column
				$currentTable.find('tr').each(function() {
					$(this).find('td').eq(index).addClass('highlightCol');
				});

				//정렬안하는 컬럼 선택시 중지
				for (i=0, len=noSortColumns.length; i<len; i++) {
					if (noSortColumns[i] == index) {
						return false;
					}
				}

				//순번 컬럼 고정
				if (firstColFix) {
					if (index > 0 ) {		//첫번째열은 no sort
						sortTable(index, tableID);
					}

					//첫번째열 순번 : 가장 큰수, 작은수 확인
					let smallestNumber = Number.MAX_VALUE;
					let biggestNumber = Number.MIN_VALUE;
					$('#'+tableID+' tbody tr').find("td:first").each(function() {
						smallestNumber = Math.min(smallestNumber, parseInt($(this).text(), 10));
						biggestNumber = Math.max(biggestNumber, parseInt($(this).text(), 10));
					});
					//console.log(smallestNumber,biggestNumber)

					if(firstColasc) {
						if(isNaN(smallestNumber) == false) {
							$('#'+tableID+' td.first').each(function() {
								$(this).html(smallestNumber++);
							});
						}
					}else{
						if(isNaN(biggestNumber) == false) {
							$('#'+tableID+' td.first').each(function() {
								$(this).html(biggestNumber--);
							});
						}
					}

				}else{
					sortTable(index, tableID);
				}

			});

			// Greenify the collection based on the settings variable.
			return this.css({
				//color: settings.color
			});

		};
	}(jQuery));


	function sortTable(n, tableID) {
		var table, rows, switching, i, x, y, shouldSwitch, dir, switchcount = 0;
		table = document.getElementById(tableID);

		switching = true;
		dir = "asc";
		while (switching) {
			switching = false;
			rows = table.rows;

			for (i = 1; i < (rows.length - 1); i++) {
				shouldSwitch = false;
				/* Get the two elements you want to compare */
				x = rows[i].getElementsByTagName("TD")[n];
				y = rows[i + 1].getElementsByTagName("TD")[n];

				let valx = '';
				let valy = '';

				//, . - 제거 후에 숫자열,문자열 판단,비교
				xinnerHTML = x.innerHTML.replace(/,/g, "");
				yinnerHTML = y.innerHTML.replace(/,/g, "");
				xinnerHTML = xinnerHTML.replace(/\./g, "");
				yinnerHTML = yinnerHTML.replace(/\./g, "");
				xinnerHTML = xinnerHTML.replace(/\-/g, "");
				yinnerHTML = yinnerHTML.replace(/\-/g, "");

				//if (isNaN(x.innerHTML) == true && isNaN(y.innerHTML) == true) {		//문자정렬
				if (isNaN(xinnerHTML) == true && isNaN(yinnerHTML) == true) {		//문자정렬
					valx = x.innerHTML.toLowerCase()
					valy = y.innerHTML.toLowerCase()
					//console.log(valx,valy,isNaN(valx))

				} else {			//숫자정렬
					valx = Number(xinnerHTML);
					valy = Number(yinnerHTML);
					//console.log(valx,valy,isNaN(valx))
				}

				if (dir == "asc") {
					if (valx > valy) {
						shouldSwitch = true;
						$('#'+tableID+' thead th').removeClass('headerAsc headerDesc');
						$('#'+tableID+' thead th').eq(n).addClass('headerAsc');
						break;
					}
				} else if (dir == "desc") {
					if (valx < valy) {
						shouldSwitch = true;
						$('#'+tableID+' thead th').removeClass('headerAsc headerDesc');
						$('#'+tableID+' thead th').eq(n).addClass('headerDesc');
						break;
					}
				}
			}
			if (shouldSwitch) {
				rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
				switching = true;
				switchcount ++;
			} else {
				if (switchcount == 0 && dir == "asc") {
					dir = "desc";
					switching = true;
				}
			}
		}
	}
