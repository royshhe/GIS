USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetGISDailyTotal]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO







/*
PROCEDURE NAME: GetGISDailyTotal
PURPOSE: To calculate the daily totals for credit card transactions in GIS.

AUTHOR: Dan McMechan?
DATE CREATED: ?
CALLED BY: Eigen
MOD HISTORY:
Name    Date        	Comments
Don K	Apr 5 1999	Changed to look for last RBR date that's _closed_.
			Use Eigen Codes on Credit Card Types.
CPY	Oct 20 1999	Skip copied deposit payments from reservation 
Don K	Oct 22 1999	Let you specify an RBR date.
Don K	Oct 25 1999	Check that the terminal id exists
*/
CREATE PROCEDURE [dbo].[GetGISDailyTotal]
	@TerminalID Varchar(20),
	@CCType Varchar(3),
	@RBRDate varchar(24)
AS
DECLARE @thisRBRDate datetime
DECLARE @PosAmount decimal(9,2), @RPosAmount decimal(9,2), @SPosAmount decimal(9,2)
DECLARE @PosCount int, @RPosCount int, @SPosCount int
DECLARE @NegAmount decimal(9,2), @RNegAmount decimal(9,2), @SNegAmount decimal(9,2)
DECLARE @NegCount int, @RNegCount int, @SNegCount int

	SELECT	@CCType = NULLIF(@CCType, '')

IF @RBRDate = ''
	Select 	@thisRBRDate = Max(RBR_Date)
	From	RBR_Date
	Where	Budget_Close_Datetime IS NOT NULL
ELSE
	SELECT	@thisRBRDate = CAST(@RBRDate AS datetime)

-- First calculate totals for contracts
	SELECT @PosAmount = Sum(CPI.Amount), @PosCount = Count(*)
	FROM
		Contract_Payment_Item CPI, Credit_Card_Payment CCP,
		Credit_Card CC, Credit_Card_Type CCT
	WHERE
		CPI.RBR_Date = @thisRBRDate
		And CPI.Payment_Type = 'Credit Card'
		And CPI.Amount > 0
		And CCP.Terminal_ID = @TerminalID
		And CPI.Contract_Number = CCP.Contract_Number
		And CPI.Sequence = CCP.Sequence
		And CCP.Credit_Card_Key = CC.Credit_Card_Key
		And CC.Credit_Card_Type_ID = CCT.Credit_Card_Type_ID
		AND CCT.Eigen_Code = @CCType
		AND CPI.Copied_Payment = 0

	SELECT @NegAmount = Sum(CPI.Amount * -1), @NegCount = Count (*)
	FROM
		Contract_Payment_Item CPI, Credit_Card_Payment CCP,
		Credit_Card CC, Credit_Card_Type CCT
	WHERE
		CPI.RBR_Date = @thisRBRDate
		And CPI.Payment_Type = 'Credit Card'
		And Amount < 0
		And CCP.Terminal_ID = @TerminalID
		And CPI.Contract_Number = CCP.Contract_Number
		And CPI.Sequence = CCP.Sequence
		And CCP.Credit_Card_Key = CC.Credit_Card_Key
		And CC.Credit_Card_Type_ID = CCT.Credit_Card_Type_ID
		AND CCT.Eigen_Code = @CCType
		AND CPI.Copied_Payment = 0

-- Now calculate totals for reservations
	SELECT @RPosAmount = Sum(rdp.Amount), @RPosCount = Count (*)
	FROM
		reservation_dep_payment rdp,
		reservation_cc_dep_payment rcdp,
		Credit_Card CC, Credit_Card_Type CCT
	WHERE
		rdp.RBR_Date = @thisRBRDate
		And rdp.Payment_Type = 'Credit Card'
		And rdp.Amount > 0
		And rcdp.Terminal_ID = @TerminalID
		And rdp.confirmation_number = rcdp.confirmation_number
		And rdp.collected_on = rcdp.collected_on
		And rcdp.Credit_Card_Key = CC.Credit_Card_Key
		And CC.Credit_Card_Type_ID = CCT.Credit_Card_Type_ID
		AND CCT.Eigen_Code = @CCType

	SELECT @RNegAmount = Sum(rdp.Amount * -1), @RNegCount = Count (*)
	FROM
		reservation_dep_payment rdp,
		reservation_cc_dep_payment rcdp,
		Credit_Card CC, Credit_Card_Type CCT
	WHERE
		rdp.RBR_Date = @thisRBRDate
		And rdp.Payment_Type = 'Credit Card'
		And rdp.Amount < 0
		And rcdp.Terminal_ID = @TerminalID
		And rdp.confirmation_number = rcdp.confirmation_number
		And rdp.collected_on = rcdp.collected_on
		And rcdp.Credit_Card_Key = CC.Credit_Card_Key
		And CC.Credit_Card_Type_ID = CCT.Credit_Card_Type_ID
		AND CCT.Eigen_Code = @CCType

-- Now calculate totals for accessory sales
	SELECT @SPosAmount = Sum(sasp.Amount), @SPosCount = Count (*)
	FROM
		sales_accessory_sale_payment sasp,
		sales_accessory_crcard_payment sacp,
		Credit_Card CC, Credit_Card_Type CCT
	WHERE
		sasp.RBR_Date = @thisRBRDate
		And sasp.Payment_Type = 'Credit Card'
		And sasp.Amount > 0
		And sacp.Terminal_ID = @TerminalID
		And sacp.sales_contract_number = sasp.sales_contract_number
		And sacp.Credit_Card_Key = CC.Credit_Card_Key
		And CC.Credit_Card_Type_ID = CCT.Credit_Card_Type_ID
		AND CCT.Eigen_Code = @CCType

	SELECT 	@SNegAmount = Sum(sasp.Amount * -1), @SNegCount = Count (*)
	FROM
		sales_accessory_sale_payment sasp,
		sales_accessory_crcard_payment sacp,
		Credit_Card CC, Credit_Card_Type CCT
	WHERE
		sasp.RBR_Date = @thisRBRDate
		And sasp.Payment_Type = 'Credit Card'
		And sasp.Amount < 0
		And sacp.Terminal_ID = @TerminalID
		And sacp.sales_contract_number = sasp.sales_contract_number
		And sacp.Credit_Card_Key = CC.Credit_Card_Key
		And CC.Credit_Card_Type_ID = CCT.Credit_Card_Type_ID
		AND CCT.Eigen_Code = @CCType

SELECT	ISNULL(@PosAmount, 0) + ISNULL(@RPosAmount, 0) + ISNULL(@SPosAmount, 0),
	ISNULL(@NegAmount, 0) + ISNULL(@RNegAmount, 0) + ISNULL(@SNegAmount, 0),
	@PosCount + @RPosCount + @SPosCount,
	@NegCount + @RNegCount + @SNegCount,
	Terminal_ID
  FROM	terminal
 WHERE	terminal_id = @TerminalID

RETURN 1









GO
