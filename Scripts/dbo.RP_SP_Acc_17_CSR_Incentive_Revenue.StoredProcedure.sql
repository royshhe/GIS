USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_17_CSR_Incentive_Revenue]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[RP_SP_Acc_17_CSR_Incentive_Revenue]  --'01 jul 2018','04 jul 2018','*','16','PAI','rhe'
			  
(
	@paramStartBusDate varchar(20) = '22 Apr 2001',
	@paramEndBusDate varchar(20) = '23 Apr 2001',
	@paramVehicleTypeID varchar(18) = 'car',
	@paramPickUpLocationID varchar(20) = '*',
	@SortBy varchar(24)='',
	@UserID varchar(24)=''
	
)
AS
--convert strings to datetime
DECLARE 	@startBusDate datetime,
		@endBusDate datetime

SELECT	@startBusDate	= CONVERT(datetime, '00:00:00 ' + @paramStartBusDate),
		@endBusDate	= CONVERT(datetime, '23:59:59 ' + @paramEndBusDate)	


-- fix upgrading problem (SQL7->SQL2000)
DECLARE  @tmpLocID varchar(20),
		@UserName varchar(50)

select @UserName =[user_name]	from gisusers where active=1 and [user_id]=@userid

--print 'UserName:' + @UserName + '@userid:' + @userid
if ltrim(rtrim(@userid)) 
in (select distinct user_id	from gisusergroup	where group_name = 'Executive' ) or 
					@userid in ('rhe', 'vfung', 'sqliu','kevint')
	begin
 
		if @paramPickUpLocationID = '*'
			BEGIN
				SELECT @tmpLocID='0'
				END
		else
			BEGIN
				SELECT @tmpLocID = @paramPickUpLocationID
			END 
	end
  else
	Begin
		if @paramPickUpLocationID = '*'
			begin
				SELECT top 1 @tmpLocID = (location_id)
				from business_transaction
				where rbr_date between @startBusDate and @endBusDate
				and [user_id]=@UserName		
				order by rbr_date desc
				
				SELECT  @paramPickUpLocationID=@tmpLocID 
			end	
		else
				BEGIN
					SELECT @tmpLocID = @paramPickUpLocationID
				END 
	end

 SElECT CSRIncentive.* from 
(
SELECT 	Revenue.Location, 
	Revenue.Vehicle_Type_ID, 
	Revenue.EmployeeID, 
	Revenue.EmployeeStatus, 
	Revenue.CSR_Name, 
	Revenue.Contract_In, 
   	 Revenue.Rental_Days, 
	Revenue.Upgrade +Revenue.Upgrade_Adj As Upgrade,--  +Revenue.Up_Sell+Revenue.Up_Sell_Adj 
	Revenue.All_Level_LDW+Revenue.All_Level_LDW_Adj as All_Level_LDW, 
	--Revenue.Buydown + Revenue.Buydown_Adj as Buydown,
	Revenue.PAI+Revenue.PAI_Adj As PAI, 
	Revenue.PEC+Revenue.PEC_Adj As PEC, 
    Revenue.ELI+Revenue.ELI_Adj As ELI,
    Revenue.GPS +Revenue.GPS_Adj As GPS, 
    Revenue.FPO  As FPO, 
	Revenue.Additional_Driver_Charge+Revenue.Additional_Driver_Charge_Adj As Additional_Driver_Charge, 
    Revenue.All_Seats+Revenue.All_Seats_Adj As All_Seats, 
	Revenue.Driver_Under_Age+Revenue.Driver_Under_Age_Adj As Driver_Under_Age, 
	Revenue.Ski_Rack+Revenue.Ski_Rack_Adj As Ski_Rack, 
	Revenue.Seat_Storage +Revenue.Seat_Storage_Adj As Seat_Storage,
	Revenue.Our_Of_Area +Revenue.Our_Of_Area_Adj As Our_Of_Area,
	Revenue.All_Dolly +Revenue.All_Dolly_Adj As All_Dolly, 
	Revenue.All_Gates+Revenue.All_Gates_Adj As  All_Gates, 
	Revenue.Blanket+Revenue.Blanket_Adj as Blanket, 
	Revenue.Snow_Tire+Revenue.Snow_Tire_Adj as Snow_Tire, 
	Revenue.KPO_Package+Revenue.KPO_Package_Adj as KPO_Package, 

	Revenue.Upgrade+--Revenue.Up_Sell+
	Revenue.All_Level_LDW+
	--Revenue.Buydown+
	Revenue.PAI+ 
	Revenue.PEC+ 
   	Revenue.ELI+ 
	Revenue.GPS+ 
	Revenue.FPO+
	Revenue.Additional_Driver_Charge+ 
    Revenue.All_Seats+ 
	Revenue.Driver_Under_Age+ 
	Revenue.Ski_Rack+ 
	Revenue.Seat_Storage+
	Revenue.Our_Of_Area+
	Revenue.All_Dolly+ 
	Revenue.All_Gates+ 
	Revenue.Blanket+
	Revenue.Snow_Tire+
	Revenue.KPO_Package	
+
	Revenue.Upgrade_Adj+--Revenue.Up_Sell_Adj+
	Revenue.All_Level_LDW_Adj+
	--Revenue.Buydown_Adj+
	Revenue.PAI_Adj+ 
	Revenue.PEC_Adj+ 
   	Revenue.ELI_Adj+ 
	Revenue.GPS_Adj+ 
	Revenue.Additional_Driver_Charge_Adj+ 
    Revenue.All_Seats_Adj+ 
	Revenue.Driver_Under_Age_Adj+ 
	Revenue.Ski_Rack_Adj+ 
	Revenue.Seat_Storage_Adj+
	Revenue.Our_Of_Area_Adj+
	Revenue.All_Dolly_Adj+ 
	Revenue.All_Gates_Adj+ 
	Revenue.Blanket_Adj+
	Revenue.Snow_Tire_Adj+
	Revenue.KPO_Package_Adj

as SalesItemRevenue,

	Revenue.Upgrade +-- Revenue.Up_Sell+
	Revenue.All_Level_LDW/2+
	--Revenue.Buydown+
	Revenue.PAI+ 
	Revenue.PEC+
    Revenue.ELI+  
	Revenue.GPS+  
	Revenue.FPO/2+
	Revenue.Additional_Driver_Charge+ 
    Revenue.All_Seats+ 
	Revenue.Driver_Under_Age+ 
	Revenue.Ski_Rack+ 
	Revenue.Seat_Storage+
	Revenue.Our_Of_Area+
	Revenue.All_Dolly+ 
	Revenue.All_Gates+ 
	Revenue.Blanket+
	Revenue.Snow_Tire+
	Revenue.KPO_Package	
+
	Revenue.Upgrade_Adj+--Revenue.Up_Sell_Adj+
	Revenue.All_Level_LDW_Adj/2+
	--Revenue.Buydown_Adj+
	Revenue.PAI_Adj+ 
	Revenue.PEC_Adj+ 
   	Revenue.ELI_Adj+ 
	Revenue.GPS_Adj+ 
	Revenue.Additional_Driver_Charge_Adj+ 
    Revenue.All_Seats_Adj+ 
	Revenue.Driver_Under_Age_Adj+ 
	Revenue.Ski_Rack_Adj+ 
	Revenue.Seat_Storage_Adj+
	Revenue.Our_Of_Area_Adj+
	Revenue.All_Dolly_Adj+ 
	Revenue.All_Gates_Adj+ 
	Revenue.Blanket_Adj+
	Revenue.Snow_Tire_Adj+
	Revenue.KPO_Package_Adj	


as PayoutRevenue,

	
       Convert(decimal (6, 2),
	(Revenue.Upgrade+--Revenue.Up_Sell+
	Revenue.All_Level_LDW+
	--Revenue.Buydown+
	Revenue.PAI+ 
	Revenue.PEC+ 
    Revenue.ELI+ 
	Revenue.GPS+  
	Revenue.FPO/2+
	Revenue.Additional_Driver_Charge+ 
    Revenue.All_Seats+ 
	Revenue.Driver_Under_Age+ 
	Revenue.Ski_Rack+
	Revenue.Seat_Storage+
	Revenue.Our_Of_Area+ 
	Revenue.All_Dolly+ 
	Revenue.All_Gates+ 
	Revenue.Blanket+
	Revenue.Snow_Tire+
	Revenue.KPO_Package	
+
	Revenue.Upgrade_Adj+--Revenue.Up_Sell_Adj+
	Revenue.All_Level_LDW_Adj+
	--Revenue.Buydown_Adj+
	Revenue.PAI_Adj+ 
	Revenue.PEC_Adj+ 
   	Revenue.ELI_Adj+ 
	Revenue.GPS_Adj+ 
	Revenue.Additional_Driver_Charge_Adj+ 
    Revenue.All_Seats_Adj+ 
	Revenue.Driver_Under_Age_Adj+ 
	Revenue.Ski_Rack_Adj+ 
	Revenue.Seat_Storage_Adj+
	Revenue.Our_Of_Area_Adj+
	Revenue.All_Dolly_Adj+ 
	Revenue.All_Gates_Adj+ 
	Revenue.Blanket_Adj+
	Revenue.Snow_Tire_Adj+
	Revenue.KPO_Package_Adj	

)/
	(case when Revenue.Rental_Days>0 
	      then Revenue.Rental_Days
	      else 1
	 end)



        )
        as SalesItemDDA,
	Sales_Yield_Tiers.Commission as SalesItemCommission,  


        Revenue.Walkup_Rental_Days, 
	Revenue.Walkup_TnM, 
        
	Convert(decimal (6, 2),
	        (Walkup_TnM/
			(case when Walkup_Rental_Days>0 
			      then Walkup_Rental_Days
			      else 1
			 end)
		)
	)
	 as WalkUpDDA,
	Average_WalkUp_DDA,
	(case when Revenue.Location_id  <>16 then 
                  Convert(decimal (6, 2),
		        (Walkup_TnM/
				(case when Walkup_Rental_Days>0 
				      then Walkup_Rental_Days
				      else 1
				 end)
			)
		  )-Average_WalkUp_DDA
	      else 0
         end) as Above_Average_DDA,

 	/*Walkup_Yield_Tiers.Payout_Tier_Start,
        Walkup_Yield_Tiers.Payout_Tier_End,
	*/

	Walkup_Yield_Tiers.Commission AS WalkupTnMCommission,
        Walkup_Count,
	
     Revenue.FPO_Contract_Count, 
	Revenue.FPOCount+Revenue.FPOCount_Adj as FPOCount,
        convert(decimal(5,2),
		Round(
			( 
				Convert(decimal (6, 2),Revenue.FPOCount+Revenue.FPOCount_Adj )
			  	/
			  	Convert(decimal (6, 2),
				  	(case when Revenue.FPO_Contract_Count>0 
					      then Revenue.FPO_Contract_Count
					      else 1
					 end)
				  
			         )
			   
			 )*100
		,0)
		) as FPOMarketSaturation,
	FPO_Payout_Rate.Payout_Rate,

	Convert(decimal (5, 2),
	        (
		 (Revenue.Upgrade+Revenue.Upgrade_Adj)/(case when Revenue.Rental_Days>0 
			      	then Revenue.Rental_Days
			      	else 1
			 	end) 
		)
	)
	 as UpgradeDDA,

/*Upgrade_Yield_Tiers.Payout_Tier_Start,
Upgrade_Yield_Tiers.Payout_Tier_End,
*/
         
Upgrade_Yield_Tiers.Commission AS UpgradeCommission,

Convert(decimal (5, 2),
	        (
		 (Revenue.All_Level_LDW+Revenue.All_Level_LDW_Adj)/
				(case when Revenue.Rental_Days>0 
			      	then Revenue.Rental_Days
			      	else 1
			 	end) 
		)
	)
	 as LDWDDA,

LDW_Yield_Tiers.Commission AS LDWCommission,
Upgrade_Count, 
All_Seats_Count, 
All_LDW_Count, 
--Buydown_Count,
PAI_Count,   
PEC_Count,   
ELI_Count,   
Additional_Driver_Count, 
Other_Extra_Count,
Snow_Tire_Count,
SR.amount as SRAmount








FROM         dbo.RP_ACC_17_CSR_Incremental_Incentive_Revenue Revenue 
		      INNER JOIN 
		      dbo.RP_Acc_17_CSR_Incremental_Walkup_Average_DDA Walkup_Average_DDA
                      ON Revenue.Location_ID = Walkup_Average_DDA.Location_ID and Revenue.RBR_Date = Walkup_Average_DDA.RBR_Date  
                      INNER JOIN
                      dbo.CSR_Incentive_Location_FPO_Payout_Rates FPO_Payout_Rate 
		      ON Revenue.Location_ID = FPO_Payout_Rate.Location_ID AND Revenue.Vehicle_Type_ID = FPO_Payout_Rate.Vehicle_Type 
		      INNER JOIN
                      dbo.CSR_Incentive_Location_Inscr_Yield Sales_Yield_Tiers ON Revenue.Location_ID = Sales_Yield_Tiers.Location_ID AND 
                      Revenue.Vehicle_Type_ID = Sales_Yield_Tiers.Vehicle_Type  and Sales_Yield_Tiers.Yield_Type='Sales' 
		      INNER JOIN
                      dbo.CSR_Incentive_Location_Inscr_Yield Walkup_Yield_Tiers ON Revenue.Location_ID = Walkup_Yield_Tiers.Location_ID AND 
                      Revenue.Vehicle_Type_ID = Walkup_Yield_Tiers.Vehicle_Type and Walkup_Yield_Tiers.Yield_Type='Walkup'
		      INNER JOIN
                      dbo.CSR_Incentive_Location_Inscr_Yield Upgrade_Yield_Tiers ON Revenue.Location_ID = Upgrade_Yield_Tiers.Location_ID AND 
                      Revenue.Vehicle_Type_ID = Upgrade_Yield_Tiers.Vehicle_Type and Upgrade_Yield_Tiers.Yield_Type='Upgrade'
			 INNER JOIN
                      dbo.CSR_Incentive_Location_Inscr_Yield LDW_Yield_Tiers ON Revenue.Location_ID = LDW_Yield_Tiers.Location_ID AND 
                      Revenue.Vehicle_Type_ID = LDW_Yield_Tiers.Vehicle_Type and LDW_Yield_Tiers.Yield_Type='LDW'
             Inner Join GISUsers
                      on   rtrim(ltrim(replace(Revenue.CSR_Name,' (T)','')))
					   =left(ltrim(GISUsers.user_name),20)
					  
					  --=rtrim(ltrim(GISUsers.User_name))
			left join (select	SR1.location,
								SR1.sold_by as CSR_Name,
								sum(amount) as amount
						from RP_Acc_24_CSR_SalesAcc_Revenue SR1
						where SR1.RBR_Date BETWEEN @startBusDate and @endBusDate
								and (sales_accessory not like '%Toll%' and sales_accessory not like '%Parking%')
						 group by SR1.location,SR1.sold_by
						) SR  on SR.location=Revenue.location and SR.CSR_Name=Revenue.CSR_Name



where 	(@paramVehicleTypeID = '*' OR Revenue.Vehicle_Type_ID = @paramVehicleTypeID)
and	(@paramPickUpLocationID = '*' or CONVERT(INT, @tmpLocID) = Revenue.Location_ID)
and 	(Revenue.RBR_Date BETWEEN @startBusDate and @endBusDate) 

and     (convert	
		(
			decimal(5,2),
			
			(Revenue.Upgrade+--Revenue.Up_Sell+
			Revenue.All_Level_LDW+
			--Revenue.Buydown+
			Revenue.PAI+ 
			Revenue.PEC+
           	Revenue.ELI+
			Revenue.GPS+  
			Revenue.FPO/2+    
			Revenue.Additional_Driver_Charge+ 
		    Revenue.All_Seats+ 
			Revenue.Driver_Under_Age+ 
			Revenue.Ski_Rack+
			Revenue.Seat_Storage+
			Revenue.Our_Of_Area+ 
			Revenue.All_Dolly+ 
			Revenue.All_Gates+ 
			Revenue.Blanket+
			Revenue.Snow_Tire+
			Revenue.KPO_Package	
		+
			Revenue.Upgrade_Adj+--Revenue.Up_Sell_Adj+
			Revenue.All_Level_LDW_Adj+
			--Revenue.Buydown_Adj+
			Revenue.PAI_Adj+ 
			Revenue.PEC_Adj+ 
   			Revenue.ELI_Adj+ 
			Revenue.GPS_Adj+ 
			Revenue.Additional_Driver_Charge_Adj+ 
			Revenue.All_Seats_Adj+ 
			Revenue.Driver_Under_Age_Adj+ 
			Revenue.Ski_Rack_Adj+ 
			Revenue.Seat_Storage_Adj+
			Revenue.Our_Of_Area_Adj+
			Revenue.All_Dolly_Adj+ 
			Revenue.All_Gates_Adj+ 
			Revenue.Blanket_Adj+
			Revenue.Snow_Tire_Adj+
			Revenue.KPO_Package_Adj	
			)/
			(case when Revenue.Rental_Days>0 
			      then Revenue.Rental_Days
			      else 1
			 end)
		 )
	)>=Sales_Yield_Tiers.Payout_Tier_Start 

and 	(convert
		(
			decimal(5,2),
			(Revenue.Upgrade+--Revenue.Up_Sell+
			Revenue.All_Level_LDW+
			--Revenue.Buydown+
			Revenue.PAI+ 
			Revenue.PEC+ 
		        Revenue.ELI+ 
			Revenue.GPS+  
			Revenue.FPO/2+
			Revenue.Additional_Driver_Charge+ 
		        Revenue.All_Seats+ 
			Revenue.Driver_Under_Age+ 
			Revenue.Ski_Rack+
			Revenue.Seat_Storage+
			Revenue.Our_Of_Area+ 
			Revenue.All_Dolly+ 
			Revenue.All_Gates+ 
			Revenue.Blanket+
			Revenue.Snow_Tire+
			Revenue.KPO_Package	
		+
			Revenue.Upgrade_Adj+--Revenue.Up_Sell_Adj+
			Revenue.All_Level_LDW_Adj+
			--Revenue.Buydown_Adj+
			Revenue.PAI_Adj+ 
			Revenue.PEC_Adj+ 
   			Revenue.ELI_Adj+ 
			Revenue.GPS_Adj+ 
			Revenue.Additional_Driver_Charge_Adj+ 
			Revenue.All_Seats_Adj+ 
			Revenue.Driver_Under_Age_Adj+ 
			Revenue.Ski_Rack_Adj+ 
			Revenue.Seat_Storage_Adj+
			Revenue.Our_Of_Area_Adj+
			Revenue.All_Dolly_Adj+ 
			Revenue.All_Gates_Adj+ 
			Revenue.Blanket_Adj+
			Revenue.Snow_Tire_Adj+
			Revenue.KPO_Package_Adj	
			)/
			(case when Revenue.Rental_Days>0 
			      then Revenue.Rental_Days
			      else 1
			 end)
		)
	)<=Sales_Yield_Tiers.Payout_Tier_End


and 	Convert(decimal (6, 2),
	        (Walkup_TnM/
			(case when Walkup_Rental_Days>0 
			      then Walkup_Rental_Days
			      else 1
			 end)
		)
	)

	 >=Walkup_Yield_Tiers.Payout_Tier_Start

and 	Convert(decimal (6, 2),
	        (Walkup_TnM/
			(case when Walkup_Rental_Days>0 
			      then Walkup_Rental_Days
			      else 1
			 end)
		)
	)
	 <= Walkup_Yield_Tiers.Payout_Tier_End






--upgrade dda

and 	(
		Convert(decimal (5, 2),
		        (
			 Revenue.Upgrade/(case when Revenue.Rental_Days>0 
				      	then Revenue.Rental_Days
				      	else 1
				 	end) 
			)
		)
	)>=Upgrade_Yield_Tiers.Payout_Tier_Start

and 	(
		Convert(decimal (5, 2),
		        (
			 Revenue.Upgrade/(case when Revenue.Rental_Days>0 
				      	then Revenue.Rental_Days
				      	else 1
				 	end) 
			)
		)
		
	) <= Upgrade_Yield_Tiers.Payout_Tier_End


---end of upgrade dda


--LDW dda

and 	(
		Convert(decimal (5, 2),
		        (
					 (Revenue.All_Level_LDW+Revenue.All_Level_LDW_Adj)/
					 (case when Revenue.Rental_Days>0 
				      	then Revenue.Rental_Days
				      	else 1
				 	end) 
			)
		)
	)>=LDW_Yield_Tiers.Payout_Tier_Start

and 	(
		Convert(decimal (5, 2),
		        (
					(Revenue.All_Level_LDW+Revenue.All_Level_LDW_Adj)/
					(case when Revenue.Rental_Days>0 
				      	then Revenue.Rental_Days
				      	else 1
				 	end) 
			)
		)
		
	) <= LDW_Yield_Tiers.Payout_Tier_End

---end of LDW dda



and 	(
		convert(
			decimal(5,2),
			Round(
				( 
					Convert(decimal (6, 2),Revenue.FPOCount+Revenue.FPOCount_Adj)
				  	/
				  	Convert(decimal (6, 2),
					  	(case when Revenue.FPO_Contract_Count>0 
						      then Revenue.FPO_Contract_Count
						      else 1
						 end)
					  
				         )
				   
				 )*100
			,0)

		)>= FPO_Payout_Rate.Market_Saturation_Start
	)

and     (convert(decimal(5,2),
		Round(
			( 
				Convert(decimal (6, 2),Revenue.FPOCount+Revenue.FPOCount_Adj)
			  	/
			  	Convert(decimal (6, 2),
				  	(case when Revenue.FPO_Contract_Count>0 
					      then Revenue.FPO_Contract_Count
					      else 1
					 end)
				  
			         )
			   
			 )*100
		,0)
	)<= FPO_Payout_Rate.Market_Saturation_End)

and 	(Revenue.RBR_Date BETWEEN FPO_Payout_Rate.Effective_Date and  FPO_Payout_Rate.Terminate_Date) 
and 	(Revenue.RBR_Date BETWEEN  Sales_Yield_Tiers.Effective_Date and Sales_Yield_Tiers.Terminate_Date) 
and  	(Revenue.RBR_Date BETWEEN Walkup_Yield_Tiers.Effective_Date and Walkup_Yield_Tiers.Terminate_Date) 
and 	(Revenue.RBR_Date BETWEEN Upgrade_Yield_Tiers.Effective_Date and Upgrade_Yield_Tiers.Terminate_Date) 
and 	(Revenue.RBR_Date BETWEEN LDW_Yield_Tiers.Effective_Date and LDW_Yield_Tiers.Terminate_Date) 
--and 	(Revenue.CSR_Name Not LIKE '%FB')
--and 	(Revenue.CSR_Name Not LIKE '%FB(T)')
--and Revenue.CSR_Name Not LIKE '%Ramandeep Johal'     
and 	(Revenue.CSR_Name  Not  LIKE '%(T)') -- and Revenue.CSR_Name<>'Bilal Dabir')
And (Revenue.CSR_Name  Not  LIKE 'trainee%')
--and		(GISUsers.Hiring_date<'2015-04-15' or GISUsers.Hiring_date>='2015-09-01' or GISUsers.Hiring_date is null )
) CSRIncentive

order by 

(Case   
	When @SortBy='Rental_Days' Then   Rental_Days
	When @SortBy='Upgrade' Then Upgrade
	When @SortBy='All_Level_LDW' Then All_Level_LDW
	--When @SortBy='Buydown' Then Buydown
	When @SortBy='PAE' Then PAI
	When @SortBy='RSN' Then PEC
	When @SortBy='ELI' Then ELI
	When @SortBy='GSO' Then FPO
	When @SortBy='Additional_Driver_Charge' Then Additional_Driver_Charge
	When @SortBy='All_Seats' Then All_Seats
	When @SortBy='Other_Extra' Then Driver_Under_Age
									+Ski_Rack
									+Seat_Storage
									+Our_Of_Area
									+All_Dolly
									+All_Gates
									+Blanket
									+GPS
									+KPO_Package

	When @SortBy='SalesItemRevenue' Then SalesItemRevenue
	When @SortBy='PayoutRevenue' Then PayoutRevenue
	When @SortBy='SalesItemDDA' Then SalesItemDDA
	When @SortBy='Sales_Payout' Then PayoutRevenue*SalesItemCommission/100.00
	When @SortBy='Walkup_Rental_Days' Then Walkup_Rental_Days
	When @SortBy='Walkup_TnM' Then Walkup_TnM
	When @SortBy='WalkUpDDA' Then WalkUpDDA
	When @SortBy='Walkup_Payout' Then Walkup_TnM*WalkupTnMCommission/100.00
	When @SortBy='Walkup_Count' Then Walkup_Count
	When @SortBy='Estimated_Payout' Then  PayoutRevenue*SalesItemCommission/100.00+Walkup_TnM*WalkupTnMCommission/100.00
End)
DESC

/*

union 

SELECT 	Revenue.Location, 
	Revenue.Vehicle_Type_ID, 
	Revenue.EmployeeID, 
	Revenue.EmployeeStatus, 
	Revenue.CSR_Name, 
	Revenue.Contract_In, 
   	 Revenue.Rental_Days, 
	Revenue.Upgrade +Revenue.Upgrade_Adj As Upgrade,--  +Revenue.Up_Sell+Revenue.Up_Sell_Adj 
	Revenue.All_Level_LDW+Revenue.All_Level_LDW_Adj as All_Level_LDW, 
	Revenue.Buydown + Revenue.Buydown_Adj as Buydown,
	Revenue.PAI+Revenue.PAI_Adj As PAI, 
	Revenue.PEC+Revenue.PEC_Adj As PEC, 
    Revenue.ELI+Revenue.ELI_Adj As ELI,
    Revenue.GPS +Revenue.GPS_Adj As GPS, 
    Revenue.FPO  As FPO, 
	Revenue.Additional_Driver_Charge+Revenue.Additional_Driver_Charge_Adj As Additional_Driver_Charge, 
    Revenue.All_Seats+Revenue.All_Seats_Adj As All_Seats, 
	Revenue.Driver_Under_Age+Revenue.Driver_Under_Age_Adj As Driver_Under_Age, 
	Revenue.Ski_Rack+Revenue.Ski_Rack_Adj As Ski_Rack, 
	Revenue.Seat_Storage +Revenue.Seat_Storage_Adj As Seat_Storage,
	Revenue.Our_Of_Area +Revenue.Our_Of_Area_Adj As Our_Of_Area,
	Revenue.All_Dolly +Revenue.All_Dolly_Adj As All_Dolly, 
	Revenue.All_Gates+Revenue.All_Gates_Adj As  All_Gates, 
	Revenue.Blanket+Revenue.Blanket_Adj as Blanket, 
	Revenue.Snow_Tire+Revenue.Snow_Tire_Adj as Snow_Tire, 
	Revenue.KPO_Package+Revenue.KPO_Package_Adj as KPO_Package, 

	Revenue.Upgrade+--Revenue.Up_Sell+
	Revenue.All_Level_LDW+
	Revenue.Buydown+
	Revenue.PAI+ 
	Revenue.PEC+ 
   	Revenue.ELI+ 
	Revenue.GPS+ 
	Revenue.FPO+
	Revenue.Additional_Driver_Charge+ 
    Revenue.All_Seats+ 
	Revenue.Driver_Under_Age+ 
	Revenue.Ski_Rack+ 
	Revenue.Seat_Storage+
	Revenue.Our_Of_Area+
	Revenue.All_Dolly+ 
	Revenue.All_Gates+ 
	Revenue.Blanket+
	Revenue.Snow_Tire+
	Revenue.KPO_Package	
+
	Revenue.Upgrade_Adj+--Revenue.Up_Sell_Adj+
	Revenue.All_Level_LDW_Adj+
	Revenue.Buydown_Adj+
	Revenue.PAI_Adj+ 
	Revenue.PEC_Adj+ 
   	Revenue.ELI_Adj+ 
	Revenue.GPS_Adj+ 
	Revenue.Additional_Driver_Charge_Adj+ 
    Revenue.All_Seats_Adj+ 
	Revenue.Driver_Under_Age_Adj+ 
	Revenue.Ski_Rack_Adj+ 
	Revenue.Seat_Storage_Adj+
	Revenue.Our_Of_Area_Adj+
	Revenue.All_Dolly_Adj+ 
	Revenue.All_Gates_Adj+ 
	Revenue.Blanket_Adj+
	Revenue.Snow_Tire_Adj+
	Revenue.KPO_Package_Adj

as SalesItemRevenue,

	Revenue.Upgrade +-- Revenue.Up_Sell+
	Revenue.All_Level_LDW/2+
	Revenue.Buydown+
	Revenue.PAI+ 
	Revenue.PEC+
    Revenue.ELI+  
	Revenue.GPS+  
	Revenue.FPO/2+
	Revenue.Additional_Driver_Charge+ 
    Revenue.All_Seats+ 
	Revenue.Driver_Under_Age+ 
	Revenue.Ski_Rack+ 
	Revenue.Seat_Storage+
	Revenue.Our_Of_Area+
	Revenue.All_Dolly+ 
	Revenue.All_Gates+ 
	Revenue.Blanket+
	Revenue.Snow_Tire+
	Revenue.KPO_Package	
+
	Revenue.Upgrade_Adj+--Revenue.Up_Sell_Adj+
	Revenue.All_Level_LDW_Adj/2+
	Revenue.Buydown_Adj+
	Revenue.PAI_Adj+ 
	Revenue.PEC_Adj+ 
   	Revenue.ELI_Adj+ 
	Revenue.GPS_Adj+ 
	Revenue.Additional_Driver_Charge_Adj+ 
    Revenue.All_Seats_Adj+ 
	Revenue.Driver_Under_Age_Adj+ 
	Revenue.Ski_Rack_Adj+ 
	Revenue.Seat_Storage_Adj+
	Revenue.Our_Of_Area_Adj+
	Revenue.All_Dolly_Adj+ 
	Revenue.All_Gates_Adj+ 
	Revenue.Blanket_Adj+
	Revenue.Snow_Tire_Adj+
	Revenue.KPO_Package_Adj	


as PayoutRevenue,

	
       Convert(decimal (6, 2),
	(Revenue.Upgrade+--Revenue.Up_Sell+
	Revenue.All_Level_LDW+
	Revenue.Buydown+
	Revenue.PAI+ 
	Revenue.PEC+ 
    Revenue.ELI+ 
	Revenue.GPS+  
	Revenue.FPO/2+
	Revenue.Additional_Driver_Charge+ 
    Revenue.All_Seats+ 
	Revenue.Driver_Under_Age+ 
	Revenue.Ski_Rack+
	Revenue.Seat_Storage+
	Revenue.Our_Of_Area+ 
	Revenue.All_Dolly+ 
	Revenue.All_Gates+ 
	Revenue.Blanket+
	Revenue.Snow_Tire+
	Revenue.KPO_Package	
+
	Revenue.Upgrade_Adj+--Revenue.Up_Sell_Adj+
	Revenue.All_Level_LDW_Adj+
	Revenue.Buydown_Adj+
	Revenue.PAI_Adj+ 
	Revenue.PEC_Adj+ 
   	Revenue.ELI_Adj+ 
	Revenue.GPS_Adj+ 
	Revenue.Additional_Driver_Charge_Adj+ 
    Revenue.All_Seats_Adj+ 
	Revenue.Driver_Under_Age_Adj+ 
	Revenue.Ski_Rack_Adj+ 
	Revenue.Seat_Storage_Adj+
	Revenue.Our_Of_Area_Adj+
	Revenue.All_Dolly_Adj+ 
	Revenue.All_Gates_Adj+ 
	Revenue.Blanket_Adj+
	Revenue.Snow_Tire_Adj+
	Revenue.KPO_Package_Adj	

)/
	(case when Revenue.Rental_Days>0 
	      then Revenue.Rental_Days
	      else 1
	 end)



        )
        as SalesItemDDA,
	Sales_Yield_Tiers.Commission*0.75 as SalesItemCommission,  


        Revenue.Walkup_Rental_Days, 
	Revenue.Walkup_TnM, 
        
	Convert(decimal (6, 2),
	        (Walkup_TnM/
			(case when Walkup_Rental_Days>0 
			      then Walkup_Rental_Days
			      else 1
			 end)
		)
	)
	 as WalkUpDDA,
	Average_WalkUp_DDA,
	(case when Revenue.Location_id  <>16 then 
                  Convert(decimal (6, 2),
		        (Walkup_TnM/
				(case when Walkup_Rental_Days>0 
				      then Walkup_Rental_Days
				      else 1
				 end)
			)
		  )-Average_WalkUp_DDA
	      else 0
         end) as Above_Average_DDA,

 	/*Walkup_Yield_Tiers.Payout_Tier_Start,
        Walkup_Yield_Tiers.Payout_Tier_End,
	*/

	Walkup_Yield_Tiers.Commission*0.75 AS WalkupTnMCommission,
        Walkup_Count,
	
     Revenue.FPO_Contract_Count, 
	Revenue.FPOCount+Revenue.FPOCount_Adj as FPOCount,
        convert(decimal(5,2),
		Round(
			( 
				Convert(decimal (6, 2),Revenue.FPOCount+Revenue.FPOCount_Adj )
			  	/
			  	Convert(decimal (6, 2),
				  	(case when Revenue.FPO_Contract_Count>0 
					      then Revenue.FPO_Contract_Count
					      else 1
					 end)
				  
			         )
			   
			 )*100
		,0)
		) as FPOMarketSaturation,
	FPO_Payout_Rate.Payout_Rate*0.75,

	Convert(decimal (5, 2),
	        (
		 (Revenue.Upgrade+Revenue.Upgrade_Adj)/(case when Revenue.Rental_Days>0 
			      	then Revenue.Rental_Days
			      	else 1
			 	end) 
		)
	)
	 as UpgradeDDA,

/*Upgrade_Yield_Tiers.Payout_Tier_Start,
Upgrade_Yield_Tiers.Payout_Tier_End,
*/
         
Upgrade_Yield_Tiers.Commission*0.75 AS UpgradeCommission,

Convert(decimal (5, 2),
	        (
		 (Revenue.All_Level_LDW+Revenue.All_Level_LDW_Adj)/
				(case when Revenue.Rental_Days>0 
			      	then Revenue.Rental_Days
			      	else 1
			 	end) 
		)
	)
	 as LDWDDA,

LDW_Yield_Tiers.Commission*0.75 AS LDWCommission,
Upgrade_Count, 
All_Seats_Count, 
All_LDW_Count, 
Buydown_Count,
PAI_Count,   
PEC_Count,   
ELI_Count,   
Additional_Driver_Count, 
Other_Extra_Count,
Snow_Tire_Count,
SR.amount as SRAmount

FROM         dbo.RP_ACC_17_CSR_Incremental_Incentive_Revenue Revenue 
		      INNER JOIN 
		      dbo.RP_Acc_17_CSR_Incremental_Walkup_Average_DDA Walkup_Average_DDA
                      ON Revenue.Location_ID = Walkup_Average_DDA.Location_ID and Revenue.RBR_Date = Walkup_Average_DDA.RBR_Date  
                      INNER JOIN
                      dbo.CSR_Incentive_Location_FPO_Payout_Rates FPO_Payout_Rate 
		      ON Revenue.Location_ID = FPO_Payout_Rate.Location_ID AND Revenue.Vehicle_Type_ID = FPO_Payout_Rate.Vehicle_Type 
		      INNER JOIN
                      dbo.CSR_Incentive_Location_Inscr_Yield Sales_Yield_Tiers ON Revenue.Location_ID = Sales_Yield_Tiers.Location_ID AND 
                      Revenue.Vehicle_Type_ID = Sales_Yield_Tiers.Vehicle_Type  and Sales_Yield_Tiers.Yield_Type='Sales' 
		      INNER JOIN
                      dbo.CSR_Incentive_Location_Inscr_Yield Walkup_Yield_Tiers ON Revenue.Location_ID = Walkup_Yield_Tiers.Location_ID AND 
                      Revenue.Vehicle_Type_ID = Walkup_Yield_Tiers.Vehicle_Type and Walkup_Yield_Tiers.Yield_Type='Walkup'
		      INNER JOIN
                      dbo.CSR_Incentive_Location_Inscr_Yield Upgrade_Yield_Tiers ON Revenue.Location_ID = Upgrade_Yield_Tiers.Location_ID AND 
                      Revenue.Vehicle_Type_ID = Upgrade_Yield_Tiers.Vehicle_Type and Upgrade_Yield_Tiers.Yield_Type='Upgrade'
			 INNER JOIN
                      dbo.CSR_Incentive_Location_Inscr_Yield LDW_Yield_Tiers ON Revenue.Location_ID = LDW_Yield_Tiers.Location_ID AND 
                      Revenue.Vehicle_Type_ID = LDW_Yield_Tiers.Vehicle_Type and LDW_Yield_Tiers.Yield_Type='LDW'
             Inner Join GISUsers
                      on   rtrim(ltrim(replace(Revenue.CSR_Name,' (T)','')))=rtrim(ltrim(GISUsers.User_name))--Revenue.CSR_Name=GISUsers.User_name
			left join (select	SR1.location,
								SR1.sold_by as CSR_Name,
								sum(amount) as amount
						from RP_Acc_24_CSR_SalesAcc_Revenue SR1
						where SR1.RBR_Date BETWEEN @startBusDate and @endBusDate
								and (sales_accessory not like '%Toll%' and sales_accessory not like '%Parking%')
						 group by SR1.location,SR1.sold_by
						) SR  on SR.location=Revenue.location and SR.CSR_Name=Revenue.CSR_Name



where 	(@paramVehicleTypeID = '*' OR Revenue.Vehicle_Type_ID = @paramVehicleTypeID)
and	(@paramPickUpLocationID = '*' or CONVERT(INT, @tmpLocID) = Revenue.Location_ID)
and 	(Revenue.RBR_Date BETWEEN @startBusDate and @endBusDate) 

and     (convert	
		(
			decimal(5,2),
			
			(Revenue.Upgrade+--Revenue.Up_Sell+
			Revenue.All_Level_LDW+
			Revenue.Buydown+
			Revenue.PAI+ 
			Revenue.PEC+
           	Revenue.ELI+
			Revenue.GPS+  
			Revenue.FPO/2+    
			Revenue.Additional_Driver_Charge+ 
		    Revenue.All_Seats+ 
			Revenue.Driver_Under_Age+ 
			Revenue.Ski_Rack+
			Revenue.Seat_Storage+
			Revenue.Our_Of_Area+ 
			Revenue.All_Dolly+ 
			Revenue.All_Gates+ 
			Revenue.Blanket+
			Revenue.Snow_Tire+
			Revenue.KPO_Package	
		+
			Revenue.Upgrade_Adj+--Revenue.Up_Sell_Adj+
			Revenue.All_Level_LDW_Adj+
			Revenue.Buydown_Adj+
			Revenue.PAI_Adj+ 
			Revenue.PEC_Adj+ 
   			Revenue.ELI_Adj+ 
			Revenue.GPS_Adj+ 
			Revenue.Additional_Driver_Charge_Adj+ 
			Revenue.All_Seats_Adj+ 
			Revenue.Driver_Under_Age_Adj+ 
			Revenue.Ski_Rack_Adj+ 
			Revenue.Seat_Storage_Adj+
			Revenue.Our_Of_Area_Adj+
			Revenue.All_Dolly_Adj+ 
			Revenue.All_Gates_Adj+ 
			Revenue.Blanket_Adj+
			Revenue.Snow_Tire_Adj+
			Revenue.KPO_Package_Adj	
			)/
			(case when Revenue.Rental_Days>0 
			      then Revenue.Rental_Days
			      else 1
			 end)
		 )
	)>=Sales_Yield_Tiers.Payout_Tier_Start 

and 	(convert
		(
			decimal(5,2),
			(Revenue.Upgrade+--Revenue.Up_Sell+
			Revenue.All_Level_LDW+
			Revenue.Buydown+
			Revenue.PAI+ 
			Revenue.PEC+ 
		        Revenue.ELI+ 
			Revenue.GPS+  
			Revenue.FPO/2+
			Revenue.Additional_Driver_Charge+ 
		        Revenue.All_Seats+ 
			Revenue.Driver_Under_Age+ 
			Revenue.Ski_Rack+
			Revenue.Seat_Storage+
			Revenue.Our_Of_Area+ 
			Revenue.All_Dolly+ 
			Revenue.All_Gates+ 
			Revenue.Blanket+
			Revenue.Snow_Tire+
			Revenue.KPO_Package	
		+
			Revenue.Upgrade_Adj+--Revenue.Up_Sell_Adj+
			Revenue.All_Level_LDW_Adj+
			Revenue.Buydown_Adj+
			Revenue.PAI_Adj+ 
			Revenue.PEC_Adj+ 
   			Revenue.ELI_Adj+ 
			Revenue.GPS_Adj+ 
			Revenue.Additional_Driver_Charge_Adj+ 
			Revenue.All_Seats_Adj+ 
			Revenue.Driver_Under_Age_Adj+ 
			Revenue.Ski_Rack_Adj+ 
			Revenue.Seat_Storage_Adj+
			Revenue.Our_Of_Area_Adj+
			Revenue.All_Dolly_Adj+ 
			Revenue.All_Gates_Adj+ 
			Revenue.Blanket_Adj+
			Revenue.Snow_Tire_Adj+
			Revenue.KPO_Package_Adj	
			)/
			(case when Revenue.Rental_Days>0 
			      then Revenue.Rental_Days
			      else 1
			 end)
		)
	)<=Sales_Yield_Tiers.Payout_Tier_End


and 	Convert(decimal (6, 2),
	        (Walkup_TnM/
			(case when Walkup_Rental_Days>0 
			      then Walkup_Rental_Days
			      else 1
			 end)
		)
	)

	 >=Walkup_Yield_Tiers.Payout_Tier_Start

and 	Convert(decimal (6, 2),
	        (Walkup_TnM/
			(case when Walkup_Rental_Days>0 
			      then Walkup_Rental_Days
			      else 1
			 end)
		)
	)
	 <= Walkup_Yield_Tiers.Payout_Tier_End






--upgrade dda

and 	(
		Convert(decimal (5, 2),
		        (
			 Revenue.Upgrade/(case when Revenue.Rental_Days>0 
				      	then Revenue.Rental_Days
				      	else 1
				 	end) 
			)
		)
	)>=Upgrade_Yield_Tiers.Payout_Tier_Start

and 	(
		Convert(decimal (5, 2),
		        (
			 Revenue.Upgrade/(case when Revenue.Rental_Days>0 
				      	then Revenue.Rental_Days
				      	else 1
				 	end) 
			)
		)
		
	) <= Upgrade_Yield_Tiers.Payout_Tier_End


---end of upgrade dda


--LDW dda

and 	(
		Convert(decimal (5, 2),
		        (
					 (Revenue.All_Level_LDW+Revenue.All_Level_LDW_Adj)/
					 (case when Revenue.Rental_Days>0 
				      	then Revenue.Rental_Days
				      	else 1
				 	end) 
			)
		)
	)>=LDW_Yield_Tiers.Payout_Tier_Start

and 	(
		Convert(decimal (5, 2),
		        (
					(Revenue.All_Level_LDW+Revenue.All_Level_LDW_Adj)/
					(case when Revenue.Rental_Days>0 
				      	then Revenue.Rental_Days
				      	else 1
				 	end) 
			)
		)
		
	) <= LDW_Yield_Tiers.Payout_Tier_End

---end of LDW dda



and 	(
		convert(
			decimal(5,2),
			Round(
				( 
					Convert(decimal (6, 2),Revenue.FPOCount+Revenue.FPOCount_Adj)
				  	/
				  	Convert(decimal (6, 2),
					  	(case when Revenue.FPO_Contract_Count>0 
						      then Revenue.FPO_Contract_Count
						      else 1
						 end)
					  
				         )
				   
				 )*100
			,0)

		)>= FPO_Payout_Rate.Market_Saturation_Start
	)

and     (convert(decimal(5,2),
		Round(
			( 
				Convert(decimal (6, 2),Revenue.FPOCount+Revenue.FPOCount_Adj)
			  	/
			  	Convert(decimal (6, 2),
				  	(case when Revenue.FPO_Contract_Count>0 
					      then Revenue.FPO_Contract_Count
					      else 1
					 end)
				  
			         )
			   
			 )*100
		,0)
	)<= FPO_Payout_Rate.Market_Saturation_End)

and 	(Revenue.RBR_Date BETWEEN FPO_Payout_Rate.Effective_Date and  FPO_Payout_Rate.Terminate_Date) 
and 	(Revenue.RBR_Date BETWEEN  Sales_Yield_Tiers.Effective_Date and Sales_Yield_Tiers.Terminate_Date) 
and  	(Revenue.RBR_Date BETWEEN Walkup_Yield_Tiers.Effective_Date and Walkup_Yield_Tiers.Terminate_Date) 
and 	(Revenue.RBR_Date BETWEEN Upgrade_Yield_Tiers.Effective_Date and Upgrade_Yield_Tiers.Terminate_Date) 
and 	(Revenue.RBR_Date BETWEEN LDW_Yield_Tiers.Effective_Date and LDW_Yield_Tiers.Terminate_Date) 
--and 	(Revenue.CSR_Name Not LIKE '%FB')
--and 	(Revenue.CSR_Name Not LIKE '%FB(T)')
and (Revenue.CSR_Name not LIKE '%Shikhar Shah'     )
and 	(Revenue.CSR_Name Not LIKE '%(T)')
and		(GISUsers.Hiring_date>='2015-04-15' and GISUsers.Hiring_date<'2015-09-01')

order by Vehicle_Type_ID,Revenue.Location,Revenue.CSR_Name


 */
























GO
