USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_Res_15_OnlineRes_Deposit_Collecting]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[RP_Res_15_OnlineRes_Deposit_Collecting]
as

SELECT    res.Foreign_Confirm_Number, res.Pick_Up_On, loc.Location AS PickupLocation, 
               dbo.Vehicle_Class.Vehicle_Class_Name, res.First_Name, res.Last_Name,   cc.Credit_Card_Type_ID, 
               cc.Credit_Card_Number, cc.Expiry
FROM  dbo.Reservation AS res INNER JOIN
               dbo.Location AS loc ON res.Pick_Up_Location_ID = loc.Location_ID INNER JOIN
               dbo.Vehicle_Class ON res.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code INNER JOIN
               dbo.Credit_Card AS cc ON res.Guarantee_Credit_Card_Key = cc.Credit_Card_Key
WHERE (res.Foreign_Confirm_Number LIKE 'i%') AND (res.Status = 'a')	 and source_code='Internet'
And Res.confirmation_Number not in (select confirmation_number from Reservation_CC_Dep_Payment )

 

--SELECT dbo.Reservation_CC_Dep_Payment.Confirmation_Number, dbo.Reservation_CC_Dep_Payment.Collected_On, dbo.Reservation_CC_Dep_Payment.Sequence, 
--               dbo.Reservation_CC_Dep_Payment.Credit_Card_Key, dbo.Reservation_CC_Dep_Payment.Authorization_Number, 
--               dbo.Reservation_CC_Dep_Payment.Terminal_ID, dbo.Reservation_Dep_Payment.RBR_Date, dbo.Reservation_Dep_Payment.Forfeited, 
--               dbo.Reservation_Dep_Payment.Refunded, dbo.Reservation_Dep_Payment.Amount
--FROM  dbo.Reservation_CC_Dep_Payment INNER JOIN
--               dbo.Reservation_Dep_Payment ON dbo.Reservation_CC_Dep_Payment.Confirmation_Number = dbo.Reservation_Dep_Payment.Confirmation_Number AND 
--               dbo.Reservation_CC_Dep_Payment.Sequence = dbo.Reservation_Dep_Payment.Sequence AND 
--               dbo.Reservation_CC_Dep_Payment.Collected_On = dbo.Reservation_Dep_Payment.Collected_On
               
               
--               select confirmation_number from Reservation_CC_Dep_Payment where confirmation_number=1626732
--               select * from Reservation_Dep_Payment where confirmation_number=1626732
GO
