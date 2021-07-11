USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GenerateLocationVehicleRateLevel]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/*
PURPOSE: To insert a record into LocationVehicleRateLevel table.
Created By: Roy He
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[GenerateLocationVehicleRateLevel]
	@LocationID			int,
        @VCCode                         Varchar(2),
	@RateID				int,
	@RateLevel			VarChar(1),
	@LocationVCRateType		VarChar(20),
	@ValidFrom			VarChar(24),
	@ValidTo			VarChar(24),
	@SelectionType			VarChar(20)
AS
	/*
	Set blank to Null for the values will be converted to numeric
	*/	
	If @ValidFrom = ''
		Select @ValidFrom = NULL
	Else
		Select @ValidFrom = CONVERT(VarChar, CONVERT(DateTime, @ValidFrom), 111) + ' 00:00:00'
	If @ValidTo = ''
		Select @ValidTo = NULL
	Else
		Select @ValidTo = CONVERT(VarChar, CONVERT(DateTime, @ValidTo), 111) + ' 23:59:59'
	Select @RateLevel = Upper(@RateLevel)


	INSERT INTO LocationVehicleRateLevel
	  (	Location_ID ,
		Vehicle_Class_Code,          
		Rate_ID,
		Rate_Level,
		Location_Vehicle_Rate_Type,
		Valid_From,
		Valid_To,
		Rate_Selection_Type
	  )
	VALUES
	  (	CONVERT(SmallInt, @LocationID),
                @VCCode,
		CONVERT(Int, @RateID),
		@RateLevel,
		@LocationVCRateType,
		CONVERT(DateTime, @ValidFrom),
		CONVERT(DateTime, @ValidTo),
		@SelectionType
	  )
Return 1


GO
