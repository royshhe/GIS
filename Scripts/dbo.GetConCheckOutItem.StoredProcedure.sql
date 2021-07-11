USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[GetConCheckOutItem]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[GetConCheckOutItem]	 --  59, '1001'
	@OptionalExtraID Varchar(20),
	@UnitNum Varchar(20) 
	 
AS
DECLARE @iUnitNum Int
DECLARE @iOptionalExtraID Int

Select @UnitNum=  NULLIF(@UnitNum,'') 
Select @iOptionalExtraID=Convert(Int, NULLIF(@OptionalExtraID,''))

print @iOptionalExtraID

print @iUnitNum

select count(*) from  Optional_Extra_Inventory
where  Optional_Extra_ID=@iOptionalExtraID and unit_number=  @UnitNum

RETURN @@ROWCOUNT
GO
