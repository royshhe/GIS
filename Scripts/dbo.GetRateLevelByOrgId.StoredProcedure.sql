USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRateLevelByOrgId]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





/*
PURPOSE: To retrieve the corporate rates (rate id, name, level) that are 
	 currently available for a given organization during PickUpDate
MOD HISTORY:
Name	Date        	Comments
Don K	Apr 4 2000	Do date comparisons to the day
*/
CREATE PROCEDURE [dbo].[GetRateLevelByOrgId]
	@OrgId	 	varchar(10),
	@VehClassCode	char(1),
	@PickupDate 	varchar(20)
AS
DECLARE @iOrgId Int,
	@dPUDate Datetime

	SELECT 	@iOrgId = Convert(Int, NULLIF(@OrgId,"")),
		-- truncate time portion from pick up date/time
		@dPUDate = CAST(FLOOR(CAST(CAST(NULLIF(@PickupDate, '') AS datetime) AS float)) AS datetime)

/*	SELECT	Distinct
			ORGR.Rate_ID,
			ORGR.Rate_Level,
			VR.Rate_Name

	FROM		Organization O,
			Organization_Rate ORGR,
			Vehicle_Rate VR
*/

        SELECT	Distinct
			ORGR.Rate_ID,
			ORGR.Rate_Level,
			VR.Rate_Name
	FROM          dbo.Organization O 
		INNER JOIN dbo.Organization_Rate ORGR 
			ON O.Organization_ID = ORGR.Organization_ID 
		INNER JOIN   dbo.Vehicle_Rate VR 
			ON ORGR.Rate_ID = VR.Rate_ID 
		INNER JOIN  dbo.Rate_Vehicle_Class RVC ON VR.Rate_ID = RVC.Rate_ID 

	WHERE 	
	 		O.Organization_Id = @iOrgId
	AND		RVC.Vehicle_Class_Code=@VehClassCode
	AND 		ORGR.Termination_Date = 'Dec 31 2078 23:59'
	AND 		RVC.Termination_Date>Getdate()
	AND		@dPUDate BETWEEN ORGR.Valid_From AND ISNULL(ORGR.Valid_To, @dPUDate)

	RETURN @@ROWCOUNT





GO
