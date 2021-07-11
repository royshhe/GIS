USE [GISData]
GO
/****** Object:  Table [dbo].[Credit_Card_Log]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Credit_Card_Log](
	[Log_ID] [int] IDENTITY(1,1) NOT NULL,
	[Log_Type] [varchar](10) NULL,
	[Credit_Card_Key] [int] NULL,
	[Credit_Card_Type_ID] [char](3) NULL,
	[Credit_Card_Number] [varchar](20) NULL,
	[Short_Token] [varchar](20) NULL,
	[Process_Date] [datetime] NULL,
 CONSTRAINT [PK_Credit_Card_Log] PRIMARY KEY CLUSTERED 
(
	[Log_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
