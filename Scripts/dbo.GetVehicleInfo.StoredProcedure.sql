USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehicleInfo]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetVehicleInfo    Script Date: 2/18/99 12:12:10 PM ******/
/****** Object:  Stored Procedure dbo.GetVehicleInfo    Script Date: 2/16/99 2:05:43 PM ******/
/****** Object:  Stored Procedure dbo.GetVehicleInfo    Script Date: 1/11/99 1:03:17 PM ******/
/****** Object:  Stored Procedure dbo.GetVehicleInfo    Script Date: 11/23/98 3:55:34 PM ******/
/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetVehicleInfo]
	@UnitNumber varchar(10)
AS
--End standard settings
	/* 3/10/99 - cpy modified - added vehicle class code */
	Declare	@nUnitNumber Integer
	Select		@nUnitNumber = Convert(int, NULLIF(@UnitNumber, ''))

	Select	Do_Not_Rent_Past_KM,
		Do_Not_Rent_Past_Days,
		Ownership_Date,
		Vehicle_Class_Code

	From	Vehicle
	
	Where	Unit_Number = @nUnitNumber
	And	Program = 1
	
RETURN 1














GO
