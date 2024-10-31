import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:letmecook/repositories/recipe_repository.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'display_pending_approval_recipe_page_model.dart';
export 'display_pending_approval_recipe_page_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class DisplayPendingApprovalRecipePageWidget extends StatefulWidget {
  final Map<String, dynamic>? recipeData;

  const DisplayPendingApprovalRecipePageWidget({Key? key, this.recipeData}) : super(key: key);

  @override
  State<DisplayPendingApprovalRecipePageWidget> createState() => _DisplayPendingApprovalRecipePageWidgetState();
}

class _DisplayPendingApprovalRecipePageWidgetState extends State<DisplayPendingApprovalRecipePageWidget> {
  late DisplayPendingApprovalRecipePageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DisplayPendingApprovalRecipePageModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

    // Helper widget to display each field as non-editable
  Widget _buildReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
      ],
    );
  }

  // Helper widget to display the uploaded image
  Widget _buildImageSection(String imageUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recipe Image",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                )
              : const Center(
                  child: Text(
                    'No Image Available',
                    style: TextStyle(color: Colors.black54),
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
        ElevatedButton(onPressed: onApprove, child: Text('Approve')),
        ElevatedButton(onPressed: onReject, child: Text('Reject')),
      ],
    );
  }
  
  void onApprove() {
  }

  void onReject() {
  }

  @override
  Widget build(BuildContext context) {
    if (widget.recipeData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Pending Recipe Approval')),
        body: const Center(child: Text('No recipe data available')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Pending Recipe Approval')),
      body: Container(
        padding: const EdgeInsets.all(24.0),
        color: const Color(0xFFF1F4F8),
        child: ListView(
          children: [
            _buildReadOnlyField("Recipe Title", widget.recipeData!['recipeTitle']),
            _buildReadOnlyField("Description", widget.recipeData!['description']),
            _buildReadOnlyField("Ingredients", widget.recipeData!['ingredients']),
            _buildReadOnlyField("Instructions", widget.recipeData!['instructions']),
            _buildReadOnlyField("Cooking Time", widget.recipeData!['cookingTime'].toString()),
            _buildReadOnlyField("Difficulty", widget.recipeData!['difficulty']),
            _buildReadOnlyField("Video Tutorial Link", widget.recipeData!['videoTutorialLink']),
            _buildImageSection(widget.recipeData!['image']),
            _buildApprovalButtons(),
          ],
        ),
      ),
    );
  }

}
