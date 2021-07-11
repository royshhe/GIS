
Insert into Sales_Journal 
select NewSJ.Business_Transaction_ID, NewSJ.Sequence, NewSJ.GL_Account, (Round(Round(SJ.Amount*1.12,2)/1.05,2) -SJ.Amount)*(-1) as Amount  from Sales_Journal SJ
inner join 

(
		select  Business_Transaction_ID,  max( Sequence)+1  as Sequence, '30309000' GL_Account 

		 from Sales_Journal  where  Business_Transaction_ID in 
		(
		select Business_Transaction_ID from Sales_Journal
		WHERE     (Business_Transaction_ID IN
								  (

									SELECT     dbo.Business_Transaction.Business_Transaction_ID
									FROM         dbo.Business_Transaction INNER JOIN
														  dbo.Contract ON dbo.Business_Transaction.Contract_Number = dbo.Contract.Contract_Number
									WHERE  (   
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
		And (GL_Account in ('72852012',  '72851012', '72851011', '72852011'))


		Group by Business_Transaction_ID
) NewSJ
On SJ.Business_Transaction_ID=NewSJ.Business_Transaction_ID

WHERE     (SJ.Business_Transaction_ID IN
                          (

							SELECT     dbo.Business_Transaction.Business_Transaction_ID
							FROM         dbo.Business_Transaction INNER JOIN
												  dbo.Contract ON dbo.Business_Transaction.Contract_Number = dbo.Contract.Contract_Number
							WHERE       (
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
And (SJ.GL_Account in('72852012',  '72851012', '72851011', '72852011')) and SJ.Amount<0


-- Update the New Amount 
--select   Round(Round(Amount*1.12,2)/1.05,2) as NetAmount, (Round(Round(Amount*1.12,2)/1.05,2) -Amount)*(-1) as HSTAdj  from Sales_Journal

Update Sales_Journal Set Amount=Round(Round(Amount*1.12,2)/1.05,2) 
WHERE     (Business_Transaction_ID IN
                          (

						
							SELECT     dbo.Business_Transaction.Business_Transaction_ID
							FROM         dbo.Business_Transaction INNER JOIN
												  dbo.Contract ON dbo.Business_Transaction.Contract_Number = dbo.Contract.Contract_Number
							WHERE       (
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
And (GL_Account in ('72852012',  '72851012', '72851011', '72852011')) and  Amount<0



--ManualAcctgExportStart '05 jul 2010'

 