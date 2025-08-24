Forecast (iOS)

Forecast is a SwiftUI iOS MVP that projects cash flow from recent transactions and lets users chat with AI about “what‑if” questions. It was built quickly with a clean, swappable architecture so you can ship fast today and scale safely tomorrow.

Overview

The app focuses on three user flows:
	1.	Home → Overview
Shows current balance across accounts, this month’s income and spending, top categories by impact, and a short list of recent transactions.
	2.	Home → Charts
Displays a 30‑day balance forecast using a simple, explainable model (average daily net). The chart is clear at a glance and fully locale‑aware.
	3.	AI Chat
Allows users to ask what‑ifs grounded in their own transactions. The current build uses a mock chat adapter; the seam is in place to swap in a real LLM service.

A Settings tab keeps integration points obvious: Connect Bank and Clear Local Data. The MVP ships with seed data and mock adapters.

Key Features
	•	Dashboard overview with current balance, monthly income/spend, top categories, and recent transactions
	•	Charts tab with a 30‑day cash‑flow forecast (line with area fill, weekly ticks, padded axes)
	•	AI Chat that answers what‑ifs using recent transactions as context (mock adapter in MVP)
	•	Localization‑ready labels and formatters; currency and dates follow the device locale
	•	Accessibility considerations such as VoiceOver labels and monospaced digits for amounts
	•	Dependency injection at the app boundary to enable easy swapping of external services

Architecture

The project is organized into clear layers to keep the domain stable and the IO details swappable:
	•	Domain models
Core entities that describe the problem space (Account, Transaction, CashFlowPoint). These are plain data types and do not depend on SDKs.
	•	Ports (protocols)
Interfaces that define capabilities and contracts, such as fetching transactions or answering a user question. Examples include BankAdapter, ChatAdapter, AccountRepository, and TransactionRepository.
	•	Adapters
Concrete implementations of the ports for specific data sources. The MVP includes mock adapters that read seed data for bank operations and generate simulated chat responses. Real integrations (Plaid, OpenAI) can replace these with no UI changes.
	•	Repositories and cache
Orchestrate data access and caching behind app‑facing methods. A small actor‑based in‑memory store provides thread‑safe, cache‑first reads. ViewModels depend on repositories, not on raw adapters.
	•	Use cases
Encapsulated business logic. The forecast use case computes day‑by‑day balance points from recent cash‑flow patterns. This can be replaced by more advanced models (bill‑aware, seasonal) without touching the UI.
	•	MVVM Views
SwiftUI views remain thin. ViewModels expose published state (loading, errors, balances, category totals, forecast points) and the views render that state. Screens include the Dashboard, Forecast Chart, and Chat.
	•	Composition root
A single place where concrete implementations are assembled and injected (for example, in the app entry or a small AppDependency). Swapping mocks for production adapters happens here.

Localization and Accessibility
	•	Currency and date formatting are driven by system formatters and respect the user’s locale.
	•	Static strings are organized under Localizable.strings.
	•	VoiceOver labels are provided for key UI elements and transactions.

Running the App
	•	Requirements: Xcode 15 or newer, iOS 17 or newer.
	•	Open the project in Xcode, select an iOS Simulator, and run.
	•	The app starts with seed accounts and transactions via mock adapters.
	•	Tabs: Home (Overview and Charts), AI Chat, Settings.

Swapping Mocks for Real Services
	•	Bank integration: create a concrete BankAdapter implementation that uses Plaid Link and a secure token flow, then replace the mock adapter in the composition root.
	•	Chat integration: create a concrete ChatAdapter implementation for your LLM or backend, then replace the mock adapter in the composition root.
	•	No ViewModel or View changes are required for either swap.

Roadmap
	•	Integrate Plaid Link and complete the server side for token exchange
	•	Replace mock chat with a production LLM adapter and prompt grounded by categorized transactions
	•	Introduce persistent storage by swapping the in‑memory store for a local database
	•	Evolve the forecast to a bill‑aware model with monthly anchors and seasonality
	•	Add additional charts such as category trends and anomaly highlights
