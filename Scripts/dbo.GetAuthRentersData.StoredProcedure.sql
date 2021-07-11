USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAuthRentersData]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetAuthRentersData    Script Date: 2/18/99 12:11:44 PM ******/
/****** Object:  Stored Procedure dbo.GetAuthRentersData    Script Date: 2/16/99 2:05:40 PM ******/
/****** Object:  Stored Procedure dbo.GetAuthRentersData    Script Date: 1/11/99 1:03:15 PM ******/
/*
PURPOSE: 	To retrieve the address name for the given organization id.
MOD HISTORY:
Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetAuthRentersData]
@OrgID varchar(10)
AS
Set Rowcount 2000
Select
	Address_Name
From
	armaster
Where	Customer_Code = @OrgID
And 	Address_Type = 1
And	Status_Type = 1

Return 1












GO
