import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const ExpensesHomePage(),
    );
  }
}

// ─────────────────────────────────────────────
//  EXPENSE MODEL
// ─────────────────────────────────────────────

class Expense {
  final String id;
  String title;
  double amount;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
  });
}

// ─────────────────────────────────────────────
//  SCREEN 1: ExpensesHomePage
// ─────────────────────────────────────────────

class ExpensesHomePage extends StatefulWidget {
  const ExpensesHomePage({super.key});

  @override
  State<ExpensesHomePage> createState() => _ExpensesHomePageState();
}

class _ExpensesHomePageState extends State<ExpensesHomePage> {
  // Dummy initial items
  final List<Expense> _expenses = [
    Expense(id: '1', title: 'Groceries', amount: 850.00),
    Expense(id: '2', title: 'Transport', amount: 120.00),
    Expense(id: '3', title: 'Dinner', amount: 450.00),
  ];

  double get _totalAmount =>
      _expenses.fold(0.0, (sum, e) => sum + e.amount);

  // ── NAVIGATE TO ADD ──
  void _goToAddExpense() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditExpensePage(),
      ),
    );

    if (result != null && result is Expense) {
      setState(() {
        _expenses.add(result);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added: ${result.title}'),
            backgroundColor: Colors.indigo,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // ── NAVIGATE TO EDIT ──
  void _goToEditExpense(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditExpensePage(
          expenseToEdit: _expenses[index],
        ),
      ),
    );

    if (result != null && result is Expense) {
      setState(() {
        _expenses[index].title = result.title;
        _expenses[index].amount = result.amount;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Updated: ${result.title}'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // ── DELETE ──
  void _deleteExpense(int index) {
    setState(() {
      _expenses.removeAt(index);
    });
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
            SizedBox(width: 8),
            Text('Delete Expense'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete "${_expenses[index].title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deleteExpense(index);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Expense Tracker',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            onPressed: _goToAddExpense,
            icon: const Icon(Icons.add_circle_outline),
            tooltip: '+ Add Expense',
          ),
        ],
      ),
      body: _expenses.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No expenses yet.',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap "Add" to record your first expense.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // ── Summary Card ──
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 18),
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Expenses',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_expenses.length} item${_expenses.length == 1 ? '' : 's'}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Total Amount',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₱${_totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Expense List ──
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _expenses.length,
                    itemBuilder: (context, index) {
                      final expense = _expenses[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          // Number avatar
                          leading: CircleAvatar(
                            backgroundColor: Colors.indigo.shade100,
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Colors.indigo,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // Title + amount
                          title: Text(
                            expense.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            '₱${expense.amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.indigo.shade400,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          // Edit + Delete buttons
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Edit button
                              IconButton(
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: Colors.indigo,
                                ),
                                tooltip: 'Edit',
                                onPressed: () => _goToEditExpense(index),
                              ),
                              // Delete button
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.redAccent,
                                ),
                                tooltip: 'Delete',
                                onPressed: () => _confirmDelete(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToAddExpense,
        icon: const Icon(Icons.add),
        label: const Text(
          'Added Expenses',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        foregroundColor: Colors.white,
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  SCREEN 2: AddEditExpensePage (Add + Edit)
// ─────────────────────────────────────────────

class AddEditExpensePage extends StatefulWidget {
  final Expense? expenseToEdit;

  const AddEditExpensePage({super.key, this.expenseToEdit});

  @override
  State<AddEditExpensePage> createState() => _AddEditExpensePageState();
}

class _AddEditExpensePageState extends State<AddEditExpensePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _titleFocus = FocusNode();

  String? _titleError;
  String? _amountError;
  bool _isSaving = false;

  bool get _isEditMode => widget.expenseToEdit != null;

  @override
  void initState() {
    super.initState();

    // Pre-fill fields if editing
    if (_isEditMode) {
      _titleController.text = widget.expenseToEdit!.title;
      _amountController.text =
          widget.expenseToEdit!.amount.toStringAsFixed(2);
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      _titleFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _titleFocus.dispose();
    super.dispose();
  }

  // ── VALIDATION & SAVE ──
  void _saveExpense() {
    final title = _titleController.text.trim();
    final amountText = _amountController.text.trim();
    final amount = double.tryParse(amountText);

    bool hasError = false;

    // Validate title
    if (title.isEmpty) {
      setState(() => _titleError = 'Title cannot be empty.');
      hasError = true;
    } else {
      setState(() => _titleError = null);
    }

    // Validate amount
    if (amountText.isEmpty) {
      setState(() => _amountError = 'Amount cannot be empty.');
      hasError = true;
    } else if (amount == null || amount <= 0) {
      setState(() => _amountError = 'Enter a valid amount greater than 0.');
      hasError = true;
    } else {
      setState(() => _amountError = null);
    }

    if (hasError) return;

    setState(() => _isSaving = true);

    // Build result Expense object
    final result = Expense(
      id: _isEditMode
          ? widget.expenseToEdit!.id
          : DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      amount: amount!,
    );

    Future.delayed(const Duration(milliseconds: 200), () {
      Navigator.pop(context, result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          _isEditMode ? 'Edit Expense' : 'Add Expense',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),

            // ── Info Banner ──
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.indigo.shade100),
              ),
              child: Row(
                children: [
                  Icon(
                    _isEditMode
                        ? Icons.edit_note_outlined
                        : Icons.info_outline,
                    color: Colors.indigo.shade400,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _isEditMode
                          ? 'Edit the fields below and tap Save to update.'
                          : 'Fill in the details below and tap Save.',
                      style: TextStyle(
                          color: Colors.indigo.shade700, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── Title Field ──
            const Text(
              'Expense Title',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              focusNode: _titleFocus,
              decoration: InputDecoration(
                hintText: 'e.g. Groceries, Transport, Dinner...',
                errorText: _titleError,
                filled: true,
                fillColor: Colors.white,
                prefixIcon:
                    const Icon(Icons.receipt_long, color: Colors.indigo),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: Colors.indigo, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: Colors.redAccent, width: 2),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: Colors.redAccent, width: 2),
                ),
              ),
              onChanged: (_) {
                if (_titleError != null) {
                  setState(() => _titleError = null);
                }
              },
              textInputAction: TextInputAction.next,
            ),

            const SizedBox(height: 20),

            // ── Amount Field ──
            const Text(
              'Amount (₱)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: 'e.g. 150.00',
                errorText: _amountError,
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.payments_outlined,
                    color: Colors.indigo),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: Colors.indigo, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: Colors.redAccent, width: 2),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: Colors.redAccent, width: 2),
                ),
              ),
              onChanged: (_) {
                if (_amountError != null) {
                  setState(() => _amountError = null);
                }
              },
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _saveExpense(),
            ),

            const SizedBox(height: 36),

            // ── Save Button ──
            ElevatedButton.icon(
              onPressed: _isSaving ? null : _saveExpense,
              icon: _isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(_isEditMode ? Icons.update : Icons.save_alt),
              label: Text(
                _isSaving
                    ? 'Saving...'
                    : _isEditMode
                        ? 'Update Expense'
                        : 'Save Expense',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.indigo.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
              ),
            ),

            const SizedBox(height: 12),

            // ── Cancel Button ──
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
              label: const Text(
                'Cancel',
                style: TextStyle(fontSize: 16),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                foregroundColor: Colors.indigo,
                side: const BorderSide(color: Color.fromARGB(255, 84, 22, 33)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}