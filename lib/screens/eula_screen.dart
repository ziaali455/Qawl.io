import 'package:first_project/screens/user_setup_page_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';


class AgreementScreen extends StatelessWidget {
  const AgreementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Terms and Conditions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Please read and accept the terms and conditions to proceed.',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                height: 200.0, // Adjust height as needed
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    eulaText
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, 
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => UserSetupPage()),
                );
              },
              child: const Text('Accept'),
            ),
          ],
        ),
      ),
    );
  }
}
const String eulaText = '''
End User License Agreement (EULA) for Qawl

Effective Date: 7/22/24

This End User License Agreement ("EULA") is a legal agreement between you ("User" or "You") and Qawl ("App" or "We" or "Us"). By installing, accessing, or using the Qawl App, you agree to be bound by the terms of this EULA. If you do not agree to these terms, do not install, access, or use the Qawl App.

1. No Tolerance for Objectionable Content

Qawl strictly prohibits the creation, sharing, or promotion of objectionable content within the App. Objectionable content includes, but is not limited to, content that:

- Promotes violence or harm.
- Contains hate speech or discriminatory language.
- Involves harassment or bullying.
- Contains sexually explicit material.
- Promotes illegal activities.

2. No Tolerance for Abusive Users

Qawl has zero tolerance for abusive users. Abusive behavior includes, but is not limited to:

- Harassment or bullying of other users.
- Sending or sharing threatening messages.
- Impersonation of others with intent to deceive.
- Engaging in any form of abusive or harmful conduct.

3. Reporting and Investigation

Users are encouraged to report the users posting any content or behavior that violates this EULA. Reports can be made through the App's reporting feature denoted by the Flag icon or by contacting our support team directly.

Upon receiving a report, the Qawl team will:

1. Review the report and any provided evidence.
2. Investigate the reported content or behavior.
3. Take appropriate action based on the findings.

4. Termination of Accounts

If the Qawl team finds evidence of abuse or harassment, the following actions will be taken:

1. The offending User's account will be immediately terminated.
2. The User will be permanently banned from using the App.
3. Any attempt to create a new account will be considered a violation of this EULA and will result in immediate termination.

5. No Appeal Process

Decisions made by the Qawl team regarding the termination of accounts for objectionable content or abusive behavior are final. There is no appeal process for Users whose accounts have been terminated under these conditions.

6. Amendments to EULA

Qawl reserves the right to modify this EULA at any time. Changes will be effective immediately upon being posted within the App or on our website. Your continued use of the App constitutes your acceptance of any modified terms.

7. Contact Information

For any questions or concerns regarding this EULA, please contact us at:

Email: qawlapp@gmail.com 
Address: 70 Morningside Drive New York NY 10027

By using Qawl, you acknowledge that you have read, understood, and agree to be bound by this EULA.

---

Ali Zia 
CEO
7/22/24

---

This EULA is a legally binding agreement. Violation of any terms may result in the termination of your account and legal action where applicable.

---

Ali Zia/Qawl
All rights reserved.

---
''';
