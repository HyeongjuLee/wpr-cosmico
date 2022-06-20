<HTML>
<HEAD>
<TITLE>문자열 자르기</TITLE>
<STYLE type = "text/css">
td { word-break: break-all; }
.shorttitle { width: 365px; height: 18;  display: block; overflow: hidden; }
</STYLE>
</HEAD>
<SCRIPT>
String.prototype.trim = function()
{
 return this.replace(/(^\s*)|(\s*$)/g, "");
}
function textCutter()
{
 trSize = 5; // 글 갯수

 for( i = 0; i < trSize; i++ ) // 글 갯수만큼 반복
 {
  row = eval( "tr" + i );

  if( row.scrollHeight >= 24 ) // 한줄이 넘어가는 글에 대해서
  {
   text = row.innerText; // text 변수에 삽입한다.

   while( true ) // 무한 loop
   {
    text = text.substring( 0, text.length - 1 ); // 텍스트를 끝에서 한글자씩 잘라가면서
    row.innerText = text; // 값을 수정한다.

    if( row.scrollHeight < 24 ) break; // 한줄이 되면 loop 를 끝낸다.
   }

   row.innerText = text.trim() + "..."; // 끝에 공백이 있다면 자른 다음  ... 을 붙여서 값을 수정한다.
   alert(row.style.width);
   row.style.width = document.getElementsByClassName("shorttitle").style.width + 10; // width 를 310에서 320으로 넓힌다. ( ... 이 보일 수 있도록 )
   }
 }
}
</SCRIPT>
<BODY onLoad = "textCutter()">
<TABLE  border = "1" cellspacing = "0" cellpadding = "2">
<TR>
 <TD>NO</TD>
 <TD width = "365">SUBJECT</TD>
 <TD>NAME</TD>
 <TD>DATE</TD>
 <TD>HIT</TD>
</TR>
<TR>
 <TD>5</TD>
 <TD>
  <A href = "http://jsguide.net">
  <SPAN id = "tr0" class = "shorttitle">제목 길게 쓰면 누가 알아나 주나? 제발 좀 제목은 간단하게 쓰라구! 누가 본다고.. 쯧쯧</SPAN>
  </A>
 </TD>
 <TD>짜증남</TD>
 <TD>2001.10.17</TD>
 <TD>2</TD>
</TR>
 <TR>
 <TD>4</TD>
 <TD>
  <SPAN id = "tr1" class = "shorttitle">짧게 좀 씁시다. 잘 안보이자나여.</SPAN>
 </TD>
 <TD>딴지남</TD>
 <TD>2001.10.17</TD>
 <TD>8</TD>
</TR>
<TR>
 <TD>3</TD>
 <TD>
  <SPAN id = "tr2" class = "shorttitle">나도 길게 쓸래. 짧게 쓰면 뭔가 허전해서 말이쥐, 왜냐구? 내맘이지 모야!</SPAN>
 </TD>
 <TD>졸라맨</TD>
 <TD>2001.10.17</TD>
 <TD>19</TD>
</TR>
<TR>
 <TD>2</TD>
 <TD>
  <SPAN id = "tr3" class = "shorttitle">이렇게 짧게 써도 되는데</SPAN>
 </TD>
 <TD>낙천맨</TD>
 <TD>2001.10.17</TD>
 <TD>7</TD>
</TR>
<TR>
 <TD>1</TD>
 <TD>
  <SPAN id = "tr4" class = "shorttitle">꼭 이렇게 제목을 길게 써야지만 직성이 풀리는 유별난 사람들이 많은 모양이예요.</SPAN>
 </TD>
 <TD>순진녀</TD>
 <TD>2001.10.17</TD>
 <TD>26</TD>
</TR>
</TABLE>
</BODY>
</HTML>


