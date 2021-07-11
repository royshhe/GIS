USE [GISData]
GO
/****** Object:  Table [dbo].[Billing_Method]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Billing_Method](
	[Billing_Method] [varchar](20) NOT NULL,
	[Type] [char](1) NOT NULL,
 CONSTRAINT [PK_Billing_Method] PRIMARY KEY CLUSTERED 
(
	[Billing_Method] ASC,
	[Type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
