USE [GISData]
GO
/****** Object:  Table [dbo].[Business_Transaction_Export]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Business_Transaction_Export](
	[RBR_Date] [datetime] NOT NULL,
	[Business_Transaction_ID] [int] NOT NULL,
 CONSTRAINT [PK_Business_Transaction_Export] PRIMARY KEY NONCLUSTERED 
(
	[RBR_Date] ASC,
	[Business_Transaction_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
