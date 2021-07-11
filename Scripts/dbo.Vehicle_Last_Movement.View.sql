USE [GISData]
GO
/****** Object:  View [dbo].[Vehicle_Last_Movement]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


/* View created for update status to get the last movement time of all vehicle
    Kenneth Wong - Jan 19, 2006 - CREATED
*/

CREATE VIEW [dbo].[Vehicle_Last_Movement] AS
SELECT MAX(VM.Date_In) AS Last_Move_Time, VM.Unit_Number As Unit_number FROM
(SELECT     Movement_In as Date_in, Unit_Number
FROM         dbo.Vehicle_Movement
UNION
SELECT Actual_Check_In as Date_in, Unit_Number
FROM	 vehicle_on_contract) VM Group By VM.Unit_Number



GO
