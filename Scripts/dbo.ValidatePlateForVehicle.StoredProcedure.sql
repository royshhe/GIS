USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[ValidatePlateForVehicle]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.ValidatePlateForVehicle    Script Date: 2/18/99 12:12:19 PM ******/
/****** Object:  Stored Procedure dbo.ValidatePlateForVehicle    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.ValidatePlateForVehicle    Script Date: 1/11/99 1:03:18 PM ******/
/****** Object:  Stored Procedure dbo.ValidatePlateForVehicle    Script Date: 11/23/98 3:55:35 PM ******/
/*
PURPOSE: To validate if the licence plate number for the province of BC exist in GIS and if so, return the unit number of the vehicle which has the licence plate attached on.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[ValidatePlateForVehicle]
@PlateNumber Varchar(10)
AS
Declare @ret int
Select @ret = 	(SELECT
			Count (*)
		FROM
			Vehicle_Licence
		WHERE
			Licence_Plate_Number=@PlateNumber
			And Licencing_Province_State='British Columbia')
If @ret = 0
	Return -1
	
Select @ret = 	(SELECT
			Unit_Number
		FROM
			Vehicle_Licence_History
		WHERE
			Licence_Plate_Number=@PlateNumber
			AND Removed_On IS NULL)
If @ret IS NULL
	Return 0
Return @ret














GO
