USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCustByPK]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  Stored Procedure dbo.GetCustByPK    Script Date: 2/18/99 12:11:53 PM ******/
/****** Object:  Stored Procedure dbo.GetCustByPK    Script Date: 2/16/99 2:05:41 PM ******/
/*  PURPOSE:		To retrieve the customer information for the given customer id
     MOD HISTORY:
     Name    Date        Comments
*/
CREATE PROCEDURE [dbo].[GetCustByPK] -- '147595'
	@CustId Varchar(10)
AS
	/* 981019 - cpy - removed DL Province, Country,
			  added DL Jurisdiction */
	/* 6/01/99 - cpy bug fix - only return organization_id if org is active;
				   if inactive org, return null in organization_id */
	/* 10/28/99 - np add prefreere_ff_plan_id and preferred_ff_member_number */
	/* get active customers by customer id */
	Declare @nCustId Integer
	Select @nCustId = Convert(Int, NULLIF(@CustId, ''))

	Select distinct	C.Customer_ID,
		C.Last_Name,
		C.First_Name,
		C.Address_1,
               	C.Phone_Number,
		C.Driver_Licence_Number,
		Convert(Char(11),C.Birth_Date,13),
		C.Program_Number,
		-- Organization_ID,
		Org_Id = (	SELECT	O.Organization_Id
			   	FROM	Organization O
			 	WHERE	O.Organization_Id = C.Organization_ID
			 	AND	O.Inactive = 0 ),
		C.Gender,
		Convert(Char(1),
		
			(Case When DNR.Do_Not_Rent is not null then	DNR.Do_Not_Rent 
				Else C.Do_Not_Rent
			 End		
			)
		) Do_Not_Rent,
		C.Remarks,
		C.Address_2,
		C.City,
		C.Province,
		C.Postal_Code,
		C.Country,
		C.Email_Address,
		Convert(Char(11),C.Driver_Licence_Expiry,13),
		C.Jurisdiction,
		C.Payment_Method,
		V.Vehicle_Class_Name,
		C.Smoking_Non_Smoking,
		Convert(Char(1), C.Add_LDW),
		Convert(Char(1), C.Add_PAI),
		Convert(Char(1), C.Add_PEC),
		--Preferred_FF_Plan_ID,
                ValidFF.Frequent_Flyer_Plan_ID as Preferred_FF_Plan_ID,
		case when ValidFF.Frequent_Flyer_Plan_ID is not null then
			Preferred_FF_Member_number
                end as Preferred_FF_Member_number,
		CC.Credit_Card_Type_Id,
		CC.Credit_Card_Number,
		CC.Expiry,
		C.Company_Name,
		c.Company_Phone_Number,
		RC.RentalCount,
		cc.Short_Token 
	From   Customer C  		
	       left join 
	         Vehicle_Class V
		       on  C.Vehicle_Class_Code = V.Vehicle_Class_Code
		left join  
		( 
			    SELECT     Frequent_Flyer_Plan_ID
                            FROM          Frequent_Flyer_Plan
                            WHERE      (Termination_Date > =GETDATE())
			   ) ValidFF
	         on Preferred_FF_Plan_ID=ValidFF.Frequent_Flyer_Plan_ID
		
		left join Credit_Card CC 
				on C.customer_id=CC.customer_id
				
		Left Join 
            (   SELECT count(*) RentalCount, con.Customer_ID 
				FROM  dbo.Contract AS con INNER JOIN
							   dbo.Vehicle_On_Contract AS voc ON con.Contract_Number = voc.Contract_Number
				WHERE (voc.Actual_Check_In IS NULL)	and con.status='co' and  con.Customer_ID  is not null
				Group by	con.Customer_ID ) RC
			On c.Customer_ID	 = RC.Customer_ID
		left join 
		
		(SELECT Do_Not_Rent,Driver_Licence_Number,Birth_Date, Last_Name, First_Name, Address_1, Address_2, City, Province,  Gender,   Driver_Licence_Expiry, Jurisdiction, 
			Program_Number
			FROM  dbo.Customer
		 WHERE (Do_Not_Rent = 1) and Customer_ID<>	@nCustId
		 )DNR

		 On Replace(Replace(C.Driver_Licence_Number, ' ',''), '-','')=Replace(Replace(DNR.Driver_Licence_Number, ' ',''), '-','') --C.Driver_Licence_Number = DNR.Driver_Licence_Number
		 And C.Birth_Date = DNR.Birth_Date
              
        where 
	Inactive = 0
	And    C.Customer_ID = @nCustId
	Return @@ROWCOUNT

GO
