import 'package:flutter_test/flutter_test.dart';
import 'package:tmail_ui_user/features/composer/presentation/composer_view.dart';

import '../base/base_scenario.dart';
import '../robots/composer_robot.dart';
import '../robots/thread_robot.dart';
import 'login_with_basic_auth_scenario.dart';

class SendEmailScenario extends BaseScenario {
  const SendEmailScenario(
    super.$, 
    {
      required this.loginWithBasicAuthScenario,
      required this.additionalRecipient,
      required this.subject,
      required this.content
    }
  );

  final LoginWithBasicAuthScenario loginWithBasicAuthScenario;
  final String additionalRecipient;
  final String subject;
  final String content;

  @override
  Future<void> execute() async {
    final threadRobot = ThreadRobot($);
    final composerRobot = ComposerRobot($);

    await loginWithBasicAuthScenario.execute();

    await threadRobot.openComposer();
    await _expectComposerViewVisible();

    await composerRobot.grantContactPermission();

    await composerRobot.addRecipient(loginWithBasicAuthScenario.email);
    await composerRobot.addRecipient(additionalRecipient);
    await composerRobot.addSubject(subject);
    await composerRobot.addContent(content);
    await composerRobot.sendEmail();

    await _expectSendEmailSuccessToast();
  }
  
  Future<void> _expectComposerViewVisible() => expectViewVisible($(ComposerView));

  Future<void> _expectSendEmailSuccessToast() async {
    expect($('Message has been sent successfully'), findsOneWidget);
  }
}