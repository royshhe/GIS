USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetVIPCustomerReport]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





/*  Programmer:   Jack Jian
     Date:	 Feb 26, 2001
     Details: 	 Get Customer  who rent over a certain times   Tracker#  1831
*/



CREATE PROCEDURE [dbo].[GetVIPCustomerReport]

	@RentTimes int  = 2
 
as

--PRINT '***************************************************************************     VIP Customers     ********************************************************************************' 
--PRINT '*************************************************************************** (Over ' + ltrim(str(@RentTimes)) + ' Times Rental) ********************************************************************************' 
--PRINT '***************************************************************************  ' + ltrim(getdate()) + '  ********************************************************************************' 

declare @CompanyCode int  --remove hardcode code
select @CompanyCode=Code from Lookup_Table where Category = 'BudgetBC Company'


	select Customer_ID, Last_Name , First_Name , Address_1 , city, Province , Postal_Code  
--	select  Last_Name , ',' , first_name
	from customer 
	where @RentTimes < 
		(select count(contract_number) 
			from contract 
			where contract.customer_id = customer.customer_id 
				and contract.status = 'CI' 
				and contract.Pick_Up_Location_ID in 
					( select location.Location_ID
					   from  location 
					   where Owning_Company_ID = @CompanyCode
					)
		)
	order by last_name , first_name
















GO
