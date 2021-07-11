USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SelectInto]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO









CREATE PROCEDURE [dbo].[SelectInto]
@LicencePlate VarChar(10)
AS

Declare @UnitNumber Int
Declare @AttachedOn DateTime

Select	@UnitNumber = Unit_Number, @AttachedOn = Attached_On
From	Vehicle_Licence_History
Where	Licence_Plate_Number = @LicencePlate
And	Attached_On =	(	Select	Min(Attached_On)
				From	Vehicle_Licence_History
				Where	Licence_Plate_Number = @LicencePlate		
			)

Select	@UnitNumber, @AttachedOn
Return 1













GO
