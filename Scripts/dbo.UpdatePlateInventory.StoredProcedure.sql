USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdatePlateInventory]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO








/*
PURPOSE: To update a record in Vehicle_Licence_History table .
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[UpdatePlateInventory]
	@PlateNumber varchar(20),
	@Province varchar(20),
	@UnitNumber varchar(20),
	@DateRemoved varchar(20),
	@Comments varchar(255),
	@UserName varchar(30)
AS
	/* 6/02/99 - cpy bug fix - save removed_on date as date only (set time as 12:00am) */
	-- Jun 7 1999 - Don K - Set licence_attached_on to NULL.
	/* 10/12/99 - do type conversion and nullif outside of SQL statement */

Declare @thisStatus char(1)
Declare @thisDate datetime
Declare @thisRemovedOnDate datetime
DECLARE @iUnitNum Int

Select @thisDate = GetDate()

SELECT 	@thisRemovedOnDate = ISNULL(Convert(Datetime, NULLIF(@DateRemoved,'')), GetDate()), 
	@iUnitNum = Convert(int, NULLIF(@UnitNumber,'')),
	@Province = NULLIF(@Province,''),
	@PlateNumber = NULLIF(@PlateNumber,'')

-- truncate time from removed on date
SELECT @thisRemovedOnDate = Cast( Floor(Cast(@thisRemovedOnDate as Float)) as Datetime)

-- 
-- Remove this licence from this unit
Update
	Vehicle_Licence_History
Set
	Removed_On = Convert(datetime,@DateRemoved),
	Comment = NULLIF(@Comments,''),
	Changed_By = 'u-' + @UserName
Where
	Unit_Number = @iUnitNum
	And Licencing_Province_State = @Province
	And Licence_Plate_Number = @PlateNumber
	And Removed_On IS NULL
--
-- Clear this licence from being attached to this unit
Update
	Vehicle
Set
	Current_Licence_Plate = '',
	licence_plate_attached_on = NULL,
	Current_Licencing_Prov_State = '',
	Last_Update_By = @UserName,
	Last_Update_On = @thisDate
Where
	Unit_Number = @iUnitNum
--
-- Update the last modified datetime on this licence
Update
	Vehicle_Licence
Set
	Last_Change_By = @UserName,
	Last_Change_On = @thisDate
Where
	Licence_Plate_Number = @PlateNumber
	And Licencing_Province_State = @Province

Return 1
GO
