import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'pending_approval_verification_model.dart';
export 'pending_approval_verification_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:letmecook/repositories/applications_repository.dart';

class PendingApprovalApplicationsWidget extends StatefulWidget {
  const PendingApprovalApplicationsWidget({super.key});

  @override
  State<PendingApprovalApplicationsWidget> createState() =>
      _PendingApprovalApplicationsWidget();
}

class _PendingApprovalApplicationsWidget extends State<PendingApprovalApplicationsWidget> {
  final ApplicationsRepository _applicationRepo = ApplicationsRepository();
  late PendingApprovalApplicationsModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PendingApprovalApplicationsModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pending Approval Application',
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
          onPressed: () async {
            context.pop();
          },
        ),
      ),
      body: Container(
        color: Color(0xFFF1F4F8),
        padding: EdgeInsets.all(24.0),
        child: FutureBuilder(
          future: _applicationRepo.getAllPending(),
          builder:
              (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
            // Check if the snapshot is still loading
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            // Check if there are no recipes available
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No pending applications to show',
                  style: TextStyle(
                      color: Colors.black), // Set the text color to black
                ),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var application = snapshot.data![index];
                return InkWell(
                  onTap: () {
                    context.pushNamed(
                      'display_pending_approval_verification',
                      pathParameters: {'id': application['id']},
                      extra: application,
                    );
                  },
                  child: Card(
                    color: Colors.white,
                    child: ListTile(
                      title: Text(
                        application['fullname'],
                        style: TextStyle(color: Colors.black),
                      ),
                      leading: Icon(
                        Icons.manage_accounts,
                        color: Colors.black,
                      ),
                      subtitle: Text(
                        'Years of Experience: ${application['yearsOfExp']}',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
