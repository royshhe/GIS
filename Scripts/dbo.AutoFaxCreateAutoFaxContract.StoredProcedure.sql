USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[AutoFaxCreateAutoFaxContract]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





----------------------------------------------------------------------------------------------------------------------------------------
--  Programmer :   Jack Jian
--  Date :              Apr 10, 2001
--  Details: 	 Get Contract list to fax , and also update the autofaxprocess table
----------------------------------------------------------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[AutoFaxCreateAutoFaxContract]
	@rbr_date varchar(255) 		= 'Jan 01 2001'  ,
	@contract_process_status int 	= 200000 ,      	-- Record created! no action!
	@process_status int  		= 100002 ,	-- Rbr Date is processed this time!
	@overrided_status int 		= 200001 ,	-- Record is overrided!
	@user_name varchar(255)      

as

	SET NOCOUNT ON

	declare @contract_number int
	declare @fax_type int

	declare @sequence_number int
	DECLARE @rbr_date_d  datetime
	declare @CompanyCode int  --remove hardcode code
	select @CompanyCode=Code from Lookup_Table where Category = 'BudgetBC Company'
	SELECT @rbr_date_d = convert( datetime, @rbr_date)

	---  Rent-Back (check in and adjustments)
	select distinct bt.contract_number, 
		bt.rbr_date , 
		con.status as contract_status ,
		1 as fax_type
	into #temp_autofaxcontract
	from business_transaction bt
	join contract con
		on bt.contract_number = con.contract_number 
	join location loc1
		on con.Pick_Up_Location_ID = loc1.location_id and loc1.Owning_Company_ID <> @CompanyCode
	join location loc2
		on con.Drop_Off_Location_ID = loc2.location_id and loc2.Owning_Company_ID = @CompanyCode
	join vehicle_on_contract voc
		on voc.contract_number = bt.contract_number 
	join vehicle v
		on voc.Unit_Number = v.unit_number and v.Owning_Company_ID = @CompanyCode
	where RBR_Date = @rbr_date_d and RBR_Date >='2003-05-07'
	and Transaction_Description in ('Check In','Adjustments')
	order by bt.contract_number	

	--  Local Foreign Car Rental
	insert into #temp_autofaxcontract
	(
		contract_number ,
		rbr_date ,
		contract_status ,
		fax_type
	)		
	select distinct bt.contract_number, 
		bt.rbr_date , 
		con.status ,
		2
	from business_transaction bt
	join contract con
		on bt.contract_number = con.contract_number 
	join location loc1
		on con.Pick_Up_Location_ID = loc1.location_id and loc1.Owning_Company_ID = @CompanyCode
	join location loc2
		on con.Drop_Off_Location_ID = loc2.location_id and loc2.Owning_Company_ID = @CompanyCode
	join vehicle_on_contract voc
		on voc.contract_number = bt.contract_number 
	join vehicle v
		on voc.Unit_Number = v.unit_number and v.Owning_Company_ID <> @CompanyCode
	where RBR_Date = @rbr_date_d and RBR_Date >='2003-05-07'
	and Transaction_Description in ('Check In','Adjustments','Open', 'Change','Check Out')
	order by bt.contract_number

	--Foreign Check In
	insert into #temp_autofaxcontract
	(
		contract_number ,
		rbr_date ,
		contract_status ,
		fax_type
	)		
	select distinct bt.contract_number, 
		bt.rbr_date , 
		con.status ,
		3
	from business_transaction bt
	join contract con
		on bt.contract_number = con.contract_number 
	join location loc1
		on con.Pick_Up_Location_ID = loc1.location_id and loc1.Owning_Company_ID <> @CompanyCode
	join location loc2
		on con.Drop_Off_Location_ID = loc2.location_id and loc2.Owning_Company_ID = @CompanyCode
	join vehicle_on_contract voc
		on voc.contract_number = bt.contract_number 
	join vehicle v
		on voc.Unit_Number = v.unit_number and v.Owning_Company_ID <> @CompanyCode
	where RBR_Date = @rbr_date_d and RBR_Date >='2003-05-07'
	and Transaction_Description in ('Check In','Adjustments','Foreign Check In')
	order by bt.contract_number

	--Send Back
	insert into #temp_autofaxcontract
	(
		contract_number ,
		rbr_date ,
		contract_status ,
		fax_type 
	)		
	select distinct bt.contract_number, 
		bt.rbr_date , 
		con.status ,
		4
	from business_transaction bt
	join contract con
		on bt.contract_number = con.contract_number 
	join location loc1
		on con.Pick_Up_Location_ID = loc1.location_id and loc1.Owning_Company_ID = @CompanyCode
	join location loc2
		on con.Drop_Off_Location_ID = loc2.location_id and loc2.Owning_Company_ID <> @CompanyCode
	join vehicle_on_contract voc

		on voc.contract_number = bt.contract_number 
	join vehicle v
		on voc.Unit_Number = v.unit_number and v.Owning_Company_ID <> @CompanyCode
	where RBR_Date = @rbr_date_d and RBR_Date >='2003-05-07'
	and Transaction_Description in ('Open','Change','Check Out')
	order by bt.contract_number	

	 ---  update autofaxcontract
	Declare thisCursor Cursor FAST_FORWARD For
	( 
		Select contract_number , fax_type
		From #temp_autofaxcontract
	)
	Open thisCursor
	Fetch Next From thisCursor Into @contract_number , @fax_type
	While (@@Fetch_Status = 0)
		Begin

			--  updated exist pending contracts status
			update  autofaxcontract 
			set         process_status = @overrided_status , 
				last_updated_by = @user_name , 
				last_updated_on = getdate()
			where contract_number = @contract_number
			           and fax_type = @fax_type
			           and process_status <> @contract_process_status
			           and process_status <> 300002  --<<------------------<< -------------------- success flag

			--  insert new contracts
			insert into autofaxcontract
			(
				contract_number ,
				copy_sequence , 
				contract_rbr_date ,
				contract_status ,
				process_date ,
				process_status ,
				fax_type ,
				try_times ,
				last_updated_by ,
				last_updated_on
			)
			select 
				contract_number ,
				0   ,			       -- copy sequence is from gis contract record
				rbr_date ,
				contract_status ,
				getdate() ,
				@contract_process_status  ,  -- Record created! No Action!			
				fax_type ,
				0 ,			       --  try times	
				@user_name ,
				getdate()
			from #temp_autofaxcontract  
			where contract_number = @contract_number
		
			Fetch Next From thisCursor Into @contract_number , @fax_type	
		end
	Close thisCursor
	Deallocate thisCursor

	--- update autofaxprocess
	if exists (select  * 
		from autofaxprocess 
		where rbr_Date = @rbr_date_d )

		update autofaxprocess 
		set process_status  = @process_status  , 
			last_updated_by =  @user_name , 
			last_updated_on = getdate()  
		where rbr_Date = @rbr_date_d

	else

		begin
			insert into autofaxprocess
			(
				rbr_date ,
				process_status ,
				process_times ,
				last_updated_by ,
				last_updated_on
			)
			values
			(
				@rbr_date_d ,
				@process_status ,
				1,			-- process times
				@user_name ,
				getdate()
			)
		end

	SET NOCOUNT OFF

GO
