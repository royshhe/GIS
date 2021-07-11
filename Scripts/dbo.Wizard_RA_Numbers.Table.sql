USE [GISData]
GO
/****** Object:  Table [dbo].[Wizard_RA_Numbers]    Script Date: 2021-07-10 1:50:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Wizard_RA_Numbers](
	[Wizard_RA_Number] [int] NOT NULL,
	[Contract_Number] [int] NULL,
 CONSTRAINT [PK_Wizard_RA_Numbers] PRIMARY KEY CLUSTERED 
(
	[Wizard_RA_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
