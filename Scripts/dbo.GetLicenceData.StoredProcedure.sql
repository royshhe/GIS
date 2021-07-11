USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLicenceData]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetLicenceData    Script Date: 2/18/99 12:12:08 PM ******/
/****** Object:  Stored Procedure dbo.GetLicenceData    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetLicenceData    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetLicenceData    Script Date: 11/23/98 3:55:33 PM ******/
CREATE PROCEDURE [dbo].[GetLicenceData]
	@PlateNumber varchar(10)
AS
Declare @thisUnitNumber int

	/* 8/28/99 - if > 1 unit has this licence plate, then take the unit with the
			latest attached on date */

SET ROWCOUNT 1

		Select	@thisUnitNumber = Unit_Number
		From	Vehicle V1
		Where	Current_Licence_Plate = @PlateNumber
		AND	Licence_Plate_Attached_On =
				(SELECT	MAX(Licence_Plate_Attached_On)
				 FROM	Vehicle V2
				 WHERE	V1.Current_Licence_Plate = V2.Current_Licence_Plate)

SET ROWCOUNT 2000

Select Distinct
	Licence_Plate_Number,
	Licencing_Province_State,
	@thisUnitNumber,
	Created_On,
	Last_Change_By,
	Last_Change_On
From
	Vehicle_Licence
Where
	Licence_Plate_Number = @PlateNumber
	And Licencing_Province_State = 'British Columbia'
	And Delete_Flag = 0
Return 1

















GO
