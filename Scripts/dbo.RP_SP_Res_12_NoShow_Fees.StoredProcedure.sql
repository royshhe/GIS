USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[RP_SP_Res_12_NoShow_Fees]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[RP_SP_Res_12_NoShow_Fees] --'*', '*', '2006-07-01','2006-07-31'
(
	
	@paramVehicleClassID char(1) = '*',
	@paramPickUpLocationID varchar(25) = '*',
	@paramStartBusDate varchar(25) = 'Mar 01 2002',
	@paramEndBusDate varchar(25) = 'Mar 31 2002'
)
as

declare  @StartDate datetime, @EndDate datetime
select  @StartDate=CONVERT(DATETIME, @paramStartBusDate )
select @EndDate=CONVERT(DATETIME, @paramEndBusDate )

-- fix upgrading problem (SQL7->SQL2000)
DECLARE  @tmpLocID varchar(20)

if @paramPickUpLocationID = '*'
	BEGIN
		SELECT @tmpLocID='0'
        END
else
	BEGIN
		SELECT @tmpLocID = @paramPickUpLocationID
	END 
-- end of fixing the problem



SELECT  dbo.Reservation_Dep_Payment.RBR_Date, 
	dbo.Location.Location AS Pick_Up_Location,  
	dbo.Vehicle_Class.Vehicle_Class_Name,
	dbo.Reservation.Confirmation_Number, 
	dbo.Reservation.Foreign_Confirm_Number, 
	dbo.Reservation.First_Name, 
	dbo.Reservation.Last_Name, 
        dbo.Reservation.Pick_Up_On,  
        dbo.Credit_Card_Type.Credit_Card_Type, 
	dbo.Reservation_Dep_Payment.Amount,  
        dbo.Reservation_Dep_Payment.Forfeited, 
	dbo.Reservation_Dep_Payment.Refunded
FROM         dbo.Reservation_CC_Dep_Payment INNER JOIN
                      dbo.Reservation_Dep_Payment ON 
                      dbo.Reservation_CC_Dep_Payment.Confirmation_Number = dbo.Reservation_Dep_Payment.Confirmation_Number AND 
                      dbo.Reservation_CC_Dep_Payment.Collected_On = dbo.Reservation_Dep_Payment.Collected_On INNER JOIN
                      dbo.Credit_Card ON dbo.Reservation_CC_Dep_Payment.Credit_Card_Key = dbo.Credit_Card.Credit_Card_Key INNER JOIN
                      dbo.Reservation ON dbo.Reservation_Dep_Payment.Confirmation_Number = dbo.Reservation.Confirmation_Number INNER JOIN
                      dbo.Credit_Card_Type ON dbo.Credit_Card.Credit_Card_Type_ID = dbo.Credit_Card_Type.Credit_Card_Type_ID INNER JOIN
                      dbo.Location ON dbo.Reservation.Pick_Up_Location_ID = dbo.Location.Location_ID INNER JOIN
                      dbo.Vehicle_Class ON dbo.Reservation.Vehicle_Class_Code = dbo.Vehicle_Class.Vehicle_Class_Code

where   -- Modified to include Local reservation
	--(dbo.Reservation_Dep_Payment.Collected_By = 'no show') 
	--AND 
	dbo.Reservation.Status='N' --and dbo.Reservation_Dep_Payment.Forfeited=1 and dbo.Reservation_Dep_Payment.Refunded=0
	And
	(dbo.Reservation_Dep_Payment.RBR_Date BETWEEN @StartDate AND @EndDate)
	And
 	(@paramVehicleClassID = '*' OR dbo.Reservation.Vehicle_Class_Code = @paramVehicleClassID)
	And
	(@paramPickUpLocationID = '*' or dbo.Reservation.Pick_Up_Location_ID = @tmpLocID)	

   
order by dbo.Reservation_Dep_Payment.RBR_Date,dbo.Location.Location,dbo.Vehicle_Class.Vehicle_Class_Name

GO
