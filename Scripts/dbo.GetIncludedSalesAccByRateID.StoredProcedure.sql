USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetIncludedSalesAccByRateID]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetIncludedSalesAccByRateID    Script Date: 2/18/99 12:11:54 PM ******/
/****** Object:  Stored Procedure dbo.GetIncludedSalesAccByRateID    Script Date: 2/16/99 2:05:41 PM ******/
CREATE PROCEDURE [dbo].[GetIncludedSalesAccByRateID]
@RateID varchar(20)
AS
Set Rowcount 2000
Select
	ISA.Sales_Accessory_ID,
	SA.Sales_Accessory,

	SA.Unit_Description
From
	Included_Sales_Accessory ISA,
	Sales_Accessory SA
Where
	ISA.Rate_ID = Convert(int, @RateID)
	And ISA.Termination_Date = 'Dec 31 2078 11:59PM'
        And ISA.Sales_Accessory_ID = SA.Sales_Accessory_ID
	And SA.Delete_Flag=0
Order By
	SA.Sales_Accessory + " - " + SA.Unit_Description
Return 1












GO
