USE [GISData]
GO
/****** Object:  View [dbo].[ViewXContractRates]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- Created By Roy He
-- Contract Rates Data output for CCRS

CREATE VIEW [dbo].[ViewXContractRates]
AS
SELECT DISTINCT Contract.Contract_number,
		substring(dbo.Vehicle_Rate.Rate_Name,1,8) as RateCode,                     
	    	 substring(RTP.Time_Period,1,4) as Unit, 
		 RTP.Time_Period_Start, 
		 RTP.Time_period_End, 
                 1 as UnitPerPeriod,
                 RCA.Amount, 
                 Case
			When Rate_Location_Set.Km_Cap  is not null and Rate_Location_Set.Override_Km_Cap_Flag=1 Then
				Convert(Varchar(6), Rate_Location_Set.Km_Cap)
			WHEN RTP.Km_Cap IS NULL THEN
				'Unlimited'
			Else
				Convert(Varchar(5), RTP.Km_Cap)
		  End as FreeMiles,

                 --dbo.Rate_Location_Set.Per_Km_Charge, 
                 
                -- dbo.Contract_Charge_Item.Unit_Type, 
                -- dbo.Contract_Charge_Item.Unit_Amount, 
                case 
                       when dbo.Contract_Charge_Item.Unit_Type=RTP.Time_Period and dbo.Contract_Charge_Item.Unit_Amount=RCA.Amount then
                         dbo.Contract_Charge_Item.Quantity 
                       else
 			 0
                end as PrdsCharged,
                case 
                       when dbo.Contract_Charge_Item.Unit_Type=RTP.Time_Period and dbo.Contract_Charge_Item.Unit_Amount=RCA.Amount then
                         dbo.Contract_Charge_Item.Quantity* dbo.Contract_Charge_Item.Unit_Amount
                       else
 			 0
                end as TotalCharge,
                '$/'+RTP.Time_Period as Description,
                 Contract_Charge_Item.Charge_Type
                
                  
                   
FROM         dbo.Rate_Charge_Amount RCA INNER JOIN
                      dbo.Rate_Time_Period RTP ON RCA.Rate_Time_Period_ID = RTP.Rate_Time_Period_ID INNER JOIN
                      dbo.Rate_Vehicle_Class RVC ON RCA.Rate_Vehicle_Class_ID = RVC.Rate_Vehicle_Class_ID INNER JOIN
                      dbo.Contract ON RCA.Rate_ID = dbo.Contract.Rate_ID AND RCA.Rate_Level = dbo.Contract.Rate_Level AND 
                      RVC.Vehicle_Class_Code = dbo.Contract.Vehicle_Class_Code INNER JOIN
                      dbo.Rate_Location_Set ON RCA.Rate_ID = dbo.Rate_Location_Set.Rate_ID INNER JOIN
                      dbo.Rate_Location_Set_Member ON dbo.Rate_Location_Set.Rate_ID = dbo.Rate_Location_Set_Member.Rate_ID AND 
                      dbo.Rate_Location_Set.Rate_Location_Set_ID = dbo.Rate_Location_Set_Member.Rate_Location_Set_ID AND 
                      dbo.Contract.Pick_Up_Location_ID = dbo.Rate_Location_Set_Member.Location_ID INNER JOIN
                      dbo.Vehicle_Rate ON dbo.Contract.Rate_ID = dbo.Vehicle_Rate.Rate_ID LEFT OUTER JOIN
                      dbo.Contract_Charge_Item ON dbo.Contract.Contract_Number = dbo.Contract_Charge_Item.Contract_Number
WHERE     (RCA.Type = 'Regular') AND (dbo.Contract.Rate_Assigned_Date BETWEEN dbo.Rate_Location_Set.Effective_Date AND 
                      dbo.Rate_Location_Set.Termination_Date) AND (dbo.Contract.Rate_Assigned_Date BETWEEN RCA.Effective_Date AND RCA.Termination_Date) AND 
                      (dbo.Contract.Rate_Assigned_Date BETWEEN RVC.Effective_Date AND RVC.Termination_Date) AND (dbo.Contract.Rate_Assigned_Date BETWEEN 
                      RTP.Effective_Date AND RTP.Termination_Date) 
                      -- AND (dbo.Contract.Contract_Number =  651747) 
                      AND (dbo.Contract_Charge_Item.Charge_Type =10)
                 --               AND (dbo.Contract_Charge_Item.Charge_Type IN (10,  11, 20, 50, 51, 52))

UNION

SELECT  dbo.Contract.Contract_Number, 
	substring(dbo.Quoted_Vehicle_Rate.Rate_Name,1,8), 
	substring(dbo.Quoted_Time_Period_Rate.Time_Period,1,4), 
        dbo.Quoted_Time_Period_Rate.Time_Period_Start, 
	dbo.Quoted_Time_Period_Rate.Time_Period_End, 
	1 as UnitPerPeriod,
	dbo.Quoted_Time_Period_Rate.Amount,
         (Case
		When Km_Cap IS NULL and Per_KM_Charge=0  Then
				'Unlimited'
		When Km_Cap IS NULL and Per_KM_Charge<>0 Then
				'0'

		Else
			Convert(varchar, Km_Cap)
	End
        ) as FreeMiles,

           case 
                       when dbo.Contract_Charge_Item.Unit_Type=dbo.Quoted_Time_Period_Rate.Time_Period and dbo.Contract_Charge_Item.Unit_Amount=dbo.Quoted_Time_Period_Rate.Amount then
                         dbo.Contract_Charge_Item.Quantity 
                       else
 			 0
                end as PrdsCharged,
          case 
                       when dbo.Contract_Charge_Item.Unit_Type=dbo.Quoted_Time_Period_Rate.Time_Period and dbo.Contract_Charge_Item.Unit_Amount=dbo.Quoted_Time_Period_Rate.Amount then
                         dbo.Contract_Charge_Item.Quantity* dbo.Contract_Charge_Item.Unit_Amount
                       else
 			 0
          end as TotalCharge,
	  '$/'+Quoted_Time_Period_Rate.Time_Period as Description,
          Contract_Charge_Item.Charge_Type

          
	
FROM	dbo.Quoted_Time_Period_Rate INNER JOIN
        dbo.Quoted_Vehicle_Rate ON dbo.Quoted_Time_Period_Rate.Quoted_Rate_ID = dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID INNER JOIN
        dbo.Contract ON dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID = dbo.Contract.Quoted_Rate_ID INNER JOIN
        dbo.Contract_Charge_Item ON dbo.Contract.Contract_Number = dbo.Contract_Charge_Item.Contract_Number


Where 	(Quoted_Time_Period_Rate.Rate_Type = 'Regular') 
                      AND (dbo.Contract_Charge_Item.Charge_Type =10)









GO
