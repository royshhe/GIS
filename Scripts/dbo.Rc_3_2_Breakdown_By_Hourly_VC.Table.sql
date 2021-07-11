USE [GISData]
GO
/****** Object:  Table [dbo].[Rc_3_2_Breakdown_By_Hourly_VC]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rc_3_2_Breakdown_By_Hourly_VC](
	[Source_Code] [varchar](30) NULL,
	[Status] [varchar](1) NULL,
	[Pick_up_on] [datetime] NULL,
	[Pick_up_date] [datetime] NULL,
	[Pick_up_hour] [int] NULL,
	[Vehicle_Type_ID] [varchar](30) NULL,
	[Vehicle_Class_Name] [varchar](30) NULL,
	[Hub_ID] [int] NULL,
	[Hub_Name] [varchar](30) NULL,
	[Owning_Company_ID] [int] NULL,
	[Company_Name] [varchar](30) NULL,
	[Location_ID] [int] NULL,
	[Location_Name] [varchar](30) NULL,
	[Res_cnt] [int] NULL
) ON [PRIMARY]
GO
