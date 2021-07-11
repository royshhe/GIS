USE [GISData]
GO
/****** Object:  Table [dbo].[FA_Dep_Lease_Month_End]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FA_Dep_Lease_Month_End](
	[FA_Month] [datetime] NOT NULL,
	[Vehicle_AMO_Date] [datetime] NULL,
	[Lease_AMO_Date] [datetime] NULL,
 CONSTRAINT [PK_FA_Month_End] PRIMARY KEY CLUSTERED 
(
	[FA_Month] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
