USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetOptExtraIDs]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






/****** Object:  Stored Procedure dbo.GetOptExtraIDs    Script Date: 2/18/99 12:11:46 PM ******/
/****** Object:  Stored Procedure dbo.GetOptExtraIDs    Script Date: 2/16/99 2:05:42 PM ******/
/* Nov 01 1999 - Modified to return an Optional Extra ID for LDW which has the lowest deductible for the given vehicle class code */
CREATE PROCEDURE [dbo].[GetOptExtraIDs]
	@VehicleClassCode	VarChar(1)
	
AS
Declare @LDWId smallint
Declare @PAEId smallint
Declare @RSNId smallint 

Select	@VehicleClassCode = NULLIF(@VehicleClassCode, '')

Select @LDWId =
	(SELECT
		MIN(OE.Optional_Extra_ID)
	FROM
		Optional_Extra OE,
		LDW_Deductible LDW
	WHERE
		OE.Type = 'LDW'
	And	OE.Optional_Extra_ID = LDW.Optional_Extra_ID
	And	LDW.Vehicle_Class_Code = @VehicleClassCode
	And 	OE.Delete_Flag = 0
	And	LDW.LDW_Deductible = 	(SELECT
							MIN(LDW.LDW_Deductible)
						FROM
							Optional_Extra OE,
							LDW_Deductible LDW
						WHERE
							OE.Type = 'LDW'
						And	OE.Optional_Extra_ID = LDW.Optional_Extra_ID
						And	LDW.Vehicle_Class_Code = @VehicleClassCode
						And 	OE.Delete_Flag = 0)
	)

Select @PAEId =

	(SELECT
		Optional_Extra_ID
	FROM
		Optional_Extra
	WHERE
		Type = 'PAE'
		And Delete_Flag = 0)

Select @RSNId =
	(SELECT
		Optional_Extra_ID
	FROM
		Optional_Extra
	WHERE
		Type = 'RSN'
		And Delete_Flag = 0)

Select @LDWId, @PAEId, @RSNId
RETURN 1


GO
