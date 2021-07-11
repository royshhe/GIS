USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetSalesContract]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

--
--select * from Sales_Accessory_Sale_Contract





/****** Object:  Stored Procedure dbo.GetSalesContract    Script Date: 2/18/99 12:12:09 PM ******/
CREATE PROCEDURE [dbo].[GetSalesContract] --29181  30852
@SalesContractNum Varchar(20)
AS
	/* 4/29/99 - cpy bug fix - simplified substring part */
	/* 9/27/99 - do type conversion outside of select */

DECLARE @iSalesCtrctNum Int

	SELECT @iSalesCtrctNum = CONVERT(int, NULLIF(@SalesContractNum,''))

	SELECT
		SASC.Sales_Contract_Number,

		Convert(Varchar(11), SASC.Sales_Date_Time),
		Convert(Varchar(5), SASC.Sales_Date_Time, 114),

		/*Substring(DateName(mm,SASC.Sales_Date_Time),1,3) + " "
		+ Right('0' + Convert(varchar,DatePart(dd,SASC.Sales_Date_Time)),2)
		+ " " + Convert(char(4),DatePart(yy,SASC.Sales_Date_Time)),
		Right('0' + Convert(varchar,DatePart(hh,SASC.Sales_Date_Time)), 2)
		+ ":" + Right('0' + Convert(varchar,DatePart(mi,SASC.Sales_Date_Time)),2), */

		SASC.Sold_At_Location_ID,
		SASC.Last_Name,
		SASC.First_Name,
		SASC.Phone_Number,
		SASC.Address_1,
		SASC.Address_2,

		SASC.City,
		SASC.Province,
		SASC.Country,
		SASC.Postal_Code,
		SASC.Refunded_Contract_No,
		SASC.Refund_Reason,
		SASP.Payment_Type,
		SASP.Amount
--	FROM
--		Sales_Accessory_Sale_Contract SASC,
--		Sales_Accessory_Sale_Payment SASP


FROM
		Sales_Accessory_Sale_Contract SASC
		Left Join 	Sales_Accessory_Sale_Payment SASP
		On SASC.Sales_Contract_Number = SASP.Sales_Contract_Number

	WHERE
		SASC.Sales_Contract_Number = @iSalesCtrctNum
--	And 	SASC.Sales_Contract_Number *= SASP.Sales_Contract_Number

	RETURN @@ROWCOUNT
GO
