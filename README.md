# Flutter Stripe Payment

A Flutter application demonstrating secure payment integration with Stripe. This project showcases how to implement payment processing functionality in a Flutter app with proper security practices and environment configuration.

## Features

- 🔐 Secure Stripe payment integration
- 📱 Cross-platform support (Android, iOS, Web, Desktop)
- 🌟 Modern Flutter UI with Material Design
- 🔑 Environment-based configuration
- 💳 Card payment processing
- ✅ Payment success/failure handling

## Prerequisites

Before running this project, make sure you have:

- Flutter SDK (3.0 or higher) - [Install Flutter](https://flutter.dev/docs/get-started/install)
- Dart SDK
- A Stripe account - [Sign up for Stripe](https://dashboard.stripe.com/register)
- An IDE (VS Code, Android Studio, or IntelliJ IDEA)

## Setup Instructions

### 1. Clone the Repository

```bash
git clone <your-repository-url>
cd flutter_stripe_payment
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Environment Configuration

**IMPORTANT**: Create a `.env` file in the root directory of the project and add your Stripe keys:

```bash
# Create .env file in the root directory
touch .env
```

Add the following content to your `.env` file:

```env
STRIPE_PUBLISHABLE_KEY=pk_test_your_publishable_key_here
STRIPE_SECRET_KEY=sk_test_your_secret_key_here
```

⚠️ **Security Notes:**

- Never commit your `.env` file to version control
- Use test keys during development
- Keep your secret key secure and never expose it in client-side code
- Add `.env` to your `.gitignore` file

### 4. Get Your Stripe Keys

1. Log in to your [Stripe Dashboard](https://dashboard.stripe.com/)
2. Navigate to **Developers > API keys**
3. Copy your **Publishable key** (starts with `pk_test_`)
4. Copy your **Secret key** (starts with `sk_test_`)
5. Replace the placeholder values in your `.env` file

### 5. Platform-specific Setup

#### Android Setup

- Minimum SDK version: 21
- The project is already configured for Android

#### iOS Setup

- iOS 11.0 or higher
- The project includes necessary iOS configurations

## How to Run the Project

### 1. Check Flutter Installation

```bash
flutter doctor
```

### 2. Run on Different Platforms

#### Android

```bash
# Connect an Android device or start an emulator
flutter run --flavor development --target lib/main.dart
```

#### iOS (macOS only)

```bash
# Connect an iOS device or start a simulator
flutter run --flavor development --target lib/main.dart
```

#### Web

```bash
flutter run -d chrome
```

#### Desktop (Linux/macOS/Windows)

```bash
# Linux
flutter run -d linux

# macOS
flutter run -d macos

# Windows
flutter run -d windows
```

### 3. Development Mode

For hot reload during development:

```bash
flutter run --debug
```

### 4. Release Build

```bash
# Android APK
flutter build apk --release

# iOS (macOS only)
flutter build ios --release

# Web
flutter build web --release
```

## Project Structure

```
lib/
├── main.dart              # App entry point
├── app.dart              # App configuration
└── presentation/
    └── home_screen.dart   # Main UI screen

android/                   # Android platform code
ios/                      # iOS platform code
web/                      # Web platform code
linux/                    # Linux platform code
macos/                    # macOS platform code
windows/                  # Windows platform code
test/                     # Unit and widget tests
```

## Usage

1. **Launch the app** using the run commands above
2. **Enter payment details** in the payment form
3. **Process payment** by tapping the payment button
4. **View results** - success or error messages will be displayed

## Testing

### Run Unit Tests

```bash
flutter test
```

### Run Integration Tests

```bash
flutter test integration_test/
```

### Test with Stripe Test Cards

Use these test card numbers in development:

- **Successful payment**: `4242424242424242`
- **Declined payment**: `4000000000000002`
- **Insufficient funds**: `4000000000009995`

## Troubleshooting

### Common Issues

1. **Environment variables not loading**

   - Ensure `.env` file is in the root directory
   - Check that your keys are properly formatted
   - Restart the app after adding environment variables

2. **Build errors**

   - Run `flutter clean` and `flutter pub get`
   - Check that all dependencies are compatible

3. **Platform-specific issues**
   - Ensure minimum SDK requirements are met
   - Check platform-specific configurations

### Getting Help

If you encounter issues:

1. Check the [Flutter documentation](https://flutter.dev/docs)
2. Review [Stripe documentation](https://stripe.com/docs)
3. Open an issue in this repository

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Security

- Never commit sensitive data (API keys, secrets) to version control
- Use environment variables for configuration
- Always use HTTPS in production
- Validate all inputs on both client and server side
- Follow Stripe's security best practices
