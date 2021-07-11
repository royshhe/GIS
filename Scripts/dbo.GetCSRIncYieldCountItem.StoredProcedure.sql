USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCSRIncYieldCountItem]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
--------------------------------------------------------------------------------------------------------------------
--	Programmer:	Vivian Leung
--	Date:		30 Apr 2002
--	Details		Get count items for CSR Incremental Yield reportl
--	Modification:		Name:		Date:		Detail:
--
---------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[GetCSRIncYieldCountItem]
	@PULocId Varchar(10) =null,
	@VehicleType Varchar(10) = 'Car'
	
AS

DECLARE @iPULocId SmallInt

SELECT	@iPULocId = Convert(SmallInt, NULLIF(@PULocId,""))


if @VehicleType = 'Car'
Begin 

if @iPULocId is not null and  @iPULocId<>0
	BEGIN
		SELECT		
		c.CSR_Name,
		c.Contract_In,
		c.Rental_Days,
		c.FPOCount as FPO,
		c.WalkUpCount as Walk_up,
		c.AdditionalDriverChargeCount as Additional_Driver_Charge,
		c.UpsellCount as Up_sell,
		c.AllSeatsCount as All_Seats,
		c.DriverUnderAgeCount as Driver_Under_Age,
		c.AllLevelLDWCount as All_Level_LDW,
		c.PAICount as PAI,
		c.PECCount as PEC,
		c.SkiRackCount as Ski_Rack,
		Total_Revenue = (c.FPO + c.Additional_Driver_Charge + c.Up_sell + c.All_Seats + c.Driver_Under_Age
				+ c.All_Level_LDW + c.PAI + c.PEC + c.Ski_Rack),
		Incremental_Yield = 
			case 
				when c.Rental_Days>0 then  
					Round(((c.FPO + c.Additional_Driver_Charge + c.Up_sell + c.All_Seats + c.Driver_Under_Age+ c.All_Level_LDW + c.PAI + c.PEC + c.Ski_Rack) / c.Rental_Days), 2)
                                        	else
					Round((c.FPO + c.Additional_Driver_Charge + c.Up_sell + c.All_Seats + c.Driver_Under_Age+ c.All_Level_LDW + c.PAI + c.PEC + c.Ski_Rack) , 2)
			end 
		FROM	CSRIncYield c
		WHERE	c.Pick_Up_Location_ID = @iPULocId
				and c.Vehicle_Type_ID = @VehicleType
	END 
ELSE
	BEGIN
		SELECT		
		c.CSR_Name,
		c.Contract_In,
		c.Rental_Days,
		c.FPOCount as FPO,
		c.WalkUpCount as Walk_up,
		c.AdditionalDriverChargeCount as Additional_Driver_Charge,
		c.UpsellCount as Up_sell,
		c.AllSeatsCount as All_Seats,
		c.DriverUnderAgeCount as Driver_Under_Age,
		c.AllLevelLDWCount as All_Level_LDW,
		c.PAICount as PAI,
		c.PECCount as PEC,
		c.SkiRackCount as Ski_Rack,
		Total_Revenue = (c.FPO + c.Additional_Driver_Charge + c.Up_sell + c.All_Seats + c.Driver_Under_Age
				+ c.All_Level_LDW + c.PAI + c.PEC + c.Ski_Rack),
                                                            
		Incremental_Yield = 
			case 
			when c.Rental_Days>0 then  
				Round(((c.FPO + c.Additional_Driver_Charge + c.Up_sell + c.All_Seats + c.Driver_Under_Age + c.All_Level_LDW + c.PAI + c.PEC + c.Ski_Rack) / c.Rental_Days), 2)
                                        else
				Round((c.FPO + c.Additional_Driver_Charge + c.Up_sell + c.All_Seats + c.Driver_Under_Age + c.All_Level_LDW + c.PAI + c.PEC + c.Ski_Rack) , 2)
			END 
		FROM	CSRIncYield c
		where c.Vehicle_Type_ID = @VehicleType
	END 
	
End

else

if @VehicleType = 'Truck'
begin
	if @iPULocId is not null and  @iPULocId<>0
		BEGIN
			SELECT		
			c.CSR_Name,
			c.Contract_In,
			c.Rental_Days,
			c.FPOCount as FPO,
			c.WalkUpCount as Walk_up,
			c.AdditionalDriverChargeCount as Additional_Driver_Charge,
			c.UpsellCount as Up_sell,
			c.AllSeatsCount as All_Seats,
			c.DriverUnderAgeCount as Driver_Under_Age,
			c.AllLevelLDWCount as All_Level_LDW,
			c.PAICount as PAI,
			c.PECCount as PEC,
			c.AllDollyCount as All_Dolly,
			c.AllGatesCount as All_Gates,
			c.BlanketCount as Blanket,
			Total_Revenue = (c.FPO + c.Additional_Driver_Charge + c.Up_sell + c.All_Seats + c.Driver_Under_Age
					+ c.All_Level_LDW + c.PAI + c.PEC + c.All_Dolly + c.All_Gates + c.Blanket),
			Incremental_Yield = 
				case 
					when c.Rental_Days>0 then  
						Round(((c.FPO + c.Additional_Driver_Charge + c.Up_sell + c.All_Seats + c.Driver_Under_Age + c.All_Level_LDW + c.PAI + c.PEC + c.All_Dolly + c.All_Gates + c.Blanket) / c.Rental_Days), 2)
	                                        	else
						Round((c.FPO + c.Additional_Driver_Charge + c.Up_sell + c.All_Seats + c.Driver_Under_Age + c.All_Level_LDW + c.PAI + c.PEC + c.All_Dolly + c.All_Gates + c.Blanket) , 2)
				end 
			FROM	CSRIncYield c
			WHERE	c.Pick_Up_Location_ID = @iPULocId
					and c.Vehicle_Type_ID = @VehicleType
		END 
	ELSE
		BEGIN
			SELECT		
			c.CSR_Name,
			c.Contract_In,
			c.Rental_Days,
			c.FPOCount as FPO,
			c.WalkUpCount as Walk_up,
			c.AdditionalDriverChargeCount as Additional_Driver_Charge,
			c.UpsellCount as Up_sell,
			c.AllSeatsCount as All_Seats,
			c.DriverUnderAgeCount as Driver_Under_Age,
			c.AllLevelLDWCount as All_Level_LDW,
			c.PAICount as PAI,
			c.PECCount as PEC,
			c.AllDollyCount as All_Dolly,
			c.AllGatesCount as All_Gates,
			c.BlanketCount as Blanket,
			Total_Revenue = (c.FPO + c.Additional_Driver_Charge + c.Up_sell + c.All_Seats + c.Driver_Under_Age
					+ c.All_Level_LDW + c.PAI + c.PEC + c.All_Dolly + c.All_Gates + c.Blanket),
			Incremental_Yield = 
				case 
					when c.Rental_Days>0 then  
					Round(((c.FPO + c.Additional_Driver_Charge + c.Up_sell + c.All_Seats + c.Driver_Under_Age + c.All_Level_LDW + c.PAI + c.PEC + c.All_Dolly + c.All_Gates + c.Blanket) / c.Rental_Days), 2)
				                else
						Round((c.FPO + c.Additional_Driver_Charge + c.Up_sell + c.All_Seats + c.Driver_Under_Age + c.All_Level_LDW + c.PAI + c.PEC + c.All_Dolly + c.All_Gates + c.Blanket) , 2)
						end 
			FROM	CSRIncYield c
			where 	c.Vehicle_Type_ID = @VehicleType
	END 	
	
End

RETURN @@ROWCOUNT







GO
