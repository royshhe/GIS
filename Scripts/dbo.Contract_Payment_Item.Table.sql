USE [GISData]
GO
/****** Object:  Table [dbo].[Contract_Payment_Item]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contract_Payment_Item](
	[Contract_Number] [int] NOT NULL,
	[Sequence] [smallint] NOT NULL,
	[Payment_Type] [varchar](20) NOT NULL,
	[Amount] [decimal](9, 2) NOT NULL,
	[Collected_On] [datetime] NOT NULL,
	[Collected_By] [varchar](50) NOT NULL,
	[Collected_At_Location_ID] [smallint] NOT NULL,
	[RBR_Date] [datetime] NOT NULL,
	[Business_Transaction_ID] [int] NOT NULL,
	[Copied_Payment] [bit] NOT NULL,
 CONSTRAINT [PK_Contract_Payment_Item] PRIMARY KEY CLUSTERED 
(
	[Contract_Number] ASC,
	[Sequence] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_cpi_rbr_ptype]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [ix_cpi_rbr_ptype] ON [dbo].[Contract_Payment_Item]
(
	[RBR_Date] ASC,
	[Payment_Type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Contract_Payment_Item] ADD  CONSTRAINT [DF_Contract_Payment_Item_Copied_Payment]  DEFAULT (0) FOR [Copied_Payment]
GO
ALTER TABLE [dbo].[Contract_Payment_Item]  WITH NOCHECK ADD  CONSTRAINT [FK_Business_Transaction4] FOREIGN KEY([Business_Transaction_ID])
REFERENCES [dbo].[Business_Transaction] ([Business_Transaction_ID])
GO
ALTER TABLE [dbo].[Contract_Payment_Item] CHECK CONSTRAINT [FK_Business_Transaction4]
GO
ALTER TABLE [dbo].[Contract_Payment_Item]  WITH NOCHECK ADD  CONSTRAINT [FK_Contract05] FOREIGN KEY([Contract_Number])
REFERENCES [dbo].[Contract] ([Contract_Number])
GO
ALTER TABLE [dbo].[Contract_Payment_Item] CHECK CONSTRAINT [FK_Contract05]
GO
ALTER TABLE [dbo].[Contract_Payment_Item]  WITH NOCHECK ADD  CONSTRAINT [FK_Location18] FOREIGN KEY([Collected_At_Location_ID])
REFERENCES [dbo].[Location] ([Location_ID])
GO
ALTER TABLE [dbo].[Contract_Payment_Item] CHECK CONSTRAINT [FK_Location18]
GO
ALTER TABLE [dbo].[Contract_Payment_Item]  WITH NOCHECK ADD  CONSTRAINT [FK_RBR_Date1] FOREIGN KEY([RBR_Date])
REFERENCES [dbo].[RBR_Date] ([RBR_Date])
GO
ALTER TABLE [dbo].[Contract_Payment_Item] CHECK CONSTRAINT [FK_RBR_Date1]
GO
