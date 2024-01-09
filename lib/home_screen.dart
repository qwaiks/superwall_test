import 'package:flutter/material.dart';
import 'package:test_superwall_app/components/textfield.dart';
import 'package:test_superwall_app/purchases/purchases_constant.dart';
import 'package:test_superwall_app/purchases/purchases_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _paywallNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final purchases = PurchasesService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                await purchases.viewPaywall(
                    paywall: PurchasesPaywall.profilePremium);
              },
              child: const Text("Show paywall"),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () async {
                await showDialog<void>(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Load Paywall',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                CustomTextField(
                                  controller: _paywallNameController,
                                  title: 'Paywall name',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a paywall name';
                                    }
                                    return null;
                                  },
                                  hintText: 'Enter Paywall name',
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                ElevatedButton(
                                  child: const Text('Load Paywall'),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      await purchases.viewPaywall(
                                          paywall: _paywallNameController.text);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              child: const Text(
                "Load Paywall",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
