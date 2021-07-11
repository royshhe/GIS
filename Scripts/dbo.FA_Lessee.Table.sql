USE [GISData]
GO
/****** Object:  Table [dbo].[FA_Lessee]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FA_Lessee](
	[Lessee_ID] [smallint] IDENTITY(1,1) NOT NULL,
	[Vendor_Code] [char](12) NULL,
	[Customer_Code] [char](12) NULL,
	[Owing_Company_ID] [int] NULL,
	[Lessee_Name] [varchar](50) NULL,
	[Alias] [char](20) NULL,
 CONSTRAINT [PK_FA_Lessee] PRIMARY KEY CLUSTERED 
(
	[Lessee_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
