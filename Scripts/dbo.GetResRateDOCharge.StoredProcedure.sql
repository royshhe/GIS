USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResRateDOCharge]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetResRateDOCharge    Script Date: 2/18/99 12:12:04 PM ******/
/****** Object:  Stored Procedure dbo.GetResRateDOCharge    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetResRateDOCharge    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetResRateDOCharge    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[GetResRateDOCharge]
	@RateId Varchar(10),
	@PULocId Varchar(5),
	@DOLocId Varchar(5),
	@CurrDate Varchar(24)
AS
DECLARE @dCurrDate Datetime
DECLARE @iPULocId SmallInt
DECLARE @iDOLocId SmallInt
DECLARE @iRateId Int
DECLARE @DOCharge Varchar(10)
DECLARE @LocIncluded Bit
DECLARE @RateLocSetId Int
DECLARE @AllowAllDropOff Bit
DECLARE @ByKm Bit
DECLARE @DOLocAuthorized Bit
	SELECT 	@dCurrDate = Convert(Datetime, NULLIF(@CurrDate,"")),
		@iPULocId = Convert(SmallInt, NULLIF(@PULocId,"")),
		@iDOLocId = Convert(SmallInt, NULLIF(@DOLocId,"")),
 	 	@iRateId = Convert(Int, NULLIF(@RateId,"")),
		@DOLocAuthorized = 0,	-- default to Unauthorized
		@AllowAllDropOff = 0	-- default to not allowed
	-- get rate location set id for this rate id and PUL
	SELECT	@RateLocSetId = Rate_Location_Set_ID
	FROM	Rate_Location_Set_Member
	WHERE	Location_ID = Convert(SmallInt, NULLIF(@PULocId,""))
	AND	Rate_ID = @iRateId
	AND	@dCurrDate BETWEEN Effective_Date AND Termination_Date
	-- get allow all drop off flag
	SELECT 	@AllowAllDropOff = Allow_All_Auth_Drop_Off_Locs
	FROM	Rate_Location_Set
	WHERE	Rate_Id = @iRateId
	AND	Rate_Location_Set_Id = @RateLocSetId
	AND	@dCurrDate BETWEEN Effective_Date AND Termination_Date
	-- if drop off charge is not included in rate,
	-- check if the included flag is set for the DOL entry
	IF @AllowAllDropOff = 0
	BEGIN
		-- if this DOL exists for this PUL, then DOL is authorized
		SELECT	@LocIncluded = Included_In_Rate,
			@DOLocAuthorized = 1
		FROM	Rate_Drop_Off_Location
		WHERE	Rate_Id = @iRateId
		AND	Location_ID = @iDOLocId
		AND	Rate_Location_Set_Id = @RateLocSetId
		AND	@dCurrDate BETWEEN Effective_Date AND Termination_Date
		IF @LocIncluded = 1
		BEGIN
			SELECT "Included", Convert(Char(1), @DOLocAuthorized)
			RETURN 1
		END
	END
	-- if DOcharge is not included, check if it is by KM
	SELECT 	@ByKm = Km_Drop_Off_Charge
	FROM	Vehicle_Rate
	WHERE	Rate_ID = @iRateId
	AND	@dCurrDate BETWEEN Effective_Date AND Termination_Date
	
	IF @ByKM = 1
	BEGIN
		SELECT "By Km", Convert(Char(1), @DOLocAuthorized)
		RETURN 1
	END
	-- get location specific drop off charge for this PUL/DOL
	SELECT	@DOCharge =
		   CASE Authorized
			WHEN 1 THEN Convert(Varchar(10), Authorized_Charge)
			ELSE Convert(Varchar(10), Unauthorized_Charge)
		   END,
		@DOLocAuthorized = Authorized
	FROM	Pick_Up_Drop_Off_Location
	WHERE	Pick_Up_Location_Id = @iPULocId
	AND	Drop_Off_Location_Id = @iDOLocId
	AND	@dCurrDate BETWEEN Valid_From AND Valid_To
	-- if no rows found, the get default unauthorized charge for PULocId
	IF @@ROWCOUNT < 1
	BEGIN
		SELECT 	@DOCharge = Convert(Varchar(10),
				Default_Unauthorized_Charge),
			@DOLocAuthorized = 0
		FROM	Location
		WHERE	Location_Id = @iPULocId
	END
	SELECT @DOCharge, Convert(Char(1), @DOLocAuthorized)
	
	RETURN 1












GO
