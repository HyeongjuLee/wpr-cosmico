Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[DKSP_NBOARD_MOVIE_LIST]
(
	 @strBoardName			VARCHAR(50)
	,@intCate				INTEGER
	,@strBoardType			VARCHAR(10)
	,@SEARCHTERM			VARCHAR(30)
	,@SEARCHSTR				VARCHAR(30)
	,@PAGESIZE				INTEGER
	,@PAGE					INTEGER
	,@strNation				VARCHAR(20)
	,@GroupData				VARCHAR(40)
	,@All_Count				INTEGER OUTPUT
)
AS
SET NOCOUNT ON;
BEGIN
	DECLARE @PAGESTART INT
	DECLARE @PAGEEND INT
	SET @PAGESTART = (@PAGESIZE * (@PAGE-1)) + 1
	SET @PAGEEND = @PAGE * @PAGESIZE
	IF (@SEARCHTERM = '' OR @SEARCHSTR = '')
		BEGIN
			SET @SEARCHTERM = ''
			SET @SEARCHSTR = ''
		END



	SELECT @ALL_COUNT = COUNT(*) FROM [DK_NBOARD_CONTENT]
		--WHERE [strBoardName] = @strBoardName AND [strDomain] = @strDomain
	WHERE [strBoardName] = @strBoardName AND [isNotice] = 'FF' AND [strNation] = @strNation AND [intDepth] = 0
		AND ((@SEARCHTERM = 'strSubject' AND [strSubject] LIKE '%'+@SEARCHSTR+'%') OR (@SEARCHTERM <> 'strSubject' AND 1=1))
		AND ((@SEARCHTERM = 'strContent' AND [strContent] LIKE '%'+@SEARCHSTR+'%') OR (@SEARCHTERM <> 'strContent' AND 1=1))
--		AND [intCate] = CASE WHEN @intCate = '' OR @intCate IS NULL THEN [intCate] ELSE @intCate END
		AND ((@GroupData <> '' AND [GroupData] = @GroupData) OR (@GroupData = '' AND 1=1))
	;

	WITH LIST AS
	(
	SELECT ROW_NUMBER() OVER (ORDER BY [regDate] DESC) AS ROWNUM,
		 [intIDX],[strUserID],[strName],[regDate],[readCnt]
		,[strSubject],[strPic]
		,(SELECT COUNT([intIDX]) FROM [DK_NBOARD_COMMENT] WHERE [intBoardIDX] = [DK_NBOARD_CONTENT].[intIDX]) AS TOTALSCORE
		,(SELECT COUNT([intIDX]) FROM [DK_NBOARD_VOTE] WHERE [bIDX] = [DK_NBOARD_CONTENT].[intIDX]) AS TOTALVOTE
		,[movieType],[movieURL]
	 FROM [DK_NBOARD_CONTENT]
	WHERE [strBoardName] = @strBoardName AND [isNotice] = 'FF' AND [strNation] = @strNation AND [intDepth] = 0
		AND ((@SEARCHTERM = 'strSubject' AND [strSubject] LIKE '%'+@SEARCHSTR+'%') OR (@SEARCHTERM <> 'strSubject' AND 1=1))
		AND ((@SEARCHTERM = 'strContent' AND [strContent] LIKE '%'+@SEARCHSTR+'%') OR (@SEARCHTERM <> 'strContent' AND 1=1))
		--AND [intCate] = CASE WHEN @intCate = '' OR @intCate IS NULL THEN [intCate] ELSE @intCate END
		AND ((@GroupData <> '' AND [GroupData] = @GroupData) OR (@GroupData = '' AND 1=1))

	)


	SELECT * FROM [LIST] WHERE ROWNUM BETWEEN @PAGESTART AND @PAGEEND



END
SET NOCOUNT OFF;

/*
	DKSP_NBOARD_MOVIE_LIST 'movie',0,'moviepop','','',10,1,'kr','',0
*/