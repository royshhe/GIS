USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[FA_UpdLoanArmotizationInterest]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create Procedure [dbo].[FA_UpdLoanArmotizationInterest]  -- '2008-03-01', '2008-03-31'
	@sLoanMonth VarChar(24),
    @sCutOffDate VarChar(24)
As

Declare @LoanMonth Datetime
Declare @LoanMonthBeginning Datetime
Declare @LoanMonthEnd Datetime
Declare @CutOffDate Datetime


Select @LoanMonth=Convert(Datetime, NULLIF(@sLoanMonth,''))
Select @LoanMonthBeginning=@LoanMonth-Day(@LoanMonth)+1
Select @LoanMonthEnd=DATEADD(month,1, @LoanMonthBeginning)-1
Select @CutOffDate=Convert(Datetime, NULLIF(@sCutOffDate,''))
--PRINT @LoanMonthBeginning
--PRINT @CutOffDate

 --  Update FA_Loan_Amortization Set Interest_Amount=MonthlyInterest.TotalInterestPayment
 Select MonthlyInterest.*, LAMO.* 
   From 
    (
	Select  Sum(LoanInterest.InterestPayment) as TotalInterestPayment,LoanInterest.Unit_Number,  LoanInterest.MB from 
 --Select LoanInterest.* from 
			(
				--======================================================================================
				-- Before the Cut Off Date
				--=====================================================================================
				--A1

				SELECT   
				@LoanMonthBeginning as ValidFrom,
				LoanInterest.Valid_To,
				Datediff(Day, @LoanMonthBeginning, LoanInterest.Valid_To) +1 as InterestDays,
				Round(PreMonthBalance*( (LoanInterest.Interest_Rate/dbo.DaysInYear(@CutOffDate)) * (Datediff(Day, @LoanMonthBeginning, LoanInterest.Valid_To) +1) ),2)as InterestPayment,
				LA.Balance as CurrentMonthBalance,
				PreMonthBalance,
				LoanInterest.Interest_Rate, 
				@LoanMonthBeginning as  MB,
				@LoanMonthEnd as  ME,
				@CutOffDate as CU,
				LoanInterest.Valid_From IB,
				LoanInterest.Valid_To IE, 
				LoanBook.Finance_Start_Date FB, 
				LoanBook.Finance_End_Date FE, 
				LoanBook.Loan_Amount, 
				LoanBook.Unit_Number
				FROM     
				(SELECT   Datediff(month, LH.Finance_Start_Date,@LoanMonth )+1 as LoanMonth,    
							LH.Unit_Number, 
							LH.Fin_Code, 
							LH.Principal_Rate_ID, 
							LH.Loan_Amount, 
							LH.Trans_Month, 
							LH.Finance_Start_Date, 
							(Case When LH.Finance_End_Date is not Null Then LH.Finance_End_Date Else '2078-12-31' End) as Finance_End_Date,			
							LH.Payout_Amount, 
							LH.Payout_Date,
							
							(SELECT  PrevMonthAMO.PreBalance  from
								   (
									SELECT Top 1 Balance as PreBalance, AMO_Month  from FA_Loan_Amortization
											
									Where Unit_number=LH.Unit_Number  And AMO_Month<@LoanMonth
									Order by AMO_Month DESC
									
									) PrevMonthAMO
							) As PreMonthBalance
				        
							
							
				FROM         dbo.FA_Loan_History LH
				Where ( LH.Finance_End_Date-1>=@LoanMonthBeginning or  LH.Finance_End_Date is null) and  LH.Payout_Date is  null
				)
				 LoanBook 
						INNER JOIN  FA_Loan_Amortization LA
								ON LoanBook.Unit_Number = LA.Unit_Number And AMO_Month=@LoanMonthBeginning
						INNER JOIN  dbo.FA_Loan_Interest_Rate LoanInterest 
								ON LoanBook.Fin_Code = LoanInterest.FIN_Code

				WHERE  
					   ( LoanInterest.Valid_From<=@LoanMonthBeginning ) And (LoanBook.Finance_Start_Date<=@LoanMonthBeginning)
				And (LoanInterest.Valid_To >=@LoanMonthBeginning )
				And (LoanInterest.Valid_To<=LoanBook.Finance_End_Date And  LoanInterest.Valid_To <= @CutOffDate-1)
				--and  (LoanBook.Unit_Number=154559)


				Union

				--a2
				-- Interest Valid from before the Month Beginning				
						-- Financial Start Date Before the Month Begining
								-- Finanacial End Date -1< Interest Valid To

				SELECT   
				@LoanMonthBeginning as ValidFrom,
				LoanBook.Finance_End_Date -1 as Valid_To,
				Datediff(Day, @LoanMonthBeginning, LoanBook.Finance_End_Date -1) +1 as InterestDays,
				Round(PreMonthBalance*( (LoanInterest.Interest_Rate/dbo.DaysInYear(@CutOffDate)) * (Datediff(Day, @LoanMonthBeginning, LoanBook.Finance_End_Date -1) +1) ),2)as InterestPayment,
				LA.Balance as CurrentMonthBalance,
				PreMonthBalance,
				LoanInterest.Interest_Rate, 
				@LoanMonthBeginning as  MB,
				@LoanMonthEnd as  ME,
				@CutOffDate as CU,
				LoanInterest.Valid_From IB,
				LoanInterest.Valid_To IE, 
				LoanBook.Finance_Start_Date FB, 
				LoanBook.Finance_End_Date FE, 
				LoanBook.Loan_Amount, 
				LoanBook.Unit_Number

				FROM         
				(SELECT   Datediff(month, LH.Finance_Start_Date,@LoanMonth )+1 as LoanMonth,    
							LH.Unit_Number, 
							LH.Fin_Code, 
							LH.Principal_Rate_ID, 
							LH.Loan_Amount, 
							LH.Trans_Month, 
							LH.Finance_Start_Date, 
							(Case When LH.Finance_End_Date is not Null Then LH.Finance_End_Date Else '2078-12-31' End) as Finance_End_Date,	
							LH.Payout_Amount, 
							LH.Payout_Date,
							
							(SELECT  PrevMonthAMO.PreBalance  from
								   (
									SELECT Top 1 Balance as PreBalance, AMO_Month  from FA_Loan_Amortization
											
									Where Unit_number=LH.Unit_Number  And AMO_Month<@LoanMonth
									Order by AMO_Month DESC
									
									) PrevMonthAMO
							) As PreMonthBalance
				        
							
							
				FROM         dbo.FA_Loan_History LH
				Where ( LH.Finance_End_Date-1>=@LoanMonthBeginning or  LH.Finance_End_Date is null) and  LH.Payout_Date is  null
				)

				 LoanBook 
						INNER JOIN  FA_Loan_Amortization LA
								ON LoanBook.Unit_Number = LA.Unit_Number And AMO_Month=@LoanMonthBeginning
						INNER JOIN  dbo.FA_Loan_Interest_Rate LoanInterest 
								ON LoanBook.Fin_Code = LoanInterest.FIN_Code

				WHERE  
						( LoanInterest.Valid_From<=@LoanMonthBeginning  And LoanBook.Finance_Start_Date<=@LoanMonthBeginning )
				And  (LoanBook.Finance_End_Date-1>=@LoanMonthBeginning)
				And  (LoanBook.Finance_End_Date-1<=LoanInterest.Valid_To And   LoanBook.Finance_End_Date-1<= @CutOffDate-1)
				--and  (LoanBook.Unit_Number=154559)

				Union

				--a3
				-- Interest Valid from before the Month Beginning				
				-------------------------------------------------------------------------------------------------------------------------------------------
						-- Financial Start Date Before the Month Begining
								-- Finanacial End Date-1 >= CU-1

				SELECT   
				@LoanMonthBeginning as ValidFrom,
				@CutOffDate-1  as Valid_To,
				Datediff(Day, @LoanMonthBeginning, @CutOffDate-1) +1 as InterestDays,
				Round(PreMonthBalance*( (LoanInterest.Interest_Rate/dbo.DaysInYear(@CutOffDate)) * (Datediff(Day, @LoanMonthBeginning, @CutOffDate-1) +1) ),2)as InterestPayment,
				LA.Balance as CurrentMonthBalance,
				PreMonthBalance,
				LoanInterest.Interest_Rate, 
				@LoanMonthBeginning as  MB,
				@LoanMonthEnd as  ME,
				@CutOffDate as CU,
				LoanInterest.Valid_From IB,
				LoanInterest.Valid_To IE, 
				LoanBook.Finance_Start_Date FB, 
				LoanBook.Finance_End_Date FE, 
				LoanBook.Loan_Amount, 
				LoanBook.Unit_Number
				FROM         
				(SELECT   Datediff(month, LH.Finance_Start_Date,@LoanMonth )+1 as LoanMonth,    
							LH.Unit_Number, 
							LH.Fin_Code, 
							LH.Principal_Rate_ID, 
							LH.Loan_Amount, 
							LH.Trans_Month, 
							LH.Finance_Start_Date, 
							(Case When LH.Finance_End_Date is not Null Then LH.Finance_End_Date Else '2078-12-31' End) as Finance_End_Date,	
							LH.Payout_Amount, 
							LH.Payout_Date,
							
							(SELECT  PrevMonthAMO.PreBalance  from
								   (
									SELECT Top 1 Balance as PreBalance, AMO_Month  from FA_Loan_Amortization
											
									Where Unit_number=LH.Unit_Number  And AMO_Month<@LoanMonth
									Order by AMO_Month DESC
									
									) PrevMonthAMO
							) As PreMonthBalance
				        
							
							
				FROM         dbo.FA_Loan_History LH
				Where ( LH.Finance_End_Date-1>=@LoanMonthBeginning or  LH.Finance_End_Date is null) and  LH.Payout_Date is  null
				)

				 LoanBook 
						INNER JOIN  FA_Loan_Amortization LA
								ON LoanBook.Unit_Number = LA.Unit_Number And AMO_Month=@LoanMonthBeginning
						INNER JOIN  dbo.FA_Loan_Interest_Rate LoanInterest 
								ON LoanBook.Fin_Code = LoanInterest.FIN_Code

				WHERE  

				   ( LoanInterest.Valid_From<=@LoanMonthBeginning ) And (LoanBook.Finance_Start_Date<=@LoanMonthBeginning)
				--And (@LoanMonthBeginning >=@CutOffDate-1)
				And @CutOffDate-1<=LoanInterest.Valid_To  And @CutOffDate-1 <= LoanBook.Finance_End_Date-1
				--and  (LoanBook.Unit_Number=154559)


				Union

				--a4

				SELECT   
				LoanBook.Finance_Start_Date as ValidFrom,
				LoanInterest.Valid_To,
				Datediff(Day, LoanBook.Finance_Start_Date, LoanInterest.Valid_To) +1 as InterestDays,
				Round(PreMonthBalance*( (LoanInterest.Interest_Rate/dbo.DaysInYear(@CutOffDate)) * (Datediff(Day, LoanBook.Finance_Start_Date, LoanInterest.Valid_To) +1) ),2)as InterestPayment,
				LA.Balance as CurrentMonthBalance,
				PreMonthBalance,
				LoanInterest.Interest_Rate, 
				@LoanMonthBeginning as  MB,
				@LoanMonthEnd as  ME,
				@CutOffDate as CU,
				LoanInterest.Valid_From IB,
				LoanInterest.Valid_To IE, 
				LoanBook.Finance_Start_Date FB, 
				LoanBook.Finance_End_Date FE, 
				LoanBook.Loan_Amount, 
				LoanBook.Unit_Number
				FROM         
				(SELECT   Datediff(month, LH.Finance_Start_Date,@LoanMonth )+1 as LoanMonth,    
							LH.Unit_Number, 
							LH.Fin_Code, 
							LH.Principal_Rate_ID, 
							LH.Loan_Amount, 
							LH.Trans_Month, 
							LH.Finance_Start_Date, 
							(Case When LH.Finance_End_Date is not Null Then LH.Finance_End_Date Else '2078-12-31' End) as Finance_End_Date,	
							LH.Payout_Amount, 
							LH.Payout_Date,
							
							(SELECT  PrevMonthAMO.PreBalance  from
								   (
									SELECT Top 1 Balance as PreBalance, AMO_Month  from FA_Loan_Amortization
											
									Where Unit_number=LH.Unit_Number  And AMO_Month<@LoanMonth
									Order by AMO_Month DESC
									
									) PrevMonthAMO
							) As PreMonthBalance
				        
							
							
				FROM         dbo.FA_Loan_History LH
				Where ( LH.Finance_End_Date-1>=@LoanMonthBeginning or  LH.Finance_End_Date is null) and  LH.Payout_Date is  null
				)

				 LoanBook 
						INNER JOIN  FA_Loan_Amortization LA
								ON LoanBook.Unit_Number = LA.Unit_Number And AMO_Month=@LoanMonthBeginning
						INNER JOIN  dbo.FA_Loan_Interest_Rate LoanInterest 
								ON LoanBook.Fin_Code = LoanInterest.FIN_Code

				WHERE  
					
						 (LoanBook.Finance_Start_Date>=@LoanMonthBeginning  And LoanBook.Finance_Start_Date>=LoanInterest.Valid_From)
				AND (LoanBook.Finance_Start_Date<=LoanInterest.Valid_To)
				AND (LoanInterest.Valid_To <= @CutOffDate-1 And LoanInterest.Valid_To <= LoanBook.Finance_End_Date)
				--and  (LoanBook.Unit_Number=154559)
               --a5
				Union

				SELECT  
				LoanBook.Finance_Start_Date as ValidFrom,
				LoanBook.Finance_End_Date -1 as Valid_To,
				Datediff(Day, LoanBook.Finance_Start_Date, LoanBook.Finance_End_Date -1) +1 as InterestDays,
				Round(PreMonthBalance*( (LoanInterest.Interest_Rate/dbo.DaysInYear(@CutOffDate)) * (Datediff(Day, LoanBook.Finance_Start_Date, LoanBook.Finance_End_Date -1) +1) ),2)as InterestPayment,
				LA.Balance as CurrentMonthBalance,
				PreMonthBalance,
				LoanInterest.Interest_Rate, 
				@LoanMonthBeginning as  MB,
				@LoanMonthEnd as  ME,
				@CutOffDate as CU,
				LoanInterest.Valid_From IB,
				LoanInterest.Valid_To IE, 
				LoanBook.Finance_Start_Date FB, 
				LoanBook.Finance_End_Date FE, 
				LoanBook.Loan_Amount, 
				LoanBook.Unit_Number

				FROM         
				(SELECT   Datediff(month, LH.Finance_Start_Date,@LoanMonth )+1 as LoanMonth,    
							LH.Unit_Number, 
							LH.Fin_Code, 
							LH.Principal_Rate_ID, 
							LH.Loan_Amount, 
							LH.Trans_Month, 
							LH.Finance_Start_Date, 
							(Case When LH.Finance_End_Date is not Null Then LH.Finance_End_Date Else '2078-12-31' End) as Finance_End_Date,	
							LH.Payout_Amount, 
							LH.Payout_Date,
							
							(SELECT  PrevMonthAMO.PreBalance  from
								   (
									SELECT Top 1 Balance as PreBalance, AMO_Month  from FA_Loan_Amortization
											
									Where Unit_number=LH.Unit_Number  And AMO_Month<@LoanMonth
									Order by AMO_Month DESC
									
									) PrevMonthAMO
							) As PreMonthBalance
				        
							
							
				FROM         dbo.FA_Loan_History LH
				Where ( LH.Finance_End_Date-1>=@LoanMonthBeginning or  LH.Finance_End_Date is null) and  LH.Payout_Date is  null
				)

				 LoanBook 
						INNER JOIN  FA_Loan_Amortization LA
								ON LoanBook.Unit_Number = LA.Unit_Number And AMO_Month=@LoanMonthBeginning
						INNER JOIN  dbo.FA_Loan_Interest_Rate LoanInterest 
								ON LoanBook.Fin_Code = LoanInterest.FIN_Code

				WHERE  

						(LoanBook.Finance_Start_Date>=@LoanMonthBeginning  And LoanBook.Finance_Start_Date>=LoanInterest.Valid_From) 
				And  ( LoanBook.Finance_End_Date<=LoanInterest.Valid_To And   LoanBook.Finance_End_Date<=@CutOffDate-1)
				--and  (LoanBook.Unit_Number=154559)

				Union

				--A6

				SELECT   
				LoanBook.Finance_Start_Date as ValidFrom,
				@CutOffDate-1  as Valid_To,
				Datediff(Day, LoanBook.Finance_Start_Date, @CutOffDate-1) +1 as InterestDays,
				Round(PreMonthBalance*( (LoanInterest.Interest_Rate/dbo.DaysInYear(@CutOffDate)) * (Datediff(Day, LoanBook.Finance_Start_Date, @CutOffDate-1) +1 )),2) as InterestPayment,
				LA.Balance as CurrentMonthBalance,
				PreMonthBalance,
				LoanInterest.Interest_Rate, 
				@LoanMonthBeginning as  MB,
				@LoanMonthEnd as  ME,
				@CutOffDate as CU,
				LoanInterest.Valid_From IB,
				LoanInterest.Valid_To IE, 
				LoanBook.Finance_Start_Date FB, 
				LoanBook.Finance_End_Date FE, 
				LoanBook.Loan_Amount, 
				LoanBook.Unit_Number
				FROM         
				(SELECT   Datediff(month, LH.Finance_Start_Date,@LoanMonth )+1 as LoanMonth,    
							LH.Unit_Number, 
							LH.Fin_Code, 
							LH.Principal_Rate_ID, 
							LH.Loan_Amount, 
							LH.Trans_Month, 
							LH.Finance_Start_Date, 
							(Case When LH.Finance_End_Date is not Null Then LH.Finance_End_Date Else '2078-12-31' End) as Finance_End_Date,	
							LH.Payout_Amount, 
							LH.Payout_Date,
							
							(SELECT  PrevMonthAMO.PreBalance  from
								   (
									SELECT Top 1 Balance as PreBalance, AMO_Month  from FA_Loan_Amortization
											
									Where Unit_number=LH.Unit_Number  And AMO_Month<@LoanMonth
									Order by AMO_Month DESC
									
									) PrevMonthAMO
							) As PreMonthBalance
				        
							
							
				FROM         dbo.FA_Loan_History LH
				Where ( LH.Finance_End_Date-1>=@LoanMonthBeginning or  LH.Finance_End_Date is null) and  LH.Payout_Date is  null
				)
				 LoanBook 
						INNER JOIN  FA_Loan_Amortization LA
								ON LoanBook.Unit_Number = LA.Unit_Number And AMO_Month=@LoanMonthBeginning
						INNER JOIN  dbo.FA_Loan_Interest_Rate LoanInterest 
								ON LoanBook.Fin_Code = LoanInterest.FIN_Code

				WHERE  

				   ( LoanBook.Finance_Start_Date>=LoanInterest.Valid_From ) And (LoanBook.Finance_Start_Date>=@LoanMonthBeginning )
				And (LoanBook.Finance_Start_Date <=@CutOffDate-1)
				And @CutOffDate-1<=LoanInterest.Valid_To  And LoanInterest.Valid_To <= LoanBook.Finance_End_Date-1
				--and  (LoanBook.Unit_Number=154559)



				Union

				--a7
				-- Interest Valid from after the Month Beginning				
				-------------------------------------------------------------------------------------------------------------------------------------------
						-- Financial Start Date Before the Month Begining
								-- Finanacial End Date-1 >= Interest Valid To

				SELECT  
				LoanInterest.Valid_From,
				LoanInterest.Valid_To,
				Datediff(Day, LoanInterest.Valid_From, LoanInterest.Valid_To) +1 as InterestDays,
				Round(PreMonthBalance*( (LoanInterest.Interest_Rate/dbo.DaysInYear(@CutOffDate)) * (Datediff(Day, LoanInterest.Valid_From, LoanInterest.Valid_To) +1) ),2)as InterestPayment,
				LA.Balance as CurrentMonthBalance,
				PreMonthBalance,
				LoanInterest.Interest_Rate, 
				@LoanMonthBeginning as  MB,
				@LoanMonthEnd as  ME,
				@CutOffDate as CU,
				LoanInterest.Valid_From IB,
				LoanInterest.Valid_To IE, 
				LoanBook.Finance_Start_Date FB, 
				LoanBook.Finance_End_Date FE, 
				LoanBook.Loan_Amount, 
				LoanBook.Unit_Number

				FROM         
				(SELECT   Datediff(month, LH.Finance_Start_Date,@LoanMonth )+1 as LoanMonth,    
							LH.Unit_Number, 
							LH.Fin_Code, 
							LH.Principal_Rate_ID, 
							LH.Loan_Amount, 
							LH.Trans_Month, 
							LH.Finance_Start_Date, 
							(Case When LH.Finance_End_Date is not Null Then LH.Finance_End_Date Else '2078-12-31' End) as Finance_End_Date,	
							LH.Payout_Amount, 
							LH.Payout_Date,
							
							(SELECT  PrevMonthAMO.PreBalance  from
								   (
									SELECT Top 1 Balance as PreBalance, AMO_Month  from FA_Loan_Amortization
											
									Where Unit_number=LH.Unit_Number  And AMO_Month<@LoanMonth
									Order by AMO_Month DESC
									
									) PrevMonthAMO
							) As PreMonthBalance
				        
							
							
				FROM         dbo.FA_Loan_History LH
				Where ( LH.Finance_End_Date-1>=@LoanMonthBeginning or  LH.Finance_End_Date is null) and  LH.Payout_Date is  null
				)
				 LoanBook 
						INNER JOIN  FA_Loan_Amortization LA
								ON LoanBook.Unit_Number = LA.Unit_Number And AMO_Month=@LoanMonthBeginning
						INNER JOIN  dbo.FA_Loan_Interest_Rate LoanInterest 
								ON LoanBook.Fin_Code = LoanInterest.FIN_Code

				WHERE  

    					(LoanBook.Finance_Start_Date<=LoanInterest.Valid_From  AND @LoanMonthBeginning <= LoanInterest.Valid_From)
				And (LoanInterest.Valid_To <= @CutOffDate-1 And LoanInterest.Valid_To<=LoanBook.Finance_End_Date-1)
				--and  (LoanBook.Unit_Number=154559)


				UNION

				--a8
				-- Interest Valid from after the Month Beginning				
				-------------------------------------------------------------------------------------------------------------------------------------------
						-- Financial Start Date Before the Month Begining
								-- Finanacial End Date-1 < Interest Valid To

				SELECT  
				LoanInterest.Valid_From,
				LoanBook.Finance_End_Date-1 Valid_To,
				Datediff(Day, LoanInterest.Valid_From, LoanBook.Finance_End_Date-1) +1 as InterestDays,
				Round(PreMonthBalance*( (LoanInterest.Interest_Rate/dbo.DaysInYear(@CutOffDate)) * (Datediff(Day, LoanInterest.Valid_From, LoanBook.Finance_End_Date-1) +1 ) ),2)as InterestPayment,
				LA.Balance as CurrentMonthBalance,
				PreMonthBalance,
				LoanInterest.Interest_Rate, 
				@LoanMonthBeginning as  MB,
				@LoanMonthEnd as  ME,
				@CutOffDate as CU,
				LoanInterest.Valid_From IB,
				LoanInterest.Valid_To IE, 
				LoanBook.Finance_Start_Date FB, 
				LoanBook.Finance_End_Date FE, 
				LoanBook.Loan_Amount, 
				LoanBook.Unit_Number
				FROM         
				(SELECT   Datediff(month, LH.Finance_Start_Date,@LoanMonth )+1 as LoanMonth,    
							LH.Unit_Number, 
							LH.Fin_Code, 
							LH.Principal_Rate_ID, 
							LH.Loan_Amount, 
							LH.Trans_Month, 
							LH.Finance_Start_Date, 
							(Case When LH.Finance_End_Date is not Null Then LH.Finance_End_Date Else '2078-12-31' End) as Finance_End_Date,	
							LH.Payout_Amount, 
							LH.Payout_Date,
							
							(SELECT  PrevMonthAMO.PreBalance  from
								   (
									SELECT Top 1 Balance as PreBalance, AMO_Month  from FA_Loan_Amortization
											
									Where Unit_number=LH.Unit_Number  And AMO_Month<@LoanMonth
									Order by AMO_Month DESC
									
									) PrevMonthAMO
							) As PreMonthBalance
				        
							
							
				FROM         dbo.FA_Loan_History LH
				Where ( LH.Finance_End_Date-1>=@LoanMonthBeginning or  LH.Finance_End_Date is null) and  LH.Payout_Date is  null
				)
				 LoanBook 
						INNER JOIN  FA_Loan_Amortization LA
								ON LoanBook.Unit_Number = LA.Unit_Number And AMO_Month=@LoanMonthBeginning
						INNER JOIN  dbo.FA_Loan_Interest_Rate LoanInterest 
								ON LoanBook.Fin_Code = LoanInterest.FIN_Code

				WHERE  

    					(LoanBook.Finance_Start_Date<=LoanInterest.Valid_From  AND @LoanMonthBeginning <= LoanInterest.Valid_From)
				And  (LoanBook.Finance_End_Date-1>=LoanInterest.Valid_From)
				And (LoanBook.Finance_End_Date-1 <= @CutOffDate-1 And  LoanBook.Finance_End_Date-1<=LoanInterest.Valid_To)
				--and  (LoanBook.Unit_Number=154559)

				UNION

				--a9
				-- Interest Valid from after the Month Beginning				
				-------------------------------------------------------------------------------------------------------------------------------------------
						-- Financial Start Date Before the Month Begining
								-- Finanacial End Date-1 < Interest Valid To

				SELECT  
				LoanInterest.Valid_From,
				@CutOffDate-1 Valid_To,
				Datediff(Day, LoanInterest.Valid_From, @CutOffDate-1 ) +1 as InterestDays,
				Round(PreMonthBalance*( (LoanInterest.Interest_Rate/dbo.DaysInYear(@CutOffDate)) * (Datediff(Day, LoanInterest.Valid_From, @CutOffDate-1 ) +1) ),2)as InterestPayment,
				LA.Balance as CurrentMonthBalance,
				PreMonthBalance,
				LoanInterest.Interest_Rate, 
				@LoanMonthBeginning as  MB,
				@LoanMonthEnd as  ME,
				@CutOffDate as CU,
				LoanInterest.Valid_From IB,
				LoanInterest.Valid_To IE, 
				LoanBook.Finance_Start_Date FB, 
				LoanBook.Finance_End_Date FE, 
				LoanBook.Loan_Amount, 
				LoanBook.Unit_Number
				FROM         
				(SELECT   Datediff(month, LH.Finance_Start_Date,@LoanMonth )+1 as LoanMonth,    
							LH.Unit_Number, 
							LH.Fin_Code, 
							LH.Principal_Rate_ID, 
							LH.Loan_Amount, 
							LH.Trans_Month, 
							LH.Finance_Start_Date, 
							(Case When LH.Finance_End_Date is not Null Then LH.Finance_End_Date Else '2078-12-31' End) as Finance_End_Date,	
							LH.Payout_Amount, 
							LH.Payout_Date,
							
							(SELECT  PrevMonthAMO.PreBalance  from
								   (
									SELECT Top 1 Balance as PreBalance, AMO_Month  from FA_Loan_Amortization
											
									Where Unit_number=LH.Unit_Number  And AMO_Month<@LoanMonth
									Order by AMO_Month DESC
									
									) PrevMonthAMO
							) As PreMonthBalance
				        
							
							
				FROM         dbo.FA_Loan_History LH
				Where ( LH.Finance_End_Date-1>=@LoanMonthBeginning or  LH.Finance_End_Date is null) and  LH.Payout_Date is  null
				)

				 LoanBook 
						INNER JOIN  FA_Loan_Amortization LA
								ON LoanBook.Unit_Number = LA.Unit_Number And AMO_Month=@LoanMonthBeginning
						INNER JOIN  dbo.FA_Loan_Interest_Rate LoanInterest 
								ON LoanBook.Fin_Code = LoanInterest.FIN_Code
				WHERE  

    					(LoanBook.Finance_Start_Date<=LoanInterest.Valid_From  AND @LoanMonthBeginning <= LoanInterest.Valid_From)
				And  (@CutOffDate-1>=LoanInterest.Valid_From)
				And (@CutOffDate-1 <=LoanBook.Finance_End_Date-1  And   @CutOffDate-1<=LoanInterest.Valid_To)
				--and  (LoanBook.Unit_Number=154559)

				--======================================================================================
				-- After Cut Off Date
				--=====================================================================================
				--B1

				Union
				SELECT   
				LoanBook.Finance_Start_Date as ValidFrom,
				LoanInterest.Valid_To,
				Datediff(Day, LoanBook.Finance_Start_Date, LoanInterest.Valid_To) +1 as InterestDays,
				Round(LA.Balance*( (LoanInterest.Interest_Rate/dbo.DaysInYear(@CutOffDate)) * (Datediff(Day, LoanBook.Finance_Start_Date, LoanInterest.Valid_To) +1) ),2)as InterestPayment,
				LA.Balance as CurrentMonthBalance,
				PreMonthBalance,
				LoanInterest.Interest_Rate, 
				@LoanMonthBeginning as  MB,
				@LoanMonthEnd as  ME,
				@CutOffDate as CU,
				LoanInterest.Valid_From IB,
				LoanInterest.Valid_To IE, 
				LoanBook.Finance_Start_Date FB, 
				LoanBook.Finance_End_Date FE, 
				LoanBook.Loan_Amount, 
				LoanBook.Unit_Number
				FROM         
				(SELECT   Datediff(month, LH.Finance_Start_Date,@LoanMonth )+1 as LoanMonth,    
							LH.Unit_Number, 
							LH.Fin_Code, 
							LH.Principal_Rate_ID, 
							LH.Loan_Amount, 
							LH.Trans_Month, 
							LH.Finance_Start_Date, 
							(Case When LH.Finance_End_Date is not Null Then LH.Finance_End_Date Else '2078-12-31' End) as Finance_End_Date,	
							LH.Payout_Amount, 
							LH.Payout_Date,
							
							(SELECT  PrevMonthAMO.PreBalance  from
								   (
									SELECT Top 1 Balance as PreBalance, AMO_Month  from FA_Loan_Amortization
											
									Where Unit_number=LH.Unit_Number  And AMO_Month<@LoanMonth
									Order by AMO_Month DESC
									
									) PrevMonthAMO
							) As PreMonthBalance
				        
							
							
				FROM         dbo.FA_Loan_History LH
				Where ( LH.Finance_End_Date-1>=@LoanMonthBeginning or  LH.Finance_End_Date is null) and  LH.Payout_Date is  null
				)

				 LoanBook 
						INNER JOIN  FA_Loan_Amortization LA
								ON LoanBook.Unit_Number = LA.Unit_Number And AMO_Month=@LoanMonthBeginning
						INNER JOIN  dbo.FA_Loan_Interest_Rate LoanInterest 
								ON LoanBook.Fin_Code = LoanInterest.FIN_Code

				WHERE  
				--B1	MB/IB/CU	FB	IE	  ME/FE
					
						 (LoanBook.Finance_Start_Date>=@CutOffDate  And LoanBook.Finance_Start_Date>=LoanInterest.Valid_From)
				AND (LoanBook.Finance_Start_Date<=LoanInterest.Valid_To)
				AND (LoanInterest.Valid_To <= @LoanMonthEnd And LoanInterest.Valid_To <= LoanBook.Finance_End_Date)
				--and  (LoanBook.Unit_Number=154559)


				--B2

				Union
				SELECT    
				LoanBook.Finance_Start_Date as ValidFrom,
				@LoanMonthEnd AS Valid_To,
				Datediff(Day, LoanBook.Finance_Start_Date, @LoanMonthEnd) +1 as InterestDays,
				Round(LA.Balance*( (LoanInterest.Interest_Rate/dbo.DaysInYear(@CutOffDate)) * (Datediff(Day, LoanBook.Finance_Start_Date, @LoanMonthEnd) +1) ),2)as InterestPayment,
				LA.Balance as CurrentMonthBalance,
				PreMonthBalance,
				LoanInterest.Interest_Rate, 
				@LoanMonthBeginning as  MB,
				@LoanMonthEnd as  ME,
				@CutOffDate as CU,
				LoanInterest.Valid_From IB,
				LoanInterest.Valid_To IE, 
				LoanBook.Finance_Start_Date FB, 
				LoanBook.Finance_End_Date FE, 
				LoanBook.Loan_Amount, 
				LoanBook.Unit_Number
				FROM         
				(SELECT   Datediff(month, LH.Finance_Start_Date,@LoanMonth )+1 as LoanMonth,    
							LH.Unit_Number, 
							LH.Fin_Code, 
							LH.Principal_Rate_ID, 
							LH.Loan_Amount, 
							LH.Trans_Month, 
							LH.Finance_Start_Date, 
							(Case When LH.Finance_End_Date is not Null Then LH.Finance_End_Date Else '2078-12-31' End) as Finance_End_Date,	
							LH.Payout_Amount, 
							LH.Payout_Date,
							
							(SELECT  PrevMonthAMO.PreBalance  from
								   (
									SELECT Top 1 Balance as PreBalance, AMO_Month  from FA_Loan_Amortization
											
									Where Unit_number=LH.Unit_Number  And AMO_Month<@LoanMonth
									Order by AMO_Month DESC
									
									) PrevMonthAMO
							) As PreMonthBalance
				        
							
							
				FROM         dbo.FA_Loan_History LH
				Where ( LH.Finance_End_Date-1>=@LoanMonthBeginning or  LH.Finance_End_Date is null) and  LH.Payout_Date is  null
				)
				LoanBook 
						INNER JOIN  FA_Loan_Amortization LA
								ON LoanBook.Unit_Number = LA.Unit_Number And AMO_Month=@LoanMonthBeginning
						INNER JOIN  dbo.FA_Loan_Interest_Rate LoanInterest 
								ON LoanBook.Fin_Code = LoanInterest.FIN_Code

				WHERE  
				--B2	MB/IB/CU	FB	ME	IE/FE

						 (LoanBook.Finance_Start_Date>=@CutOffDate  And LoanBook.Finance_Start_Date>=LoanInterest.Valid_From)
				AND (LoanBook.Finance_Start_Date<=@LoanMonthEnd)
				AND (@LoanMonthEnd <= LoanInterest.Valid_To And @LoanMonthEnd <= LoanBook.Finance_End_Date)
				--and  (LoanBook.Unit_Number=154559)


				--B3

				Union
				SELECT   
				LoanBook.Finance_Start_Date as ValidFrom,
				LoanBook.Finance_End_Date-1 AS Valid_To,
				Datediff(Day, LoanBook.Finance_Start_Date, LoanBook.Finance_End_Date-1) +1 as InterestDays,
				Round(LA.Balance*( (LoanInterest.Interest_Rate/dbo.DaysInYear(@CutOffDate)) * (Datediff(Day, LoanBook.Finance_Start_Date, LoanBook.Finance_End_Date-1) +1) ),2)as InterestPayment,
				LA.Balance as CurrentMonthBalance,
				PreMonthBalance,
				LoanInterest.Interest_Rate, 
				@LoanMonthBeginning as  MB,
				@LoanMonthEnd as  ME,
				@CutOffDate as CU,
				LoanInterest.Valid_From IB,
				LoanInterest.Valid_To IE, 
				LoanBook.Finance_Start_Date FB, 
				LoanBook.Finance_End_Date FE, 
				LoanBook.Loan_Amount, 
				LoanBook.Unit_Number
				FROM         
				(SELECT   Datediff(month, LH.Finance_Start_Date,@LoanMonth )+1 as LoanMonth,    
							LH.Unit_Number, 
							LH.Fin_Code, 
							LH.Principal_Rate_ID, 
							LH.Loan_Amount, 
							LH.Trans_Month, 
							LH.Finance_Start_Date, 
							(Case When LH.Finance_End_Date is not Null Then LH.Finance_End_Date Else '2078-12-31' End) as Finance_End_Date,	
							LH.Payout_Amount, 
							LH.Payout_Date,
							
							(SELECT  PrevMonthAMO.PreBalance  from
								   (
									SELECT Top 1 Balance as PreBalance, AMO_Month  from FA_Loan_Amortization
											
									Where Unit_number=LH.Unit_Number  And AMO_Month<@LoanMonth
									Order by AMO_Month DESC
									
									) PrevMonthAMO
							) As PreMonthBalance
				        
							
							
				FROM         dbo.FA_Loan_History LH
				Where ( LH.Finance_End_Date-1>=@LoanMonthBeginning or  LH.Finance_End_Date is null) and  LH.Payout_Date is  null
				)
				 LoanBook 
						INNER JOIN  FA_Loan_Amortization LA
								ON LoanBook.Unit_Number = LA.Unit_Number And AMO_Month=@LoanMonthBeginning
						INNER JOIN  dbo.FA_Loan_Interest_Rate LoanInterest 
								ON LoanBook.Fin_Code = LoanInterest.FIN_Code

				WHERE  
				-- In this case the Loan is with one Month
				--B3	MB/IB/CU	FB	FE	IE/ME
						 (LoanBook.Finance_Start_Date>=@CutOffDate  And LoanBook.Finance_Start_Date>=LoanInterest.Valid_From)
				--AND (LoanBook.Finance_Start_Date<=@LoanMonthEnd)
				AND ( LoanBook.Finance_End_Date <= LoanInterest.Valid_To And  LoanBook.Finance_End_Date <= @LoanMonthEnd)
				--and  (LoanBook.Unit_Number=154559)



				--B4

				Union
				SELECT  
				LoanInterest.Valid_From,
				LoanInterest.Valid_To AS Valid_To,
				Datediff(Day, LoanInterest.Valid_From, LoanInterest.Valid_To) +1 as InterestDays,
				Round(LA.Balance*( (LoanInterest.Interest_Rate/dbo.DaysInYear(@CutOffDate)) * (Datediff(Day, LoanInterest.Valid_From, LoanInterest.Valid_To) +1) ),2)as InterestPayment,
				LA.Balance as CurrentMonthBalance,
				PreMonthBalance,
				LoanInterest.Interest_Rate, 
				@LoanMonthBeginning as  MB,
				@LoanMonthEnd as  ME,
				@CutOffDate as CU,
				LoanInterest.Valid_From IB,
				LoanInterest.Valid_To IE, 
				LoanBook.Finance_Start_Date FB, 
				LoanBook.Finance_End_Date FE, 
				LoanBook.Loan_Amount, 
				LoanBook.Unit_Number
				FROM         
				(SELECT   Datediff(month, LH.Finance_Start_Date,@LoanMonth )+1 as LoanMonth,    
							LH.Unit_Number, 
							LH.Fin_Code, 
							LH.Principal_Rate_ID, 
							LH.Loan_Amount, 
							LH.Trans_Month, 
							LH.Finance_Start_Date, 
							(Case When LH.Finance_End_Date is not Null Then LH.Finance_End_Date Else '2078-12-31' End) as Finance_End_Date,	
							LH.Payout_Amount, 
							LH.Payout_Date,
							
							(SELECT  PrevMonthAMO.PreBalance  from
								   (
									SELECT Top 1 Balance as PreBalance, AMO_Month  from FA_Loan_Amortization
											
									Where Unit_number=LH.Unit_Number  And AMO_Month<@LoanMonth
									Order by AMO_Month DESC
									
									) PrevMonthAMO
							) As PreMonthBalance
				        
							
							
				FROM         dbo.FA_Loan_History LH
				Where ( LH.Finance_End_Date-1>=@LoanMonthBeginning or  LH.Finance_End_Date is null) and  LH.Payout_Date is  null
				)
				 LoanBook 
						INNER JOIN  FA_Loan_Amortization LA
								ON LoanBook.Unit_Number = LA.Unit_Number And AMO_Month=@LoanMonthBeginning
						INNER JOIN  dbo.FA_Loan_Interest_Rate LoanInterest 
								ON LoanBook.Fin_Code = LoanInterest.FIN_Code

				WHERE  

				--B4	MB/FB/CU	IB 	IE	 FE/ME
						 (LoanInterest.Valid_From>=@CutOffDate  And LoanInterest.Valid_From>=LoanBook.Finance_Start_Date)
				--AND (LoanInterest.Valid_From<=LoanInterest.Valid_To )
				AND ( LoanInterest.Valid_To <=LoanBook.Finance_Start_Date And  LoanInterest.Valid_To  <= @LoanMonthEnd)
				--and  (LoanBook.Unit_Number=154559)


				--B5

				Union
				SELECT    
				LoanInterest.Valid_From,
				@LoanMonthEnd AS Valid_To,
				Datediff(Day, LoanInterest.Valid_From, @LoanMonthEnd) +1 as InterestDays,
				Round(LA.Balance*( (LoanInterest.Interest_Rate/dbo.DaysInYear(@CutOffDate)) * (Datediff(Day, LoanInterest.Valid_From, @LoanMonthEnd) +1) ),2)as InterestPayment,
				LA.Balance as CurrentMonthBalance,
				PreMonthBalance,
				LoanInterest.Interest_Rate, 
				@LoanMonthBeginning as  MB,
				@LoanMonthEnd as  ME,
				@CutOffDate as CU,
				LoanInterest.Valid_From IB,
				LoanInterest.Valid_To IE, 
				LoanBook.Finance_Start_Date FB, 
				LoanBook.Finance_End_Date FE, 
				LoanBook.Loan_Amount, 
				LoanBook.Unit_Number
				FROM         
				(SELECT   Datediff(month, LH.Finance_Start_Date,@LoanMonth )+1 as LoanMonth,    
							LH.Unit_Number, 
							LH.Fin_Code, 
							LH.Principal_Rate_ID, 
							LH.Loan_Amount, 
							LH.Trans_Month, 
							LH.Finance_Start_Date, 
							(Case When LH.Finance_End_Date is not Null Then LH.Finance_End_Date Else '2078-12-31' End) as Finance_End_Date,	
							LH.Payout_Amount, 
							LH.Payout_Date,
							
							(SELECT  PrevMonthAMO.PreBalance  from
								   (
									SELECT Top 1 Balance as PreBalance, AMO_Month  from FA_Loan_Amortization
											
									Where Unit_number=LH.Unit_Number  And AMO_Month<@LoanMonth
									Order by AMO_Month DESC
									
									) PrevMonthAMO
							) As PreMonthBalance
				        
							
							
				FROM         dbo.FA_Loan_History LH
				Where ( LH.Finance_End_Date-1>=@LoanMonthBeginning or  LH.Finance_End_Date is null) and  LH.Payout_Date is  null
				)
				 LoanBook 
						INNER JOIN  FA_Loan_Amortization LA
								ON LoanBook.Unit_Number = LA.Unit_Number And AMO_Month=@LoanMonthBeginning
						INNER JOIN  dbo.FA_Loan_Interest_Rate LoanInterest 
								ON LoanBook.Fin_Code = LoanInterest.FIN_Code

				WHERE  

				--B5	MB/FB/CU	IB 	ME	IE/FE
						 (LoanInterest.Valid_From>=@CutOffDate  And LoanInterest.Valid_From>=LoanBook.Finance_Start_Date)
				AND (LoanInterest.Valid_From <=@LoanMonthEnd)
				AND ( @LoanMonthEnd <=LoanBook.Finance_End_Date And  @LoanMonthEnd  <= LoanInterest.Valid_To )
				--and  (LoanBook.Unit_Number=154559)


				--B6
				Union
				SELECT    
				LoanInterest.Valid_From,
				LoanBook.Finance_End_Date-1 AS Valid_To,
				Datediff(Day, LoanInterest.Valid_From, LoanBook.Finance_End_Date-1) +1 as InterestDays,
				Round(LA.Balance*( (LoanInterest.Interest_Rate/dbo.DaysInYear(@CutOffDate)) * (Datediff(Day, LoanInterest.Valid_From, LoanBook.Finance_End_Date-1) +1) ),2)as InterestPayment,
				LA.Balance as CurrentMonthBalance,
				PreMonthBalance,
				LoanInterest.Interest_Rate, 
				@LoanMonthBeginning as  MB,
				@LoanMonthEnd as  ME,
				@CutOffDate as CU,
				LoanInterest.Valid_From IB,
				LoanInterest.Valid_To IE, 
				LoanBook.Finance_Start_Date FB, 
				LoanBook.Finance_End_Date FE, 
				LoanBook.Loan_Amount, 
				LoanBook.Unit_Number
				FROM         
				(SELECT   Datediff(month, LH.Finance_Start_Date,@LoanMonth )+1 as LoanMonth,    
							LH.Unit_Number, 
							LH.Fin_Code, 
							LH.Principal_Rate_ID, 
							LH.Loan_Amount, 
							LH.Trans_Month, 
							LH.Finance_Start_Date, 
							(Case When LH.Finance_End_Date is not Null Then LH.Finance_End_Date Else '2078-12-31' End) as Finance_End_Date,	
							LH.Payout_Amount, 
							LH.Payout_Date,
							
							(SELECT  PrevMonthAMO.PreBalance  from
								   (
									SELECT Top 1 Balance as PreBalance, AMO_Month  from FA_Loan_Amortization
											
									Where Unit_number=LH.Unit_Number  And AMO_Month<@LoanMonth
									Order by AMO_Month DESC
									
									) PrevMonthAMO
							) As PreMonthBalance
				        
							
							
				FROM         dbo.FA_Loan_History LH
				Where ( LH.Finance_End_Date-1>=@LoanMonthBeginning or  LH.Finance_End_Date is null) and  LH.Payout_Date is  null
				)
				 LoanBook 
						INNER JOIN  FA_Loan_Amortization LA
								ON LoanBook.Unit_Number = LA.Unit_Number And AMO_Month=@LoanMonthBeginning
						INNER JOIN  dbo.FA_Loan_Interest_Rate LoanInterest 
								ON LoanBook.Fin_Code = LoanInterest.FIN_Code

				WHERE  

				--B6	MB/FB/CU	IB 	FE	IE/ME
						 (LoanInterest.Valid_From>=@CutOffDate  And LoanInterest.Valid_From>=LoanBook.Finance_Start_Date)
				AND (LoanInterest.Valid_From <=LoanBook.Finance_End_Date)
				AND ( LoanBook.Finance_End_Date <=@LoanMonthEnd  And  LoanBook.Finance_End_Date <= LoanInterest.Valid_To )
				--and  (LoanBook.Unit_Number=154559)


				--B7
				Union
				SELECT    
				@CutOffDate as ValidFrom,
				LoanInterest.Valid_To,
				Datediff(Day, @CutOffDate , LoanInterest.Valid_To) +1 as InterestDays,
				Round(LA.Balance*( (LoanInterest.Interest_Rate/dbo.DaysInYear(@CutOffDate)) * (Datediff(Day, @CutOffDate , LoanInterest.Valid_To) +1) ),2)as InterestPayment,
				LA.Balance as CurrentMonthBalance,
				PreMonthBalance,
				LoanInterest.Interest_Rate, 
				@LoanMonthBeginning as  MB,
				@LoanMonthEnd as  ME,
				@CutOffDate as CU,
				LoanInterest.Valid_From IB,
				LoanInterest.Valid_To IE, 
				LoanBook.Finance_Start_Date FB, 
				LoanBook.Finance_End_Date FE, 
				LoanBook.Loan_Amount, 
				LoanBook.Unit_Number
				FROM         
				(SELECT   Datediff(month, LH.Finance_Start_Date,@LoanMonth )+1 as LoanMonth,    
							LH.Unit_Number, 
							LH.Fin_Code, 
							LH.Principal_Rate_ID, 
							LH.Loan_Amount, 
							LH.Trans_Month, 
							LH.Finance_Start_Date, 
							(Case When LH.Finance_End_Date is not Null Then LH.Finance_End_Date Else '2078-12-31' End) as Finance_End_Date,	
							LH.Payout_Amount, 
							LH.Payout_Date,
							
							(SELECT  PrevMonthAMO.PreBalance  from
								   (
									SELECT Top 1 Balance as PreBalance, AMO_Month  from FA_Loan_Amortization
											
									Where Unit_number=LH.Unit_Number  And AMO_Month<@LoanMonth
									Order by AMO_Month DESC
									
									) PrevMonthAMO
							) As PreMonthBalance
				        
							
							
				FROM         dbo.FA_Loan_History LH
				Where ( LH.Finance_End_Date-1>=@LoanMonthBeginning or  LH.Finance_End_Date is null) and  LH.Payout_Date is  null
				)

				 LoanBook 
						INNER JOIN  FA_Loan_Amortization LA
								ON LoanBook.Unit_Number = LA.Unit_Number And AMO_Month=@LoanMonthBeginning
						INNER JOIN  dbo.FA_Loan_Interest_Rate LoanInterest 
								ON LoanBook.Fin_Code = LoanInterest.FIN_Code
				WHERE  

				--B7	MB/IB/FB	CU	IE	 FE/ME
						 (@CutOffDate>=LoanBook.Finance_Start_Date  And @CutOffDate>=LoanInterest.Valid_From)
				AND (@CutOffDate<=LoanInterest.Valid_To)
				AND ( LoanInterest.Valid_To<=LoanBook.Finance_End_Date   And  LoanInterest.Valid_To <= @LoanMonthEnd )
				--and  (LoanBook.Unit_Number=154559)



				--B8
				Union
				SELECT     
				@CutOffDate as ValidFrom,
				@LoanMonthEnd AS Valid_To,
				Datediff(Day, @CutOffDate, @LoanMonthEnd) +1 as InterestDays,
				Round(LA.Balance*( (LoanInterest.Interest_Rate/dbo.DaysInYear(@CutOffDate)) * (Datediff(Day, @CutOffDate, @LoanMonthEnd) +1) ),2)as InterestPayment,
				LA.Balance as CurrentMonthBalance,
				PreMonthBalance,
				LoanInterest.Interest_Rate, 
				@LoanMonthBeginning as  MB,
				@LoanMonthEnd as  ME,
				@CutOffDate as CU,
				LoanInterest.Valid_From IB,
				LoanInterest.Valid_To IE, 
				LoanBook.Finance_Start_Date FB, 
				LoanBook.Finance_End_Date FE, 
				LoanBook.Loan_Amount, 
				LoanBook.Unit_Number
				FROM         
				(SELECT   Datediff(month, LH.Finance_Start_Date,@LoanMonth )+1 as LoanMonth,    
							LH.Unit_Number, 
							LH.Fin_Code, 
							LH.Principal_Rate_ID, 
							LH.Loan_Amount, 
							LH.Trans_Month, 
							LH.Finance_Start_Date, 
							(Case When LH.Finance_End_Date is not Null Then LH.Finance_End_Date Else '2078-12-31' End) as Finance_End_Date,	
							LH.Payout_Amount, 
							LH.Payout_Date,
							
							(SELECT  PrevMonthAMO.PreBalance  from
								   (
									SELECT Top 1 Balance as PreBalance, AMO_Month  from FA_Loan_Amortization
											
									Where Unit_number=LH.Unit_Number  And AMO_Month<@LoanMonth
									Order by AMO_Month DESC
									
									) PrevMonthAMO
							) As PreMonthBalance
				        
							
							
				FROM         dbo.FA_Loan_History LH
				Where ( LH.Finance_End_Date-1>=@LoanMonthBeginning or  LH.Finance_End_Date is null) and  LH.Payout_Date is  null
				)

				 LoanBook 
						INNER JOIN  FA_Loan_Amortization LA
								ON LoanBook.Unit_Number = LA.Unit_Number And AMO_Month=@LoanMonthBeginning
						INNER JOIN  dbo.FA_Loan_Interest_Rate LoanInterest 
								ON LoanBook.Fin_Code = LoanInterest.FIN_Code
				WHERE  

				--B8	MB/IB/FB	CU	ME	IE/FE
						 (@CutOffDate>=LoanBook.Finance_Start_Date  And @CutOffDate>=LoanInterest.Valid_From)
				AND (@CutOffDate<=@LoanMonthEnd)
				AND ( @LoanMonthEnd<=LoanBook.Finance_End_Date   And  @LoanMonthEnd<=LoanInterest.Valid_To)
				--and  (LoanBook.Unit_Number=154559)



				--B9
				Union
				SELECT    
				@CutOffDate as ValidFrom,
				LoanBook.Finance_End_Date-1 AS Valid_To,
				Datediff(Day, @CutOffDate , LoanBook.Finance_End_Date-1) +1 as InterestDays,
				Round(LA.Balance*( (LoanInterest.Interest_Rate/dbo.DaysInYear(@CutOffDate)) * (Datediff(Day, @CutOffDate , LoanBook.Finance_End_Date-1) +1) ),2)as InterestPayment,
				LA.Balance as CurrentMonthBalance,
				PreMonthBalance,
				LoanInterest.Interest_Rate, 
				@LoanMonthBeginning as  MB,
				@LoanMonthEnd as  ME,
				@CutOffDate as CU,
				LoanInterest.Valid_From IB,
				LoanInterest.Valid_To IE, 
				LoanBook.Finance_Start_Date FB, 
				LoanBook.Finance_End_Date FE, 
				LoanBook.Loan_Amount, 
				LoanBook.Unit_Number
				FROM         
				(SELECT   Datediff(month, LH.Finance_Start_Date,@LoanMonth )+1 as LoanMonth,    
							LH.Unit_Number, 
							LH.Fin_Code, 
							LH.Principal_Rate_ID, 
							LH.Loan_Amount, 
							LH.Trans_Month, 
							LH.Finance_Start_Date, 
							(Case When LH.Finance_End_Date is not Null Then LH.Finance_End_Date Else '2078-12-31' End) as Finance_End_Date,	
							LH.Payout_Amount, 
							LH.Payout_Date,
							
							(SELECT  PrevMonthAMO.PreBalance  from
								   (
									SELECT Top 1 Balance as PreBalance, AMO_Month  from FA_Loan_Amortization
											
									Where Unit_number=LH.Unit_Number  And AMO_Month<@LoanMonth
									Order by AMO_Month DESC
									
									) PrevMonthAMO
							) As PreMonthBalance
				        
							
							
				FROM         dbo.FA_Loan_History LH
				Where ( LH.Finance_End_Date-1>=@LoanMonthBeginning or  LH.Finance_End_Date is null) and  LH.Payout_Date is  null
				)

				 LoanBook 
						INNER JOIN  FA_Loan_Amortization LA
								ON LoanBook.Unit_Number = LA.Unit_Number And AMO_Month=@LoanMonthBeginning
						INNER JOIN  dbo.FA_Loan_Interest_Rate LoanInterest 
								ON LoanBook.Fin_Code = LoanInterest.FIN_Code

				WHERE  

				--B9	MB/IB/FB	CU	FE	ME/IE
						 (@CutOffDate>=LoanBook.Finance_Start_Date  And @CutOffDate>=LoanInterest.Valid_From)
				AND (@CutOffDate<=LoanBook.Finance_End_Date)
				AND ( LoanBook.Finance_End_Date<=@LoanMonthEnd   And  LoanBook.Finance_End_Date<=LoanInterest.Valid_To)
				--and  (LoanBook.Unit_Number=154559)

			) LoanInterest
			Group by LoanInterest.Unit_Number,  LoanInterest.MB
	)	MonthlyInterest
		INNER JOIN  FA_Loan_Amortization LAMO
								ON MonthlyInterest.Unit_Number = LAMO.Unit_Number And LAMO.AMO_Month=MonthlyInterest.MB

/*
Inner Join FA_Loan_Amortization LoanAmo
On LoanInterest.
*/
GO
