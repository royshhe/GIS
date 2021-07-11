USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CreateTruckResCustCC]    Script Date: 2021-07-10 1:50:48 PM ******/
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
create PROCEDURE [dbo].[CreateTruckResCustCC]
	@CustId varchar(10),
	@CCType varchar(30),
	@CCNumber varchar(20),
	@CCExpiry char(5),
	@LastName Varchar(25),
	@FirstName Varchar(25),
	@UserName Varchar(20),
	@SeqRequired varchar(1)
AS
	/* 10/05/99 - @LastName, @FirstName varchar(20) -> varchar(25) */

DECLARE	@iCustId int,
	@iCCKey int,
	@iSeq int,
	@CCTypeID varchar(3)

SELECT	@iCustId = Convert(int, NULLIF(@CustId,''))
	IF @iCustId IS NOT NULL
		UPDATE	Credit_Card
		   SET	Customer_ID = NULL
		 WHERE	Customer_ID = @iCustId

	SELECT @CCTypeID=( SELECT Credit_Card_Type_ID
							FROM CREDIT_CARD_TYPE
							WHERE credit_card_type = @CCType
						)
	IF @SeqRequired = '1'
		-- Generate the next sequence number for this combination
		-- The ISNULLs allow you to match NULL entries in the table
		-- with empty string parameters.
		SELECT	@iSeq = ISNULL(MAX(sequence_num), 0) + 1
		  FROM	credit_card
		 WHERE	ISNULL(credit_card_type_id, '') = @CCTypeID
		   AND	ISNULL(credit_card_number, '') = @CCNumber
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
		 Sequence_Num
		)
	VALUES	(NULLIF(@CCTypeID, ''),
		 NULLIF(@CCNumber,''),
		 @iCustId,
		 NULLIF(@CCExpiry,''),
		 NULLIF(@LastName,''),
		 NULLIF(@FirstName,''),
		 @iSeq
		)
	SELECT @iCCKey = @@IDENTITY
	/* Update Audit Info */
	Update
		Customer
	Set
		Last_Changed_By=@UserName,
		Last_Changed_On=getDate()
	Where
		Customer_ID = @iCustId

	RETURN @iCCKey
GO
