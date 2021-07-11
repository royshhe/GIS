USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[Sys_MoveRateAvailabilityToProd]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Sys_MoveRateAvailabilityToProd]

as


-- Terminate the current Rate Availability
UPDATE    Rate_Availability
SET              Termination_Date = getdate()
--SELECT    *
--FROM         dbo.Rate_Availability 
where dbo.Rate_Availability.Rate_ID in (select distinct Rate_id from 
                      dbo.Rate_Availability_Input) and Termination_Date>getdate()

-- insert new
Insert into dbo.Rate_Availability
SELECT DISTINCT Rate_ID, GETDATE() AS Effective_Date,    '12/31/2078 11:59:00 PM' AS Termination_Date,  Valid_From, Valid_To from  dbo.Rate_Availability_Input


GO
