USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreatePlateGeneration]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreatePlateGeneration    Script Date: 2/18/99 12:11:42 PM ******/
/****** Object:  Stored Procedure dbo.CreatePlateGeneration    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreatePlateGeneration    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreatePlateGeneration    Script Date: 11/23/98 3:55:31 PM ******/
/*
PURPOSE: To insert a record into Vehicle_Licence table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CreatePlateGeneration]
@Province varchar(20),
@PlateNumber varchar(20),
@UserName varchar(30)
AS
Declare @thisDate datetime
Select @thisDate = getDate()
Insert into Vehicle_Licence
	(Licence_Plate_Number,Licencing_Province_State,
	Created_On,Last_Change_By,Last_Change_On)
Values
	(@PlateNumber,@Province,@thisDate,@UserName,@thisDate)
Return 1













GO
