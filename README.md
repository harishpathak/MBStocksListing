# MBStocksListing
A simple list of static stocks with a echo websocket connection to reflect random price changes.

| Stock List | Stock List | Stock Details | Stock Details |
| :---: | :---: | :---: | :---: |
| <img src="https://github.com/user-attachments/assets/917c238a-da50-4950-97a7-a850d3312d98" width="250" /> | <img src="https://github.com/user-attachments/assets/dfbdc17e-1d48-4266-8ea7-79249bf2d0d0" width="250" /> | <img src="https://github.com/user-attachments/assets/eeda3f83-946e-497d-93f9-c1fb9f28e321" width="250" /> | <img src="https://github.com/user-attachments/assets/4ddc6770-74f8-4b82-8bd2-87e934beb6dd" width="250" /> |



**Architecture Decisions**

MVVM + Coordinator

Coordinators own all navigation logic — ViewControllers never push/present directly.
ViewModels own business logic; ViewControllers are purely display + delegation.
Combine is used for reactive bindings between ViewModel outputs and ViewController UI updates.

**Service Layer**

WebSocketService — protocol-based, injectable, handles reconnection and state management.
StockPriceService — sits above WebSocket, owns the symbol registry, dispatches PriceUpdate events.
All services are protocol-defined for testability.

**WebSocket Integration**

Connects to wss://ws.postman-echo.com/raw (echo server).
Sends a JSON payload with a random price delta; echoed message is parsed back as a PriceUpdate.

**Screens**
**Stock List Screen**

25 symbols with name, price, and change indicator (color).
Sort by Price or Price Change via segmented control.
Connection status badge (live/disconnected).
Start / Stop feed button.

**Stock Detail Screen**

Symbol name
Live price changes
Company description.
Start / Stop feed button.


**Testing Strategy**
See Tests/ — unit tests cover:

StockListViewModel — sorting, feed toggle, state emissions
StockDetailViewModel — price update subscription, feed status
StockPriceService — symbol display, price change update
WebSocketService — connection state machine.

Mocks: MockWebSocketService, MockStockPriceService for full isolation.
