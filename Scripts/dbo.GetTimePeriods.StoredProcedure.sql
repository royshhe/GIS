USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetTimePeriods]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetTimePeriods    Script Date: 2/18/99 12:11:48 PM ******/
/****** Object:  Stored Procedure dbo.GetTimePeriods    Script Date: 2/16/99 2:05:43 PM ******/
CREATE PROCEDURE [dbo].[GetTimePeriods]
AS
Set Rowcount 2000
Select
	Time_Period
From
	Time_Period
Order By
	Sort_Order
Return 1












GO
