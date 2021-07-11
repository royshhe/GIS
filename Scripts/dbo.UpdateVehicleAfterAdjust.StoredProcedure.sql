USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateVehicleAfterAdjust]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/*
PURPOSE: To update a record in Vehicle table .
MOD HISTORY:
Name    Date        	Comments
NP	Oct 27 99	- Moved data conversion code out of the where clause 
CPY	Jan 21 2000	- added @LastUpdateBy param to update the vehicle table
*/
CREATE PROCEDURE [dbo].[UpdateVehicleAfterAdjust]
	@UnitNum 	Varchar(10),
	@CurrDOLocId 	Varchar(5),
	@KMIn 		Varchar(10),
	@LastUpdateBy 	Varchar(20)
AS
	Declare	@nUnitNum Integer
	Select	@nUnitNum = Convert(Int, NULLIF(@UnitNum, '')),
		@LastUpdateBy = NULLIF(@LastUpdateBy,'')

	UPDATE	Vehicle
	SET	Current_KM = Convert(Int, NULLIF(@KMIn,'')),
		Current_Location_ID = Convert(SmallInt, NULLIF(@CurrDOLocId,'')),
		Last_Update_By = ISNULL(@LastUpdateBy, Last_Update_By),
		Last_Update_On = GetDate()
	WHERE	Unit_Number = @nUnitNum

	RETURN @@ROWCOUNT
GO
