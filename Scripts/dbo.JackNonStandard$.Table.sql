USE [GISData]
GO
/****** Object:  Table [dbo].[JackNonStandard$]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JackNonStandard$](
	[ARC#] [nvarchar](255) NULL,
	[TRAVEL AGENCY NAME] [nvarchar](255) NULL,
	[*  PREFERRED SUPPLIER] [nvarchar](255) NULL,
	[COMMISSION %] [float] NULL,
	[COMMENTS] [nvarchar](255) NULL,
	[Additional Comments ] [nvarchar](255) NULL,
	[F7] [nvarchar](255) NULL
) ON [PRIMARY]
GO
