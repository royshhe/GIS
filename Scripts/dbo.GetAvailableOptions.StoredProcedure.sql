USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAvailableOptions]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO













/****** Object:  Stored Procedure dbo.GetAvailableOptions    Script Date: 2/18/99 12:11:44 PM ******/
/****** Object:  Stored Procedure dbo.GetAvailableOptions    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.GetAvailableOptions    Script Date: 1/11/99 1:03:15 PM ******/
/****** Object:  Stored Procedure dbo.GetAvailableOptions    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: 	To retrieve a list of available optional extra.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetAvailableOptions]
AS
Set Rowcount 2000
Select Distinct
	dbo.Optional_Extra.Optional_Extra,dbo.Optional_Extra.Optional_Extra_ID
From
	Optional_Extra INNER JOIN
      dbo.Optional_Extra_Price ON dbo.Optional_Extra.Optional_Extra_ID = dbo.Optional_Extra_Price.Optional_Extra_ID
Where
	Delete_Flag=0 
	and (dbo.Optional_Extra_Price.Valid_To is null or dbo.Optional_Extra_Price.Valid_To>=getdate())
Return 1














GO
