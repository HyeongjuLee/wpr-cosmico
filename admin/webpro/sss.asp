<HTML>
<HEAD>
<TITLE>���ڿ� �ڸ���</TITLE>
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
 trSize = 5; // �� ����

 for( i = 0; i < trSize; i++ ) // �� ������ŭ �ݺ�
 {
  row = eval( "tr" + i );

  if( row.scrollHeight >= 24 ) // ������ �Ѿ�� �ۿ� ���ؼ�
  {
   text = row.innerText; // text ������ �����Ѵ�.

   while( true ) // ���� loop
   {
    text = text.substring( 0, text.length - 1 ); // �ؽ�Ʈ�� ������ �ѱ��ھ� �߶󰡸鼭
    row.innerText = text; // ���� �����Ѵ�.

    if( row.scrollHeight < 24 ) break; // ������ �Ǹ� loop �� ������.
   }

   row.innerText = text.trim() + "..."; // ���� ������ �ִٸ� �ڸ� ����  ... �� �ٿ��� ���� �����Ѵ�.
   alert(row.style.width);
   row.style.width = document.getElementsByClassName("shorttitle").style.width + 10; // width �� 310���� 320���� ������. ( ... �� ���� �� �ֵ��� )
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
  <SPAN id = "tr0" class = "shorttitle">���� ��� ���� ���� �˾Ƴ� �ֳ�? ���� �� ������ �����ϰ� ����! ���� ���ٰ�.. ����</SPAN>
  </A>
 </TD>
 <TD>¥����</TD>
 <TD>2001.10.17</TD>
 <TD>2</TD>
</TR>
 <TR>
 <TD>4</TD>
 <TD>
  <SPAN id = "tr1" class = "shorttitle">ª�� �� ���ô�. �� �Ⱥ����ڳ���.</SPAN>
 </TD>
 <TD>������</TD>
 <TD>2001.10.17</TD>
 <TD>8</TD>
</TR>
<TR>
 <TD>3</TD>
 <TD>
  <SPAN id = "tr2" class = "shorttitle">���� ��� ����. ª�� ���� ���� �����ؼ� ������, �ֳı�? �������� ���!</SPAN>
 </TD>
 <TD>�����</TD>
 <TD>2001.10.17</TD>
 <TD>19</TD>
</TR>
<TR>
 <TD>2</TD>
 <TD>
  <SPAN id = "tr3" class = "shorttitle">�̷��� ª�� �ᵵ �Ǵµ�</SPAN>
 </TD>
 <TD>��õ��</TD>
 <TD>2001.10.17</TD>
 <TD>7</TD>
</TR>
<TR>
 <TD>1</TD>
 <TD>
  <SPAN id = "tr4" class = "shorttitle">�� �̷��� ������ ��� ������� ������ Ǯ���� ������ ������� ���� ����̿���.</SPAN>
 </TD>
 <TD>������</TD>
 <TD>2001.10.17</TD>
 <TD>26</TD>
</TR>
</TABLE>
</BODY>
</HTML>


