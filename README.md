Forecast (iOS)

Forecast is a SwiftUI iOS MVP that projects cash flow from recent transactions and lets users chat with AI about “what‑if” questions. It’s built with a clean, swappable architecture so you can ship fast today and scale safely tomorrow.

⸻

Overview

The app focuses on three core flows:
	1.	Home → Overview
Shows current balance across accounts, this month’s income and spending, top categories by impact, and recent transactions.
	2.	Home → Charts
Displays a 30‑day balance forecast using a simple, explainable model (average daily net). The chart is clear at a glance and locale‑aware.
	3.	AI Chat
Lets users ask what‑ifs grounded in their own transactions. The MVP uses a mock chat adapter today; the seam is ready to swap in a real LLM.

A Settings tab keeps integration points obvious: Connect Bank and Clear Local Data. The MVP ships with seed data and mock adapters.

⸻

Key Features
	•	Dashboard overview with current balance, monthly income/spend, top categories, and recent transactions
	•	Charts tab with a 30‑day cash‑flow forecast (line + area, weekly ticks, padded axes)
	•	AI Chat that answers what‑ifs using recent transactions as context (mock adapter in MVP)
	•	Localization‑ready: labels in Localizable.strings; currency/dates respect device locale
	•	Accessibility: VoiceOver labels, monospaced digits for amounts, sensible contrast
	•	Dependency injection at the app boundary so external services are easy to swap

⸻

Architecture

Designed to keep the domain stable and IO details swappable:
	•	Domain models
Plain Swift types that describe the problem space (Account, Transaction, CashFlowPoint). No SDK dependencies.
	•	Ports (protocols)
Interfaces that define capabilities and contracts (BankAdapter, ChatAdapter, AccountRepository, TransactionRepository). These specify what the app needs, not how it’s done.
	•	Adapters
Concrete implementations of ports for specific sources. The MVP includes mock adapters (seed JSON and simulated chat). Real integrations (Plaid, OpenAI) can replace these without UI changes.
	•	Repositories + cache
Repositories orchestrate data and hide IO behind app‑facing methods. A small actor‑based in‑memory store provides thread‑safe, cache‑first reads. ViewModels depend on repositories, not raw adapters.
	•	Use cases
Encapsulated business logic. The forecast use case computes day‑by‑day balance points from recent cash‑flow patterns. It’s swappable for bill‑aware or seasonal models without touching UI.
	•	MVVM Views
SwiftUI views stay thin. ViewModels expose published state (loading, errors, balances, category totals, forecast points); Views render state. Screens include Dashboard, Forecast Chart, and Chat.
	•	Composition root
A single place to assemble and inject concrete implementations (e.g., in app entry or a small AppDependency). Swapping mocks for production adapters happens here.

⸻

Localization and Accessibility
	•	Currency and date formatting use system formatters and respect user locale.
	•	Static strings live in Localizable.strings.
	•	VoiceOver labels are provided for key UI elements and transaction semantics.

⸻

Running the App
	•	Requirements: Xcode 15+, iOS 17+
	•	Run: Open the project in Xcode, select an iOS Simulator, Build & Run
	•	Data: The app starts with seed accounts/transactions via mock adapters
	•	Tabs: Home (Overview and Charts), AI Chat, Settings

⸻

Swapping Mocks for Real Services
	•	Bank integration (Plaid): Implement a concrete BankAdapter using Plaid Link + secure token flow; replace the mock in the composition root.
	•	Chat integration (LLM): Implement ChatAdapter for your LLM/backend; replace the mock adapter in the composition root.
	•	No ViewModel/View changes needed—only bindings change.

⸻

Roadmap
	•	Integrate Plaid Link and complete secure token exchange
	•	Replace mock chat with a production LLM adapter and prompt grounded by categorized transactions
	•	Add persistent storage by swapping the in‑memory store for a local database
	•	Evolve the forecast to a bill‑aware model (monthly anchors, seasonality)
	•	Add additional charts: category trends, burn‑down, anomaly highlights

⸻

<img width="437" height="964" alt="image" src="https://github.com/user-attachments/assets/cf1843f9-b660-406a-8159-aa64979f8442" />
<img width="437" height="964" alt="image" src="https://github.com/user-attachments/assets/6ca3cb3c-3234-47fd-bacb-f09b47a6a2a1" />
<img width="437" height="964" alt="image" src="https://github.com/user-attachments/assets/ddf8180f-38fc-4d5b-b65d-2644347c3fcd" />
<img width="437" height="964" alt="image" src="https://github.com/user-attachments/assets/25f54053-52f1-4eb9-b688-070827f85292" />



