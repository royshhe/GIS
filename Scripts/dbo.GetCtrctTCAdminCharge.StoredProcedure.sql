USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCtrctTCAdminCharge]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[GetCtrctTCAdminCharge]     --2034515, 'T3'
	@ContractNumber Varchar(20),
	@Issuer	Varchar(10)
AS 
-- if Toll Fee Charge or Toll Fee Admin Charge exist in contract, No More Admin Charge needed
Declare @AmountCharged decimal(9,2)
Declare @ReportingCount int

Select @AmountCharged= Sum(Amount)   from Contract_Charge_Item 
Where Contract_Number= convert(int, @ContractNumber) and Charge_type in (48, 49)
	--And Issuer=	@Issuer
Group by Contract_Number,Issuer 


SELECT @ReportingCount= count(*)  
FROM  Toll_Reporting 
where contract_number=convert(int, @ContractNumber) 
or 
Confirmation_Number in (
	Select foreign_confirm_number from reservation where confirmation_number in
	(Select confirmation_number from Contract where contract_number=convert(int, @ContractNumber))  

)



if	 (@AmountCharged>0 or @ReportingCount>0)
     Select 0
else
    
  begin 
	insert into TollAdminCharge
		select @ContractNumber as contract_number,
				@Issuer as Issuer,
				(select Convert(Decimal(9,2),Value) from lookup_table where Category ='Toll Fee Admin Charge' and Code= @Issuer ) as AdminAmount,
				getdate()

    --Select 0
	 Select Convert(Decimal(9,2),Value) as AdminAmount from lookup_table where Category ='Toll Fee Admin Charge' and Code= @Issuer   
  end
  
  

GO
