USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[FA_CreateVehiclePurchaseAR]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[FA_CreateVehiclePurchaseAR]   -- '2009-07-02', '2009-07-02'
		@paramStartDate Varchar(24),
		@paramEndDate Varchar(24)
As


Declare @dProcessStartDate Datetime
Declare @dProcessEndDate Datetime
Select @dProcessStartDate=Convert(Datetime, NULLIF(@paramStartDate,''))
Select @dProcessEndDate=Convert(Datetime, NULLIF(@paramEndDate,''))


 
--Create Vehicle Purchase AR Transaction for Generating AR Invoice and GL Entry
Select * Into  #ARTransaction from
(
SELECT    V.Unit_Number,  
				  V.Purchase_Process_Date as RBR_Date,
				 	(	
				  Case When V.ISD is not Null Then V.ISD 
				           When V.ISD is  Null  And dbo.UpdatedVehicleISD(V.Unit_Number) is Not Null Then dbo.UpdatedVehicleISD(V.Unit_Number)
                           Else Convert(Varchar, getdate(), 106)
				  End)  as DATEINVC,  
				  dbo.FA_Dealer.Customer_Code as Customer_Account, 
				  V.PDI_Amount as Amount , 
				  Getdate() as Transaction_Date,
				 'FA Purchase AR' As Transaction_Type,	
				 'PDI Revenue' as RevenueItem,
				 'PDI  Receivable Clearing Account' As ClearingAccount,
				 'PDI - ' +V.Serial_Number as INVCDESC,
				 V.Vehicle_Class_Code,
				 V.Program,
--				 'V' + RIGHT(CONVERT(varchar, V.Unit_Number + 10000000000), 10) +'P' AS  Doc_Ctrl_Num_Base, 
			  	 'PD' AS Document_Type, 
				  'I' as Doc_Ctrl_Num_Type, 
				 1 as Doc_Ctrl_Num_Seq, 
				 NULL as Apply_To_Doc_Ctrl_Num
FROM         dbo.Vehicle AS V 
--                         INNER JOIN
--                      dbo.FA_Inservcie_Date_vw AS FAISD ON V.Unit_Number = FAISD.Unit_Number 
                           INNER JOIN
                      dbo.FA_Dealer ON V.Dealer_ID = dbo.FA_Dealer.Dealer_Code  

WHERE     (V.PDI_Included_In_Price = 1) AND (V.PDI_Performed_By = 'Own') AND (V.PDI_Amount > 0)
 				 AND (V.Purchase_Process_Date between @dProcessStartDate and @dProcessEndDate)
                -- And V.ISD is Not Null

Union
-- PDI GST
SELECT    V.Unit_Number,  
				  V.Purchase_Process_Date as RBR_Date,
					(	
				  Case When V.ISD is not Null Then V.ISD 
				           When V.ISD is  Null  And dbo.UpdatedVehicleISD(V.Unit_Number) is Not Null Then dbo.UpdatedVehicleISD(V.Unit_Number)
                           Else Convert(Varchar, getdate(), 106)
				  End)  as DATEINVC,
				  dbo.FA_Dealer.Customer_Code as Customer_Account, 
				  Round(V.PDI_Amount  *(Tax_Rate/100),2)as Amount , 
				  Getdate() as Transaction_Date,
				 'FA Purchase AR' As Transaction_Type,	
				 'Sales GST' as RevenueItem,
				 'PDI  Receivable Clearing Account' As ClearingAccount,
				 'PDI - ' +V.Serial_Number as INVCDESC,
				 V.Vehicle_Class_Code,
				 V.Program,
--				 'V' + RIGHT(CONVERT(varchar, V.Unit_Number + 10000000000), 10) +'P' AS  Doc_Ctrl_Num_Base, 
			  	 'PD' AS Document_Type, 
				  'I' as Doc_Ctrl_Num_Type, 
				 1 as Doc_Ctrl_Num_Seq, 
				 NULL as Apply_To_Doc_Ctrl_Num
FROM         dbo.Vehicle AS V 
--                         INNER JOIN
--                      dbo.FA_Inservcie_Date_vw AS FAISD ON V.Unit_Number = FAISD.Unit_Number 
                           INNER JOIN
                      dbo.FA_Dealer ON V.Dealer_ID = dbo.FA_Dealer.Dealer_Code  
						    INNER JOIN
                      dbo.Tax_Rate AS TaxRate  ON   V.Purchase_Process_Date  between TaxRate.Valid_From And  TaxRate.Valid_To And (Tax_Type='GST' or Tax_Type='HST')


WHERE     (V.PDI_Included_In_Price = 1) AND (V.PDI_Performed_By = 'Own') AND (V.PDI_Amount > 0)
 				 AND (V.Purchase_Process_Date between @dProcessStartDate and @dProcessEndDate)
                -- And V.ISD is Not Null


Union

-- Incentive from coporate
SELECT     V.Unit_Number, 
					V.Purchase_Process_Date AS RBR_Date, 
				   (	
				    Case When V.ISD is not Null Then V.ISD 
				           When V.ISD is  Null  And dbo.UpdatedVehicleISD(V.Unit_Number) is Not Null Then dbo.UpdatedVehicleISD(V.Unit_Number)
                           Else Convert(Varchar, getdate(), 106)
				    End)  as DATEINVC,
					AllowanceSource.Customer_Code,
					V.Volume_Incentive as Amount,
					GETDATE() AS Transaction_Date, 
					 'FA Purchase AR'AS Transaction_Type,
					'Volume Incentive' as RevenueItem,
					'Volume Incentive Clearing Account' As ClearingAccount,
					'Incentive - ' +V.Serial_Number as INVCDESC,
					V.Vehicle_Class_Code,
					V.Program,					
--					'V' + RIGHT(CONVERT(varchar,  V.Unit_Number + 10000000000), 10) + 'V' AS Doc_Ctrl_Num_Base, 
					'VI' as  Document_Type,
					'I' AS Doc_Ctrl_Num_Type, 
					1 AS Doc_Ctrl_Num_Seq, 
					NULL AS Apply_To_Doc_Ctrl_Num
                    
FROM          dbo.FA_Market_Allowance_Source AS AllowanceSource INNER JOIN
                      dbo.Vehicle AS V 
--              INNER JOIN
--                      dbo.FA_Inservcie_Date_vw AS FAISD ON V.Unit_Number = FAISD.Unit_Number 
                ON AllowanceSource.Source_Type = V.Incentive_Received_From 
--					Inner Join Tax_Rate 
--									On V.Purchase_Process_Date  between Tax_Rate.Valid_From And  Tax_Rate.Valid_To And Tax_Type='GST'
WHERE     (AllowanceSource.Source_Type='C')  AND (V.Volume_Incentive> 0)
				 --AND (FAISD.ISD between @dProcessStartDate and @dProcessEndDate)
				 AND (V.Purchase_Process_Date between @dProcessStartDate and @dProcessEndDate)
--				-- And V.ISD is Not Null

Union 
-- Incentive GST
SELECT     V.Unit_Number, 
					V.Purchase_Process_Date AS RBR_Date, 
					 	(	
					  Case When V.ISD is not Null Then V.ISD 
							   When V.ISD is  Null  And dbo.UpdatedVehicleISD(V.Unit_Number) is Not Null Then dbo.UpdatedVehicleISD(V.Unit_Number)
							   Else Convert(Varchar, getdate(), 106)
					  End)  as DATEINVC,
					AllowanceSource.Customer_Code,				 
					Round(V.Volume_Incentive  *(Tax_Rate/100),2)as Amount , 
					GETDATE() AS Transaction_Date, 
					 'FA Purchase AR'AS Transaction_Type,
					'Sales GST' as RevenueItem,
					'Volume Incentive Clearing Account' As ClearingAccount,
					'Incentive - ' +V.Serial_Number as INVCDESC,
					V.Vehicle_Class_Code,
					V.Program,					
--					'V' + RIGHT(CONVERT(varchar,  V.Unit_Number + 10000000000), 10) + 'V' AS Doc_Ctrl_Num_Base, 
					'VI' as  Document_Type,
					'I' AS Doc_Ctrl_Num_Type, 
					1 AS Doc_Ctrl_Num_Seq, 
					NULL AS Apply_To_Doc_Ctrl_Num
                    
FROM          dbo.FA_Market_Allowance_Source AS AllowanceSource INNER JOIN
                      dbo.Vehicle AS V 
--              INNER JOIN
--                      dbo.FA_Inservcie_Date_vw AS FAISD ON V.Unit_Number = FAISD.Unit_Number 
                ON AllowanceSource.Source_Type = V.Incentive_Received_From 
					Inner Join Tax_Rate 
									On V.Purchase_Process_Date  between Tax_Rate.Valid_From And  Tax_Rate.Valid_To And (Tax_Type='GST' or Tax_Type='HST')
WHERE     (AllowanceSource.Source_Type='C')  AND (V.Volume_Incentive> 0)
				 --AND (FAISD.ISD between @dProcessStartDate and @dProcessEndDate)
				 AND (V.Purchase_Process_Date between @dProcessStartDate and @dProcessEndDate)
--				And V.ISD is Not Null

Union
-- Incentive from Dealer
SELECT     V.Unit_Number, 
					V.Purchase_Process_Date AS RBR_Date, 
						(	
					  Case When V.ISD is not Null Then V.ISD 
							   When V.ISD is  Null  And dbo.UpdatedVehicleISD(V.Unit_Number) is Not Null Then dbo.UpdatedVehicleISD(V.Unit_Number)
							   Else Convert(Varchar, getdate(), 106)
					  End)  as DATEINVC,
					AllowanceSource.Customer_Code, 
					V.Volume_Incentive AS Amount, 
					GETDATE() AS Transaction_Date, 
					 'FA Purchase AR'   AS Transaction_Type, 
					'Volume Incentive' as RevenueItem,
					'Volume Incentive Clearing Account' As ClearingAccount,
					'Incentive - ' +V.Serial_Number as INVCDESC,
					V.Vehicle_Class_Code,
					V.Program,
					--'V' + RIGHT(CONVERT(varchar, V.Unit_Number + 10000000000), 10) + 'V' AS Doc_Ctrl_Num_Base, 
					'VI' as  Document_Type,
					 'I' AS Doc_Ctrl_Num_Type, 
                      1 AS Doc_Ctrl_Num_Seq, 
					 NULL AS Apply_To_Doc_Ctrl_Num
				
					
FROM         dbo.FA_Market_Allowance_Source AS AllowanceSource INNER JOIN
                      dbo.Vehicle AS V 
--					  INNER JOIN
--                      dbo.FA_Inservcie_Date_vw AS FAISD ON V.Unit_Number = FAISD.Unit_Number 
					ON AllowanceSource.Source_Type = V.Incentive_Received_From AND 
                      AllowanceSource.Source = V.Dealer_ID 

WHERE     (AllowanceSource.Source_Type = 'D' ) AND (V.Volume_Incentive > 0)
--				AND (FAISD.ISD between @dProcessStartDate and @dProcessEndDate)
				AND (V.Purchase_Process_Date between @dProcessStartDate and @dProcessEndDate)
--				And V.ISD is Not Null


Union
-- Incentive from Dealer  GST
SELECT     V.Unit_Number, 
					V.Purchase_Process_Date AS RBR_Date, 
					(	
					  Case When V.ISD is not Null Then V.ISD 
							   When V.ISD is  Null  And dbo.UpdatedVehicleISD(V.Unit_Number) is Not Null Then dbo.UpdatedVehicleISD(V.Unit_Number)
							   Else Convert(Varchar, getdate(), 106)
					  End)  as DATEINVC,
					AllowanceSource.Customer_Code, 
					Round(V.Volume_Incentive  *(Tax_Rate/100),2)as Amount , 
					GETDATE() AS Transaction_Date, 
					 'FA Purchase AR'   AS Transaction_Type, 
					'Sales GST' as RevenueItem,
					'Volume Incentive Clearing Account' As ClearingAccount,
					'Incentive - ' +V.Serial_Number as INVCDESC,
					V.Vehicle_Class_Code,
					V.Program,
					--'V' + RIGHT(CONVERT(varchar, V.Unit_Number + 10000000000), 10) + 'V' AS Doc_Ctrl_Num_Base, 
					'VI' as  Document_Type,
					 'I' AS Doc_Ctrl_Num_Type, 
                      1 AS Doc_Ctrl_Num_Seq, 
					 NULL AS Apply_To_Doc_Ctrl_Num
				
					
FROM         dbo.FA_Market_Allowance_Source AS AllowanceSource
					 INNER JOIN
                      dbo.Vehicle AS V 
--					  INNER JOIN
--                      dbo.FA_Inservcie_Date_vw AS FAISD ON V.Unit_Number = FAISD.Unit_Number 
					ON AllowanceSource.Source_Type = V.Incentive_Received_From AND 
                      AllowanceSource.Source = V.Dealer_ID 
				    INNER JOIN
                      dbo.Tax_Rate AS TaxRate  ON   V.Purchase_Process_Date  between TaxRate.Valid_From And  TaxRate.Valid_To And (Tax_Type='GST' or Tax_Type='HST')


WHERE     (AllowanceSource.Source_Type = 'D' ) AND (V.Volume_Incentive > 0)
--				AND (FAISD.ISD between @dProcessStartDate and @dProcessEndDate)
				AND (V.Purchase_Process_Date between @dProcessStartDate and @dProcessEndDate)
--				And V.ISD is Not Null



Union

-- Incentive from Manufacturer
SELECT     V.Unit_Number, 
					V.Purchase_Process_Date AS RBR_Date, 
					(	
					  Case When V.ISD is not Null Then V.ISD 
							   When V.ISD is  Null  And dbo.UpdatedVehicleISD(V.Unit_Number) is Not Null Then dbo.UpdatedVehicleISD(V.Unit_Number)
							   Else Convert(Varchar, getdate(), 106)
					  End)  as DATEINVC,
					AllowanceSource.Customer_Code, 
					V.Volume_Incentive AS Amount, 
					GETDATE() AS Transaction_Date, 
					  'FA Purchase AR' AS Transaction_Type, 
					'Volume Incentive' as RevenueItem,
					'Volume Incentive Clearing Account' As ClearingAccount,
				    'Incentive - ' +V.Serial_Number as INVCDESC,
					V.Vehicle_Class_Code,
					V.Program,
					--'V' + RIGHT(CONVERT(varchar, V.Unit_Number + 10000000000), 10) + 'V' AS Doc_Ctrl_Num_Base, 
					'VI' as  Document_Type,
					 'I' AS Doc_Ctrl_Num_Type, 
                      1 AS Doc_Ctrl_Num_Seq, 
					 NULL AS Apply_To_Doc_Ctrl_Num					

FROM         dbo.FA_Market_Allowance_Source AllowanceSource INNER JOIN
                      dbo.Vehicle V 
--					INNER JOIN
--                      dbo.FA_Inservcie_Date_vw FAISD ON V.Unit_Number = FAISD.Unit_Number 
					ON 
                      AllowanceSource.Source_Type = V.Incentive_Received_From INNER JOIN
                      dbo.Vehicle_Model_Year VMY ON V.Vehicle_Model_ID = VMY.Vehicle_Model_ID AND 
                      AllowanceSource.Source = VMY.Manufacturer_ID 
WHERE   (AllowanceSource.Source_Type = 'M') AND (V.Volume_Incentive > 0)
--				 AND (FAISD.ISD between @dProcessStartDate and @dProcessEndDate)
			AND (V.Purchase_Process_Date between @dProcessStartDate and @dProcessEndDate)
--            And V.ISD is Not Null


Union

-- Incentive from Manufacturer GST
SELECT     V.Unit_Number, 
					V.Purchase_Process_Date AS RBR_Date, 
					(	
				    Case When V.ISD is not Null Then V.ISD 
				           When V.ISD is  Null  And dbo.UpdatedVehicleISD(V.Unit_Number) is Not Null Then dbo.UpdatedVehicleISD(V.Unit_Number)
                           Else Convert(Varchar, getdate(), 106)
				    End)  as DATEINVC,
					AllowanceSource.Customer_Code, 
					Round(V.Volume_Incentive  *(Tax_Rate/100),2)as Amount , 
					GETDATE() AS Transaction_Date, 
					  'FA Purchase AR' AS Transaction_Type, 
					'Sales GST' as RevenueItem,
					'Volume Incentive Clearing Account' As ClearingAccount,
				    'Incentive - ' +V.Serial_Number as INVCDESC,
					V.Vehicle_Class_Code,
					V.Program,
					--'V' + RIGHT(CONVERT(varchar, V.Unit_Number + 10000000000), 10) + 'V' AS Doc_Ctrl_Num_Base, 
					'VI' as  Document_Type,
					 'I' AS Doc_Ctrl_Num_Type, 
                      1 AS Doc_Ctrl_Num_Seq, 
					 NULL AS Apply_To_Doc_Ctrl_Num					

FROM         dbo.FA_Market_Allowance_Source AllowanceSource INNER JOIN
                      dbo.Vehicle V 
--					INNER JOIN
--                      dbo.FA_Inservcie_Date_vw FAISD ON V.Unit_Number = FAISD.Unit_Number 
					ON 
                      AllowanceSource.Source_Type = V.Incentive_Received_From INNER JOIN
                      dbo.Vehicle_Model_Year VMY ON V.Vehicle_Model_ID = VMY.Vehicle_Model_ID AND 
                      AllowanceSource.Source = VMY.Manufacturer_ID 
				   INNER JOIN
                      dbo.Tax_Rate AS TaxRate  ON   V.Purchase_Process_Date  between TaxRate.Valid_From And  TaxRate.Valid_To And (Tax_Type='GST' or Tax_Type='HST')


WHERE   (AllowanceSource.Source_Type = 'M') AND (V.Volume_Incentive > 0)
--				 AND (FAISD.ISD between @dProcessStartDate and @dProcessEndDate)
			AND (V.Purchase_Process_Date between @dProcessStartDate and @dProcessEndDate)
--            And V.ISD is Not Null


-- Rebate
-- Rate from Coporate
Union
 
SELECT     V.Unit_Number, 
					V.Purchase_Process_Date AS RBR_Date, 
					 (	
					  Case When V.ISD is not Null Then V.ISD 
							   When V.ISD is  Null  And dbo.UpdatedVehicleISD(V.Unit_Number) is Not Null Then dbo.UpdatedVehicleISD(V.Unit_Number)
							   Else Convert(Varchar, getdate(), 106)
					  End)  as DATEINVC,
					AllowanceSource.Customer_Code,
					V.Rebate_Amount as Amount,
					GETDATE() AS Transaction_Date, 
					 'FA Purchase AR' AS Transaction_Type,
					'Vehicle Asset' as RevenueItem,
					'Risk Allowance Clearing Accounting' As ClearingAccount,
					'Rebate - ' +V.Serial_Number as INVCDESC,
					V.Vehicle_Class_Code,
					V.Program,
--					CRAuth.Summary_Level, 					
					--'V' + RIGHT(CONVERT(varchar,  V.Unit_Number + 10000000000), 10) + 'R' AS Doc_Ctrl_Num_Base, 
					'RA' as  Document_Type,
					'I' AS Doc_Ctrl_Num_Type, 
					1 AS Doc_Ctrl_Num_Seq, 
					NULL AS Apply_To_Doc_Ctrl_Num
                    
FROM          dbo.FA_Market_Allowance_Source AS AllowanceSource INNER JOIN
                      dbo.Vehicle AS V 
--						INNER JOIN
--                      dbo.FA_Inservcie_Date_vw AS FAISD ON V.Unit_Number = FAISD.Unit_Number 
                  ON AllowanceSource.Source_Type = V.Rebate_From 

WHERE     (AllowanceSource.Source_Type='C')  AND (V.Rebate_Amount> 0)
--				 AND (FAISD.ISD between @dProcessStartDate and @dProcessEndDate)
				AND (V.Purchase_Process_Date between @dProcessStartDate and @dProcessEndDate)
--				And V.ISD is Not Null


-- Rebate
-- Rate from Coporate GST
Union
 
SELECT     V.Unit_Number, 
					V.Purchase_Process_Date AS RBR_Date, 
					(	
				     Case When V.ISD is not Null Then V.ISD 
				           When V.ISD is  Null  And dbo.UpdatedVehicleISD(V.Unit_Number) is Not Null Then dbo.UpdatedVehicleISD(V.Unit_Number)
                           Else Convert(Varchar, getdate(), 106)
				    End)  as DATEINVC,
					AllowanceSource.Customer_Code,
					Round(V.Rebate_Amount   *(Tax_Rate/100),2)as Amount , 
					GETDATE() AS Transaction_Date, 
					 'FA Purchase AR' AS Transaction_Type,
					'Sales GST' as RevenueItem,
					'Risk Allowance Clearing Accounting' As ClearingAccount,
					'Rebate - ' +V.Serial_Number as INVCDESC,
					V.Vehicle_Class_Code,
					V.Program,
--					CRAuth.Summary_Level, 					
					--'V' + RIGHT(CONVERT(varchar,  V.Unit_Number + 10000000000), 10) + 'R' AS Doc_Ctrl_Num_Base, 
					'RA' as  Document_Type,
					'I' AS Doc_Ctrl_Num_Type, 
					1 AS Doc_Ctrl_Num_Seq, 
					NULL AS Apply_To_Doc_Ctrl_Num
                    
FROM          dbo.FA_Market_Allowance_Source AS AllowanceSource INNER JOIN
                      dbo.Vehicle AS V 
--						INNER JOIN
--                      dbo.FA_Inservcie_Date_vw AS FAISD ON V.Unit_Number = FAISD.Unit_Number 
                  ON AllowanceSource.Source_Type = V.Rebate_From 
   INNER JOIN
                      dbo.Tax_Rate AS TaxRate  ON   V.Purchase_Process_Date  between TaxRate.Valid_From And  TaxRate.Valid_To And (Tax_Type='GST' or Tax_Type='HST')


WHERE     (AllowanceSource.Source_Type='C')  AND (V.Rebate_Amount> 0)
--				 AND (FAISD.ISD between @dProcessStartDate and @dProcessEndDate)
				AND (V.Purchase_Process_Date between @dProcessStartDate and @dProcessEndDate)
--				And V.ISD is Not Null


Union
-- Rate from Dealer
SELECT     V.Unit_Number, 
					V.Purchase_Process_Date AS RBR_Date, 
					(	
					  Case When V.ISD is not Null Then V.ISD 
							   When V.ISD is  Null  And dbo.UpdatedVehicleISD(V.Unit_Number) is Not Null Then dbo.UpdatedVehicleISD(V.Unit_Number)
							   Else Convert(Varchar, getdate(), 106)
					  End)  as DATEINVC,
					AllowanceSource.Customer_Code, 
					V.Rebate_Amount AS Amount, 
					GETDATE() AS Transaction_Date, 
				    'FA Purchase AR'   AS Transaction_Type, 
					'Vehicle Asset' as RevenueItem,
					'Risk Allowance Clearing Accounting' As ClearingAccount,
					'Rebate - ' +V.Serial_Number as INVCDESC,
--					CRAuth.Summary_Level,
					V.Vehicle_Class_Code,
					V.Program,
					--'V' + RIGHT(CONVERT(varchar, V.Unit_Number + 10000000000), 10) + 'R' AS Doc_Ctrl_Num_Base, 
					'RA' as  Document_Type,
					 'I' AS Doc_Ctrl_Num_Type, 
                      1 AS Doc_Ctrl_Num_Seq, 
					 NULL AS Apply_To_Doc_Ctrl_Num
					
FROM         dbo.FA_Market_Allowance_Source AS AllowanceSource INNER JOIN
                      dbo.Vehicle AS V 
--					INNER JOIN
--                      dbo.FA_Inservcie_Date_vw AS FAISD ON V.Unit_Number = FAISD.Unit_Number 
					ON AllowanceSource.Source_Type = V.Rebate_From AND 
                      AllowanceSource.Source = V.Dealer_ID 

WHERE     (AllowanceSource.Source_Type = 'D' ) AND (V.Rebate_Amount > 0)
--				AND (FAISD.ISD between @dProcessStartDate and @dProcessEndDate)
				AND (V.Purchase_Process_Date between @dProcessStartDate and @dProcessEndDate)
--				  And V.ISD is Not Null



Union
-- Rate from Dealer GST
SELECT     V.Unit_Number, 
					V.Purchase_Process_Date AS RBR_Date, 
					(	
					  Case When V.ISD is not Null Then V.ISD 
							   When V.ISD is  Null  And dbo.UpdatedVehicleISD(V.Unit_Number) is Not Null Then dbo.UpdatedVehicleISD(V.Unit_Number)
							   Else Convert(Varchar, getdate(), 106)
					  End)  as DATEINVC,
					AllowanceSource.Customer_Code, 
					Round(V.Rebate_Amount   *(Tax_Rate/100),2)as Amount , 
					GETDATE() AS Transaction_Date, 
				    'FA Purchase AR'   AS Transaction_Type, 
					'Sales GST'  as RevenueItem,
					'Risk Allowance Clearing Accounting' As ClearingAccount,
					'Rebate - ' +V.Serial_Number as INVCDESC,
--					CRAuth.Summary_Level,
					V.Vehicle_Class_Code,
					V.Program,
					--'V' + RIGHT(CONVERT(varchar, V.Unit_Number + 10000000000), 10) + 'R' AS Doc_Ctrl_Num_Base, 
					'RA' as  Document_Type,
					 'I' AS Doc_Ctrl_Num_Type, 
                      1 AS Doc_Ctrl_Num_Seq, 
					 NULL AS Apply_To_Doc_Ctrl_Num
					
FROM         dbo.FA_Market_Allowance_Source AS AllowanceSource INNER JOIN
                      dbo.Vehicle AS V 
--					INNER JOIN
--                      dbo.FA_Inservcie_Date_vw AS FAISD ON V.Unit_Number = FAISD.Unit_Number 
					ON AllowanceSource.Source_Type = V.Rebate_From AND 
                      AllowanceSource.Source = V.Dealer_ID 
					INNER JOIN
                      dbo.Tax_Rate AS TaxRate  ON   V.Purchase_Process_Date  between TaxRate.Valid_From And  TaxRate.Valid_To And (Tax_Type='GST' or Tax_Type='HST')


WHERE     (AllowanceSource.Source_Type = 'D' ) AND (V.Rebate_Amount > 0)
--				AND (FAISD.ISD between @dProcessStartDate and @dProcessEndDate)
				AND (V.Purchase_Process_Date between @dProcessStartDate and @dProcessEndDate)
--				  And V.ISD is Not Null




Union

-- Rate from Manufacturer
SELECT     V.Unit_Number, 
					V.Purchase_Process_Date AS RBR_Date, 
					(	
				  Case When V.ISD is not Null Then V.ISD 
				           When V.ISD is  Null  And dbo.UpdatedVehicleISD(V.Unit_Number) is Not Null Then dbo.UpdatedVehicleISD(V.Unit_Number)
                           Else Convert(Varchar, getdate(), 106)
				  End)  as DATEINVC,
					AllowanceSource.Customer_Code, 
					V.Rebate_Amount AS Amount, 
					GETDATE() AS Transaction_Date, 
					 'FA Purchase AR'   AS Transaction_Type,
					'Vehicle Asset' as RevenueItem, 
					'Risk Allowance Clearing Accounting' As ClearingAccount,
				    'Rebate - ' +V.Serial_Number as INVCDESC,
--					CRAuth.Summary_Level,
					V.Vehicle_Class_Code,
					V.Program,
					--'V' + RIGHT(CONVERT(varchar, V.Unit_Number + 10000000000), 10) + 'R' AS Doc_Ctrl_Num_Base, 
					'RA' as  Document_Type,
					 'I' AS Doc_Ctrl_Num_Type, 
                      1 AS Doc_Ctrl_Num_Seq, 
					 NULL AS Apply_To_Doc_Ctrl_Num					

FROM         dbo.FA_Market_Allowance_Source AllowanceSource INNER JOIN
                      dbo.Vehicle V 
--					INNER JOIN
--                      dbo.FA_Inservcie_Date_vw FAISD ON V.Unit_Number = FAISD.Unit_Number 
			ON 
                      AllowanceSource.Source_Type = V.Rebate_From INNER JOIN
                      dbo.Vehicle_Model_Year VMY ON V.Vehicle_Model_ID = VMY.Vehicle_Model_ID AND 
                      AllowanceSource.Source = VMY.Manufacturer_ID 
WHERE   (AllowanceSource.Source_Type = 'M') AND (V.Rebate_Amount > 0)
--				 AND (FAISD.ISD between @dProcessStartDate and @dProcessEndDate)
				AND (V.Purchase_Process_Date between @dProcessStartDate and @dProcessEndDate)
--				 And V.ISD is Not Null

Union

-- Rate from Manufacturer GST
SELECT     V.Unit_Number, 
					V.Purchase_Process_Date AS RBR_Date, 
						(	
				  Case When V.ISD is not Null Then V.ISD 
				           When V.ISD is  Null  And dbo.UpdatedVehicleISD(V.Unit_Number) is Not Null Then dbo.UpdatedVehicleISD(V.Unit_Number)
                           Else Convert(Varchar, getdate(), 106)
				  End)  as DATEINVC,
					AllowanceSource.Customer_Code, 
				   Round(V.Rebate_Amount   *(Tax_Rate/100),2)as Amount , 
					GETDATE() AS Transaction_Date, 
					 'FA Purchase AR'   AS Transaction_Type,
					'Sales GST' as RevenueItem, 
					'Risk Allowance Clearing Accounting' As ClearingAccount,
				    'Rebate - ' +V.Serial_Number as INVCDESC,
--					CRAuth.Summary_Level,
					V.Vehicle_Class_Code,
					V.Program,
					--'V' + RIGHT(CONVERT(varchar, V.Unit_Number + 10000000000), 10) + 'R' AS Doc_Ctrl_Num_Base, 
					'RA' as  Document_Type,
					 'I' AS Doc_Ctrl_Num_Type, 
                      1 AS Doc_Ctrl_Num_Seq, 
					 NULL AS Apply_To_Doc_Ctrl_Num					

FROM         dbo.FA_Market_Allowance_Source AllowanceSource INNER JOIN
                      dbo.Vehicle V 
--					INNER JOIN
--                      dbo.FA_Inservcie_Date_vw FAISD ON V.Unit_Number = FAISD.Unit_Number 
			ON 
                      AllowanceSource.Source_Type = V.Rebate_From INNER JOIN
                      dbo.Vehicle_Model_Year VMY ON V.Vehicle_Model_ID = VMY.Vehicle_Model_ID AND 
                      AllowanceSource.Source = VMY.Manufacturer_ID 
				INNER JOIN
                      dbo.Tax_Rate AS TaxRate  ON   V.Purchase_Process_Date  between TaxRate.Valid_From And  TaxRate.Valid_To And (Tax_Type='GST' or Tax_Type='HST')

WHERE   (AllowanceSource.Source_Type = 'M') AND (V.Rebate_Amount > 0)
--				AND (FAISD.ISD between @dProcessStartDate and @dProcessEndDate)
				AND (V.Purchase_Process_Date between @dProcessStartDate and @dProcessEndDate)
			    -- And V.ISD is Not Null

) FAARTran

--======================================================================================================
-- Creating Vehicle Purchase AR

-- AR Invoice

	Delete FA_AR_Detail
	FROM         dbo.FA_AR_Detail AS ARDet INNER JOIN
						  dbo.FA_AR_Header AS ARHd ON ARDet.AR_ID = ARHd.AR_ID
	Where ARHd.rbr_date Between @dProcessStartDate and @dProcessEndDate and Transaction_Type='FA Purchase AR'


	Delete FA_AR_Header  Where rbr_date Between @dProcessStartDate and @dProcessEndDate and Transaction_Type='FA Purchase AR'

       -- Everything in Detail Level First

        INSERT
          INTO   FA_AR_Header
                (
				Transaction_Type,
				RBR_Date,
				Document_Number,                               
				Document_Date,				
				Customer_Account,
				Document_Description,
				Amount, 
				Summary_Level,              
				Doc_Ctrl_Num_Base,
				Doc_Ctrl_Num_Type
                )


				Select   Transaction_Type, 
							RBR_Date, 
							Unit_Number, 
							DATEINVC,
							Customer_Account, 			
							INVCDESC,
							Sum(Amount) as Amount,          
--							SUM(Round(Amount *(1+Tax_Rate/100),2)) as Amount , 
							CRAuth.summary_level , 
							'V'+
							(Case When CRAuth.summary_level<>'C' Or  CRAuth.summary_level IS Null Then Ltrim( rtrim(Convert(Varchar(10),FAAR.Unit_Number))) Else  Ltrim( rtrim(Customer_Account ))End)+ 
							Document_Type  AS Doc_Ctrl_Num_Base, 
							'I' As Doc_Ctrl_Num_Type			
				From		#ARTransaction FAAR
--                Inner Join Tax_Rate 
--									On FAAR.RBR_Date  between Tax_Rate.Valid_From And  Tax_Rate.Valid_To And Tax_Type='GST'

				LEFT OUTER JOIN	dbo.AR_Credit_Authorization CRAuth 
							ON  FAAR.Customer_Account=CRAuth.Customer_Code 

				where  FAAR.RBR_Date Between @dProcessStartDate and @dProcessEndDate and FAAR.Transaction_Type='FA Purchase AR'
                				group by FAAR.Transaction_Type, FAAR.RBR_Date, FAAR.Customer_Account,  FAAR.Unit_Number ,FAAR.INVCDESC, FAAR.DATEINVC,CRAuth.summary_level , FAAR.Document_Type
				HAVING sum(Amount)<>0


/*
* Determine the type of records (Invoice or Adjustment) 
 * Make the first record an invoice and all others adjustments
 * when sorted by transaction date and ar_export_id
 */
        UPDATE  FA_AR_Header
           SET  doc_ctrl_num_type = 'I'
         WHERE  doc_ctrl_num_type IS NULL
	   AND	rbr_date = 
		(
		SELECT	MIN(ar2.rbr_date)
		  FROM	FA_AR_Header ar2
		 WHERE	ar2.doc_ctrl_num_base = FA_AR_Header.doc_ctrl_num_base
		   AND	ar2.customer_account = FA_AR_Header.customer_account
		)
	  
	   AND	NOT EXISTS
		(
                /* eliminate new transactions that are adjustments
		 * of existing invoices.
		 */
		SELECT	*
		  FROM	FA_AR_Header arExists
		 WHERE	arExists.doc_ctrl_num_type = 'I'
		   AND	arExists.doc_ctrl_num_base = FA_AR_Header.doc_ctrl_num_base
		   AND	arExists.customer_account = FA_AR_Header.customer_account
		)

        /* set remaining transactions to be adjustments */
        UPDATE  FA_AR_Header
           SET  doc_ctrl_num_type = 'A'
         WHERE  doc_ctrl_num_type IS NULL


/* Set sequence numbers
 * Use two correlated subqueries. The first calculates the maximum existing 
 * sequence number and the second calculates the record's position within the 
 * new records for this base.
 */
	UPDATE	FA_AR_Header
	   SET	doc_ctrl_num_seq =
		(
		SELECT	existing.max_seq + new.position
		  FROM	(
			SELECT	ISNULL(MAX(doc_ctrl_num_seq), 0) max_seq
			  FROM	FA_AR_Header ar2
			 WHERE	ar2.doc_ctrl_num_base =	FA_AR_Header.doc_ctrl_num_base
			   AND	ar2.doc_ctrl_num_type =	FA_AR_Header.doc_ctrl_num_type
			) existing,
			(
			SELECT	COUNT(*) + 1 position
			  FROM	FA_AR_Header ar3
			 WHERE	ar3.doc_ctrl_num_seq IS	NULL
			   AND	ar3.doc_ctrl_num_base =	FA_AR_Header.doc_ctrl_num_base
			   AND	ar3.doc_ctrl_num_type =	FA_AR_Header.doc_ctrl_num_type
			   AND	ar3.AR_ID < FA_AR_Header.AR_ID			  
			) new
		)
	 WHERE  doc_ctrl_num_seq IS NULL
/* Link adjustments to original invoices */
        UPDATE  FA_AR_Header
           SET  apply_to_doc_ctrl_num =
                        (
                        SELECT  FA_AR_Header.doc_ctrl_num_base + 'I' +
                                  RIGHT(CONVERT(varchar,
                                  MAX(ar2.doc_ctrl_num_seq) +
                                  1000), 3)
                          FROM  FA_AR_Header ar2
                         WHERE  ar2.doc_ctrl_num_base =
                                  FA_AR_Header.doc_ctrl_num_base
                           AND  ar2.customer_account = FA_AR_Header.customer_account

                           AND  ar2.doc_ctrl_num_type = 'I'
                        )
         WHERE  doc_ctrl_num_type = 'A'
           AND  apply_to_doc_ctrl_num IS NULL



INSERT INTO 
	FA_AR_Detail (
	AR_ID ,
	Revenue_Account,
	Amount
) 

Select   FAARH.AR_ID,
            GL.GL_Number as RevenueAccount,
--			SUM(Round(FAAR.Amount *(1+Tax_Rate/100),2)) as Amount 
            SUM(FAAR.Amount) as Amount 
			
From
		(  Select   Transaction_Type, 
							RBR_Date, 
							Unit_Number, 
							DATEINVC,
							Customer_Account, 			
							INVCDESC,
							Sum(Amount) as Amount,          
--							SUM(Round(Amount *(1+Tax_Rate/100),2)) as Amount , 
							CRAuth.summary_level , 
							'V'+
							(Case When CRAuth.summary_level<>'C' Or  CRAuth.summary_level IS Null Then Ltrim( rtrim(Convert(Varchar(10),FAAR.Unit_Number))) Else  Ltrim( rtrim(Customer_Account ))End)+ 
							Document_Type  AS Doc_Ctrl_Num_Base, 
							'I' As Doc_Ctrl_Num_Type,
							Vehicle_Class_Code,		
							ClearingAccount,
							Program
				From		#ARTransaction FAAR
				LEFT OUTER JOIN	dbo.AR_Credit_Authorization CRAuth 
							ON  FAAR.Customer_Account=CRAuth.Customer_Code 
				where  FAAR.RBR_Date Between @dProcessStartDate and @dProcessEndDate and FAAR.Transaction_Type='FA Purchase AR'
                				group by FAAR.Transaction_Type, FAAR.RBR_Date, FAAR.Customer_Account,  FAAR.Unit_Number ,FAAR.INVCDESC, FAAR.DATEINVC,CRAuth.summary_level , FAAR.Document_Type,Vehicle_Class_Code,		
							ClearingAccount,
							Program
				HAVING sum(Amount)<>0
)FAAR
INNER JOIN dbo.Vehicle_Class VC 
					ON FAAR.Vehicle_Class_Code = VC.Vehicle_Class_Code
 Inner Join dbo.FA_GL GL 
					On FAAR.ClearingAccount=GL.Accounting_Item and FAAR .Program=GL.Program  And  VC.FA_Vehicle_Type_ID=GL.Vehicle_Type
Inner Join dbo.FA_AR_Header FAARH
					On  FAAR.Unit_Number=FAARH.Document_Number 
					And FAAR.RBR_Date=FAARH.RBR_Date 
					And FAAR.Customer_Account=FAARH.Customer_Account
					And FAAR.Doc_Ctrl_Num_Base=FAARH.Doc_Ctrl_Num_Base
				   And  FAAR.Doc_Ctrl_Num_Type=FAARH.Doc_Ctrl_Num_Type 
				   And  FAAR.INVCDESC=FAARH.Document_Description

Group By AR_ID,  GL.GL_Number

-- GL Entry

 Delete FA_Sales_Journal  Where rbr_date Between @dProcessStartDate and @dProcessEndDate and Transaction_Type='FA Purchase AR'

-- GL Entry
Insert Into FA_Sales_Journal (RBR_Date,	Document_Number,	Transaction_Type,	Entry_Date,	GL_Account,Amount)
Select RBR_Date,  Convert(Varchar(12), Unit_Number),GLTrans.Transaction_Type, DATEENTRY, GL.GL_Number, Amount  from 
(
-- Credit Revenue Account

-- Revenue
SELECT  ARTrans.RBR_Date,    ARTrans.Unit_Number, Transaction_Type, DATEINVC as DATEENTRY, ARTrans.Amount *(-1) as Amount, ARTrans.RevenueItem GLItem, dbo.Vehicle_Class.FA_Vehicle_Type_ID, ARTrans.Program
FROM         #ARTransaction AS ARTrans INNER JOIN
                      dbo.Vehicle_Class ON ARTrans.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code
--Union 
--
--SELECT     ARTrans.RBR_Date, ARTrans.Unit_Number,  Transaction_Type, DATEINVC as DATEENTRY, Round(Amount *(Tax_Rate/100),2)*(-1) as Amount ,  'Sales GST' as GLItem , dbo.Vehicle_Class.FA_Vehicle_Type_ID, ARTrans.Program
--FROM         #ARTransaction AS ARTrans INNER JOIN
--                      dbo.Vehicle_Class ON ARTrans.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code INNER JOIN
--                      dbo.Tax_Rate AS TaxRate  ON   ARTrans.RBR_Date  between TaxRate.Valid_From And  TaxRate.Valid_To And Tax_Type='GST'
-- Debit  Clearing Account
Union
SELECT  ARTrans.RBR_Date,    ARTrans.Unit_Number, Transaction_Type, DATEINVC as DATEENTRY,  Amount , --Round(Amount *(1+Tax_Rate/100),2)  as Amount , 
ClearingAccount as GLItem , dbo.Vehicle_Class.FA_Vehicle_Type_ID, ARTrans.Program
FROM       #ARTransaction AS ARTrans INNER JOIN
                      dbo.Vehicle_Class ON ARTrans.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code 
--INNER JOIN
--                      dbo.Tax_Rate AS TaxRate  ON   ARTrans.RBR_Date  between TaxRate.Valid_From And  TaxRate.Valid_To And Tax_Type='GST'


) GLTrans Inner Join dbo.FA_GL GL on GLTrans.GLItem=GL.Accounting_Item and GLTrans .Program=GL.Program And GLTrans.FA_Vehicle_Type_ID=GL.Vehicle_Type

/*

(

SELECT   ARTrans.RBR_Date,  ARTrans.Unit_Number, Transaction_Type, DATEINVC as DATEENTRY, ARTrans.Amount *(-1) as Amount, ARTrans.RevenueItem GLItem, dbo.Vehicle_Class.FA_Vehicle_Type_ID, ARTrans.Program
FROM         #ARTransaction AS ARTrans INNER JOIN
                      dbo.Vehicle_Class ON ARTrans.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code

) GLTrans Inner Join dbo.FA_GL GL on GLTrans.GLItem=GL.Accounting_Item and GLTrans .Program=GL.Program And GLTrans.FA_Vehicle_Type_ID=GL.Vehicle_Type
*/
--select * from vehicle where Price_Difference is not null and Price_Difference<>0

GO
