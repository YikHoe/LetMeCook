import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'display_pending_approval_recipe_page_widget.dart' show DisplayPendingApprovalRecipePageWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DisplayPendingApprovalRecipePageModel extends FlutterFlowModel<DisplayPendingApprovalRecipePageWidget> {
  TextEditingController recipeTitleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController ingredientsController = TextEditingController();
  TextEditingController instructionsController = TextEditingController();
  TextEditingController cookingTimeController = TextEditingController();
  TextEditingController videoTutorialLinkController = TextEditingController();
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    recipeTitleController.dispose();
    descriptionController.dispose();
    ingredientsController.dispose();
    instructionsController.dispose();
    cookingTimeController.dispose();
    videoTutorialLinkController.dispose();
  }
}
