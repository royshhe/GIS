USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateCtrctInsXfer]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdateCtrctInsXfer    Script Date: 2/18/99 12:12:18 PM ******/
/****** Object:  Stored Procedure dbo.UpdateCtrctInsXfer    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.UpdateCtrctInsXfer    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.UpdateCtrctInsXfer    Script Date: 11/23/98 3:55:34 PM ******/
/*
PROCEDURE NAME: UpdateCtrctInsXfer
PURPOSE: To update an insurance_transfer record
AUTHOR: Don Kirkby
DATE CREATED: Aug 14, 1998
CALLED BY: Contract
REQUIRES: a record exists with the contract number
ENSURES: the record is updated. returns 1 for success, else 0
PARAMETERS:
	CtrctNum: Contract number
	CompName: Company name
	Expiry: expiry date & time
	CollDeduct: Collision Deductible
	CompDeduct: Comprehensive Deductible
	Manufacturer: name of manufacturer
	Model: name of model
	Year
	Licence: Plate number
	LastChangedBy
MOD HISTORY:

Name    Date        Comments
*/
/* Oct 28 - Moved data conversion code out of the where clause */
CREATE PROCEDURE [dbo].[UpdateCtrctInsXfer]
	@CtrctNum	varchar(11),
	@CompName	varchar(20),
	@Expiry		varchar(24),
	@CollDeduct	varchar(13),
	@CompDeduct	varchar(13),
	@Manufacturer	varchar(10),
	@Model		varchar(25),
	@Year		varchar(4),
	@Licence	varchar(10),
	@LastChangedBy	varchar(20)
AS
	Declare	@nCtrctNum Integer
	Select		@nCtrctNum = CONVERT(int, NULLIF(@CtrctNum, ''))

	UPDATE	insurance_transfer
	   SET	company_name = @CompName,
		expiry = CONVERT(datetime, @Expiry),
		collision_deductible =
			CONVERT(decimal(9,2), NULLIF(@CollDeduct, '')),
		comprehensive_deductible =
			CONVERT(decimal(9,2), NULLIF(@CompDeduct, '')),
		vehicle_manufacturer = @Manufacturer,
		vehicle_model_name = @Model,
		vehicle_year = CONVERT(int, @Year),
		vehicle_licence_plate = @Licence,
		last_change_by = @LastChangedBy,
		last_change_on = GetDate()
	 WHERE	contract_number = @nCtrctNum
	RETURN @@ROWCOUNT













GO
