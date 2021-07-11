USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateOptExtraPrice]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.CreateOptExtraPrice    Script Date: 2/18/99 12:11:50 PM ******/
/****** Object:  Stored Procedure dbo.CreateOptExtraPrice    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateOptExtraPrice    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateOptExtraPrice    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To insert a record into Optional_Extra_Price table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CreateOptExtraPrice]
	@OptionalExtraID	VarChar(10),
	@OptionalExtraValidFrom	VarChar(24),
	@ValidTo		VarChar(24),
	@DailyRate		VarChar(10),
	@WeeklyRate		VarChar(10),
	@RentalCalendarDay	VarChar(8),
	@GSTExempt		VarChar(1),
	@HST2Exempt		Varchar(1),
	@PSTExempt		VarChar(1),
	@LastChangedBy		VarChar(20)
AS
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
			
	INSERT INTO Optional_Extra_Price
		(
		Optional_Extra_ID,
		Optional_Extra_Valid_From,
		Valid_To,
		Rental_Calendar_Day,
		Daily_Rate,
		Weekly_Rate,
		GST_Exempt,
		HST2_Exempt,
		PST_Exempt,
		Last_Changed_By,
		Last_Changed_On
		)
	VALUES
		(
		CONVERT(SmallInt, @OptionalExtraID),
		CONVERT(DateTime, @OptionalExtraValidFrom),
		CONVERT(DateTime, @ValidTo),
		@RentalCalendarDay,
		CONVERT(Decimal(7,2), @DailyRate),
		CONVERT(Decimal(7,2), @WeeklyRate),
		CONVERT(Bit, @GSTExempt),
		CONVERT(Bit, @HST2Exempt),
		CONVERT(Bit, @PSTExempt),
		@LastChangedBy,
		GetDate()
		)
RETURN CONVERT(SmallInt, @OptionalExtraID)
GO
