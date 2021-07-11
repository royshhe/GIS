USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLocationVehSpecFee]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

--select * from LocationVC_Specific_Fee

CREATE Procedure [dbo].[GetLocationVehSpecFee]  --16,'B','39',  '2017-07-25 10:00', '2017-06-25 09:00'
	@LocationID varchar(5),
	@VehicleClassCode varchar(1),
	@ChargeType varchar(5),
	@PickUpDate varchar(25),
	@ResBookDate   varchar(25)
AS

Declare @sChargeType	SmallInt, 
	@sPickUpDate	datetime,
	@sResBookDate   datetime,
	@dImplementDate datetime

Select @dImplementDate='2017-08-01'

SELECT @sChargeType = Convert(SmallInt, NULLIF(@ChargeType,'')),
	 @sPickUpDate = CONVERT(datetime, NULLIF(@PickUpDate, '')),
	@sResBookDate= CONVERT(datetime, NULLIF(@ResBookDate, ''))
--
--IF @VehicleClassCode = ''
--	
--	BEGIN 
--		EXEC  GetLocationSpecFee @LocationID, @ChargeType, @PickUpDate, @ResBookDate
--	END
--ELSE
--	BEGIN
			--IF @sResBookDate  IS NOT NULL 
			IF @sResBookDate  IS NOT NULL 
			And Not (@sResBookDate>=@dImplementDate and @ChargeType='39')
					BEGIN
						SELECT  Fee_Type,
							Location_ID, 
							Percentage_Fee = CASE WHEN Percentage_Fee is not null 
										THEN	Percentage_Fee
										ELSE	0
										END,
							Flat_Fee = CASE WHEN Flat_Fee is not null
									THEN	Flat_Fee
									ELSE	0
									END,
							Per_Day_Fee = CASE WHEN Per_Day_Fee is not null
									THEN	Per_Day_Fee
									ELSE	0
									END
						FROM LocationVC_Specific_Fee
						WHERE Location_ID = @locationID And
							 (Vehicle_Class_Code = @VehicleClassCode or Vehicle_Class_Code ='*')  and
							 Fee_type = @sChargeType And
							 @sResBookDate >= Valid_from and
							@sResBookDate < Convert(Datetime, Valid_To)+1 		
		                   
					END
				ELSE
					BEGIN

						SELECT  Fee_Type,
							Location_ID, 
							Percentage_Fee = CASE WHEN Percentage_Fee is not null 
										THEN	Percentage_Fee
										ELSE	0
										END,
							Flat_Fee = CASE WHEN Flat_Fee is not null
									THEN	Flat_Fee
									ELSE	0
									END,
							Per_Day_Fee = CASE WHEN Per_Day_Fee is not null
									THEN	Per_Day_Fee
									ELSE	0
									END

						FROM LocationVC_Specific_Fee
						WHERE Location_ID = @locationID And
							  (Vehicle_Class_Code = @VehicleClassCode or Vehicle_Class_Code ='*')  And
							 Fee_type = @sChargeType And
							 @sPickUpdate >= Valid_from and
							@sPickUpdate < Convert(Datetime, Valid_To)+1 
						
					END

--			END





SET ANSI_NULLS OFF
GO
