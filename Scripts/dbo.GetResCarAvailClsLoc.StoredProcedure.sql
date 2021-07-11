USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResCarAvailClsLoc]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[GetResCarAvailClsLoc]  --'B', 16, '2011-03-25'
	@VehClassCode Varchar(1),
	@PULocId Varchar(5),
	@PUDate Varchar(24)
AS
DECLARE @dLastDatetime Datetime
	
	/* 2/24/99 - cpy bug fix - order by location name */

	SELECT 	@VehClassCode = NULLIF(@VehClassCode,''),
		@PULocId = NULLIF(@PULocId,''),
		@PUDate = NULLIF(@PUDate,'')

	SELECT @dLastDatetime = Convert(Datetime, '31 Dec 2078 23:59')
	
	SELECT	B.Location, A.Location_id
	FROM	
		Location B Left Join 
		Location_vehicle_class A
		On B.location_id = A.location_id
       AND	
		Convert(Datetime,  @PUDate) BETWEEN A.Valid_From AND
			ISNULL(A.Valid_To, @dLastDatetime)
	AND	A.Vehicle_Class_Code = @VehClassCode

--        Location B,
--		Location_vehicle_class A
	WHERE	
--		B.location_id *= A.location_id	AND	
--		Convert(Datetime,  @PUDate) BETWEEN A.Valid_From AND
--			ISNULL(A.Valid_To, @dLastDatetime)
--		AND	A.Vehicle_Class_Code = @VehClassCode	AND	
			B.Hub_Id = (	SELECT 	Hub_Id
				FROM 	Location
				WHERE	Location_id = Convert(SmallInt, @PULocId) )
	AND	B.Delete_Flag = 0
	AND	B.Rental_Location = 1
	ORDER BY B.Location

	RETURN @@ROWCOUNT
GO
