import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'verified_user_home_page_widget.dart' show VerifiedUserHomePageWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class VerifiedUserHomePageModel
    extends FlutterFlowModel<VerifiedUserHomePageWidget> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    searchController.dispose(); // Dispose the controller when done
  }

  void performSearch(BuildContext context) {
    final query = searchController.text;
    if (query.isNotEmpty) {
      // Implement your search functionality here
      debugPrint("Searching for: $query");
    }
  }
}
