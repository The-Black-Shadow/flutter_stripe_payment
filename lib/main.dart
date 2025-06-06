import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_stripe_payment/app.dart';

void main() async {
  // Ensure that Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  //Initialize Stripe with  publishable key
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;
  // It's good practice to set the URL scheme for deep linking
  await Stripe.instance.applySettings();
  runApp(const MyApp());
}
