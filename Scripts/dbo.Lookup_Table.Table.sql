USE [GISData]
GO
/****** Object:  Table [dbo].[Lookup_Table]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Lookup_Table](
	[Category] [char](25) NOT NULL,
	[Code] [char](25) NOT NULL,
	[Value] [varchar](255) NULL,
	[Alias] [varchar](255) NULL,
	[Editable] [bit] NULL,
 CONSTRAINT [PK_Lookup_Table] PRIMARY KEY CLUSTERED 
(
	[Category] ASC,
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [_dta_index_Lookup_Table_5_2066978590__K2_K1_K3]    Script Date: 2021-07-10 1:50:47 PM ******/
CREATE NONCLUSTERED INDEX [_dta_index_Lookup_Table_5_2066978590__K2_K1_K3] ON [dbo].[Lookup_Table]
(
	[Code] ASC,
	[Category] ASC,
	[Value] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
