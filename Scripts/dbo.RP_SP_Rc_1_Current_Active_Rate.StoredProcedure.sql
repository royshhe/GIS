USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Rc_1_Current_Active_Rate]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO











/*
PROCEDURE NAME: RP_SP_Rc_1_Current_Active_Rate 
PURPOSE: Select all information needed for Current Active Rate Report

AUTHOR:	Joseph Tseung
DATE CREATED: 1999/11/20
USED BY:  RP_SP_Rc_1_Current_Active_Rate Report
MOD HISTORY:
Name 		Date		Comments
Joseph Tseung	2000/01/13	Fix Rate Restriction flag
*/

CREATE PROCEDURE [dbo].[RP_SP_Rc_1_Current_Active_Rate] 
(
	@paramCompanyID	   varchar(20) = '*',
	@paramLocationID varchar(20) = '*',
	@paramStartDate varchar(20) = '1999/01/01',
	@paramEndDate varchar(20) = '1999/12/31',
	@paramAllValidDates varchar(5) = 'True',
	@paramValidFromTo varchar(10) = 'All',
	@paramPurposeID1 varchar(5) = '*',
	@paramPurposeID2 varchar(5) = '-1',
	@paramPurposeID3 varchar(5) = '-1',
	@paramPurposeID4 varchar(5) = '-1',
	@paramPurposeID5 varchar(5) = '-1',
	@paramPurposeID6 varchar(5) = '-1',
	@paramPurposeID7 varchar(5) = '-1',
	@paramPurposeID8 varchar(5) = '-1',
	@paramPurposeID9 varchar(5) = '-1',
	@paramPurposeID10 varchar(5) = '-1',
	@paramRateName varchar(50) = 'wedding package'
)
AS
-- convert strings to datetime
DECLARE 	@startDate datetime,
		@endDate datetime,
		@pID1 	int,
		@pID2 	int,
		@pID3 	int,
		@pID4 	int,
		@pID5 	int,
		@pID6 	int,
		@pID7 	int,
		@pID8 	int,
		@pID9 	int,
		@pID10 	int

IF @paramPurposeID1 <> '*' 
	SELECT @pID1 = CONVERT(INT, @paramPurposeID1)
ELSE
	SELECT @pID1 = 0

-- fix upgrading problem (SQL7->SQL2000)
DECLARE 	@tmpLocID varchar(20), 
		@tmpOwningCompanyID varchar(20)

if @paramLocationID = '*'
	BEGIN
		SELECT @tmpLocID='0'
        	END
else
	BEGIN
		SELECT @tmpLocID = @paramLocationID
	END 

if @paramCompanyID = '*'
	BEGIN
		SELECT @tmpOwningCompanyID = '0'
	END
else 
	BEGIN
		SELECT @tmpOwningCompanyID = @paramCompanyID
	END
-- end of fixing the problem


SELECT	@startDate	= CONVERT(datetime, '00:00:00 ' + @paramStartDate),
	@endDate	= CONVERT(datetime, '23:59:59 ' + @paramEndDate),
	@pID2		= CONVERT(INT, @paramPurposeID2),
	@pID3		= CONVERT(INT, @paramPurposeID3),
	@pID4		= CONVERT(INT, @paramPurposeID4),
	@pID5		= CONVERT(INT, @paramPurposeID5),
	@pID6		= CONVERT(INT, @paramPurposeID6),
	@pID7		= CONVERT(INT, @paramPurposeID7),
	@pID8		= CONVERT(INT, @paramPurposeID8),
	@pID9		= CONVERT(INT, @paramPurposeID9),
	@pID10		= CONVERT(INT, @paramPurposeID10)

IF (@paramValidFromTo = 'Valid From' AND @paramAllValidDates = 'False')
BEGIN
SELECT 	Vehicle_Rate.Rate_ID, 
	Vehicle_Rate.Rate_Name, 
    	Vehicle_Rate.Rate_Purpose_ID, 
	Rate_Purpose.Rate_Purpose, 
	Rate_Level.Rate_Level AS End_Level,
	Vehicle_Rate.Last_Changed_By, 
    	Vehicle_Rate.Last_Changed_On,
	Violation = CASE WHEN Vehicle_Rate.Violated_Rate_ID IS NOT NULL
			 THEN 'Y'
			 ELSE ''
		    END,
	Restriction = CASE WHEN Rate_Restriction.Restriction_ID IS NOT NULL
		      	 THEN 'Y'
			 ELSE ''
		    END,
    	Vehicle_Rate.Other_Remarks,
	vLVD.Owning_Company_ID,
	vLVD.Owning_Company_Name,
	vLVD.Location_ID,
	vLVD.Location_Name,
	vLVD.Valid_From,
	vLVD.Valid_To
		
FROM 	Vehicle_Rate  with(nolock)
	INNER 
	JOIN
	Rate_Purpose 
		ON Rate_Purpose.Rate_Purpose_ID = Vehicle_Rate.Rate_Purpose_ID
		AND Vehicle_Rate.Termination_Date > CONVERT(DATETIME,'2078-12-31')
	INNER
	JOIN
	Rate_Level
		ON Vehicle_Rate.Rate_ID = Rate_Level.Rate_ID
		AND Rate_Level.Rate_Level = (SELECT MAX(Rate_Level) 
						FROM Rate_Level rl with(nolock)
						WHERE Rate_Level.Rate_ID = rl.Rate_ID)
	INNER
	JOIN
	RP_Rc_1_Current_Active_Rate_L1_Base_Loc_And_Valid_Dates vLVD
		ON vLVD.Rate_ID = Vehicle_Rate.Rate_ID
	LEFT 
	JOIN
	Rate_Restriction
		ON Rate_Restriction.Rate_ID = Vehicle_Rate.Rate_ID
		AND Rate_Restriction.Restriction_ID = (SELECT MAX(Restriction_ID) 
								FROM Rate_Restriction rR with(nolock)
									WHERE rR.Rate_ID = Rate_Restriction.Rate_ID
									AND rR.Termination_Date > CONVERT(DATETIME,'2078-12-31'))
		AND Rate_Restriction.Termination_Date > CONVERT(DATETIME,'2078-12-31')

WHERE 	Vehicle_Rate.Rate_ID IN
	(
	SELECT DISTINCT Rate_ID FROM RP_Rc_1_Current_Active_Rate_L1_Base_Param vParam with(nolock)
		WHERE
		(@paramCompanyID = "*" OR CONVERT(INT, @tmpOwningCompanyID) = vParam.Owning_Company_ID)
		AND
		(@paramLocationID = "*" OR CONVERT(INT, @tmpLocID) = vParam.Location_ID)
		AND
		(@paramPurposeID1 = "*" OR vParam.Rate_Purpose_ID IN (@pID1, @pID2, @pID3, @pID4, @pID5, @pID6, @pID7, @pID8, @pID9, @pID10))
		AND
		(@paramRateName = "*" OR vParam.Rate_Name LIKE @paramRateName)
		AND
		vParam.Valid_From BETWEEN @startDate AND @endDate
	)


END

ELSE


IF (@paramValidFromTo = 'Valid To' AND @paramAllValidDates = 'False')
BEGIN
SELECT 	Vehicle_Rate.Rate_ID, 
	Vehicle_Rate.Rate_Name, 
    	Vehicle_Rate.Rate_Purpose_ID, 
	Rate_Purpose.Rate_Purpose, 
	Rate_Level.Rate_Level AS End_Level,
	Vehicle_Rate.Last_Changed_By, 
    	Vehicle_Rate.Last_Changed_On,
	Violation = CASE WHEN Vehicle_Rate.Violated_Rate_ID IS NOT NULL
			 THEN 'Y'
			 ELSE ''
		    END,
	Restriction = CASE WHEN Rate_Restriction.Restriction_ID IS NOT NULL
		      	 THEN 'Y'
			 ELSE ''
		    END,
    	Vehicle_Rate.Other_Remarks,
	vLVD.Owning_Company_ID,
	vLVD.Owning_Company_Name,
	vLVD.Location_ID,
	vLVD.Location_Name,
	vLVD.Valid_From,
	vLVD.Valid_To
		
FROM 	Vehicle_Rate with(nolock)
	INNER 
	JOIN
	Rate_Purpose 
		ON Rate_Purpose.Rate_Purpose_ID = Vehicle_Rate.Rate_Purpose_ID
		AND Vehicle_Rate.Termination_Date > CONVERT(DATETIME,'2078-12-31')
	INNER
	JOIN
	Rate_Level
		ON Vehicle_Rate.Rate_ID = Rate_Level.Rate_ID
		AND Rate_Level.Rate_Level = (SELECT MAX(Rate_Level) 
						FROM Rate_Level rl with(nolock)
						WHERE Rate_Level.Rate_ID = rl.Rate_ID)
	INNER
	JOIN
	RP_Rc_1_Current_Active_Rate_L1_Base_Loc_And_Valid_Dates vLVD
		ON vLVD.Rate_ID = Vehicle_Rate.Rate_ID
	LEFT 
	JOIN
	Rate_Restriction
		ON Rate_Restriction.Rate_ID = Vehicle_Rate.Rate_ID
		AND Rate_Restriction.Restriction_ID = (SELECT MAX(Restriction_ID) 
								FROM Rate_Restriction rR with(nolock)
									WHERE rR.Rate_ID = Rate_Restriction.Rate_ID
									AND rR.Termination_Date > CONVERT(DATETIME,'2078-12-31'))
		AND Rate_Restriction.Termination_Date > CONVERT(DATETIME,'2078-12-31')

WHERE 	Vehicle_Rate.Rate_ID IN
	(
	SELECT DISTINCT Rate_ID FROM RP_Rc_1_Current_Active_Rate_L1_Base_Param vParam with(nolock)
		WHERE
		(@paramCompanyID = "*" OR CONVERT(INT, @tmpOwningCompanyID) = vParam.Owning_Company_ID)
		AND
		(@paramLocationID = "*" OR CONVERT(INT, @tmpLocID) = vParam.Location_ID)
		AND
		(@paramPurposeID1 = "*" OR vParam.Rate_Purpose_ID IN (@pID1, @pID2, @pID3, @pID4, @pID5, @pID6, @pID7, @pID8, @pID9, @pID10))
		AND
		(@paramRateName = "*" OR vParam.Rate_Name LIKE @paramRateName)
		AND
		vParam.Valid_To BETWEEN @startDate AND @endDate
	)

END

ELSE

IF (@paramValidFromTo = 'All' AND @paramAllValidDates = 'True')
BEGIN
SELECT 	Vehicle_Rate.Rate_ID, 
	Vehicle_Rate.Rate_Name, 
    	Vehicle_Rate.Rate_Purpose_ID, 
	Rate_Purpose.Rate_Purpose, 
	Rate_Level.Rate_Level AS End_Level,
	Vehicle_Rate.Last_Changed_By, 
    	Vehicle_Rate.Last_Changed_On,
	Violation = CASE WHEN Vehicle_Rate.Violated_Rate_ID IS NOT NULL
			 THEN 'Y'
			 ELSE ''
		    END,
	Restriction = CASE WHEN Rate_Restriction.Restriction_ID IS NOT NULL
		      	 THEN 'Y'
			 ELSE ''
		    END,
    	Vehicle_Rate.Other_Remarks,
	vLVD.Owning_Company_ID,
	vLVD.Owning_Company_Name,
	vLVD.Location_ID,
	vLVD.Location_Name,
	vLVD.Valid_From,
	vLVD.Valid_To
		
FROM 	Vehicle_Rate with(nolock)
	INNER 
	JOIN
	Rate_Purpose 
		ON Rate_Purpose.Rate_Purpose_ID = Vehicle_Rate.Rate_Purpose_ID
		AND Vehicle_Rate.Termination_Date > CONVERT(DATETIME,'2078-12-31')
	INNER
	JOIN
	Rate_Level
		ON Vehicle_Rate.Rate_ID = Rate_Level.Rate_ID
		AND Rate_Level.Rate_Level = (SELECT MAX(Rate_Level) 
						FROM Rate_Level rl with(nolock)
						WHERE Rate_Level.Rate_ID = rl.Rate_ID)
	INNER
	JOIN
	RP_Rc_1_Current_Active_Rate_L1_Base_Loc_And_Valid_Dates vLVD
		ON vLVD.Rate_ID = Vehicle_Rate.Rate_ID
	LEFT 
	JOIN
	Rate_Restriction
		ON Rate_Restriction.Rate_ID = Vehicle_Rate.Rate_ID
		AND Rate_Restriction.Restriction_ID = (SELECT MAX(Restriction_ID) 
								FROM Rate_Restriction rR with(nolock)
									WHERE rR.Rate_ID = Rate_Restriction.Rate_ID
									AND rR.Termination_Date > CONVERT(DATETIME,'2078-12-31'))
		AND Rate_Restriction.Termination_Date > CONVERT(DATETIME,'2078-12-31')

WHERE 	Vehicle_Rate.Rate_ID IN
	(
	SELECT DISTINCT Rate_ID FROM RP_Rc_1_Current_Active_Rate_L1_Base_Param vParam with(nolock)
		WHERE
		(@paramCompanyID = "*" OR CONVERT(INT, @tmpOwningCompanyID) = vParam.Owning_Company_ID)
		AND
		(@paramLocationID = "*" OR CONVERT(INT, @tmpLocID) = vParam.Location_ID)
		AND
		(@paramPurposeID1 = "*" OR vParam.Rate_Purpose_ID IN (@pID1, @pID2, @pID3, @pID4, @pID5, @pID6, @pID7, @pID8, @pID9, @pID10))
		AND
		(@paramRateName = "*" OR vParam.Rate_Name LIKE @paramRateName)
	)

END

ELSE

IF (@paramValidFromTo = 'All' AND @paramAllValidDates = 'False')
BEGIN
SELECT 	Vehicle_Rate.Rate_ID, 
	Vehicle_Rate.Rate_Name, 
    	Vehicle_Rate.Rate_Purpose_ID, 
	Rate_Purpose.Rate_Purpose, 
	Rate_Level.Rate_Level AS End_Level,
	Vehicle_Rate.Last_Changed_By, 
    	Vehicle_Rate.Last_Changed_On,
	Violation = CASE WHEN Vehicle_Rate.Violated_Rate_ID IS NOT NULL
			 THEN 'Y'
			 ELSE ''
		    END,
	Restriction = CASE WHEN Rate_Restriction.Restriction_ID IS NOT NULL
		      	 THEN 'Y'
			 ELSE ''
		    END,
    	Vehicle_Rate.Other_Remarks,
	vLVD.Owning_Company_ID,
	vLVD.Owning_Company_Name,
	vLVD.Location_ID,
	vLVD.Location_Name,
	vLVD.Valid_From,
	vLVD.Valid_To
		
FROM 	Vehicle_Rate with(nolock)
	INNER 
	JOIN
	Rate_Purpose 
		ON Rate_Purpose.Rate_Purpose_ID = Vehicle_Rate.Rate_Purpose_ID
		AND Vehicle_Rate.Termination_Date > CONVERT(DATETIME,'2078-12-31')
	INNER
	JOIN
	Rate_Level
		ON Vehicle_Rate.Rate_ID = Rate_Level.Rate_ID
		AND Rate_Level.Rate_Level = (SELECT MAX(Rate_Level) 
						FROM Rate_Level rl with(nolock)
						WHERE Rate_Level.Rate_ID = rl.Rate_ID)
	INNER
	JOIN
	RP_Rc_1_Current_Active_Rate_L1_Base_Loc_And_Valid_Dates vLVD
		ON vLVD.Rate_ID = Vehicle_Rate.Rate_ID
	LEFT 
	JOIN
	Rate_Restriction
		ON Rate_Restriction.Rate_ID = Vehicle_Rate.Rate_ID
		AND Rate_Restriction.Restriction_ID = (SELECT MAX(Restriction_ID) 
								FROM Rate_Restriction rR with(nolock)
									WHERE rR.Rate_ID = Rate_Restriction.Rate_ID
									AND rR.Termination_Date > CONVERT(DATETIME,'2078-12-31'))
		AND Rate_Restriction.Termination_Date > CONVERT(DATETIME,'2078-12-31')

WHERE 	Vehicle_Rate.Rate_ID IN
	(
	SELECT DISTINCT Rate_ID FROM RP_Rc_1_Current_Active_Rate_L1_Base_Param vParam with(nolock)
		WHERE
		(@paramCompanyID = "*" OR CONVERT(INT, @tmpOwningCompanyID) = vParam.Owning_Company_ID)
		AND
		(@paramLocationID = "*" OR CONVERT(INT, @tmpLocID) = vParam.Location_ID)
		AND
		(@paramPurposeID1 = "*" OR vParam.Rate_Purpose_ID IN (@pID1, @pID2, @pID3, @pID4, @pID5, @pID6, @pID7, @pID8, @pID9, @pID10))
		AND
		(@paramRateName = "*" OR vParam.Rate_Name LIKE @paramRateName)
		AND
		(
		 @startDate BETWEEN vParam.Valid_From AND vParam.Valid_To 
		 OR 
		 @endDate BETWEEN vParam.Valid_From AND vParam.Valid_To 
		 OR
		 (vParam.Valid_From > @startDate AND vParam.Valid_To < @endDate)
		)
	)

END
GO
