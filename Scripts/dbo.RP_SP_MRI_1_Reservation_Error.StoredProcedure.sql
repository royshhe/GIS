USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_MRI_1_Reservation_Error]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/*
PROCEDURE NAME: RP_SP_MRI_1_Reservation_Error
PURPOSE: Select all the information needed for Maestro Reservation Error Report

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: Maestro Reservation Error Report
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	Sep 24 1999	Add more filtering to improve performance
*/
/* add Rate_Name and BCD on Feb 18, 2005 , simon gong*/

CREATE PROCEDURE [dbo].[RP_SP_MRI_1_Reservation_Error]
(	
	@FromDate varchar(24) = '1999/01/12 09:36',
	@ToDate varchar(24) = '1999/01/12 09:37',
	@paramErrorTypeID varchar(20) = '*',
	@paramErrorLevelID varchar(20) = '*'
)
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


SELECT 	Batch_Error_Log.Batch_Start_Date,
	Batch_Error_Log.Process_Date,
    	Maestro.Transaction_Date, Maestro.Sequence_Number,
    	Maestro.Foreign_Confirm_Number,
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
    	Error_Level_Str =
    		CASE Batch_Error_Message.Error_Level
    		WHEN 'I' THEN 'Info'
    		WHEN 'W' THEN 'Warning'
    		WHEN 'E' THEN 'Error'
    		END,

	Rate_name=Case when maestro.maestro_data is null then null 
                            else

                              	case when patindex('%/Rat%', maestro_data)<>0 then
		      	substring(maestro_data, patindex('%/Rat%', maestro_data)+4, 
			(charindex('\',maestro_data, patindex('%/Rat%', maestro_data))-patindex('%/Rat%', maestro_data)-4)
			) 
		   	else null
			end  
	             End,
	BCD= case when maestro.maestro_data is null then null
		  else
			 case when patindex('%/BCD%', maestro_data)<>0 then
				substring(maestro_data, patindex('%/BCD%', maestro_data)+4,
				(charindex('\',maestro_data, patindex('%/BCD%', maestro_data))-patindex('%/BCD%', maestro_data)-4)
				) 
			else  NULL
		             end 
   		END

FROM 	Batch_Error_Log with(nolock)
	INNER JOIN
    	Batch_Error_Message
		ON Batch_Error_Log.Error_Number = Batch_Error_Message.Error_Number
     	LEFT OUTER JOIN
    	Maestro
		ON Batch_Error_Log.Maestro_ID = Maestro.Maestro_ID

WHERE 	(Batch_Error_Log.Process_Code = 'Maestro')
  	AND	
	Batch_Error_Log.Batch_Start_Date BETWEEN @dFrom AND @dTo
	AND
 	(@paramErrorTypeID = "*" or CONVERT(INT, @tmpErrorTypeID) = Batch_Error_Message.System_Only)
	AND
	(@paramErrorLevelID = "*" OR Batch_Error_Message.Error_Level = @paramErrorLevelID)

ORDER BY
	Batch_Error_Log.Process_Date,
	Maestro.Transaction_Date
	
	
RETURN @@ROWCOUNT
GO
