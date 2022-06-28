<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "BUSINESS"
	ISLEFT = "T"
	ISSUBTOP = "T"

	view = gRequestTF("view",True)
	'sview = gRequestTF("sview",True)
	mNum = 4
	sNum = view
	sVar = sNum

	If PG_EXAM_MODE = "T" Then Call ALERTS(LNG_PAGE_ALERT01,"back","")		'PG

	If view = 1 Then
		'CALL ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1)
	End If
	If view = 2 Then
		CALL ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1)
	End If
%>
<!--#include virtual = "/_include/document.asp"-->
<META NAME="GOOGLEBOT" CONTENT="NOINDEX, NOFOLLOW">
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<div id="pages">
<%Select Case view%>
	<%Case "1111"%>
		<div class="business business01">
			<article>
				<section class="image">
					<div class="img">
						<img src="/images/content/business01_img1.jpg" alt="">
					</div>
				</section>
				<section class="text">
					<h2><%=LNG_BUSINESS_01_1%></h2>
					<i></i>
					<ul>
						<li><%=LNG_BUSINESS_01_2%></li>
						<li><%=LNG_BUSINESS_01_3%></li>
						<li><%=LNG_BUSINESS_01_4%></li>
						<li><%=LNG_BUSINESS_01_5%></li>
					</ul>
				</section>
			</article>
			<article>
				<section class="dash">
					<h2><%=LNG_BUSINESS_01_6%></h2>
					<ul>
						<li class="company">
							<div class="icon">
								<i class="icon-building-filled"></i>
							</div>
							<div class="con">
								<p>Meta C21 Global</p>
								<span><%=LNG_BUSINESS_01_7%></span>
							</div>
						</li>
						<li class="site">
							<div class="icon">
								<i class="icon-mobile"></i>
							</div>
							<div class="con">
								<p>www.metac21g.com</p>
								<span><%=LNG_BUSINESS_01_8%></span>
							</div>
						</li>
						<li class="location">
							<div class="icon">
								<i class="icon-location"></i>
							</div>
							<div class="con">
								<img src="/images/content/location.png" alt="">
							</div>
						</li>
						<li class="kossa">
							<div class="icon">
								<i class="icon-link"></i>
							</div>
							<div class="con">
								<img src="/images/content/kossa_big.png" alt="">
							</div>
						</li>
					</ul>
				</section>
			</article>
		</div>
	<%Case "1"%>
		<div class="ready">
			<div><img src="/images/content/maintenance-line.svg" alt=""></div>
			<p><%=LNG_READY_02_01%></p>
		</div>
	<%Case "2"%>
		<!-- <link rel="stylesheet" href="/css/marketing_plan.css?v0"> -->
		<!--include virtual = "/page/marketing_plan.asp"-->
		<div class="ready">
			<div><img src="/images/content/maintenance-line.svg" alt=""></div>
			<p><%=LNG_READY_02_01%></p>
		</div>
	<%Case "3"%>
		<div class="ready">
			<div><img src="/images/content/maintenance-line.svg" alt=""></div>
			<p><%=LNG_READY_02_01%></p>
		</div>
	<%Case "3333"%>
		<div class="business business03">
			<p><%=LNG_BUSINESS_03_01%></p>
			<article>
				<h1><%=LNG_BUSINESS_03_02%></h1>
				<section>
					<h2><%=LNG_BUSINESS_03_03%></h2>
					<ul>
						<li><%=LNG_BUSINESS_03_04%>
							<ol>
								<li><%=LNG_BUSINESS_03_05%></li>
								<li><%=LNG_BUSINESS_03_06%></li>
								<li><%=LNG_BUSINESS_03_07%></li>
								<li><%=LNG_BUSINESS_03_08%></li>
								<li><%=LNG_BUSINESS_03_09%></li>
							</ol>
						</li>
						<li><%=LNG_BUSINESS_03_10%></li>
					</ul>
				</section>
				<section>
					<h2><%=LNG_BUSINESS_03_11%></h2>
					<ul>
						<li><%=LNG_BUSINESS_03_12%>
							<ol>
								<li><%=LNG_BUSINESS_03_13%></li>
								<li><%=LNG_BUSINESS_03_14%></li>
							</ol>
						</li>
					</ul>
				</section>
			</article>
			<article>
				<h1><%=LNG_BUSINESS_03_15%></h1>
			</article>
			<article>
				<h1><%=LNG_BUSINESS_03_16%></h1>
				<section>
					<ul>
						<li><%=LNG_BUSINESS_03_17%></li>
						<li><%=LNG_BUSINESS_03_18%></li>
						<li><%=LNG_BUSINESS_03_19%></li>
						<li><%=LNG_BUSINESS_03_20%></li>
						<li><%=LNG_BUSINESS_03_21%></li>
						<li><%=LNG_BUSINESS_03_22%></li>
						<li><%=LNG_BUSINESS_03_23%></li>
						<li><%=LNG_BUSINESS_03_24%></li>
					</ul>
				</section>
			</article>
			<article>
				<h1><%=LNG_BUSINESS_03_25%></h1>
				<section>
					<h2><%=LNG_BUSINESS_03_26%></h2>
					<ul>
						<li><%=LNG_BUSINESS_03_27%></li>
						<li><%=LNG_BUSINESS_03_28%></li>
						<li><%=LNG_BUSINESS_03_29%></li>
					</ul>
				</section>
				<section>
					<h2><%=LNG_BUSINESS_03_30%></h2>
					<ul>
						<li><%=LNG_BUSINESS_03_31%></li>
						<li><%=LNG_BUSINESS_03_32%></li>
					</ul>
				</section>
			</article>
			<article>
				<h1><%=LNG_BUSINESS_03_33%></h1>
				<section>
					<ul>
						<li><%=LNG_BUSINESS_03_34%></li>
						<li><%=LNG_BUSINESS_03_35%></li>
					</ul>
				</section>
			</article>
			<article>
				<h1><%=LNG_BUSINESS_03_36%></h1>
				<section>
					<ul>
						<li><%=LNG_BUSINESS_03_37%></li>
						<li><%=LNG_BUSINESS_03_38%>
							<ol>
								<li><%=LNG_BUSINESS_03_39%></li>
								<li><%=LNG_BUSINESS_03_40%></li>
							</ol>
						</li>
						<li><%=LNG_BUSINESS_03_41%></li>
						<li><%=LNG_BUSINESS_03_42%></li>
						<li><%=LNG_BUSINESS_03_43%></li>
						<li><%=LNG_BUSINESS_03_44%></li>
						<li><%=LNG_BUSINESS_03_45%></li>
						<li><%=LNG_BUSINESS_03_46%></li>
						<li><%=LNG_BUSINESS_03_47%></li>
					</ul>
				</section>
			</article>
		</div>
	<%Case "4"%>
		<!--include virtual = "/page/business04.asp"-->
		<div class="ready">
			<div><img src="/images/content/maintenance-line.svg" alt=""></div>
			<p><%=LNG_READY_02_01%></p>
		</div>
	<%Case "5"%>
		<div class="ready">
			<div><img src="/images/content/maintenance-line.svg" alt=""></div>
			<p><%=LNG_READY_02_01%></p>
		</div>
	<%Case "6"%>
		<link rel="stylesheet" href="/css/marketing_plan.css?">
		<!--#include virtual = "/page/marketing_plan.asp"-->
	<%Case Else Call ALERTS(LNG_PAGE_ALERT01,"BACK","")%>
<%End Select%>
</div>
<!--#include virtual = "/_include/copyright.asp"-->




