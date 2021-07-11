USE [GISData]
GO
/****** Object:  Table [dbo].[IB_Revenue_Ownership]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IB_Revenue_Ownership](
	[Owned_By_Me] [bit] NULL,
	[Rented_By_Me] [bit] NULL,
	[Received_By_Me] [bit] NULL,
	[Revenue_Owner_Ship] [varchar](20) NULL,
	[Subleger] [char](10) NULL,
	[Customer_Type] [char](10) NULL,
	[Vendor_Type] [char](10) NULL
) ON [PRIMARY]
GO
