USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_FA_Loan_Amotization]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[RP_SP_FA_Loan_Amotization]    -- '2008-10-01', '2008-10-31', 'BMO', 'V'
	@sFinCode Varchar(24) = 'BMO',
	@sLoanMonth VarChar(24)	='2008-10-01'
As
-- Created By Roy He On 2009-02-12

Declare @LoanMonth Datetime
Declare @LoanMonthBeginning Datetime
Declare @LoanMonthEnd Datetime

Select @LoanMonth=Convert(Datetime, NULLIF(@sLoanMonth,''))
Select @LoanMonthBeginning=@LoanMonth-Day(@LoanMonth)+1
Select @LoanMonthEnd=DATEADD(month,1, @LoanMonthBeginning)-1
		 
SELECT      V.Unit_Number, V.Serial_Number, 
					LoanBook.Finance_Start_Date, 
					LoanBook.Finance_End_Date, 
					LoanBook.Loan_Amount, 
					LoanBook.PreMonthBalance, 
					LoanBook.Payout_Amount, 
				    LOANAMO.Principle_Amount, 
					LOANAMO.Balance, 
					LOANAMO.Interest_Amount, 
					LoanBook.Trans_Month,
					(Case When PaidInterest is Not NULL Then PaidInterest Else 0 End ) As PaidInterest, 
					(Case When PaidInterest is Not NULL Then PaidInterest Else 0 End ) +LOANAMO.Interest_Amount as InterestToDate
 
					FROM         FA_Loan_Amortization LOANAMO 
										INNER JOIN	dbo.Vehicle V 
													ON LOANAMO.Unit_Number = V.Unit_Number
										 INNER JOIN
										(
											SELECT   
														LH.Unit_Number, 
														LH.Fin_Code, 
														LH.Principal_Rate_ID, 
														LH.Override_Principal_Rate,
														LH.Loan_Amount, 
														LH.Trans_Month, 
														LH.Finance_Start_Date, 													
														(Case When LH.Finance_End_Date<=@LoanMonthEnd Then LH.Finance_End_Date
																Else Null
														End)  Finance_End_Date,

														(Case When LH.Payout_Date>=@LoanMonthBeginning and Payout_Date<=@LoanMonthEnd Then LH.Payout_Amount
																Else Null
														End) Payout_Amount,

														LH.Payout_Date,

                                                        (  SELECT    Sum(Interest_Amount) PaidInterest
															FROM         dbo.FA_Loan_Amortization
															Where Unit_number=LH.Unit_Number 
																	And Fin_Code=LH.Fin_Code
																	And Finance_Start_Date=LH.Finance_Start_Date
																	And AMO_Month<@LoanMonthBeginning
														 ) as PaidInterest,

														
														(SELECT  PrevMonthAMO.PreBalance  from
															   (
																SELECT Top 1 Balance as PreBalance, AMO_Month  from FA_Loan_Amortization
																		
																Where Unit_number=LH.Unit_Number 
																			And Fin_Code=LH.Fin_Code
																			And Finance_Start_Date=LH.Finance_Start_Date
																			And AMO_Month<@LoanMonthBeginning
																Order by AMO_Month DESC
																
																) PrevMonthAMO
														) As PreMonthBalance
																												
											FROM         dbo.FA_Loan_History LH
														
											WHERE
																	-- Partial Month
																		(Finance_Start_Date>=@LoanMonthBeginning and Finance_Start_Date <=@LoanMonthEnd)
																	OR   
																		(Finance_End_Date-1>=@LoanMonthBeginning AND Finance_End_Date-1<=@LoanMonthEnd)

																	--- Including whole month
																	OR 	
																		(Finance_Start_Date<=@LoanMonthBeginning and Finance_End_Date-1 >=@LoanMonthEnd)

																	OR 
																		(Finance_Start_Date<=@LoanMonthBeginning	AND  Finance_End_Date is null) 			
											
										)
										 LoanBook
													  ON LOANAMO.Unit_Number = LoanBook.Unit_Number
													 And LOANAMO.Fin_code=LoanBook.Fin_Code
													 And LOANAMO.Finance_Start_Date=LoanBook.Finance_Start_Date
													  
													

Where LOANAMO.AMO_Month between @LoanMonthBeginning and @LoanMonthEnd And (LOANAMO.Fin_code=@sFinCode or @sFinCode='*')
GO
