USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[Sys_MoveOrganizationRateToProd]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Sys_MoveOrganizationRateToProd]

as




-- Terminate the current Rate Availability
UPDATE    dbo.Organization_Rate
SET              Termination_Date = getdate()

--SELECT distinct    dbo.Organization_Rate.Organization_ID, dbo.Organization_Rate.Rate_ID, dbo.Organization_Rate.Effective_Date, dbo.Organization_Rate.Valid_From, 
--                    dbo.Organization_Rate.Valid_To, dbo.Organization_Rate.Termination_Date, dbo.Organization_Rate.Rate_Level
--select *
FROM         dbo.Organization_Rate rate INNER JOIN vehicle_rate vr on rate.rate_id=vr.rate_id 
                      inner join dbo.Organization_Rate_Input ON Rate.Organization_ID = dbo.Organization_Rate_Input.Organization_ID 

--min and max valid from should be for the org --- need more modification later
-- one time we only load one org
WHERE rate.Termination_Date>GETDATE() --and dbo.Organization_Rate.Valid_From  >=(select min(dbo.Organization_Rate_Input.Valid_from) from dbo.Organization_Rate_Input ) and  dbo.Organization_Rate.Valid_From  <=(select max(dbo.Organization_Rate_Input.Valid_from) from dbo.Organization_Rate_Input )
	and rate.valid_from =dbo.Organization_Rate_Input.valid_from
		and rate.rate_id=dbo.Organization_Rate_Input.rate_id




--SELECT     * FROM         dbo.Organization_Rate 
--FROM         dbo.Organization_Rate 
--where dbo.Organization_Rate.Organization_ID in (select distinct Organization_ID from
--                      dbo.Organization_Rate_Input  ) and Termination_Date>getdate()

-- insert new
Insert into dbo.Organization_Rate

SELECT DISTINCT Organization_ID, Rate_ID, GETDATE() AS Effective_Date, Valid_From, Valid_To, Rate_Level,'12/31/2078 11:59:00 PM' AS Termination_Date,Maestro_Rate_Code as Maestro_Rate  from  dbo.Organization_Rate_Input



GO
