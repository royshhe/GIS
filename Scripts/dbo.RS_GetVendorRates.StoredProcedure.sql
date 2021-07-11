USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RS_GetVendorRates]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RS_GetVendorRates]  -- 16 , '10:30 31 May 2017',1
(
	@paramLocationID varchar(20) = '*',
	@paramPickUpDate varchar(20) = '10:30 01 Jan 2017',
	@paramLOR varchar(20) = '1'
--	@paramShopDate varchar(20) = '1999/12/31'
)
--Select convert(varchar(20),CONVERT(datetime,'10:30 01 Jan 2017'),120)
--Select  cast(convert(char(11), max(ShopTime), 113) as datetime) from dbo.Rate_Shops 
--select * from Rate_shops
 --select * from Rate_Shops where PickUpDateTime='10:30 01 May 2017' and sippcode='SCAR' and LOr=1 and PickUpLocation='YVR'
 --and ShopTime='2017-02-02 14:51:00.000'

AS

Declare @shopDate Datetime
Declare @batchNumber Int
Declare @dtPickDate Datetime

--Select @shopDate=  cast(convert(char(11), max(ShopTime), 113) as datetime) from dbo.Rate_Shops where websiteURL='www.Expedia.ca'
select @dtPickDate= CONVERT(datetime,@paramPickUpDate) 
Select @shopDate=  cast(convert(char(11), max(ShopTime), 113) as datetime) from dbo.Rate_Shops where websiteURL='www.Expedia.ca' and PickUpDateTime= @dtPickDate

Select @batchNumber=  max(Batch_ID) from dbo.Rate_Shops where ShopTime>=  @shopDate and ShopTime< @shopDate +1 and PickUpDateTime= @dtPickDate and websiteURL='www.Expedia.ca'


Select SIPPcode, Budget, Alamo, Dollar, Avis,  Hertz,  [National],Enterprise,

dbo.GetBaseRate(
	(Case When TargetPrice=9999 Then 0 
		 Else TargetPrice-0.10
	 End),
 'Budget',
 PickUpLocation, 
 ShopTime,
 LOR,
 Rate_type)
 TargetPrice,
 (Case When TargetPrice=9999 Then 0 
		 Else TargetPrice
	 End) InclusiveTargetPrice
 
From 
(
SELECT 
LOR,
PickUpLocation,
Rate_Type,
ShopTime,
SIPPcode,         
Sum(Case When VendorName='Budget' 
	Then 
		dbo.GetBaseRate(Inclusive_Rate,VendorName,PickUpLocation, ShopTime,LOR,Rate_type)
		--(Case When Rate_type='D' Then dbo.GetBaseRate(Inclusive_Rate,VendorName,PickUpLocation, ShopTime,LOR,Rate_type)
		--  When Rate_type='W' Then dbo.GetBaseRate(Inclusive_Rate,VendorName,PickUpLocation, ShopTime,LOR)*7
		--End)
	Else 0 
End) Budget, 
Sum(Case When VendorName='Alamo' 
	Then 
	    dbo.GetBaseRate(Inclusive_Rate,VendorName,PickUpLocation, ShopTime,LOR,Rate_type)
		--(Case When Rate_type='D' Then dbo.GetBaseRate(Inclusive_Rate,VendorName,PickUpLocation, ShopTime,LOR)
		--  When Rate_type='W' Then dbo.GetBaseRate(Inclusive_Rate,VendorName,PickUpLocation, ShopTime,LOR)*7
		--End) 
	Else 0 
End) Alamo, 
Sum(Case When VendorName='Dollar' 
    
	 Then 
	 dbo.GetBaseRate(Inclusive_Rate,VendorName,PickUpLocation, ShopTime,LOR,Rate_type)
	--	(Case When Rate_type='D' Then dbo.GetBaseRate(Inclusive_Rate,VendorName,PickUpLocation, ShopTime,LOR)
	--	  When Rate_type='W' Then dbo.GetBaseRate(Inclusive_Rate,VendorName,PickUpLocation, ShopTime,LOR)*7
	--	End)
	Else 0 
End) Dollar,
Sum(Case When VendorName='Avis' 
	Then 
		dbo.GetBaseRate(Inclusive_Rate,VendorName,PickUpLocation, ShopTime,LOR,Rate_type)
		--(Case When Rate_type='D' Then dbo.GetBaseRate(Inclusive_Rate,VendorName,PickUpLocation, ShopTime,LOR)
		--  When Rate_type='W' Then dbo.GetBaseRate(Inclusive_Rate,VendorName,PickUpLocation, ShopTime,LOR)*7
		--End)
	Else 0 
End) Avis,  
Sum(Case When VendorName='Hertz' 
	Then 
		dbo.GetBaseRate(Inclusive_Rate,VendorName,PickUpLocation, ShopTime,LOR,Rate_type)
		--(Case When Rate_type='D' Then dbo.GetBaseRate(Inclusive_Rate,VendorName,PickUpLocation, ShopTime,LOR)
		--  When Rate_type='W' Then dbo.GetBaseRate(Inclusive_Rate,VendorName,PickUpLocation, ShopTime,LOR)*7
		--End)
	Else 0 
End) Hertz, 
Sum(Case When VendorName='National' 
	Then 
		dbo.GetBaseRate(Inclusive_Rate,VendorName,PickUpLocation, ShopTime,LOR,Rate_type)
		--(Case When Rate_type='D' Then dbo.GetBaseRate(Inclusive_Rate,VendorName,PickUpLocation, ShopTime,LOR)
		--  When Rate_type='W' Then dbo.GetBaseRate(Inclusive_Rate,VendorName,PickUpLocation, ShopTime,LOR)*7
		--End)
	Else 0 
End) [National], 
Sum(Case When VendorName='Enterprise' 
	Then 
		dbo.GetBaseRate(Inclusive_Rate,VendorName,PickUpLocation, ShopTime,LOR,Rate_type)
		--(Case When Rate_type='D' Then dbo.GetBaseRate(Inclusive_Rate,VendorName,PickUpLocation, ShopTime,LOR)
		--  When Rate_type='W' Then dbo.GetBaseRate(Inclusive_Rate,VendorName,PickUpLocation, ShopTime,LOR)*7
		--End)
	Else 0 
End) Enterprise,
--Min(Case When VendorName='Budget' or dbo.GetBaseRate(Inclusive_Rate,VendorName,PickUpLocation, ShopTime,LOR,Rate_type) =0 Then 9999 
--	Else dbo.GetBaseRate(Inclusive_Rate,VendorName,PickUpLocation, ShopTime,LOR,Rate_type) 
--End) as TargetPrice



Min(Case When VendorName='Budget' or Inclusive_Rate =0  Then 9999 
		 Else	Inclusive_Rate
End) as TargetPrice





FROM  
dbo.Rate_Shops RS Inner Join Rate_Shop_Location_vw RL
On RS.PickUpLocation=RL.Platinum_Territory_Code



 where websiteURL='www.Expedia.ca' 
 and Batch_ID= @batchNumber 
 and RL.Location_id = @paramLocationID
 and PickUpDateTime=@paramPickUpDate
 and LOR=@paramLOR
 and VendorName<>'Thrifty' 
 Group by 

SIPPcode,
LOR,
PickUpLocation,
Rate_Type,
ShopTime 



)V
order by --PickUpDateTime,LOR, 
SIPPcode

GO
