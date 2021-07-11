USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResRateKMCharge]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetResRateKMCharge    Script Date: 2/18/99 12:12:04 PM ******/
/****** Object:  Stored Procedure dbo.GetResRateKMCharge    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetResRateKMCharge    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetResRateKMCharge    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[GetResRateKMCharge]
	@RateId		Varchar(10),
	@CurrDate	Varchar(24),
	@VehClassCode	Varchar(1),
	@PULocID	VarChar(10)
AS
	/* Modify to to get Per_KM_Charge from Rate_Location_Set if exist;
	   otherwise, get it from Rate_Vehicle_Class
	*/
	/* 10/13/99 - do type conversion and nullif outside of SQL statements */

DECLARE @dPerKMCharge	Decimal(7, 2),
	@iRateId 	Int,
	@dCurrDate	Datetime,
	@iPULocId	SmallInt

	SELECT 	@iRateId = Convert(Int, NULLIF(@RateId,'')),
		@dCurrDate = Convert(Datetime, NULLIF(@CurrDate,'')),
		@iPULocId = CONVERT(Int, NULLIF(@PULocId,'')),
		@VehClassCode = NULLIF(@VehClassCode,'')


	SELECT 	@dPerKMCharge = ISNULL(RLS.Per_KM_Charge, 0)
	FROM	Rate_Location_Set RLS,
		Rate_Location_Set_Member RLSM
	WHERE	RLS.Rate_Location_Set_ID = RLSM.Rate_Location_Set_ID
	AND	RLS.Rate_ID = @iRateId
	AND	@dCurrDate BETWEEN RLS.Effective_Date AND RLS.Termination_Date
	AND	RLSM.Location_Id = @iPULocId
	
	SELECT 	Case
		When @dPerKmCharge > 0 Then
			@dPerKmCharge
		Else
			Per_KM_Charge
		End
	FROM	Rate_Vehicle_Class
	WHERE	Rate_ID = @iRateId
	AND	@dCurrDate BETWEEN Effective_Date AND Termination_Date
	AND	Vehicle_Class_Code = @VehClassCode
	RETURN @@ROWCOUNT























GO
