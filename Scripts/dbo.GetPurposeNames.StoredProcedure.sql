USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetPurposeNames]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetPurposeNames    Script Date: 2/18/99 12:11:46 PM ******/
/****** Object:  Stored Procedure dbo.GetPurposeNames    Script Date: 2/16/99 2:05:42 PM ******/
CREATE PROCEDURE [dbo].[GetPurposeNames]
AS
Set Rowcount 2000
Select Distinct
	Rate_Purpose
From
	Rate_Purpose
Order By
	Rate_Purpose
Return 1












GO
