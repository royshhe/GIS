USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[FA_GetKMCharge]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FA_GetKMCharge] -- '2010', '1', 'Ford','1','42000'
	@AgreementYear		VarChar(10),	
	@PurchaseCycle		VarChar(10),
	@ManufacturerName	VarChar(20),
	@Program		VarChar(10),
	@KMReading		VarChar(15)
	
AS

Select @KMReading=NULLIf(@KMReading, '')
Declare @iKMReading Int
Select @iKMReading=CONVERT(Int, @KMReading)

Declare @ManufacturerID varchar(50)
select @ManufacturerID=Code from lookup_table where category ='Manufacturer' and Value=@ManufacturerName


SELECT     Sum(KM_Charge*
								  (
									Case When @iKMReading between KM_Start and KM_End then @iKMReading-KM_Start+1
											 When @iKMReading>KM_End Then KM_End-KM_Start+1
											  Else 0
									End)
					)



FROM         dbo.FA_KM_Charge
where Agreement_Year=@AgreementYear and Purchase_Cycle=@PurchaseCycle and Program=convert(bit,@Program) and 
(@iKMReading >= KM_Start) and Manufacturer	=@ManufacturerID

/*Select * from FA_KM_Charge where agreement_year='2010' and purchase_cycle=1 and KM_Start<=42000


SELECT     KM_Charge*(42000-(KM_Start-1))
FROM         dbo.FA_KM_Charge
where Agreement_Year='2010' and Purchase_Cycle='1' and Program=1 and 
(KM_Start<=42000) and Manufacturer	=2
*/
GO
