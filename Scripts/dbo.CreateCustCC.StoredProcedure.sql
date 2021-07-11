USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateCustCC]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
PROCEDURE NAME: CreateCustCC
PURPOSE: To create a credit card
AUTHOR: Cindy Yee
DATE CREATED: ?
CALLED BY: Customer
REQUIRES:
MOD HISTORY:
Name    Date        Comments
Don K	Oct 30 1998 Changed to use CCKey and no Primary_Card
Don K	Jun 14 1999 Use MAX + 1 instead of COUNT + 1 for generating sequence #
*/
CREATE PROCEDURE [dbo].[CreateCustCC]
	@CustId varchar(10),
	@CCType varchar(3),
	@CCNumber varchar(20),
	@CCExpiry char(5),
	@LastName Varchar(25),
	@FirstName Varchar(25),
	@UserName Varchar(20),
	@SeqRequired varchar(1),
	@ShortToken varchar(20)
AS
	/* 10/05/99 - @LastName, @FirstName varchar(20) -> varchar(25) */

DECLARE	@iCustId int,
	@iCCKey int,
	@iSeq int

Declare @cckey as varchar(20)
DECLARE @isApplicant as integer

	--SELECT @CCKEY=(SELECT	TOP 1 credit_card_key
	--		  FROM	Credit_Card WITH(NOLOCK) 
	--		 WHERE	ISNULL(credit_card_type_id, '') = @CCType
	--		   And	ISNULL(Short_Token, '') = @ShortToken
	--		   AND	ISNULL(expiry, '') = @CCExpiry
	--		   AND	ISNULL(last_name, '') = @LastName
	--		   AND	ISNULL(first_name, '') = @FirstName
	--		)
			
	select @isApplicant=(select count(*)
				from reservation r 
						inner join Customer C on R.customer_id=C.customer_id
						inner join credit_card CC on C.customer_id=cc.customer_id
				where CC.credit_card_key in (SELECT	 credit_card_key
											  FROM	Credit_Card WITH(NOLOCK) 
											 WHERE	ISNULL(credit_card_type_id, '') = @CCType
											   And	ISNULL(Short_Token, '') = @ShortToken
											   AND	ISNULL(expiry, '') = @CCExpiry
											   AND	ISNULL(last_name, '') = @LastName
											   AND	ISNULL(first_name, '') = @FirstName)	
						and R.applicant_status_indicator='1'
				)

	if @isApplicant>=1 
		select @SeqRequired='1'

SELECT	@iCustId = Convert(int, NULLIF(@CustId,''))
	IF @iCustId IS NOT NULL
		UPDATE	Credit_Card
		   SET	Customer_ID = NULL
		 WHERE	Customer_ID = @iCustId

	IF @SeqRequired = '1'
		-- Generate the next sequence number for this combination
		-- The ISNULLs allow you to match NULL entries in the table
		-- with empty string parameters.
		SELECT	@iSeq = ISNULL(MAX(sequence_num), 0) + 1
		  FROM	credit_card
		 WHERE	ISNULL(credit_card_type_id, '') = @CCType
		   AND	ISNULL(Short_Token, '') = @ShortToken
		   AND	ISNULL(expiry, '') = @CCExpiry
		   AND	ISNULL(last_name, '') = @LastName
		   AND	ISNULL(first_name, '') = @FirstName

	INSERT
	  INTO	Credit_Card
		(Credit_Card_Type_ID,
		 Credit_Card_Number,
		 Customer_ID,
		 Expiry,
		 Last_Name,
		 First_Name,
		 Sequence_Num,
		 Short_Token
		)
	VALUES	(NULLIF(@CCType, ''),
		 NULLIF(@CCNumber,''),
		 @iCustId,
		 NULLIF(@CCExpiry,''),
		 NULLIF(@LastName,''),
		 NULLIF(@FirstName,''),
		 @iSeq,
		 NULLIF(@ShortToken,'')
		)
	SELECT @iCCKey = @@IDENTITY
	/* Update Audit Info */
--	Update
--		Customer
--	Set
--		Last_Changed_By=@UserName,
--		Last_Changed_On=getDate()
--	Where
--		Customer_ID = @iCustId

--select * from Credit_Card_Log
--create credit card log........
	INSERT
	  INTO	Credit_Card_Log
		(Log_Type,
		 Credit_Card_Key,
		 Credit_Card_Type_ID,
		 Credit_Card_Number,
		 Short_Token,
		 Process_Date
		)
	VALUES	('Create',
			  @iCCKey,
			  NULLIF(@CCType, ''),
			  NULLIF(@CCNumber,''),
			  NULLIF(@ShortToken,''),
			  getdate()
		)

	RETURN @iCCKey

GO
