USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRateMaintVehicleRateData]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.GetRateMaintVehicleRateData    Script Date: 2/18/99 12:11:55 PM ******/
/****** Object:  Stored Procedure dbo.GetRateMaintVehicleRateData    Script Date: 2/16/99 2:05:42 PM ******/
CREATE PROCEDURE [dbo].[GetRateMaintVehicleRateData] -- 866
	@RateId Varchar(25)
AS

	/* 2/17/99 - cpy - applied fix to last_changed_on date manipulation */


Set Rowcount 1
Declare @ViolatedRateID int
Declare @ViolatedRateName varchar(25)
Select @ViolatedRateID =
	(Select Distinct
		Violated_Rate_ID
	From
		Vehicle_Rate
	Where
		Rate_ID = Convert(int, @RateID)
		And Termination_Date = 'Dec 31 2078 11:59PM')
Select @ViolatedRateName =
	(Select Distinct
		Rate_Name
	From
		Vehicle_Rate
	Where
		Rate_ID = @ViolatedRateID
		And Termination_Date = 'Dec 31 2078 11:59PM')
Select
	@RateID,
	Rate_Name,
	Rate_Purpose_ID,
	Convert(char(1), Upsell),
	Convert(char(1), Flex_Discount_Allowed),
	Convert(char(1), Discount_Allowed),
	Convert(char(1), Frequent_Flyer_Plans_Honoured),
	Convert(char(1), Commission_Paid),
	Convert(char(1), Referral_Fee_Paid),
	Convert(char(1), Insurance_Transfer_Allowed),
	Convert(char(1), Km_Drop_Off_Charge),
	Convert(char(1), Warranty_Repair_Allowed),
	convert(char(1), Calendar_Day_Rate),
	Manufacturer_ID,
	Contract_Remarks,
	Other_Remarks,
	Last_Changed_By,
	Convert(Varchar(11), Last_Changed_On, 100) + ' ' +
	Convert(Varchar(5), Last_Changed_On, 108),
/*
	Substring(DateName(mm,Last_Changed_On),1,3) + " "
	+ Right('0' + Convert(varchar,DatePart(dd,Last_Changed_On)),2)
	+ " " + Convert(char(4),DatePart(yy,Last_Changed_On))
	+ " " + Right('0' + Convert(varchar,DatePart(hh,Last_Changed_On)),2)
	+ ":" + Right('0' + Convert(varchar,DatePart(mi,Last_Changed_On)),2), */
	Special_Restrictions,
	@ViolatedRateName,
	Violated_Rate_Level,
	Convert(char(1),GST_Included),
	Convert(char(1),PST_Included),
	Convert(char(1),PVRT_Included),
	Convert(char(1),Location_Fee_Included),
	Convert(char(1), FPO_Purchased),
	Convert(char(1), License_Fee_Included),
	Convert(char(1), ERF_Included),
	Convert(char(1), CFC_Included),
	Convert(Varchar(25), Amount_Markup),
	convert(char(1),isnull(Underage_Charge,0))
From
	Vehicle_Rate
Where
	Rate_ID=Convert(int,@RateID)
	And Termination_Date='Dec 31 2078 11:59PM'
Return 1



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
