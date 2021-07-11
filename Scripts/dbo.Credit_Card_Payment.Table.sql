USE [GISData]
GO
/****** Object:  Table [dbo].[Credit_Card_Payment]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Credit_Card_Payment](
	[Contract_Number] [int] NOT NULL,
	[Sequence] [smallint] NOT NULL,
	[Credit_Card_Key] [int] NOT NULL,
	[Authorization_Number] [varchar](12) NOT NULL,
	[Swiped_Flag] [bit] NOT NULL,
	[Terminal_ID] [varchar](20) NULL,
	[Trx_Receipt_Ref_Num] [char](20) NULL,
	[Trx_ISO_Response_Code] [char](2) NULL,
	[Trx_Remarks] [varchar](90) NULL,
 CONSTRAINT [PK_Credit_Card_Payment] PRIMARY KEY CLUSTERED 
(
	[Contract_Number] ASC,
	[Sequence] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_Credit_Card_Payment1]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [IX_Credit_Card_Payment1] ON [dbo].[Credit_Card_Payment]
(
	[Credit_Card_Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Credit_Card_Payment] ADD  CONSTRAINT [DF_Credit_Card_Swiped_Flag_1]  DEFAULT (0) FOR [Swiped_Flag]
GO
ALTER TABLE [dbo].[Credit_Card_Payment]  WITH CHECK ADD  CONSTRAINT [FK_Credit_Card2] FOREIGN KEY([Credit_Card_Key])
REFERENCES [dbo].[Credit_Card] ([Credit_Card_Key])
GO
ALTER TABLE [dbo].[Credit_Card_Payment] CHECK CONSTRAINT [FK_Credit_Card2]
GO
ALTER TABLE [dbo].[Credit_Card_Payment]  WITH CHECK ADD  CONSTRAINT [FK_Terminal3] FOREIGN KEY([Terminal_ID])
REFERENCES [dbo].[Terminal] ([Terminal_ID])
GO
ALTER TABLE [dbo].[Credit_Card_Payment] CHECK CONSTRAINT [FK_Terminal3]
GO
