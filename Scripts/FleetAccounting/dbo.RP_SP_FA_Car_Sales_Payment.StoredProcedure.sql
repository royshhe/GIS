USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_FA_Car_Sales_Payment]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[RP_SP_FA_Car_Sales_Payment]-- '*', '2017/05/15', '2017/05/16'
	@Buyer as Varchar(30),
	@StartPaymentDate Varchar(24),
	@EndPaymentDate  Varchar(24)
As

Declare @dStartPaymentDate Datetime
Declare @dEndPaymentDate Datetime
Select @dStartPaymentDate=Convert(Datetime, NULLIF(@StartPaymentDate,''))
Select @dEndPaymentDate=Convert(Datetime, NULLIF(@EndPaymentDate,''))

SELECT     V.Unit_Number, VMY.Model_Name, VMY.Model_Year, VMY.Manufacturer_ID, V.Serial_Number, V.Sales_Processed_date, V.Sell_To,V.Selling_price,
                      dbo.zeroifnull(V.Selling_Price)+dbo.zeroifnull(V.Sales_GST) + dbo.zeroifnull(V.Sales_PST) as Sales_Proceeds, V.Amount_Paid, dbo.zeroifnull(V.Amount_Paid) - (dbo.zeroifnull(V.Selling_Price)+dbo.zeroifnull(V.Sales_GST) + dbo.zeroifnull(V.Sales_PST)) As Balance,V.Payment_Cheque_No, V.Payment_Date, V.Finance_By
FROM         dbo.Vehicle V INNER JOIN
                      dbo.Vehicle_Model_Year VMY ON V.Vehicle_Model_ID = VMY.Vehicle_Model_ID

Where (V.Payment_Date between @dStartPaymentDate and @dEndPaymentDate) And  (V.Sell_To=@Buyer or @Buyer='*')

GO
