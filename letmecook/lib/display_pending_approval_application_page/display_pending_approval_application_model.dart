import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'display_pending_approval_application_widget.dart' show DisplayPendingApprovalApplicationWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DisplayPendingApprovalApplicationModel extends FlutterFlowModel<DisplayPendingApprovalApplicationWidget> {
  TextEditingController reasonController = TextEditingController();
  @override
  void initState(BuildContext context) {}


  @override
  void dispose() {
    reasonController.dispose();
  }
}
