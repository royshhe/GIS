USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAllFFPlan]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetAllFFPlan    Script Date: 2/18/99 12:11:43 PM ******/
/****** Object:  Stored Procedure dbo.GetAllFFPlan    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.GetAllFFPlan    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetAllFFPlan    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: 	To retrieve a list of frequent flyer plans.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetAllFFPlan]
AS
   SELECT Frequent_Flyer_Plan_ID, Airline, Frequent_Flyer_Plan
   FROM   Frequent_Flyer_Plan
   where frequent_flyer_plan_id not in (7, 8, 3)
   ORDER BY Airline, Frequent_Flyer_Plan
   RETURN 1
GO
