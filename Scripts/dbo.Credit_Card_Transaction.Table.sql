USE [GISData]
GO
/****** Object:  Table [dbo].[Credit_Card_Transaction]    Script Date: 2021-07-10 1:50:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Credit_Card_Transaction](
	[Authorization_Number] [varchar](12) NOT NULL,
	[Credit_Card_Type_Id] [char](3) NOT NULL,
	[Credit_Card_Number] [varchar](20) NOT NULL,
	[Last_Name] [varchar](25) NULL,
	[First_Name] [varchar](25) NULL,
	[Expiry] [char](5) NULL,
	[Amount] [decimal](9, 2) NOT NULL,
	[Collected_By] [varchar](20) NOT NULL,
	[Collected_At_Location_Id] [smallint] NOT NULL,
	[Terminal_ID] [varchar](20) NOT NULL,
	[Trx_Receipt_Ref_Num] [char](20) NOT NULL,
	[Trx_ISO_Response_Code] [char](2) NOT NULL,
	[Trx_Remarks] [varchar](90) NOT NULL,
	[Swiped_Flag] [bit] NOT NULL,
	[Contract_Number] [int] NULL,
	[Confirmation_Number] [int] NULL,
	[Sales_Contract_Number] [int] NULL,
	[Added_To_GIS] [bit] NOT NULL,
	[Entered_On_Handheld] [bit] NOT NULL,
	[Function] [varchar](20) NOT NULL,
	[RBR_Date] [datetime] NOT NULL,
	[System_Datetime] [datetime] NOT NULL,
	[Void] [bit] NOT NULL,
	[Short_Token] [varchar](20) NOT NULL,
 CONSTRAINT [PK_Credit_Card_Transaction_1] PRIMARY KEY CLUSTERED 
(
	[Authorization_Number] ASC,
	[Trx_Receipt_Ref_Num] ASC,
	[Short_Token] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Credit_Card_Transaction] ADD  CONSTRAINT [DF__Credit_Car__Void__57404F6B]  DEFAULT (0) FOR [Void]
GO
