USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[ApplySnowTireMngtFee]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Peter Ni>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ApplySnowTireMngtFee]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	--remove reservation no longer with snow tire car but already apply snow tire surcharge.
	
		--remove remark
		update reservation set special_comments=replace(special_comments,'**TIRE MGMT FEE OF $10/DAY','')
		--select *
		from Reserved_Rental_Accessory rra 
				inner join optional_extra oe on rra.optional_extra_id=oe.optional_extra_id
				inner join reservation r on rra.confirmation_number =r.confirmation_number
				inner join vehicle_class vc on r.vehicle_class_code=vc.vehicle_class_code
		where oe.optional_extra='Snow Tire 10' and r.status='a' and r.foreign_confirm_number is not null
				 and vc.vehicle_class_name<>'Snow Tire Car'
		
		--remove optional extra
		delete Reserved_Rental_Accessory
		--select *
		from Reserved_Rental_Accessory rra 
				inner join optional_extra oe on rra.optional_extra_id=oe.optional_extra_id
				inner join reservation r on rra.confirmation_number =r.confirmation_number
				inner join vehicle_class vc on r.vehicle_class_code=vc.vehicle_class_code
		where oe.optional_extra='Snow Tire 10' and r.status='a'  and r.foreign_confirm_number is not null
				and vc.vehicle_class_name<>'Snow Tire Car'
		

	--apply snow tire surcharge as snow tire optional extra.
		--update remark
		update reservation set special_comments=replace(special_comments,'**TIRE MGMT FEE OF $10/DAY','')+'**TIRE MGMT FEE OF $10/DAY'
		--select *
		from reservation r 
				inner join vehicle_class vc on r.vehicle_class_code=vc.vehicle_class_code
				left join Reserved_Rental_Accessory RRA on r.confirmation_number=RRA.confirmation_number
				left join optional_extra oe on rra.optional_extra_id=oe.optional_extra_id and oe.delete_flag=0
		where r.status='a' and vehicle_class_name='Snow Tire Car'  and r.foreign_confirm_number is not null
				and (oe.optional_extra<>'Snow Tire 10' or rra.optional_extra_id is null)
				and r.confirmation_number not  in (select confirmation_number 
																from Reserved_Rental_Accessory rra1 
																		inner join optional_extra oe1 on rra1.optional_extra_id=oe1.optional_extra_id
															where oe1.optional_extra='Snow Tire 10'  )
				--and r.foreign_confirm_number='15133260CA2'															
		
		--add optional extra for tire management fee
		
		
		insert into Reserved_Rental_Accessory
		select distinct r.confirmation_number,
				(select optional_extra_id from optional_extra where optional_extra='Snow Tire 10' ) as optional_extra_id,
				1 as quantity, null,null, null
		--select *		
		from reservation r 
				inner join vehicle_class vc on r.vehicle_class_code=vc.vehicle_class_code
				left join Reserved_Rental_Accessory RRA on r.confirmation_number=RRA.confirmation_number
				left join optional_extra oe on rra.optional_extra_id=oe.optional_extra_id and oe.delete_flag=0
		where status='a' and vehicle_class_name='Snow Tire Car'  and r.foreign_confirm_number is not null
				and (oe.optional_extra<>'Snow Tire 10' or rra.optional_extra_id is null)
				and r.confirmation_number not  in (select confirmation_number 
																from Reserved_Rental_Accessory rra1 
																		inner join optional_extra oe1 on rra1.optional_extra_id=oe1.optional_extra_id
															where oe1.optional_extra='Snow Tire 10'  )
				--and r.foreign_confirm_number='15133260CA2'															


END
GO
