USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetHubMapByHubID]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[GetHubMapByHubID]
@HubID smallint 

AS

SELECT     MapImageName
FROM         dbo.HubMaps
where HubID=@HubID
Return 1
GO
