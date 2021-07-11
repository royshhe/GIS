USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRateSelectionType]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetRateSelectionType    Script Date: 2/18/99 12:12:09 PM ******/
/****** Object:  Stored Procedure dbo.GetRateSelectionType    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetRateSelectionType    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetRateSelectionType    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetRateSelectionType]
	@RateID		varchar(15),
	@RateLevel	char(1),
	@PickupDate	varchar(24),
	@sLocVehRateType varchar(10) 
AS
	/* 10/05/99 - NP - @PickUpDate varchar(20) -> 24 */

Select Distinct
	B.Rate_Selection_Type
From
	Rate_Level A, Location_Vehicle_Rate_Level B
Where
	A.Rate_ID=B.Rate_ID
	And   A.Rate_Level=B.Rate_Level
	And   A.Termination_Date = 'Dec 31 2078 11:59PM'
	And   B.Location_Vehicle_Rate_Type = @sLocVehRateType
	And   B.Valid_From <= Convert(datetime, @PickupDate)
	And   B.Valid_To >= Convert(datetime, @PickupDate)
	And   A.Rate_ID=Convert(int,@RateID)
	And   A.Rate_Level=@RateLevel
Return 1










GO
