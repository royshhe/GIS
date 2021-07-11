USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLookupTableCode]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetLookupTableCode    Script Date: 2/18/99 12:11:45 PM ******/
/****** Object:  Stored Procedure dbo.GetLookupTableCode    Script Date: 2/16/99 2:05:41 PM ******/
CREATE PROCEDURE [dbo].[GetLookupTableCode]
@Category varchar(25),
@Value varchar(25)
AS
Set Rowcount 1
Select Distinct
	Code
From
	Lookup_Table
Where
	Category = @Category
	And Value = @Value
Return 1














GO
