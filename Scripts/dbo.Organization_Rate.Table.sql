USE [GISData]
GO
/****** Object:  Table [dbo].[Organization_Rate]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Organization_Rate](
	[Organization_ID] [int] NOT NULL,
	[Rate_ID] [int] NOT NULL,
	[Effective_Date] [datetime] NOT NULL,
	[Valid_From] [datetime] NOT NULL,
	[Valid_To] [datetime] NULL,
	[Rate_Level] [char](1) NOT NULL,
	[Termination_Date] [datetime] NOT NULL,
	[Maestro_Rate] [varchar](10) NULL,
 CONSTRAINT [PK_Organization_Rate] PRIMARY KEY CLUSTERED 
(
	[Organization_ID] ASC,
	[Rate_ID] ASC,
	[Effective_Date] ASC,
	[Rate_Level] ASC,
	[Valid_From] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_Organization_Rate1]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [IX_Organization_Rate1] ON [dbo].[Organization_Rate]
(
	[Organization_ID] ASC,
	[Rate_ID] ASC,
	[Termination_Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Organization_Rate] ADD  CONSTRAINT [DF__Organizat__Rate___0BDD6985]  DEFAULT (' ') FOR [Rate_Level]
GO
ALTER TABLE [dbo].[Organization_Rate]  WITH CHECK ADD  CONSTRAINT [FK_Organization1] FOREIGN KEY([Organization_ID])
REFERENCES [dbo].[Organization] ([Organization_ID])
GO
ALTER TABLE [dbo].[Organization_Rate] CHECK CONSTRAINT [FK_Organization1]
GO
