USE [GISData]
GO
/****** Object:  Table [dbo].[Quoted_Organization_Rate]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Quoted_Organization_Rate](
	[BCD_Number] [char](10) NOT NULL,
	[Vehicle_Class_Code] [nchar](1) NOT NULL,
	[Quoted_Rate_ID] [int] NOT NULL,
	[LDWID] [int] NULL,
 CONSTRAINT [PK_Quoted_Organization_Rate] PRIMARY KEY CLUSTERED 
(
	[BCD_Number] ASC,
	[Vehicle_Class_Code] ASC,
	[Quoted_Rate_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
