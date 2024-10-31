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
import 'upload_recipe_page_model.dart';
export 'upload_recipe_page_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class UploadRecipePageWidget extends StatefulWidget {
  const UploadRecipePageWidget({super.key});

  @override
  State<UploadRecipePageWidget> createState() => _UploadRecipePageWidgetState();
}

class _UploadRecipePageWidgetState extends State<UploadRecipePageWidget> {
  late UploadRecipePageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UploadRecipePageModel());
  }

  void clearForm() {
    // Reset any form fields, controllers, or variables here.
    _model.recipeTitleController.clear();
    _model.descriptionController.clear();
    _model.ingredientsController.clear();
    _model.instructionsController.clear();
    _model.cookingTimeController.clear();
    _model.videoTutorialLinkController.clear();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _submitRecipe() async {
    // Validate required fields before showing the uploading message
    if (_model.recipeTitleController.text.isEmpty ||
        _model.descriptionController.text.isEmpty ||
        _model.ingredientsController.text.isEmpty ||
        _model.instructionsController.text.isEmpty ||
        _model.cookingTimeController.text.isEmpty ||
        (_imageBytes == null && _imageFile == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Please fill out all required fields and upload an image.'),
        ),
      );
      return; // Exit early if validation fails
    }

    // Validate cooking time format
    int cookingTime;
    try {
      cookingTime = int.parse(_model.cookingTimeController.text);
      // Check if cooking time is less than or equal to zero
      if (cookingTime <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Please enter a valid cooking time greater than zero.')),
        );
        return; // Exit early if cooking time is invalid
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please enter a valid cooking time in minutes.')),
      );
      return; // Exit early if cooking time is invalid
    }

    // If all fields are filled and cooking time is valid, show the uploading message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Uploading recipe...')),
    );

    // Call the addRecipe function and handle errors
    final String? result = await RecipeRepository().addRecipe(
      _model.recipeTitleController.text,
      _model.descriptionController.text,
      _model.ingredientsController.text,
      _model.instructionsController.text,
      cookingTime, // Use the validated cooking time
      _difficulty, // Use selected value for difficulty
      _model.videoTutorialLinkController.text,
      imageBytes: _imageBytes, // Use imageBytes for web
      imageFile: _imageFile, // Use imageFile for mobile/desktop
    );

    if (result == "admin") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Recipe submitted successfully.',
          ),
        ),
      );
      _formKey.currentState!.reset();
      setState(() {
        _difficulty = 'Easy';
        _imageBytes = null;
        _imageFile = null;
      });
      clearForm();
    } else if (result == "verifiedUser") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Recipe submitted successfully. The administrator will review your recipe before publishing.',
          ),
        ),
      );
      _formKey.currentState!.reset();
      setState(() {
        _difficulty = 'Easy';
        _imageBytes = null;
        _imageFile = null;
      });
      clearForm();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to upload recipe. Please try again.")),
      );
    }
  }

  final _formKey = GlobalKey<FormState>();
  String _difficulty = 'Easy';
  XFile? _imageFile;
  Uint8List? _imageBytes;

  final picker = ImagePicker();

  Future<void> _pickImage() async {
    if (kIsWeb) {
      // Web-specific image picking
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        // Read the bytes outside of setState
        final bytes = await pickedFile.readAsBytes();
        // Now, update the state with the bytes
        setState(() {
          _imageBytes = bytes;
        });
      }
    } else {
      // Non-web platforms (Mobile/Desktop)
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });
      }
    }
  }

  Widget _buildImageWidget() {
    if (kIsWeb && _imageBytes != null) {
      // Display web image as bytes
      return ClipRect(
        child: Align(
          alignment: Alignment.center, // Aligns the image in the center
          widthFactor: 1.0, // Take full width of the container
          heightFactor: 1.0, // Take full height of the container
          child: Image.memory(
            _imageBytes!,
            fit: BoxFit.cover, // Maintain aspect ratio
          ),
        ),
      );
    } else if (_imageFile != null) {
      // Display file image for non-web
      return ClipRect(
        child: Align(
          alignment: Alignment.center, // Aligns the image in the center
          widthFactor: 1.0, // Take full width of the container
          heightFactor: 1.0, // Take full height of the container
          child: Image.file(
            File(_imageFile!.path),
            fit: BoxFit.cover, // Maintain aspect ratio
          ),
        ),
      );
    } else {
      // Placeholder text when no image is selected
      return Center(
        child: Text(
          'Tap to upload an image from gallery',
          style: TextStyle(color: Colors.black),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Upload Recipe',
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
        padding: const EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 4.0),
              // Recipe Title
              TextFormField(
                controller: _model.recipeTitleController,
                decoration: InputDecoration(
                  labelText: 'Recipe Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16.0),

              // Description
              TextFormField(
                controller: _model.descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
                style: TextStyle(
                  color: Colors.black,
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16.0),

              // Ingredients
              TextFormField(
                controller: _model.ingredientsController,
                decoration: InputDecoration(
                  labelText: 'Ingredients',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
                style: TextStyle(
                  color: Colors.black,
                ),
                maxLines: 4,
              ),
              SizedBox(height: 16.0),

              // Instructions
              TextFormField(
                controller: _model.instructionsController,
                decoration: InputDecoration(
                  labelText: 'Instructions',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
                style: TextStyle(
                  color: Colors.black,
                ),
                maxLines: 5,
              ),
              SizedBox(height: 16.0),

              // Cooking Time
              TextFormField(
                controller: _model.cookingTimeController,
                decoration: InputDecoration(
                  labelText: 'Cooking Time (minutes)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16.0),

              // Difficulty Level
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Difficulty',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
                value: _difficulty,
                items: ['Easy', 'Medium', 'Hard'].map((difficulty) {
                  return DropdownMenuItem(
                    value: difficulty,
                    child: Text(difficulty),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _difficulty = value!;
                  });
                },
                style: TextStyle(
                  color: Colors.black,
                ),
                dropdownColor: Colors.white,
                iconEnabledColor: Colors.black,
              ),

              SizedBox(height: 16.0),

              // Video Tutorial URL
              TextFormField(
                controller: _model.videoTutorialLinkController,
                decoration: InputDecoration(
                  labelText: 'Video Tutorial Link',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  labelStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16.0),
              // Image Upload
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: _buildImageWidget(),
                ),
              ),
              SizedBox(height: 16.0),
              // Submit Button
              ElevatedButton(
                onPressed:
                    _submitRecipe, // Call the existing _submitRecipe function
                child: Text(
                  'Submit Recipe',
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFFE59368),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
