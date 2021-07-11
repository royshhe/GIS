USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_FA_Key_Tag]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--exec dbo.RP_SP_FA_Key_Tag;1 '190000','199000','Program','','EXPLORER','2018'

--exec dbo.RP_SP_FA_Key_Tag;1 '190000','199000','1','1','Accord','2018'


CREATE Procedure [dbo].[RP_SP_FA_Key_Tag]  --'190000','199000','1','1','ACCORD','2018'
	@startingUnitNumber varchar(10),
	@endingUnitNumber varchar(10),
	@Program varchar(10),
	@Own varchar(1)='',
	@modelName varchar(25)='',
	@modelYear varchar(4)=''
As

DECLARE  @tmpProgram bit
DECLARE @vehicleModelID int

if @modelName='*' 
	Select @vehicleModelID=0
Else
	Select @vehicleModelID=Vehicle_Model_ID from Vehicle_Model_Year where Model_Name=@modelName and Model_Year=@modelYear


if UPPER(@Program) = 'PROGRAM'	
		SELECT @tmpProgram='1'    
else	
		SELECT @tmpProgram = '0'

	

--if @Own<>'1' 
	Begin
	 

		if @program='_' 

			SELECT   top 30  ' ' as Unit_Number, ' ' as Model_Name, ' ' as Exterior_Colour, 0 as Program, ' ' as Current_Licence_Plate, null as Owning_Company_ID,
					null as GPS, null as AllWheelDrive, null as LeatherSeat,null as Sedan,null as HatchBack, null as SunRoof
			--select *
			FROM         dbo.Vehicle V INNER JOIN
							  dbo.Vehicle_Model_Year VMY ON V.Vehicle_Model_ID = VMY.Vehicle_Model_ID INNER JOIN
								  (SELECT     *
									FROM          lookup_table
									WHERE      category LIKE '%budget%') OC ON V.Owning_Company_ID = OC.Code
			Where v.Unit_Number between Convert(int, @startingUnitNumber) and Convert(int, @endingUnitNumber) and (@Program = '_'	 or Program=convert(bit, @tmpProgram))
					and v.deleted=0 and ((v.sales_processed is null) or v.sales_processed=0)
			--and (v.Current_Rental_Status = 'a' OR
		 --   	v.Current_Rental_Status = 'c')	
			AND 
   			(v.Current_Vehicle_Status = 'b' OR
    			v.Current_Vehicle_Status = 'c' OR
			v.Current_Vehicle_Status = 'd' OR
    			v.Current_Vehicle_Status = 'f' OR
    			v.Current_Vehicle_Status = 'j' OR
    			v.Current_Vehicle_Status = 'k')
			and (v.Vehicle_Model_ID=@vehicleModelID or @modelName='*')
			order by v.unit_number

		else
			
			select  rtrim(cast(V.Unit_Number as char(20))) as unit_number, VMY.Model_Name, V.Exterior_Colour, V.Program, V.Current_Licence_Plate, V.Owning_Company_ID,
					Veh_OP.GPS,Veh_OP.AllWheelDrive,Veh_OP.LeatherSeat,Veh_OP.Sedan,Veh_OP.HatchBack,Veh_OP.SunRoof

			--select *
			FROM         dbo.Vehicle V INNER JOIN
							  dbo.Vehicle_Model_Year VMY ON V.Vehicle_Model_ID = VMY.Vehicle_Model_ID INNER JOIN
								  (SELECT     *
									FROM          lookup_table
									WHERE      category LIKE '%budget%') OC ON V.Owning_Company_ID = OC.Code
					left join ((select unit_number,
										sum(case when vo.alias='G'
												then 1
												else 0
										end ) as GPS,
										sum(case when vo.alias='A'
												then 1
												else 0
										end ) as AllWheelDrive,
										sum(case when vo.alias='L'
												then 1
												else 0
										end ) as LeatherSeat,
										sum(case when vo.alias='S'
												then 1
												else 0
										end ) as Sedan,
										sum(case when vo.alias='H'
												then 1
												else 0
										end ) as HatchBack,
										sum(case when vo.alias='SR'
												then 1
												else 0
										end ) as SunRoof

									--select *
								from dbo.vehicle_installed_option vio inner join 
										(SELECT     *
										   FROM          lookup_table
										   WHERE      category LIKE '%vehicle option%') VO on vio.vehicle_option_id=vo.code
								group by unit_number)
							) Veh_OP	on Veh_OP.unit_number=v.unit_number
							
			Where v.Unit_Number between Convert(int, @startingUnitNumber) and Convert(int, @endingUnitNumber) and (@Program = '*'	 or Program=convert(bit, @tmpProgram))
					--v.unit_number='177398'
					and v.deleted=0 and ((v.sales_processed is null) or v.sales_processed=0) 
					and (v.current_licence_plate is not null and  v.current_licence_plate <>'')
			--and (v.Current_Rental_Status = 'a' OR
		 --   	v.Current_Rental_Status = 'c')	
			AND 
   			(v.Current_Vehicle_Status = 'b' OR
    			v.Current_Vehicle_Status = 'c' OR
			v.Current_Vehicle_Status = 'd' OR
    			v.Current_Vehicle_Status = 'f' OR
    			v.Current_Vehicle_Status = 'j' OR
				v.Current_Vehicle_Status = 'e' OR
    			v.Current_Vehicle_Status = 'k')
			and (v.Vehicle_Model_ID=@vehicleModelID or @modelName='*')
			order by v.unit_number

	End
 -- Else
	--Begin
	--	print 'ow 1:'+@Own
	--	if @program='_' 

	--		SELECT   top 30  ' ' as Unit_Number, ' ' as Model_Name, ' ' as Exterior_Colour, 0 as Program, ' ' as Current_Licence_Plate, null as Owning_Company_ID,
	--				null as GPS, null as AllWheelDrive, null as LeatherSeat,null as Sedan,null as HatchBack, null as SunRoof
	--		--select *
	--		FROM         dbo.Vehicle V INNER JOIN
	--						  dbo.Vehicle_Model_Year VMY ON V.Vehicle_Model_ID = VMY.Vehicle_Model_ID INNER JOIN
	--							  (SELECT     *
	--								FROM          lookup_table
	--								WHERE      category LIKE '%budget%') OC ON V.Owning_Company_ID = OC.Code
	--		Where v.Unit_Number between Convert(int, @startingUnitNumber) and Convert(int, @endingUnitNumber) and (@Program = '_'	 or Program=convert(bit, @tmpProgram))
	--				and v.deleted=0 and ((v.sales_processed is null) or v.sales_processed=0)
	--		--and (v.Current_Rental_Status = 'a' OR
	--	 --   	v.Current_Rental_Status = 'c')	
	--		AND 
 --  			(v.Current_Vehicle_Status = 'b')
	--		and (v.Vehicle_Model_ID=@vehicleModelID or @vehicleModelID is null)
	--		order by v.unit_number

	--	else
			
	--		select  rtrim(cast(V.Unit_Number as char(20))) as unit_number, VMY.Model_Name, V.Exterior_Colour, V.Program, V.Current_Licence_Plate, V.Owning_Company_ID,
	--				Veh_OP.GPS,Veh_OP.AllWheelDrive,Veh_OP.LeatherSeat,Veh_OP.Sedan,Veh_OP.HatchBack,Veh_OP.SunRoof

	--		--select *
	--		FROM         dbo.Vehicle V INNER JOIN
	--						  dbo.Vehicle_Model_Year VMY ON V.Vehicle_Model_ID = VMY.Vehicle_Model_ID INNER JOIN
	--							  (SELECT     *
	--								FROM          lookup_table
	--								WHERE      category LIKE '%budget%') OC ON V.Owning_Company_ID = OC.Code
	--				left join ((select unit_number,
	--									sum(case when vo.alias='G'
	--											then 1
	--											else 0
	--									end ) as GPS,
	--									sum(case when vo.alias='A'
	--											then 1
	--											else 0
	--									end ) as AllWheelDrive,
	--									sum(case when vo.alias='L'
	--											then 1
	--											else 0
	--									end ) as LeatherSeat,
	--									sum(case when vo.alias='S'
	--											then 1
	--											else 0
	--									end ) as Sedan,
	--									sum(case when vo.alias='H'
	--											then 1
	--											else 0
	--									end ) as HatchBack,
	--									sum(case when vo.alias='SR'
	--											then 1
	--											else 0
	--									end ) as SunRoof

	--								--select *
	--							from dbo.vehicle_installed_option vio inner join 
	--									(SELECT     *
	--									   FROM          lookup_table
	--									   WHERE      category LIKE '%vehicle option%') VO on vio.vehicle_option_id=vo.code
	--							group by unit_number)
	--						) Veh_OP	on Veh_OP.unit_number=v.unit_number
							
	--		Where v.Unit_Number between Convert(int, @startingUnitNumber) and Convert(int, @endingUnitNumber) and (@Program = '*'	 or Program=convert(bit, @tmpProgram))
	--				--v.unit_number='177398'
	--				and v.deleted=0 and ((v.sales_processed is null) or v.sales_processed=0) 
	--				and (v.current_licence_plate is not null and  v.current_licence_plate <>'')
	--		--and (v.Current_Rental_Status = 'a' OR
	--	 --   	v.Current_Rental_Status = 'c')	
	--		AND 
 --  			(v.Current_Vehicle_Status = 'b')
	--		and (v.Vehicle_Model_ID=@vehicleModelID or @vehicleModelID is null)
	--		order by v.unit_number

	--End

GO
