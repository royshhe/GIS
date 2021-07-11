USE [GISData]
GO
/****** Object:  StoredProcedure [dbo].[Sys_Remove_Old_Loc_VC_Rate_Level]    Script Date: 2021-07-10 1:50:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



Create Procedure [dbo].[Sys_Remove_Old_Loc_VC_Rate_Level]

as

delete Location_Vehicle_Rate_Level
 
WHERE (Valid_To < GETDATE())




GO
