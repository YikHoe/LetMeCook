import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
<<<<<<< Updated upstream

=======
>>>>>>> Stashed changes
import 'login_page_model.dart';
export 'login_page_model.dart';

class LoginPageWidget extends StatefulWidget {
  const LoginPageWidget({super.key});

  @override
  State<LoginPageWidget> createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPageWidget> {
  late LoginPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginPageModel());

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
<<<<<<< Updated upstream
        backgroundColor: Color(0xFFE0E3E7),
=======
        backgroundColor: Color(0xFFF1F4F8),
>>>>>>> Stashed changes
        appBar: AppBar(
          backgroundColor: Color(0xFFE59368),
          automaticallyImplyLeading: false,
          title: Align(
<<<<<<< Updated upstream
            alignment: AlignmentDirectional(0, 0),
=======
            alignment: AlignmentDirectional(0.0, 0.0),
>>>>>>> Stashed changes
            child: Text(
              'LetMeCook',
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontFamily: 'Inter Tight',
                    color: Colors.white,
<<<<<<< Updated upstream
                    fontSize: 22,
=======
                    fontSize: 22.0,
>>>>>>> Stashed changes
                    letterSpacing: 0.0,
                  ),
            ),
          ),
          actions: [],
          centerTitle: false,
<<<<<<< Updated upstream
          elevation: 2,
=======
          elevation: 2.0,
>>>>>>> Stashed changes
        ),
        body: SafeArea(
          top: true,
          child: Padding(
<<<<<<< Updated upstream
            padding: EdgeInsetsDirectional.fromSTEB(24, 24, 24, 24),
=======
            padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
>>>>>>> Stashed changes
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Login',
                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                          fontFamily: 'Inter Tight',
                          color: Colors.black,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Material(
                    color: Colors.transparent,
<<<<<<< Updated upstream
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
=======
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
>>>>>>> Stashed changes
                    ),
                    child: Container(
                      width: MediaQuery.sizeOf(context).width * 0.9,
                      decoration: BoxDecoration(
                        color: Colors.white,
<<<<<<< Updated upstream
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24, 24, 24, 24),
=======
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            24.0, 24.0, 24.0, 24.0),
>>>>>>> Stashed changes
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: _model.textController1,
                              focusNode: _model.textFieldFocusNode1,
                              autofocus: false,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Inter',
                                      color: Colors.black,
                                      letterSpacing: 0.0,
                                    ),
                                hintStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Inter',
<<<<<<< Updated upstream
                                      color: Colors.black,
=======
>>>>>>> Stashed changes
                                      letterSpacing: 0.0,
                                    ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFE0E3E7),
                                    width: 1.0,
                                  ),
<<<<<<< Updated upstream
                                  borderRadius: BorderRadius.circular(8),
=======
                                  borderRadius: BorderRadius.circular(8.0),
>>>>>>> Stashed changes
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1.0,
                                  ),
<<<<<<< Updated upstream
                                  borderRadius: BorderRadius.circular(8),
=======
                                  borderRadius: BorderRadius.circular(8.0),
>>>>>>> Stashed changes
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1.0,
                                  ),
<<<<<<< Updated upstream
                                  borderRadius: BorderRadius.circular(8),
=======
                                  borderRadius: BorderRadius.circular(8.0),
>>>>>>> Stashed changes
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1.0,
                                  ),
<<<<<<< Updated upstream
                                  borderRadius: BorderRadius.circular(8),
=======
                                  borderRadius: BorderRadius.circular(8.0),
>>>>>>> Stashed changes
                                ),
                                filled: true,
                                fillColor: Color(0xFFF1F4F8),
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .override(
                                    fontFamily: 'Inter',
<<<<<<< Updated upstream
                                    color: Colors.black,
=======
>>>>>>> Stashed changes
                                    letterSpacing: 0.0,
                                  ),
                              minLines: 1,
                              keyboardType: TextInputType.emailAddress,
                              validator: _model.textController1Validator
                                  .asValidator(context),
                            ),
                            TextFormField(
                              controller: _model.textController2,
                              focusNode: _model.textFieldFocusNode2,
                              autofocus: false,
                              obscureText: !_model.passwordVisibility,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Inter',
                                      color: Colors.black,
                                      letterSpacing: 0.0,
                                    ),
                                hintStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Inter',
<<<<<<< Updated upstream
                                      color: Colors.black,
=======
>>>>>>> Stashed changes
                                      letterSpacing: 0.0,
                                    ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFE0E3E7),
                                    width: 1.0,
                                  ),
<<<<<<< Updated upstream
                                  borderRadius: BorderRadius.circular(8),
=======
                                  borderRadius: BorderRadius.circular(8.0),
>>>>>>> Stashed changes
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1.0,
                                  ),
<<<<<<< Updated upstream
                                  borderRadius: BorderRadius.circular(8),
=======
                                  borderRadius: BorderRadius.circular(8.0),
>>>>>>> Stashed changes
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1.0,
                                  ),
<<<<<<< Updated upstream
                                  borderRadius: BorderRadius.circular(8),
=======
                                  borderRadius: BorderRadius.circular(8.0),
>>>>>>> Stashed changes
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1.0,
                                  ),
<<<<<<< Updated upstream
                                  borderRadius: BorderRadius.circular(8),
=======
                                  borderRadius: BorderRadius.circular(8.0),
>>>>>>> Stashed changes
                                ),
                                filled: true,
                                fillColor: Color(0xFFF1F4F8),
                                suffixIcon: InkWell(
                                  onTap: () => safeSetState(
                                    () => _model.passwordVisibility =
                                        !_model.passwordVisibility,
                                  ),
                                  focusNode: FocusNode(skipTraversal: true),
                                  child: Icon(
                                    _model.passwordVisibility
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
<<<<<<< Updated upstream
                                    size: 22,
=======
                                    size: 22.0,
>>>>>>> Stashed changes
                                  ),
                                ),
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .override(
                                    fontFamily: 'Inter',
                                    color: Colors.black,
                                    letterSpacing: 0.0,
                                  ),
                              minLines: 1,
                              validator: _model.textController2Validator
                                  .asValidator(context),
                            ),
<<<<<<< Updated upstream
                          ].divide(SizedBox(height: 16)),
=======
                          ].divide(SizedBox(height: 16.0)),
>>>>>>> Stashed changes
                        ),
                      ),
                    ),
                  ),
                  FFButtonWidget(
<<<<<<< Updated upstream
                    onPressed: () {
                      print('Button pressed ...');
=======
                    onPressed: () async {
                      context.pushNamed('normal_user_home_page');
>>>>>>> Stashed changes
                    },
                    text: 'Login',
                    options: FFButtonOptions(
                      width: MediaQuery.sizeOf(context).width * 0.9,
<<<<<<< Updated upstream
                      height: 50,
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
=======
                      height: 50.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
>>>>>>> Stashed changes
                      color: Color(0xFFE59368),
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'Inter Tight',
                                color: Colors.white,
                                letterSpacing: 0.0,
                              ),
<<<<<<< Updated upstream
                      elevation: 2,
                      borderRadius: BorderRadius.circular(25),
=======
                      elevation: 2.0,
                      borderRadius: BorderRadius.circular(25.0),
>>>>>>> Stashed changes
                    ),
                  ),
                  Text(
                    'OR',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                        ),
                  ),
                  FFButtonWidget(
                    onPressed: () {
                      print('Button pressed ...');
                    },
                    text: 'Sign in with Google',
                    options: FFButtonOptions(
                      width: MediaQuery.sizeOf(context).width * 0.9,
<<<<<<< Updated upstream
                      height: 50,
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
=======
                      height: 50.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
>>>>>>> Stashed changes
                      color: Colors.white,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'Inter Tight',
                                color: Colors.black,
                                letterSpacing: 0.0,
                              ),
<<<<<<< Updated upstream
                      elevation: 0,
                      borderSide: BorderSide(
                        color: Color(0xFFE0E3E7),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(25),
=======
                      elevation: 0.0,
                      borderSide: BorderSide(
                        color: Color(0xFFE0E3E7),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(25.0),
>>>>>>> Stashed changes
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                            ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          context.pushNamed('sign_up_page');
                        },
                        child: Text(
                          'Sign Up',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    color: Color(0xFFE59368),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
<<<<<<< Updated upstream
                    ].divide(SizedBox(width: 4)),
                  ),
                ].divide(SizedBox(height: 24)),
=======
                    ].divide(SizedBox(width: 4.0)),
                  ),
                ].divide(SizedBox(height: 24.0)),
>>>>>>> Stashed changes
              ),
            ),
          ),
        ),
      ),
    );
  }
<<<<<<< Updated upstream
}
=======
}
>>>>>>> Stashed changes
