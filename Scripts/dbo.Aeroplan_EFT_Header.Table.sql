USE [GISData]
GO
/****** Object:  Table [dbo].[Aeroplan_EFT_Header]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Aeroplan_EFT_Header](
	[File_Creation_Number] [int] IDENTITY(1,1) NOT NULL,
	[Starting_RBR_Date] [datetime] NULL,
	[Ending_RBR_Date] [datetime] NULL,
	[File_Name] [varchar](30) NULL,
	[Record_Type] [varchar](2) NULL,
	[Source_Identifier] [varchar](10) NULL,
	[Record_Count] [int] NULL,
	[File_CreatetionDate] [datetime] NULL,
	[Partner_code] [varchar](3) NOT NULL
) ON [PRIMARY]
GO
