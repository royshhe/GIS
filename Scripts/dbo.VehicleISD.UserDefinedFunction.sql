USE [GISData]
GO
/****** Object:  UserDefinedFunction [dbo].[VehicleISD]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[VehicleISD] 
(
  @pUnitNumber Int
)

RETURNS DateTime
AS
BEGIN

Declare @ISD DateTime
Declare @rentalStartDate DateTime
Declare @LeaseStartDate DateTime

Select @rentalStartDate=dbo.FA_Rental_Start_Date_vw.ISD from FA_Rental_Start_Date_vw Where Unit_Number=@pUnitNumber
Select @LeaseStartDate=dbo.FA_Status_Date_AfterOwn_vw.ISD  from FA_Status_Date_AfterOwn_vw Where Unit_Number=@pUnitNumber

Select @ISD=
Convert(Varchar,  (Case 
		When  @rentalStartDate is  Not Null And @LeaseStartDate Is Null  Then @rentalStartDate
        When  @rentalStartDate is  Null And @LeaseStartDate Is Not Null  Then @LeaseStartDate
        When  @rentalStartDate is  Not Null And @LeaseStartDate Is Not Null  Then
				 
						(Case When  @rentalStartDate<=@LeaseStartDate  Then @rentalStartDate
								 Else @LeaseStartDate
						End)
            
         When  @rentalStartDate is  Null And  @LeaseStartDate Is  Null  Then Null
END),106)

Return @ISD

End
GO
