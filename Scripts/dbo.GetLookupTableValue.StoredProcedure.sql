USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLookupTableValue]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetLookupTableValue    Script Date: 2/18/99 12:11:46 PM ******/
/****** Object:  Stored Procedure dbo.GetLookupTableValue    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetLookupTableValue    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetLookupTableValue    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetLookupTableValue]
@Category varchar(25)
AS
Set Rowcount 2000
Select Distinct
	Value
From
	Lookup_Table
Where
	Category=@Category
Order By Value
Return 1












GO
