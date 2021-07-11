USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[LoadOrganization]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[LoadOrganization]
As
	
	delete BCD_Data where Data is null or Data=''
	select Substring(Data,44,40) as Organization,  
	Substring(Data,156,15) as BCD_Number, 
	Substring(Data,84,40) as Address_1,
	Substring(Data,124,20) as City,  
	--Substring(Data,144,2) as Province,   
	Prov.Value  as Province,   
	Substring (Data,36,3) as Country, 
	Substring (Data,146,10) as  Phone_Number  Into #Organization
	from BCD_Data Left Join (Select * from lookup_table where category = 'Province') Prov
	On Substring(BCD_Data.Data,144,2)=Prov.Code

	
	--Update the Existing...
	Update Organization 
	SET Organization=NewOrg.Organization,
		BCD_Number=NewOrg.BCD_Number,
		Address_1=NewOrg.Address_1,
		City=NewOrg.City,
		Province=NewOrg.Province,
		Country=NewOrg.Country,
		Phone_Number=NewOrg.Phone_Number,
		Last_Changed_By='SQL Job',
		Last_Changed_On	= getdate()
	from Organization Org inner join #Organization NewOrg on Org.BCD_Number=NewOrg.BCD_Number
	where not (NewOrg.BCD_Number is null or NewOrg.BCD_Number='')		 

    -- Insert New
	INSERT INTO Organization
		(Organization, BCD_Number, Address_1, Address_2,
		 City, Province, Country, Postal_Code,
		 Phone_Number, Fax_Number,
		 Contact_Name, Contact_Position, Contact_Phone_Number,
		 Contact_Fax_Number, Contact_Email_Address, Commission_Payable,
		 Org_Type, Remarks, Inactive, Last_Changed_By, Last_Changed_On,
		 Maestro_Commission_Paid, Maestro_Freq_Flyer_Honoured, Tour_Rate_Account,
		 Maestro_Rate_Override, AR_Customer_Code, Marketing_Source)		 
	select distinct Organization, BCD_Number,Address_1,'' Address_2,
		 City,Province,  Country,'' Postal_Code,
		 Phone_Number, '' Fax_Number, 
		 '' Contact_Name,'' Contact_Position,'' Contact_Phone_Number,
		 '' Contact_Fax_Number, '' Contact_Email_Address,'N' Commission_Payable,
		 '' Org_Type, '' Remarks,0 Inactive, 'SQL Job' Last_Changed_By, getdate() Last_Changed_On,
		 1,1,0,0, '', 'C' from #Organization NewOrg where NewOrg.BCD_Number not in (Select BCD_Number from Organization)
		 
	-- Remove Data being processed
	Delete 	BCD_Data	 
	from BCD_Data inner join #Organization on Substring(BCD_Data.Data,156,15) =#Organization.BCD_Number
		 
    Drop Table #Organization

GO
