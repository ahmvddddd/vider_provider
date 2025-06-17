import 'package:flutter/material.dart';

import '../../../utils/helpers/helper_function.dart';

class TermsAndConditionsDialog extends StatelessWidget {
  const TermsAndConditionsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunction.isDarkMode(context);
    return AlertDialog(
      backgroundColor: dark ? Colors.black : Colors.white,
      title: const Text('Terms and Conditions'),
      content: SizedBox(
        height: 400,
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Text('''
1. Eligibility
You must be at least 18 years old and capable of entering into a binding contract.

2. Account Registration
Provide accurate and up-to-date info, and secure your credentials.

3. Platform Use
Use Vider lawfully. No spam, fraud, or abuse.

4. Freelancer & Client Responsibilities
Freelancers: Deliver on time and communicate.
Clients: Provide clear requirements and make timely payments.

5. Payments and Fees
Fees apply. Payments are processed securely. Non-refundable unless stated.

6. Dispute Resolution
Try to resolve disputes directly. Contact support if needed.

7. Termination
Accounts may be suspended for violations or fraud.

8. Intellectual Property
Our content is protected. Don not copy or misuse it.

9. Changes
We may update these terms anytime. Continued use = acceptance.

10. Contact
Email: vider_support@gmail.com

By signing up, you agree to these terms.
''', style: Theme.of(context).textTheme.bodySmall),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child:  Text('Close',
          style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.red)),
        ),
      ],
    );
  }
}
