USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetOptionalExtraCurrent]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--GetLocationInfoByHubID '*','' ,'01 jun 2004 20:00:00'
--exec GetLocationDropOffLocation '16', 'Jun 01 2004'

create PROCEDURE [dbo].[GetOptionalExtraCurrent]  --'*','*' 
	@UnitNumber varchar(12)='*',
	@OptionalExtraType varchar(20)='*'
AS

select distinct opt.optional_extra,oei.unit_Number,CLoc.Location as Current_Location,opt.status,opt.contract_number,opt.Remarks_Out,
	Opt.Remarks_In 

--select *

from optional_extra_inventory oei
left join
(
	SELECT	
	OE.Optional_Extra,	 	 
	OEI.Unit_Number,
	OEI.serial_number, 
	OTA.PUDate, 
	OTA.DODate,
	(Case when OTA.Status='CO' Then PULoc
		 when OTA.Status='CI' Then DOLoc
	End) CurrentLoc, 
	OTA.PULoc,
	OTA.DOLoc, 
	(Case when OTA.Status='CO' Then 'On Rent'
		 when OTA.Status='CI' Then 'Available'
	End) Status ,
	OTA.Contract_Number,
	OTA.Daily_Rate,
	OTA.Weekly_Rate, 
	OTA.Coupon_Code,
	OTA.Movement_Type,
	OE.Type,
	OEI.Expiry_date,
	ota.Remarks_Out,
	ota.Remarks_In   
--select *	 	  
	FROM dbo.Optional_Extra_Inventory OEI 
	INNER JOIN  dbo.Optional_Extra OE 
		 ON OEI.Optional_Extra_ID = OE.Optional_Extra_ID	
	Left Join 
	(Select 
		coe.Optional_Extra_ID,
		coe.unit_number,
		coe.PUDate,
		coe.DODate,
		coe.PULoc,
		coe.DOLoc,
		coe.Status,
		coe.Daily_Rate,
		coe.Weekly_Rate, 
		coe.Coupon_Code,
		coe.Contract_Number,  
		coe.Movement_Type,
		coe.Remarks_Out,
		coe.Remarks_In	 
		from	
		(
					SELECT   
						Optional_Extra_ID,
						Unit_Number,
						ce.Contract_Number,
						Rent_From PUDate, 
						Sold_At_Location_ID PULoc,
						Rent_To DODate, 
						Return_Location_ID DOLoc, 
						Daily_Rate, 
						Weekly_Rate, 
						Coupon_Code,
						Sold_By Moved_by, 
						ce.Status, 
						'Contract' Movement_Type,
						'' Remarks_Out,
						'' Remarks_In   
					
					FROM  dbo.Contract_Optional_Extra ce --AS coe
					Inner Join dbo.Contract con 
						on ce.Contract_number=con.Contract_Number			
					where   ce.Termination_Date>getdate()	and ce.unit_number is not null
					And con.status not in ('VD','CA')	 
					and ce.Rent_From<>ce.Rent_To
					--where   Termination_Date>getdate()	and unit_number is not null
					Union 
					SELECT 
						Optional_Extra_ID, 
						Unit_Number,
						NULL Contract_Number, 
						Movement_Out PUDate, 
						Sending_Location_ID PULoc,
						Movement_In DODate,    
						Receiving_Location_ID DOLoc, 
						NULL Daily_Rate, 
						NULL Weekly_Rate, 
						NULL Coupon_Code,
						Moved_By,
						'CI' as Status, 
						Movement_Type,
						Remarks_Out,
						Remarks_In
					--select *
					FROM  dbo.Optional_Extra_Item_Movement AS oim
	) coe


--dbo.Contract_Optional_Extra AS coe 
	INNER JOIN
	(
		SELECT Unit_Number, Optional_Extra_ID, max(PUDate) Last_PU_Date
		FROM  
		(
			SELECT   
				Optional_Extra_ID,
				Unit_Number,
				ce.Contract_Number,
				Rent_From PUDate, 
				Sold_At_Location_ID PULoc,
				Rent_To DODate, 
				Return_Location_ID DOLoc, 
				Sold_By Moved_by, 
				ce.Status, 
				'Contract' Movement_Type
			FROM  dbo.Contract_Optional_Extra ce --AS coe
					Inner Join dbo.Contract con 
						on ce.Contract_number=con.Contract_Number			
					where   ce.Termination_Date>getdate()	and ce.unit_number is not null
					And con.status not in ('VD','CA')	 
					and ce.Rent_From<>ce.Rent_To
					  
			Union 
			SELECT 
				Optional_Extra_ID, 
				Unit_Number,
				NULL Contract_Number, 
				Movement_Out PUDate, 
				Sending_Location_ID PULoc,
				Movement_In DODate,    
				Receiving_Location_ID DOLoc, 
				Moved_By,
				'CI' as Status, 
				Movement_Type
				FROM  dbo.Optional_Extra_Item_Movement AS oim
			) mv
		 
		--Where Termination_Date>getdate() 
			Group by Unit_Number, Optional_Extra_ID
		) LUR       
		ON	coe.Unit_Number =   LUR.Unit_Number And  coe.Optional_Extra_ID =	LUR.Optional_Extra_ID
		And coe.PUDate  = LUR.Last_PU_Date   --and    coe.Optional_Extra_ID=59
	) OTA  	
	On OEI.Unit_Number=OTA.Unit_Number   and OEI.Optional_Extra_ID = OTA.Optional_Extra_ID
 
Where  
OEI.Deleted_Flag=0 and OEI.Current_Item_Status='d' --And OEI.Optional_Extra_ID=59	
and OEI.owning_company_id in (select code from lookup_table where category='BudgetBC Company')

) OPT
on opt.unit_number=oei.unit_number
Left Join Location CLoc
On OPT.CurrentLoc=CLoc.Location_ID
where deleted_flag=0 and current_item_status='d' -- optional_extra_type='gps'
and (oei.Unit_Number = @UnitNumber or @UnitNumber='*')
and (oei.Optional_Extra_Type = @OptionalExtraType or @OptionalExtraType='*')

order by current_location


GO
