<!-- 타이틀 S -->
<%
	spanClass1 = "mn1"
	spanClass2 = "mn2"
	spanClass3 = "mn3"
	spanClass4 = "mn4"
	spanClass5 = "mn5"


	Select Case mnType
		Case "1" : spanClass1 = "mn1o"
		Case "2" : spanClass2 = "mn2o"
		Case "3" : spanClass3 = "mn3o"
		Case "4" : spanClass4 = "mn4o"
		Case "5" : spanClass5 = "mn5o"
	End Select

%>
	<div id="navi">
		<h4 class="mn<%=mnType%>">타이틀</h4>
		<div class="map_navi">
			<ul>
				<!-- <li class="first"><span class="<%=spanClass1%>" >회원종류 선택</span></li> -->
				<li class="first"><span class="<%=spanClass2%>">약관동의</span></li>
				<li><span class="<%=spanClass3%>">가입인증</span></li>
				<li><span class="<%=spanClass4%>">회원정보 입력</span></li>
				<li><span class="<%=spanClass5%>">가입완료</span></li>
			</ul>
		</div>
	</div>
<!-- 타이틀 E -->