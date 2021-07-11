USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Acc_26_Manual_Charge_Items]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--SELECT * FROM Contract_Billing_Party WHERE Contract_number = 3701310

/*  PURPOSE:		To retrieve all charge items (calculaed, manual) for the given contract number
     MOD HISTORY:
     Name    Date        Comments
	 Vinnie  2017/01/26  Updated code to include GST, PST, and PVRT amounts
*/
CREATE PROCEDURE [dbo].[RP_SP_Acc_26_Manual_Charge_Items]-- '*','*','*','*','01 may 2017','31 may 2017'
	@ChargeType varchar(18) = '*',
	@ChargeTypeID varchar(18) = '*',
	@LocationID varchar(6) = '*',
	@CSRName varchar(20) = 'Cindy Yee',
	@StartBusDate varchar(24) = '22 Apr 1999',
	@EndBusDate varchar(24) = '24 Apr 1999'
AS
DECLARE @dtStartBus datetime,
	@dtEndBus datetime
DECLARE  @tmpLocID varchar(6)
DECLARE  @tmpChargeTypeID varchar(6)


SELECT	@dtStartBus = CAST(@StartBusDate+' 00:00' as datetime),
	@dtEndBus = CAST(@EndBusDate + ' 23:59' as datetime)

if @LocationID = '*'
	BEGIN
		SELECT @tmpLocID='0'
        END

	SELECT	
		MCI.Contract_Number ,
		Charge_Item_Type,
		Charge_Type_ID,
		Value,
		Unit_Type,
		Unit_Amount,
		Quantity, 
		amount,
		GST_Amount,
		PST_Amount,
		PVRT_Amount,
		Charged_By ,
		L.Location_ID ,
		l.Location  ,
		bt.RBR_Date 
	FROM	RP_Acc_26_Manual_Charge_Items_Main MCI  INNER JOIN
           dbo.Business_Transaction BT ON MCI.Contract_Number = BT.Contract_Number
           and (bt.Business_Transaction_id=mci.Business_Transaction_id or Mci.Business_Transaction_id is null )
    		 INNER JOIN Location l	ON BT.Location_ID = l.Location_ID     
    	       
	WHERE (bt.Transaction_Type = 'con') 
		--AND	(bt.Transaction_Description in ( 'check in','Adjustments') )
		AND MCI.Status not in ('vd', 'ca')  
		and mci.Charge_Type_ID not in (30,35)--location fee

		AND (@LocationID = '*' OR CONVERT(INT, @tmpLocID) = l.Location_ID)
		AND	(@CSRName='*' or Charged_By = @CSRName)
		AND	(@ChargeType = '*' or @ChargeType=mci.Charge_Item_Type )
		AND	(@ChargeTypeID = '*' or @ChargeTypeID=mci.Charge_Type_ID )
		AND	RBR_Date BETWEEN @dtStartBus AND @dtEndBus
	
	ORDER BY MCI.Contract_Number 

	RETURN @@ROWCOUNT

GO
