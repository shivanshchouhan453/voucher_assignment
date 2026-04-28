# Voucher App

A Flutter application for purchasing vouchers with dynamic pricing, multiple payment methods, and real-time discount calculations.

## 📱 Application Screenshots

| Screen 1 | Screen 2 |
|----------|----------|
| ![Screenshot 1](assets/app_screenshots/Screenshot%202026-04-28%20151717.png) | ![Screenshot 2](assets/app_screenshots/Screenshot%202026-04-28%20151732.png) |

## 🔗 GitHub Repository

**Repository Link:** [Add your GitHub repository link here]

Replace the above link with your actual GitHub repository URL.

## 📋 Project Overview

This application demonstrates a complete voucher purchasing flow with:
- Dynamic amount selection with min/max validation
- Multiple payment method options (UPI, Credit Card, Debit Card)
- Real-time discount and savings calculations
- Quantity selection
- Responsive UI with smooth animations

## 🏗️ State Management Architecture

**Architecture Pattern:** Repository → State → UI

This app uses **Riverpod** with **StateNotifier** pattern:
- **Repository Layer:** `VoucherRepositoryImpl` fetches voucher data from data source
- **State Layer:** `VoucherNotifier` manages state updates and business logic; `VoucherState` holds UI state (voucher, amount, quantity, selectedMethod)
- **UI Layer:** `VoucherScreen` (ConsumerStatefulWidget) observes state changes via `ref.watch(voucherProvider)` and triggers updates through `ref.read(voucherProvider.notifier)`

The data flows unidirectionally: Repository fetches data → State manages it → UI reflects changes reactively.

## 🔘 Pay Button Enable/Disable Handling

The Pay button's enabled/disabled state is controlled by:

1. **`disablePurchase` Flag:** Retrieved from the voucher data, this boolean flag determines if purchases are allowed
2. **`isPayEnabled` Getter:** Implements the logic `!(state.voucher?.disablePurchase ?? true)` - button is enabled only when voucher's `disablePurchase` is `false`
3. **Amount Validation:** Even if `isPayEnabled` is true, the button is only clickable (`canPay`) when the entered amount is valid (between min and max)
4. **Button States:**
   - ✅ **Enabled:** When voucher is available AND amount is valid → shows "Pay ₹{amount} ✨"
   - ❌ **Disabled with invalid amount:** When amount is out of range → shows "Enter a valid amount"
   - ❌ **Disabled with unavailable voucher:** When `disablePurchase` is true → shows "Voucher unavailable"

## ✨ Key Features

- **Real-time Discount Calculation:** Discounts update instantly based on selected payment method
- **Amount Validation:** Min and max amount constraints enforced
- **Quantity Management:** Increase/decrease voucher quantity
- **Multiple Payment Methods:** UPI, Credit Card, Debit Card with different discount percentages
- **Responsive Design:** Optimized for various screen sizes

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest version)
- Dart SDK
- Android Studio or Xcode (for mobile development)

### Installation

1. Clone the repository:
```bash
git clone [your-github-repository-link]
cd voucher_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## 📦 Dependencies

- `flutter_riverpod`: State management
- Other dependencies are listed in [pubspec.yaml](pubspec.yaml)

## 🧪 Testing

Run tests with:
```bash
flutter test
```

## 📚 Resources

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Riverpod Documentation](https://riverpod.dev)
- [Flutter Documentation](https://docs.flutter.dev/)

## 📝 License

This project is licensed under the MIT License.

---

**Project Status:** ✅ Ready for submission

**Note:** Ensure project runs without errors by executing `flutter run` before submission.
