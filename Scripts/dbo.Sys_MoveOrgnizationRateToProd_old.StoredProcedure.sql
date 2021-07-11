USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[Sys_MoveOrgnizationRateToProd_old]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Sys_MoveOrgnizationRateToProd_old]

as




-- Terminate the current Rate Availability
UPDATE    dbo.Organization_Rate
SET              Termination_Date = getdate()
--SELECT     *
--FROM         dbo.Organization_Rate 
where dbo.Organization_Rate.Organization_ID in (select distinct Organization_ID from
                      dbo.Organization_Rate_Input  ) and Termination_Date>getdate()

-- insert new
Insert into dbo.Organization_Rate
SELECT DISTINCT Organization_ID, Rate_ID, GETDATE() AS Effective_Date, Valid_From, Valid_To, Rate_Level,'12/31/2078 11:59:00 PM' AS Termination_Date from  dbo.Organization_Rate_Input


GO
