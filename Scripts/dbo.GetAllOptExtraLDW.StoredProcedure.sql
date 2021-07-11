USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAllOptExtraLDW]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

/*
PURPOSE: 	To retrieve a list of available optional extra.
MOD HISTORY:
Name          Date                Comments
Andy Zhong    2010 Dec 15th       
*/
Create PROCEDURE [dbo].[GetAllOptExtraLDW]
AS
Select Distinct
	Optional_Extra, Optional_Extra_ID
From
	Optional_Extra
Where
	Type = 'LDW' and Delete_Flag=0
Return 1
GO
