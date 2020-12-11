CREATE TABLE [Master].[Orders] (
    [Id]             INT          IDENTITY (1, 1) NOT NULL,
    [ClientId]       INT          NULL,
    [Date]           DATE         NULL,
    [ShippingStatus] VARCHAR (20) NULL,
    CONSTRAINT [PK_Master_Orders] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_U_Orders_Clients] FOREIGN KEY ([ClientId]) REFERENCES [Master].[Clients] ([Id])
);

