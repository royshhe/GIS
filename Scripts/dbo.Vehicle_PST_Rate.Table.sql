USE [GISData]
GO
/****** Object:  Table [dbo].[Vehicle_PST_Rate]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vehicle_PST_Rate](
	[Vehicle_PST_Rate_ID] [int] IDENTITY(1,1) NOT NULL,
	[Vehicle_Starting_Price] [decimal](10, 2) NULL,
	[Vehicle_Ending_Price] [decimal](10, 2) NULL,
	[PST_Rate] [decimal](9, 4) NULL,
	[Valid_From] [datetime] NULL,
	[Valid_To] [datetime] NULL,
 CONSTRAINT [PK_Vehicle_PST_Rate] PRIMARY KEY CLUSTERED 
(
	[Vehicle_PST_Rate_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
