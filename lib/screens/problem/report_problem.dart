import 'package:chalet/config/functions/dissmis_focus.dart';
import 'package:chalet/models/problem_model.dart';
import 'package:chalet/models/user_model.dart';
import 'package:chalet/screens/index.dart';
import 'package:chalet/services/problem_service.dart';
import 'package:chalet/styles/dimentions.dart';
import 'package:chalet/styles/input_decoration.dart';
import 'package:chalet/widgets/custom_appBars.dart';
import 'package:chalet/widgets/custom_elevated_button.dart';
import 'package:chalet/widgets/vertical_sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class ReportProblem extends StatefulWidget {
  const ReportProblem({Key? key}) : super(key: key);

  @override
  _ReportProblemState createState() => _ReportProblemState();
}

class _ReportProblemState extends State<ReportProblem> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ProblemModel _problem =
      ProblemModel(chaletId: '', userId: '', chaletName: '', problemDescription: '', isSolved: false);
  bool _isCreateProblemButtonActive = true;

  Future<void> _createProblem() async {
    setState(() => _isCreateProblemButtonActive = false);
    if (_formKey.currentState!.validate()) {
      try {
        EasyLoading.show(status: '', maskType: EasyLoadingMaskType.black);
        await ProblemService().createProblem(_problem);
        EasyLoading.dismiss();
        EasyLoading.showSuccess('Zgłoszenie przyjęto');
        Navigator.pop(context);
      } catch (e) {
        print(e);
        EasyLoading.dismiss();
        EasyLoading.showError(e.toString());
      }
    }
    setState(() => _isCreateProblemButtonActive = true);
  }

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)!.settings.arguments as ReportProblemArgs;
    setState(() {
      _problem.chaletId = args.chaletId;
      _problem.chaletName = args.chaletName;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserModel?>(context);
    if (user != null) _problem.userId = user.uid;
    return GestureDetector(
      onTap: () => dissmissCurrentFocus(context),
      child: Scaffold(
        appBar: CustomAppBars.customAppBarChaletBlue(context, 'Zgłoś problem'),
        body: Padding(
          padding: const EdgeInsets.all(Dimentions.horizontalPadding),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'Opisz nam problem z Szaletem',
                  style: Theme.of(context).textTheme.headline3?.copyWith(fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
                VerticalSizedBox24(),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                      hintText:
                          'Czynny w innych godzinach? Zły adres? Nie można znaleźć szaletu? Informacje są nie jasne?'),
                  minLines: 3,
                  maxLines: 4,
                  validator: (val) => val!.isEmpty ? 'To pole jest obowiązkowe' : null,
                  onChanged: (val) => setState(() => _problem.problemDescription = val),
                ),
                VerticalSizedBox24(),
                CustomElevatedButton(
                  label: 'Zgłoś problem',
                  onPressed: _isCreateProblemButtonActive ? _createProblem : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
