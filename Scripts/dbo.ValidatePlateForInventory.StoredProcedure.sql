USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[ValidatePlateForInventory]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.ValidatePlateForInventory    Script Date: 2/18/99 12:12:18 PM ******/
/****** Object:  Stored Procedure dbo.ValidatePlateForInventory    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.ValidatePlateForInventory    Script Date: 1/11/99 1:03:18 PM ******/
/****** Object:  Stored Procedure dbo.ValidatePlateForInventory    Script Date: 11/23/98 3:55:35 PM ******/
/*
PURPOSE: To validate if the combination of unit number, licence plate for the province has been used.
MOD HISTORY:
Name    Date        Comments
*/

/*Moved NULLIF out of the Where clause */
CREATE PROCEDURE [dbo].[ValidatePlateForInventory]
@PlateNumber varchar(20),
@Province varchar(20),
@UnitNumber varchar(20)
AS
Declare @ret int
Declare @nUnitNumber Int

Select @nUnitNumber = Convert(int, @UnitNumber)

Select @ret = 	(SELECT
			Count (*)
		FROM
			Vehicle
		Where
			Unit_Number = @nUnitNumber)
If @ret = 0
	Return -2
Select @ret = 	(SELECT
			Count (*)
		FROM
			Vehicle
		WHERE
			Current_Licence_Plate <> ''
			And Unit_Number = @nUnitNumber)
If @ret > 0
	Return -1
	
Select @ret = 	(SELECT
			Unit_Number
		FROM
			Vehicle_Licence_History
		WHERE
			Licence_Plate_Number = @PlateNumber
			And Licencing_Province_State = @Province
			And Removed_On IS NULL)
If @ret IS NULL
	Return 0
Return @ret















GO
