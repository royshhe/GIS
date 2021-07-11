USE [GISData]
GO
/****** Object:  Table [dbo].[Air_Miles_EFT_Header]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Air_Miles_EFT_Header](
	[File_Creation_Number] [int] IDENTITY(1,1) NOT NULL,
	[Starting_RBR_Date] [datetime] NULL,
	[Ending_RBR_Date] [datetime] NULL,
	[File_Name] [varchar](13) NULL,
	[Transaction_Type] [varchar](2) NULL,
	[Originator_ID] [varchar](10) NULL,
	[File_CreatetionDate] [datetime] NULL,
 CONSTRAINT [PK_Air_Miles_EFT_Header] PRIMARY KEY CLUSTERED 
(
	[File_Creation_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
