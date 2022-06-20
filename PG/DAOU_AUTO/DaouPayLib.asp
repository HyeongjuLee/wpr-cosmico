<%
		Session.CodePage = 65001
		Response.CharSet = "UTF-8"
		Response.AddHeader "Pragma","no-cache"
		Response.AddHeader "Expires","0"

    '*********************************************************
    '***  Function LogWrite(str)
    '***  로그파일을 남김. 해당 디렉토리는 IUSER
    '***  쓰기&생성 가능해야함.
    '*********************************************************
    Function LogWrite(strs)
      Set fslog = Server.CreateObject("Scripting.FileSystemObject")
      filename = Server.MapPath("/PG/DAOU_AUTO/logss/asplog_") & Replace(Date(),"-","") & ".log"

      If fslog.FileExists(filename) = false then
        fslog.CreateTextFile filename,true
      end if

      logtime = "[" & Date &" "& Time & "] "

      Set objFilelog = fslog.OpenTextFile(filename,8)
      objFilelog.writeLine(logtime & strs)
      objFilelog.close
    End Function

    '*********************************************************
%>
