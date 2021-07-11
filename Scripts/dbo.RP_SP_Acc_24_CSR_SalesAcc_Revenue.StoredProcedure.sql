USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_24_CSR_SalesAcc_Revenue]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








/*
PURPOSE: Retrieve the Sales Accessories on contracts for a CSR on a 
	business day.
MOD HISTORY:
Name	Date		Comments
Don K	Feb 7 2000	Created
*/
CREATE PROCEDURE [dbo].[RP_SP_Acc_24_CSR_SalesAcc_Revenue]-- '*','*','*','01 mar 2012','31 mar 2012','0'
	@SalesAccID varchar(18) = '*',
	@LocationID varchar(6) = '*',
	@CSRName varchar(20) = 'Cindy Yee',
	@StartBusDate varchar(24) = '22 Apr 1999',
	@EndBusDate varchar(24) = '24 Apr 1999',
	@RptPurpose varchar(1) = '0'
AS
DECLARE @dtStartBus datetime,
	@dtEndBus datetime

SELECT	@dtStartBus = CAST(@StartBusDate as datetime),
	@dtEndBus = CAST(@EndBusDate as datetime)

-- fix upgrading problem (SQL7->SQL2000)
DECLARE  @tmpLocID varchar(6)

if @LocationID = '*'
	BEGIN
		SELECT @tmpLocID='0'
        END
else
	BEGIN
		SELECT @tmpLocID = @LocationID
	END 

DECLARE  @tmpSalesAccID varchar(6)

if @SalesAccID = '*'
	BEGIN
		SELECT @tmpSalesAccID='0'
        END
else
	BEGIN
		SELECT @tmpSalesAccID = @SalesAccID
	END 

-- end of fixing the problem
if @RptPurpose='0'--Revenue
	begin
		SELECT	Sales_Accessory_ID, 
				Sales_Accessory, 
				Sales_Contract_Number, 
				Refunded_Contract_No, 
				Quantity, 
				Price, 
				Amount, 
				Payment_Type, 
				Sold_At_Location_ID, 
				Location, 
				Sold_By, 
				Refund_Reason, 
				RBR_Date
		FROM	RP_Acc_24_CSR_SalesAcc_Revenue with(nolock)
		WHERE	(@LocationID = '*' OR CONVERT(INT, @tmpLocID) = Sold_At_Location_ID)
		AND	(@CSRName='*' or Sold_By = @CSRName)
		AND	(@SalesAccID = '*' or CONVERT(INT, @tmpSalesAccID)=Sales_Accessory_ID )
		AND	RBR_Date BETWEEN @dtStartBus AND @dtEndBus
		ORDER 
		BY	Sold_At_Location_ID,
			Sales_Contract_Number,
			Sales_Accessory
	end
  else--Inventory
	begin
		SELECT	Sales_Accessory_ID, 
				Sales_Accessory, 
				Sales_Contract_Number, 
				Refunded_Contract_No, 
				Quantity, 
				Price, 
				Amount, 
				Payment_Type, 
				Sold_At_Location_ID, 
				Location, 
				Sold_By, 
				Refund_Reason, 
				RBR_Date
		FROM	RP_Acc_24_CSR_SalesAcc_Inventory with(nolock)
		WHERE	(@LocationID = '*' OR CONVERT(INT, @tmpLocID) = Sold_At_Location_ID)
		AND	(@CSRName='*' or Sold_By = @CSRName)
		AND	(@SalesAccID = '*' or CONVERT(INT, @tmpSalesAccID)=Sales_Accessory_ID )
		AND	RBR_Date BETWEEN @dtStartBus AND @dtEndBus
		ORDER 
		BY	Sold_At_Location_ID,
			Sales_Contract_Number,
			Sales_Accessory
	end



GO
