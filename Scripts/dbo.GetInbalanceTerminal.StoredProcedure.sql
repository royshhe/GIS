USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetInbalanceTerminal]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[GetInbalanceTerminal]
	@RBRDate varchar(24)
AS


DECLARE @thisRBRDate DATETIME
DECLARE @BudgetCode SMALLINT
IF @RBRDate = ''
	SELECT @thisRBRDate =
		(SELECT
			Max(RBR_Date)
		FROM
			RBR_Date
		WHERE
			Budget_Close_Datetime IS NOT NULL)
ELSE
	SELECT	@thisRBRDate = CAST(@RBRDate AS datetime)

SELECT @BudgetCode=CAST(code AS SMALLINT) FROM Lookup_Table WHERE Category='BudgetBC Company'

IF @BudgetCode is not NULL 
BEGIN 
	PRINT ' ****************   Imbalance Terminal List   *************'
	PRINT ' **  RBR Date:'+@RBRDate+'                  Report DateTime:' + CONVERT(VARCHAR(20),GETDATE())+'  **'
	PRINT ''


	SELECT 'Location'=CAST(loc.Location AS CHAR(18) ),'Terminal'=CAST(TDT.Terminal_Id AS CHAR(10)), 'CreditCard'=CCT.Credit_Card_Type,
        'Eigen Purch.'=TDT.Eigen_Purchase_amount,'EPCnt'=CAST(TDT.Eigen_Purchase_count AS CHAR(6)),
	'BRAC Purch.'=TDT.Budget_Purchase_Amount, 'BPCnt'=CAST(TDT.Budget_Purchase_Count AS CHAR(6)),'Eigen Refund'=TDT.Eigen_Return_amount, 
	'ERCnt'=CAST(TDT.Eigen_Return_Count AS CHAR(6)),
	'BRAC Refund'=TDT.Budget_Return_amount,'BRCnt'=CAST(TDT.Budget_Return_Count AS CHAR(6))

	FROM Terminal_Daily_Total TDT,
       	Credit_Card_Type CCT,
	Terminal Ter,
	Location Loc
	WHERE CCT.Eigen_Code=TDT.Eigen_CCT_Code
	AND CCT.Credit_Card_Type_ID in ('AMX','DC','JCB','MCD','VSA')
	AND Ter.Terminal_ID=TDT.Terminal_ID
	AND Loc.Location_ID=Ter.Location_ID
	AND Loc.owning_company_id=@BudgetCode
	AND RBR_date =@RBRDate
	AND ( ((Eigen_Purchase_Count+Eigen_Return_Count)!=(Budget_Purchase_Count+Budget_Return_Count))
       		OR
       	      ((Eigen_Purchase_Amount+Eigen_Return_Amount)!=(Budget_Purchase_Amount+Budget_Return_Amount))
	)
       ORDER BY Loc.Location,TDT.Terminal_ID
END
ELSE 
BEGIN
    PRINT 'Invalid Budget Company Code! PLease call system support'
END 

GO
