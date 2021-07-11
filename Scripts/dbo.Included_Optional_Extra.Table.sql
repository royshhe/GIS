USE [GISData]
GO
/****** Object:  Table [dbo].[Included_Optional_Extra]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Included_Optional_Extra](
	[Rate_ID] [int] NOT NULL,
	[Effective_Date] [datetime] NOT NULL,
	[Termination_Date] [datetime] NOT NULL,
	[Optional_Extra_ID] [smallint] NOT NULL,
	[Quantity] [smallint] NOT NULL,
	[Included_Daily_Amount] [decimal](7, 2) NOT NULL,
	[Included_Weekly_Amount] [decimal](7, 2) NULL,
 CONSTRAINT [PK_Included_Optional_Extra] PRIMARY KEY CLUSTERED 
(
	[Rate_ID] ASC,
	[Effective_Date] ASC,
	[Optional_Extra_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_Included_Optional_Extra1]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [IX_Included_Optional_Extra1] ON [dbo].[Included_Optional_Extra]
(
	[Rate_ID] ASC,
	[Termination_Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Included_Optional_Extra]  WITH CHECK ADD  CONSTRAINT [FK_Optional_Extra02] FOREIGN KEY([Optional_Extra_ID])
REFERENCES [dbo].[Optional_Extra] ([Optional_Extra_ID])
GO
ALTER TABLE [dbo].[Included_Optional_Extra] CHECK CONSTRAINT [FK_Optional_Extra02]
GO
