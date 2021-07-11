USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetXCtrctVehicleByCtrctNumber]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--------------------------------------------------------------------------------------------------------------------
--	Programmer:	Roy He
--	Date:		2003-12-19
--	Details		ccrs Export
--	Modification:		Name:		Date:		Detail:
--
---------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[GetXCtrctVehicleByCtrctNumber] --'2003-11-01', '2003-11-01'
(
	@CtrctNumber varchar(20)
)
AS
SELECT 	
	*
FROM 	ViewXContractVehicle
WHERE	Contract_number=@CtrctNumber


GO
