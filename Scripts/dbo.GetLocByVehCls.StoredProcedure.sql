USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLocByVehCls]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO











CREATE PROCEDURE [dbo].[GetLocByVehCls]
	@VehClassCode Varchar(1),
	@CurrDate Varchar(24)	
AS
DECLARE @dLastDatetime Datetime
	/* 2/24/99 - cpy created - return all locations that carry VehClassCode
					valid on CurrDate
				- only return rental locations and
				  locations for which resnet can place res */

	/* 3/3/99 - cpy bug fix - remove resnet restriction */

	SELECT	@VehClassCode = NULLIF(@VehClassCode,''),
		@CurrDate = NULLIF(@CurrDate,''),
		@dLastDatetime = Convert(Datetime, '31 Dec 2078 23:59')
	
	SELECT	B.Location, A.Location_id
	FROM	Location B,
		Location_vehicle_class A
	WHERE	B.location_id = A.location_id
	AND	Convert(Datetime,  @CurrDate) BETWEEN A.Valid_From AND
			ISNULL(A.Valid_To, @dLastDatetime)
	AND	A.Vehicle_Class_Code = @VehClassCode
	AND	B.Delete_Flag = 0
	AND	B.Rental_Location = 1
	-- AND	B.ResNet = 1
	ORDER BY B.Location

	RETURN @@ROWCOUNT














GO
