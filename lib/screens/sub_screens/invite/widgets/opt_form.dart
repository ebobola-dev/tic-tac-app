import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_app/bloc/otp_form/otp_form_bloc.dart';
import 'package:tic_tac_app/bloc/otp_form/otp_form_event.dart';
import 'package:tic_tac_app/bloc/otp_form/otp_form_state.dart';

class OtpForm extends StatefulWidget {
  const OtpForm({Key? key}) : super(key: key);

  @override
  State<OtpForm> createState() => OtpFormWidgetState();
}

class OtpFormWidgetState extends State<OtpForm> {
  late final FocusNode firstDigitFocusNode;
  final _numb1 = TextEditingController();
  final _numb2 = TextEditingController();
  final _numb3 = TextEditingController();
  final _numb4 = TextEditingController();

  @override
  void initState() {
    firstDigitFocusNode = FocusNode();
    _numb1.text = context.read<OtpFormBloc>().state.code[0]?.toString() ?? '';
    _numb2.text = context.read<OtpFormBloc>().state.code[1]?.toString() ?? '';
    _numb3.text = context.read<OtpFormBloc>().state.code[2]?.toString() ?? '';
    _numb4.text = context.read<OtpFormBloc>().state.code[3]?.toString() ?? '';
    super.initState();
  }

  @override
  void dispose() {
    firstDigitFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final otpBloc = context.read<OtpFormBloc>();
    return BlocListener<OtpFormBloc, OtpFormState>(
      listener: (context, state) {
        if (state.clean) {
          _numb1.clear();
          _numb2.clear();
          _numb3.clear();
          _numb4.clear();
        }
      },
      child: Form(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 68,
              width: 64,
              child: TextFormField(
                focusNode: firstDigitFocusNode,
                controller: _numb1,
                onChanged: (value) {
                  if (value.length == 1) {
                    FocusScope.of(context).nextFocus();
                  }
                  otpBloc.add(OtpFormChangeEvent(0, int.tryParse(value)));
                },
                style: Theme.of(context).textTheme.headline6,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            SizedBox(
              height: 68,
              width: 64,
              child: TextFormField(
                controller: _numb2,
                onChanged: (value) {
                  if (value.length == 1) {
                    FocusScope.of(context).nextFocus();
                  }
                  otpBloc.add(OtpFormChangeEvent(1, int.tryParse(value)));
                },
                style: Theme.of(context).textTheme.headline6,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            SizedBox(
              height: 68,
              width: 64,
              child: TextFormField(
                controller: _numb3,
                onChanged: (value) {
                  if (value.length == 1) {
                    FocusScope.of(context).nextFocus();
                  }
                  otpBloc.add(OtpFormChangeEvent(2, int.tryParse(value)));
                },
                style: Theme.of(context).textTheme.headline6,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            SizedBox(
              height: 68,
              width: 64,
              child: TextFormField(
                controller: _numb4,
                onChanged: (value) {
                  otpBloc.add(OtpFormChangeEvent(3, int.tryParse(value)));
                },
                style: Theme.of(context).textTheme.headline6,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
