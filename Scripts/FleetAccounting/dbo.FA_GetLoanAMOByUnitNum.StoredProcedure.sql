USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[FA_GetLoanAMOByUnitNum]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










CREATE PROCEDURE [dbo].[FA_GetLoanAMOByUnitNum] -- '164994'
	@UnitNum Varchar(10)
AS
	/* 3/27/99 - rhe created - Get Vehicle Monthly AMO for given unit num	*/
	DECLARE	@nUnitNum Integer
	SELECT	@nUnitNum = Convert(Int, NULLIF(@UnitNum,''))

	 SELECT     CONVERT(VarChar, dbo.FA_Loan_Amortization.AMO_Month, 111) AMO_Month, FinInst.Value, dbo.FA_Loan_Amortization.Finance_Start_Date, dbo.FA_Loan_Amortization.Principle_Amount, 
						  dbo.FA_Loan_Amortization.Interest_Amount, dbo.FA_Loan_Amortization.Balance, dbo.FA_Loan_Amortization.Last_Updated_On
	FROM         dbo.FA_Loan_Amortization INNER JOIN
                      dbo.FA_Financial_Institution ON dbo.FA_Loan_Amortization.Fin_Code = dbo.FA_Financial_Institution.Fin_Code INNER JOIN
                          (SELECT     Category, Code, Value, Alias
                            FROM          dbo.Lookup_Table
                            WHERE      (Category LIKE 'Financial Institution')) AS FinInst ON dbo.FA_Financial_Institution.Fin_Code = FinInst.Code
	WHERE	Unit_Number = @nUnitNum
and (( dbo.FA_Loan_Amortization.Principle_Amount is not Null or dbo.FA_Loan_Amortization.Interest_Amount is not null) And ( dbo.FA_Loan_Amortization.Principle_Amount<>0 or dbo.FA_Loan_Amortization.Interest_Amount <>0) )

	RETURN @@ROWCOUNT




















GO
