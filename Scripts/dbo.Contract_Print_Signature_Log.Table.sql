USE [GISData]
GO
/****** Object:  Table [dbo].[Contract_Print_Signature_Log]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contract_Print_Signature_Log](
	[Contract_Number] [int] NULL,
	[Credit_Card_Key] [int] NULL,
	[Last_Print_Date] [datetime] NULL,
	[Current_Print_Date] [datetime] NULL,
	[Remarks] [varchar](50) NULL
) ON [PRIMARY]
GO
