USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetDOPData]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Vinnie Fung
-- Create date: 2018/06/29
-- Description: Get data for DOP Monitor
-- =============================================
CREATE PROCEDURE [dbo].[GetDOPData] 
AS
BEGIN

SELECT
	Alias AS 'VehicleClass',
	CASE WHEN COUNT(CASE WHEN status='AR' and Location_ID IN (16, 13) then status END) = 0
	     THEN NULL
	ELSE
	     COUNT(CASE WHEN status='AR' and Location_ID IN (16, 13) then status END) END AS 'AR_YVRs',

          CASE WHEN COUNT(CASE WHEN status='AR' and Location_ID IN (1) then status END) = 0
	     THEN NULL
	ELSE
	     COUNT(CASE WHEN status='AR' and Location_ID IN (1) then status END) END AS 'AR_SC',

	--COUNT(CASE WHEN status='ANR' then status END) as 'ANR',
	CASE WHEN COUNT(CASE WHEN status='D' then status END) = 0
	     THEN NULL
	ELSE
	     COUNT(CASE WHEN status='D' then status END) END AS 'Due',
	--COUNT(CASE WHEN status='D' then status END) as 'D', --  and RP_Flt_11_Daily_Operation_Plan_L2_Main.Hours_Overdue <= 2 
	--COUNT(CASE WHEN status='D' and RP_Flt_11_Daily_Operation_Plan_L2_Main.Hours_Overdue > 2  then status END) as 'D2',
	CASE WHEN COUNT(CASE WHEN status='R' then status END) = 0
	     THEN NULL
	ELSE
	     COUNT(CASE WHEN status='R' then status END) END AS 'Res',

	--COUNT(CASE WHEN status='R' then status END) as 'R',
	(COUNT(CASE WHEN status='AR' then status END) +
	 COUNT(CASE WHEN status='D' then status END) -
	 --COUNT(CASE WHEN status='D' and RP_Flt_11_Daily_Operation_Plan_L2_Main.Hours_Overdue > 2  then status END) -
	 COUNT(CASE WHEN status='R' then status END)) AS 'Difference'
FROM   	RP_Flt_11_Daily_Operation_Plan_L2_Main 
        INNER
	JOIN
        Vehicle_Class
        	ON RP_Flt_11_Daily_Operation_Plan_L2_Main.Vehicle_Class_Code = Vehicle_Class.Vehicle_Class_Code

GROUP BY Alias, DisplayOrder

ORDER BY DisplayOrder

END

-- SELECT* FROM RP_Flt_11_Daily_Operation_Plan_L2_Main
-- SELECT * FROM Location
GO
