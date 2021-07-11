USE [GISData]
GO
/****** Object:  UserDefinedFunction [dbo].[IsLocalComapy]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[IsLocalComapy] 
(
  @pIntCompanyID smallint
)

RETURNS bit 
AS
BEGIN

declare @LocalCompanyID smallint
declare @IsLocalCompany bit

SELECT    @LocalCompanyID= Convert(smallint,code)
FROM         dbo.Lookup_Table
WHERE     (Category = 'BudgetBC Company')

if @LocalCompanyID<>@pIntCompanyID 
	select @IsLocalCompany=0
else
	select @IsLocalCompany=1

return @IsLocalCompany


END





GO
