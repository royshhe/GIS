USE [GISData]
GO
/****** Object:  Table [dbo].[Organization_Rate_Input]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Organization_Rate_Input](
	[OrganizationRateID] [int] IDENTITY(1,1) NOT NULL,
	[Organization_ID] [int] NOT NULL,
	[Rate_ID] [int] NOT NULL,
	[Valid_From] [datetime] NOT NULL,
	[Valid_To] [datetime] NULL,
	[Rate_Level] [char](1) NOT NULL,
	[Maestro_Rate_Code] [varchar](50) NULL,
 CONSTRAINT [PK_Organization_Rate_Input] PRIMARY KEY CLUSTERED 
(
	[OrganizationRateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
