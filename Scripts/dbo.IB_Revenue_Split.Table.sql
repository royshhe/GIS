USE [GISData]
GO
/****** Object:  Table [dbo].[IB_Revenue_Split]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IB_Revenue_Split](
	[Transaction_Type] [varchar](20) NOT NULL,
	[IB_Zone] [char](10) NOT NULL,
	[Revenue_Account] [varchar](20) NOT NULL,
	[Revenue_Ownership] [varchar](20) NULL,
	[Commission_Rate] [decimal](9, 4) NULL,
 CONSTRAINT [PK_IB_Revenue_Split] PRIMARY KEY CLUSTERED 
(
	[Transaction_Type] ASC,
	[IB_Zone] ASC,
	[Revenue_Account] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
