<%


	'▣ 이번 달 mms 테이블 있는지 확인 S
		ThisMMS_Month = "em_log_"&year(now)&Right("00"&month(now),2)
		SQL_M1 = "select count(*) From sysobjects where name = ? "
		arrParams_M1 = array(_
			Db.makeParam("@ThisMMS_Month",adVarChar,adParamInput,50,ThisMMS_Month) _
		)
		MMS_TBexists = CDbl(Db.execRsData(SQL_M1,DB_TEXT,arrParams_M1,DB5))


		SQL = ""
		SQL = SQL & "	DECLARE @PAGESTART INT "
		SQL = SQL & "	DECLARE @PAGEEND INT "
		SQL = SQL & "	SET @PAGESTART = (@PAGESIZE * (@PAGE-1)) + 1 "
		SQL = SQL & "	SET @PAGEEND = @PAGE * @PAGESIZE "






	'▣ 이번 달 mms 테이블 있는지 확인 E



%>