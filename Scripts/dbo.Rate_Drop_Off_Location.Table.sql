USE [GISData]
GO
/****** Object:  Table [dbo].[Rate_Drop_Off_Location]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rate_Drop_Off_Location](
	[Location_ID] [smallint] NOT NULL,
	[Rate_ID] [int] NOT NULL,
	[Effective_Date] [datetime] NOT NULL,
	[Termination_Date] [datetime] NOT NULL,
	[Rate_Location_Set_ID] [int] NOT NULL,
	[Included_In_Rate] [bit] NOT NULL,
 CONSTRAINT [PK_Rate_Drop_Off_Location] PRIMARY KEY CLUSTERED 
(
	[Location_ID] ASC,
	[Rate_ID] ASC,
	[Effective_Date] ASC,
	[Rate_Location_Set_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_Rate_Drop_Off_Location]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [IX_Rate_Drop_Off_Location] ON [dbo].[Rate_Drop_Off_Location]
(
	[Rate_ID] ASC,
	[Termination_Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Rate_Drop_Off_Location]  WITH NOCHECK ADD  CONSTRAINT [FK_Location12] FOREIGN KEY([Location_ID])
REFERENCES [dbo].[Location] ([Location_ID])
GO
ALTER TABLE [dbo].[Rate_Drop_Off_Location] CHECK CONSTRAINT [FK_Location12]
GO
ALTER TABLE [dbo].[Rate_Drop_Off_Location]  WITH NOCHECK ADD  CONSTRAINT [FK_Rate_Drop_Off_Location_Rate_Location_Set] FOREIGN KEY([Rate_ID], [Effective_Date], [Rate_Location_Set_ID])
REFERENCES [dbo].[Rate_Location_Set] ([Rate_ID], [Effective_Date], [Rate_Location_Set_ID])
NOT FOR REPLICATION 
GO
ALTER TABLE [dbo].[Rate_Drop_Off_Location] NOCHECK CONSTRAINT [FK_Rate_Drop_Off_Location_Rate_Location_Set]
GO
