USE [GISData]
GO
/****** Object:  View [dbo].[RP__Maestro_KMCAP]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[RP__Maestro_KMCAP]
AS
SELECT     dbo.Quoted_Time_Period_Rate.Km_Cap, dbo.Quoted_Vehicle_Rate.Per_KM_Charge, dbo.Reservation.Confirmation_Number
FROM         dbo.Quoted_Vehicle_Rate INNER JOIN
                      dbo.Quoted_Time_Period_Rate ON dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID = dbo.Quoted_Time_Period_Rate.Quoted_Rate_ID INNER JOIN
                      dbo.Reservation ON dbo.Quoted_Vehicle_Rate.Quoted_Rate_ID = dbo.Reservation.Quoted_Rate_ID
WHERE     (dbo.Quoted_Time_Period_Rate.Km_Cap is not null) AND (dbo.Quoted_Time_Period_Rate.Time_Period = 'Day') AND 
                      (dbo.Quoted_Time_Period_Rate.Time_Period_Start = 1)

union

SELECT     dbo.Rate_Time_Period.Km_Cap, dbo.Rate_Vehicle_Class.Per_KM_Charge, dbo.Reservation.Confirmation_Number
                    
FROM         dbo.Reservation INNER JOIN
                      dbo.Rate_Time_Period ON dbo.Reservation.Rate_ID = dbo.Rate_Time_Period.Rate_ID INNER JOIN
                      dbo.Rate_Vehicle_Class ON dbo.Reservation.Rate_ID = dbo.Rate_Vehicle_Class.Rate_ID

where  
       (dbo.Reservation.Date_Rate_Assigned between dbo.Rate_Vehicle_Class.Effective_Date and  dbo.Rate_Vehicle_Class.Termination_Date) and 
       (dbo.Reservation.Date_Rate_Assigned between dbo.Rate_Time_Period.Effective_Date and dbo.Rate_Time_Period.Termination_Date) and 
       dbo.Rate_Time_Period.Time_Period='Day' and  dbo.Rate_Time_Period.Time_Period_Start=1 and Km_Cap is not null
GO
