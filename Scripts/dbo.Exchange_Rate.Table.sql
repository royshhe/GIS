USE [GISData]
GO
/****** Object:  Table [dbo].[Exchange_Rate]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Exchange_Rate](
	[Exchange_Rate_ID] [int] IDENTITY(1,1) NOT NULL,
	[Currency_ID] [tinyint] NOT NULL,
	[Exchange_Rate_Valid_From] [datetime] NOT NULL,
	[Rate] [decimal](9, 4) NULL,
	[Valid_To] [datetime] NULL,
	[Last_Changed_By] [varchar](20) NOT NULL,
	[Last_Changed_On] [datetime] NOT NULL,
 CONSTRAINT [PK_Exchange_Rate] PRIMARY KEY CLUSTERED 
(
	[Exchange_Rate_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UC_Exchange_Rate1] UNIQUE NONCLUSTERED 
(
	[Currency_ID] ASC,
	[Exchange_Rate_Valid_From] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
