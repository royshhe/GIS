USE [GISData]
GO
/****** Object:  Table [dbo].[Foreign_Vehicle_CI_Log]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Foreign_Vehicle_CI_Log](
	[FI_Log_ID] [int] IDENTITY(1,1) NOT NULL,
	[Foreign_Unit_Number] [varchar](20) NULL,
	[Licence_Plate] [varchar](20) NULL,
	[Model] [varchar](30) NULL,
	[Owning_Company] [varchar](50) NULL,
	[Time_In] [smalldatetime] NULL,
	[KM_In] [int] NULL,
	[Location_In] [varchar](25) NULL,
	[Tank_Level] [char](6) NULL,
	[Condition_Status] [varchar](30) NULL,
	[User_Name] [varchar](50) NULL,
	[Last_Updated_On] [datetime] NULL,
 CONSTRAINT [PK_Foreign_Vehicle_CI_Log] PRIMARY KEY CLUSTERED 
(
	[FI_Log_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
