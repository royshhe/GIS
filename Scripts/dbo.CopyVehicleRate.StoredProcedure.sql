USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CopyVehicleRate]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  Stored Procedure dbo.CopyVehicleRate    Script Date: 2/18/99 12:12:06 PM ******/
/****** Object:  Stored Procedure dbo.CopyVehicleRate    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CopyVehicleRate    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CopyVehicleRate    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To copy Vehicle_Rate info from the current rate into the new rate(system generate new rate id).
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[CopyVehicleRate]
/* Copy one vehicle rate record to another */
@RateID varchar(7),
@RateName varchar(25),
@ChangedBy varchar(35)
AS
Declare @thisDate datetime
Declare @oldRateID int
Declare @newRateID int
Declare @ret int
Select @thisDate = getDate()
Select @oldRateID = Convert(int,@RateID)
Insert Into Vehicle_Rate
	(Effective_Date,Termination_Date,Rate_Name,Rate_Purpose_ID,Upsell,
	Flex_Discount_Allowed,Discount_Allowed,Frequent_Flyer_Plans_Honoured,
	Commission_Paid,Referral_Fee_Paid,Insurance_Transfer_Allowed,
	Km_Drop_Off_Charge,Warranty_Repair_Allowed,Manufacturer_ID,
	Contract_Remarks,Other_Remarks,Last_Changed_By,Last_Changed_On,
	Special_Restrictions,Violated_Rate_ID,Violated_Rate_Level,
	GST_Included,PST_Included,PVRT_Included,Location_Fee_Included,
	FPO_Purchased, License_Fee_Included,Amount_Markup,ERF_Included,Calendar_Day_Rate,Underage_Charge)
Select
	@thisDate,Termination_Date,@RateName,Rate_Purpose_ID,Upsell,
	Flex_Discount_Allowed,Discount_Allowed,Frequent_Flyer_Plans_Honoured,
	Commission_Paid,Referral_Fee_Paid,Insurance_Transfer_Allowed,
	Km_Drop_Off_Charge,Warranty_Repair_Allowed,Manufacturer_ID,
	Contract_Remarks,Other_Remarks,@ChangedBy,@thisDate,
	Special_Restrictions,Violated_Rate_ID,Violated_Rate_Level,
	GST_Included,PST_Included,PVRT_Included,Location_Fee_Included,
	FPO_Purchased, License_Fee_Included,Amount_Markup,ERF_Included,Calendar_Day_Rate,Underage_Charge
--select *
From
	Vehicle_Rate
Where
	Rate_ID=Convert(int,@RateID)
	And Termination_Date='Dec 31 2078 11:59PM'
Select @newRateID = @@IDENTITY
Execute @ret=CopyRateAvailability @oldRateID,@newRateID
Execute @ret=CopyRateRestriction @oldRateID,@newRateID
Execute @ret=CopyIncludedOptionalExtras @oldRateID,@newRateID
Execute @ret=CopyIncludedSalesAccessory @oldRateID,@newRateID
Execute @ret=CopyRateTimePeriod @oldRateID,@newRateID
Execute @ret=CopyRateLevel @oldRateID,@newRateID
Execute @ret=CopyRateVehicleClass @oldRateID,@newRateID
Execute @ret=CopyRateChargeAmount @oldRateID,@newRateID
Execute @ret=CopyRateLocationSet @oldRateID,@newRateID
Execute @ret=CopyRateLocationSetMember @oldRateID,@newRateID
Execute @ret=CopyRateDropOffLocation @oldRateID,@newRateID
Return @newRateID
GO
