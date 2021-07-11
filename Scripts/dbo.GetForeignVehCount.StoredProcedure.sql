USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetForeignVehCount]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetForeignVehCount    Script Date: 2/18/99 12:12:08 PM ******/
/****** Object:  Stored Procedure dbo.GetForeignVehCount    Script Date: 2/16/99 2:05:41 PM ******/
/****** Object:  Stored Procedure dbo.GetForeignVehCount    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetForeignVehCount    Script Date: 11/23/98 3:55:33 PM ******/
/*	PURPOSE:		To retrieve the count of foreign vehicle for the given parameters.
     	MOD HISTORY:
     	Name	Date		Comments
  	NP	Apr 19 2000	Added a condition to include non-deleted vehicle only

*/
CREATE PROCEDURE [dbo].[GetForeignVehCount]
	@ForeignVehicleUnitNumber	VarChar(20),
	@OwningCompanyID		VarChar(10)
AS
	SELECT	Count(*)
	FROM		Vehicle
	WHERE	Foreign_Vehicle_Unit_Number	= @ForeignVehicleUnitNumber
	AND		Owning_Company_ID		= CONVERT(SmallInt, @OwningCompanyID)
	AND		Deleted = 0
	
RETURN 1












GO
