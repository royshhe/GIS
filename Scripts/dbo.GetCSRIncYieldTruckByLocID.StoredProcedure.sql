USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCSRIncYieldTruckByLocID]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.GetCSRIncYieldTruckByLocID    Script Date: 7/15/2002 1:55:50 PM ******/


--------------------------------------------------------------------------------------------------------------------
--	Programmer:	Vivian Leung
--	Date:		15 Feb 2002
--	Details		Create scheduled CSR Incremental Yield Truck report for exporting to Excel
--	Modification:		Name:		Date:		Detail:
--
---------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[GetCSRIncYieldTruckByLocID]
	@PULocId Varchar(10) =null
AS

DECLARE @iPULocId SmallInt

SELECT	@iPULocId = Convert(SmallInt, NULLIF(@PULocId,""))
if @iPULocId is not null and  @iPULocId<>0
	BEGIN
		SELECT		
		CSR_Name,
		Contract_In,
		Rental_Days,
		FPO,
		--FPOCount as FPO,
		Walk_up,
		Additional_Driver_Charge,
		Up_sell,
		All_Seats,
		Driver_Under_Age,
		All_Level_LDW,
		PAI,
		PEC,
		All_Dolly,
		All_Gates,
		Blanket,
		Total_Revenue = (Additional_Driver_Charge + Up_sell + All_Seats + Driver_Under_Age
				+ All_Level_LDW + PAI + PEC + All_Dolly + All_Gates + Blanket),
		Incremental_Yield = 
			case 
				when Rental_Days>0 then  
					Round((( Additional_Driver_Charge + Up_sell + All_Seats + Driver_Under_Age+ All_Level_LDW + PAI + PEC + All_Dolly + All_Gates + Blanket) / Rental_Days), 2)
                                        	else
					Round(( Additional_Driver_Charge + Up_sell + All_Seats + Driver_Under_Age+ All_Level_LDW + PAI + PEC + All_Dolly + All_Gates + Blanket) , 2)
			end 
		FROM	CSRIncYield
		WHERE	Pick_Up_Location_ID = @iPULocId
				and Vehicle_Type_ID = 'Truck'
	END 
ELSE
	BEGIN
		SELECT		
		CSR_Name,
		Contract_In,
		Rental_Days,
		FPO,
		--FPOCount as FPO,
		Walk_up,
		Additional_Driver_Charge,
		Up_sell,
		All_Seats,
		Driver_Under_Age,
		All_Level_LDW,
		PAI,
		PEC,
		All_Dolly,
		All_Gates,
		Blanket,
		Total_Revenue = (Additional_Driver_Charge + Up_sell + All_Seats + Driver_Under_Age
				+ All_Level_LDW + PAI + PEC + All_Dolly + All_Gates + Blanket),
                                                            
		Incremental_Yield = 
			case 
			when Rental_Days>0 then  
				Round((( Additional_Driver_Charge + Up_sell + All_Seats + Driver_Under_Age+ All_Level_LDW + PAI + PEC + All_Dolly + All_Gates + Blanket) / Rental_Days), 2)
                                        else
				Round(( Additional_Driver_Charge + Up_sell + All_Seats + Driver_Under_Age+ All_Level_LDW + PAI + PEC + All_Dolly + All_Gates + Blanket) , 2)
			END 
		FROM	CSRIncYield
		where 	Vehicle_Type_ID = 'Truck'
	END 	

RETURN @@ROWCOUNT










GO
