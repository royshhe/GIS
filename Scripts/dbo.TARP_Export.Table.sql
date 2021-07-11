USE [GISData]
GO
/****** Object:  Table [dbo].[TARP_Export]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TARP_Export](
	[Contract_Number] [int] NULL,
	[Confirmation_Number] [int] NULL,
	[Total_Charges] [decimal](6, 2) NULL,
	[Code] [char](1) NULL,
 CONSTRAINT [UC_TARP_Export1] UNIQUE NONCLUSTERED 
(
	[Contract_Number] ASC,
	[Confirmation_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
