USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[FA_GetPurchaseAgreement]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--FA_GetPurchaseAgreement '167938', '2009','1' 
--select  [dbo].[GetKMCharge] ('2009', '1', 'Ford',1,35000)


/*
PURPOSE: To search and retrieve a vehicle by the given params
MOD HISTORY:
Name	Date        	Comments
CPY	Jan 5 2000	Return vehicle rental status code instead of the rental status desc.
Sli 	Aug 31 2005	Add MVA Number for compatibility level 80
*/
CREATE PROCEDURE [dbo].[FA_GetPurchaseAgreement]
	@UnitNumber		VarChar(10),
	@AgreementYear		VarChar(10),	
	@PurchaseCycle		VarChar(10)
	
AS
	if  ISNUMERIC (@UnitNumber)=1

			SELECT    --V.Year_Of_Agreement, V.Purchase_Cycle, L.Value,V.Program,V.Current_KM,  
								PA.Monthly_Dep_Amount, 
								PA.Monthly_Dep_Rate, 
								PA.Vehicle_Price, 
								PA.PDI_Amount, 
								CONVERT(VarChar(1), PA.Price_Include_PDI), 
								PA.PDI_Performer, 
								PA.Dep_Type, 
								PA.Volume_Incentive, 
								PA.Incentive_from, 
								PA.Rebate, 
								PA.Rebate_From, 
								PA.Days_InService_Start, 
								PA.Days_InService_End, 
								PA.Allowance_days, 
								PA.Inservice_Days, 
								PA.Mark_Down, 
								PA.Exercise_Tax, 
								PA.Battery_Levy,
										 
								(Case When V.Cap_Cost is not null then V.Cap_Cost
										  When dbo.FA_Repurchase_Eligibility.Capitalized is not null And V.Program = 1 then dbo.FA_Repurchase_Eligibility.Capitalized
										  Else V.Vehicle_Cost
								End) Cap_Cost, 							
								-- default KM Reading
								(Case When V.KM_Reading is Not Null  Then V.KM_Reading 
										Else V.Current_KM
								End) KM_Reading,
								--Default KM Charge 
								(Case When KM_Charge is Not Null Then KM_Charge
										 Else
												(Case When V.KM_Reading is Not Null Then [dbo].[GetKMCharge] (	@AgreementYear, @PurchaseCycle, L.Value,V.Program, KM_Reading )
														 Else [dbo].[GetKMCharge] (@AgreementYear,@PurchaseCycle, L.Value,V.Program,V.Current_KM)
												End)
								End) KM_Charge, 
								
								(Case
										When V.Program = 1  then CONVERT(VarChar(11),dbo.FA_Repurchase_Eligibility.ISD,13) 
										Else ''
								End) as ManufacturerISD,
								CONVERT(VarChar(11),  dbo.VehicleISD(V.Unit_Number),13) GISISD,
								--CONVERT(VarChar(11), V.ISD, 13) ISD,
								(Case 
											When V.OSD is Not Null then	CONVERT(VarChar(11), V.OSD, 13)
											Else CONVERT(VarChar(11),VPFD.Effective_On ,13)
								End)	 OSD,

								CONVERT(VarChar(11), VSD.Effective_On,13) as Sold_Date

--								,
--								@AgreementYear, 
--								@PurchaseCycle, 
--								L.Value,
--								V.Program,
--								(Case When V.KM_Reading is Not Null  Then V.KM_Reading 	Else V.Current_KM	End) as KM

             FROM         dbo.Vehicle  V 
				INNER JOIN   dbo.Vehicle_Model_Year VMY 
						ON V.Vehicle_Model_ID = VMY.Vehicle_Model_ID 
			LEFT OUTER JOIN
                      dbo.FA_Purchase_Agreement  PA  ON PA.Vehicle_Model_ID = V.Vehicle_Model_ID AND PA.Program = V.Program
					And    PA.Agreement_Year=@AgreementYear and  PA.Purchase_Cycle=@PurchaseCycle
			LEFT OUTER JOIN
								  dbo.FA_Repurchase_Eligibility ON V.Serial_Number = dbo.FA_Repurchase_Eligibility.Vin							
			LEFT OUTER JOIN     dbo.Lookup_Table L 
					ON VMY.Manufacturer_ID = CONVERT(SmallInt, L.Code)   AND	L.Category		='Manufacturer'
			LEFT OUTER JOIN
						 (Select Unit_number, Vehicle_Status, max(Effective_On)  Effective_On from Vehicle_History 
						 Group by Unit_number, Vehicle_Status)  VPFD 
						 ON V.Unit_Number = VPFD.Unit_Number AND (V.Program = 0 AND VPFD.Vehicle_Status = 'f' OR
								  V.Program = 1 AND VPFD.Vehicle_Status = 'g')
			LEFT OUTER JOIN
						 (Select Unit_number, Vehicle_Status, max(Effective_On)  Effective_On from Vehicle_History 
						 Group by Unit_number, Vehicle_Status)  VSD 
						 ON V.Unit_Number = VSD.Unit_Number AND (V.Program = 0 AND VSD.Vehicle_Status = 'i' OR
								  V.Program = 1 AND VSD.Vehicle_Status = 'g') 

			Where V.Unit_number= CONVERT(Int, @UnitNumber) 



--select * from lookup_table where category like '%manuf%'
	
GO
