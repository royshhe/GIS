USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRateAmtByRateLvlVehCls]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetRateAmtByRateLvlVehCls    Script Date: 2/18/99 12:12:02 PM ******/
/****** Object:  Stored Procedure dbo.GetRateAmtByRateLvlVehCls    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetRateAmtByRateLvlVehCls    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetRateAmtByRateLvlVehCls    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetRateAmtByRateLvlVehCls]
@Rate_ID    varchar(15),
@VehClassCode   char(1),
@RateLevel  char(1)
AS
Select Distinct
	RCA.Amount
From
	Rate_Vehicle_Class RVC, Rate_Charge_Amount RCA
Where
	RCA.Rate_Vehicle_Class_ID = RVC.Rate_Vehicle_Class_ID
	And RCA.Rate_ID = RVC.Rate_ID
	And RCA.Rate_ID = Convert(int, @Rate_ID)
	And RCA.Rate_Level = @RateLevel
	And RVC.Vehicle_Class_Code = @VehClassCode
	And RCA.Type = "Regular"
	And RCA.Termination_Date="Dec 31 2078 11:59PM"
	And RVC.Termination_Date="Dec 31 2078 11:59PM"
Return 1












GO
