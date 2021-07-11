USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetOptionalExtraItem]    Script Date: 2021-07-10 1:50:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
--GetLocationInfoByHubID '*','' ,'01 jun 2004 20:00:00'
--exec GetLocationDropOffLocation '16', 'Jun 01 2004'

create PROCEDURE [dbo].[GetOptionalExtraItem]  --'Down* airport office' 
	@UnitNumber varchar(12),
	@OptionalExtraType varchar(20)
AS

Select * from Optional_Extra_Inventory
where Unit_Number = @UnitNumber and Optional_Extra_Type = @OptionalExtraType
GO
