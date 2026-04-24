# Sovereign Ledger (Expense Tracker App)

Sovereign Ledger is a powerful, locally-first personal finance and expense tracking application built with Flutter. It helps users manage their finances by providing robust transaction tracking, visual budgeting features, and an intuitive dashboard to monitor wealth and spending trends.

## Features

*   **Dynamic Dashboard:** Get a bird's-eye view of your Liquid Wealth Portfolio, recent transactions, and weekly spending trends.
*   **Budget Allocations:** Set dynamic spending limits for different categories (Food, Travel, Subscriptions, Utilities, etc.) and visually track your remaining balances.
*   **Transaction Management:** Easily log income and expenses with smart input formatting, categorization, and notes.
*   **Insightful Analytics:** Visualize your spending velocity and view detailed breakdowns of your financial habits using dynamic line and bar charts.
*   **Security (Liveness Check):** Incorporates advanced liveness check flows to ensure security and user authenticity.
*   **Local Persistence:** Fully functional offline utilizing Hive for lightning-fast, secure local database storage.

## Tech Stack

*   **Framework:** Flutter
*   **State Management:** Riverpod
*   **Local Database:** Hive CE
*   **Data Visualization:** fl_chart
*   **Formatting:** intl (Currency and Date formatting)

## Architecture

The project strictly follows a feature-first architecture, separating logic, state, and UI to ensure a scalable and maintainable codebase:
*   `lib/features/`: Contains distinct feature modules (e.g., `dashoard`, `transaction`, `budgets`, `insights`, `liveness check`).
    *   `/controller`: Riverpod providers and state management logic.
    *   `/model`: Data models and Hive Type Adapters.
    *   `/service`: Core business logic and database interactions.
    *   `/view`: Main UI screens.
    *   `/widgets`: Reusable, feature-specific UI components.
*   `lib/utils/`: Centralized utilities, custom formatters (like the `ThousandsInputFormatter`), and global theme/color definitions (`AppColors`).
*   `lib/core/`: Core application configurations and database boxes initialization.

## Getting Started

1.  **Clone the repository.**
2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Run code generation** (if modifying Hive models):
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```
4.  **Run the app:**
    ```bash
    flutter run
    ```
