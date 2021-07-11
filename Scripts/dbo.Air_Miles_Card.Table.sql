USE [GISData]
GO
/****** Object:  Table [dbo].[Air_Miles_Card]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Air_Miles_Card](
	[CARD_number] [varchar](20) NOT NULL,
	[Card_Type_ID] [char](4) NOT NULL,
	[Last_Name] [varchar](25) NULL,
	[First_Name] [varchar](25) NULL,
	[Last_Changed_By] [varchar](20) NULL,
	[Last_Changed_On] [datetime] NULL,
 CONSTRAINT [PK_Air_Miles_Card] PRIMARY KEY CLUSTERED 
(
	[CARD_number] ASC,
	[Card_Type_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
