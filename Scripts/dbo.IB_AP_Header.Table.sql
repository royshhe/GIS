USE [GISData]
GO
/****** Object:  Table [dbo].[IB_AP_Header]    Script Date: 2021-07-10 1:50:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IB_AP_Header](
	[IB_AP_ID] [int] IDENTITY(1,1) NOT NULL,
	[Contract_Number] [int] NOT NULL,
	[RBR_Date] [datetime] NOT NULL,
	[Vendor_Code] [varchar](12) NOT NULL,
	[Amount] [decimal](9, 2) NOT NULL,
	[Doc_Ctrl_Num_Base] [varchar](12) NOT NULL,
	[Doc_Ctrl_Num_Type] [char](1) NULL,
	[Doc_Ctrl_Num_Seq] [int] NULL,
	[Apply_To_Doc_Ctrl_Num] [varchar](16) NULL,
 CONSTRAINT [PK_IB_AP_Header] PRIMARY KEY CLUSTERED 
(
	[IB_AP_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
