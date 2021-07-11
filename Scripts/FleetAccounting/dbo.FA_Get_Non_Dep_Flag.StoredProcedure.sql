USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[FA_Get_Non_Dep_Flag]    Script Date: 2021-07-10 1:50:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create Procedure [dbo].[FA_Get_Non_Dep_Flag]
		@RiskType Varchar(10)
As

Select @RiskType=NULLIF(@RiskType,'')
SELECT     Allow_Non_Dep
FROM         dbo.FA_Risk_Type_Non_Dep
Where Risk_Type=@RiskType
GO
