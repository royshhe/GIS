USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateTruckAvailability]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[CreateTruckAvailability] as
 
Declare @maxRptDate datetime
Declare @DayNum Int
declare @rptDate datetime --varchar(20),
declare --@ConfirmationNumber varchar(20),
			@PULocID varchar(10),
			@VCCode varchar(1),
			@PickUpOn datetime,
			@DropOffOn datetime
Declare @AMFrom as varchar(10),
		@PMFrom as Varchar(10),
		@OVFrom as Varchar(10)

select	@AMFrom=' 07:30',
		@PMFrom=' 12:00',
		@OVFrom=' 16:30'


Select @DayNum=Max(DayNum) from RP_Day_Number
--select * from RP_Day_Number
Select @maxRptDate= CONVERT(VarChar, Dateadd( d, @DayNum, getdate()),106)

--Print @maxRptDate

Delete 
--select * from 
RP_Truck_Availability --where Rpt_Date between CONVERT(VarChar, getdate(), 106) And @maxRptDate


insert into RP_Truck_Availability
select location_id,
		vehicle_class_code,
		calendar_date,
		AM_Inventory,
		 PM_Inventory,
	 OV_Inventory,
	 AM_Inventory,
		 PM_Inventory,
	 OV_Inventory
--select *
from truck_inventory
where calendar_date>=getdate()-1
--print getdate()

--For Reservation
		Delete RP_Truck_Availability_Source
		insert into RP_Truck_Availability_Source
		select Pick_Up_Location_ID,
				Vehicle_Class_Code,
				Pick_Up_On,
				Drop_Off_On,
				Source
			from
			(select --Confirmation_Number,
				--Drop_Off_Location_ID,
				Pick_Up_Location_ID as Pick_Up_Location_ID,
				r.Vehicle_Class_Code as Vehicle_Class_Code,
				Pick_Up_On as Pick_Up_On,
				Drop_Off_On as Drop_Off_On,
				'Reservation' as Source
		from reservation r inner join vehicle_class vc
				on vc.Vehicle_Class_Code=r.Vehicle_Class_Code
		where --Pick_Up_Location_ID = 201 and r.Vehicle_Class_Code = 'm' and 
				Drop_Off_On>=getdate() and status='a' and vc.vehicle_type_id='Truck'
				--and Drop_Off_On<=getdate()	+4
		 union all
		
		SELECT 	dbo.Vehicle_On_Contract.Pick_Up_Location_ID as Pick_Up_Location_ID, 
				dbo.Vehicle.Vehicle_Class_Code as Vehicle_Class_Code,
				dbo.Vehicle_On_Contract.Checked_Out as Pick_Up_On, 
				dbo.Vehicle_On_Contract.Expected_Check_In  as Drop_Off_On,
				'OnRent' as Source
		--select *
		FROM dbo.Vehicle_On_Contract INNER JOIN
			  dbo.Vehicle ON dbo.Vehicle_On_Contract.Unit_Number = dbo.Vehicle.Unit_Number inner join
				dbo.vehicle_class on dbo.Vehicle_On_Contract.actual_vehicle_class_code=dbo.vehicle_class.vehicle_class_code
		WHERE (dbo.Vehicle_On_Contract.Actual_Check_In is null) and dbo.vehicle_class.vehicle_type_id='Truck') Res
		--where Pick_Up_Location_ID=201 and Vehicle_Class_Code='n'
		order by Drop_Off_On


		DECLARE Reservation_cursor CURSOR FOR
		select Pick_Up_Location_ID,
				Vehicle_Class_Code,
				Pick_Up_On,
				Drop_Off_On
			from
			(select --Confirmation_Number,
				--Drop_Off_Location_ID,
				Pick_Up_Location_ID as Pick_Up_Location_ID,
				r.Vehicle_Class_Code as Vehicle_Class_Code,
				Pick_Up_On as Pick_Up_On,
				Drop_Off_On as Drop_Off_On,
				'Reservation' as Source
		from reservation r inner join vehicle_class vc
				on vc.Vehicle_Class_Code=r.Vehicle_Class_Code
		where --Pick_Up_Location_ID = 201 and r.Vehicle_Class_Code = 'm' and 
				Drop_Off_On>=getdate() and status='a' and vc.vehicle_type_id='Truck'
				--and Drop_Off_On<=getdate()	+4
		 union all
		
		SELECT 	dbo.Vehicle_On_Contract.Pick_Up_Location_ID as Pick_Up_Location_ID, 
				dbo.Vehicle.Vehicle_Class_Code as Vehicle_Class_Code,
				dbo.Vehicle_On_Contract.Checked_Out as Pick_Up_On, 
				dbo.Vehicle_On_Contract.Expected_Check_In  as Drop_Off_On,
				'OnRent' as Source
		--select *
		FROM dbo.Vehicle_On_Contract INNER JOIN
			  dbo.Vehicle ON dbo.Vehicle_On_Contract.Unit_Number = dbo.Vehicle.Unit_Number inner join
				dbo.vehicle_class on dbo.Vehicle_On_Contract.actual_vehicle_class_code=dbo.vehicle_class.vehicle_class_code
		WHERE (dbo.Vehicle_On_Contract.Actual_Check_In is null) and dbo.vehicle_class.vehicle_type_id='Truck') Res
		--where Pick_Up_Location_ID=201 and Vehicle_Class_Code='n'
		order by Drop_Off_On

		OPEN Reservation_cursor

		FETCH NEXT FROM Reservation_cursor
		INTO @PULocID,@VCCode,@PickUpOn,@DropOffOn
		print @PickUpOn
		print @DropOffOn
		-- Check @@FETCH_STATUS to see if there are any more rows to fetch.
		WHILE @@FETCH_STATUS = 0
		BEGIN

			if @PickUpOn>=  convert(datetime,CONVERT(VarChar, @PickUpOn,106) + ' 07:00') 
				and @PickUpOn<  convert(datetime,CONVERT(VarChar, @PickUpOn,106) + @AMFrom) 
				begin
					select @PickUpOn=convert(datetime,CONVERT(VarChar, @PickUpOn,106) + @AMFrom) 
				end

			if @PickUpOn>=  convert(datetime,CONVERT(VarChar, @PickUpOn,106) + ' 11:30') 
				and @PickUpOn<  convert(datetime,CONVERT(VarChar, @PickUpOn,106) + @PMFrom) 
				begin
					select @PickUpOn=convert(datetime,CONVERT(VarChar, @PickUpOn,106) + @PMFrom) 
				end

			if @PickUpOn>=  convert(datetime,CONVERT(VarChar, @PickUpOn,106) + ' 16:00') 
				and @PickUpOn<  convert(datetime,CONVERT(VarChar, @PickUpOn,106) + @OVFrom) 
				begin
					select @PickUpOn=convert(datetime,CONVERT(VarChar, @PickUpOn,106) + @OVFrom) 
				end

			if @DropOffOn>=  convert(datetime,CONVERT(VarChar, @DropOffOn,106) + ' 07:00') 
				and @DropOffOn<  convert(datetime,CONVERT(VarChar, @DropOffOn,106) + @AMFrom) 
				begin
					select @DropOffOn=convert(datetime,CONVERT(VarChar, @DropOffOn,106) + ' 07:00') 
				end

			if @DropOffOn>=  convert(datetime,CONVERT(VarChar, @DropOffOn,106) + ' 11:30') 
				and @DropOffOn<  convert(datetime,CONVERT(VarChar, @DropOffOn,106) + @PMFrom) 
				begin
					select @DropOffOn=convert(datetime,CONVERT(VarChar, @DropOffOn,106) + ' 11:30') 
				end

			if @DropOffOn>=  convert(datetime,CONVERT(VarChar, @DropOffOn,106) + ' 16:00') 
				and @DropOffOn<  convert(datetime,CONVERT(VarChar, @DropOffOn,106) + @OVFrom) 
				begin
					select @DropOffOn=convert(datetime,CONVERT(VarChar, @DropOffOn,106) + ' 16:00') 
				end
			
			if @DropOffOn<=	@PickUpOn 
				begin 
					FETCH NEXT FROM Reservation_cursor	INTO @PULocID,@VCCode,@PickUpOn,@DropOffOn
					continue
				end

		--case 1 <7:30 am
			if @PickUpOn<  convert(datetime,CONVERT(VarChar, @PickUpOn,106) + @AMFrom)	
						and @DropOffOn<=convert(datetime,CONVERT(VarChar, @DropOffOn,106) + @AMFrom)
				begin	
					print 'Case 1-1'
					UPDATE	RP_Truck_Availability
						SET	OV_Availability = OV_Availability-1
					WHERE	Location_ID = @PULocID
					AND	Vehicle_Class_Code = @VCCode
					AND	(Calendar_Date = convert(datetime, convert(varchar, dateadd(dd,-1,@PickUpOn),106)+' 00:00' ) )

					UPDATE	RP_Truck_Availability
						SET	AM_Availability = AM_Availability-1,
							PM_Availability =PM_Availability-1,
							OV_Availability = OV_Availability-1
					WHERE	Location_ID = @PULocID
					AND	Vehicle_Class_Code = @VCCode
					AND	(Calendar_Date  >=  convert(datetime, convert(varchar, @PickUpOn,106)+' 00:00' ) and Calendar_Date<=convert(datetime, convert(varchar, dateadd(dd,-1,@DropOffOn),106)+' 23:59' ) )
				end

			if @PickUpOn<  convert(datetime,CONVERT(VarChar, @PickUpOn,106) + @AMFrom)	
					and @DropOffOn>  convert(datetime,CONVERT(VarChar, @DropOffOn,106) + @AMFrom)	
						and @DropOffOn<=convert(datetime,CONVERT(VarChar, @DropOffOn,106) + @PMFrom)
				begin	
					print 'Case 1-2'
					UPDATE	RP_Truck_Availability
						SET	OV_Availability = OV_Availability-1
					WHERE	Location_ID = @PULocID
					AND	Vehicle_Class_Code = @VCCode
					AND	(Calendar_Date =   convert(datetime, convert(varchar, dateadd(dd,-1,@PickUpOn),106)+' 00:00' ) )

					UPDATE	RP_Truck_Availability
						SET	AM_Availability = AM_Availability-1,
							PM_Availability =PM_Availability-1,
							OV_Availability = OV_Availability-1
					WHERE	Location_ID = @PULocID
					AND	Vehicle_Class_Code = @VCCode
					AND	(Calendar_Date  >=  convert(datetime, convert(varchar,@PickUpOn,106)+' 00:00' ) and Calendar_Date <= convert(datetime, convert(varchar, dateadd(dd,-1,@DropOffOn),106)+' 23:59' ) )

					UPDATE	RP_Truck_Availability
						SET	AM_Availability = AM_Availability-1
					WHERE	Location_ID = @PULocID
					AND	Vehicle_Class_Code = @VCCode
					AND	(Calendar_Date =  convert(datetime, convert(varchar,@DropOffOn,106)+' 00:00' ) )
				end

			if @PickUpOn<  convert(datetime,CONVERT(VarChar, @PickUpOn,106) + @AMFrom)	
					and @DropOffOn>  convert(datetime,CONVERT(VarChar, @DropOffOn,106) + @PMFrom)	
						and @DropOffOn<=convert(datetime,CONVERT(VarChar, @DropOffOn,106) + @OVFrom)
				begin	
					print 'Case 1-3'
					UPDATE	RP_Truck_Availability
						SET	OV_Availability = OV_Availability-1
					WHERE	Location_ID = @PULocID
					AND	Vehicle_Class_Code = @VCCode
					AND	(Calendar_Date =  convert(datetime, convert(varchar,dateadd(dd,-1,@PickUpOn) ,106)+' 00:00' ))

					UPDATE	RP_Truck_Availability
						SET	AM_Availability = AM_Availability-1,
							PM_Availability =PM_Availability-1,
							OV_Availability = OV_Availability-1
					WHERE	Location_ID = @PULocID
					AND	Vehicle_Class_Code = @VCCode
					AND	(Calendar_Date  >=  convert(datetime, convert(varchar,@PickUpOn,106)+' 00:00' )  and Calendar_Date<= convert(datetime, convert(varchar,dateadd(dd,-1,@DropOffOn),106)+' 23:59' ))

					UPDATE	RP_Truck_Availability
						SET	AM_Availability = AM_Availability-1,
							PM_Availability =PM_Availability-1
					WHERE	Location_ID = @PULocID
					AND	Vehicle_Class_Code = @VCCode
					AND	(Calendar_Date =  convert(datetime, convert(varchar,@DropOffOn,106)+' 00:00' )  )
				end

			if @PickUpOn<  convert(datetime,CONVERT(VarChar, @PickUpOn,106) + @AMFrom)	
					and @DropOffOn>  convert(datetime,CONVERT(VarChar, @DropOffOn,106) + @OVFrom)	
				begin	
					print 'Case 1-4'
					UPDATE	RP_Truck_Availability
						SET	OV_Availability = OV_Availability-1
					WHERE	Location_ID = @PULocID
					AND	Vehicle_Class_Code = @VCCode
					AND	(Calendar_Date =  convert(datetime, convert(varchar,dateadd(dd,-1,@PickUpOn) ,106)+' 00:00' ))

					UPDATE	RP_Truck_Availability
						SET	AM_Availability = AM_Availability-1,
							PM_Availability =PM_Availability-1,
							OV_Availability = OV_Availability-1
					WHERE	Location_ID = @PULocID
					AND	Vehicle_Class_Code = @VCCode
					AND	(Calendar_Date  >=   convert(datetime, convert(varchar,@PickUpOn,106)+' 00:00' ) and Calendar_Date <= convert(datetime, convert(varchar,@DropOffOn,106)+' 23:59' ))
				end
			
			--Case 2 >=7:30 am <12:30 am
			if @PickUpOn>= convert(datetime,CONVERT(VarChar, @PickUpOn,106) + @AMFrom)	
					and @PickUpOn< convert(datetime,CONVERT(VarChar, @PickUpOn,106) + @PMFrom)		
						and @DropOffOn<=convert(datetime,CONVERT(VarChar, @DropOffOn,106) + @AMFrom)
				begin	
					print 'Case 2-1'
					UPDATE	RP_Truck_Availability
						SET	AM_Availability = AM_Availability-1,
							PM_Availability =PM_Availability-1,
							OV_Availability = OV_Availability-1
--					select * from RP_Truck_Availability
					WHERE	Location_ID = @PULocID
					AND	Vehicle_Class_Code = @VCCode
					AND	(Calendar_Date  >= convert(datetime, convert(varchar,@PickUpOn,106)+' 00:00' ) and Calendar_Date <=   convert(datetime, convert(varchar,dateadd(dd,-1,@DropOffOn),106))+' 23:59')
				end

			if @PickUpOn>= convert(datetime,CONVERT(VarChar, @PickUpOn,106) + @AMFrom)	
					and @PickUpOn< convert(datetime,CONVERT(VarChar, @PickUpOn,106) + @PMFrom)		
						and @DropOffOn>convert(datetime,CONVERT(VarChar, @DropOffOn,106) + @AMFrom)
						and @DropOffOn<=convert(datetime,CONVERT(VarChar, @DropOffOn,106) + @PMFrom)
				begin	
					print 'Case 2-2'
					UPDATE	RP_Truck_Availability
						SET	AM_Availability = AM_Availability-1,
							PM_Availability =PM_Availability-1,
							OV_Availability = OV_Availability-1
					WHERE	Location_ID = @PULocID
					AND	Vehicle_Class_Code = @VCCode
					AND	(Calendar_Date  >= convert(datetime, convert(varchar,@PickUpOn,106)+' 00:00' ) and Calendar_Date <=   convert(datetime, convert(varchar,dateadd(dd,-1,@DropOffOn),106))+' 23:59')

					UPDATE	RP_Truck_Availability
						SET	AM_Availability = AM_Availability-1
					WHERE	Location_ID = @PULocID
					AND	Vehicle_Class_Code = @VCCode
					AND	(Calendar_Date =  convert(datetime, convert(varchar,@DropOffOn,106)+' 00:00' )  )
				end

			if @PickUpOn>= convert(datetime,CONVERT(VarChar, @PickUpOn,106) + @AMFrom)	
					and @PickUpOn< convert(datetime,CONVERT(VarChar, @PickUpOn,106) + @PMFrom)		
						and @DropOffOn>convert(datetime,CONVERT(VarChar, @DropOffOn,106) + @PMFrom)
						and @DropOffOn<=convert(datetime,CONVERT(VarChar, @DropOffOn,106) + @OVFrom)
				begin	
					print 'Case 2-3'
					UPDATE	RP_Truck_Availability
						SET	AM_Availability = AM_Availability-1,
							PM_Availability =PM_Availability-1,
							OV_Availability = OV_Availability-1
					WHERE	Location_ID = @PULocID
					AND	Vehicle_Class_Code = @VCCode
					AND	(Calendar_Date  >= convert(datetime, convert(varchar,@PickUpOn,106)+' 00:00' ) and Calendar_Date <=   convert(datetime, convert(varchar,dateadd(dd,-1,@DropOffOn),106))+' 23:59')

					UPDATE	RP_Truck_Availability
						SET	AM_Availability = AM_Availability-1,
							PM_Availability =PM_Availability-1
					WHERE	Location_ID = @PULocID
					AND	Vehicle_Class_Code = @VCCode
					AND	(Calendar_Date =  convert(datetime, convert(varchar,@DropOffOn,106)+' 00:00' )  )
				end


			if @PickUpOn>= convert(datetime,CONVERT(VarChar, @PickUpOn,106) + @AMFrom)	
					and @PickUpOn< convert(datetime,CONVERT(VarChar, @PickUpOn,106) + @PMFrom)		
						and @DropOffOn>convert(datetime,CONVERT(VarChar, @DropOffOn,106) + @OVFrom)
				begin	
					print 'Case 2-4'
					UPDATE	RP_Truck_Availability
						SET	AM_Availability = AM_Availability-1,
							PM_Availability =PM_Availability-1,
							OV_Availability = OV_Availability-1
					WHERE	Location_ID = @PULocID
					AND	Vehicle_Class_Code = @VCCode
					AND	(Calendar_Date  >= convert(datetime, convert(varchar,@PickUpOn,106)+' 00:00' ) and Calendar_Date <=   convert(datetime, convert(varchar,@DropOffOn,106))+' 23:59')
				end

			--Case 3 >=12:30 am <16:30 pm
			if @PickUpOn>= convert(datetime,CONVERT(VarChar, @PickUpOn,106) + @PMFrom)	
					and @PickUpOn< convert(datetime,CONVERT(VarChar, @PickUpOn,106) + @OVFrom)		
						and @DropOffOn<=convert(datetime,CONVERT(VarChar, @DropOffOn,106) + @AMFrom)
				begin	
					print 'Case 3-1'
					UPDATE	RP_Truck_Availability
						SET	PM_Availability =PM_Availability-1,
							OV_Availability = OV_Availability-1
					WHERE	Location_ID = @PULocID
					AND	Vehicle_Class_Code = @VCCode
					AND	(Calendar_Date =  convert(datetime, convert(varchar,@PickUpOn ,106)+' 00:00' ))

					UPDATE	RP_Truck_Availability
						SET	AM_Availability = AM_Availability-1,
							PM_Availability =PM_Availability-1,
							OV_Availability = OV_Availability-1
					WHERE	Location_ID = @PULocID
					AND	Vehicle_Class_Code = @VCCode
					AND	(Calendar_Date  >= convert(datetime, convert(varchar, dateadd(dd,1,@PickUpOn) ,106)+' 00:00' ) and Calendar_Date <=   convert(datetime, convert(varchar,dateadd(dd,-1,@DropOffOn),106))+' 23:59')
				end

			if @PickUpOn>= convert(datetime,CONVERT(VarChar, @PickUpOn,106) + @PMFrom)	
					and @PickUpOn< convert(datetime,CONVERT(VarChar, @PickUpOn,106) + @OVFrom)		
						and @DropOffOn>convert(datetime,CONVERT(VarChar, @DropOffOn,106) + @AMFrom)
						and @DropOffOn<=convert(datetime,CONVERT(VarChar, @DropOffOn,106) + @PMFrom)
				begin	
					print 'Case 3-2'
					UPDATE	RP_Truck_Availability
						SET	PM_Availability =PM_Availability-1,
							OV_Availability = OV_Availability-1
					WHERE	Location_ID = @PULocID
					AND	Vehicle_Class_Code = @VCCode
					AND	(Calendar_Date =  convert(datetime, convert(varchar,@PickUpOn ,106)+' 00:00' ))

					UPDATE	RP_Truck_Availability
						SET	AM_Availability = AM_Availability-1,
							PM_Availability =PM_Availability-1,
							OV_Availability = OV_Availability-1
					WHERE	Location_ID = @PULocID
					AND	Vehicle_Class_Code = @VCCode
					AND	(Calendar_Date  >= convert(datetime, convert(varchar, dateadd(dd,1,@PickUpOn) ,106)+' 00:00' ) and Calendar_Date <=   convert(datetime, convert(varchar,dateadd(dd,-1,@DropOffOn),106))+' 23:59')

					UPDATE	RP_Truck_Availability
						SET	AM_Availability = AM_Availability-1
					WHERE	Location_ID = @PULocID
					AND	Vehicle_Class_Code = @VCCode
					AND	(Calendar_Date =  convert(datetime, convert(varchar,@DropOffOn ,106)+' 00:00' ))
				end

			if @PickUpOn>= convert(datetime,CONVERT(VarChar, @PickUpOn,106) + @PMFrom)	
					and @PickUpOn< convert(datetime,CONVERT(VarChar, @PickUpOn,106) + @OVFrom)		
						and @DropOffOn>convert(datetime,CONVERT(VarChar, @DropOffOn,106) + @PMFrom)
						and @DropOffOn<=convert(datetime,CONVERT(VarChar, @DropOffOn,106) + @OVFrom)
				begin	
					print 'Case 3-3'
					if datediff(dd,@PickUpOn,@DropOffOn)>=1   
							begin
								UPDATE	RP_Truck_Availability
									SET	PM_Availability =PM_Availability-1,
										OV_Availability = OV_Availability-1
								WHERE	Location_ID = @PULocID
								AND	Vehicle_Class_Code = @VCCode
								AND	(Calendar_Date =  convert(datetime, convert(varchar,@PickUpOn ,106)+' 00:00' ))

								UPDATE	RP_Truck_Availability
									SET	AM_Availability = AM_Availability-1,
										PM_Availability =PM_Availability-1
								WHERE	Location_ID = @PULocID
								AND	Vehicle_Class_Code = @VCCode
								AND	(Calendar_Date =  convert(datetime, convert(varchar,@DropOffOn ,106)+' 00:00' ))
							end
						else 
							begin
								UPDATE	RP_Truck_Availability
									SET	PM_Availability =PM_Availability-1
								WHERE	Location_ID = @PULocID
								AND	Vehicle_Class_Code = @VCCode
								AND	(Calendar_Date =  convert(datetime, convert(varchar,@PickUpOn ,106)+' 00:00' ))
							 end

					UPDATE	RP_Truck_Availability
						SET	AM_Availability = AM_Availability-1,
							PM_Availability =PM_Availability-1,
							OV_Availability = OV_Availability-1
					WHERE	Location_ID = @PULocID
					AND	Vehicle_Class_Code = @VCCode
					AND	(Calendar_Date  >= convert(datetime, convert(varchar, dateadd(dd,1,@PickUpOn) ,106)+' 00:00' ) and Calendar_Date <=   convert(datetime, convert(varchar,dateadd(dd,-1,@DropOffOn),106))+' 23:59')

				end

			if @PickUpOn>= convert(datetime,CONVERT(VarChar, @PickUpOn,106) + @PMFrom)	
					and @PickUpOn< convert(datetime,CONVERT(VarChar, @PickUpOn,106) + @OVFrom)		
						and @DropOffOn>convert(datetime,CONVERT(VarChar, @DropOffOn,106) + @OVFrom)
				begin	
					print 'Case 3-4'
					UPDATE	RP_Truck_Availability
						SET	PM_Availability =PM_Availability-1,
							OV_Availability = OV_Availability-1
					WHERE	Location_ID = @PULocID
					AND	Vehicle_Class_Code = @VCCode
					AND	(Calendar_Date =  convert(datetime, convert(varchar,@PickUpOn ,106)+' 00:00' ))

					UPDATE	RP_Truck_Availability
						SET	AM_Availability = AM_Availability-1,
							PM_Availability =PM_Availability-1,
							OV_Availability = OV_Availability-1
					WHERE	Location_ID = @PULocID
					AND	Vehicle_Class_Code = @VCCode
					AND	(Calendar_Date  >= convert(datetime, convert(varchar, dateadd(dd,1,@PickUpOn) ,106)+' 00:00' ) and Calendar_Date <=   convert(datetime, convert(varchar,@DropOffOn,106))+' 23:59')
				end

			--Case 4 >=16:30 pm 
			if @PickUpOn>= convert(datetime,CONVERT(VarChar, @PickUpOn,106) + @OVFrom)	
						and @DropOffOn<=convert(datetime,CONVERT(VarChar, @DropOffOn,106) + @AMFrom)
				begin	
					print 'Case 4-1'
					UPDATE	RP_Truck_Availability
						SET	OV_Availability = OV_Availability-1
					WHERE	Location_ID = @PULocID
					AND	Vehicle_Class_Code = @VCCode
					AND	(Calendar_Date =  convert(datetime, convert(varchar,@PickUpOn ,106)+' 00:00' ))

					UPDATE	RP_Truck_Availability
						SET	AM_Availability = AM_Availability-1,
							PM_Availability =PM_Availability-1,
							OV_Availability = OV_Availability-1
					WHERE	Location_ID = @PULocID
					AND	Vehicle_Class_Code = @VCCode
					AND	(Calendar_Date  >= convert(datetime, convert(varchar, dateadd(dd,1,@PickUpOn) ,106)+' 00:00' ) and Calendar_Date <=   convert(datetime, convert(varchar,dateadd(dd,-1,@DropOffOn),106))+' 23:59')
				end

			if @PickUpOn>= convert(datetime,CONVERT(VarChar, @PickUpOn,106) + @OVFrom)	
						and @DropOffOn>convert(datetime,CONVERT(VarChar, @DropOffOn,106) + @AMFrom)
						and @DropOffOn<=convert(datetime,CONVERT(VarChar, @DropOffOn,106) + @PMFrom)
				begin	
					print 'Case 4-2'
					UPDATE	RP_Truck_Availability
						SET	OV_Availability = OV_Availability-1
					WHERE	Location_ID = @PULocID
					AND	Vehicle_Class_Code = @VCCode
					AND	(Calendar_Date =  convert(datetime, convert(varchar,@PickUpOn ,106)+' 00:00' ))

					UPDATE	RP_Truck_Availability
						SET	AM_Availability = AM_Availability-1,
							PM_Availability =PM_Availability-1,
							OV_Availability = OV_Availability-1
					WHERE	Location_ID = @PULocID
					AND	Vehicle_Class_Code = @VCCode
					AND	(Calendar_Date  >= convert(datetime, convert(varchar, dateadd(dd,1,@PickUpOn) ,106)+' 00:00' ) and Calendar_Date <=   convert(datetime, convert(varchar,dateadd(dd,-1,@DropOffOn),106))+' 23:59')

					UPDATE	RP_Truck_Availability
						SET	AM_Availability = AM_Availability-1
					WHERE	Location_ID = @PULocID
					AND	Vehicle_Class_Code = @VCCode
					AND	(Calendar_Date =  convert(datetime, convert(varchar,@DropOffOn ,106)+' 00:00' ))
				end

			if @PickUpOn>= convert(datetime,CONVERT(VarChar, @PickUpOn,106) + @OVFrom)	
						and @DropOffOn>convert(datetime,CONVERT(VarChar, @DropOffOn,106) + @PMFrom)
						and @DropOffOn<=convert(datetime,CONVERT(VarChar, @DropOffOn,106) + @OVFrom)
				begin	
					print 'Case 4-3'
					UPDATE	RP_Truck_Availability
						SET	OV_Availability = OV_Availability-1
					WHERE	Location_ID = @PULocID
					AND	Vehicle_Class_Code = @VCCode
					AND	(Calendar_Date =  convert(datetime, convert(varchar,@PickUpOn ,106)+' 00:00' ))

					UPDATE	RP_Truck_Availability
						SET	AM_Availability = AM_Availability-1,
							PM_Availability =PM_Availability-1,
							OV_Availability = OV_Availability-1
					WHERE	Location_ID = @PULocID
					AND	Vehicle_Class_Code = @VCCode
					AND	(Calendar_Date  >= convert(datetime, convert(varchar, dateadd(dd,1,@PickUpOn) ,106)+' 00:00' ) and Calendar_Date <=   convert(datetime, convert(varchar,dateadd(dd,-1,@DropOffOn),106))+' 23:59')

					UPDATE	RP_Truck_Availability
						SET	AM_Availability = AM_Availability-1,
							PM_Availability =PM_Availability-1
					WHERE	Location_ID = @PULocID
					AND	Vehicle_Class_Code = @VCCode
					AND	(Calendar_Date =  convert(datetime, convert(varchar,@DropOffOn ,106)+' 00:00' ))
				end

			if @PickUpOn>= convert(datetime,CONVERT(VarChar, @PickUpOn,106) + @OVFrom)	
						and @DropOffOn>convert(datetime,CONVERT(VarChar, @DropOffOn,106) + @OVFrom)
				begin	
					print 'Case 4-4'
					UPDATE	RP_Truck_Availability
						SET	OV_Availability = OV_Availability-1
					WHERE	Location_ID = @PULocID
					AND	Vehicle_Class_Code = @VCCode
					AND	(Calendar_Date =  convert(datetime, convert(varchar,@PickUpOn ,106)+' 00:00' ))

					UPDATE	RP_Truck_Availability
						SET	AM_Availability = AM_Availability-1,
							PM_Availability =PM_Availability-1,
							OV_Availability = OV_Availability-1
					WHERE	Location_ID = @PULocID
					AND	Vehicle_Class_Code = @VCCode
					AND	(Calendar_Date  >= convert(datetime, convert(varchar, dateadd(dd,1,@PickUpOn) ,106)+' 00:00' ) and Calendar_Date <=   convert(datetime, convert(varchar,@DropOffOn,106))+' 23:59')
				end



		   FETCH NEXT FROM Reservation_cursor
		   INTO @PULocID,@VCCode,@PickUpOn,@DropOffOn
			print @PickUpOn
			print @DropOffOn

		END

		CLOSE Reservation_cursor
		DEALLOCATE Reservation_cursor

update truck_inventory
	set am_availability=ta.am_availability,
		pm_availability=ta.pm_availability,
		OV_availability=ta.OV_availability	
--select *
from truck_inventory TI inner join 
	RP_Truck_Availability TA 
		on ti.location_id=ta.location_id
			and ti.vehicle_class_code=ta.vehicle_class_code
			and ti.calendar_date=ta.calendar_date
--where ti.am_availability<>ta.am_availability or
--		ti.pm_availability<>ta.pm_availability or
--		ti.OV_availability<>ta.OV_availability	


GO
