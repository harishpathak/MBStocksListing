# MBStocksListing
A simple list of static stocks with a echo websocket connection to reflect random price changes.

Architecture Decisions
MVVM + Coordinator

Coordinators own all navigation logic — ViewControllers never push/present directly.
ViewModels own business logic; ViewControllers are purely display + delegation.
Combine is used for reactive bindings between ViewModel outputs and ViewController UI updates.

Service Layer

WebSocketService — protocol-based, injectable, handles reconnection and state management.
StockPriceService — sits above WebSocket, owns the symbol registry, dispatches PriceUpdate events.
All services are protocol-defined for testability.

WebSocket Integration

Connects to wss://ws.postman-echo.com/raw (echo server).
Sends a JSON payload with a random price delta; echoed message is parsed back as a PriceUpdate.

Screens
Stock List Screen

25 symbols with name, price, and change indicator (color).
Sort by Price or Price Change via segmented control.
Connection status badge (live/disconnected).
Start / Stop feed button.

Stock Detail Screen

Symbol name
Live price changes
Company description.
Start / Stop feed button.


Testing Strategy
See Tests/ — unit tests cover:

StockListViewModel — sorting, feed toggle, state emissions
StockDetailViewModel — price update subscription, feed status
StockPriceService — symbol display, price change update
WebSocketService — connection state machine.

Mocks: MockWebSocketService, MockStockPriceService for full isolation.
