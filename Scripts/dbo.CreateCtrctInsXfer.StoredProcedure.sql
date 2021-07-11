USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateCtrctInsXfer]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateCtrctInsXfer    Script Date: 2/18/99 12:12:12 PM ******/
/****** Object:  Stored Procedure dbo.CreateCtrctInsXfer    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateCtrctInsXfer    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateCtrctInsXfer    Script Date: 11/23/98 3:55:31 PM ******/
/*
PROCEDURE NAME: CreateCtrctInsXfer
PURPOSE: To create an insurance_transfer record
AUTHOR: Don Kirkby
DATE CREATED: Aug 14, 1998
CALLED BY: Contract
REQUIRES: no record exists with the same contract number
ENSURES: new record is created. returns 1 for success, else 0
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
CREATE PROCEDURE [dbo].[CreateCtrctInsXfer]
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
	INSERT
	  INTO	insurance_transfer
		(
		contract_number,
		company_name,
		expiry,
		collision_deductible,
		comprehensive_deductible,
		vehicle_manufacturer,
		vehicle_model_name,
		vehicle_year,
		vehicle_licence_plate,
		Last_Change_By,
		Last_Change_On
		)
	VALUES	(
		CONVERT(int, @CtrctNum),
		@CompName,
		CONVERT(datetime, @Expiry),
		CONVERT(decimal(9,2), NULLIF(@CollDeduct, '')),
		CONVERT(decimal(9,2), NULLIF(@CompDeduct, '')),
		@Manufacturer,
		@Model,
		CONVERT(int, @Year),
		@Licence,
		@LastChangedBy,
		GetDate()
		)
	RETURN @@ROWCOUNT












GO
