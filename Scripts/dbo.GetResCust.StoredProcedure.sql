USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResCust]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  Stored Procedure dbo.GetResCust    Script Date: 2/18/99 12:11:56 PM ******/
/****** Object:  Stored Procedure dbo.GetResCust    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetResCust    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetResCust    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[GetResCust]    --'1208275'
	@CustId Varchar(10)
AS
DECLARE @CustomerId 	Int
DECLARE @LastName 	Varchar(25)
DECLARE @FirstName 	Varchar(25)
DECLARE @PhoneNumber 	Varchar(35)
DECLARE @Address1 	Varchar(50)
DECLARE @Address2 	Varchar(50)
DECLARE @City 		Varchar(25)
DECLARE @Province 	Varchar(25)
DECLARE @Country 	Varchar(25)
DECLARE @BirthDate 	Varchar(11)
DECLARE @EmailAddr 	Varchar(50)
DECLARE @PayMethod 	Varchar(20)
DECLARE @CCType 	Varchar(20)
DECLARE @CreditCardNumber Varchar(20)
DECLARE @ShortToken Varchar(20)
DECLARE @CCExpiry varchar(5)
DECLARE @HolderLastName 	Varchar(25)
DECLARE @HolderFirstName 	Varchar(25)

	/* 981123 - cpy - return CC type Id, not name */
	IF @CustId = '' 	SELECT @CustId = NULL
	/* Get Customer info */
	SELECT	@CustomerId = Customer_ID,
		@LastName = Last_Name,
		@FirstName = First_Name,
		@PhoneNumber = Phone_Number,
		@Address1 = Address_1,
		@Address2 = Address_2,
		@City = City,
		@Province = Province,
		@Country = Country,
		@BirthDate = Convert(Char(11), Birth_Date, 13),
		@EmailAddr = Email_Address,
		@PayMethod = Payment_Method
	FROM	Customer
	WHERE	Customer_ID = Convert(Int, @CustId)
	/* Get CC Type Id */
	SELECT 	@CCType = Credit_Card_Type_ID,
			@CreditCardNumber=Credit_Card_Number,
			@ShortToken=Short_Token,
			@CCExpiry=Expiry,
			@HolderLastName= Credit_Card.Last_Name,
			@HolderFirstName= Credit_Card.First_Name
			
	FROM	Credit_Card	 
	WHERE	Customer_ID = Convert(Int, @CustId)
	SELECT	@CustomerId, @LastName,	@FirstName, @PhoneNumber,
		@Address1, @Address2, @City, @Province, @Country, @BirthDate,
		@EmailAddr, @PayMethod, @CCType,@CreditCardNumber,@ShortToken,@CCExpiry,@HolderLastName,@HolderFirstName
	WHERE 	@CustomerId IS NOT NULL
		
	RETURN 1

--		select * from credit_card
--select top 100 * from customer where customer_id in (select customer_id from credit_card)  order by customer_id desc
GO
