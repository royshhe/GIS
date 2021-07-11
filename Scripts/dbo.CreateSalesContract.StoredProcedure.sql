USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateSalesContract]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.CreateSalesContract    Script Date: 2/18/99 12:12:00 PM ******/
/****** Object:  Stored Procedure dbo.CreateSalesContract    Script Date: 2/16/99 2:05:39 PM ******/
/****** Object:  Stored Procedure dbo.CreateSalesContract    Script Date: 1/11/99 1:03:14 PM ******/
/****** Object:  Stored Procedure dbo.CreateSalesContract    Script Date: 11/23/98 3:55:32 PM ******/
/*
PURPOSE: To insert a record into Sales_Accessory_Sale_Contract table.
MOD HISTORY:
Name    Date        Comments
 */

CREATE PROCEDURE [dbo].[CreateSalesContract]
	@SaleDate		Varchar(35),
	@LocationID		Varchar(35),
	@LastName 		Varchar(25),
	@FirstName 		Varchar(25),
	@Phone		 	Varchar(35),
	@Addr1 			Varchar(50),
	@Addr2	 		Varchar(50),
	@City 			Varchar(25),
	@Province 		Varchar(20),
	@Country	 	Varchar(20),
	@PostalCode 		Varchar(10),
	@RefundedContractNum 	Varchar(20),
	@RefundReason		Varchar(255),
	@User			Varchar(35)
AS
Insert Into Sales_Accessory_Sale_Contract
	(Sold_At_Location_ID, Sales_Date_Time, Sold_By, Last_Name, First_Name, Phone_Number,
	Address_1, Address_2, City, Province, Postal_Code, Country,
	Refunded_Contract_No, Refund_Reason)
Values
	(Convert(int,@LocationID), Convert(datetime, @SaleDate), @User,
	@LastName, @FirstName, @Phone,
	@Addr1, @Addr2, @City, @Province, @PostalCode, @Country,
	Convert(int, NULLIF(@RefundedContractNum, '')), @RefundReason)
RETURN @@IDENTITY
















GO
