USE [GISData]
GO
/****** Object:  Table [dbo].[Credit_Card]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Credit_Card](
	[Credit_Card_Key] [int] IDENTITY(1,1) NOT NULL,
	[Credit_Card_Type_ID] [char](3) NULL,
	[Credit_Card_Number] [varchar](20) NULL,
	[Customer_ID] [int] NULL,
	[Last_Name] [varchar](25) NULL,
	[First_Name] [varchar](25) NULL,
	[Expiry] [char](5) NULL,
	[Sequence_Num] [int] NULL,
	[Token] [varchar](130) NULL,
	[Short_Token] [varchar](20) NULL,
	[Card_Holder_Name] [varchar](80) NULL,
 CONSTRAINT [PK_Credit_Card] PRIMARY KEY CLUSTERED 
(
	[Credit_Card_Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UC_Credit_Card1] UNIQUE NONCLUSTERED 
(
	[Credit_Card_Type_ID] ASC,
	[Short_Token] ASC,
	[Last_Name] ASC,
	[First_Name] ASC,
	[Expiry] ASC,
	[Sequence_Num] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [_dta_index_Credit_Card_5_629577281__K1_K2]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [_dta_index_Credit_Card_5_629577281__K1_K2] ON [dbo].[Credit_Card]
(
	[Credit_Card_Key] ASC,
	[Credit_Card_Type_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ID_Credit_Card_N_E_K_T_F_L]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [ID_Credit_Card_N_E_K_T_F_L] ON [dbo].[Credit_Card]
(
	[Credit_Card_Number] ASC,
	[Expiry] ASC,
	[Credit_Card_Key] ASC,
	[Credit_Card_Type_ID] ASC,
	[First_Name] ASC,
	[Last_Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [IX_CreditCard_Cust]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [IX_CreditCard_Cust] ON [dbo].[Credit_Card]
(
	[Customer_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix_creditcard_number]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [ix_creditcard_number] ON [dbo].[Credit_Card]
(
	[Credit_Card_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Credit_Card]  WITH NOCHECK ADD  CONSTRAINT [FK_Credit_Card_Type1] FOREIGN KEY([Credit_Card_Type_ID])
REFERENCES [dbo].[Credit_Card_Type] ([Credit_Card_Type_ID])
GO
ALTER TABLE [dbo].[Credit_Card] CHECK CONSTRAINT [FK_Credit_Card_Type1]
GO
ALTER TABLE [dbo].[Credit_Card]  WITH CHECK ADD  CONSTRAINT [FK_Customer2] FOREIGN KEY([Customer_ID])
REFERENCES [dbo].[Customer] ([Customer_ID])
GO
ALTER TABLE [dbo].[Credit_Card] CHECK CONSTRAINT [FK_Customer2]
GO
