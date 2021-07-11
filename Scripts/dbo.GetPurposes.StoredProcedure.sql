USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetPurposes]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetPurposes    Script Date: 2/18/99 12:11:47 PM ******/
/****** Object:  Stored Procedure dbo.GetPurposes    Script Date: 2/16/99 2:05:42 PM ******/
CREATE PROCEDURE [dbo].[GetPurposes]
AS
Set Rowcount 2000
Select
	Rate_Purpose,
	Rate_Purpose_ID
From
	Rate_Purpose
Order By
	Rate_Purpose
Return 1












GO
