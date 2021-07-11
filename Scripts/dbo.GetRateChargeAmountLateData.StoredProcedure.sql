USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRateChargeAmountLateData]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetRateChargeAmountLateData    Script Date: 2/18/99 12:11:47 PM ******/
/****** Object:  Stored Procedure dbo.GetRateChargeAmountLateData    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetRateChargeAmountLateData    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetRateChargeAmountLateData    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetRateChargeAmountLateData]
@RateID varchar(20),
@Level varchar(20),
@VehicleClassID varchar(20)
AS
Set Rowcount 2000
Select
	Amount
From
	Rate_Charge_Amount
Where
	Rate_ID=Convert(int,@RateID)
	And Termination_Date='Dec 31 2078 11:59PM'
	And Rate_Level=@Level
	And Rate_Vehicle_Class_ID = Convert(int,@VehicleClassID)
	And Type='Late'
ORDER BY
	Rate_Time_Period_ID
		
Return 1












GO
