// home_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? paymentIntent;
  final TextEditingController amountController = TextEditingController();

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stripe Payment'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Enter Amount',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: const TextStyle(fontSize: 22),
              decoration: InputDecoration(
                labelText: 'Amount',
                hintText: 'e.g., 50.00',
                prefixIcon: const Icon(Icons.attach_money),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.deepPurple,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                if (amountController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter an amount')),
                  );
                  return;
                }
                await makePayment();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
              child: const Text(
                'Pay with Stripe',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent(amountController.text, 'USD');
      if (paymentIntent == null) {
        throw Exception('Failed to create payment intent.');
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          merchantDisplayName: 'Flutter Stripe Demo',
          style: ThemeMode.light,
        ),
      );

      await displayPaymentSheet();
    } on StripeConfigException catch (e) {
      debugPrint("Stripe Configuration Error: $e");
      // GUARD THE BUILDCONTEXT
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stripe is not configured correctly.')),
      );
    } catch (e, s) {
      debugPrint('Error making payment: $e\n$s');
      // GUARD THE BUILDCONTEXT
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();

      // GUARD THE BUILDCONTEXT
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 100.0),
              SizedBox(height: 10.0),
              Text("Payment Successful!"),
            ],
          ),
        ),
      );
      paymentIntent = null;
    } on StripeException catch (e) {
      debugPrint('Payment failed: ${e.error.localizedMessage}');
      // GUARD THE BUILDCONTEXT
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cancel, color: Colors.red, size: 100.0),
              SizedBox(height: 10.0),
              Text("Payment Failed"),
            ],
          ),
        ),
      );
    }
  }

  Future<Map<String, dynamic>?> createPaymentIntent(
    String amount,
    String currency,
  ) async {
    try {
      final calculatedAmount = (double.parse(amount) * 100).round().toString();
      Map<String, dynamic> body = {
        'amount': calculatedAmount,
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET_KEY']}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        debugPrint('Error creating payment intent: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Error creating payment intent: $e');
      return null;
    }
  }
}