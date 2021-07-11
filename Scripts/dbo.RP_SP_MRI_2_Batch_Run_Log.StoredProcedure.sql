USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_MRI_2_Batch_Run_Log]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





/*
PROCEDURE NAME: RP_SP_MRI_2_Batch_Run_Log
PURPOSE: Select all the information needed for Batch Run Log Report

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: Batch Run Log Report
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	1999/09/24	add more filtering to improve performance
Joseph Tseung	1999/11/04	implement to select all process codes excluding Maestro
Joseph Tseung	1999/12/03	use description of Error Level in lookup table
Don K		25 Jan 2000	Change order of parameters to match URL
*/

CREATE PROCEDURE [dbo].[RP_SP_MRI_2_Batch_Run_Log]
	@FromDate varchar(24) = '1999/07/01 00:00',
	@ToDate varchar(24) = '1999/10/30 09:59',
	@paramProcessCode varchar(20) = '*',
	@paramExcludeMaestro char(1) = 'N',
	@paramErrorTypeID varchar(20) = '*',
	@paramErrorLevelID varchar(20) = '*'
AS
DECLARE @dFrom datetime,
	@dTo datetime

SELECT 	@dFrom = CONVERT(datetime, @FromDate)
SELECT 	@dTo = CONVERT(datetime, @ToDate)

-- fix upgrading problem (SQL7->SQL2000)
DECLARE  @tmpErrorTypeID varchar(20)

if @paramErrorTypeID = '*'
	BEGIN
		SELECT @tmpErrorTypeID='0'
        END
else
	BEGIN
		SELECT @tmpErrorTypeID = @paramErrorTypeID
	END 
-- end of fixing the problem


IF @paramExcludeMaestro = 'N'
-- either a single process code or all process codes incl Maestro is selected
BEGIN

SELECT 	Batch_Error_Log.Batch_Start_Date,
	Batch_Error_Log.Process_Date,
	Batch_Error_Log.Process_Code,
	Data_1_Str = ISNULL(Batch_Error_Log.Data_1,''),
    	Data_2_Str = ISNULL(Batch_Error_Log.Data_2,''),
    	Data_3_Str = ISNULL(Batch_Error_Log.Data_3,''),
    	Message_1_Str = ISNULL(Batch_Error_Message.Message1,''),
    	Message_2_Str = ISNULL(Batch_Error_Message.Message2,''),
    	Message_3_Str = ISNULL(Batch_Error_Message.Message3,''),
    	Message_4_Str = ISNULL(Batch_Error_Message.Message4,''),
    	Batch_Error_Message.System_Only,
    	Error_Type_Str =
    		CASE Batch_Error_Message.System_Only
    			WHEN 1 THEN 'System'
    			ELSE 'User'
    		END,
    	Batch_Error_Message.Error_Level,
	Error_Level_Str = Lookup_Table.Value

FROM 	Batch_Error_Log with(nolock)
	INNER
	JOIN
    	Batch_Error_Message
		ON Batch_Error_Log.Error_Number = Batch_Error_Message.Error_Number
	INNER
	JOIN
	Lookup_Table
		ON Batch_Error_Message.Error_Level = Lookup_Table.Code
		AND Lookup_Table.Category = 'Error Level'
     	LEFT
	OUTER JOIN
    	Maestro
		ON Batch_Error_Log.Maestro_ID = Maestro.Maestro_ID

WHERE 	Batch_Error_Log.Batch_Start_Date BETWEEN @dFrom AND @dTo
	AND
	(@paramProcessCode = "*" OR Batch_Error_Log.Process_Code = @paramProcessCode)	
	AND
 	(@paramErrorTypeID = "*" or CONVERT(INT, @tmpErrorTypeID) = Batch_Error_Message.System_Only)
	AND
	(@paramErrorLevelID = "*" OR Batch_Error_Message.Error_Level = @paramErrorLevelID)	

ORDER BY
	Batch_Error_Log.Process_Date,
	Maestro.Transaction_Date
	
END
ELSE
IF @paramExcludeMaestro = 'Y'
-- all process codes excl Maestro is selected
BEGIN

SELECT 	Batch_Error_Log.Batch_Start_Date,
	Batch_Error_Log.Process_Date,
	Batch_Error_Log.Process_Code,
	Data_1_Str = ISNULL(Batch_Error_Log.Data_1,''),
    	Data_2_Str = ISNULL(Batch_Error_Log.Data_2,''),
    	Data_3_Str = ISNULL(Batch_Error_Log.Data_3,''),
    	Message_1_Str = ISNULL(Batch_Error_Message.Message1,''),
    	Message_2_Str = ISNULL(Batch_Error_Message.Message2,''),
    	Message_3_Str = ISNULL(Batch_Error_Message.Message3,''),
    	Message_4_Str = ISNULL(Batch_Error_Message.Message4,''),
    	Batch_Error_Message.System_Only,
    	Error_Type_Str =
    		CASE Batch_Error_Message.System_Only
    			WHEN 1 THEN 'System'
    			ELSE 'User'
    		END,
    	Batch_Error_Message.Error_Level,
	Error_Level_Str = Lookup_Table.Value

FROM 	Batch_Error_Log with(nolock)
	INNER
	JOIN
    	Batch_Error_Message
		ON Batch_Error_Log.Error_Number = Batch_Error_Message.Error_Number
	INNER
	JOIN
	Lookup_Table
		ON Batch_Error_Message.Error_Level = Lookup_Table.Code
		AND Lookup_Table.Category = 'Error Level'
     	LEFT
	OUTER JOIN
    	Maestro
		ON Batch_Error_Log.Maestro_ID = Maestro.Maestro_ID

WHERE 	Batch_Error_Log.Batch_Start_Date BETWEEN @dFrom AND @dTo
	AND
	Batch_Error_Log.Process_Code <> 'Maestro'
	AND
 	(@paramErrorTypeID = "*" or CONVERT(INT, @tmpErrorTypeID) = Batch_Error_Message.System_Only)
	AND
	(@paramErrorLevelID = "*" OR Batch_Error_Message.Error_Level = @paramErrorLevelID)	

ORDER BY
	Batch_Error_Log.Process_Date,
	Maestro.Transaction_Date
	
END
RETURN @@ROWCOUNT

GO
