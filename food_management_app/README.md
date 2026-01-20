# Food Management Module

## Overview
This is a Flutter application for the "Food Management" module. It allows users to manage meal plans, view daily menus, track meal attendance, and collect feedback.

## Project Structure
The project follows a **Clean Architecture** approach:
- **lib/data**: Contains data models and repositories.
  - `models/`: Dart Data Classes (mapped from JSON).
  - `repositories/`: `FoodRepository` handles data fetching from the mock JSON file.
- **lib/state**: Contains business logic using BLoC.
  - `bloc/`: Blocs for different features (MealPlan, Menu, Attendance, Feedback).
- **lib/presentation**: Contains UI code.
  - `screens/`: Application screens.
  - `widgets/`: Reusable widgets.
- **lib/main.dart**: Application entry point and Dependency Injection.

## State Management
**BLoC (Business Logic Component)** was chosen as the state management solution.
- **Why BLoC?**
  - **Separation of Concerns**: UI is strictly separated from business logic.
  - **Scalability**: BLoC scales well for complex enterprise applications.
  - **Testability**: Events and States make unit testing straightforward.
  - **Predictability**: Unidirectional data flow ensures predictable application state.

## Implementation Details
- **Mock API**: Data is loaded from `lib/data/mock/meal_plans.json`.
- **UI/UX**: Designed to match the provided Figma reference with a dark theme aesthetic.
- **Data Flow**: `Repository` -> `Bloc` -> `UI`.

## Features
1.  **Meal Plans**: View existing plans, Add new plans (Mock save).
2.  **Daily Menu**: View today's menu items.
3.  **Meal Track**: Track attendance for meals.
4.  **Feedback**: View user feedback.

## Known Issues & Limitations
- **Data Persistence**: Since the data source is a static JSON file in the assets, "adding" a plan or "saving" edits does not persist across app restarts. The "Save" actions are mocked to show success UI.
- **Set Plan Detail**: The "Set Plan" screen is simplified to show time configuration and meal types without full item selection logic due to time constraints, but the UI structure is in place.

## How to Run
1.  Ensure Flutter is installed (Min 3.38.1).
2.  Run `flutter pub get`.
3.  Run `flutter run`.
