USE [GISData]
GO
/****** Object:  Table [dbo].[Discount]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Discount](
	[Discount_ID] [char](1) NOT NULL,
	[Discount] [varchar](20) NOT NULL,
	[Percentage] [decimal](7, 4) NOT NULL,
	[TermsConds_1] [varchar](255) NULL,
	[TermsConds_2] [varchar](255) NULL,
	[TermsConds_3] [varchar](255) NULL,
	[TermsConds_4] [varchar](255) NULL,
	[TermsConds_5] [varchar](255) NULL,
	[TermsConds_6] [varchar](255) NULL,
	[TermsConds_7] [varchar](255) NULL,
	[Effective_Date] [datetime] NOT NULL,
	[Termination_Date] [datetime] NOT NULL,
 CONSTRAINT [PK_Discount] PRIMARY KEY CLUSTERED 
(
	[Discount_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [UC_Discount1] UNIQUE NONCLUSTERED 
(
	[Discount] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Discount] ADD  CONSTRAINT [DF__Discount__Effect__2D942E62]  DEFAULT ('1999-01-01 00:00:00') FOR [Effective_Date]
GO
ALTER TABLE [dbo].[Discount] ADD  CONSTRAINT [DF__Discount__Termin__2E88529B]  DEFAULT ('2078-12-31 23:59:00') FOR [Termination_Date]
GO
