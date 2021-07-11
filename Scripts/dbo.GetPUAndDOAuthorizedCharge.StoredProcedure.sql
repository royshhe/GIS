USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetPUAndDOAuthorizedCharge]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
PURPOSE: To retrieve the authorized and unauthorized pickup / drop off charges
	 for a given date 
MOD HISTORY:
Name	Date        	Comments
Don K	Mar 29 2000	Do date comparisons to the day
*/
CREATE PROCEDURE [dbo].[GetPUAndDOAuthorizedCharge]
	@PULocID	VarChar(10),
	@DOLocID	VarChar(10),
	@RateID 	VarChar(10),
	@RateDate	VarChar(24)
AS
	DECLARE @dRateDate DateTime
	DECLARE @nRateID		Integer	
	DECLARE @sRatePurpose  VarChar(10)

    Set Rowcount 2000

	SELECT @nRateID = CONVERT(Int, NULLIF(@RateID , ''))
	SELECT @dRateDate = CAST(FLOOR(CAST(CAST(@RateDate AS datetime) AS float)) AS datetime)

	SELECT     @sRatePurpose=dbo.Rate_Purpose.Rate_Purpose 
	FROM         dbo.Vehicle_Rate INNER JOIN
                      dbo.Rate_Purpose ON dbo.Vehicle_Rate.Rate_Purpose_ID = dbo.Rate_Purpose.Rate_Purpose_ID 
	WHERE	dbo.Vehicle_Rate.Rate_ID = @nRateID
	AND	@dRateDate BETWEEN Effective_Date AND Termination_Date

    IF  @sRatePurpose= 'Tour Pkg'
			SELECT	Distinct
				CONVERT(VarChar, Authorized),
				Authorized_Charge,
				Unauthorized_Charge
			FROM	Tour_Drop_Off_Charge
			WHERE	Pick_Up_Location_ID = CONVERT(SmallInt, @PULocID)
			AND	Drop_Off_Location_ID = CONVERT(SmallInt, @DOLocID)
			AND	@dRateDate BETWEEN Valid_From AND ISNULL(Valid_To, CONVERT(DateTime, 'Dec 31 2078'))
	ELSE

			SELECT	Distinct
				CONVERT(VarChar, Authorized),
				Authorized_Charge,
				Unauthorized_Charge
			FROM	Pick_Up_Drop_Off_Location
			WHERE	Pick_Up_Location_ID = CONVERT(SmallInt, @PULocID)
			AND	Drop_Off_Location_ID = CONVERT(SmallInt, @DOLocID)
			AND	@dRateDate BETWEEN Valid_From AND ISNULL(Valid_To, CONVERT(DateTime, 'Dec 31 2078'))
RETURN 1



--exec GetPUAndDOAuthorizedCharge '16', '16', '', '3/7/2011 3:42:42 PM'
GO
