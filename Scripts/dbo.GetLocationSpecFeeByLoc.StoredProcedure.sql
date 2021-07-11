USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLocationSpecFeeByLoc]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Created by Kenneth Wong Jan 13, 2006
-- Get all location fee
CREATE Procedure [dbo].[GetLocationSpecFeeByLoc] 
	@LocationID varchar(5),
	@PickUpDate varchar(25)
AS

Declare @sPickUpDate	datetime
select @sPickUpDate = CONVERT(datetime, NULLIF(@PickUpDate, ''))

	SELECT 	Fee_Type,
		Location_ID, 
		Percentage_Fee = CASE WHEN Percentage_Fee is not null 
					THEN	Percentage_Fee
					ELSE	0
					END,
		Flat_Fee = CASE WHEN Flat_Fee is not null
				THEN	Flat_Fee
				ELSE	0
				END,
		Per_Day_Fee = CASE WHEN Per_Day_Fee is not null
				THEN	Per_Day_Fee
				ELSE	0
				END,
		Fee_description,
		GSTExempt,
		PSTExempt
	FROM Location_Specific_Fees
	WHERE Location_ID = @locationID And
		 @PickUpdate >= Valid_from and
		@PickUpdate < Convert(Datetime, Valid_To)+1

GO
