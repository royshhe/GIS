USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdOptExtraPrice]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.UpdOptExtraPrice    Script Date: 2/18/99 12:11:58 PM ******/
/****** Object:  Stored Procedure dbo.UpdOptExtraPrice    Script Date: 2/16/99 2:05:43 PM ******/
/*
PURPOSE: To update a record in Optional_Extra_Price table .
MOD HISTORY:
Name    Date        Comments
*/
/* Oct 27 - Moved data conversion code out of the where clause */
CREATE PROCEDURE [dbo].[UpdOptExtraPrice]
	@OptionalExtraID	VarChar(10),
	@OptionalExtraValidFrom	VarChar(24),
	@OldValidFrom		VarChar(24),
	@ValidTo		VarChar(24),
	@DailyRate		VarChar(10),
	@WeeklyRate		VarChar(10),
	@RentalCalendarDay	VarChar(8),
	@GSTExempt		VarChar(1),
	@HST2Exempt		VarChar(1),
	@PSTExempt		VarChar(1),
	@LastChangedBy		VarChar(20)
AS
	Declare @nOptionalExtraID SmallInt
	Declare @dOldValidFrom DateTime

	Select	@nOptionalExtraID = CONVERT(SmallInt, NULLIF(@OptionalExtraID, ''))
	Select	@dOldValidFrom = CONVERT(DateTime, NULLIF(@OldValidFrom, ''))

	If @OptionalExtraValidFrom = ''
		Select @OptionalExtraValidFrom = NULL

	If @ValidTo = ''
		Select @ValidTo = NULL

	--Front End logic change. Optional Extra only have either one Exempt: GSTExempt or HST2Exempt /Peter Ni	
	--So, only pick up @GSTExempt as Exempt. @HST2Exempt no used!
	if @GSTExempt='1' 
			select @HST2Exempt='0'
	 else
			select @HST2Exempt='1'

	UPDATE Optional_Extra_Price
		
	SET	Optional_Extra_Valid_From = CONVERT(DateTime, @OptionalExtraValidFrom),
		Valid_To = CONVERT(DateTime, @ValidTo),
		Rental_Calendar_Day = @RentalCalendarDay,
		Daily_Rate = CONVERT(Decimal(7,2), @DailyRate),
		Weekly_Rate = CONVERT(Decimal(7,2), @WeeklyRate),
		GST_Exempt = CONVERT(Bit, @GSTExempt),
		HST2_Exempt = CONVERT(Bit, @HST2Exempt),
		PST_Exempt = CONVERT(Bit, @PSTExempt),
		Last_Changed_By = @LastChangedBy,
		Last_Changed_On = GetDate()

	WHERE	Optional_Extra_ID = @nOptionalExtraID
	AND	Optional_Extra_Valid_From = @dOldValidFrom

RETURN @nOptionalExtraID
GO
