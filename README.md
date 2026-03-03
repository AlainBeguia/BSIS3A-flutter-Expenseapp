# expense_app
# Short Note
This app uses imperative navigation with Navigator.push() and Navigator.pop() methods. The list screen pushes the Add/Edit screen onto the navigation stack and waits for an Expense object to be returned using async/await, making it simple to pass data back without needing a shared state manager. The AddEditExpensePage is reused for both adding and editing by passing an optional expenseToEdit parameter if it is null, the screen runs in Add mode; otherwise, it pre-fills the fields with the existing expense data for editing. This approach was chosen because the app only has two screens with a straightforward parent-child relationship, making imperative navigation more than sufficient without the added complexity of named routes or a routing package like GoRouter.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
