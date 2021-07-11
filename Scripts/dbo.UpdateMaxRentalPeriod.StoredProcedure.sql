USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[UpdateMaxRentalPeriod]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.UpdateMaxRentalPeriod    Script Date: 2/18/99 12:12:10 PM ******/
/****** Object:  Stored Procedure dbo.UpdateMaxRentalPeriod    Script Date: 2/16/99 2:05:44 PM ******/
/****** Object:  Stored Procedure dbo.UpdateMaxRentalPeriod    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.UpdateMaxRentalPeriod    Script Date: 11/23/98 3:55:35 PM ******/
/*
PURPOSE: To update a record in Vehicle table .
MOD HISTORY:
Name    Date        Comments
*/

/* Oct 28 - Moved data conversion code out of the where clause */

CREATE PROCEDURE [dbo].[UpdateMaxRentalPeriod]
@UnitNumber varchar(10),@MaxRentalPeriod varchar(10),@UserName varchar(30)
AS
Declare	@nUnitNumber Integer
Select		@nUnitNumber = Convert(int, NULLIF(@UnitNumber, ''))
Update
	Vehicle
Set
	Maximum_Rental_Period=Convert(smallint,NULLIF(@MaxRentalPeriod,'')),
	Last_Update_By=@UserName,
	Last_Update_On=getDate()
Where
	Unit_Number=@nUnitNumber
	
Return 1














GO
