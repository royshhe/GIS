USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetLocationSpecFee]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





CREATE Procedure [dbo].[GetLocationSpecFee]  --16, '96', '2008-10-02 10:00', '2008-10-01 09:00'
	@LocationID varchar(5),
	@ChargeType varchar(5),
	@PickUpDate varchar(25),
	@ResBookDate   varchar(25)
AS

Declare @sChargeType	SmallInt, 
	@sPickUpDate	datetime,
	@sResBookDate   datetime

SELECT @sChargeType = Convert(SmallInt, NULLIF(@ChargeType,'')),
	 @sPickUpDate = CONVERT(datetime, NULLIF(@PickUpDate, '')),
	@sResBookDate= CONVERT(datetime, NULLIF(@ResBookDate, ''))

IF @LocationID = '*'
	BEGIN

		IF @sResBookDate  IS NOT NULL 
			BEGIN

					SELECT 	Fee_Type,
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
					FROM Location_Specific_Fees
					WHERE Fee_type = @sChargeType 
						AND @sResBookDate >= Valid_from and
						@sResBookDate < Convert(Datetime, Valid_To)+1 
			END
		ELSE
			BEGIN

				SELECT 	Fee_Type,
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
					FROM Location_Specific_Fees
					WHERE Fee_type = @sChargeType And
						 @sPickUpdate >= Valid_from and
						@sPickUpdate < Convert(Datetime, Valid_To)+1 
						--and
						--@sResBookDate>=Valid_from
			END



	END 
ELSE
	BEGIN
		IF @sResBookDate  IS NOT NULL 
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
				FROM Location_Specific_Fees
				WHERE Location_ID = @locationID And
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

				FROM Location_Specific_Fees
				WHERE Location_ID = @locationID And
					 Fee_type = @sChargeType And
					 @sPickUpdate >= Valid_from and
					@sPickUpdate < Convert(Datetime, Valid_To)+1 
				
			END

	END


GO
