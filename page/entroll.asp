<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_include/document.asp"-->

<%
	view = gRequestTF("view",True)
	mNum = 2
	sview = gRequestTF("sview",True)
%>

</head>
<body>

<style type="text/css">
	#entroll {width: 650px; height: 100%; text-align: center;}
	#entroll img {display: inline-block; margin: 0 auto;}
</style>

<div id="entroll">
	<%Select Case view%>
	<%Case "1"%>
		<%Select Case sView%>
		<%Case "1"%>
			<img src="/images/entroll/company06_t1_01.jpg" alt="" />
		<%Case "2"%>
			<img src="/images/entroll/company06_t1_02.jpg" alt="" />
		<%Case "3"%>
			<img src="/images/entroll/company06_t1_03.jpg" alt="" />
		<%Case "4"%>
			<img src="/images/entroll/company06_t1_04.jpg" alt="" />
		<%Case "5"%>
			<img src="/images/entroll/company06_t1_05.jpg" alt="" />
		<%Case "6"%>
			<img src="/images/entroll/company06_t1_06.jpg" alt="" />
		<%Case "7"%>
			<img src="/images/entroll/company06_t1_07.jpg" alt="" />
		<%Case "8"%>
			<img src="/images/entroll/company06_t1_08.jpg" alt="" />
		<%Case "9"%>
			<img src="/images/entroll/company06_t1_09.jpg" alt="" />
		<%Case "10"%>
			<img src="/images/entroll/company06_t1_10.jpg" alt="" />
		<%Case "11"%>
			<img src="/images/entroll/company06_t1_11.jpg" alt="" />
		<%Case "12"%>
			<img src="/images/entroll/company06_t1_12.jpg" alt="" />
		<%Case "13"%>
			<img src="/images/entroll/company06_t1_13.jpg" alt="" />
		<%End Select%>
	<%Case "2"%>
		<%Select Case sView%>
		<%Case "1"%>
			<img src="/images/entroll/company06_t2_01.jpg" alt="" />
		<%Case "2"%>
			<img src="/images/entroll/company06_t2_02.jpg" alt="" />
		<%Case "3"%>
			<img src="/images/entroll/company06_t2_03.jpg" alt="" />
		<%Case "4"%>
			<img src="/images/entroll/company06_t2_04.jpg" alt="" />
		<%Case "5"%>
			<img src="/images/entroll/company06_t2_05.jpg" alt="" />
		<%Case "6"%>
			<img src="/images/entroll/company06_t2_06.jpg" alt="" />
		<%Case "7"%>
			<img src="/images/entroll/company06_t2_07.jpg" alt="" />
		<%Case "8"%>
			<img src="/images/entroll/company06_t2_08.jpg" alt="" />
		<%Case "9"%>
			<img src="/images/entroll/company06_t2_09.jpg" alt="" />
		<%End Select%>
	<%Case "3"%>
		<%Select Case sView%>
		<%Case "1"%>
			<img src="/images/entroll/company06_t3_01.jpg" alt="" />
		<%Case "2"%>
			<img src="/images/entroll/company06_t3_02.jpg" alt="" />
			<img src="/images/entroll/company06_t3_02_1.jpg" alt="" />
		<%Case "3"%>
			<img src="/images/entroll/company06_t3_03.jpg" alt="" />
			<img src="/images/entroll/company06_t3_03_1.jpg" alt="" />
			<img src="/images/entroll/company06_t3_03_2.jpg" alt="" />
			<img src="/images/entroll/company06_t3_03_3.jpg" alt="" />
			<img src="/images/entroll/company06_t3_03_4.jpg" alt="" />
			<img src="/images/entroll/company06_t3_03_5.jpg" alt="" />
		<%Case "4"%>
			<img src="/images/entroll/company06_t3_04.jpg" alt="" />
			<img src="/images/entroll/company06_t3_04_1.jpg" alt="" />
		<%Case "5"%>
			<img src="/images/entroll/company06_t3_05.jpg" alt="" />
			<img src="/images/entroll/company06_t3_05_1.jpg" alt="" />
			<img src="/images/entroll/company06_t3_05_2.jpg" alt="" />
		<%Case "6"%>
			<img src="/images/entroll/company06_t3_06.jpg" alt="" />
		<%End Select%>
	<%Case "4"%>
		<%Select Case sView%>
		<%Case "1"%>
			<img src="/images/entroll/company06_t4_01.jpg" alt="" />
			<img src="/images/entroll/company06_t4_01_1.jpg" alt="" />
			<img src="/images/entroll/company06_t4_01_2.jpg" alt="" />
			<img src="/images/entroll/company06_t4_01_3.jpg" alt="" />
			<img src="/images/entroll/company06_t4_01_4.jpg" alt="" />
			<img src="/images/entroll/company06_t4_01_5.jpg" alt="" />
		<%Case "2"%>
			<img src="/images/entroll/company06_t4_02.jpg" alt="" />
		<%Case "3"%>
			<img src="/images/entroll/company06_t4_03.jpg" alt="" />
			<img src="/images/entroll/company06_t4_03_1.jpg" alt="" />
		<%End Select%>
	<%Case Else Call ALERTS("존재하지 않는 페이지입니다.","BACK","")%>
	<%End Select%>
	</div>
</body>
</html>




