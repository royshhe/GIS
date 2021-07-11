USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Credict_Card_TRansaction]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






---------------------------------------------------------------------------------------
--  Programmer :   S.Li
--  Date :         Jul 08, 2005
--  Details: 	 create credit card transaction report
---------------------------------------------------------------------------------------

CREATE Procedure [dbo].[RP_SP_Credict_Card_TRansaction] --'4', '01 feb 2011', '20 feb 2011'
		 @CreditCard_number varchar(20),
                 @StartDateInput varchar(30)='Jun 01 2005', 
                 @EndDateInput varchar(30)='Jun 30 2005'

AS 

SET NOCOUNT ON 

DECLARE @StartDate datetime, @EndDate datetime
SELECT @StartDate = CONVERT(DATETIME, @StartDateInput)
SELECT @EndDate = CONVERT(DATETIME, @EndDateInput)+1

select  dbo.ccmask(cct.Credit_Card_Number,4,4), 
	cct.Amount, 
	cct.RBR_Date, 
	cct.Contract_Number, 
	cct.Confirmation_Number, 
	cct.ContractPickupLocation, 
	cct.ResPickupLocation
from 
	(SELECT  dbo.Credit_Card.Credit_Card_Number as Credit_Card_Number,
		dbo.Contract_Payment_Item.Amount as Amount, 
		dbo.Contract_Payment_Item.RBR_Date as RBR_Date, 
		dbo.Contract_Payment_Item.Contract_Number as Contract_Number, 
		'' as Confirmation_Number,
        dbo.Location.Location as ContractPickupLocation,
		'' as ResPickupLocation,
		dbo.Contract_Payment_Item.Payment_Type as Payment_Type
FROM         dbo.Contract_Payment_Item INNER JOIN
                      dbo.Contract ON dbo.Contract_Payment_Item.Contract_Number = dbo.Contract.Contract_Number INNER JOIN
                      dbo.Renter_Primary_Billing ON dbo.Contract_Payment_Item.Contract_Number = dbo.Renter_Primary_Billing.Contract_Number INNER JOIN
                      dbo.Credit_Card ON dbo.Renter_Primary_Billing.Credit_Card_Key = dbo.Credit_Card.Credit_Card_Key INNER JOIN
                      dbo.Location ON dbo.Contract.Pick_Up_Location_ID = dbo.Location.Location_ID AND dbo.Contract.Drop_Off_Location_ID = dbo.Location.Location_ID
union

SELECT  dbo.Credit_Card.Credit_Card_Number as Credit_Card_Number, 
		dbo.Reservation_Dep_Payment.Amount as Amount, 
		dbo.Reservation_Dep_Payment.RBR_Date as RBR_Date, 
		'' as Contract_Number,
        dbo.Reservation_Dep_Payment.Confirmation_Number as Confirmation_Number, 
		'' as ContractPickupLocation,
		dbo.Location.Location as ResPickupLocation,
		dbo.Reservation_Dep_Payment.Payment_Type as Payment_Type

FROM         dbo.Reservation_Dep_Payment INNER JOIN
                      dbo.Reservation ON dbo.Reservation_Dep_Payment.Confirmation_Number = dbo.Reservation.Confirmation_Number INNER JOIN
                      dbo.Reservation_CC_Dep_Payment ON dbo.Reservation_Dep_Payment.Confirmation_Number = dbo.Reservation_CC_Dep_Payment.Confirmation_Number AND 
                      dbo.Reservation_Dep_Payment.Collected_On = dbo.Reservation_CC_Dep_Payment.Collected_On AND 
                      dbo.Reservation_Dep_Payment.Sequence = dbo.Reservation_CC_Dep_Payment.Sequence INNER JOIN
                      dbo.Credit_Card ON dbo.Reservation_CC_Dep_Payment.Credit_Card_Key = dbo.Credit_Card.Credit_Card_Key INNER JOIN
                      dbo.Location ON dbo.Reservation.Pick_Up_Location_ID = dbo.Location.Location_ID

) cct

where cct.Payment_Type='Credit Card' and
	cct.Credit_Card_Number like @CreditCard_number + '%'
	and cct.RBR_Date >= @StartDate and cct.RBR_Date < @EndDate

order by cct.Credit_Card_Number






GO
