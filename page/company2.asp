<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "COMPANY"
	ISLEFT = "T"
	ISSUBTOP = "T"

	view = gRequestTF("view",True)
	'sview = gRequestTF("sview",True)
	mNum = 1

%>
<!--#include virtual = "/_include/document.asp"-->
<link rel="stylesheet" type="text/css" href="http://api.typolink.co.kr/css?family=RixMj+B:400" />
<style type="text/css">
	#left {display: none;}
</style>
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
	<div id="pages">
	<%Select Case view%>
	<%Case "1"%>
		<script type="text/javascript">
			$(document).ready(function(){
				$('ul.tab li').click(function(){
					var tab_id = $(this).attr('data-tab');

					$('ul.tab li,.c06 .con').removeClass('on');

					$(this).addClass('on');
					$("#"+tab_id).addClass('on');
				});
			});
		</script>
		<div id="company" class="c06">

			<ul class="tab">
				<li class="btn on" data-tab="t01">등록 / 허가증</li>
				<li class="btn" data-tab="t02">인증서</li>
				<li class="btn" data-tab="t03">시험 / 검사성적서</li>
				<li class="btn" data-tab="t04">추천서 / 수상</li>
				<i class="line"></i>
			</ul>

			<div id="t01" class="con on">
				<div class="list">
					<a href="#" onclick="window.open('entroll.asp?view=1&sview=1','','scrollbars=no,width=660,height=900,top=40,left=500')">
						<div class="img">
							<img src="/images/entroll/company06_t1_01.jpg" alt="" />
						</div>
						<p><span>화장품 제조판매업 등록필증</span></p>
						<div class="more">more +</div>
						<i></i>
					</a>
				</div>
				<div class="list">
					<a href="#" onclick="window.open('entroll.asp?view=1&sview=2','','scrollbars=no,width=660,height=900,top=40,left=500')">
						<div class="img">
							<img src="/images/entroll/company06_t1_02.jpg" alt="" />
						</div>
						<p><span>한국원적외선협회 회원증</span></p>
						<div class="more">more +</div>
						<i></i>
					</a>
				</div>
				<div class="list">
					<a href="#" onclick="window.open('entroll.asp?view=1&sview=3','','scrollbars=no,width=660,height=900,top=40,left=500')">
						<div class="img">
							<img src="/images/entroll/company06_t1_03.jpg" alt="" />
						</div>
						<p><span>무역협회회원증</span></p>
						<div class="more">more +</div>
						<i></i>
					</a>
				</div>
				<div class="list">
					<a href="#" onclick="window.open('entroll.asp?view=1&sview=4','','scrollbars=no,width=660,height=900,top=40,left=500')">
						<div class="img">
							<img src="/images/entroll/company06_t1_04.jpg" alt="" />
						</div>
						<p><span>상표서비스등록증</span></p>
						<div class="more">more +</div>
						<i></i>
					</a>
				</div>
				<div class="list">
					<a href="#" onclick="window.open('entroll.asp?view=1&sview=5','','scrollbars=no,width=660,height=900,top=40,left=500')">
						<div class="img">
							<img src="/images/entroll/company06_t1_05.jpg" alt="" />
						</div>
						<p><span>상표등록증</span></p>
						<div class="more">more +</div>
						<i></i>
					</a>
				</div>
				<div class="list">
					<a href="#" onclick="window.open('entroll.asp?view=1&sview=6','','scrollbars=no,width=660,height=900,top=40,left=500')">
						<div class="img">
							<img src="/images/entroll/company06_t1_06.jpg" alt="" />
						</div>
						<p><span>디자인등록증</span></p>
						<div class="more">more +</div>
						<i></i>
					</a>
				</div>
				<div class="list">
					<a href="#" onclick="window.open('entroll.asp?view=1&sview=7','','scrollbars=no,width=660,height=900,top=40,left=500')">
						<div class="img">
							<img src="/images/entroll/company06_t1_07.jpg" alt="" />
						</div>
						<p><span>특허증</span></p>
						<div class="more">more +</div>
						<i></i>
					</a>
				</div>
				<div class="list">
					<a href="#" onclick="window.open('entroll.asp?view=1&sview=8','','scrollbars=no,width=660,height=900,top=40,left=500')">
						<div class="img">
							<img src="/images/entroll/company06_t1_08.jpg" alt="" />
						</div>
						<p><span>특허증</span></p>
						<div class="more">more +</div>
						<i></i>
					</a>
				</div>
				<div class="list">
					<a href="#" onclick="window.open('entroll.asp?view=1&sview=9','','scrollbars=no,width=660,height=900,top=40,left=500')">
						<div class="img">
							<img src="/images/entroll/company06_t1_09.jpg" alt="" />
						</div>
						<p><span>상표등록증</span></p>
						<div class="more">more +</div>
						<i></i>
					</a>
				</div>
				<div class="list">
					<a href="#" onclick="window.open('entroll.asp?view=1&sview=10','','scrollbars=no,width=660,height=900,top=40,left=500')">
						<div class="img">
							<img src="/images/entroll/company06_t1_10.jpg" alt="" />
						</div>
						<p><span>건강기능식품영업신고증</span></p>
						<div class="more">more +</div>
						<i></i>
					</a>
				</div>
				<div class="list">
					<a href="#" onclick="window.open('entroll.asp?view=1&sview=11','','scrollbars=no,width=660,height=900,top=40,left=500')">
						<div class="img">
							<img src="/images/entroll/company06_t1_11.jpg" alt="" />
						</div>
						<p><span>영업신고증</span></p>
						<div class="more">more +</div>
						<i></i>
					</a>
				</div>
				<div class="list">
					<a href="#" onclick="window.open('entroll.asp?view=1&sview=12','','scrollbars=no,width=660,height=900,top=40,left=500')">
						<div class="img">
							<img src="/images/entroll/company06_t1_12.jpg" alt="" />
						</div>
						<p><span>의료기기판매업신고증</span></p>
						<div class="more">more +</div>
						<i></i>
					</a>
				</div>
				<div class="list">
					<a href="#" onclick="window.open('entroll.asp?view=1&sview=13','','scrollbars=no,width=660,height=900,top=40,left=500')">
						<div class="img">
							<img src="/images/entroll/company06_t1_13.jpg" alt="" />
						</div>
						<p><span>다단계판매업등록</span></p>
						<div class="more">more +</div>
						<i></i>
					</a>
				</div>
			</div>
			<div id="t02" class="con">
				<div class="list">
					<a href="#" onclick="window.open('entroll.asp?view=2&sview=1','','scrollbars=no,width=660,height=900,top=40,left=500')">
						<div class="img">
							<img src="/images/entroll/company06_t2_01.jpg" alt="" />
						</div>
						<p><span><%=LNG_ENTROLL_02_01%></span></p>
						<div class="more">more +</div>
						<i></i>
					</a>
				</div>
				<div class="list">
					<a href="#" onclick="window.open('entroll.asp?view=2&sview=2','','scrollbars=no,width=950,height=680,top=40,left=400')">
						<div class="img center">
							<img src="/images/entroll/company06_t2_02.jpg" alt="" />
						</div>
						<p><span><%=LNG_ENTROLL_02_02%></span></p>
						<div class="more">more +</div>
						<i></i>
					</a>
				</div>
				<div class="list">
					<a href="#" onclick="window.open('entroll.asp?view=2&sview=3','','scrollbars=no,width=950,height=680,top=40,left=400')">
						<div class="img center">
							<img src="/images/entroll/company06_t2_03.jpg" alt="" />
						</div>
						<p><span><%=LNG_ENTROLL_02_03%></span></p>
						<div class="more">more +</div>
						<i></i>
					</a>
				</div>
				<div class="list">
					<a href="#" onclick="window.open('entroll.asp?view=2&sview=4','','scrollbars=no,width=660,height=900,top=40,left=500')">
						<div class="img">
							<img src="/images/entroll/company06_t2_04.jpg" alt="" />
						</div>
						<p><span><%=LNG_ENTROLL_02_04%></span></p>
						<div class="more">more +</div>
						<i></i>
					</a>
				</div>
				<div class="list">
					<a href="#" onclick="window.open('entroll.asp?view=2&sview=5','','scrollbars=no,width=660,height=900,top=40,left=500')">
						<div class="img">
							<img src="/images/entroll/company06_t2_05.jpg" alt="" />
						</div>
						<p><span><%=LNG_ENTROLL_02_05%></span></p>
						<div class="more">more +</div>
						<i></i>
					</a>
				</div>
				<div class="list">
					<a href="#" onclick="window.open('entroll.asp?view=2&sview=6','','scrollbars=no,width=660,height=900,top=40,left=500')">
						<div class="img">
							<img src="/images/entroll/company06_t2_06.jpg" alt="" />
						</div>
						<p><span><%=LNG_ENTROLL_02_06%></span></p>
						<div class="more">more +</div>
						<i></i>
					</a>
				</div>
				<div class="list">
					<a href="#" onclick="window.open('entroll.asp?view=2&sview=7','','scrollbars=no,width=660,height=900,top=40,left=500')">
						<div class="img">
							<img src="/images/entroll/company06_t2_07.jpg" alt="" />
						</div>
						<p><span><%=LNG_ENTROLL_02_07%></span></p>
						<div class="more">more +</div>
						<i></i>
					</a>
				</div>
				<div class="list">
					<a href="#" onclick="window.open('entroll.asp?view=2&sview=8','','scrollbars=no,width=660,height=900,top=40,left=500')">
						<div class="img">
							<img src="/images/entroll/company06_t2_08.jpg" alt="" />
						</div>
						<p><span><%=LNG_ENTROLL_02_08%></span></p>
						<div class="more">more +</div>
						<i></i>
					</a>
				</div>
				<div class="list">
					<a href="#" onclick="window.open('entroll.asp?view=2&sview=9','','scrollbars=no,width=660,height=900,top=40,left=500')">
						<div class="img">
							<img src="/images/entroll/company06_t2_09.jpg" alt="" />
						</div>
						<p><span><%=LNG_ENTROLL_02_09%></span></p>
						<div class="more">more +</div>
						<i></i>
					</a>
				</div>
			</div>
			<div id="t03" class="con">
				<div class="list">
					<a href="#" onclick="window.open('entroll.asp?view=3&sview=1','','scrollbars=no,width=660,height=900,top=40,left=500')">
						<div class="img">
							<img src="/images/entroll/company06_t3_01.jpg" alt="" />
						</div>
						<p><span><%=LNG_ENTROLL_03_01%></span></p>
						<div class="more">more +</div>
						<i></i>
					</a>
				</div>
				<div class="list">
					<a href="#" onclick="window.open('entroll.asp?view=3&sview=2','','scrollbars=no,width=660,height=900,top=40,left=500')">
						<div class="img">
							<img src="/images/entroll/company06_t3_02.jpg" alt="" />
						</div>
						<p><span><%=LNG_ENTROLL_03_02%></span></p>
						<div class="more">more +</div>
						<i></i>
					</a>
				</div>
				<div class="list">
					<a href="#" onclick="window.open('entroll.asp?view=3&sview=3','','scrollbars=no,width=660,height=900,top=40,left=500')">
						<div class="img">
							<img src="/images/entroll/company06_t3_03.jpg" alt="" />
						</div>
						<p><span><%=LNG_ENTROLL_03_03%></span></p>
						<div class="more">more +</div>
						<i></i>
					</a>
				</div>
				<div class="list">
					<a href="#" onclick="window.open('entroll.asp?view=3&sview=4','','scrollbars=no,width=660,height=900,top=40,left=500')">
						<div class="img">
							<img src="/images/entroll/company06_t3_04.jpg" alt="" />
						</div>
						<p><span><%=LNG_ENTROLL_03_04%></span></p>
						<div class="more">more +</div>
						<i></i>
					</a>
				</div>
				<div class="list">
					<a href="#" onclick="window.open('entroll.asp?view=3&sview=5','','scrollbars=no,width=660,height=900,top=40,left=500')">
						<div class="img">
							<img src="/images/entroll/company06_t3_05.jpg" alt="" />
						</div>
						<p><span><%=LNG_ENTROLL_03_05%></span></p>
						<div class="more">more +</div>
						<i></i>
					</a>
				</div>
			</div>
			<div id="t04" class="con">
				<div class="list">
					<a href="#" onclick="window.open('entroll.asp?view=4&sview=1','','scrollbars=no,width=660,height=900,top=40,left=500')">
						<div class="img">
							<img src="/images/entroll/company06_t4_01.jpg" alt="" />
						</div>
						<p><span><%=LNG_ENTROLL_04_01%></span></p>
						<div class="more">more +</div>
						<i></i>
					</a>
				</div>
				<div class="list">
					<a href="#" onclick="window.open('entroll.asp?view=4&sview=2','','scrollbars=no,width=660,height=900,top=40,left=500')">
						<div class="img">
							<img src="/images/entroll/company06_t4_02.jpg" alt="" />
						</div>
						<p><span><%=LNG_ENTROLL_04_02%></span></p>
						<div class="more">more +</div>
						<i></i>
					</a>
				</div>
				<div class="list">
					<a href="#" onclick="window.open('entroll.asp?view=4&sview=3','','scrollbars=no,width=660,height=900,top=40,left=500')">
						<div class="img">
							<img src="/images/entroll/company06_t4_03.jpg" alt="" />
						</div>
						<p><span><%=LNG_ENTROLL_04_03%></span></p>
						<div class="more">more +</div>
						<i></i>
					</a>
				</div>
			</div>
			<script type="text/javascript">
				$(document).ready(function() {

					// .list span 중 가장 높은 높이값과 나머지 높이값 동일하게 조절
					var maxHeight = -1;

					$('.list span').each(function() {
						maxHeight = maxHeight > $(this).height() ? maxHeight : $(this).height();
					});
					$('.list span').each(function() {
						$('.list span').height(maxHeight+18+'px');
					});
				});
			</script>
		</div>
	<%Case "7"%>
		<div id="company" class="c07">
			<ul>
				<li class="li01">
					<u class="uleft"></u>
					<u class="uright"></u>
					<p><span><%=LNG_COMPANY_06_01%></span></p>
					<s></s>
					<em></em>
					<i></i>
				</li>
				<li class="li02">
					<u class="uleft"></u>
					<u class="uright"></u>
					<p>
						<span class="sp01"><%=LNG_COMPANY_06_02%></span><span class="sp02"><%=LNG_COMPANY_06_03%></span>
					</p>
					<s></s>
					<em></em>
					<i></i>
				</li>
				<i class="middle"></i>
				<li class="li03 l01">
					<div>
						<u class="uleft"></u>
						<u class="uright"></u>
						<p>
							<u class="uleft"></u>
							<u class="uright"></u>
							<span><%=LNG_COMPANY_06_04%></span>
							<s></s>
						</p>
						<s></s>
						<em></em>
						<i></i>
					</div>
					<dl class="dl01">
						<dt>
							<u class="uleft"></u>
							<u class="uright"></u>
							<p><span><%=LNG_COMPANY_06_05%></span></p>
							<s></s>
						</dt>
						<dd>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_06%></span></p>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_07%></span></p>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_08%></span></p>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_09%></span></p>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_10%></span></p>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_11%></span></p>
						</dd>
					</dl>
					<dl class="dl02">
						<dt>
							<u class="uleft"></u>
							<u class="uright"></u>
							<p><span><%=LNG_COMPANY_06_12%></span></p>
							<s></s>
						</dt>
						<dd>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_13%></span></p>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_14%></span></p>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_15%></span></p>
						</dd>
					</dl>
					<dl class="dl03">
						<dt>
							<u class="uleft"></u>
							<u class="uright"></u>
							<p><span><%=LNG_COMPANY_06_16%></span></p>
							<s></s>
						</dt>
						<dd>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_17%></span></p>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_18%></span></p>
						</dd>
					</dl>
				</li>
				<li class="li03 l02">
					<div>
						<u class="uleft"></u>
						<u class="uright"></u>
						<p>
							<u class="uleft"></u>
							<u class="uright"></u>
							<span><%=LNG_COMPANY_06_19%></span>
							<s></s>
						</p>
						<s></s>
						<em></em>
						<i></i>
					</div>
					<dl class="dl01">
						<dd>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_20%></span></p>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_21%></span></p>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_22%></span></p>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_23%></span></p>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_24%></span></p>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_25%></span></p>
						</dd>
					</dl>
				</li>
				<li class="li03 l03">
					<div>
						<u class="uleft"></u>
						<u class="uright"></u>
						<p>
							<u class="uleft"></u>
							<u class="uright"></u>
							<span><%=LNG_COMPANY_06_26%></span>
							<s></s>
						</p>
						<s></s>
						<em></em>
						<i></i>
					</div>
					<dl class="dl01">
						<dt>
							<u class="uleft"></u>
							<u class="uright"></u>
							<p><span><%=LNG_COMPANY_06_27%></span></p>
							<s></s>
						</dt>
						<dd>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_28%></span></p>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_29%></span></p>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_30%></span></p>
						</dd>
					</dl>
				</li>
				<li class="li03 l04">
					<div>
						<u class="uleft"></u>
						<u class="uright"></u>
						<p>
							<u class="uleft"></u>
							<u class="uright"></u>
							<span><%=LNG_COMPANY_06_31%></span>
							<s></s>
						</p>
						<s></s>
						<em></em>
						<i></i>
					</div>
					<dl class="dl01">
						<dd>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_32%></span></p>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_33%></span></p>
						</dd>
					</dl>
				</li>
				<li class="li03 l05">
					<div>
						<u class="uleft"></u>
						<u class="uright"></u>
						<p>
							<u class="uleft"></u>
							<u class="uright"></u>
							<span><%=LNG_COMPANY_06_34%></span>
							<s></s>
						</p>
						<s></s>
						<em></em>
						<i></i>
					</div>
					<dl class="dl01">
						<dd>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_35%></span></p>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_36%></span></p>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_37%></span></p>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_38%></span></p>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_39%></span></p>
						</dd>
					</dl>
				</li>
				<li class="li03 l06">
					<div>
						<u class="uleft"></u>
						<u class="uright"></u>
						<p>
							<u class="uleft"></u>
							<u class="uright"></u>
							<span><%=LNG_COMPANY_06_40%></span>
							<s></s>
						</p>
						<s></s>
						<em></em>
						<i></i>
					</div>
					<dl class="dl01">
						<dt>
							<u class="uleft"></u>
							<u class="uright"></u>
							<p><span><%=LNG_COMPANY_06_41%></span></p>
							<s></s>
						</dt>
						<dd>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_42%></span></p>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_43%></span></p>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_44%></span></p>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_45%></span></p>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_46%></span></p>
						</dd>
					</dl>
					<dl class="dl02">
						<dt>
							<u class="uleft"></u>
							<u class="uright"></u>
							<p><span><%=LNG_COMPANY_06_47%></span></p>
							<s></s>
						</dt>
						<dd>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_48%></span></p>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_49%></span></p>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_50%></span></p>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_51%></span>	</p>
						</dd>
					</dl>
					<dl class="dl03">
						<dt>
							<u class="uleft"></u>
							<u class="uright"></u>
							<p><span><%=LNG_COMPANY_06_52%></span></p>
							<s></s>
						</dt>
						<dd>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_53%></span></p>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_54%></span></p>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_55%></span></p>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_56%></span></p>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_57%></span></p>
							<p><span class="s01">· </span><span class="s02"><%=LNG_COMPANY_06_58%></span></p>
						</dd>
					</dl>
				</li>
			</ul>
		</div>
		<%If UCase(lang)="JP" Then%>
		<script type="text/javascript">
			$(document).ready(function(){
				$('.c07 .l01').each(function(){
					var Widest = -1;
					$('.c07 .l01 dd>p').each(function(){
						if($(this).width() > Widest)
							Widest = $(this).width();
						});
					$('.c07 .l01 dd>p').width(Widest+10);
				});
				$('.c07 .l02').each(function(){
					var Widest = -1;
					$('.c07 .l02 dd>p').each(function(){
						if($(this).width() > Widest)
							Widest = $(this).width();
						});
					$('.c07 .l02 dd>p').width(Widest+10).css('margin-left','10px');
				});
				$('.c07 .l03').each(function(){
					var Widest = -1;
					$('.c07 .l03 dd>p').each(function(){
						if($(this).width() > Widest)
							Widest = $(this).width();
						});
					$('.c07 .l03 dd>p').width(Widest+10);
				});
				$('.c07 .l04').each(function(){
					var Widest = -1;
					$('.c07 .l04 dd>p').each(function(){
						if($(this).width() > Widest)
							Widest = $(this).width();
						});
					$('.c07 .l04 dd>p').width(Widest);
				});
				$('.c07 .l05').each(function(){
					var Widest = -1;
					$('.c07 .l05 dd>p').each(function(){
						if($(this).width() > Widest)
							Widest = $(this).width();
						});
					$('.c07 .l05 dd>p').width(Widest+10);
				});
				$('.c07 .l06').each(function(){
					var Widest = -1;
					$('.c07 .l06 dd>p').each(function(){
						if($(this).width() > Widest)
							Widest = $(this).width();
						});
					$('.c07 .l06 dd>p').width(Widest+10);
				});
			});
		</script>
		<%Else%>
		<script type="text/javascript">
			$(document).ready(function(){
				$('.c07 .l01').each(function(){
					var Widest = -1;
					$('.c07 .l01 dd>p').each(function(){
						if($(this).width() > Widest)
							Widest = $(this).width();
						});
					$('.c07 .l01 dd>p').width(Widest);
				});
				$('.c07 .l02').each(function(){
					var Widest = -1;
					$('.c07 .l02 dd>p').each(function(){
						if($(this).width() > Widest)
							Widest = $(this).width();
						});
					$('.c07 .l02 dd>p').width(Widest+10).css('margin-left','10px');
				});
				$('.c07 .l03').each(function(){
					var Widest = -1;
					$('.c07 .l03 dd>p').each(function(){
						if($(this).width() > Widest)
							Widest = $(this).width();
						});
					$('.c07 .l03 dd>p').width(Widest+10);
				});
				$('.c07 .l04').each(function(){
					var Widest = -1;
					$('.c07 .l04 dd>p').each(function(){
						if($(this).width() > Widest)
							Widest = $(this).width();
						});
					$('.c07 .l04 dd>p').width(Widest);
				});
				$('.c07 .l05').each(function(){
					var Widest = -1;
					$('.c07 .l05 dd>p').each(function(){
						if($(this).width() > Widest)
							Widest = $(this).width();
						});
					$('.c07 .l05 dd>p').width(Widest+10);
				});
				$('.c07 .l06').each(function(){
					var Widest = -1;
					$('.c07 .l06 dd>p').each(function(){
						if($(this).width() > Widest)
							Widest = $(this).width();
						});
					$('.c07 .l06 dd>p').width(Widest);
				});
			});
		</script>
		<%End If%>
	<%Case Else Call ALERTS("존재하지 않는 페이지입니다.","BACK","")%>
<%End Select%>
</div>
<!--#include virtual = "/_include/copyright.asp"-->




