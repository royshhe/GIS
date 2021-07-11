USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehDropShipDate]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO




CREATE PROCEDURE [dbo].[GetVehDropShipDate] 
	@UnitNum Varchar(11)
AS
DECLARE	@iUnitNum Int

	SELECT	@iUnitNum = Cast(NULLIF(@UnitNum,'') as Int)

	SELECT	Drop_ShipDate 
	FROM	Vehicle
	WHERE	Unit_Number = @iUnitNum

	RETURN @@ROWCOUNT






GO
