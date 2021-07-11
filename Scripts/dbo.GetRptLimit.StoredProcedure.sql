USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRptLimit]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/* 
PURPOSE: Retrieve the current time limit for running reports
MOD HISTORY:
Name	Date		Comment
Don K	Jan 19 2000	Created
*/
CREATE PROCEDURE [dbo].[GetRptLimit] 
AS
DECLARE	@dtNow datetime,
	@dtDayStart datetime,
	@dtDayEnd datetime,
	@sPeriod char(25)

SELECT	@dtNow = GETDATE()

/* Determine when today's day time period starts and ends by getting the times
 * from the look up table and appending them to today's date.
 */
SELECT	@dtDayStart = CONVERT
		(
		datetime,
		CONVERT(varchar(11), @dtNow, 120) + 
			(
			SELECT	value
			FROM	lookup_table
			WHERE	category = 'Report Day'
			AND	code = 'Start'
			),
		120
		),
	@dtDayEnd = CONVERT
		(
		datetime,
		CONVERT(varchar(11), @dtNow, 120) + 
			(
			SELECT	value
			FROM	lookup_table
			WHERE	category = 'Report Day'
			AND	code = 'End'
			),
		120
		)

IF @dtNow BETWEEN @dtDayStart AND @dtDayEnd
	SELECT @sPeriod = 'Day'
ELSE
	SELECT @sPeriod = 'Night'

-- Now return the appropriate time limit for this time of day.
SELECT	value
FROM	lookup_table
WHERE	category = 'Report Limit'
AND	code = @sPeriod




GO
