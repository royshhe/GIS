USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetSearchReservationData]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[GetSearchReservationData]
	@ConfirmationNumber varchar(35),	-- used for gis and foreign
	@ForeignConfirmationNumber varchar(35),	-- not used
	@LastName varchar(25),
	@FirstName varchar(25),
	@PickUpDate varchar(35),	-- expecting DD MMM YYYY only, no time
	@PickUpLocation varchar(6),	-- expecting location id
	@CreditCardTypeId varchar(3),	-- expecting CC Type Id eg. 'AMX','VSA'
	@CreditCardNumber varchar(35),
	@ReservationStatus char(1)	-- expecting code
AS
DECLARE	@iConfirmNum Int
DECLARE @sForeignConfirmNum Varchar(35)
DECLARE @dPickUpBegin Datetime
DECLARE @dPickUpEnd Datetime

/* 8/18/2011 - added by Andy Z - */
DECLARE @sqlCreditCardNumber varchar(35)
SELECT	@sqlCreditCardNumber = REPLACE(@CreditCardNumber,'*','%')
	/* 2/20/99 - cpy modified - Cc search bug fix */
        /* 20040702 - Recycle Res Number, fix the result to only return current one*/
       /*20050125--Upgraded to compatibilty 80   */

	SET ROWCOUNT 100

	SELECT @ConfirmationNumber = NULLIF(@ConfirmationNumber,''),
		@iConfirmNum = CASE WHEN ISNUMERIC(@ConfirmationNumber) = 1
			THEN Convert(Int, NULLIF(@ConfirmationNumber,''))
		   	ELSE NULL
		   END,
		@sForeignConfirmNum = NULLIF(@ConfirmationNumber,''),
		--@LastName = NULLIF(@LastName,''),
		--@FirstName = NULLIF(@FirstName,''),
		@PickUpDate = NULLIF(@PickUpDate,''),
		@dPickUpBegin = Convert(Datetime, @PickUpDate + ' 00:00'),
		--@dPickUpEnd = Convert(Datetime, ISNULL(@PickUpDate,'31 Dec 2078') + ' 23:59:59:999'),
		@dPickUpEnd = Convert(Datetime, ISNULL(@PickUpDate,'31 Dec 2078') + ' 23:59:59:998'),
		@PickUpLocation = NULLIF(@PickUpLocation,''),
		@CreditCardTypeId = NULLIF(@CreditCardTypeId,''),
		--@CreditCardNumber = NULLIF(@CreditCardNumber,''),
		@ReservationStatus = NULLIF(@ReservationStatus,'')

	Select 	Distinct
		R.Confirmation_Number,
		R.Last_Name,
		R.First_Name,
		R.Pick_Up_On,
		--Convert(Varchar(17), R.Pick_Up_On, 13),
		L.Location,
		VC.Vehicle_Class_Name,
		LT.Value,
		R.Foreign_Confirm_Number
/*, Debug
		R.Foreign_Confirm_Number,
		CC.Credit_Card_Type_Id,
		CC.Credit_Card_Number */
	From
		Reservation R
		JOIN Location L
		  ON R.Pick_Up_Location_ID = L.Location_ID

		JOIN Vehicle_Class VC
		  ON R.Vehicle_Class_Code = VC.Vehicle_Class_Code

		JOIN Lookup_Table LT
		  ON R.Status = LT.Code
		 And LT.Category = 'Reservation Status'

		LEFT JOIN
			Reservation_CC_Dep_Payment RCDP
			JOIN Credit_Card CC
			  ON RCDP.Credit_Card_Key = CC.Credit_Card_Key
		  ON R.Confirmation_Number = RCDP.Confirmation_Number

	Where
		((@ConfirmationNumber IS NOT NULL
		  	AND
			((R.Confirmation_Number = @iConfirmNum
			  AND R.Foreign_Confirm_Number IS NULL)
			 OR	
			 R.Foreign_Confirm_Number LIKE @sForeignConfirmNum + '%')
		 )
		 OR @ConfirmationNumber IS NULL)
	AND	R.Last_Name Like @LastName + '%'
	AND	R.First_Name Like @FirstName + '%'
	And 	R.Pick_Up_On BETWEEN ISNULL(@dPickUpBegin, R.Pick_Up_On) AND
				ISNULL(@dPickUpEnd, R.Pick_Up_On)
	And 	R.Status = ISNULL(@ReservationStatus, R.Status)
	And 	R.Pick_Up_Location_Id = ISNULL(@PickUpLocation, R.Pick_Up_Location_Id)
	And 	ISNULL(CC.Credit_Card_Type_Id,'') = ISNULL(@CreditCardTypeId, ISNULL(CC.Credit_Card_Type_Id,''))
	And 	ISNULL(CC.Credit_Card_Number,'') Like LTrim(@sqlCreditCardNumber) + '%'
      --  And     R.Pick_Up_On>getdate()-400

--	Order By R.Confirmation_Number
	ORDER BY R.Last_Name, R.First_Name, R.Pick_UP_On Desc
	Return 1
GO
