USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[PurgeGISRATETABLES]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[PurgeGISRATETABLES]
as

--Process vehicle_Rate table

select distinct  [Rate_ID],
	[Effective_Date]  ,
	[Termination_Date] ,
	[Rate_Name],
	[Location_Fee_Included] ,
	[Rate_Purpose_ID]  ,
	[Upsell] ,
	[Flex_Discount_Allowed] ,
	[Discount_Allowed] ,
	[Referral_Fee_Paid],
	[Commission_Paid]  ,
	[Frequent_Flyer_Plans_Honoured]  ,
	[Km_Drop_Off_Charge]  ,
	[Insurance_Transfer_Allowed]  ,
	[Warranty_Repair_Allowed]  ,
	[Contract_Remarks]  ,
	[Other_Remarks]  ,
	[Special_Restrictions]   ,
	[Manufacturer_ID] ,
	[GST_Included]  ,
	[PST_Included]  ,
	[PVRT_Included] ,
	null as Update_Ctrl  ,
	[Violated_Rate_ID] ,
	[Violated_Rate_Level]   ,
	[Last_Changed_By] ,
	[Last_Changed_On]  ,
	[FPO_Purchased]  ,
	[License_Fee_Included]  
into #vehicle_rate 
from (
select * from vehicle_rate where termination_date>getdate()
union
select vr.* from vehicle_rate vr inner join contract co on vr.rate_id=co.rate_id 
where vr.termination_date>=co.rate_assigned_date and vr.effective_date<=co.rate_assigned_date 
union
select vr.* from vehicle_rate vr inner join reservation re on vr.rate_id=re.rate_id
where vr.termination_date>=re.date_rate_assigned and vr.effective_date <=re.date_rate_assigned
) as x

delete from vehicle_rate

--put data back
set IDENTITY_INSERT vehicle_rate on
insert into vehicle_rate 
 	( [Rate_ID],
	[Effective_Date]  ,
	[Termination_Date] ,
	[Rate_Name],
	[Location_Fee_Included] ,
	[Rate_Purpose_ID]  ,
	[Upsell] ,
	[Flex_Discount_Allowed] ,
	[Discount_Allowed] ,
	[Referral_Fee_Paid],
	[Commission_Paid]  ,
	[Frequent_Flyer_Plans_Honoured]  ,
	[Km_Drop_Off_Charge]  ,
	[Insurance_Transfer_Allowed]  ,
	[Warranty_Repair_Allowed]  ,
	[Contract_Remarks]  ,
	[Other_Remarks]  ,
	[Special_Restrictions]   ,
	[Manufacturer_ID] ,
	[GST_Included]  ,
	[PST_Included]  ,
	[PVRT_Included] ,
	[Update_Ctrl]  ,
	[Violated_Rate_ID] ,
	[Violated_Rate_Level]   ,
	[Last_Changed_By] ,
	[Last_Changed_On]  ,
	[FPO_Purchased]  ,
	[License_Fee_Included]
)
select 
[Rate_ID],
	[Effective_Date]  ,
	[Termination_Date] ,
	[Rate_Name],
	[Location_Fee_Included] ,
	[Rate_Purpose_ID]  ,
	[Upsell] ,
	[Flex_Discount_Allowed] ,
	[Discount_Allowed] ,
	[Referral_Fee_Paid],
	[Commission_Paid]  ,
	[Frequent_Flyer_Plans_Honoured]  ,
	[Km_Drop_Off_Charge]  ,
	[Insurance_Transfer_Allowed]  ,
	[Warranty_Repair_Allowed]  ,
	[Contract_Remarks]  ,
	[Other_Remarks]  ,
	[Special_Restrictions]   ,
	[Manufacturer_ID] ,
	[GST_Included]  ,
	[PST_Included]  ,
	[PVRT_Included] ,
	null  ,
	[Violated_Rate_ID] ,
	[Violated_Rate_Level]   ,
	[Last_Changed_By] ,
	[Last_Changed_On]  ,
	[FPO_Purchased]  ,
	[License_Fee_Included]
 from #vehicle_rate
set IDENTITY_INSERT vehicle_rate off

--Following three tables should be processed together

--Table: Rate_location_Set_Member
select distinct  * into #Rate_location_Set_Member
from (
select * from rate_location_set_member where termination_date>getdate()
union
select vr.* from rate_location_set_member vr inner join contract co on vr.rate_id=co.rate_id 
where vr.termination_date>=co.rate_assigned_date and vr.effective_date<=co.rate_assigned_date 
union
select vr.* from rate_location_set_member vr inner join reservation re on vr.rate_id=re.rate_id
where vr.termination_date>=re.date_rate_assigned and vr.effective_date <=re.date_rate_assigned
) as x

--Table: Rate_drop_off_location
select distinct  * into #Rate_drop_off_location
from (
select * from Rate_drop_off_location where termination_date>getdate()
union
select vr.* from Rate_drop_off_location vr inner join contract co on vr.rate_id=co.rate_id 
where vr.termination_date>=co.rate_assigned_date and vr.effective_date<=co.rate_assigned_date 
union
select vr.* from Rate_drop_off_location vr inner join reservation re on vr.rate_id=re.rate_id
where vr.termination_date>=re.date_rate_assigned and vr.effective_date <=re.date_rate_assigned
) as x

--Table: Rate_location_set
select distinct  * into #Rate_location_set
from (
select * from Rate_location_set where termination_date>getdate()
union
select vr.* from Rate_location_set vr inner join contract co on vr.rate_id=co.rate_id 
where vr.termination_date>=co.rate_assigned_date and vr.effective_date<=co.rate_assigned_date 
union
select vr.* from Rate_location_set vr inner join reservation re on vr.rate_id=re.rate_id
where vr.termination_date>=re.date_rate_assigned and vr.effective_date <=re.date_rate_assigned
) as x


--Delete three tables
delete from Rate_drop_off_location
delete from Rate_location_Set_Member
delete from Rate_location_set   --deleted last

--put data back to three tables

set IDENTITY_INSERT  Rate_Location_Set  on
Insert into Rate_Location_Set (
	[Rate_ID] ,
	[Effective_Date]  ,
	[Termination_Date]  ,
	[Rate_Location_Set_ID]  ,
	[Km_Cap] ,
	[Per_Km_Charge]  ,
	[Flat_Surcharge]  ,
	[Daily_Surcharge]  ,
	[Allow_All_Auth_Drop_Off_Locs] ,
	[Override_Km_Cap_Flag] 
)    
select * from #Rate_Location_Set   --insert first
set IDENTITY_INSERT  Rate_Location_Set  off

insert into Rate_Location_Set_Member
select * from #Rate_Location_Set_Member

insert into Rate_drop_off_location
select * from #Rate_drop_off_location

--Following two tables should be processed together

--Table: Rate_Charge_Amount
select distinct  * into #Rate_Charge_Amount
from (
select * from Rate_Charge_Amount where termination_date>getdate()
union
select vr.* from Rate_Charge_Amount vr inner join contract co on vr.rate_id=co.rate_id 
where vr.termination_date>=co.rate_assigned_date and vr.effective_date<=co.rate_assigned_date 
union
select vr.* from Rate_Charge_Amount vr inner join reservation re on vr.rate_id=re.rate_id
where vr.termination_date>=re.date_rate_assigned and vr.effective_date <=re.date_rate_assigned
) as x

--Table: Rate_Vehicle_Class
select distinct  * into #Rate_Vehicle_Class
from (
select * from Rate_Vehicle_Class where termination_date>getdate()
union
select vr.* from Rate_Vehicle_Class vr inner join contract co on vr.rate_id=co.rate_id 
where vr.termination_date>=co.rate_assigned_date and vr.effective_date<=co.rate_assigned_date 
union
select vr.* from Rate_Vehicle_Class vr inner join reservation re on vr.rate_id=re.rate_id
where vr.termination_date>=re.date_rate_assigned and vr.effective_date <=re.date_rate_assigned
) as x


--Delete two tables
delete from Rate_Charge_Amount
delete from Rate_Vehicle_Class   --deleted last

--put data back to two tables
set IDENTITY_INSERT  Rate_Vehicle_Class  on
Insert into Rate_Vehicle_Class 
(
[Rate_Vehicle_Class_ID]  ,
	[Rate_ID]  ,
	[Effective_Date]  ,
	[Termination_Date]  ,
	[Vehicle_Class_Code],
	[Per_KM_Charge] 
)  
select * from #Rate_Vehicle_Class   --insert first
set IDENTITY_INSERT  Rate_Vehicle_Class  off

insert into Rate_Charge_Amount
select * from #Rate_Charge_Amount

--following tables have no relationships

--table Rate_Restriction 
select distinct  * into #Rate_Restriction 
from (
select * from Rate_Restriction  where termination_date>getdate()
union
select vr.* from Rate_Restriction vr inner join contract co on vr.rate_id=co.rate_id 
where vr.termination_date>=co.rate_assigned_date and vr.effective_date<=co.rate_assigned_date 
union
select vr.* from Rate_Restriction  vr inner join reservation re on vr.rate_id=re.rate_id
where vr.termination_date>=re.date_rate_assigned and vr.effective_date <=re.date_rate_assigned
) as x

delete from Rate_Restriction 

insert into Rate_Restriction 
select * from #Rate_Restriction 


--Table: Rate_Availability

select distinct  * into #Rate_Availability
from (
select * from Rate_Availability  where termination_date>getdate()
union
select vr.* from Rate_Availability vr inner join contract co on vr.rate_id=co.rate_id 
where vr.termination_date>=co.rate_assigned_date and vr.effective_date<=co.rate_assigned_date 
union
select vr.* from Rate_Availability  vr inner join reservation re on vr.rate_id=re.rate_id
where vr.termination_date>=re.date_rate_assigned and vr.effective_date <=re.date_rate_assigned
) as x

delete from Rate_Availability

insert into Rate_Availability 
select * from #Rate_Availability


--Table: Rate_Level

select distinct  * into #Rate_Level
from (
select * from Rate_Level  where termination_date>getdate()
union
select vr.* from Rate_Level vr inner join contract co on vr.rate_id=co.rate_id 
where vr.termination_date>=co.rate_assigned_date and vr.effective_date<=co.rate_assigned_date 
union
select vr.* from Rate_Level  vr inner join reservation re on vr.rate_id=re.rate_id
where vr.termination_date>=re.date_rate_assigned and vr.effective_date <=re.date_rate_assigned
) as x

delete from Rate_Level

insert into Rate_Level
select * from #Rate_Level


--Table: Rate_Time_Period

select distinct  * into #Rate_Time_Period
from (
select * from Rate_Time_Period where termination_date>getdate()
union
select vr.* from Rate_Time_Period vr inner join contract co on vr.rate_id=co.rate_id 
where vr.termination_date>=co.rate_assigned_date and vr.effective_date<=co.rate_assigned_date 
union
select vr.* from Rate_Time_Period  vr inner join reservation re on vr.rate_id=re.rate_id
where vr.termination_date>=re.date_rate_assigned and vr.effective_date <=re.date_rate_assigned
) as x

delete from Rate_Time_Period

set IDENTITY_INSERT Rate_Time_Period on
insert into Rate_Time_Period
(
[Rate_Time_Period_ID]  ,
	[Rate_ID]  ,
	[Effective_Date]  ,
	[Termination_Date] ,
	[Time_Period] ,
	[Time_Period_Start] ,
	[Type]  ,
	[Time_period_End]  ,
	[Km_Cap] 
)
select * from #Rate_Time_Period
GO
