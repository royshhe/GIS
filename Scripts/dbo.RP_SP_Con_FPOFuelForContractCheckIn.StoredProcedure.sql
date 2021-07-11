USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Con_FPOFuelForContractCheckIn]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[RP_SP_Con_FPOFuelForContractCheckIn] -- '*',  '2016-08-10' , '2016-08-10'
(
	@paramLocID varchar(20) = '*',
	@RBR_Start_Date varchar(22) 	= '01 JUL 2007',
	@RBR_End_Date 	varchar(22) 	= '01 JUL 2007'
)
AS


-- convert strings to datetime
DECLARE @startDate datetime,
	@endDate datetime

SELECT	@startDate	= CONVERT(datetime, '00:00:00 ' + @RBR_Start_Date),
	@endDate	= CONVERT(datetime, '23:59:59 ' + @RBR_End_Date)	


/*
SELECT	@startDate	= CONVERT(datetime, @RBR_Start_Date),
	@endDate	= CONVERT(datetime,  @RBR_End_Date)	

*/

DECLARE @tmpLocID varchar(20)
if @paramLocID = '*'
	BEGIN
		SELECT @tmpLocID='0'
        END
else
	BEGIN
		SELECT @tmpLocID = @paramLocID
	END 


SELECT
	--RBR_Date, 	
        Location.Location,
	Contract_number ,
	foreign_contract_number,
	Unit_number =  case when Foreign_Vehicle_Unit_Number is not null 
				then Foreign_Vehicle_Unit_Number
				else convert(varchar(20), Unit_number)
				end,  
        km_in,
        km_driven, 	
        Actual_Check_In,	
	SUM(CASE	WHEN Charge_Type = 14
			THEN Amount
			ELSE 0
		END) 							as FPO,

	SUM(CASE	WHEN Charge_Type = 18
			THEN Amount
			ELSE 0
		END) 							as Fuel,
       dbo.RP_Con_ChargeItem_Detail.Pick_Up_On, 

      (Case 
			  when Unit_Type='Litres'  then  dbo.RP_Con_ChargeItem_Detail.Unit_Amount
              Else Null
       End) Unit_Amount, 
      
	sum(Case 
			  when Unit_Type='Litres'  then  dbo.RP_Con_ChargeItem_Detail.Quantity
              Else Null
       End) Quantity, 

       (Case 
			  when Unit_Type='Litres'  then  sum(dbo.RP_Con_ChargeItem_Detail.NetAmount)/ sum(Case when dbo.RP_Con_ChargeItem_Detail.Quantity is not null and dbo.RP_Con_ChargeItem_Detail.Quantity <>0  then dbo.RP_Con_ChargeItem_Detail.Quantity Else 1 End)
              Else Null
       End) Net_Unit_Amount, 

     

-- dbo.RP_Con_ChargeItem_Detail.Quantity, 
	SUM(CASE	WHEN Charge_Type = 14
			THEN NetAmount
			ELSE 0
		END) 							as NetFPO,
	SUM(CASE	WHEN Charge_Type = 18
			THEN NetAmount
			ELSE 0
		END) 							as NetFuel,

		KmChargeFlat
 
	
FROM 	RP_Con_ChargeItem_Detail inner join Location on Location.Location_id=  Actual_Drop_Off_Location_ID
where Actual_Check_In between  @startDate AND @endDate    AND	
 (@paramLocID = '*' or CONVERT(INT, @tmpLocID) = Actual_Drop_Off_Location_ID)
   and  Charge_Type in ('14','18') 

/*and contract_Number 

in 
			(1134026,
1135275,
1137320

)*/

GROUP BY 	Contract_number,
		Unit_number,
		km_in,
        km_driven, 	
		Foreign_contract_number,
		Foreign_Vehicle_Unit_Number,	
		Actual_Check_In,
		Location.Location,  
		Charge_Type,
		dbo.RP_Con_ChargeItem_Detail.Pick_Up_On, 
		dbo.RP_Con_ChargeItem_Detail.Unit_Type,
       dbo.RP_Con_ChargeItem_Detail.Unit_Amount,
		KmChargeFlat
        --   , 
       --dbo.RP_Con_ChargeItem_Detail.Quantity
order by Actual_Check_In
	









GO
