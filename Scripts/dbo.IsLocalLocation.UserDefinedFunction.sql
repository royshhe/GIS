USE [GISData]
GO
/****** Object:  UserDefinedFunction [dbo].[IsLocalLocation]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- end Cash Deposit

create FUNCTION [dbo].[IsLocalLocation] 
(
  @pIntLocationID smallint
)

RETURNS bit 
AS
BEGIN
 
declare @IsLocalLocation bit

SELECT  @IsLocalLocation=  count(Location_ID) 
FROM         dbo.Lookup_Table INNER JOIN
                      dbo.Location ON dbo.Lookup_Table.Code = dbo.Location.Owning_Company_ID
WHERE     (dbo.Lookup_Table.Category = 'BudgetBC Company') And Location_ID=@pIntLocationID



return @IsLocalLocation


END
GO
