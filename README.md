**Forecast** is a SwiftUI iOS MVP(built in 2days) that projects cash flow from recent transactions and lets users **chat with AI** about “what‑if” questions. It is designed with a **clean, swappable architecture** so you can **ship quickly** today and **scale safely** tomorrow.

Youtube link: https://youtu.be/byG2sWgnZuE
---

## Overview

The app focuses on three core flows:

1. **Home → Overview**  
   Shows **current balance** across accounts, **this month’s income and spending**, **top categories** by impact, and **recent transactions**.

2. **Home → Charts**  
   Displays a **30‑day balance forecast** using an explainable model (**average daily net**). The chart is **locale‑aware** and legible at a glance.

3. **AI Chat**  
   Lets users ask **what‑ifs grounded in their transactions**. The MVP uses a **mock chat adapter**; the seam is ready to swap in a **real LLM**.

A **Settings** tab keeps integration points obvious: **Connect Bank** and **Clear Local Data**. The MVP ships with **seed data** and **mock adapters**.

---

## Key Features

- **Dashboard overview**: current balance, monthly income/spend, top categories, recent transactions  
- **Charts tab**: 30‑day **cash‑flow forecast** (line + area, weekly ticks, padded axes)  
- **AI Chat**: answers what‑ifs using **recent transactions as context** (mock adapter in MVP)  
- **Localization‑ready**: strings in `Localizable.strings`; **currency/dates respect device locale**  
- **Accessibility**: VoiceOver labels, **monospaced digits** for amounts, sensible contrast  
- **Dependency injection** at the app boundary to keep external services **easy to swap**

---

## Architecture

The project keeps the **domain stable** and **IO details swappable** through well‑defined layers:

- **Domain models**  
  Plain Swift types describing the problem space (**`Account`**, **`Transaction`**, **`CashFlowPoint`**). No SDK dependencies.

- **Ports (protocols)**  
  **Interfaces** that define capabilities and contracts (**`BankAdapter`**, **`ChatAdapter`**, **`AccountRepository`**, **`TransactionRepository`**). They specify **what** the app needs, not **how** to do it.

- **Adapters**  
  **Concrete implementations** of ports for specific sources. The MVP includes **mock adapters** (seed JSON and simulated chat). Production integrations (**Plaid**, **OpenAI**) can replace these **without UI changes**.

- **Repositories and cache**  
  Repositories **orchestrate data** and **hide IO** behind app‑facing methods. A small **actor‑based in‑memory store** provides **thread‑safe, cache‑first** reads. ViewModels depend on **repositories**, not raw adapters.

- **Use cases**  
  Encapsulated **business logic**. The **forecast use case** computes day‑by‑day balance points from recent cash‑flow patterns. It can be replaced by bill‑aware or seasonal models **without touching UI**.

- **MVVM Views**  
  SwiftUI views remain **thin**. ViewModels expose **published state** (loading, errors, balances, category totals, forecast points); views **render that state**. Screens include **Dashboard**, **Forecast Chart**, and **Chat**.

- **Composition root**  
  A single place to **assemble and inject** concrete implementations (for example, in app entry or a small **AppDependency**). Swapping mocks for production adapters happens **here**.

---

## Project Structure (example)

```
Forecast/
├─ App/
│  ├─ ForecastApp.swift
│  └─ MainTabView.swift                 # Composition root (mocks injected here)
├─ Domain/
│  ├─ Models/                           # Account, Transaction, CashFlowPoint
│  ├─ Interfaces/                       # Ports: Adapters, Repositories
│  └─ UseCases/                         # ForecastUseCase
├─ Data/
│  ├─ Adapters/                         # MockBankAdapter, MockChatAdapter
│  ├─ Persistence/                      # TransactionStore, InMemoryTransactionStore
│  └─ Repositories/                     # TransactionRepositoryImpl, MockAccountRepository
├─ Features/
│  ├─ Dashboard/                        # DashboardViewModel + Views (DashboardView, ForecastChart)
│  └─ Chat/                             # ChatViewModel + ChatView
├─ Resources/
│  ├─ Seeds/                            # transactions.json, accounts.json
│  └─ Localizable.strings               # Localization (en and others)
└─ Tests/                               # Unit tests
```

---

## Localization and Accessibility

- **Currency and date formatting** use system formatters and respect the user’s locale.  
- Static strings live in **`Localizable.strings`**.  
- **VoiceOver labels** are provided for key UI elements and transaction semantics.  
- Monetary values use **monospaced digits** for readability.

---

## Getting Started

**Requirements**  
- Xcode 15 or newer  
- iOS 17 or newer

**Run**  
1. Open the project in Xcode.  
2. Select an iOS Simulator.  
3. Build and run.  

The app starts with **seed accounts and transactions** via **mock adapters**. Tabs include **Home** (Overview and Charts), **AI Chat**, and **Settings**.

---

## Swapping Mocks for Real Services

- **Bank (Plaid)**  
  Implement a concrete **`BankAdapter`** that uses **Plaid Link** and a secure token flow. Replace the mock adapter in the **composition root**.

- **Chat (LLM)**  
  Implement a concrete **`ChatAdapter`** for your LLM or backend. Replace the mock adapter in the **composition root**.

No ViewModel or View changes are required. Only the bindings in the composition root change.

---

## Roadmap

- Integrate **Plaid Link** and secure token exchange  
- Replace mock chat with a **production LLM adapter** and prompt grounded by categorized transactions  
- Introduce **persistent storage** by swapping the in‑memory store for a local database  
- Evolve the forecast to a **bill‑aware** model with monthly anchors and seasonality  
- Add additional charts such as **category trends** and **anomaly highlights**

---
