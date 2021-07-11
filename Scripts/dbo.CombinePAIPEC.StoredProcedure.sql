USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[CombinePAIPEC]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[CombinePAIPEC]
as
Delete dbo.Reserved_Rental_Accessory
--Select * from dbo.Reserved_Rental_Accessory
Where Confirmation_Number in

(
		SELECT     rsa.Confirmation_Number--, rsa.Optional_Extra_ID, rsa.Quantity
		FROM         dbo.Reserved_Rental_Accessory AS rsa INNER JOIN
							  dbo.Reservation AS res ON rsa.Confirmation_Number = res.Confirmation_Number
		WHERE     (res.Status = 'A') AND (rsa.Optional_Extra_ID = 20)
		and rsa.Confirmation_Number not in 
		(SELECT     rsa.Confirmation_Number
			FROM         dbo.Reserved_Rental_Accessory AS rsa INNER JOIN
								  dbo.Reservation AS res ON rsa.Confirmation_Number = res.Confirmation_Number
			WHERE     (res.Status = 'A') AND (rsa.Optional_Extra_ID = 21)
		                      
		 )
		 
		 union
		 
		 
		 SELECT     rsa.Confirmation_Number--, rsa.Optional_Extra_ID, rsa.Quantity
		FROM         dbo.Reserved_Rental_Accessory AS rsa INNER JOIN
							  dbo.Reservation AS res ON rsa.Confirmation_Number = res.Confirmation_Number
		WHERE     (res.Status = 'A') AND (rsa.Optional_Extra_ID = 21)
		and rsa.Confirmation_Number not in 
		(SELECT     rsa.Confirmation_Number
			FROM         dbo.Reserved_Rental_Accessory AS rsa INNER JOIN
								  dbo.Reservation AS res ON rsa.Confirmation_Number = res.Confirmation_Number
			WHERE     (res.Status = 'A') AND (rsa.Optional_Extra_ID = 20)
		                      
		 )
 
)    
And  Optional_Extra_ID in (20,21)   


--Remove PEC
Delete   Reserved_Rental_Accessory 
--SELECT     rsa.Confirmation_Number, rsa.Optional_Extra_ID, rsa.Quantity
FROM         dbo.Reserved_Rental_Accessory AS rsa INNER JOIN
							  dbo.Reservation AS res ON rsa.Confirmation_Number = res.Confirmation_Number
		WHERE     (res.Status = 'A') AND (rsa.Optional_Extra_ID = 21)

Update  Reserved_Rental_Accessory Set Optional_Extra_ID=241
--SELECT     rsa.Confirmation_Number, rsa.Optional_Extra_ID, rsa.Quantity
FROM         dbo.Reserved_Rental_Accessory AS rsa INNER JOIN
							  dbo.Reservation AS res ON rsa.Confirmation_Number = res.Confirmation_Number
		WHERE     (res.Status = 'A') AND (rsa.Optional_Extra_ID = 20)


		
		
		             
                      
--Select * from Optional_Extra

--Optional_Extra_ID
--20 PAI
--21 PEC


--Select * from dbo.Contract_Optional_Extra 
Delete Contract_Optional_Extra
where Contract_Number in
(
	SELECT     coe.Contract_Number--, coe.Optional_Extra_ID, coe.Termination_Date, con.Status
	FROM         dbo.Contract AS con INNER JOIN
						  dbo.Contract_Optional_Extra AS coe ON con.Contract_Number = coe.Contract_Number
	Where    con.Status='OP' and  coe.Optional_Extra_ID=20      
			and  coe.Contract_Number not in   
			(
			SELECT     coe.Contract_Number--, coe.Optional_Extra_ID, coe.Termination_Date, con.Status
			FROM         dbo.Contract AS con INNER JOIN
								  dbo.Contract_Optional_Extra AS coe ON con.Contract_Number = coe.Contract_Number
			Where    con.Status='OP' and  coe.Optional_Extra_ID=21  
			) 
	union


	SELECT     coe.Contract_Number--, coe.Optional_Extra_ID, coe.Termination_Date, con.Status
	FROM         dbo.Contract AS con INNER JOIN
						  dbo.Contract_Optional_Extra AS coe ON con.Contract_Number = coe.Contract_Number
	Where    con.Status='OP' and  coe.Optional_Extra_ID=21      
			and  coe.Contract_Number not in   
			(
			SELECT     coe.Contract_Number--, coe.Optional_Extra_ID, coe.Termination_Date, con.Status
			FROM         dbo.Contract AS con INNER JOIN
								  dbo.Contract_Optional_Extra AS coe ON con.Contract_Number = coe.Contract_Number
			Where    con.Status='OP' and  coe.Optional_Extra_ID=20  
			) 
) 

And  Optional_Extra_ID in (20,21)    


Delete Contract_Optional_Extra 
FROM         dbo.Contract AS con INNER JOIN
						  dbo.Contract_Optional_Extra AS coe ON con.Contract_Number = coe.Contract_Number
Where    con.Status='OP' and  coe.Optional_Extra_ID=21      

Update Contract_Optional_Extra Set Optional_Extra_ID= 241  

--SELECT     coe.Contract_Number , coe.Optional_Extra_ID, coe.Termination_Date, con.Status
	FROM         dbo.Contract AS con INNER JOIN
						  dbo.Contract_Optional_Extra AS coe ON con.Contract_Number = coe.Contract_Number
	Where    con.Status='OP' and  coe.Optional_Extra_ID=20  
GO
