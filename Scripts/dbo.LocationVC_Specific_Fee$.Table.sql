USE [GISData]
GO
/****** Object:  Table [dbo].[LocationVC_Specific_Fee$]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LocationVC_Specific_Fee$](
	[Location] [varchar](50) NOT NULL,
	[Vehicle_Class] [char](30) NOT NULL,
	[Fee_Type] [char](3) NOT NULL,
	[Fee_Description] [varchar](50) NULL,
	[Flat_Fee] [decimal](7, 2) NULL,
	[Percentage_fee] [decimal](5, 2) NULL,
	[Per_Day_fee] [decimal](7, 2) NULL,
	[Valid_From] [datetime] NOT NULL,
	[Valid_To] [datetime] NULL
) ON [PRIMARY]
GO
