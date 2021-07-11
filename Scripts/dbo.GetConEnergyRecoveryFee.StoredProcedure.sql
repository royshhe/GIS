USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetConEnergyRecoveryFee]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetConEnergyRecoveryFee] --'16', '13 apr 2006',''
	@PULocId Varchar(10),
	@VehicleClassCode varchar(1),
	@RateDate varchar(30)
AS
	/* 10/10/99 - do type conversion and nullif outside of sql statement */
DECLARE @iPULocId SmallInt,
	@dResBookDate datetime

	SELECT	@iPULocId = Convert(SmallInt, NULLIF(@PULocId,''))
		--@dResBookDate=case when @ResBookDate=''
		--		then convert(datetime,'12/31/2078 23:59')
		--		else convert(datetime,@ResBookDate)
		--		end


	SELECT  Per_Day_Fee = CASE WHEN Per_Day_Fee is not null
				THEN	Per_Day_Fee
				ELSE	0
				END,
		Percentage_Fee = CASE WHEN Percentage_Fee is not null 
					THEN	Percentage_Fee
					ELSE	0
					END,
		Flat_Fee = CASE WHEN Flat_Fee is not null
				THEN	Flat_Fee
				ELSE	0
				END
	FROM LocationVC_Specific_Fee--Location_Specific_Fees
	WHERE Location_ID = @PULocId  And
		 Fee_type = '46' And
		 (Vehicle_Class_Code = @VehicleClassCode or Vehicle_Class_Code ='*') And		 
		 (@RateDate >= Valid_from) And
		@RateDate < Convert(Datetime, Valid_To)+1
	RETURN @@ROWCOUNT
GO
