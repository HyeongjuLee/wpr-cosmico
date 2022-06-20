<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "BUSINESS"
	ISLEFT = "T"
	ISSUBTOP = "T"

	view = gRequestTF("view",True)
	mNum = 2
	'sview = gRequestTF("sview",True)

	If view= 2 Then
		CALL ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1)
	End If
%>
<!--#include virtual = "/_include/document.asp"-->
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<style type="text/css">
	#business {width: 100%; font-size: 14px; line-height: 22px;}
	#business em {font-style: normal;}
	#business * {word-break: keep-all; word-wrap: break-word;}
	.b03 {font-size: 0; text-align: center;}
	.b03 .wrap {display: inline-block; *display: inline; zoom: 1; height: 792px;}
	.b03 .fleft, .b03 .fright {width: 540px; height: 790px; position: relative; background-size: 100%; border: 1px solid #2a2a2a;}
	.b03 .w01 .fleft {background: url(/images/content/bus03_01.jpg) no-repeat center;}
		.b03 .w01 .fleft .tit {width: 370px; height: 200px; display: inline-block; *display: inline; zoom: 1; margin: 100px 0; position: relative;}
		.b03 .w01 .fleft .tit em {position: absolute; top: 0; left: 0; width: 100%; height: 100%; background: #fff; opacity: .5; filter: alpha(opacity=50); z-index: 0;}
		.b03 .w01 .fleft .tit span {width: 253px; height: 83px; display: inline-block; *display: inline; zoom: 1; position: relative; margin-top: 25px; background: url(/images/content/logo.png) no-repeat center;}
		.b03 .w01 .fleft .tit p {position: relative; z-index: 1; color: #3b3ebb; font-size: 36px; line-height: 40px; font-weight: 900; margin-top: 15px;}
	.b03 .w02 .fleft {background: url(/images/content/bus03_02.jpg) no-repeat center;}
		.b03 .w02 .fleft .tit {color: #000; font-size: 36px; letter-spacing: 15px; margin-top: 170px; display: inline-block; *display: inline; zoom: 1; position: relative; padding: 6px; z-index: 1;}
			.b03 .w02 .fleft .tit em {color: #fff; position: absolute; bottom: 3px; right: 3px; z-index: -1; opacity: .7; filter: alpha(opacity=70);}
		.b03 .w02 .fleft .contents {width: 460px; margin: 0 auto; position: relative; overflow: hidden; height: 100%;}
		.b03 .w02 .fleft ul {position: absolute; width: 100%; left: 0; bottom: 125px;}
		.b03 .w02 .fleft li {width: 100%; padding: 10px 0; margin: 10px 0; position: relative; font-weight: 300;}
		.b03 .w02 .fleft li p {color: #fff; text-align: left; font-size: 20px; line-height: 22px; margin: 0 20px; position: relative; z-index: 1;}
		.b03 .w02 .fleft li em {width: 100%; height: 100%; position: absolute; top: 0; left: 0; background: #000; opacity: .5; filter: alpha(opacity=50); z-index: 0; border-radius: 5px;}
	.b03 .w02 .fright {background: url(/images/content/bus03_03.jpg) no-repeat center;}
		.b03 .w02 .fright .con {width: 360px; height: 610px; padding: 40px; margin: 50px; position: relative; overflow: hidden; z-index: 1;}
		.b03 .w02 .fright .con em {width: 100%; height: 100%; background: #fff; position: absolute; top: 0; left: 0; opacity: .9; filter: alpha(opacity=90); z-index: 0;}
		.b03 .w02 .fright .con * {position: relative; z-index: 1;}
		.b03 .w02 .fright .tit {font-size: 24px; font-weight: 300;}
		.b03 .w02 .fright u {width: 30px; height: 1px; background: #2a2a2a; margin: 20px 0; display: inline-block; *display: inline; zoom: 1;}
		.b03 .w02 .fright .stit {font-size: 18px; line-height: 32px; font-weight: 600; color: #6519d5; margin-bottom: 20px;}
		.b03 .w02 .fright .txt {color: #2a2a2a; font-size: 15px; line-height: 30px; text-align: left;}
		.b03 .w02 .fright .txt p {margin-bottom: 12px;}
		.b03 .w02 .fright .txt span {text-align: right; display: block;}
	.b03 .w03 .fleft {background: url(/images/content/bus03_04.jpg) no-repeat center top;}
		.b03 .w03 .fleft .tit {width: 100%; height: 170px; overflow: hidden;}
		.b03 .w03 .fleft .tit p {text-align: left; line-height: 50px; margin: 60px 40px;}
		.b03 .w03 .fleft .tit span {position: relative; color: #1b1b1b; font-size: 36px; font-weight: 300; z-index: 1; padding-right: 15px;}
		.b03 .w03 .fleft .tit u {position: absolute; top: 0; left: 0; width: 100%; height: 100%; background: #fff; opacity: .7; filter: alpha(opacity=70); z-index: -1;}
		.b03 .w03 .fleft .txt {margin: 30px 40px; display: block; overflow: hidden; text-align: left; font-size: 16px; line-height: 30px; color: #2e2e2e;}
		.b03 .w03 .fleft .txt .stit {font-size: 24px; line-height: 40px;}
		.b03 .w03 .fleft .txt ul {width: 400px; height: 450px; overflow: hidden; padding: 20px 30px; background: #fafafa; margin-top: 20px;}
		.b03 .w03 .fleft .txt li {width: 100%; float: left; margin: 3px 0;}
		.b03 .w03 .fleft .txt li .left {float: left; width: 16%;}
		.b03 .w03 .fleft .txt li u {float: left; text-decoration: none; width: 10px; text-align: center;}
		.b03 .w03 .fleft .txt li .right {float: right; width: 80%;}
		.b03 .w03 .fleft .txt li .right.img {background: url(/images/content/logo2.png) no-repeat left center; height: 46px;}
	.b03 .w03 .fright {background: url(/images/content/bus03_04.jpg) no-repeat center top;}
		.b03 .w03 .fright .tit {width: 100%; height: 170px; overflow: hidden;}
		.b03 .w03 .fright .tit p {text-align: left; line-height: 50px; margin: 60px 40px;}
		.b03 .w03 .fright .tit span {position: relative; color: #1b1b1b; font-size: 36px; font-weight: 300; z-index: 1; padding-right: 15px;}
		.b03 .w03 .fright .tit u {position: absolute; top: 0; left: 0; width: 100%; height: 100%; background: #fff; opacity: .7; filter: alpha(opacity=70); z-index: -1;}
		.b03 .w03 .fright .txt {margin: 30px 40px; display: block; overflow: hidden; text-align: left; font-size: 14px; line-height: 25px; color: #2e2e2e;}
		.b03 .w03 .fright .txt .stit {font-size: 24px; line-height: 40px;}
		.b03 .w03 .fright .txt dt {font-size: 20px; font-weight: 600; color: #2e2e2e; margin: 10px 0;}
		.b03 .w03 .fright .txt dt span {position: relative; padding: 0 5px;}
		.b03 .w03 .fright .txt dt u {position: absolute; bottom: 0; left: 0; width: 100%; height: 12px; background: #6519d5; opacity: .15; filter: alpha(opacity=15); z-index: -1;}
		.b03 .w03 .fright .txt dd .left {float: left; width: 4%;}
		.b03 .w03 .fright .txt dd .right {float: right; width: 96%;}
	.b03 .w04 .fleft {background: url(/images/content/bus03_05.jpg) no-repeat center top;}
		.b03 .w04 .fleft .tit {color: #3b3ebb; font-size: 30px; line-height: 46px; font-weight: 600; margin-top: 240px;}
		.b03 .w04 .fleft .tit span {padding: 5px 30px; position: relative; border-top: 1px solid #3b3ebb; border-bottom: 1px solid #3b3ebb;}
		.b03 .w04 .fleft .con {margin: 0 40px; margin-top: 70px; overflow: hidden;}
		.b03 .w04 .fleft dl {width: 210px;}
		.b03 .w04 .fleft .left {float: left;}
		.b03 .w04 .fleft .right {float: right;}
		.b03 .w04 .fleft dl dt {font-size: 18px; color: #2e2e2e; margin-bottom: 20px;}
		.b03 .w04 .fleft dl dd {width: 200px; height: 281px; border: 5px solid #eee;}
		.b03 .w04 .fleft .left dd {background: url(/images/content/bus03_06.jpg) no-repeat center;}
	.b03 .w04 .fright {background: url(/images/content/bus03_05.jpg) no-repeat center top;}
		.b03 .w04 .fright .tit {color: #3b3ebb; font-size: 30px; line-height: 46px; font-weight: 600; margin-top: 240px;}
		.b03 .w04 .fright .tit span {padding: 5px 30px; position: relative; border-top: 1px solid #3b3ebb; border-bottom: 1px solid #3b3ebb;}
	.b03 .w05 {text-align: left;}
	.b03 .w05 .fleft {background: url(/images/content/bus03_08.jpg) no-repeat center top;}
		.b03 .w05 p {color: #2e2e2e;}
		.b03 .w05 .tit {width: 100%; height: 170px; overflow: hidden;}
		.b03 .w05 .tit p {line-height: 50px; margin: 60px 40px;}
		.b03 .w05 .tit span {position: relative; color: #1b1b1b; font-size: 36px; font-weight: 300; z-index: 1; padding-right: 15px;}
		.b03 .w05 .tit u {position: absolute; top: 0; left: 0; width: 100%; height: 100%; background: #fff; opacity: .7; filter: alpha(opacity=70); z-index: -1;}
		.b03 .w05 .txt {width: 100%; float: left; text-align: left; margin: 10px 0;}
		.b03 .w05 .txt2 {width: 100%; height: 0px; float: left;}
		.b03 .w05 dl {margin: 30px 40px; overflow: hidden;}
		.b03 .w05 dt {color: #2a2a2a; font-size: 20px; margin: 10px 0; width: 100%; float: left;}
		.b03 .w05 dt span {position: relative;}
		.b03 .w05 dt u {background: #3c61d7; width: 100%; height: 10px; position: absolute; bottom: 0; left: 0; opacity: .4; filter: alpha(opacity=40); z-index: -1;}
		.b03 .w05 dd p {margin: 3px 0; font-size: 14px; line-height: 26px; width: 100%; float: left;}
		.b03 .w05 dd .ul01>li>p {font-weight: 500;}
		.b03 .w05 dd .ul02 {margin-left: 10px;}
		.b03 .w05 dd .ul03 {margin-left: 10px;}
		.b03 .w05 li {float: left; width: 100%;}
	.b03 .w05 .fright {background: url(/images/content/bus03_08.jpg) no-repeat center top;}
	#originalText {display: none;}
</style>
<div id="pages">
<%Select Case view%>
	<%Case "1"%>
		<div class="ready">
			<div class="tit">
				<p><%=LNG_READY_01_01%><span><%=LNG_READY_01_02%></span><%=LNG_READY_01_03%></p>
			</div>
			<div class="stit"><%=LNG_READY_02_01%></div>
		</div>
	<%Case "2"%>
		<div class="ready">
			<div class="tit">
				<p><%=LNG_READY_01_01%><span><%=LNG_READY_01_02%></span><%=LNG_READY_01_03%></p>
			</div>
			<div class="stit"><%=LNG_READY_02_01%></div>
		</div>
	<%Case "3"%>
		<div id="business" class="b03">
			<div class="wrap w01">
				<div class="fleft">
					<div class="tit">
						<em></em>
						<span></span>
						<p><%=LNG_BUSINESS_03_01%></p>
					</div>
				</div>
				<div class="fright">
				</div>
			</div>
			<div class="wrap w02">
				<div class="fleft">
					<div class="contents">
						<p class="tit"><%=LNG_BUSINESS_03_02%><em><%=LNG_BUSINESS_03_02%></em></p>
						<ul>
							<li><p><%=LNG_BUSINESS_03_02_01%></p><em></em></li>
							<li><p><%=LNG_BUSINESS_03_02_02%></p><em></em></li>
							<li><p><%=LNG_BUSINESS_03_02_03%></p><em></em></li>
							<li><p><%=LNG_BUSINESS_03_02_04%></p><em></em></li>
							<li><p><%=LNG_BUSINESS_03_02_05%></p><em></em></li>
							<li><p><%=LNG_BUSINESS_03_02_06%></p><em></em></li>
						</ul>
					</div>
				</div>
				<div class="fright">
					<div class="con">
						<em></em>
						<p class="tit"><%=LNG_BUSINESS_03_03%></p>
						<u></u>
						<p class="stit"><%=LNG_BUSINESS_03_03_01%></p>
						<div class="txt">
							<p><%=LNG_BUSINESS_03_03_02%></p>
							<p><%=LNG_BUSINESS_03_03_03%></p>
							<p><%=LNG_BUSINESS_03_03_04%></p>
							<p><%=LNG_BUSINESS_03_03_05%></p>
							<span><%=LNG_BUSINESS_03_03_06%></span>
							<span><%=LNG_BUSINESS_03_03_07%></span>
						</div>
					</div>
				</div>
			</div>
			<div class="wrap w03">
				<div class="fleft">
					<div class="tit">
						<p><span><%=LNG_BUSINESS_03_04_01%><u></u></span></p>
					</div>
					<div class="txt">
						<p class="stit"><%=LNG_BUSINESS_03_04_02%></p>
						<ul>
							<li><p class="left"><%=LNG_BUSINESS_03_04_03%></p><u> : </u><p class="right"><%=LNG_BUSINESS_03_04_04%></p></li>
							<li><p class="left"><%=LNG_BUSINESS_03_04_05%></p><u> : </u><p class="right"><%=LNG_BUSINESS_03_04_06%></p></li>
							<li><p class="left"><%=LNG_BUSINESS_03_04_07%></p><u> : </u><p class="right"><%=LNG_BUSINESS_03_04_08%></p></li>
							<li><p class="left"><%=LNG_BUSINESS_03_04_09%></p><u> : </u><p class="right"><%=LNG_BUSINESS_03_04_10%></p></li>
							<li><p class="left"><%=LNG_BUSINESS_03_04_11%></p><u> : </u><p class="right"><%=LNG_BUSINESS_03_04_12%></p></li>
							<li><p class="left"><%=LNG_BUSINESS_03_04_13%></p><u> : </u><p class="right"><%=LNG_BUSINESS_03_04_14%></p></li>
							<li><p class="left"><%=LNG_BUSINESS_03_04_15%></p><u> : </u><p class="right"><%=LNG_BUSINESS_03_04_16%></p></li>
							<li><p class="left"><%=LNG_BUSINESS_03_04_17%></p><u> : </u><p class="right"><%=LNG_BUSINESS_03_04_18%></p></li>
							<li><p class="left"><%=LNG_BUSINESS_03_04_19%></p><u> : </u><p class="right"><%=LNG_BUSINESS_03_04_20%></p></li>
							<li><p class="left"><%=LNG_BUSINESS_03_04_21%></p><u> : </u><p class="right img"></p></li>
						</ul>
					</div>
				</div>
				<div class="fright">
					<div class="tit">
						<p><span><%=LNG_BUSINESS_03_05_01%><u></u></span></p>
					</div>
					<div class="txt">
						<p class="stit"><%=LNG_BUSINESS_03_05_02%></p>
						<dl>
							<dt><span><%=LNG_BUSINESS_03_05_03%><u></u></span></dt>
							<dd><%=LNG_BUSINESS_03_05_04%></dd>
						</dl>
						<dl>
							<dt><span><%=LNG_BUSINESS_03_05_05%><u></u></span></dt>
							<dd><p class="left">1. </p><p class="right"><%=LNG_BUSINESS_03_05_06%></p></dd>
							<dd><p class="left">2. </p><p class="right"><%=LNG_BUSINESS_03_05_07%></p></dd>
							<dd><p class="left">3. </p><p class="right"><%=LNG_BUSINESS_03_05_08%></p></dd>
							<dd><p class="left">4. </p><p class="right"><%=LNG_BUSINESS_03_05_09%></p></dd>
							<dd><p class="left">5. </p><p class="right"><%=LNG_BUSINESS_03_05_10%></p></dd>
							<dd><%=LNG_BUSINESS_03_05_11%></dd>
						</dl>
						<dl>
							<dt><span><%=LNG_BUSINESS_03_05_12%><u></u></span></dt>
							<dd><%=LNG_BUSINESS_03_05_13%></dd>
						</dl>
					</div>
				</div>
			</div>
			<div class="wrap w04">
				<div class="fleft">
					<div class="tit">
						<p><span><%=LNG_BUSINESS_03_06_01%><u></u></span></p>
					</div>
					<div class="con">
						<dl class="left">
							<dt><%=LNG_BUSINESS_03_06_02%></dt>
							<dd></dd>
						</dl>
						<dl class="right">
							<dt><%=LNG_BUSINESS_03_06_03%></dt>
							<dd></dd>
						</dl>
					</div>
				</div>
				<div class="fright">
					<div class="tit">
						<p><span><%=LNG_BUSINESS_03_07_01%><u></u></span></p>
					</div>
					<div class="con">
						<dl>
							<dd></dd>
						</dl>
					</div>
				</div>
			</div>
			<div class="wrap w05">
				<div class="fleft">
					<div class="tit">
						<p><span><%=LNG_BUSINESS_03_08_01%><u></u></span></p>
					</div>
					<div id="originalText" class="con">
						<dl>
							<dt><span><%=LNG_BUSINESS_03_08_02%><u></u></span></dt>
							<dd>
								<p class="txt"><%=LNG_BUSINESS_03_08_03%></p>
								<ul class="ul01">
									<li><p><%=LNG_BUSINESS_03_08_04%></p>
										<ul class="ul02">
											<li><p><%=LNG_BUSINESS_03_08_05%></p>
												<ul class="ul03">
													<li><p><%=LNG_BUSINESS_03_08_06%></p></li>
													<li><p><%=LNG_BUSINESS_03_08_07%></p></li>
													<li><p><%=LNG_BUSINESS_03_08_08%></p></li>
													<li><p><%=LNG_BUSINESS_03_08_09%></p></li>
													<li><p><%=LNG_BUSINESS_03_08_10%></p></li>
												</ul>
											</li>
											<li><p><%=LNG_BUSINESS_03_08_11%></p></li>
											<li><p><%=LNG_BUSINESS_03_08_12%></p></li>
											<li><p><%=LNG_BUSINESS_03_08_13%></p></li>
											<li><p><%=LNG_BUSINESS_03_08_14%></p></li>
										</ul>
									</li>
									<li><p><%=LNG_BUSINESS_03_08_15%></p></li>
									<li><p><%=LNG_BUSINESS_03_08_16%></p></li>
									<li><p><%=LNG_BUSINESS_03_08_17%></p>
										<ul class="ul02">
											<li><p><%=LNG_BUSINESS_03_08_18%></p></li>
										</ul>
									</li>
									<li><p><%=LNG_BUSINESS_03_08_19%></p>
										<ul class="ul02">
											<li><p><%=LNG_BUSINESS_03_08_20%></p></li>
											<li><p><%=LNG_BUSINESS_03_08_21%></p></li>
											<li><p><%=LNG_BUSINESS_03_08_22%></p></li>
											<li><p><%=LNG_BUSINESS_03_08_23%></p></li>
										</ul>
									</li>
								</ul>
							</dd>
							<dt><span><%=LNG_BUSINESS_03_09_02%><u></u></span></dt>
							<dd>
								<p class="txt"><%=LNG_BUSINESS_03_09_03%></p>
							</dd>
							<dt><span><%=LNG_BUSINESS_03_09_04%><u></u></span></dt>
							<dd>
								<p class="txt"><%=LNG_BUSINESS_03_09_05%></p>
							</dd>
							<dt><span><%=LNG_BUSINESS_03_09_06%><u></u></span></dt>
							<dd>
								<p class="txt2"></p>
								<ul class="ul01">
									<li><p><%=LNG_BUSINESS_03_09_07%></p>
										<ul class="ul02">
											<li><p><%=LNG_BUSINESS_03_09_08%></p></li>
										</ul>
									</li>
									<li><p><%=LNG_BUSINESS_03_09_09%></p>
										<ul class="ul02">
											<li><p><%=LNG_BUSINESS_03_09_10%></p></li>
										</ul>
									</li>
									<li><p><%=LNG_BUSINESS_03_09_11%></p>
										<ul class="ul02">
											<li><p><%=LNG_BUSINESS_03_09_12%></p></li>
										</ul>
									</li>
									<li><p><%=LNG_BUSINESS_03_09_13%></p>
										<ul class="ul02">
											<li><p><%=LNG_BUSINESS_03_09_14%></p></li>
											<li><p><%=LNG_BUSINESS_03_09_15%></p></li>
										</ul>
									</li>
									<li><p><%=LNG_BUSINESS_03_09_16%></p>
										<ul class="ul02">
											<li><p><%=LNG_BUSINESS_03_09_17%></p></li>
										</ul>
									</li>
								</ul>
							</dd>
						</dl>
					</div>
					<div id="paginatedText"></div>
				</div>
				<div class="fright">
					<div class="tit">
						<p><span><%=LNG_BUSINESS_03_08_01%><u></u></span></p>
					</div>
					<div id="paginatedText"></div>
				</div>
			</div>

			<script type="text/javascript">
				function paginateText() {
					var text = document.getElementById("originalText").innerHTML; // 나중에 표시해야하는 텍스트를 가져옵니다.
					var textArray = text.split(''); // 텍스트를 단어 배열로 만듭니다.
					createPage(); // 첫 번째 페이지를 만듭니다.
					for (var i = 0; i < textArray.length; i++) { // 모든 단어를 반복합니다.
						var success = appendToLastPage(textArray[i]); // 마지막 페이지에서 단어를 채 웁니다.
						if (!success) { // 마지막 페이지에 단어를 채울 수 없는지 확인합니다.
							createPage(); // 빈 페이지를 새로 만듭니다.
							appendToLastPage(textArray[i]); // 마지막 요소에서 단어를 채 웁니다.
							}
						}
					}

					function createPage() {
						var page = document.createElement("div"); // 새로운 html 요소를 만듭니다.
						page.setAttribute("class", "con"); // 요소에 "page"클래스를 추가합니다.
						document.getElementById("paginatedText").appendChild(page); // 모든 페이지의 컨테이너에 요소를 추가합니다.
					}

					function appendToLastPage(word) {
						var page = document.getElementsByClassName("con")[document.getElementsByClassName("con").length - 1]; // 마지막 페이지 가져 오기
						var pageText = page.innerHTML; // 마지막 페이지에서 텍스트를 가져옵니다.
						page.innerHTML += word + ""; // 마지막 페이지의 텍스트를 저장합니다.
						if (560 < page.scrollHeight ) { // 페이지가 오버플로하는지 확인합니다 (공백보다 많은 단어)
							page.innerHTML = pageText; // 페이지 텍스트를 재설정합니다.
							return false; // false를 반환합니다.
						} else {
							return true; // word가 페이지에 성공적으로 채워 졌기 때문에 true를 반환합니다.
					}
				}

				paginateText();
			</script>
		</div>
	<%Case "4"%>
		<div class="ready">
			<div class="tit">
				<p><%=LNG_READY_01_01%><span><%=LNG_READY_01_02%></span><%=LNG_READY_01_03%></p>
			</div>
			<div class="stit"><%=LNG_READY_02_01%></div>
		</div>
	<%Case "5"%>
		<div class="ready">
			<div class="tit">
				<p><%=LNG_READY_01_01%><span><%=LNG_READY_01_02%></span><%=LNG_READY_01_03%></p>
			</div>
			<div class="stit"><%=LNG_READY_02_01%></div>
		</div>
	<%Case Else Call ALERTS(LNG_PAGE_ALERT01,"BACK","")%>
<%End Select%>
</div>
<!--#include virtual = "/_include/copyright.asp"-->




