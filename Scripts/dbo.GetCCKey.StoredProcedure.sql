USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetCCKey]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetCCKey]
	@CreditCardTypeID varchar(20),
	--@CreditCardNumber varchar(20),
	@ShortToken	 varchar(20),
	@LastName varchar(25),
	@FirstName varchar(25),
	@Expiry varchar(5),
	@SeqNum varchar(11)
AS
-- for Applicant case, add logic for advoice the credit card information from Maestro had been overridden. Peter Ni
	Declare @cckey as varchar(20)
	DECLARE @isApplicant as integer
	Declare @CreditCardKey as varchar(20)
	
	SELECT @CCKEY=(SELECT	TOP 1 credit_card_key
			  FROM	Credit_Card WITH(NOLOCK) 
			 WHERE	ISNULL(credit_card_type_id, '') = @CreditCardTypeID
			   --AND	ISNULL(credit_card_number, '') = @CreditCardNumber
			   And	ISNULL(Short_Token, '') = @ShortToken
			   AND	ISNULL(expiry, '') = @Expiry
			   AND	ISNULL(last_name, '') = @LastName
			   AND	ISNULL(first_name, '') = @FirstName
			   AND	(ISNULL(sequence_num, '') = @SeqNum OR (sequence_num IS NULL AND NULLIF(@SeqNum, '') IS NULL) )
			)
			
	select @isApplicant=(select count(*)
				from reservation r 
						inner join Customer C on R.customer_id=C.customer_id
						inner join credit_card CC on C.customer_id=cc.customer_id
				where CC.credit_card_key=@CCKEY	and R.status='A' and R.applicant_status_indicator='1'
				)
	if @isApplicant=0				
		SELECT	credit_card_key
						  FROM	Credit_Card WITH(NOLOCK) 
						 WHERE	ISNULL(credit_card_type_id, '') = @CreditCardTypeID
						   --AND	ISNULL(credit_card_number, '') = @CreditCardNumber
						   And	ISNULL(Short_Token, '') = @ShortToken
						   AND	ISNULL(expiry, '') = @Expiry
						   AND	ISNULL(last_name, '') = @LastName
						   AND	ISNULL(first_name, '') = @FirstName
						   AND	(ISNULL(sequence_num, '') = @SeqNum OR (sequence_num IS NULL AND NULLIF(@SeqNum, '') IS NULL) )
	  else
		SELECT	credit_card_key
						  FROM	Credit_Card WITH(NOLOCK) 
						 WHERE	ISNULL(credit_card_type_id, '') = @CreditCardTypeID
						   --AND	ISNULL(credit_card_number, '') = @CreditCardNumber
						   And	ISNULL(Short_Token, '') = @ShortToken
						   AND	ISNULL(expiry, '') = @Expiry
						   AND	ISNULL(last_name, '') = @LastName
						   AND	ISNULL(first_name, '') = @FirstName
						   AND	(ISNULL(sequence_num, '') = @SeqNum OR (sequence_num IS NULL AND NULLIF(@SeqNum, '') IS NULL) )
							and 1=0

	--select   @CreditCardKey	 AS credit_card_key  
	RETURN @@ROWCOUNT


--
--select count(*),Credit_Card_Type_ID,Credit_Card_Number,Expiry,Last_Name,First_Name from credit_card 
--group by Credit_Card_Type_ID,Credit_Card_Number,Expiry,Last_Name,First_Name
--having count(*)>1
--
GO
