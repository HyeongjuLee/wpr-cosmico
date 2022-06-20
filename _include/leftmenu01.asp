<%
	mainMenuOutColor = "0x999999"
	mainMenuOverColor = "0x2070ad"

	subMenuOutColor = "0x999999"
	subMenuOverColor = "0x2070ad"

%>
<?xml version="1.0" encoding="euc-kr"?>
<!--
menuSpeed : 메뉴이동스피드
delayTime  : 메뉴아웃시 되돌아 가는 시간(단위:프레임)
-->
<menu menuSpeed="0.25" delayTime="50">
	<main name="인사말" link="/page/page.asp?mode=intro&amp;view=1" target="_self" outColor="<%=mainMenuOutColor%>" overColor="<%=mainMenuOverColor%>"  letterSpacing="-0.5"></main>
	<main name="진료시스템"  link="/page/intro.asp?view=2" target="_self" outColor="<%=mainMenuOutColor%>" overColor="<%=mainMenuOverColor%>"  letterSpacing="-0.5"></main>
	<main name="의료진소개"  link="/page/intro.asp?view=3" target="_self" outColor="<%=mainMenuOutColor%>" overColor="<%=mainMenuOverColor%>"  letterSpacing="-0.5"></main>
	<main name="장비소개"  link="/page/intro.asp?view=4" target="_self" outColor="<%=mainMenuOutColor%>" overColor="<%=mainMenuOverColor%>"  letterSpacing="-0.5"></main>
	<main name="병원 둘러보기"  link="/page/intro.asp?view=5" target="_self"  outColor="<%=mainMenuOutColor%>" overColor="<%=mainMenuOverColor%>"  letterSpacing="0"></main>
	<main name="진료안내"  link="/page/intro.asp?view=6" target="_self"  outColor="<%=mainMenuOutColor%>" overColor="<%=mainMenuOverColor%>"  letterSpacing="0"></main>
	<main name="찾아오시는 길"  link="/page/intro.asp?view=7" target="_self"  outColor="<%=mainMenuOutColor%>" overColor="<%=mainMenuOverColor%>"  letterSpacing="0"></main>
</menu>
