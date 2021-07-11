USE [GISData]
GO
/****** Object:  Table [dbo].[Pick_Up_Drop_Off_Location]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pick_Up_Drop_Off_Location](
	[ID] [smallint] IDENTITY(1,1) NOT NULL,
	[Pick_Up_Location_ID] [smallint] NOT NULL,
	[Drop_Off_Location_ID] [smallint] NOT NULL,
	[Valid_From] [datetime] NOT NULL,
	[Valid_To] [datetime] NULL,
	[Authorized] [bit] NOT NULL,
	[Authorized_Charge] [decimal](7, 2) NULL,
	[Unauthorized_Charge] [decimal](7, 2) NOT NULL,
 CONSTRAINT [PK_Pick_Up_Drop_Off_Location] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UC_Pick_Up_Drop_Off_Location1] UNIQUE NONCLUSTERED 
(
	[Pick_Up_Location_ID] ASC,
	[Drop_Off_Location_ID] ASC,
	[Valid_From] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_Pick_Up_Drop_Off_Location1]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [IX_Pick_Up_Drop_Off_Location1] ON [dbo].[Pick_Up_Drop_Off_Location]
(
	[Pick_Up_Location_ID] ASC,
	[Drop_Off_Location_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Pick_Up_Drop_Off_Location]  WITH NOCHECK ADD  CONSTRAINT [FK_Location16] FOREIGN KEY([Drop_Off_Location_ID])
REFERENCES [dbo].[Location] ([Location_ID])
GO
ALTER TABLE [dbo].[Pick_Up_Drop_Off_Location] CHECK CONSTRAINT [FK_Location16]
GO
ALTER TABLE [dbo].[Pick_Up_Drop_Off_Location]  WITH NOCHECK ADD  CONSTRAINT [FK_Location17] FOREIGN KEY([Pick_Up_Location_ID])
REFERENCES [dbo].[Location] ([Location_ID])
GO
ALTER TABLE [dbo].[Pick_Up_Drop_Off_Location] CHECK CONSTRAINT [FK_Location17]
GO
