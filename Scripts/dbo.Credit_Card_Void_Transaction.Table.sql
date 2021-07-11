USE [GISData]
GO
/****** Object:  Table [dbo].[Credit_Card_Void_Transaction]    Script Date: 2021-07-10 1:50:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Credit_Card_Void_Transaction](
	[Authorization_Number] [varchar](12) NOT NULL,
	[Credit_Card_Type_Id] [char](3) NOT NULL,
	[Credit_Card_Number] [varchar](20) NOT NULL,
	[Last_Name] [varchar](25) NOT NULL,
	[First_Name] [varchar](25) NOT NULL,
	[Expiry] [char](5) NOT NULL,
	[Amount] [decimal](9, 2) NOT NULL,
	[Collected_By] [varchar](20) NOT NULL,
	[Collected_At_Location_Id] [smallint] NOT NULL,
	[Terminal_ID] [varchar](20) NOT NULL,
	[Trx_Receipt_Ref_Num] [char](8) NOT NULL,
	[Trx_ISO_Response_Code] [char](2) NOT NULL,
	[Trx_Remarks] [varchar](20) NOT NULL,
	[Swiped_Flag] [bit] NOT NULL,
	[Contract_Number] [int] NULL,
	[Confirmation_Number] [int] NULL,
	[Sales_Contract_Number] [int] NULL,
	[Added_To_GIS] [bit] NOT NULL,
	[Entered_On_Handheld] [bit] NOT NULL,
	[Function] [varchar](20) NOT NULL,
	[RBR_Date] [datetime] NOT NULL,
	[System_Datetime] [datetime] NOT NULL
) ON [PRIMARY]
GO
