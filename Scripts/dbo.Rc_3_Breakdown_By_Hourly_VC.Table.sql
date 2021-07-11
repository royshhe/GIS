USE [GISData]
GO
/****** Object:  Table [dbo].[Rc_3_Breakdown_By_Hourly_VC]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rc_3_Breakdown_By_Hourly_VC](
	[Expected_Check_In] [datetime] NULL,
	[Expected_Check_In_Date] [datetime] NULL,
	[Expected_Check_In_Hour] [int] NULL,
	[Vehicle_Type_ID] [varchar](30) NULL,
	[Vehicle_Class_Code_Name] [varchar](30) NULL,
	[Expected_Check_In_Location_ID] [int] NULL,
	[Expected_Check_In_Location_Name] [varchar](30) NULL,
	[Contract_Cnt] [int] NULL
) ON [PRIMARY]
GO
