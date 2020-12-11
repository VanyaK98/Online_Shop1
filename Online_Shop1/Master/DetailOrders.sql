CREATE TABLE [Master].[DetailOrders] (
    [ID]         INT IDENTITY (1, 1) NOT NULL,
    [OrderId]    INT NULL,
    [ProductsID] INT NULL,
    CONSTRAINT [PK_Master_DetailOrders] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_O_DetailOrders_Orders] FOREIGN KEY ([OrderId]) REFERENCES [Master].[Orders] ([Id]),
    CONSTRAINT [FK_O_DetailOrders_Products] FOREIGN KEY ([ProductsID]) REFERENCES [Master].[Products] ([ID])
);

