USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[FA_CreateLoanAmotization]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[FA_CreateLoanAmotization]  -- 'CWF', '2009-09-01', '2009-09-20',  'V'

	@sFinCode Varchar(24),
	@sLoanMonth VarChar(24),
	@sCutOffDate VarChar(24),
	@sMode Char(1)='C' 
As
-- Created By Roy He On 2009-02-12

Declare @LoanMonth Datetime
Declare @LoanMonthBeginning Datetime
Declare @LoanMonthEnd Datetime
Declare @CutOffDate Datetime


Select @LoanMonth=Convert(Datetime, NULLIF(@sLoanMonth,''))
Select @LoanMonthBeginning=@LoanMonth-Day(@LoanMonth)+1
Select @LoanMonthEnd=DATEADD(month,1, @LoanMonthBeginning)-1
Select @CutOffDate=Convert(Datetime, NULLIF(@sCutOffDate,''))


CREATE TABLE #FA_Loan_Amortization (
	[Unit_Number] [int] NOT NULL ,
	[AMO_Month] [datetime] NOT NULL ,
	[Fin_Code] [char] (10) NULL ,
	[Finance_Start_Date] [datetime] NULL ,
	[Principle_Amount] [decimal](9, 2) NULL ,
	[Interest_Amount] [decimal](9, 2) NULL ,
	[Balance] [decimal](10, 2) NULL ,
	[Last_Updated_On] [datetime] NULL 
) 

-- Get Previous Month ARMO if exist
Insert into #FA_Loan_Amortization
SELECT     LA.Unit_Number, LA.AMO_Month, LA.Fin_Code, LA.Finance_Start_Date, LA.Principle_Amount, LA.Interest_Amount, LA.Balance, 
                      LA.Last_Updated_On
FROM         dbo.FA_Loan_Amortization LA INNER JOIN
                      dbo.FA_Loan_History LH ON LA.Unit_Number = LH.Unit_Number AND LA.Fin_Code = LH.Fin_Code AND LA.Finance_Start_Date = LH.Finance_Start_Date          
					INNER JOIN 
					(Select Unit_number, Max(AMO_Month) AMO_Month,  Fin_Code, Finance_Start_Date  from  dbo.FA_Loan_Amortization 
					 where AMO_Month<@LoanMonthBeginning
					 Group by Unit_Number, Unit_number,Fin_Code, Finance_Start_Date)
					 PrevLA
					On LA.Unit_Number=PrevLA.Unit_Number And LA.Fin_Code=PrevLA.Fin_Code And LA.Finance_Start_Date=PrevLA.Finance_Start_Date and  LA.AMO_Month= PrevLA.AMO_Month
Where (	
				(LH.Finance_Start_Date>=@LoanMonthBeginning and LH.Finance_Start_Date <=@LoanMonthEnd)
						OR   
							(LH.Finance_End_Date-1>=@LoanMonthBeginning AND LH.Finance_End_Date-1<=@LoanMonthEnd)

						--- Including whole month
						OR 	
							(LH.Finance_Start_Date<=@LoanMonthBeginning and LH.Finance_End_Date-1 >=@LoanMonthEnd)

						OR 
						(LH.Finance_Start_Date<=@LoanMonthBeginning	AND  LH.Finance_End_Date is null) 
					)  
	


--If No Loan Amo before, create an initial one
Insert into #FA_Loan_Amortization
 
SELECT     Unit_Number, (Finance_Start_Date-Day(Finance_Start_Date))-Day(Finance_Start_Date-Day(Finance_Start_Date))+1 as AMO_Month, Fin_code,  Finance_Start_Date,NULL, NULL,  
LH.Loan_Amount- (Case When  Override_Principal_Rate is not Null And  Override_Principal_Rate<>0 THEN Loan_Amount* Override_Principal_Rate/100
										When RD.Principal_Rate_Amount is Not Null and  RD.Principal_Rate_Amount<>0 Then RD.Principal_Rate_Amount
                                        When RD.Principal_Rate is Not Null and RD.Principal_Rate<>0 Then Loan_Amount*RD.Principal_Rate/100
										Else 0
								End)
*(case when LH.Trans_Month is null then 0 else LH.Trans_Month end ) as IntitialBalance, 

getdate()
FROM         dbo.FA_Loan_History LH Left Join  
(SELECT     RateDetail.Rate_ID, RateDetail.Start_Month, RateDetail.End_Month, RateDetail.Principal_Rate, RateDetail.Principal_Rate_Amount, RateDetail.Valid_From, 
                      RateDetail.Valid_To, PrincipalRate.Effective_Date, PrincipalRate.Terminate_Date
FROM         dbo.FA_Loan_Principal_Rate AS PrincipalRate INNER JOIN
                      dbo.FA_Loan_Principal_Rate_Detail AS RateDetail ON PrincipalRate.Rate_ID = RateDetail.Rate_ID
) RD On LH.Principal_Rate_ID=RD.Rate_ID and RD.Start_Month=1
Where Unit_Number not in (SELECT     dbo.FA_Loan_Amortization.Unit_Number
FROM         dbo.FA_Loan_Amortization 
Where dbo.FA_Loan_Amortization.Unit_Number= LH.Unit_Number and dbo.FA_Loan_Amortization.Fin_Code = LH.Fin_Code
			And dbo.FA_Loan_Amortization.Finance_Start_Date = LH.Finance_Start_Date And AMO_Month<@LoanMonthBeginning


) and Fin_code=@sFinCode
And RD.Valid_From<= @LoanMonthBeginning And  @LoanMonthEnd<=ISNULL(RD.Valid_To, '2078-12-31')
And Finance_Start_Date between RD.Effective_Date And ISNULL(RD.Terminate_Date, '2078-12-31')

And (	
                    -- Partial Month
							(LH.Finance_Start_Date>=@LoanMonthBeginning and LH.Finance_Start_Date <=@LoanMonthEnd)

						OR   

							(LH.Finance_End_Date-1>=@LoanMonthBeginning AND LH.Finance_End_Date-1<=@LoanMonthEnd)						

						--- Whole month
						OR 	
							(LH.Finance_Start_Date<=@LoanMonthBeginning and LH.Finance_End_Date-1 >=@LoanMonthEnd)

						OR 
						(LH.Finance_Start_Date<=@LoanMonthBeginning	AND  LH.Finance_End_Date is null) 
					)     




Insert into #FA_Loan_Amortization
Select   Unit_Number, 
@LoanMonthBeginning LoanMonth, 
LoanBook.Fin_Code,
Finance_Start_Date,

(      
		-- If Loan End date is on or after the cut off date, the we got whole month Principal, otherwise on princial
		Case When (Finance_End_Date>=@CutOffDate  Or Finance_End_Date Is Null) And (Finance_Start_Date <@CutOffDate)Then --Payout_Amount =0 or  Payout_Amount is   null	Then 
                                              (
                                                    Case When LoanMonth=RD.Expiry_Month --And Override_Principal_Rate is  Null 
																	  And (      
																					(RD.Principal_Rate_Amount is Not Null and  RD.Principal_Rate_Amount<>0 )
																					OR
																					( RD.Principal_Rate is Not Null and RD.Principal_Rate<>0)
																				)
																Then   PreMonthBalance
													  Else     		
                                                       		 Convert(decimal(9,2), 

																			(Case When  Override_Principal_Rate is not Null And  Override_Principal_Rate<>0 THEN Loan_Amount* Override_Principal_Rate/100
																					  When RD.Principal_Rate_Amount is Not Null and  RD.Principal_Rate_Amount<>0 Then RD.Principal_Rate_Amount
																					  When RD.Principal_Rate is Not Null and RD.Principal_Rate<>0 Then Loan_Amount*RD.Principal_Rate/100
																					  Else 0
																			End)

													            )
													End
                                            )
		Else
				0
End)  PrincipalAmount,
--PreMonthBalance as PreBalance, 
NULL,
PreMonthBalance-
						
(      
		-- If Loan End date is on or after the cut off date, the we got whole month Principal, otherwise on princial
		Case When (Finance_End_Date>=@CutOffDate  Or Finance_End_Date Is Null) And (Finance_Start_Date <@CutOffDate) Then --Payout_Amount =0 or  Payout_Amount is   null	Then 
                                              (
                                                    Case When LoanMonth=RD.Expiry_Month --And Override_Principal_Rate is  Null 
																	  And (      
																					(RD.Principal_Rate_Amount is Not Null and  RD.Principal_Rate_Amount<>0 )
																					OR
																					( RD.Principal_Rate is Not Null and RD.Principal_Rate<>0)
																				)
																Then   PreMonthBalance
													  Else     		
                                                       		 Convert(decimal(9,2), 

																			(Case When  Override_Principal_Rate is not Null And  Override_Principal_Rate<>0 THEN Loan_Amount* Override_Principal_Rate/100
																					  When RD.Principal_Rate_Amount is Not Null and  RD.Principal_Rate_Amount<>0 Then RD.Principal_Rate_Amount
																					  When RD.Principal_Rate is Not Null and RD.Principal_Rate<>0 Then Loan_Amount*RD.Principal_Rate/100
																					  Else 0
																			End)

													            )
													End
                                            )
		Else
				0
End)-  dbo.ZeroIfNull(Payout_Amount)

--							(
--										Case When Payout_Amount =0 or  Payout_Amount is   null	Then 
--																					Convert(decimal(9,2), 
--																					Loan_Amount*  (Case When  Override_Principal_Rate is not Null And  Override_Principal_Rate<>0 THEN Override_Principal_Rate
--																														ELSE RD.Principal_Rate
--																												END)/100.0000000
--																					)
--										Else
--												Payout_Amount
--								End)

 as Balanace,   Getdate()
from 
(SELECT    
			(Case When LH.Trans_Month is not null Then LH.Trans_Month Else 0 End)+
			(Case When (LH.Finance_Start_Date <@CutOffDate) Then	Datediff(month, LH.Finance_Start_Date,@LoanMonthBeginning )+1 
					When (LH.Finance_Start_Date >=@CutOffDate) Then	Datediff(month, LH.Finance_Start_Date,@LoanMonthBeginning ) 
			End) as LoanMonth,    
			LH.Unit_Number, 
			LH.Fin_Code, 
			LH.Principal_Rate_ID, 
			LH.Override_Principal_Rate,
			LH.Loan_Amount, 
			LH.Trans_Month, 
			LH.Finance_Start_Date, 
			LH.Finance_End_Date, 
			-- Ignore the payount date, payout date is only for reference, Use OSD instead
			(Case When LH.Finance_End_Date>=@LoanMonthBeginning and LH.Finance_End_Date<=@LoanMonthEnd Then LH.Payout_Amount
																			Else 0
																	End) Payout_Amount,
			LH.Payout_Date,
          
	   		--(Case When  Datediff(month, LH.Finance_Start_Date,@LoanMonthBeginning )+1 =1 then LH.Loan_Amount
			--Else
			
				(SELECT  PrevMonthAMO.PreBalance  from
					   (
						SELECT Top 1 Balance as PreBalance, AMO_Month  from #FA_Loan_Amortization
								
						Where Unit_number=LH.Unit_Number  
						And Fin_code=LH.Fin_Code
						And Finance_Start_Date=LH.Finance_Start_Date	   
						And AMO_Month<@LoanMonthBeginning
						Order by AMO_Month DESC
						
						) PrevMonthAMO
				)
			--End)
 As PreMonthBalance
			
			
FROM         dbo.FA_Loan_History LH
Where (	(Finance_Start_Date>=@LoanMonthBeginning and Finance_Start_Date <=@LoanMonthEnd)
				OR   
					(Finance_End_Date-1>=@LoanMonthBeginning AND Finance_End_Date-1<=@LoanMonthEnd)

				--- Including whole month
				OR 	
					(Finance_Start_Date<=@LoanMonthBeginning and Finance_End_Date-1 >=@LoanMonthEnd)

				OR 
					(Finance_Start_Date<=@LoanMonthBeginning	AND  Finance_End_Date is null) )  



--and  (LH.Payout_Date is  Null Or LH.Payout_Date >@LoanMonthBeginning)
) LoanBook

Inner Join  
--(SELECT     RateDetail.Rate_ID, RateDetail.Start_Month, RateDetail.End_Month, RateDetail.Principal_Rate, RateDetail.Principal_Rate_Amount, RateDetail.Valid_From, 
--                      RateDetail.Valid_To, PrincipalRate.Effective_Date, PrincipalRate.Terminate_Date
--FROM         dbo.FA_Loan_Principal_Rate AS PrincipalRate INNER JOIN
--                      dbo.FA_Loan_Principal_Rate_Detail AS RateDetail ON PrincipalRate.Rate_ID = RateDetail.Rate_ID
--) RD
(SELECT     RateDetail.Rate_ID, RateDetail.Start_Month, RateDetail.End_Month, RateDetail.Principal_Rate, RateDetail.Principal_Rate_Amount, RateDetail.Valid_From, 
                      RateDetail.Valid_To, PrincipalRate.Effective_Date, PrincipalRate.Terminate_Date, LastMonthRD.Expiry_Month
FROM         dbo.FA_Loan_Principal_Rate AS PrincipalRate INNER JOIN
                      dbo.FA_Loan_Principal_Rate_Detail AS RateDetail ON PrincipalRate.Rate_ID = RateDetail.Rate_ID
                   Inner Join 
					(select Rate_ID, Max(End_Month) as Expiry_Month from dbo.FA_Loan_Principal_Rate_Detail  Group by Rate_ID) LastMonthRD
                   ON PrincipalRate.Rate_ID =LastMonthRD.Rate_ID
) RD
--dbo.FA_Loan_Principal_Rate_Detail RD
On LoanBook.Principal_Rate_ID=RD.Rate_ID
Where  (LoanMonth BETWEEN RD.Start_Month AND RD.End_Month) 
--And  (RD.Valid_From<= @LoanMonthBeginning And  @LoanMonthEnd<=RD.Valid_To) 
And RD.Valid_From<= @LoanMonthBeginning And  @LoanMonthEnd<=ISNULL(RD.Valid_To, '2078-12-31')
And Finance_Start_Date between RD.Effective_Date And ISNULL(RD.Terminate_Date, '2078-12-31')

And  (LoanBook.PreMonthBalance<>0) And (LoanBook.Fin_Code=@sFinCode)


   Update #FA_Loan_Amortization Set Interest_Amount=MonthlyInterest.TotalInterestPayment
 -- Select MonthlyInterest.*, LAMO.* 
   From 
    (
    -- Total Intest
	Select  Sum(LoanInterest.InterestPayment) as TotalInterestPayment,LoanInterest.Unit_Number,  LoanInterest.MB, LoanInterest.Fin_Code, LoanInterest.FB from 
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
				LoanBook.Fin_Code,
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
--							(Case When LH.Payout_Date>=@LoanMonthBeginning and Payout_Date<=@LoanMonthEnd Then LH.Payout_Amount
--									  Else 0
--							End) Payout_Amount,
							(Case When LH.Finance_End_Date>=@LoanMonthBeginning and LH.Finance_End_Date<=@LoanMonthEnd Then LH.Payout_Amount
												Else 0
							End) Payout_Amount,
							LH.Payout_Date,
														
							(SELECT  PrevMonthAMO.PreBalance  from
								   (
									SELECT Top 1 Balance as PreBalance, AMO_Month  from #FA_Loan_Amortization
											
									Where Unit_number=LH.Unit_Number 
												And Fin_Code=LH.Fin_Code
												And Finance_Start_Date=LH.Finance_Start_Date
												And AMO_Month<@LoanMonthBeginning
									Order by AMO_Month DESC
									
									) PrevMonthAMO
							) As PreMonthBalance
							
							
							
				FROM         dbo.FA_Loan_History LH
				Where-- ( LH.Finance_End_Date-1>=@LoanMonthBeginning or  LH.Finance_End_Date is null)  
						(
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
						--and  (LH.Payout_Date is  Null Or LH.Payout_Date >@LoanMonthBeginning)
				)
				 LoanBook 
						INNER JOIN  #FA_Loan_Amortization LA
								ON LoanBook.Unit_Number = LA.Unit_Number And AMO_Month=@LoanMonthBeginning
						INNER JOIN  dbo.FA_Loan_Interest_Rate LoanInterest 
								ON LoanBook.Fin_Code = LoanInterest.FIN_Code

				WHERE  
					   ( LoanInterest.Valid_From<=@LoanMonthBeginning ) And (LoanBook.Finance_Start_Date<=@LoanMonthBeginning)
				And (LoanInterest.Valid_To >=@LoanMonthBeginning )
				And (LoanInterest.Valid_To<=LoanBook.Finance_End_Date And  LoanInterest.Valid_To <= @CutOffDate-1)
				AND (LoanBook.Fin_Code=@sFinCode) --and  (LoanBook.Unit_Number=154559)


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
				LoanBook.Fin_Code,  
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
							(Case When LH.Finance_End_Date>=@LoanMonthBeginning and LH.Finance_End_Date<=@LoanMonthEnd Then LH.Payout_Amount
												Else 0
							End) Payout_Amount,
							LH.Payout_Date,
											
							(SELECT  PrevMonthAMO.PreBalance  from
								   (
									SELECT Top 1 Balance as PreBalance, AMO_Month  from #FA_Loan_Amortization
											
									Where Unit_number=LH.Unit_Number 
												And Fin_Code=LH.Fin_Code
												And Finance_Start_Date=LH.Finance_Start_Date
												And AMO_Month<@LoanMonthBeginning
									Order by AMO_Month DESC
									
									) PrevMonthAMO
							) As PreMonthBalance
			
				        
							
							
				FROM         dbo.FA_Loan_History LH
				Where-- ( LH.Finance_End_Date-1>=@LoanMonthBeginning or  LH.Finance_End_Date is null)  
						(
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
						--and  (LH.Payout_Date is  Null Or LH.Payout_Date >@LoanMonthBeginning)
				)

				 LoanBook 
						INNER JOIN  #FA_Loan_Amortization LA
								ON LoanBook.Unit_Number = LA.Unit_Number And AMO_Month=@LoanMonthBeginning
						INNER JOIN  dbo.FA_Loan_Interest_Rate LoanInterest 
								ON LoanBook.Fin_Code = LoanInterest.FIN_Code

				WHERE  
						( LoanInterest.Valid_From<=@LoanMonthBeginning  And LoanBook.Finance_Start_Date<=@LoanMonthBeginning )
				And  (LoanBook.Finance_End_Date-1>=@LoanMonthBeginning)
				And  (LoanBook.Finance_End_Date-1<=LoanInterest.Valid_To And   LoanBook.Finance_End_Date-1<= @CutOffDate-1)
				AND (LoanBook.Fin_Code=@sFinCode) --and  (LoanBook.Unit_Number=154559)

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
				LoanBook.Fin_Code,
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
							(Case When LH.Finance_End_Date>=@LoanMonthBeginning and LH.Finance_End_Date<=@LoanMonthEnd Then LH.Payout_Amount
												Else 0
							End) Payout_Amount,
							LH.Payout_Date,
							
							(SELECT  PrevMonthAMO.PreBalance  from
								   (
									SELECT Top 1 Balance as PreBalance, AMO_Month  from #FA_Loan_Amortization
											
									Where Unit_number=LH.Unit_Number 
												And Fin_Code=LH.Fin_Code
												And Finance_Start_Date=LH.Finance_Start_Date
												And AMO_Month<@LoanMonthBeginning
									Order by AMO_Month DESC
									
									) PrevMonthAMO
							) As PreMonthBalance
							
							
				FROM         dbo.FA_Loan_History LH
				Where-- ( LH.Finance_End_Date-1>=@LoanMonthBeginning or  LH.Finance_End_Date is null)  
						(
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
						--and  (LH.Payout_Date is  Null Or LH.Payout_Date >@LoanMonthBeginning)
				)

				 LoanBook 
						INNER JOIN  #FA_Loan_Amortization LA
								ON LoanBook.Unit_Number = LA.Unit_Number And AMO_Month=@LoanMonthBeginning
						INNER JOIN  dbo.FA_Loan_Interest_Rate LoanInterest 
								ON LoanBook.Fin_Code = LoanInterest.FIN_Code

				WHERE  

				   ( LoanInterest.Valid_From<=@LoanMonthBeginning ) And (LoanBook.Finance_Start_Date<=@LoanMonthBeginning)
				--And (@LoanMonthBeginning >=@CutOffDate-1)
				And @CutOffDate-1<=LoanInterest.Valid_To  And @CutOffDate-1 <= LoanBook.Finance_End_Date-1
				AND (LoanBook.Fin_Code=@sFinCode) --and  (LoanBook.Unit_Number=154559)


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
				LoanBook.Fin_Code,
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
							(Case When LH.Finance_End_Date>=@LoanMonthBeginning and LH.Finance_End_Date<=@LoanMonthEnd Then LH.Payout_Amount
												Else 0
							End) Payout_Amount,
							LH.Payout_Date,
							
							(SELECT  PrevMonthAMO.PreBalance  from
								   (
									SELECT Top 1 Balance as PreBalance, AMO_Month  from #FA_Loan_Amortization
											
									Where Unit_number=LH.Unit_Number 
												And Fin_Code=LH.Fin_Code
												And Finance_Start_Date=LH.Finance_Start_Date
												And AMO_Month<@LoanMonthBeginning
									Order by AMO_Month DESC
									
									) PrevMonthAMO
							) As PreMonthBalance
				        
							
							
				FROM         dbo.FA_Loan_History LH
				Where-- ( LH.Finance_End_Date-1>=@LoanMonthBeginning or  LH.Finance_End_Date is null)  
						(
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
						--and  (LH.Payout_Date is  Null Or LH.Payout_Date >@LoanMonthBeginning)
				)

				 LoanBook 
						INNER JOIN  #FA_Loan_Amortization LA
								ON LoanBook.Unit_Number = LA.Unit_Number And AMO_Month=@LoanMonthBeginning
						INNER JOIN  dbo.FA_Loan_Interest_Rate LoanInterest 
								ON LoanBook.Fin_Code = LoanInterest.FIN_Code

				WHERE  
					
						 (LoanBook.Finance_Start_Date>=@LoanMonthBeginning  And LoanBook.Finance_Start_Date>=LoanInterest.Valid_From)
				AND (LoanBook.Finance_Start_Date<=LoanInterest.Valid_To)
				AND (LoanInterest.Valid_To <= @CutOffDate-1 And LoanInterest.Valid_To <= LoanBook.Finance_End_Date)
				AND (LoanBook.Fin_Code=@sFinCode) --and  (LoanBook.Unit_Number=154559)
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
				LoanBook.Fin_Code,
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
							(Case When LH.Finance_End_Date>=@LoanMonthBeginning and LH.Finance_End_Date<=@LoanMonthEnd Then LH.Payout_Amount
												Else 0
							End) Payout_Amount,
							LH.Payout_Date,
							
							(SELECT  PrevMonthAMO.PreBalance  from
								   (
									SELECT Top 1 Balance as PreBalance, AMO_Month  from #FA_Loan_Amortization
											
									Where Unit_number=LH.Unit_Number 
												And Fin_Code=LH.Fin_Code
												And Finance_Start_Date=LH.Finance_Start_Date
												And AMO_Month<@LoanMonthBeginning
									Order by AMO_Month DESC
									
									) PrevMonthAMO
							) As PreMonthBalance
				        
							
							
				FROM         dbo.FA_Loan_History LH
				Where-- ( LH.Finance_End_Date-1>=@LoanMonthBeginning or  LH.Finance_End_Date is null)  
						(
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
						--and  (LH.Payout_Date is  Null Or LH.Payout_Date >@LoanMonthBeginning)
				)

				 LoanBook 
						INNER JOIN  #FA_Loan_Amortization LA
								ON LoanBook.Unit_Number = LA.Unit_Number And AMO_Month=@LoanMonthBeginning
						INNER JOIN  dbo.FA_Loan_Interest_Rate LoanInterest 
								ON LoanBook.Fin_Code = LoanInterest.FIN_Code

				WHERE  

						(LoanBook.Finance_Start_Date>=@LoanMonthBeginning  And LoanBook.Finance_Start_Date>=LoanInterest.Valid_From) 
				And  ( LoanBook.Finance_End_Date<=LoanInterest.Valid_To And   LoanBook.Finance_End_Date<=@CutOffDate-1)
				AND (LoanBook.Fin_Code=@sFinCode) --and  (LoanBook.Unit_Number=154559)

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
				LoanBook.Fin_Code,
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
							(Case When LH.Finance_End_Date>=@LoanMonthBeginning and LH.Finance_End_Date<=@LoanMonthEnd Then LH.Payout_Amount
												Else 0
							End) Payout_Amount,
							LH.Payout_Date,
							
							(SELECT  PrevMonthAMO.PreBalance  from
								   (
									SELECT Top 1 Balance as PreBalance, AMO_Month  from #FA_Loan_Amortization
											
									Where Unit_number=LH.Unit_Number 
												And Fin_Code=LH.Fin_Code
												And Finance_Start_Date=LH.Finance_Start_Date
												And AMO_Month<@LoanMonthBeginning
									Order by AMO_Month DESC
									
									) PrevMonthAMO
							) As PreMonthBalance
				        
							
							
				FROM         dbo.FA_Loan_History LH
				Where-- ( LH.Finance_End_Date-1>=@LoanMonthBeginning or  LH.Finance_End_Date is null)  
						(
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
						--and  (LH.Payout_Date is  Null Or LH.Payout_Date >@LoanMonthBeginning)
				)
				 LoanBook 
						INNER JOIN  #FA_Loan_Amortization LA
								ON LoanBook.Unit_Number = LA.Unit_Number And AMO_Month=@LoanMonthBeginning
						INNER JOIN  dbo.FA_Loan_Interest_Rate LoanInterest 
								ON LoanBook.Fin_Code = LoanInterest.FIN_Code

				WHERE  

				   ( LoanBook.Finance_Start_Date>=LoanInterest.Valid_From ) And (LoanBook.Finance_Start_Date>=@LoanMonthBeginning )
				And (LoanBook.Finance_Start_Date <=@CutOffDate-1)
				And @CutOffDate-1<=LoanInterest.Valid_To  --And LoanInterest.Valid_To <= LoanBook.Finance_End_Date-1
				AND (LoanBook.Fin_Code=@sFinCode) --and  (LoanBook.Unit_Number=154559)



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
				LoanBook.Fin_Code,
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
							(Case When LH.Finance_End_Date>=@LoanMonthBeginning and LH.Finance_End_Date<=@LoanMonthEnd Then LH.Payout_Amount
												Else 0
							End) Payout_Amount,
							LH.Payout_Date,
							
							(SELECT  PrevMonthAMO.PreBalance  from
								   (
									SELECT Top 1 Balance as PreBalance, AMO_Month  from #FA_Loan_Amortization
											
									Where Unit_number=LH.Unit_Number 
												And Fin_Code=LH.Fin_Code
												And Finance_Start_Date=LH.Finance_Start_Date
												And AMO_Month<@LoanMonthBeginning
									Order by AMO_Month DESC
									
									) PrevMonthAMO
							) As PreMonthBalance
				        
							
							
				FROM         dbo.FA_Loan_History LH
				Where-- ( LH.Finance_End_Date-1>=@LoanMonthBeginning or  LH.Finance_End_Date is null)  
						(
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
						--and  (LH.Payout_Date is  Null Or LH.Payout_Date >@LoanMonthBeginning)
				)
				 LoanBook 
						INNER JOIN  #FA_Loan_Amortization LA
								ON LoanBook.Unit_Number = LA.Unit_Number And AMO_Month=@LoanMonthBeginning
						INNER JOIN  dbo.FA_Loan_Interest_Rate LoanInterest 
								ON LoanBook.Fin_Code = LoanInterest.FIN_Code

				WHERE  

    					(LoanBook.Finance_Start_Date<=LoanInterest.Valid_From  AND @LoanMonthBeginning <= LoanInterest.Valid_From)
				And (LoanInterest.Valid_To <= @CutOffDate-1 And LoanInterest.Valid_To<=LoanBook.Finance_End_Date-1)
				AND (LoanBook.Fin_Code=@sFinCode) --and  (LoanBook.Unit_Number=154559)


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
				LoanBook.Fin_Code,
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
							(Case When LH.Finance_End_Date>=@LoanMonthBeginning and LH.Finance_End_Date<=@LoanMonthEnd Then LH.Payout_Amount
												Else 0
							End) Payout_Amount,
							LH.Payout_Date,
							
							(SELECT  PrevMonthAMO.PreBalance  from
								   (
									SELECT Top 1 Balance as PreBalance, AMO_Month  from #FA_Loan_Amortization
											
									Where Unit_number=LH.Unit_Number 
												And Fin_Code=LH.Fin_Code
												And Finance_Start_Date=LH.Finance_Start_Date
												And AMO_Month<@LoanMonthBeginning
									Order by AMO_Month DESC
									
									) PrevMonthAMO
							) As PreMonthBalance
				        
							
							
				FROM         dbo.FA_Loan_History LH
				Where-- ( LH.Finance_End_Date-1>=@LoanMonthBeginning or  LH.Finance_End_Date is null)  
						(
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
						--and  (LH.Payout_Date is  Null Or LH.Payout_Date >@LoanMonthBeginning)
				)
				 LoanBook 
						INNER JOIN  #FA_Loan_Amortization LA
								ON LoanBook.Unit_Number = LA.Unit_Number And AMO_Month=@LoanMonthBeginning
						INNER JOIN  dbo.FA_Loan_Interest_Rate LoanInterest 
								ON LoanBook.Fin_Code = LoanInterest.FIN_Code

				WHERE  

    					(LoanBook.Finance_Start_Date<=LoanInterest.Valid_From  AND @LoanMonthBeginning <= LoanInterest.Valid_From)
				And  (LoanBook.Finance_End_Date-1>=LoanInterest.Valid_From)
				And (LoanBook.Finance_End_Date-1 <= @CutOffDate-1 And  LoanBook.Finance_End_Date-1<=LoanInterest.Valid_To)
				AND (LoanBook.Fin_Code=@sFinCode) --and  (LoanBook.Unit_Number=154559)

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
				LoanBook.Fin_Code,
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
							(Case When LH.Finance_End_Date>=@LoanMonthBeginning and LH.Finance_End_Date<=@LoanMonthEnd Then LH.Payout_Amount
												Else 0
							End) Payout_Amount,
							LH.Payout_Date,
							
							(SELECT  PrevMonthAMO.PreBalance  from
								   (
									SELECT Top 1 Balance as PreBalance, AMO_Month  from #FA_Loan_Amortization
											
									Where Unit_number=LH.Unit_Number 
												And Fin_Code=LH.Fin_Code
												And Finance_Start_Date=LH.Finance_Start_Date
												And AMO_Month<@LoanMonthBeginning
									Order by AMO_Month DESC
									
									) PrevMonthAMO
							) As PreMonthBalance
				        
							
							
				FROM         dbo.FA_Loan_History LH
				Where-- ( LH.Finance_End_Date-1>=@LoanMonthBeginning or  LH.Finance_End_Date is null)  
						(
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
						--and  (LH.Payout_Date is  Null Or LH.Payout_Date >@LoanMonthBeginning)
				)

				 LoanBook 
						INNER JOIN  #FA_Loan_Amortization LA
								ON LoanBook.Unit_Number = LA.Unit_Number And AMO_Month=@LoanMonthBeginning
						INNER JOIN  dbo.FA_Loan_Interest_Rate LoanInterest 
								ON LoanBook.Fin_Code = LoanInterest.FIN_Code
				WHERE  

    					(LoanBook.Finance_Start_Date<=LoanInterest.Valid_From  AND @LoanMonthBeginning <= LoanInterest.Valid_From)
				And  (@CutOffDate-1>=LoanInterest.Valid_From)
				And (@CutOffDate-1 <=LoanBook.Finance_End_Date-1  And   @CutOffDate-1<=LoanInterest.Valid_To)
				AND (LoanBook.Fin_Code=@sFinCode) --and  (LoanBook.Unit_Number=154559)

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
				LoanBook.Fin_Code,
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
							(Case When LH.Finance_End_Date>=@LoanMonthBeginning and LH.Finance_End_Date<=@LoanMonthEnd Then LH.Payout_Amount
												Else 0
							End) Payout_Amount,
							LH.Payout_Date,
							
							(SELECT  PrevMonthAMO.PreBalance  from
								   (
									SELECT Top 1 Balance as PreBalance, AMO_Month  from #FA_Loan_Amortization
											
									Where Unit_number=LH.Unit_Number 
												And Fin_Code=LH.Fin_Code
												And Finance_Start_Date=LH.Finance_Start_Date
												And AMO_Month<@LoanMonthBeginning
									Order by AMO_Month DESC
									
									) PrevMonthAMO
							) As PreMonthBalance
				        
							
							
				FROM         dbo.FA_Loan_History LH
				Where-- ( LH.Finance_End_Date-1>=@LoanMonthBeginning or  LH.Finance_End_Date is null)  
						(
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
						--and  (LH.Payout_Date is  Null Or LH.Payout_Date >@LoanMonthBeginning)
				)

				 LoanBook 
						INNER JOIN  #FA_Loan_Amortization LA
								ON LoanBook.Unit_Number = LA.Unit_Number And AMO_Month=@LoanMonthBeginning
						INNER JOIN  dbo.FA_Loan_Interest_Rate LoanInterest 
								ON LoanBook.Fin_Code = LoanInterest.FIN_Code

				WHERE  
				--B1	MB/IB/CU	FB	IE	  ME/FE
					
						 (LoanBook.Finance_Start_Date>=@CutOffDate  And LoanBook.Finance_Start_Date>=LoanInterest.Valid_From)
				AND (LoanBook.Finance_Start_Date<=LoanInterest.Valid_To)
				AND (LoanInterest.Valid_To <= @LoanMonthEnd And LoanInterest.Valid_To <= LoanBook.Finance_End_Date)
				AND (LoanBook.Fin_Code=@sFinCode) --and  (LoanBook.Unit_Number=154559)


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
				LoanBook.Fin_Code,
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
							(Case When LH.Finance_End_Date>=@LoanMonthBeginning and LH.Finance_End_Date<=@LoanMonthEnd Then LH.Payout_Amount
												Else 0
							End) Payout_Amount,
							LH.Payout_Date,
							
							(SELECT  PrevMonthAMO.PreBalance  from
								   (
									SELECT Top 1 Balance as PreBalance, AMO_Month  from #FA_Loan_Amortization
											
									Where Unit_number=LH.Unit_Number 
												And Fin_Code=LH.Fin_Code
												And Finance_Start_Date=LH.Finance_Start_Date
												And AMO_Month<@LoanMonthBeginning
									Order by AMO_Month DESC
									
									) PrevMonthAMO
							) As PreMonthBalance
				        
							
							
				FROM         dbo.FA_Loan_History LH
				Where-- ( LH.Finance_End_Date-1>=@LoanMonthBeginning or  LH.Finance_End_Date is null)  
						(
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
						--and  (LH.Payout_Date is  Null Or LH.Payout_Date >@LoanMonthBeginning)
				)
				LoanBook 
						INNER JOIN  #FA_Loan_Amortization LA
								ON LoanBook.Unit_Number = LA.Unit_Number And AMO_Month=@LoanMonthBeginning
						INNER JOIN  dbo.FA_Loan_Interest_Rate LoanInterest 
								ON LoanBook.Fin_Code = LoanInterest.FIN_Code

				WHERE  
				--B2	MB/IB/CU	FB	ME	IE/FE

						 (LoanBook.Finance_Start_Date>=@CutOffDate  And LoanBook.Finance_Start_Date>=LoanInterest.Valid_From)
				AND (LoanBook.Finance_Start_Date<=@LoanMonthEnd)
				AND (@LoanMonthEnd <= LoanInterest.Valid_To And @LoanMonthEnd <= LoanBook.Finance_End_Date)
				AND (LoanBook.Fin_Code=@sFinCode) --and  (LoanBook.Unit_Number=154559)


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
				LoanBook.Fin_Code,
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
							(Case When LH.Finance_End_Date>=@LoanMonthBeginning and LH.Finance_End_Date<=@LoanMonthEnd Then LH.Payout_Amount
												Else 0
							End) Payout_Amount,
							LH.Payout_Date,
							
						  (SELECT  PrevMonthAMO.PreBalance  from
								   (
									SELECT Top 1 Balance as PreBalance, AMO_Month  from #FA_Loan_Amortization
											
									Where Unit_number=LH.Unit_Number 
												And Fin_Code=LH.Fin_Code
												And Finance_Start_Date=LH.Finance_Start_Date
												And AMO_Month<@LoanMonthBeginning
									Order by AMO_Month DESC
									
									) PrevMonthAMO
							) As PreMonthBalance
				        
							
							
				FROM         dbo.FA_Loan_History LH
				Where-- ( LH.Finance_End_Date-1>=@LoanMonthBeginning or  LH.Finance_End_Date is null)  
						(
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
						--and  (LH.Payout_Date is  Null Or LH.Payout_Date >@LoanMonthBeginning)
				)
				 LoanBook 
						INNER JOIN  #FA_Loan_Amortization LA
								ON LoanBook.Unit_Number = LA.Unit_Number And AMO_Month=@LoanMonthBeginning
						INNER JOIN  dbo.FA_Loan_Interest_Rate LoanInterest 
								ON LoanBook.Fin_Code = LoanInterest.FIN_Code

				WHERE  
				-- In this case the Loan is with one Month
				--B3	MB/IB/CU	FB	FE	IE/ME
						 (LoanBook.Finance_Start_Date>=@CutOffDate  And LoanBook.Finance_Start_Date>=LoanInterest.Valid_From)
				--AND (LoanBook.Finance_Start_Date<=@LoanMonthEnd)
				AND ( LoanBook.Finance_End_Date <= LoanInterest.Valid_To And  LoanBook.Finance_End_Date <= @LoanMonthEnd)
				AND (LoanBook.Fin_Code=@sFinCode) --and  (LoanBook.Unit_Number=154559)



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
				LoanBook.Fin_Code,
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
							(Case When LH.Finance_End_Date>=@LoanMonthBeginning and LH.Finance_End_Date<=@LoanMonthEnd Then LH.Payout_Amount
												Else 0
							End) Payout_Amount,
							LH.Payout_Date,
							
							(SELECT  PrevMonthAMO.PreBalance  from
								   (
									SELECT Top 1 Balance as PreBalance, AMO_Month  from #FA_Loan_Amortization
											
									Where Unit_number=LH.Unit_Number 
												And Fin_Code=LH.Fin_Code
												And Finance_Start_Date=LH.Finance_Start_Date
												And AMO_Month<@LoanMonthBeginning
									Order by AMO_Month DESC
									
									) PrevMonthAMO
							) As PreMonthBalance
							
							
				FROM         dbo.FA_Loan_History LH
				Where-- ( LH.Finance_End_Date-1>=@LoanMonthBeginning or  LH.Finance_End_Date is null)  
						(
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
						--and  (LH.Payout_Date is  Null Or LH.Payout_Date >@LoanMonthBeginning)
				)
				 LoanBook 
						INNER JOIN  #FA_Loan_Amortization LA
								ON LoanBook.Unit_Number = LA.Unit_Number And AMO_Month=@LoanMonthBeginning
						INNER JOIN  dbo.FA_Loan_Interest_Rate LoanInterest 
								ON LoanBook.Fin_Code = LoanInterest.FIN_Code

				WHERE  

				--B4	MB/FB/CU	IB 	IE	 FE/ME
						 (LoanInterest.Valid_From>=@CutOffDate  And LoanInterest.Valid_From>=LoanBook.Finance_Start_Date)
				--AND (LoanInterest.Valid_From<=LoanInterest.Valid_To )
				AND ( LoanInterest.Valid_To <=LoanBook.Finance_Start_Date And  LoanInterest.Valid_To  <= @LoanMonthEnd)
				AND (LoanBook.Fin_Code=@sFinCode) --and  (LoanBook.Unit_Number=154559)


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
				LoanBook.Fin_Code,
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
							(Case When LH.Finance_End_Date>=@LoanMonthBeginning and LH.Finance_End_Date<=@LoanMonthEnd Then LH.Payout_Amount
												Else 0
							End) Payout_Amount,
							LH.Payout_Date,
							
							(SELECT  PrevMonthAMO.PreBalance  from
								   (
									SELECT Top 1 Balance as PreBalance, AMO_Month  from #FA_Loan_Amortization
											
									Where Unit_number=LH.Unit_Number 
												And Fin_Code=LH.Fin_Code
												And Finance_Start_Date=LH.Finance_Start_Date
												And AMO_Month<@LoanMonthBeginning
									Order by AMO_Month DESC
									
									) PrevMonthAMO
							) As PreMonthBalance
				        
							
							
				FROM         dbo.FA_Loan_History LH
				Where-- ( LH.Finance_End_Date-1>=@LoanMonthBeginning or  LH.Finance_End_Date is null)  
						(
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
						--and  (LH.Payout_Date is  Null Or LH.Payout_Date >@LoanMonthBeginning)
				)
				 LoanBook 
						INNER JOIN  #FA_Loan_Amortization LA
								ON LoanBook.Unit_Number = LA.Unit_Number And AMO_Month=@LoanMonthBeginning
						INNER JOIN  dbo.FA_Loan_Interest_Rate LoanInterest 
								ON LoanBook.Fin_Code = LoanInterest.FIN_Code

				WHERE  

				--B5	MB/FB/CU	IB 	ME	IE/FE
						 (LoanInterest.Valid_From>=@CutOffDate  And LoanInterest.Valid_From>=LoanBook.Finance_Start_Date)
				AND (LoanInterest.Valid_From <=@LoanMonthEnd)
				AND ( @LoanMonthEnd <=LoanBook.Finance_End_Date And  @LoanMonthEnd  <= LoanInterest.Valid_To )
				AND (LoanBook.Fin_Code=@sFinCode) --and  (LoanBook.Unit_Number=154559)


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
				LoanBook.Fin_Code,
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
							(Case When LH.Finance_End_Date>=@LoanMonthBeginning and LH.Finance_End_Date<=@LoanMonthEnd Then LH.Payout_Amount
												Else 0
							End) Payout_Amount,
							LH.Payout_Date,
							
							(SELECT  PrevMonthAMO.PreBalance  from
								   (
									SELECT Top 1 Balance as PreBalance, AMO_Month  from #FA_Loan_Amortization
											
									Where Unit_number=LH.Unit_Number 
												And Fin_Code=LH.Fin_Code
												And Finance_Start_Date=LH.Finance_Start_Date
												And AMO_Month<@LoanMonthBeginning
									Order by AMO_Month DESC
									
									) PrevMonthAMO
							) As PreMonthBalance
				        
							
							
				FROM         dbo.FA_Loan_History LH
				Where-- ( LH.Finance_End_Date-1>=@LoanMonthBeginning or  LH.Finance_End_Date is null)  
						(
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
						--and  (LH.Payout_Date is  Null Or LH.Payout_Date >@LoanMonthBeginning)
				)
				 LoanBook 
						INNER JOIN  #FA_Loan_Amortization LA
								ON LoanBook.Unit_Number = LA.Unit_Number And AMO_Month=@LoanMonthBeginning
						INNER JOIN  dbo.FA_Loan_Interest_Rate LoanInterest 
								ON LoanBook.Fin_Code = LoanInterest.FIN_Code

				WHERE  

				--B6	MB/FB/CU	IB 	FE	IE/ME
						 (LoanInterest.Valid_From>=@CutOffDate  And LoanInterest.Valid_From>=LoanBook.Finance_Start_Date)
				AND (LoanInterest.Valid_From <=LoanBook.Finance_End_Date)
				AND ( LoanBook.Finance_End_Date <=@LoanMonthEnd  And  LoanBook.Finance_End_Date <= LoanInterest.Valid_To )
				AND (LoanBook.Fin_Code=@sFinCode) --and  (LoanBook.Unit_Number=154559)


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
				LoanBook.Fin_Code,
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
							(Case When LH.Finance_End_Date>=@LoanMonthBeginning and LH.Finance_End_Date<=@LoanMonthEnd Then LH.Payout_Amount
												Else 0

							End) Payout_Amount,
							LH.Payout_Date,
							
							(SELECT  PrevMonthAMO.PreBalance  from
								   (
									SELECT Top 1 Balance as PreBalance, AMO_Month  from #FA_Loan_Amortization
											
									Where Unit_number=LH.Unit_Number 
												And Fin_Code=LH.Fin_Code
												And Finance_Start_Date=LH.Finance_Start_Date
												And AMO_Month<@LoanMonthBeginning
									Order by AMO_Month DESC
									
									) PrevMonthAMO
							) As PreMonthBalance
				        
							
							
				FROM         dbo.FA_Loan_History LH
				Where-- ( LH.Finance_End_Date-1>=@LoanMonthBeginning or  LH.Finance_End_Date is null)  
						(
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
						--and  (LH.Payout_Date is  Null Or LH.Payout_Date >@LoanMonthBeginning)
				)

				 LoanBook 
						INNER JOIN  #FA_Loan_Amortization LA
								ON LoanBook.Unit_Number = LA.Unit_Number And AMO_Month=@LoanMonthBeginning
						INNER JOIN  dbo.FA_Loan_Interest_Rate LoanInterest 
								ON LoanBook.Fin_Code = LoanInterest.FIN_Code
				WHERE  

				--B7	MB/IB/FB	CU	IE	 FE/ME
						 (@CutOffDate>=LoanBook.Finance_Start_Date  And @CutOffDate>=LoanInterest.Valid_From)
				AND (@CutOffDate<=LoanInterest.Valid_To)
				AND ( LoanInterest.Valid_To<=LoanBook.Finance_End_Date   And  LoanInterest.Valid_To <= @LoanMonthEnd )
				AND (LoanBook.Fin_Code=@sFinCode) --and  (LoanBook.Unit_Number=154559)



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
				LoanBook.Fin_Code,
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
							(Case When LH.Finance_End_Date>=@LoanMonthBeginning and LH.Finance_End_Date<=@LoanMonthEnd Then LH.Payout_Amount
												Else 0
							End) Payout_Amount,
							LH.Payout_Date,
							
							(SELECT  PrevMonthAMO.PreBalance  from
								   (
									SELECT Top 1 Balance as PreBalance, AMO_Month  from #FA_Loan_Amortization
											
									Where Unit_number=LH.Unit_Number 
												And Fin_Code=LH.Fin_Code
												And Finance_Start_Date=LH.Finance_Start_Date
												And AMO_Month<@LoanMonthBeginning
									Order by AMO_Month DESC
									
									) PrevMonthAMO
							) As PreMonthBalance
				        
							
							
				FROM         dbo.FA_Loan_History LH
				Where-- ( LH.Finance_End_Date-1>=@LoanMonthBeginning or  LH.Finance_End_Date is null)  
						(
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
						--and  (LH.Payout_Date is  Null Or LH.Payout_Date >@LoanMonthBeginning)
				)

				 LoanBook 
						INNER JOIN  #FA_Loan_Amortization LA
								ON LoanBook.Unit_Number = LA.Unit_Number And AMO_Month=@LoanMonthBeginning
						INNER JOIN  dbo.FA_Loan_Interest_Rate LoanInterest 
								ON LoanBook.Fin_Code = LoanInterest.FIN_Code
				WHERE  

				--B8	MB/IB/FB	CU	ME	IE/FE
						 (@CutOffDate>=LoanBook.Finance_Start_Date  And @CutOffDate>=LoanInterest.Valid_From)
				AND (@CutOffDate<=@LoanMonthEnd)
				AND ( @LoanMonthEnd<=LoanBook.Finance_End_Date   And  @LoanMonthEnd<=LoanInterest.Valid_To)
				AND (LoanBook.Fin_Code=@sFinCode) --and  (LoanBook.Unit_Number=154559)



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
				LoanBook.Fin_Code,
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
							(Case When LH.Finance_End_Date>=@LoanMonthBeginning and LH.Finance_End_Date<=@LoanMonthEnd Then LH.Payout_Amount
												Else 0
							End) Payout_Amount,
							LH.Payout_Date,
							
							(SELECT  PrevMonthAMO.PreBalance  from
								   (
									SELECT Top 1 Balance as PreBalance, AMO_Month  from #FA_Loan_Amortization
											
									Where Unit_number=LH.Unit_Number 
												And Fin_Code=LH.Fin_Code
												And Finance_Start_Date=LH.Finance_Start_Date
												And AMO_Month<@LoanMonthBeginning
									Order by AMO_Month DESC
									
									) PrevMonthAMO
							) As PreMonthBalance
				        
							
							
				FROM         dbo.FA_Loan_History LH
				Where-- ( LH.Finance_End_Date-1>=@LoanMonthBeginning or  LH.Finance_End_Date is null)  
						(
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
						--and  (LH.Payout_Date is  Null Or LH.Payout_Date >@LoanMonthBeginning)
				)

				 LoanBook 
						INNER JOIN  #FA_Loan_Amortization LA
								ON LoanBook.Unit_Number = LA.Unit_Number And AMO_Month=@LoanMonthBeginning
						INNER JOIN  dbo.FA_Loan_Interest_Rate LoanInterest 
								ON LoanBook.Fin_Code = LoanInterest.FIN_Code

				WHERE  

				--B9	MB/IB/FB	CU	FE	ME/IE
						 (@CutOffDate>=LoanBook.Finance_Start_Date  And @CutOffDate>=LoanInterest.Valid_From)
				AND (@CutOffDate<=LoanBook.Finance_End_Date)
				AND ( LoanBook.Finance_End_Date<=@LoanMonthEnd   And  LoanBook.Finance_End_Date<=LoanInterest.Valid_To)
				AND (LoanBook.Fin_Code=@sFinCode) --and  (LoanBook.Unit_Number=154559)

			) LoanInterest

			Group by LoanInterest.Unit_Number,  LoanInterest.MB,LoanInterest.Fin_Code, LoanInterest.FB
	)	MonthlyInterest
		INNER JOIN  #FA_Loan_Amortization LAMO
								ON MonthlyInterest.Unit_Number = LAMO.Unit_Number 								
								And MonthlyInterest.MB =LAMO.AMO_Month
								And MonthlyInterest.Fin_code=LAMO.Fin_Code
								And MonthlyInterest.FB=LAMO.Finance_Start_Date

/*
Inner Join FA_Loan_Amortization LoanAmo
On LoanInterest.
*/
If @sMode='C' 
Begin
   
    
	
	Delete 
	--Select * from 
	FA_Loan_Amortization where AMO_Month between @LoanMonthBeginning and @LoanMonthEnd and Fin_Code=@sFinCode
	Insert into FA_Loan_Amortization Select * from #FA_Loan_Amortization where AMO_Month between @LoanMonthBeginning and @LoanMonthEnd
	Declare @iCount Int

    Select @iCount=count(*) from FA_Loan_Month_End Where FA_Month=@LoanMonthBeginning and Fin_Code=@sFinCode
	If @iCount=0
			 Insert into FA_Loan_Month_End  Values(@LoanMonthBeginning, @sFinCode, Getdate())
	Else
             Update FA_Loan_Month_End Set Loan_AMO_Date=getdate() Where FA_Month=@LoanMonthBeginning and Fin_Code=@sFinCode
 
		
End

Else
		If @sMode='V' 
			--Select * from #FA_Loan_Amortization where AMO_Month between @LoanMonthBeginning and @LoanMonthEnd	Order by Unit_Number
		 
			  SELECT       V.Unit_Number, V.Serial_Number, LoanBook.Finance_Start_Date, LoanBook.Finance_End_Date, LoanBook.Loan_Amount, LoanBook.PreMonthBalance, LoanBook.Payout_Amount, 
								  LOANAMO.Principle_Amount, LOANAMO.Balance, LOANAMO.Interest_Amount, LoanBook.Trans_Month,
								   (Case When PaidInterest is Not NULL Then PaidInterest Else 0 End ) As PaidInterest, (Case When PaidInterest is Not NULL Then PaidInterest Else 0 End ) +LOANAMO.Interest_Amount as InterestToDate
													

								FROM         #FA_Loan_Amortization LOANAMO INNER JOIN
													dbo.Vehicle V ON LOANAMO.Unit_Number = V.Unit_Number INNER JOIN
            										(
														SELECT   
																	LH.Unit_Number, 
																	LH.Fin_Code, 
																	LH.Principal_Rate_ID, 
																	LH.Override_Principal_Rate,
																	LH.Loan_Amount, 
																	LH.Trans_Month, 
																	LH.Finance_Start_Date, 
																	--LH.Finance_End_Date, 
																	(Case When Finance_End_Date<=@LoanMonthEnd Then LH.Finance_End_Date
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
													 LoanBook ON LOANAMO.Unit_Number = LoanBook.Unit_Number
																  And LOANAMO.Fin_code=LoanBook.Fin_Code
																  And LOANAMO.Finance_Start_Date=LoanBook.Finance_Start_Date
																

										Where LOANAMO.AMO_Month between @LoanMonthBeginning and @LoanMonthEnd
		
 
 
Drop Table #FA_Loan_Amortization
GO
