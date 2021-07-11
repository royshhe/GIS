USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AutoFaxCreateAutoFax]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO








---------------------------------------------------------------------------------------
--  Programmer :   Jack Jian
--  Date :              Apr 04, 2001
--  Details: 	 Create Contract list to fax , then need to update autofaxcontract table
---------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[AutoFaxCreateAutoFax]

	@ref_control_ID int ,                                 -- control_id in autofaxcontract table
	@pcl_file_name varchar(255) ,
	@fax_init_status int = 300004 ,                 -- fax record created ok
	@create_date varchar(255) ,
	@user_name varchar(255) 
as

	SET NOCOUNT ON

	declare @contract_number int
	declare @fax_type int
	declare @create_Date_d datetime
	declare @CompanyCode int        --remove hardcode code
	select @CompanyCode=Code from Lookup_Table where Category = 'BudgetBC Company'
	
	select @contract_number = contract_number , @fax_type = fax_type from autofaxcontract where control_ID = @ref_control_ID
	select @create_date_d = convert( datetime , @create_date )
	
	select 	
		0 as ref_control_id ,
		0 as fax_type ,
		space(20) as fax_number ,
		space(100) as reciever_id ,
		space(100) as reciever_name 

	into #temp_fax
	where 1 = 2 
	
	-- 1- Rent Back --- adding all foreign pickup location
	if @fax_type = 1
		begin
			insert into #temp_fax
			(	ref_control_id ,
				fax_type ,
				fax_number ,
				reciever_id ,
				reciever_name 
			)
			select
				@ref_control_ID  as ref_control_id ,  
				1 as fax_type ,
				loc.Fax_Number  ,
				'CoID: ' + convert( varchar , oc.Owning_Company_ID ) ,
				oc. name
			from vehicle_on_contract voc
			join vehicle v
				on voc.Unit_Number = v.Unit_Number and v.Owning_Company_ID = @CompanyCode 
			join  location loc
				on voc.Pick_Up_Location_ID = loc.Location_ID and loc.Owning_Company_ID <> @CompanyCode  and loc.Delete_Flag <> 1 
				     and not ( loc.fax_number = '' or upper(loc.fax_number) = 'N/A' )	
			join owning_company oc
				on oc.Owning_Company_ID = loc.Owning_Company_ID and not ( oc.fax_number = '' or upper( oc.fax_number) = 'N/A' )	
			where voc.contract_number = @contract_number
		end	
	
	-- 2- Local foreign car rented --  adding owing company of each foreign vehicle on the contract
	if @fax_type = 2
		begin
			insert into #temp_fax
			(	ref_control_id ,
				fax_type ,
				fax_number ,
				reciever_id ,
				reciever_name 
			)
			select
				@ref_control_id as ref_control_id ,
				2 as fax_type ,
				oc.Fax_Number ,
				'CoID: ' + convert( varchar , oc.Owning_Company_ID ) ,
				oc.name 
			from vehicle_on_contract voc
			join vehicle v
				on voc.unit_number = v.unit_number and v.Owning_Company_ID <> @CompanyCode 
			join Owning_Company oc
				on v.Owning_Company_ID =  oc.Owning_Company_ID and not ( oc.fax_number = '' or upper( oc.fax_number) = 'N/A' )
			where voc.contract_number = @contract_number
		end

	-- 3 --foreign check in -- adding all pickup location and  owning company of each foreign vehicle
	if @fax_type = 3
		begin
			insert into #temp_fax
			(	ref_control_id ,	
				fax_type ,
				fax_number ,
				reciever_id ,
				reciever_name 
			)

			select 
				@ref_control_id as ref_control_id ,
				3 as fax_type ,
				oc.Fax_Number ,
				'CoID: ' + convert( varchar , oc.Owning_Company_ID ) ,
				oc.name 
			from vehicle_on_contract voc
			join vehicle v
				on voc.Unit_Number = v.Unit_Number and v.Owning_Company_ID <> @CompanyCode 
			join  location loc
				on voc.Pick_Up_Location_ID = loc.Location_ID and loc.Owning_Company_ID <> @CompanyCode  and loc.Delete_Flag <> 1
			join Owning_Company oc
				on v.Owning_Company_ID = oc.Owning_Company_ID and not ( oc.fax_number = '' or upper( oc.fax_number) = 'N/A' )
			where voc.contract_number = @contract_number

		end


	-- 3 --foreign check in -- adding all pickup location and  owning company of each foreign vehicle
	-- if the reantal location's woning company is the same with the vehcile owning company, then only fax to the owning company ONE time !!!
	if @fax_type = 3
		begin
			insert into #temp_fax  
			(	ref_control_id ,	
				fax_type ,
				fax_number ,
				reciever_id ,
				reciever_name 
			)

			select 
				@ref_control_id as ref_control_id ,
				3 as fax_type ,
				loc.Fax_Number ,
				'CoID: ' + convert( varchar ,  oc.Owning_Company_ID ) ,
				oc.name
			from vehicle_on_contract voc
			join vehicle v
				on voc.Unit_Number = v.Unit_Number and v.Owning_Company_ID <> @CompanyCode 
			join  location loc
				on voc.Pick_Up_Location_ID = loc.Location_ID and loc.Owning_Company_ID <> @CompanyCode  and loc.Delete_Flag <> 1
				     and not ( loc.fax_number = '' or upper(loc.fax_number) = 'N/A' )	
			join owning_company oc
				on oc.Owning_Company_ID = loc.Owning_Company_ID
					and not exists ( 
							select * 
							from #temp_fax 
							where reciever_id = 'CoID: ' + convert( varchar ,  oc.Owning_Company_ID ) and ref_control_id = @ref_control_id 
						          )

			where voc.contract_number = @contract_number	
		end
	
	-- 4 - send back -- adding all foreign owning company of each foreign vehicle on the contract
	if @fax_type = 4
		begin
			insert into #temp_fax
			(	ref_control_id ,
				fax_type ,
				fax_number ,
				reciever_id ,
				reciever_name 
			)

			select
				@ref_control_id as ref_control_id ,
				4 as fax_type ,
				oc.Fax_Number ,
				'CoID: ' + convert( varchar , oc.Owning_Company_ID ) ,
				oc.name 
			from vehicle_on_contract voc
			join vehicle v
				on voc.Unit_Number = v.Unit_Number and v.Owning_Company_ID <> @CompanyCode 
			join Owning_Company oc
				on v.Owning_Company_ID = oc.Owning_Company_ID and not ( oc.fax_number = '' or upper( oc.fax_number) = 'N/A' )
			where voc.contract_number = @contract_number
		end


	---        insert into fax record
	insert into autofax
	(	
		ref_control_ID ,
		create_date ,
		contract_number ,
		response_id ,
		process_status ,
		control_status ,
		contract_rbr_date ,
		fax_type ,
		send_try_times ,
		contract_status ,

		expect_send_date ,
		latest_try_date ,
		success_send_date ,
		priority ,

		submit_status_code ,
		fax_status_code ,
		success_dele_file_falg ,
		
		fax_subject ,

		sender_full_name ,
		sender_comany_name ,
		sender_tele_no ,
		send_fax_no ,
		sender_voice_no ,

		reciever_fax_no ,
		reciever_id ,
		reciever_name ,


		pcl_file_name ,

		send_device_name ,

		last_updated_by ,
		last_updated_on
	)
	select
		@ref_control_ID ,            -- control id in autofaxcontract
		@create_date_d ,
		afc.contract_number ,
		0 ,   			-- response id ( init value = 0 )
		@fax_init_status ,   	-- 300004 fax record create successfully! 
		0 ,			-- control status set to 0 , if 1 then record disabled
		afc.contract_rbr_date ,
		tf.fax_type ,
		0 ,			-- send try times
		con.status ,                      

		getdate() ,		-- predefined send date ( not used )
		null , 			-- latest try date             ( not used )
		null ,			-- sucess send date      ( not used )
		1 , 		 	-- priority                        ( not sed )

		0 ,			-- submit_status_code  ( not used )
		null ,			-- fax_status_code       ( not used )
		'N' ,			-- flag to delete the file after sucess sending

		null , 											 -- fax subject

		(select control_value from autofaxcontrol where control_id = 100) sender_full_name ,		 -- sender full name
		(select control_value from autofaxcontrol where control_id = 101) sender_company_name  ,	 -- sender company name
		(select control_value from autofaxcontrol where control_id = 102) sender_tele_no  , 		 -- sender telephone number
		(select control_value from autofaxcontrol where control_id = 103) sender_fax_no  , 		 -- sender fax number
		(select control_value from autofaxcontrol where control_id = 104) sender_voice_no  , 	 -- sender voice number

		tf.fax_number ,	--<--------------------<-------------------<--<---<<<------------------------------ receiver fax number !!!!!!!!!!!!!!!!!!
		tf.reciever_id ,
		tf.reciever_name ,

		@pcl_file_name ,
		null ,  -- send deveice name

		@user_name ,
		getdate()

	from autofaxcontract afc
	join #temp_fax tf
		on afc.control_ID = tf.ref_control_ID
	join  contract  con
		on afc.contract_number = con.contract_number
	where afc.control_ID = @ref_control_ID

	SET NOCOUNT Off


















GO
