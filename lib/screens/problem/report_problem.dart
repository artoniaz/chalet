import 'package:Challet/blocs/problem/problem_bloc.dart';
import 'package:Challet/blocs/problem/problem_event.dart';
import 'package:Challet/blocs/problem/problem_state.dart';
import 'package:Challet/blocs/user_data/user_data_bloc.dart';
import 'package:Challet/config/functions/dissmis_focus.dart';
import 'package:Challet/models/problem_model.dart';
import 'package:Challet/models/user_model.dart';
import 'package:Challet/screens/index.dart';
import 'package:Challet/styles/dimentions.dart';
import 'package:Challet/styles/input_decoration.dart';
import 'package:Challet/widgets/custom_appBars.dart';
import 'package:Challet/widgets/custom_elevated_button.dart';
import 'package:Challet/widgets/vertical_sized_boxes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class ReportProblem extends StatefulWidget {
  const ReportProblem({Key? key}) : super(key: key);

  @override
  _ReportProblemState createState() => _ReportProblemState();
}

class _ReportProblemState extends State<ReportProblem> {
  late ProblemBloc _problemBloc;
  late UserModel? _user;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ProblemModel _problem = ProblemModel(
    chaletId: '',
    userId: '',
    chaletName: '',
    problemDescription: '',
    isSolved: false,
    created: Timestamp.now(),
  );

  void _createProblem() {
    if (_formKey.currentState!.validate()) {
      if (_user != null) _problem.userId = _user!.uid;
      _problemBloc.add(CreateProblem(_problem));
    }
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
  void initState() {
    _problemBloc = Provider.of<ProblemBloc>(context, listen: false);
    _user = context.read<UserDataBloc>().state.props.first as UserModel;

    super.initState();
  }

  @override
  void dispose() {
    _problemBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProblemBloc, ProblemState>(
        bloc: _problemBloc,
        listener: (context, state) {
          if (state is ProblemStateLoaded) {
            EasyLoading.showSuccess('Zgłoszenie przyjęto');
            Navigator.pop(context);
          } else if (state is ProblemStateError) {
            EasyLoading.showError(state.errorMessage);
          }
        },
        builder: (context, state) {
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
                        onPressed: state is ProblemStateLoading ? null : _createProblem,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
