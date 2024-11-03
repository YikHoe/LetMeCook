import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'upload_recipe_page_widget.dart' show UploadRecipePageWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UploadRecipePageModel extends FlutterFlowModel<UploadRecipePageWidget> {
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
