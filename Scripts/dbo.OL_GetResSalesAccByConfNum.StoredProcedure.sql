USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[OL_GetResSalesAccByConfNum]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.GetResSalesAccByConfNum    Script Date: 2/18/99 12:12:09 PM ******/
/****** Object:  Stored Procedure dbo.GetResSalesAccByConfNum    Script Date: 2/16/99 2:05:42 PM ******/
/****** Object:  Stored Procedure dbo.GetResSalesAccByConfNum    Script Date: 1/11/99 1:03:16 PM ******/
/****** Object:  Stored Procedure dbo.GetResSalesAccByConfNum    Script Date: 11/23/98 3:55:34 PM ******/
CREATE PROCEDURE [dbo].[OL_GetResSalesAccByConfNum] -- 1856588

	@ConfirmNum Varchar(20)
AS
	IF @ConfirmNum = ""	SELECT @ConfirmNum = NULL
	--SELECT	 Sales_Accessory_Id, Quantity
	--FROM	Reserved_Sales_Accessory
	--WHERE	Confirmation_Number = Convert(Int, @ConfirmNum)
	--RETURN @@ROWCOUNT
	
 
    DECLARE @dCurrDate Datetime
	DECLARe @dLastDatetime Datetime
	DECLARE @nLocId Integer

	SELECT @nLocId = Pick_up_location_id,@dCurrDate=Pick_up_On from Reservation where Confirmation_Number = Convert(Int, @ConfirmNum)	 
	SELECT @dLastDatetime = Convert(Datetime, "31 Dec 2078 11:59PM")
 
 
SELECT     SA.Sales_Accessory_ID, 
		   SA.Sales_Accessory,
			ISNULL(LSA.Price, SAPrice.Price) AS Price, 
			SAPrice.GST_Exempt, 
			SAPrice.PST_Exempt,
			RSA.Quantity
FROM         dbo.Sales_Accessory SA INNER JOIN
                      dbo.Location_Sales_Accessory LSA ON SA.Sales_Accessory_ID = LSA.Sales_Accessory_ID 
                      INNER JOIN  dbo.Reserved_Sales_Accessory RSA 
                      ON SA.Sales_Accessory_ID = RSA.Sales_Accessory_ID                        
                      LEFT OUTER JOIN
                      dbo.Sales_Accessory_Price SAPrice ON SA.Sales_Accessory_ID = SAPrice.Sales_Accessory_ID
                      AND	@dCurrDate BETWEEN SAPrice.Sales_Accessory_Valid_From AND
						ISNULL(SAPrice.Valid_To, @dLastDatetime)
                      
                      	
	WHERE	
    Confirmation_Number = Convert(Int, @ConfirmNum)
    And 
	SA.Delete_Flag = 0 
	AND	@dCurrDate BETWEEN LSA.Valid_From AND
			ISNULL(LSA.Valid_To, @dLastDatetime)
	AND	LSA.Location_ID = @nLocId	 
	RETURN @@ROWCOUNT
GO
