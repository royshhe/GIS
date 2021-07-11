USE [GISData]
GO
/****** Object:  Table [dbo].[FA_Market_Allowance_Source]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FA_Market_Allowance_Source](
	[Source_ID] [int] IDENTITY(1,1) NOT NULL,
	[Source_Type] [varchar](20) NOT NULL,
	[Source] [varchar](20) NULL,
	[Customer_Code] [varchar](20) NULL,
 CONSTRAINT [PK_FA_Market_Allowance_Source] PRIMARY KEY CLUSTERED 
(
	[Source_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
