USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetAllOptExtraInventoryLocation]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*
PURPOSE: 	To retrieve tables name.
MOD HISTORY:
Name    Date        Comments
*/
create PROCEDURE [dbo].[GetAllOptExtraInventoryLocation]
AS


SELECT * from location
where location_id in(
SELECT     Owning_Location
FROM         Optional_Extra_Inventory
GROUP BY Owning_Location)
GO
