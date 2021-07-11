USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetResDepPayment]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO












/****** Object:  Stored Procedure dbo.GetResDepPayment    Script Date: 2/18/99 12:12:16 PM ******/
/****** Object:  Stored Procedure dbo.GetResDepPayment    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetResDepPayment    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetResDepPayment    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[GetResDepPayment]
	@ConfirmNum Varchar(20)
AS
/*** THIS IS NOT BEING USED
- delete from here and from reservations dll
		REPLACED BY GetResDepCA/CR

	IF @ConfirmNum = "" 	SELECT @ConfirmNum = NULL
	SELECT	RDP.Collected_On,
		RDP.Payment_Type,
		CC.Credit_Card_Type_ID,
		CC.Credit_Card_Number,
		CC.Last_Name,
		CC.First_Name,
		CC.Expiry,
		RCDP.Authorization_Number
	FROM	Credit_Card CC,
		Reservation_CC_Dep_Payment RCDP,
		Reservation_Dep_Payment RDP
	WHERE	RDP.Confirmation_Number = Convert(Int, @ConfirmNum)
	AND	RDP.Confirmation_Number = RCDP.Confirmation_Number
	AND	RDP.Collected_On = RCDP.Collected_On
	AND	RCDP.Credit_Card_Key = CC.Credit_Card_Key
*/
	RETURN @@ROWCOUNT













GO
