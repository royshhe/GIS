USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLicenceInventoryData]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetLicenceInventoryData    Script Date: 2/18/99 12:12:16 PM ******/
/****** Object:  Stored Procedure dbo.GetLicenceInventoryData    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetLicenceInventoryData    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetLicenceInventoryData    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetLicenceInventoryData]
@PlateNumber varchar(10)
AS
Set Rowcount 2000
Select
	Unit_Number,
	CONVERT(VarChar, Attached_On,  111) Attached_On_Date,
	CONVERT(VarChar, Attached_On,  108) Attached_On_Time,
	CONVERT(VarChar, Removed_On,  111) Removed_On_Date,
	CONVERT(VarChar, Removed_On,  108) Removed_On_Time,
	Comment
From
	Vehicle_Licence_History
Where
	Licence_Plate_Number = @PlateNumber
	And Licencing_Province_State = 'British Columbia'
	And Removed_On IS NOT NULL
Order By Attached_On Desc
Return 1















GO
