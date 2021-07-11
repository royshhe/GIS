USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVehicleSalesTaxRates]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetVehicleSalesTaxRates]  --'178700', '37001', '2013-04-19'
    @UnitNumber Varchar(10),
	@VehicleSalesPrice Varchar(20),
	@CurrDatetime Varchar(24)
  
	
AS
	/* 9/27/99 - do type conversion outside of select */

    DECLARE @dCurrDatetime Datetime
	SELECT	@dCurrDatetime =  Convert(Datetime, NULLIF(@CurrDatetime,''))

	Declare	@nUnitNumber int
	SELECT		@nUnitNumber = Convert(int, NULLIF(@UnitNumber, ''))
    
    Declare @PassengerVehicle bit

    SELECT  @VehicleSalesPrice 	= NULLIF(@VehicleSalesPrice, '')

    SELECT	@PassengerVehicle=VMY.Passenger_Vehicle		
	FROM	Vehicle_Model_Year VMY,
		Vehicle V
	WHERE	V.Unit_Number = @nUnitNumber
	AND	V.Vehicle_Model_ID = VMY.Vehicle_Model_ID

--    Print 'P V' +convert(char(1), @PassengerVehicle)
--SElect @PassengerVehicle

  
	If  @PassengerVehicle=1
			Begin
				-- GST Rate
				SELECT 	Tax_Type, Tax_Rate, Rate_Type
				FROM		Tax_Rate				
				WHERE	@dCurrDatetime BETWEEN Valid_From AND Valid_To And (Tax_Type='GST' or tax_type='HST')

				Union

				SELECT     'PST' Tax_Type, 
				(Case 
					When @dCurrDatetime>='2013-04-01' or @dCurrDatetime<'2010-07-01' Then PST_Rate
					Else 0.00 
				End) PST_Rate, 'Percent'
--select *
				FROM         dbo.Vehicle_PST_Rate
				Where  (Convert(decimal(10,2), @VehicleSalesPrice) between Vehicle_Starting_Price And Vehicle_Ending_Price)
							And (@dCurrDatetime between Valid_From And Valid_To)

			End
	Else
			SELECT 	Tax_Type, Tax_Rate, Rate_Type
			FROM		Tax_Rate	
			WHERE	@dCurrDatetime BETWEEN Valid_From AND Valid_To

	RETURN @@ROWCOUNT

GO
