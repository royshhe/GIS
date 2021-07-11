USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[ValidateCredit]    Script Date: 2021-07-10 1:50:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
PURPOSE: To do credit check for the organization and return 0 if it has enough credit.
MOD HISTORY:
Name    Date        	Comments
Don K 	Mar 15 1999 	- Used outer join to bgt_armaster and aractcus 
CPY	Jan 6 2000	- retrieve @thisOrgName regardless of status_type
Rhe MSSQL 2008 UPGRADE
select * from armaster
*/


CREATE PROCEDURE [dbo].[ValidateCredit] -- 'expedia', 55
@OrgID varchar(255), @Amount varchar(35)
AS
Declare @thisOrgName varchar(255)
Declare @thisCreditAmount decimal(12,2)

select @orgid=replace(@orgid,'''''','''')

Select @thisOrgName = (Select
				Address_Name
			From
				armaster
			Where
				Customer_Code = @OrgID
				And Address_Type = 0
				--And Status_Type = 1
			)

Select @thisCreditAmount = (Select
	(ACM.Credit_Limit - ISNULL(ACustA.Amt_Balance, 0) - ACA.Daily_Contract_Total - ACA.Expected_Open_Contract_Charges)
--			From
--				bgt_armaster BACM, armaster ACM,
--				AR_Credit_Authorization ACA, aractcus ACustA



			From
					armaster ACM
			Inner Join AR_Credit_Authorization ACA
						On ACM.Customer_Code= ACA.Customer_Code 
			Left Join  bgt_armaster BACM
						On  ACM.Customer_Code= BACM.Customer_Code And ACM.Address_Type =BACM.Address_Type And ACM.Ship_To_Code=BACM.Ship_To_Code
			Left Join 	 aractcus ACustA
						On  ACM.Customer_Code= ACustA.Customer_Code 


			Where
				ACM.Customer_Code = @OrgID
--				And BACM.Customer_Code =* ACM.Customer_Code
--				And BACM.Address_Type =* ACM.Address_Type
--				And BACM.Ship_To_Code =* ACM.Ship_To_Code
--				And ACustA.Customer_Code =* ACM.Customer_Code
--				And ACA.Customer_Code = ACM.Customer_Code
				And ACM.Address_Type = 0)
If (@thisCreditAmount >= Convert(decimal(12,2),@Amount))
	/* Set to 0 if credit OK */
	Select @thisCreditAmount = 0
Select @thisCreditAmount, @thisOrgName
Return 1
GO
