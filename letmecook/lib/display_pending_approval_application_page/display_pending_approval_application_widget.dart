import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:letmecook/models/applications.dart';
import 'package:letmecook/repositories/applications_repository.dart';
import 'package:letmecook/repositories/recipe_repository.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'display_pending_approval_application_model.dart';
export 'display_pending_approval_application_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

class DisplayPendingApprovalApplicationWidget extends StatefulWidget {
  final Map<String, dynamic> applicationData;

  const DisplayPendingApprovalApplicationWidget({
    Key? key,
    required this.applicationData,
  }) : super(key: key);

  @override
  State<DisplayPendingApprovalApplicationWidget> createState() =>
      _DisplayPendingApprovalApplicationWidgetState();
}

class _DisplayPendingApprovalApplicationWidgetState extends State<DisplayPendingApprovalApplicationWidget> {
  late DisplayPendingApprovalApplicationModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final ApplicationsRepository applicationRepo = ApplicationsRepository();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DisplayPendingApprovalApplicationModel());

  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // Helper widget to display each field as non-editable and clickable
  Widget _buildReadOnlyField(String label, String value,
      {bool isCopyable = false, bool isClickable = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: isClickable
                    ? Colors.blue
                    : Colors.black, // Blue if clickable
                decoration: isClickable
                    ? TextDecoration.underline
                    : TextDecoration.none, // Underline only if clickable
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildApprovalButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: onApprove,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          child: Text('Approve'),
        ),
        ElevatedButton(
          onPressed: onReject,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.red,
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
          child: Text('Reject'),
        ),
      ],
    );
  }

  void onApprove() async {
    final appID = widget.applicationData['id'];
    final result = await applicationRepo.updateStatus(appID, 1);

    if (result['status'] == 200) {
      // Show confirmation overlay
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text('Success'),
            content: Text(result['message']),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Dismiss the dialog
                  Navigator.of(context).pop(); // Go back to the previous screen
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Unexpected error occurred. Please try again later")),
      );
    }
  }

  void onReject() {
    final appID = widget.applicationData['id'];
    var result;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Reason'),
          content: TextField(
            controller: _model.reasonController,
            decoration: InputDecoration(
              hintText: 'Enter reason',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                // Verify the input
                String reason = _model.reasonController.text.trim();
                if (reason.isEmpty) {
                  // Show an error message if input is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Reason cannot be empty')),
                  );
                } else {
                  result = await applicationRepo.updateStatus(appID, 0, reason);
                  Navigator.of(dialogContext).pop(); // Close the dialog

                  if (result['status'] == 200) {
                    // Show confirmation overlay
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: Text('Success'),
                          content: Text(result['message']),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop(); // Dismiss the dialog
                                Navigator.of(context).pop(); // Go back to the previous screen
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Unexpected error occurred. Please try again later")),
                    );
                  }
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Application Details',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: 'Inter Tight',
                color: Colors.white,
                fontSize: 22.0,
                letterSpacing: 0.0,
              ),
        ),
        centerTitle: true,
        elevation: 2.0,
        backgroundColor: Color(0xFFE59368),
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30.0,
          borderWidth: 1.0,
          buttonSize: 60.0,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 30.0,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        color: Color(0xFFF1F4F8),
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            _buildReadOnlyField(
                "Full Name", widget.applicationData['fullname']),
            const SizedBox(height: 16.0),
            _buildReadOnlyField(
                "Age", widget.applicationData['age'].toString()),
            const SizedBox(height: 16.0),
            _buildReadOnlyField(
                "Occupation", widget.applicationData['occupation']),
            const SizedBox(height: 16.0),
            _buildReadOnlyField(
                "Years of Experience", widget.applicationData['yearsOfExp'].toString()),
            const SizedBox(height: 24.0),
            _buildApprovalButtons(),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
