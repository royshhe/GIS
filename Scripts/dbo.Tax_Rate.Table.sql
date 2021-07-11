USE [GISData]
GO
/****** Object:  Table [dbo].[Tax_Rate]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tax_Rate](
	[Valid_From] [datetime] NOT NULL,
	[Valid_To] [datetime] NOT NULL,
	[Tax_Type] [varchar](5) NOT NULL,
	[Tax_Rate] [decimal](7, 4) NOT NULL,
	[Rate_Type] [varchar](10) NOT NULL,
	[Last_Changed_By] [varchar](20) NULL,
	[Last_Changed_On] [datetime] NULL,
	[Payables_Clearing_Account] [varchar](20) NULL,
	[Payables_Clearing_Contra] [varchar](20) NULL,
 CONSTRAINT [PK_Tax_Rate] PRIMARY KEY CLUSTERED 
(
	[Valid_From] ASC,
	[Valid_To] ASC,
	[Tax_Type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Tax_Rate] ADD  CONSTRAINT [DF__Tax_Ratex__Rate___6A50C1DA]  DEFAULT ('Percent') FOR [Rate_Type]
GO
