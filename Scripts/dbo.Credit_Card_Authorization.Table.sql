USE [GISData]
GO
/****** Object:  Table [dbo].[Credit_Card_Authorization]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Credit_Card_Authorization](
	[Contract_Number] [int] NOT NULL,
	[Contract_Billing_Party_ID] [int] NOT NULL,
	[Sequence] [smallint] NOT NULL,
	[Amount_Authorized] [decimal](9, 2) NOT NULL,
	[Authorization_Number] [varchar](12) NOT NULL,
	[Authorized_On] [datetime] NOT NULL,
	[Authorized_By] [varchar](20) NOT NULL,
	[Swiped_Flag] [bit] NOT NULL,
	[Terminal_ID] [varchar](20) NULL,
	[Authorized_At_Location_ID] [smallint] NOT NULL,
	[Collected_Flag] [bit] NOT NULL,
	[Credit_Card_Key] [int] NULL,
	[Trx_Receipt_Ref_Num] [char](20) NULL,
	[Trx_ISO_Response_Code] [char](8) NULL,
	[Trx_Remarks] [varchar](90) NULL,
 CONSTRAINT [PK_Credit_Card_Authorization] PRIMARY KEY CLUSTERED 
(
	[Contract_Number] ASC,
	[Contract_Billing_Party_ID] ASC,
	[Sequence] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Credit_Card_Authorization] ADD  CONSTRAINT [DF_Credit_Card_Swiped_Flag]  DEFAULT (0) FOR [Swiped_Flag]
GO
ALTER TABLE [dbo].[Credit_Card_Authorization] ADD  CONSTRAINT [DF_Credit_Card_Collected_F]  DEFAULT (0) FOR [Collected_Flag]
GO
ALTER TABLE [dbo].[Credit_Card_Authorization]  WITH CHECK ADD  CONSTRAINT [FK_Credit_Cardx] FOREIGN KEY([Credit_Card_Key])
REFERENCES [dbo].[Credit_Card] ([Credit_Card_Key])
GO
ALTER TABLE [dbo].[Credit_Card_Authorization] CHECK CONSTRAINT [FK_Credit_Cardx]
GO
ALTER TABLE [dbo].[Credit_Card_Authorization]  WITH NOCHECK ADD  CONSTRAINT [FK_Location28] FOREIGN KEY([Authorized_At_Location_ID])
REFERENCES [dbo].[Location] ([Location_ID])
GO
ALTER TABLE [dbo].[Credit_Card_Authorization] CHECK CONSTRAINT [FK_Location28]
GO
ALTER TABLE [dbo].[Credit_Card_Authorization]  WITH CHECK ADD  CONSTRAINT [FK_Terminal2] FOREIGN KEY([Terminal_ID])
REFERENCES [dbo].[Terminal] ([Terminal_ID])
GO
ALTER TABLE [dbo].[Credit_Card_Authorization] CHECK CONSTRAINT [FK_Terminal2]
GO
