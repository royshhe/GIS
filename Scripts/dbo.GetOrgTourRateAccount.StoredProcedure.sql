USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetOrgTourRateAccount]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[GetOrgTourRateAccount]
	@OrgName varchar(20)
AS
select Top 1 o.Tour_Rate_Account from vehicle_rate v
join
organization_Rate r on v.Rate_ID = r.Rate_ID
join 
organization o on o.organization_ID = r.organization_ID 
where v.Rate_name = @OrgName

GO
