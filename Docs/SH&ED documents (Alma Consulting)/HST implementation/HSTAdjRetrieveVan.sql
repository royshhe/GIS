-- Retrieve the data
Select distinct Contract_number from business_transaction where Business_Transaction_ID in 
(
select Business_Transaction_ID from Sales_Journal
		WHERE     (Business_Transaction_ID IN
								  (

									SELECT     dbo.Business_Transaction.Business_Transaction_ID
									FROM         dbo.Business_Transaction INNER JOIN
														  dbo.Contract ON dbo.Business_Transaction.Contract_Number = dbo.Contract.Contract_Number
									WHERE    (   
														(dbo.Contract.Pick_Up_On >= '2010-07-01') 
														OR
														   (  
																	(dbo.Contract.Pick_Up_On < '2010-07-01') AND (dbo.Contract.Drop_Off_On >= '2010-08-01')
															 )
													 )
													And
                                                   (dbo.Business_Transaction.RBR_Date=(select max(RBR_DAte) from RBR_Date where Budget_Close_Datetime is not null))
								)
							)
		And (GL_Account in ('72852012',  '72851012', '72851011', '72852011')) and Amount<0

)


select  GL_Account, Amount NetAmountOld,  Round(Round(Amount*1.12,2)/1.05,2) as NetAmount, (Round(Round(Amount*1.12,2)/1.05,2) -Amount)*(-1) as HSTAdj  from Sales_Journal
WHERE     (Business_Transaction_ID IN
                          (

							SELECT     dbo.Business_Transaction.Business_Transaction_ID
							FROM         dbo.Business_Transaction INNER JOIN
												  dbo.Contract ON dbo.Business_Transaction.Contract_Number = dbo.Contract.Contract_Number
							WHERE    (   
														(dbo.Contract.Pick_Up_On >= '2010-07-01') 
														OR
														   (  
																	(dbo.Contract.Pick_Up_On < '2010-07-01') AND (dbo.Contract.Drop_Off_On >= '2010-08-01')
															 )
													 )
													And
                                                   (dbo.Business_Transaction.RBR_Date=(select max(RBR_DAte) from RBR_Date where Budget_Close_Datetime is not null))
						)
					)
And (GL_Account in ('72852012',  '72851012', '72851011', '72852011')) and Amount<0


-- Check Final Sales Journal


SELECT bt.Contract_Number,	sj.business_transaction_id
  FROM	sales_journal sj
  JOIN	business_transaction bt
    ON	bt.business_transaction_id = sj.business_transaction_id
 WHERE	bt.rbr_date = (select max(RBR_DAte)-1 from RBR_Date where Budget_Close_Datetime is not null)
 GROUP
    BY	bt.Contract_Number,sj.business_transaction_id
HAVING	SUM(sj.amount) != 0



select  *  from Sales_Journal
WHERE     (Business_Transaction_ID IN
                          (

							SELECT     dbo.Business_Transaction.Business_Transaction_ID
							FROM         dbo.Business_Transaction INNER JOIN
												  dbo.Contract ON dbo.Business_Transaction.Contract_Number = dbo.Contract.Contract_Number
							WHERE   (   
														(dbo.Contract.Pick_Up_On >= '2010-07-01') 
														OR
														   (  
																	(dbo.Contract.Pick_Up_On < '2010-07-01') AND (dbo.Contract.Drop_Off_On >= '2010-08-01')
															 )
													 )
													And
                                                   (dbo.Business_Transaction.RBR_Date=(select max(RBR_DAte) from RBR_Date where Budget_Close_Datetime is not null))
						)
					)
And (GL_Account in('72852012',  '72851012', '72851011', '72852011'))

