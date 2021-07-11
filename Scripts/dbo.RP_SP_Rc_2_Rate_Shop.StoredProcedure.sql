USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Rc_2_Rate_Shop]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[RP_SP_Rc_2_Rate_Shop]        --'16', '10:30 07 Feb 2017', '06 Feb 2017'
(
	@paramLocationID varchar(20) = '*',
	@paramPickUpDate varchar(20) = '10:30 01 Jan 2017',
	--@paramLOR varchar(20) = '1',
	@paramShopDate varchar(20) = '23 Dec 2016'
)
--Select convert(varchar(20),CONVERT(datetime,'10:30 01 Jan 2017'),120)
AS

Declare @batchNumber Int
Declare @dtPickDate Datetime
DECLARE  @tmpLocID varchar(20)

if @paramLocationID = '*'
	BEGIN
		SELECT @tmpLocID='0'
        END
else
	BEGIN
		SELECT @tmpLocID = @paramLocationID
	END 




select @dtPickDate= CONVERT(datetime,@paramPickUpDate)  
Select @batchNumber=  max(Batch_ID) from dbo.Rate_Shops 
where ShopTime>= CONVERT(datetime, @paramShopDate) and ShopTime<CONVERT(datetime, @paramShopDate) +1 and PickUpDateTime= @dtPickDate
and websiteURL='www.Expedia.ca' 

Select PickUpDateTime,          
		PickUpLocation,       
		LOR,         
		SIPPcode, 		     
		Budget,    
		Budget_Incl,                                  
		Alamo,
		Alamo_Incl,                                   
		Dollar, 
		Dollar_Incl,                                 
		Avis, 
		Avis_Incl,                                   
		Hertz, 
		Hertz_Incl,                                  
		[National],    
		National_Incl,                           
		Enterprise,
		Enterprise_Incl,                              
		Thrifty, 
		Thrifty_Incl,
		(Case When TargetInclusiveRate=9999 Then 0 
			 Else dbo.GetBaseRate(TargetInclusiveRate, 'Budget',PickUpLocation, @dtPickDate,LOR,Rate_type)
		End) TargetPrice,
		
		(Case When TargetInclusiveRate=9999 Then 0 
				 Else TargetInclusiveRate
		End)/ 
		(Case When Rate_type='D' Then LOR
		   When Rate_type='W' Then 1						   
		End)
		TargetPrice_Incl
From 
(SELECT 
	PickUpDateTime,
	PickUpLocation, 
	LOR,
	Rate_type,
	SIPPcode,         
	Sum(Case When VendorName='Budget' 
		Then 
			dbo.GetBaseRate(Inclusive_Rate,VendorName,PickUpLocation, ShopTime,LOR,Rate_type)
			
		 
		Else 0 
	End) Budget, 
	
	Sum(Case When VendorName='Budget' 
		Then 
			Inclusive_Rate			
		Else 0 
	End)/
	(Case When Rate_type='D' Then LOR
	    When Rate_type='W' Then 1						   
	End)
	Budget_Incl, 
	
	Sum(Case When VendorName='Alamo' 
		Then 
			dbo.GetBaseRate(Inclusive_Rate,VendorName,PickUpLocation, ShopTime,LOR,Rate_type)
			 
		Else 0 
	End) Alamo, 
	Sum(Case When VendorName='Alamo' 
		Then 
			Inclusive_Rate			
		Else 0 
	End)/
	(Case When Rate_type='D' Then LOR
	    When Rate_type='W' Then 1						   
	End) Alamo_Incl, 
	Sum(Case When VendorName='Dollar' 
		Then 
			dbo.GetBaseRate(Inclusive_Rate,VendorName,PickUpLocation, ShopTime,LOR,Rate_type)
			 
		Else 0 
	End) Dollar,
	
	Sum(Case When VendorName='Dollar' 
		Then 
			Inclusive_Rate			
		Else 0 
	End)/
	(Case When Rate_type='D' Then LOR
	    When Rate_type='W' Then 1						   
	End) Dollar_Incl, 
	
	Sum(Case When VendorName='Avis' 
		Then 
			dbo.GetBaseRate(Inclusive_Rate,VendorName,PickUpLocation, ShopTime,LOR,Rate_type)
			 
		Else 0 
	End) Avis,  
	
	Sum(Case When VendorName='Avis' 
		Then 
			Inclusive_Rate			
		Else 0 
	End)/
	(Case When Rate_type='D' Then LOR
	    When Rate_type='W' Then 1						   
	End) Avis_Incl,
	
	Sum(Case When VendorName='Hertz' 
		Then 
			dbo.GetBaseRate(Inclusive_Rate,VendorName,PickUpLocation, ShopTime,LOR,Rate_type)
			 
		Else 0 
	End) Hertz, 
	
	Sum(Case When VendorName='Hertz' 
		Then 
			Inclusive_Rate			
		Else 0 
	End)/
	(Case When Rate_type='D' Then LOR
	    When Rate_type='W' Then 1						   
	End) Hertz_Incl,
	
	Sum(Case When VendorName='National' 
		Then 
			dbo.GetBaseRate(Inclusive_Rate,VendorName,PickUpLocation, ShopTime,LOR,Rate_type)
			 
		Else 0 
	End) [National], 
	
	Sum(Case When VendorName='National' 
		Then 
			Inclusive_Rate			
		Else 0 
	End)/
	(Case When Rate_type='D' Then LOR
	    When Rate_type='W' Then 1						   
	End) National_Incl,
	
	Sum(Case When VendorName='Enterprise' 
		Then 
			dbo.GetBaseRate(Inclusive_Rate,VendorName,PickUpLocation, ShopTime,LOR,Rate_type)
			 
		Else 0 
	End) Enterprise,
	Sum(Case When VendorName='Enterprise' 
		Then 
			Inclusive_Rate			
		Else 0 
	End)/
	(Case When Rate_type='D' Then LOR
	    When Rate_type='W' Then 1						   
	End) Enterprise_Incl,
	
	Sum(Case When VendorName='Thrifty' 
		Then 
			dbo.GetBaseRate(Inclusive_Rate,VendorName,PickUpLocation, ShopTime,LOR,Rate_type)
			 
		Else 0 
	End) Thrifty,
	
	Sum(Case When VendorName='Thrifty' 
		Then 
			Inclusive_Rate			
		Else 0 
	End)/
	(Case When Rate_type='D' Then LOR
	    When Rate_type='W' Then 1						   
	End) Thrifty_Incl,
	
	
	Min(Case When VendorName='Budget' or Inclusive_Rate =0  Then 9999 
			 Else	Inclusive_Rate
	End) as TargetInclusiveRate

	--Min(Case When VendorName='Budget' or dbo.GetBaseRate(Inclusive_Rate,VendorName,PickUpLocation, ShopTime,LOR,Rate_type) =0 Then 9999 
	--	Else dbo.GetBaseRate(Inclusive_Rate,VendorName,PickUpLocation, ShopTime,LOR,Rate_type) 
	--	End) as TargetPrice
	  

	FROM dbo.Rate_Shops
		Inner Join dbo.Location 
		on dbo.Location.Platinum_Territory_Code=Rate_Shops.PickUpLocation

	Where websiteURL='www.Expedia.ca' and Batch_ID= @batchNumber 
	      
	AND	(@paramLocationID = '*' or CONVERT(INT, @tmpLocID) =  dbo.Location.Location_ID)
	--AND	(  dbo.Location.Location_ID=16)
	And PickUpDateTime=@dtPickDate

	Group by 
		PickUpDateTime,  
		LOR,
		PickUpLocation,
		SIPPcode,
		Rate_type

)V

InNer Join dbo.Vehicle_Class VC on V.SIPPCode=VC.SIPP
order by  PickUpDateTime,LOR, PickUpLocation,VC.DisplayOrder, SIPPCode


 
GO
