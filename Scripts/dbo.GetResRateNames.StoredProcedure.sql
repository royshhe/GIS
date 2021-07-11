USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResRateNames]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.GetResRateNames    Script Date: 2/18/99 12:11:56 PM ******/
/****** Object:  Stored Procedure dbo.GetResRateNames    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetResRateNames    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetResRateNames    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[GetResRateNames]  --'5625', '2009-04-28','A'
	@RateId Varchar(10),
	@CurrDate Varchar(24),
	@RateLevel Varchar(1)
AS
	/* 3/16/99 - cpy modified - added extra field for rate_source at end
					- # fields should match GetNonGisRateNames */
	/* 8/17/99 - added FPO_Purchased */
	/* 9/02/99 - convert fpo to char(1) */
    /* 04/20/2009 - Roy He Add Calendar Date Flag */

DECLARE @iRateId 		Int
DECLARE @RateName		Varchar(25)
DECLARE @ViolatedRateId		Int
DECLARE @ViolatedRateName	Varchar(25)
DECLARE @ViolatedRateLevel	Char(1)
DECLARE @FFPlan			Bit
DECLARE @FFPlanHonoured 	Varchar(10)
DECLARE @FlexDiscount 		Bit
DECLARE @DiscountAllowed 	Bit
DECLARE @KMDropCharge		Bit
DECLARE @OtherRemarks		Varchar(255)
DECLARE @ContRemarks		Varchar(255)
	IF @RateId = ""		SELECT @RateId = NULL
	IF @CurrDate = ""	SELECT @CurrDate = NULL
	IF @CurrDate = ""	SELECT @CurrDate = NULL

	SET ROWCOUNT 1

	SELECT 	A.Rate_Id,
		A.Rate_Name,
		@RateLevel as Rate_Level,
		FFPlan =
			CASE A.Frequent_Flyer_Plans_Honoured
				WHEN 1 THEN "Honoured"
				ELSE "Not honoured"
			END,
		A.Violated_Rate_Id,

		B.Rate_Name,
		A.Violated_Rate_Level,
		Convert(Char(1), A.Flex_Discount_Allowed) as Flex_Discount_Allowed,
		Convert(Char(1), A.Discount_Allowed) as Discount_Allowed,
		Convert(Char(1), A.Km_Drop_Off_Charge) Km_Drop_Off_Charge,

		A.Other_Remarks,
		A.Contract_Remarks,
		Convert(Char(1), A.Insurance_Transfer_Allowed) as Insurance_Transfer_Allowed,
		Convert(Char(1), A.Warranty_Repair_Allowed) as Warranty_Repair_Allowed,
		A.Manufacturer_ID,
		"GIS",
		Convert(Char(1), A.FPO_Purchased) as FPO_Purchased,
		Convert(Char(1), A.Calendar_Day_Rate) as Calendar_Day_Rate, -- Add Calandar Date Flag,
		--RP.Rate_Purpose
		convert(char(1),A.Underage_Charge) as  Underage_Charge
	FROM	Vehicle_Rate A 
	LEFT JOIN 	Vehicle_Rate B
	ON A.Violated_Rate_Id = B.Rate_Id  AND	Convert(Datetime, @CurrDate) BETWEEN B.Effective_Date AND B.Termination_Date
--		Rate_Purpose RP

--  	FROM	Vehicle_Rate B,
--		Vehicle_Rate A, Rate_Purpose RP


	WHERE	--A.Violated_Rate_Id *= B.Rate_Id --And A.Rate_Purpose_ID=RP.Rate_Purpose_ID	AND	
	A.Rate_Id = Convert(Int, @RateId)
	AND  Convert(Datetime, @CurrDate) BETWEEN A.Effective_Date AND A.Termination_Date
	
	RETURN @@ROWCOUNT
 
GO
