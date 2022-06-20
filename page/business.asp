<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "BUSINESS"
	ISLEFT = "T"
	ISSUBTOP = "T"

	view = gRequestTF("view",True)
	'sview = gRequestTF("sview",True)
	mNum = 2
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
	<%Case "1"%>
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
	<%Case "1111"%>
		<div><img src="/images/content/business01_2.jpg" alt=""></div>
	<%Case "2"%>
		<link rel="stylesheet" href="/css/marketing_plan.css?v0">
		<!--#include virtual = "/page/marketing_plan.asp"-->
	<%Case "3"%>
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
		<!--#include virtual = "/page/business04.asp"-->
	<%Case "444"%>
		<div class="business business04">
			<div><span><%=LNG_BUSINESS_04_01%></span></div>
			<article><!--1조-->
				<h1><%=LNG_BUSINESS_04_02%></h1>
				<section>
					<p><%=LNG_BUSINESS_04_03%></p>
				</section>
			</article>
			<article><!--2조-->
				<h1><%=LNG_BUSINESS_04_04%></h1>
				<section>
					<p><%=LNG_BUSINESS_04_05%></p>
					<ul>
						<li><%=LNG_BUSINESS_04_06%></li>
						<li><%=LNG_BUSINESS_04_07%></li>
						<li><%=LNG_BUSINESS_04_08%>
							<table>
								<thead>
									<tr>
										<th><%=LNG_BUSINESS_04_09%></th>
										<th><%=LNG_BUSINESS_04_10%></th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<th><%=LNG_BUSINESS_04_11%></th>
										<td><%=LNG_BUSINESS_04_12%></td>
									</tr>
									<tr>
										<th><%=LNG_BUSINESS_04_13%></th>
										<td rowspan="3"><%=LNG_BUSINESS_04_14%></td>
									</tr>
									<tr><th><%=LNG_BUSINESS_04_15%></th></tr>
									<tr><th><%=LNG_BUSINESS_04_16%></th></tr>
									<!-- <tr><th><%=LNG_BUSINESS_04_17%></th></tr> -->
								</tbody>
							</table>
						</li>
						<li><%=LNG_BUSINESS_04_18%></li>
						<li><%=LNG_BUSINESS_04_19%></li>
						<li><%=LNG_BUSINESS_04_20%></li>
						<li><%=LNG_BUSINESS_04_21%></li>
						<li><%=LNG_BUSINESS_04_22%></li>
						<li><%=LNG_BUSINESS_04_23%></li>
					</ul>
				</section>
			</article>
			<article><!--3조-->
				<h1><%=LNG_BUSINESS_04_24%></h1>
				<section>
					<p><%=LNG_BUSINESS_04_25%></p>
				</section>
			</article>
			<article><!--4조-->
				<h1><%=LNG_BUSINESS_04_26%></h1>
				<section>
					<p><%=LNG_BUSINESS_04_27%></p>
				</section>
			</article>
			<article><!--5조-->
				<h1><%=LNG_BUSINESS_04_28%></h1>
				<section>
					<p><%=LNG_BUSINESS_04_29%></p>
					<ul>
						<li><%=LNG_BUSINESS_04_30%>
							<ol>
								<li><%=LNG_BUSINESS_04_31%></li>
							</ol>
						</li>
					</ul>
				</section>
			</article>
			<article><!--6조-->
				<h1><%=LNG_BUSINESS_04_32%></h1>
				<section>
					<p><%=LNG_BUSINESS_04_33%></p>
					<ul>
						<li><%=LNG_BUSINESS_04_34%></li>
						<li><%=LNG_BUSINESS_04_35%>
							<span><%=LNG_BUSINESS_04_36%></span>
						</li>
						<li><%=LNG_BUSINESS_04_37%></li>
					</ul>
				</section>
			</article>
			<article><!--7조-->
				<h1><%=LNG_BUSINESS_04_38%></h1>
				<section>
					<p><%=LNG_BUSINESS_04_39%></p>
				</section>
			</article>
			<article><!--8조-->
				<h1><%=LNG_BUSINESS_04_40%></h1>
				<section>
					<p><%=LNG_BUSINESS_04_41%></p>
					<ul>
						<li><%=LNG_BUSINESS_04_42%></li>
						<li><%=LNG_BUSINESS_04_43%></li>
						<li><%=LNG_BUSINESS_04_44%></li>
						<li><%=LNG_BUSINESS_04_45%></li>
						<li><%=LNG_BUSINESS_04_46%></li>
						<li><%=LNG_BUSINESS_04_47%></li>
						<li><%=LNG_BUSINESS_04_48%></li>
					</ul>
				</section>
			</article>
			<article><!--9조-->
				<h1><%=LNG_BUSINESS_04_49%></h1>
				<section>
					<p><%=LNG_BUSINESS_04_50%></p>
				</section>
			</article>
			<article><!--10조-->
				<h1><%=LNG_BUSINESS_04_51%></h1>
				<section>
					<p><%=LNG_BUSINESS_04_52%></p>
				</section>
			</article>
			<article><!--11조-->
				<h1><%=LNG_BUSINESS_04_53%></h1>
				<section>
					<p><%=LNG_BUSINESS_04_54%></p>
					<ul>
						<li><%=LNG_BUSINESS_04_55%></li>
						<li><%=LNG_BUSINESS_04_56%></li>
						<li><%=LNG_BUSINESS_04_57%></li>
						<li><%=LNG_BUSINESS_04_58%></li>
					</ul>
				</section>
			</article>
			<article><!--12조-->
				<h1><%=LNG_BUSINESS_04_59%></h1>
				<section>
					<ul>
						<li><%=LNG_BUSINESS_04_60%></li>
						<li><%=LNG_BUSINESS_04_61%></li>
						<li><%=LNG_BUSINESS_04_62%></li>
						<li><%=LNG_BUSINESS_04_63%></li>
						<li><%=LNG_BUSINESS_04_64%></li>
					</ul>
				</section>
			</article>
			<article><!--13조-->
				<h1><%=LNG_BUSINESS_04_65%></h1>
				<section>
					<p><%=LNG_BUSINESS_04_66%></p>
					<ul>
						<li><%=LNG_BUSINESS_04_67%></li>
						<li><%=LNG_BUSINESS_04_68%></li>
					</ul>
				</section>
			</article>
			<article><!--14조-->
				<h1><%=LNG_BUSINESS_04_69%></h1>
				<section>
					<p><%=LNG_BUSINESS_04_70%></p>
				</section>
			</article>
			<article><!--15조-->
				<h1><%=LNG_BUSINESS_04_71%></h1>
				<section>
					<p><%=LNG_BUSINESS_04_72%></p>
					<ul>
						<li><%=LNG_BUSINESS_04_73%></li>
					</ul>
				</section>
			</article>
			<article><!--16조-->
				<h1><%=LNG_BUSINESS_04_74%></h1>
				<section>
					<p><%=LNG_BUSINESS_04_75%></p>
				</section>
			</article>
			<article><!--17조-->
				<h1><%=LNG_BUSINESS_04_76%></h1>
				<section>
					<ul>
						<li><%=LNG_BUSINESS_04_77%></li>
						<li><%=LNG_BUSINESS_04_78%></li>
						<li><%=LNG_BUSINESS_04_79%></li>
					</ul>
				</section>
			</article>
			<article><!--18조-->
				<h1><%=LNG_BUSINESS_04_80%></h1>
				<section>
					<p><%=LNG_BUSINESS_04_81%></p>
				</section>
			</article>
			<article><!--19조-->
				<h1><%=LNG_BUSINESS_04_82%></h1>
				<section>
					<ul>
						<li><%=LNG_BUSINESS_04_83%></li>
						<li><%=LNG_BUSINESS_04_84%></li>
						<li><%=LNG_BUSINESS_04_85%></li>
						<li><%=LNG_BUSINESS_04_86%></li>
					</ul>
				</section>
			</article>
			<article><!--20조-->
				<h1><%=LNG_BUSINESS_04_87%></h1>
				<section>
					<p><%=LNG_BUSINESS_04_88%></p>
				</section>
			</article>
			<article><!--21조-->
				<h1><%=LNG_BUSINESS_04_89%></h1>
				<section>
					<p><%=LNG_BUSINESS_04_90%></p>
				</section>
			</article>
			<article><!--22조-->
				<h1><%=LNG_BUSINESS_04_91%></h1>
				<section>
					<ul>
						<li><%=LNG_BUSINESS_04_92%></li>
						<li><%=LNG_BUSINESS_04_93%></li>
						<li><%=LNG_BUSINESS_04_94%>
							<ol>
								<li><%=LNG_BUSINESS_04_95%></li>
								<li><%=LNG_BUSINESS_04_96%></li>
								<li><%=LNG_BUSINESS_04_97%></li>
							</ol>
						</li>
					</ul>
				</section>
			</article>
			<article><!--23조-->
				<h1><%=LNG_BUSINESS_04_98%></h1>
				<section>
					<ul>
						<li><%=LNG_BUSINESS_04_99%></li>
						<li><%=LNG_BUSINESS_04_100%></li>
						<li><%=LNG_BUSINESS_04_101%></li>
					</ul>
				</section>
			</article>
			<article><!--24조-->
				<h1><%=LNG_BUSINESS_04_102%></h1>
				<section>
					<ul>
						<li><%=LNG_BUSINESS_04_103%></li>
						<li><%=LNG_BUSINESS_04_104%></li>
						<li><%=LNG_BUSINESS_04_105%></li>
						<li><%=LNG_BUSINESS_04_106%></li>
					</ul>
				</section>
			</article>
			<article><!--25조-->
				<h1><%=LNG_BUSINESS_04_107%></h1>
				<section>
					<p><%=LNG_BUSINESS_04_108%></p>
				</section>
			</article>
			<article><!--26조-->
				<h1><%=LNG_BUSINESS_04_109%></h1>
				<section>
					<p><%=LNG_BUSINESS_04_110%></p>
					<ul>
						<li><%=LNG_BUSINESS_04_111%></li>
						<li><%=LNG_BUSINESS_04_112%></li>
					</ul>
				</section>
			</article>
			<article><!--27조-->
				<h1><%=LNG_BUSINESS_04_113%></h1>
				<section>
					<ul>
						<li><%=LNG_BUSINESS_04_114%>
							<ol>
								<li><%=LNG_BUSINESS_04_115%></li>
								<li><%=LNG_BUSINESS_04_116%></li>
								<li><%=LNG_BUSINESS_04_117%></li>
								<li><%=LNG_BUSINESS_04_118%></li>
							</ol>
						</li>
						<li><%=LNG_BUSINESS_04_119%>
							<ol>
								<li><%=LNG_BUSINESS_04_120%></li>
								<li><%=LNG_BUSINESS_04_121%></li>
								<li><%=LNG_BUSINESS_04_122%></li>
								<li><%=LNG_BUSINESS_04_123%></li>
							</ol>
						</li>
						<li><%=LNG_BUSINESS_04_124%></li>
						<li><%=LNG_BUSINESS_04_125%>
							<ol>
								<li><%=LNG_BUSINESS_04_126%></li>
								<li><%=LNG_BUSINESS_04_127%></li>
								<li><%=LNG_BUSINESS_04_128%></li>
								<li><%=LNG_BUSINESS_04_129%></li>
								<li><%=LNG_BUSINESS_04_130%></li>
								<li><%=LNG_BUSINESS_04_131%></li>
							</ol>
						</li>
						<li><%=LNG_BUSINESS_04_132%></li>
					</ul>
				</section>
			</article>
			<article><!--28조-->
				<h1><%=LNG_BUSINESS_04_133%></h1>
				<section>
					<ul>
						<li><%=LNG_BUSINESS_04_134%></li>
						<li><%=LNG_BUSINESS_04_135%></li>
					</ul>
				</section>
			</article>
			<article><!--29조-->
				<h1><%=LNG_BUSINESS_04_136%></h1>
				<section>
					<p><%=LNG_BUSINESS_04_137%></p>
					<ul>
						<li><%=LNG_BUSINESS_04_138%>
							<p><%=LNG_BUSINESS_04_139%></p>
						</li>
						<li><%=LNG_BUSINESS_04_140%>
							<p><%=LNG_BUSINESS_04_141%></p>
						</li>
						<li><%=LNG_BUSINESS_04_142%></li>
						<li><%=LNG_BUSINESS_04_143%></li>
					</ul>
				</section>
			</article>
			<article><!--30조-->
				<h1><%=LNG_BUSINESS_04_144%></h1>
				<section>
					<ul>
						<li><%=LNG_BUSINESS_04_145%></li>
						<li><%=LNG_BUSINESS_04_146%></li>
						<li><%=LNG_BUSINESS_04_147%></li>
					</ul>
				</section>
			</article>
			<article><!--31조-->
				<h1><%=LNG_BUSINESS_04_148%></h1>
				<section>
					<ul>
						<li><%=LNG_BUSINESS_04_149%></li>
						<li><%=LNG_BUSINESS_04_150%></li>
						<li><%=LNG_BUSINESS_04_151%></li>
						<li><%=LNG_BUSINESS_04_152%></li>
						<li><%=LNG_BUSINESS_04_153%></li>
						<li><%=LNG_BUSINESS_04_154%></li>
						<li><%=LNG_BUSINESS_04_155%></li>
						<li><%=LNG_BUSINESS_04_156%></li>
						<li><%=LNG_BUSINESS_04_157%></li>
						<li><%=LNG_BUSINESS_04_158%></li>
						<li><%=LNG_BUSINESS_04_159%></li>
						<li><%=LNG_BUSINESS_04_160%></li>
						<li><%=LNG_BUSINESS_04_161%></li>
						<li><%=LNG_BUSINESS_04_162%></li>
						<li><%=LNG_BUSINESS_04_163%></li>
						<li><%=LNG_BUSINESS_04_164%>
							<ol>
								<li><%=LNG_BUSINESS_04_165%></li>
								<li><%=LNG_BUSINESS_04_166%></li>
							</ol>
						</li>
						<li><%=LNG_BUSINESS_04_167%></li>
						<li><%=LNG_BUSINESS_04_168%></li>
						<li><%=LNG_BUSINESS_04_169%></li>
						<li><%=LNG_BUSINESS_04_170%></li>
						<li><%=LNG_BUSINESS_04_171%></li>
						<li><%=LNG_BUSINESS_04_172%></li>
						<li><%=LNG_BUSINESS_04_173%></li>
						<li><%=LNG_BUSINESS_04_174%></li>
						<li><%=LNG_BUSINESS_04_175%></li>
						<li><%=LNG_BUSINESS_04_176%>
							<ol>
								<li style="text-indent: 0;"><%=LNG_BUSINESS_04_177%></li>
							</ol>
						</li>
						<li><%=LNG_BUSINESS_04_178%></li>
						<li><%=LNG_BUSINESS_04_179%></li>
					</ul>
					<p><%=LNG_BUSINESS_04_180%></p>
				</section>
			</article>
			<article><!--32조-->
				<h1><%=LNG_BUSINESS_04_181%></h1>
				<section>
					<ul>
						<li><%=LNG_BUSINESS_04_182%></li>
						<li><%=LNG_BUSINESS_04_183%></li>
						<li><%=LNG_BUSINESS_04_184%></li>
						<li><%=LNG_BUSINESS_04_185%></li>
						<li><%=LNG_BUSINESS_04_186%></li>
						<li><%=LNG_BUSINESS_04_187%></li>
						<li><%=LNG_BUSINESS_04_188%></li>
					</ul>
				</section>
			</article>
			<article><!--33조-->
				<h1><%=LNG_BUSINESS_04_189%></h1>
				<section>
					<ul>
						<li><%=LNG_BUSINESS_04_190%>
							<ol>
								<li><%=LNG_BUSINESS_04_191%>
									<ol>
										<li><%=LNG_BUSINESS_04_192%></li>
										<li><%=LNG_BUSINESS_04_193%></li>
										<li><%=LNG_BUSINESS_04_194%></li>
										<li><%=LNG_BUSINESS_04_195%></li>
										<li><%=LNG_BUSINESS_04_196%></li>
									</ol>
								</li>
								<li><%=LNG_BUSINESS_04_197%>
									<ol>
										<li><%=LNG_BUSINESS_04_198%></li>
										<li><%=LNG_BUSINESS_04_199%></li>
									</ol>
								</li>
							</ol>
						</li>
						<li><%=LNG_BUSINESS_04_200%>
							<ol>
								<li><%=LNG_BUSINESS_04_201%>
									<ol>
										<li><%=LNG_BUSINESS_04_202%></li>
										<li><%=LNG_BUSINESS_04_203%></li>
									</ol>
								</li>
								<li><%=LNG_BUSINESS_04_204%>
									<ol>
										<li><%=LNG_BUSINESS_04_205%></li>
										<li><%=LNG_BUSINESS_04_206%></li>
										<li><%=LNG_BUSINESS_04_207%></li>
									</ol>
								</li>
								<li><%=LNG_BUSINESS_04_208%>
									<ol>
										<li><%=LNG_BUSINESS_04_209%></li>
										<li><%=LNG_BUSINESS_04_210%></li>
										<li><%=LNG_BUSINESS_04_211%></li>
									</ol>
								</li>
							</ol>
						</li>
						<li><%=LNG_BUSINESS_04_212%>
							<ol>
								<li><%=LNG_BUSINESS_04_213%></li>
								<li><%=LNG_BUSINESS_04_214%></li>
								<li><%=LNG_BUSINESS_04_215%></li>
								<li><%=LNG_BUSINESS_04_216%></li>
							</ol>
						</li>
					</ul>
				</section>
			</article>
			<article><!--34조-->
				<h1><%=LNG_BUSINESS_04_217%></h1>
				<section>
					<ul>
						<li><%=LNG_BUSINESS_04_218%></li>
						<li><%=LNG_BUSINESS_04_219%></li>
						<li><%=LNG_BUSINESS_04_220%></li>
					</ul>
					<div class="txt">
						<span><%=LNG_BUSINESS_04_221%></span>
						<span><%=LNG_BUSINESS_04_222%></span>
						<span><%=LNG_BUSINESS_04_223%></span>
					</div>
				</section>
			</article>
			<div><span><%=LNG_BUSINESS_04_224%></span></div>
			<article>
				<h1><%=LNG_BUSINESS_04_225%></h1>
				<section>
					<p><%=LNG_BUSINESS_04_226%></p>
				</section>
			</article>
		</div>
	<%Case "5"%>
		<div class="ready1">
			<div><img src="/images/content/maintenance-line(1).svg" alt=""></div>
			<p><%=LNG_READY_02_01%></p>
		</div>
	<%Case Else Call ALERTS(LNG_PAGE_ALERT01,"BACK","")%>
<%End Select%>
</div>
<!--#include virtual = "/_include/copyright.asp"-->




