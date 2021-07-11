USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetRateVehClassAllowed]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetRateVehClassAllowed    Script Date: 2/18/99 12:12:03 PM ******/
/****** Object:  Stored Procedure dbo.GetRateVehClassAllowed    Script Date: 2/16/99 2:05:42 PM ******/
/* Oct 29 - Moved data conversion code with NULLIF out of the where clause */
CREATE PROCEDURE [dbo].[GetRateVehClassAllowed]
	@RateId Varchar(10),
	@VehClassCode Varchar(1)
AS
	DECLARE	@nRateId Integer
	SELECT	@nRateId = Convert(Int, NULLIF(@RateId,''))
	SELECT	@VehClassCode = NULLIF(@VehClassCode,'')

	SELECT	Count(*)
	FROM	Rate_Vehicle_Class
	WHERE	Rate_ID = @nRateId
	AND	Vehicle_Class_Code = @VehClassCode
	AND	Termination_Date = '31 DEC 2078 23:59'
	RETURN @@ROWCOUNT













GO
