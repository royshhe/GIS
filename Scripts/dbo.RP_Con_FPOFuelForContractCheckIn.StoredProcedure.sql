USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_Con_FPOFuelForContractCheckIn]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----------------------------------------------------------------------------------------------------------------------------------------
--  Programmer :   Roy He
--  Date :         Jun 22, 2002
--  Details: 	   FPO Fuel Adhoc Reports
----------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[RP_Con_FPOFuelForContractCheckIn]-- '2016/08/10'
	@RBRDate datetime  =  '2002/02/02'
AS

SELECT
	RBR_Date, 	
        Location.Location,
	Contract_number,
	Unit_number,   	
        Actual_Check_In,	
	SUM(CASE	WHEN Charge_Type = 14
			THEN Amount
			ELSE 0
		END) 							as GSO,
	SUM(CASE	WHEN Charge_Type = 18
			THEN Amount
			ELSE 0
		END) 							as Fuel
	
FROM 	RP_Con_Business_Transaction_Detail inner join Location on Location.Location_id=Drop_Off_Location_ID
where RBR_Date =@RBRDate and Charge_Type in ('14','18')

GROUP BY 	RBR_Date,
		Contract_number,
		Unit_number,
		Actual_Check_In,
		Location.Location
		










GO
