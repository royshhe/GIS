USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateOverrideCheckIn]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateOverrideCheckIn    Script Date: 2/18/99 12:12:19 PM ******/
/****** Object:  Stored Procedure dbo.CreateOverrideCheckIn    Script Date: 2/16/99 2:05:39 PM ******/
/*
PURPOSE: To insert a record into Override_Check_In table.
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[CreateOverrideCheckIn]
	@OverridingCtrctNum 	varchar(20),		-- overriding contract#
	@UnitNumber 		varchar(20),
	@OverridenCtrctNum 	varchar(20),		-- overridden contract#
	@OverrideCIDate 	varchar(20),		-- override check in date
	@OverrideCITime 	varchar(20),		-- override check in time
	@LicenceNumber 	varchar(20),
	@KmIn 			varchar(20),
	@FuelLevel 		varchar(20),
	@FuelRemaining 	varchar(20),
	@DOLocationName 	varchar(35),			-- drop off location name
	@CheckedInBy		VarChar(20)
AS
Declare @DOLocId int
Declare @OverridenCODatetime datetime

	/* 3/25/99 - cpy bug fix - apply NULLIF to all fields before using */
	/* 3/26/99 - cpy bug fix - remove convert to smallint on location */
	/* 4/08/99 - cpy bug fix - the select to get the last checked_out date for this
				contract and unit# only had contract# in the where clause;
				added unit# */
	/* 4/09/99 - cpy bug fix - was inserting @OverridenCODatetime and CheckedOutDatetimes in
				the wrong place */
	/* 6/21/99 - renamed params to match table columns for readability */
	/* 8/13/99 - added @CheckedInBy param */

	Select 	@DOLocId = Location_ID
	From	Location
	Where	Location = NULLIF(@DOLocationName,'')

SET ROWCOUNT 1
	
	-- if so happens the same vehicle is put on contract more than once,
	-- get the last checked_out date
	Select 	@OverridenCODatetime = Checked_Out
	From	Vehicle_On_Contract
	Where	Contract_Number = Convert(int, NULLIF(@OverridenCtrctNum,''))
	AND	Unit_Number = Convert(Int, NULLIF(@UnitNumber,''))
	ORDER BY Checked_Out DESC

SET ROWCOUNT 0

Insert Into Override_Check_In
	(Overridden_Contract_Number,
	 Unit_Number,
	 Checked_Out,
	 Override_Contract_Number,
	 Drop_Off_Location_ID,
	 Check_In,
	 Km_In,
	 Fuel_Level,
	 Fuel_Remaining,
	 Checked_In_By )
Values
	(Convert(int, NULLIF(@OverridenCtrctNum,'')),
	 Convert(int, NULLIF(@UnitNumber,'')),
	 @OverridenCODatetime,
	 Convert(int, NULLIF(@OverridingCtrctNum,'')),
	 @DOLocId,
	 Convert(Datetime, NULLIF(@OverrideCIDate,'') + ' ' + NULLIF(@OverrideCITime,'')),
	 Convert(int, NULLIF(@KmIn,'')),
	 NULLIF(@FuelLevel,''),
	 Convert(Decimal(5, 2), NULLIF(@FuelRemaining,'')),
	 NULLIF(@CheckedInBy, ''))

Return 1









GO
