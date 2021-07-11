USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_CON_14_Open_Contracts]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RP_SP_CON_14_Open_Contracts]
AS
SELECT dbo.Contract.Contract_Number, dbo.Contract.Pick_Up_On, dbo.Location.Location, 
			  dbo.Contract.Drop_Off_On, dbo.Vehicle_Class.Vehicle_Class_Name, 
              dbo.Business_Transaction.Transaction_Date ,                
              dbo.Business_Transaction.User_ID, dbo.Reservation.Fastbreak_Indicator, 
               dbo.Reservation.Program_Number

               
FROM  dbo.Contract 
INNER JOIN dbo.Location 
        ON dbo.Contract.Pick_Up_Location_ID = dbo.Location.Location_ID 
INNER JOIN dbo.Vehicle_Class 
		ON dbo.Contract.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code 
INNER JOIN dbo.Business_Transaction 
		ON dbo.Contract.Contract_Number = dbo.Business_Transaction.Contract_Number
		   And dbo.Business_Transaction.transaction_description='open'
Left Join dbo.Reservation ON dbo.Contract.confirmation_number=dbo.Reservation.confirmation_number
WHERE (dbo.Contract.Status = 'op')
 
order by dbo.Location.Location, dbo.Contract.Pick_Up_On
GO
