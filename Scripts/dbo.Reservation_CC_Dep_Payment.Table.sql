USE [GISData]
GO
/****** Object:  Table [dbo].[Reservation_CC_Dep_Payment]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reservation_CC_Dep_Payment](
	[Confirmation_Number] [int] NOT NULL,
	[Collected_On] [datetime] NOT NULL,
	[Sequence] [smallint] NOT NULL,
	[Credit_Card_Key] [int] NOT NULL,
	[Authorization_Number] [varchar](12) NOT NULL,
	[Swiped_Flag] [bit] NOT NULL,
	[Terminal_ID] [varchar](20) NULL,
	[Trx_Receipt_Ref_Num] [varchar](20) NULL,
	[Trx_ISO_Response_Code] [char](2) NULL,
	[Trx_Remarks] [varchar](90) NULL,
 CONSTRAINT [PK_Reservation_CC_Dep_Payment] PRIMARY KEY CLUSTERED 
(
	[Confirmation_Number] ASC,
	[Collected_On] ASC,
	[Sequence] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Reservation_CC_Dep_Payment] ADD  CONSTRAINT [DF_Reservation_Swiped_Flag]  DEFAULT (0) FOR [Swiped_Flag]
GO
ALTER TABLE [dbo].[Reservation_CC_Dep_Payment]  WITH CHECK ADD  CONSTRAINT [FK_Credit_Card3] FOREIGN KEY([Credit_Card_Key])
REFERENCES [dbo].[Credit_Card] ([Credit_Card_Key])
GO
ALTER TABLE [dbo].[Reservation_CC_Dep_Payment] CHECK CONSTRAINT [FK_Credit_Card3]
GO
ALTER TABLE [dbo].[Reservation_CC_Dep_Payment]  WITH CHECK ADD  CONSTRAINT [FK_Terminal5] FOREIGN KEY([Terminal_ID])
REFERENCES [dbo].[Terminal] ([Terminal_ID])
GO
ALTER TABLE [dbo].[Reservation_CC_Dep_Payment] CHECK CONSTRAINT [FK_Terminal5]
GO
