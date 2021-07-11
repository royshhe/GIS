USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[SaveAirMiles]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





/*
PROCEDURE NAME: SaveAirMiles
PURPOSE: To create a Air Miles Card
AUTHOR: Roy he
DATE CREATED: ?
CALLED BY: Customer
REQUIRES:
MOD HISTORY:
Name    Date        Comments
*/

CREATE PROCEDURE [dbo].[SaveAirMiles] --'Blue', '830145123291','Hea','Roi','NLuii'
	@AMType varchar(4),
	@AMNumber varchar(20),	
	@LastName Varchar(25),
	@FirstName Varchar(25),
	@UserName Varchar(20)
	
AS
	/* 10/05/99 - @LastName, @FirstName varchar(20) -> varchar(25) */

--select * from Air_Miles_Card

DECLARE	@iCount int


	
	SELECT	@iCount = count(CARD_number)
	  FROM	Air_Miles_Card
	 WHERE	ISNULL(CARD_number, '') = @AMNumber	  
	

	--if Exist, then just updated
	if @iCount>0 
		Update Air_Miles_Card 	
		Set   	
			Card_Type_ID=@AMType, 
			Last_Name=@LastName,
			First_Name=@FirstName,
			Last_Changed_By=@UserName,
			Last_Changed_On=getDate()
		where (ISNULL(CARD_number, '') = @AMNumber) and (Card_Type_ID<>@AMType or Last_Name<>@LastName or First_Name<>@FirstName)
	else

		INSERT
		  INTO	Air_Miles_Card
			(Card_Type_ID,
			 CARD_number,
			 Last_Name,
			 First_Name,
			 Last_Changed_By,
			 Last_Changed_On		 
			)
		VALUES	(NULLIF(@AMType, ''),
			 NULLIF(@AMNumber,''),		
			 NULLIF(@LastName,''),
			 NULLIF(@FirstName,''),
			 NULLIF(@UserName,''),
			 getDate()
			)
	
	return @@ROWCOUNT


GO
