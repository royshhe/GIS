USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLocationIncrYieldTiers]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Stored Procedure dbo.GetLocationListByOwningCompany    Script Date: 2/18/99 12:11:52 PM ******/
/****** Object:  Stored Procedure dbo.GetLocationListByOwningCompany    Script Date: 2/16/99 2:05:40 PM ******/
/*
PURPOSE: 	To retrieve a list of locations that belong to BudgetBC.
MOD HISTORY:
Name    Date        Comments
Roy     2002-02-14
*/
CREATE PROCEDURE [dbo].[GetLocationIncrYieldTiers]
@LocationID int,
@VehicleType varchar(10)='car',
@ReportDate datetime	
AS

   SELECT LocationID, PayoutTierStart, PayoutTierEnd, Commission, 
   EffectiveDate, TerminateDate
   FROM LocationInscrYield
where (@ReportDate between EffectiveDate and  TerminateDate) and LocationID=@LocationID and VehicleType=@VehicleType
GO
