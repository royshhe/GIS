USE [GISData]
GO
/****** Object:  Table [dbo].[GIS_CSR]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GIS_CSR](
	[Location] [char](25) NOT NULL,
	[UserName] [char](25) NOT NULL,
	[Password] [char](10) NOT NULL,
	[EmployeeID] [char](10) NULL,
	[EmployeeStatus] [char](5) NULL,
 CONSTRAINT [PK_GIS_CSR] PRIMARY KEY NONCLUSTERED 
(
	[Location] ASC,
	[Password] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UC_GIS_CSR] UNIQUE NONCLUSTERED 
(
	[Location] ASC,
	[Password] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GIS_CSR] ADD  CONSTRAINT [DF_GIS_CSR_Location]  DEFAULT ('A') FOR [Location]
GO
