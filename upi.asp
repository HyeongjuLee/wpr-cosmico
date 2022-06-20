<!--#include virtual = "/_lib/strFunc.asp"-->
<%

If webproIP<>"T" Then Response.Redirect "/index.asp"


%>

<form name="aaa" method="post" enctype="multipart/form-data" action="upih.asp">

<input type="file" name="Filedata" />
<input type="submit" value="제출" />
</form>