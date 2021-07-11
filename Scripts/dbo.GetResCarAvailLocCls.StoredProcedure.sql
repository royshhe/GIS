USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResCarAvailLocCls]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[GetResCarAvailLocCls]
	@PULocId Varchar(5),
	@PUDate Varchar(24)
AS
DECLARE @dLastDatetime Datetime
	IF @PULocId = ""	SELECT @PULocId = NULL
	IF @PUDate = ""		SELECT @PUDate = NULL
	SELECT @dLastDatetime = Convert(Datetime, '31 Dec 2078 23:59')
	SELECT	V.Vehicle_Class_Name, L.Vehicle_Class_Code
	FROM	Vehicle_Class V 
	Left Join  Location_Vehicle_Class L
	On V.vehicle_class_code = L.vehicle_class_code And
		Convert(Datetime, @PUDate) BETWEEN L.Valid_From AND
			ISNULL(L.Valid_To, @dLastDatetime)
	AND	L.Location_ID = Convert(SmallInt, @PULocId)

	WHERE	--V.vehicle_class_code *= L.vehicle_class_code	AND	
--		Convert(Datetime, @PUDate) BETWEEN L.Valid_From AND
--			ISNULL(L.Valid_To, @dLastDatetime)
--	AND	L.Location_ID = Convert(SmallInt, @PULocId)	 AND	
	V.Vehicle_Type_ID = "Car"
	RETURN @@ROWCOUNT
GO
