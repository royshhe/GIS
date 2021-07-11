USE [GISData]
GO
/****** Object:  Table [dbo].[FA_Vehicle_Depreciation_History]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FA_Vehicle_Depreciation_History](
	[Unit_Number] [int] NOT NULL,
	[Depreciation_Start_Date] [datetime] NOT NULL,
	[Depreciation_End_Date] [datetime] NULL,
	[Depreciation_Rate_Amount] [decimal](9, 2) NULL,
	[Depreciation_Rate_Percentage] [decimal](9, 5) NULL,
	[Last_Update_On] [datetime] NULL,
 CONSTRAINT [PK_FA_Vehicle_Depreciation_History] PRIMARY KEY CLUSTERED 
(
	[Unit_Number] ASC,
	[Depreciation_Start_Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
