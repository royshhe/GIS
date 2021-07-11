USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_FA_NewAcqure]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





----------------------------------------------------------------------------------------------------------------------------------------
--  Programmer :   Roy He
--  Date :         Jun 22, 2002
--  Details: 	   FPO Fuel Adhoc Reports
----------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[RP_SP_FA_NewAcqure] --'2016-09-01', '2017-09-30'
       @StartDateInput varchar(30)='Dec 01 2000', 
       @EndDateInput varchar(30)='Dec 31 2000'

AS 

SET NOCOUNT ON 

DECLARE @StartDate datetime, @EndDate datetime
SELECT @StartDate = CONVERT(DATETIME, @StartDateInput)
SELECT @EndDate = CONVERT(DATETIME, @EndDateInput)+1

declare @CompanyCode int  --remove hardcode code
select @CompanyCode=Code from Lookup_Table where Category = 'BudgetBC Company'
	

SELECT 
V.Unit_Number, 
V.Serial_Number, 
VMY.Model_Name, 
VMY.Model_Year, 
--VOC.ISD, 
dbo.VehicleISD(v.Unit_number) as VehicleISD,
(CASE WHEN V.program = 1 THEN 'Program' ELSE 'Risk' END) 
               AS Order_type, 
--(CASE WHEN V.program = 1 THEN NULL 
--	  ELSE
--	 (Case When PDI_Included_In_Price=1 Then NULL Else PDI_Amount END)
--End) Risk_PDI,
--Modify to include Program PDI
--(Case When PDI_Included_In_Price=1 Then NULL Else PDI_Amount END)Risk_PDI,
PDI_Amount Risk_PDI,
V.Vehicle_Cost, 
V.Volume_Incentive, 
V.Rebate_Amount,
--V.Mark_Down, 
--V.Excise_Tax, 
--V.Battery_Levy,
V.Purchase_Price,  
V.Purchase_GST, 
--V.Purchase_PST,
V.Purchase_Price+V.Purchase_GST+ISNULL(V.Purchase_PST,0) as Total

FROM  dbo.Vehicle V 
INNER JOIN dbo.Vehicle_Model_Year VMY 
	ON V.Vehicle_Model_ID = VMY.Vehicle_Model_ID 
--INNER JOIN
--	(SELECT MIN(Checked_Out) AS ISD, Unit_Number
--    FROM   dbo.Vehicle_On_Contract WITH (NOLOCK)
--    GROUP BY Unit_Number) VOC 
--	ON V.Unit_Number = VOC.Unit_Number



WHERE
    (V.Owning_Company_ID = @CompanyCode ) AND 
    (V.Deleted = 0) AND 
	(dbo.VehicleISD(v.Unit_number) >= @StartDate AND dbo.VehicleISD(v.Unit_number) <@EndDate) 
order by V.Unit_Number




GO
