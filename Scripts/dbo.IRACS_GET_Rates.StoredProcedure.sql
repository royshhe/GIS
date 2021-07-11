USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[IRACS_GET_Rates]    Script Date: 2021-07-10 1:50:49 PM ******/
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
CREATE PROCEDURE [dbo].[IRACS_GET_Rates] --1060141
(
	@CtrctNumber varchar(20)
)


AS




SELECT distinct   
	substring(ISNULL(Vehicle_Rate.Rate_Name,'XXX '),1,7) as RateCode,
       'PRI' as RateSelection,                     
	 
       (Case When RTP.Time_Period ='Day' then 'DY'
	    When RTP.Time_Period ='Week' then 'WK'
	    When RTP.Time_Period ='Hour' then 'HM'
            When RTP.Time_Period ='Month' then 'MO'
	    Else   'HM'
	End ) as RatePierod,
	RTP.Time_Period_Start, 
	RTP.Time_period_End, 
        RCA.Amount, 

       Case
		When (Rate_Location_Set.Km_Cap  is not null ) and Rate_Location_Set.Override_Km_Cap_Flag=1 Then
              
		   (Case When Rate_Location_Set.Km_Cap IS Null  then 9999
			  Else Convert(Varchar(6), Rate_Location_Set.Km_Cap)
		     End)

		WHEN RTP.Km_Cap IS NULL THEN
			9999
                --WHEN RTP.Km_Cap='Unlimited' THEN                                 
		--	9999
		Else
			Convert(Varchar(5), RTP.Km_Cap)
	 End as          FreeMiles


--Syntax error converting the varchar value 'Unlimited' to a column of data type smallint.

         /*,
         case 
               when dbo.Contract_Charge_Item.Unit_Type=RTP.Time_Period and dbo.Contract_Charge_Item.Unit_Amount=RCA.Amount then
                 dbo.Contract_Charge_Item.Quantity 
               else 0
         end as PrdsCharged,
         case 
               when dbo.Contract_Charge_Item.Unit_Type=RTP.Time_Period and dbo.Contract_Charge_Item.Unit_Amount=RCA.Amount then
                 dbo.Contract_Charge_Item.Quantity* dbo.Contract_Charge_Item.Unit_Amount
               else 0
         end as TotalCharge
        */
         
                                  
                 
FROM    dbo.Rate_Charge_Amount RCA INNER JOIN dbo.Rate_Time_Period RTP 
	ON RCA.Rate_Time_Period_ID = RTP.Rate_Time_Period_ID AND RCA.Rate_ID = RTP.Rate_ID
		INNER JOIN  dbo.Rate_Vehicle_Class RVC 
	ON RCA.Rate_Vehicle_Class_ID = RVC.Rate_Vehicle_Class_ID INNER JOIN
                      dbo.Contract ON RCA.Rate_ID = dbo.Contract.Rate_ID AND RCA.Rate_Level = dbo.Contract.Rate_Level AND 
                      RVC.Vehicle_Class_Code = dbo.Contract.Vehicle_Class_Code INNER JOIN
                      dbo.Rate_Location_Set ON RCA.Rate_ID = dbo.Rate_Location_Set.Rate_ID INNER JOIN
                      dbo.Rate_Location_Set_Member ON dbo.Rate_Location_Set.Rate_ID = dbo.Rate_Location_Set_Member.Rate_ID AND 
                      dbo.Rate_Location_Set.Rate_Location_Set_ID = dbo.Rate_Location_Set_Member.Rate_Location_Set_ID AND 
                      dbo.Contract.Pick_Up_Location_ID = dbo.Rate_Location_Set_Member.Location_ID INNER JOIN
                      dbo.Vehicle_Rate ON dbo.Contract.Rate_ID = dbo.Vehicle_Rate.Rate_ID 
                       /*Inner JOIN
                      dbo.Contract_Charge_Item ON dbo.Contract.Contract_Number = dbo.Contract_Charge_Item.Contract_Number
			*/

WHERE     (RCA.Type = 'Regular') 

AND (dbo.Contract.Rate_Assigned_Date BETWEEN dbo.Rate_Location_Set.Effective_Date AND dbo.Rate_Location_Set.Termination_Date) 
AND (dbo.Contract.Rate_Assigned_Date BETWEEN dbo.Rate_Location_Set_Member.Effective_Date AND dbo.Rate_Location_Set_Member.Termination_Date) 
AND (dbo.Contract.Rate_Assigned_Date BETWEEN dbo.Vehicle_Rate.Effective_Date AND dbo.Vehicle_Rate.Termination_Date) 
AND (dbo.Contract.Rate_Assigned_Date BETWEEN RCA.Effective_Date AND RCA.Termination_Date) 
AND (dbo.Contract.Rate_Assigned_Date BETWEEN RVC.Effective_Date AND RVC.Termination_Date) 
AND (dbo.Contract.Rate_Assigned_Date BETWEEN RTP.Effective_Date AND RTP.Termination_Date) 
--And (dbo.Contract_Charge_Item.Unit_Type=RTP.Time_Period and dbo.Contract_Charge_Item.Unit_Amount=RCA.Amount)
--AND (dbo.Contract_Charge_Item.Charge_Type =10)
And (dbo.Contract.Contract_number=Convert(int, @CtrctNumber))


UNION

SELECT  


       substring(ISNULL(dbo.Quoted_Vehicle_Rate.Rate_Name, 'XXX'),1,7) as RateCode,
       'PRI' as RateSelection,                     	
       (Case When dbo.Quoted_Time_Period_Rate.Time_Period ='Day' then 'DY'
	    When dbo.Quoted_Time_Period_Rate.Time_Period ='Week' then 'WK'
	    When dbo.Quoted_Time_Period_Rate.Time_Period ='Hour' then 'HM'
            When dbo.Quoted_Time_Period_Rate.Time_Period ='Month' then 'MO'
	    Else   'HM'
	End ) as RatePierod,	
         dbo.Quoted_Time_Period_Rate.Time_Period_Start, 
	 dbo.Quoted_Time_Period_Rate.Time_Period_End, 
	dbo.Quoted_Time_Period_Rate.Amount,
       (Case
		When  Per_KM_Charge<>0 Then 
			(Case When  Km_Cap IS NULL	 then 0
                               When KM_Cap is not Null  then  Km_Cap
			  End) 		

		When (Km_Cap IS NULL  )and (Per_KM_Charge=0 or Per_KM_Charge is null) Then 9999
		Else Km_Cap
	End
        ) as FreeMiles
       /*,

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
          end as TotalCharge
          
*/         
FROM	dbo.Quoted_Time_Period_Rate INNER JOIN
        dbo.Quoted_Vehicle_Rate ON dbo.Quoted_Time_Period_Rate.Quoted_Rate_ID = dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID INNER JOIN
        dbo.Contract ON dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID = dbo.Contract.Quoted_Rate_ID 
	--INNER JOIN  dbo.Contract_Charge_Item ON dbo.Contract.Contract_Number = dbo.Contract_Charge_Item.Contract_Number



Where 	(Quoted_Time_Period_Rate.Rate_Type = 'Regular') 
        --AND (dbo.Contract_Charge_Item.Charge_Type =10)
	--And (dbo.Contract_Charge_Item.Unit_Type=Quoted_Time_Period_Rate.Time_Period and dbo.Contract_Charge_Item.Unit_Amount=Quoted_Time_Period_Rate.Amount)
        And (dbo.Contract.Contract_number=Convert(int, @CtrctNumber))


ORDER BY  FreeMiles





GO
