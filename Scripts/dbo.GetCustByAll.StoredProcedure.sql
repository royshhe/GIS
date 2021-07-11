USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCustByAll]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec GetCustByAll 'lei','winnie','','','',''

CREATE PROCEDURE [dbo].[GetCustByAll]
	@LastName	Varchar(25),
	@FirstName	Varchar(25),
	@City		Varchar(25),
	@BCN		Varchar(25),
	@Phone		Varchar(35),
	@Licence	Varchar(25)
AS


Declare @sLastName	Varchar(26)
Declare @sFirstName	Varchar(26)
Declare @sCity		Varchar(26)
Declare @sBCN		Varchar(26)
Declare @sPhone		Varchar(36)
Declare @sLicence	Varchar(26) 

DECLARE @SQLString VARCHAR(5000) 

            /* 2/19/99 - cpy - bug fix */
            /* 6/01/99 - cpy bug fix - only return organization_id if the organization
                                                   is active; if inactive, return null */
            /* 10/05/99 - @Licence varchar(15) -> varchar(25) */ 

            Select @sLastName = LTrim(@LastName + '%')
            Select @sFirstName = LTrim(@FirstName + '%')
            Select @sCity = LTrim(@City + '%')
            Select @sBCN = LTrim(@BCN + '%')
            Select @sPhone = LTrim(@Phone + '%')
            Select @sLicence = LTrim(@Licence + '%')
 
            select @SQLString='Select Top 100 
                        Customer_ID, Last_Name, First_Name, Address_1,
                        Phone_Number, Driver_Licence_Number,
                        Convert(Char(11),Birth_Date, 13),
                        Program_Number,
                        -- Organization_ID,
                        Org_Id= (SELECT          O.Organization_Id
                                    FROM   Organization O
                                    WHERE            O.Organization_Id = C.Organization_Id
                                    AND     O.Inactive = 0),
                        Gender,
                        Convert(Char(1), Do_Not_Rent),
                        Remarks, Address_2, City, Province,
                        Postal_Code, Country, Email_Address,
                        Convert(Char(11),Driver_Licence_Expiry,13),
                        Jurisdiction,
                        Payment_Method,
                        VC.Vehicle_Class_Name,
                        Smoking_Non_Smoking,
                        Convert(Char(1), Add_LDW),
                        Convert(Char(1), Add_PAI),
                        Convert(Char(1), Add_PEC),
						'''',-- Preferred_FF_Plan_ID,
						'''',-- Preferred_FF_Member_number,
						'''',--CC.Credit_Card_Type_Id,
						'''',--CC.Credit_Card_Number,
						'''',--CC.Expiry,
		                Company_Name,
                        Company_Phone_Number
            From  Customer C Left Join
                        Vehicle_Class VC
				On  C.Vehicle_Class_Code = VC.Vehicle_Class_Code
            Where
                       
                        Inactive = 0' 

        if @LastName<>'' 
           Select @SQLString= @SQLString +' And Last_Name like '''+@sLastName+''''
        if @FirstName <> ''
               Select @SQLString= @SQLString +' And         First_Name like '''+@sFirstName+''''
        if @City <> ''
           Select @SQLString= @SQLString +' And ISNULL(City,'''') like '''+@sCity+''''
        if @BCN <> ''
           Select @SQLString= @SQLString +' And ISNULL(Program_Number,'''') like '''+ @sBCN+''''
            if @Phone <> ''
           Select @SQLString= @SQLString +' And ISNULL(Phone_Number,'''') like '''+ @sPhone+''''
            if @Licence <> ''
               Select @SQLString= @SQLString +' And         ISNULL(Driver_Licence_Number,'''') like '''+@sLicence+''''
        Select @SQLString= @SQLString +' 
            ORDER BY Last_Name, First_Name, City'
 
-- print @SQLString
 
exec (@SQLString) 

Return 1
GO
