USE [GISData]
GO
/****** Object:  Table [dbo].[Vehicle_RiskType_History]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vehicle_RiskType_History](
	[Unit_Number] [int] NOT NULL,
	[Risk_Type] [char](1) NULL,
	[Effective_On] [datetime] NOT NULL,
	[Last_Update_By] [varchar](20) NULL,
 CONSTRAINT [PK_Vehicle_RiskType_History] PRIMARY KEY CLUSTERED 
(
	[Unit_Number] ASC,
	[Effective_On] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
