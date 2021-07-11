USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetModelPSTRate]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetModelPSTRate    Script Date: 2/18/99 12:12:09 PM ******/
/****** Object:  Stored Procedure dbo.GetModelPSTRate    Script Date: 2/16/99 2:05:41 PM ******/
/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetModelPSTRate]
	@UnitNumber	VarChar(10)
AS
Declare	@nUnitNumber Integer
Select		@nUnitNumber = CONVERT(Int, NULLIF(@UnitNumber, ''))

Select	Distinct
	VMY.PST_Rate
From
	Vehicle_Model_Year VMY,
	Vehicle VEH
Where	VEH.Unit_Number = @nUnitNumber
And	VEH.Vehicle_Model_ID = VMY.Vehicle_Model_ID
Return 1













GO
