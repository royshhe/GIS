USE [GISData]
GO
/****** Object:  Table [dbo].[Contract_Print]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contract_Print](
	[Contract_Number] [int] NOT NULL,
	[Print_Seq] [smallint] NOT NULL,
	[Printed_By] [varchar](20) NULL,
	[Printed_On] [datetime] NOT NULL,
 CONSTRAINT [PK_Contract_Print] PRIMARY KEY CLUSTERED 
(
	[Contract_Number] ASC,
	[Print_Seq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
