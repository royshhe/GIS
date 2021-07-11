USE [GISData]
GO
/****** Object:  Table [dbo].[Location_Vehicle_Rate_Block]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Location_Vehicle_Rate_Block](
	[Location_VC_Rate_ID] [int] IDENTITY(1,1) NOT NULL,
	[Location_ID] [smallint] NULL,
	[Vehicle_Class_Code] [char](2) NULL,
	[Rate_ID] [int] NOT NULL,
	[Rate_Level] [char](1) NOT NULL,
	[Rate_Type] [varchar](20) NOT NULL,
	[Location_Vehicle_Rate_Type] [varchar](20) NOT NULL,
	[Valid_From] [datetime] NOT NULL,
	[Valid_To] [datetime] NULL,
	[Rate_Selection_Type] [varchar](20) NOT NULL,
 CONSTRAINT [PK_Location_Vehicle_Rate_Block] PRIMARY KEY CLUSTERED 
(
	[Location_VC_Rate_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
