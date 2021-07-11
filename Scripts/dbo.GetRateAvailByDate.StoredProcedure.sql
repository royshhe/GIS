USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRateAvailByDate]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetRateAvailByDate    Script Date: 2/18/99 12:11:47 PM ******/
/****** Object:  Stored Procedure dbo.GetRateAvailByDate    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetRateAvailByDate    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetRateAvailByDate    Script Date: 11/23/98 3:55:33 PM ******/
/****** Object:  Stored Procedure dbo.GetRateAvailByDate    Script Date: 9/8/98 2:10:19 PM ******/
CREATE PROCEDURE [dbo].[GetRateAvailByDate]
	@RateID		VarChar(10),
	@PickupDate	VarChar(24)
AS
	/* 10/05/99 - NP - @PickupDate varchar(20) -> 24 */

Declare @thisPickupDate datetime
Select @thisPickupDate = Convert(datetime,@PickupDate)
SELECT
	Count(*)
From
	Rate_Availability
Where
	Rate_ID = CONVERT(Int, @RateID)
	And Termination_Date = 'Dec 31 2078 11:59PM'
	And @PickupDate BETWEEN Valid_From AND ISNULL(Valid_To,@PickupDate)
RETURN 1











GO
