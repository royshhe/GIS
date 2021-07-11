USE [GISData]
GO
/****** Object:  UserDefinedFunction [dbo].[GetKMCharge]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create FUNCTION [dbo].[GetKMCharge] 
(
    @AgreementYear		VarChar(10),	
	@PurchaseCycle		VarChar(10),
	@ManufacturerName	VarChar(20),
	@Program		VarChar(10),
	@KMReading		VarChar(15)
)

RETURNS decimal(9,2) 
AS
BEGIN

Declare @KMCharge decimal(9,2)


Select @KMReading=NULLIf(@KMReading, '')
Declare @iKMReading Int
Select @iKMReading=CONVERT(Int, @KMReading)

Declare @ManufacturerID varchar(50)
select @ManufacturerID=Code from lookup_table where category ='Manufacturer' and Value=@ManufacturerName

SELECT   @KMCharge=
				  Sum(KM_Charge*
								  (
									Case When @iKMReading between KM_Start and KM_End then @iKMReading-KM_Start+1
											 When @iKMReading>KM_End Then KM_End-KM_Start+1
											  Else 0
									End)
					)



FROM         dbo.FA_KM_Charge
where Agreement_Year=@AgreementYear and Purchase_Cycle=@PurchaseCycle and Program=convert(bit,@Program) and 
(@iKMReading >= KM_Start) and Manufacturer	=@ManufacturerID

Return @KMCharge

End
GO
