USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Flt_11_Daily_Operation_Plan]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO










/*
PROCEDURE NAME: RP_SP_Flt_11_Daily_Operation_Plan
PURPOSE: Select all the information needed for Daily Operation Plan Report

AUTHOR:	Nenad Ukropina
DATE CREATED: 1999/01/01
USED BY: Daily Operation Plan Report
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	1999/10/07	Change stored procedure to base on 
				view RP_Flt_11_Daily_Operation_Plan_L2_Main
Joseph Tseung	1999/11/10	Output vehicle class name together with code
Joseph Tseung	1999/11/23	Change sign >= to > when comparing Hours_Overdue field
				with @iOverdueHours parameter 
*/
CREATE Procedure [dbo].[RP_SP_Flt_11_Daily_Operation_Plan]-- 'Car', '2'
(
		@Vehicle_Type		CHAR(5)  = '*',	
		@Overdue_Hours      	CHAR(2)  = '0'
)

AS

DECLARE 	@iOverdueHours smallint
SELECT 		@iOverdueHours = CAST(@Overdue_Hours AS SMALLINT)

SELECT
	RP_Flt_11_Daily_Operation_Plan_L2_Main.ID,
        RP_Flt_11_Daily_Operation_Plan_L2_Main.Location_ID,
        Location.Location AS Location_Name,
        Vehicle_Class.Vehicle_Type_ID,
       	--RP_Flt_11_Daily_Operation_Plan_L2_Main.Vehicle_Class_Code + ' - ' + 
Vehicle_Class.Alias AS Vehicle_Class_Code_Name,
        Status = CASE
        	WHEN RP_Flt_11_Daily_Operation_Plan_L2_Main.Hours_Overdue > @iOverdueHours 
			THEN 'OD'
        		ELSE RP_Flt_11_Daily_Operation_Plan_L2_Main.Status
        	END,
       	RP_Flt_11_Daily_Operation_Plan_L2_Main.Hours_Overdue, Vehicle_Class.DisplayOrder
FROM   	RP_Flt_11_Daily_Operation_Plan_L2_Main with(nolock)
	INNER
	JOIN
        Location
        	ON RP_Flt_11_Daily_Operation_Plan_L2_Main.Location_ID = Location.Location_ID
        INNER
	JOIN
        Vehicle_Class
        	ON RP_Flt_11_Daily_Operation_Plan_L2_Main.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code

WHERE ( @Vehicle_Type='*' or  Vehicle_Class.Vehicle_Type_ID = @Vehicle_Type)
order by Vehicle_Class.DisplayOrder
	
return @@ROWCOUNT




























GO
