import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'upload_recipe_page_model.dart';
export 'upload_recipe_page_model.dart';
import 'package:letmecook/repositories/auth_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class UploadRecipePageWidget extends StatefulWidget {
  const UploadRecipePageWidget({super.key});

  @override
  State<UploadRecipePageWidget> createState() => _UploadRecipePageWidgetState();
}

class _UploadRecipePageWidgetState extends State<UploadRecipePageWidget> {
  late UploadRecipePageModel _model;
  final AuthRepository _authRepository = AuthRepository();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UploadRecipePageModel());

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();

    _model.textController4 ??= TextEditingController();
    _model.textFieldFocusNode4 ??= FocusNode();
  }

  void clearForm() {
    // Reset any form fields, controllers, or variables here.
    _model.textController1?.clear();
    _model.textController2?.clear();
    _model.textController3?.clear();
    _model.textController4?.clear();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
              SizedBox(height: 16.0),
              // Recipe Title
              TextFormField(
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

              // Preparation Time
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Preparation Time (minutes)',
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

              // Cooking Time
              TextFormField(
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Handle form submission
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Recipe submitted successfully')),
                    );
                  }
                },
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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: Text("Upload Recipe")),
  //     body: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Form(
  //         key: _formKey,
  //         child: ListView(
  //           children: [
  //             // Recipe Title
  //             TextFormField(
  //               decoration: InputDecoration(
  //                 labelText: 'Recipe Title',
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(10.0),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(height: 16.0),

  //             // Description
  //             TextFormField(
  //               decoration: InputDecoration(
  //                 labelText: 'Description',
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(10.0),
  //                 ),
  //               ),
  //               maxLines: 3,
  //             ),
  //             SizedBox(height: 16.0),

  //             // Ingredients
  //             TextFormField(
  //               decoration: InputDecoration(
  //                 labelText: 'Ingredients',
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(10.0),
  //                 ),
  //               ),
  //               maxLines: 4,
  //             ),
  //             SizedBox(height: 16.0),

  //             // Instructions
  //             TextFormField(
  //               decoration: InputDecoration(
  //                 labelText: 'Instructions',
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(10.0),
  //                 ),
  //               ),
  //               maxLines: 5,
  //             ),
  //             SizedBox(height: 16.0),

  //             // Preparation Time
  //             TextFormField(
  //               decoration: InputDecoration(
  //                 labelText: 'Preparation Time (minutes)',
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(10.0),
  //                 ),
  //               ),
  //               keyboardType: TextInputType.number,
  //             ),
  //             SizedBox(height: 16.0),

  //             // Cooking Time
  //             TextFormField(
  //               decoration: InputDecoration(
  //                 labelText: 'Cooking Time (minutes)',
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(10.0),
  //                 ),
  //               ),
  //               keyboardType: TextInputType.number,
  //             ),
  //             SizedBox(height: 16.0),

  //             // Difficulty Level
  //             DropdownButtonFormField<String>(
  //               decoration: InputDecoration(
  //                 labelText: 'Difficulty',
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(10.0),
  //                 ),
  //               ),
  //               value: _difficulty,
  //               items: ['Easy', 'Medium', 'Hard'].map((difficulty) {
  //                 return DropdownMenuItem(
  //                   value: difficulty,
  //                   child: Text(difficulty),
  //                 );
  //               }).toList(),
  //               onChanged: (value) {
  //                 setState(() {
  //                   _difficulty = value!;
  //                 });
  //               },
  //             ),
  //             SizedBox(height: 16.0),

  //             // Cuisine Type
  //             TextFormField(
  //               decoration: InputDecoration(
  //                 labelText: 'Cuisine Type',
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(10.0),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(height: 16.0),

  //             // Image Upload
  //             GestureDetector(
  //               onTap: _pickImage,
  //               child: Container(
  //                 height: 150,
  //                 decoration: BoxDecoration(
  //                   color: Colors.grey[200],
  //                   borderRadius: BorderRadius.circular(10.0),
  //                 ),
  //                 child: _image == null
  //                     ? Center(child: Text('Tap to upload an image'))
  //                     : Image.file(File(_image!.path), fit: BoxFit.cover),
  //               ),
  //             ),
  //             SizedBox(height: 16.0),

  //             // Submit Button
  //             ElevatedButton(
  //               onPressed: () {
  //                 if (_formKey.currentState!.validate()) {
  //                   // Handle form submission
  //                   ScaffoldMessenger.of(context).showSnackBar(
  //                     SnackBar(content: Text('Recipe submitted successfully')),
  //                   );
  //                 }
  //               },
  //               child: Text('Submit Recipe'),
  //               style: ElevatedButton.styleFrom(
  //                 padding: EdgeInsets.symmetric(vertical: 16.0),
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(10.0),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  //   final scaffoldKey = GlobalKey<ScaffoldState>();

  // // Form Controllers
  // late TextEditingController recipeNameController;
  // late TextEditingController recipeDescriptionController;
  // late TextEditingController procedureController;

  // // Focus Nodes
  // late FocusNode recipeNameFocusNode;
  // late FocusNode recipeDescriptionFocusNode;
  // late FocusNode procedureFocusNode;

  // String selectedDifficulty = '';
  // List<String> ingredients = ['Ingredient 1', 'Ingredient 2'];

  // @override
  // void initState() {
  //   super.initState();
  //   recipeNameController = TextEditingController();
  //   recipeDescriptionController = TextEditingController();
  //   procedureController = TextEditingController();

  //   recipeNameFocusNode = FocusNode();
  //   recipeDescriptionFocusNode = FocusNode();
  //   procedureFocusNode = FocusNode();
  // }

  // @override
  // void dispose() {
  //   recipeNameController.dispose();
  //   recipeDescriptionController.dispose();
  //   procedureController.dispose();

  //   recipeNameFocusNode.dispose();
  //   recipeDescriptionFocusNode.dispose();
  //   procedureFocusNode.dispose();
  //   super.dispose();
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return GestureDetector(
  //     onTap: () => FocusScope.of(context).unfocus(),
  //     child: Scaffold(
  //       key: scaffoldKey,
  //       backgroundColor: Color(0xFFF1F4F8),
  //       appBar: AppBar(
  //         backgroundColor: Color(0xFFE59368),
  //         automaticallyImplyLeading: false,
  //         leading: FlutterFlowIconButton(
  //           borderColor: Colors.transparent,
  //           borderRadius: 30.0,
  //           borderWidth: 1.0,
  //           buttonSize: 60.0,
  //           icon: Icon(
  //             Icons.arrow_back_rounded,
  //             color: Colors.white,
  //             size: 30.0,
  //           ),
  //           onPressed: () async {
  //             Navigator.pop(context);
  //           },
  //         ),
  //         title: Text(
  //           'Upload Recipe',
  //           style: FlutterFlowTheme.of(context).headlineMedium.override(
  //             fontFamily: 'Inter Tight',
  //             color: Colors.white,
  //             fontSize: 22.0,
  //             letterSpacing: 0.0,
  //           ),
  //         ),
  //         centerTitle: true,
  //         elevation: 2.0,
  //       ),
  //       body: SafeArea(
  //         top: true,
  //         child: Padding(
  //           padding: EdgeInsets.all(24.0),
  //           child: SingleChildScrollView(
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   'RECIPE DETAILS',
  //                   style: FlutterFlowTheme.of(context).titleMedium.override(
  //                     fontFamily: 'Inter',
  //                     color: Colors.black,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //                 SizedBox(height: 20),
  //                 Material(
  //                   color: Colors.transparent,
  //                   elevation: 2.0,
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(12.0),
  //                   ),
  //                   child: Container(
  //                     width: double.infinity,
  //                     decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       borderRadius: BorderRadius.circular(12.0),
  //                     ),
  //                     child: Padding(
  //                       padding: EdgeInsets.all(24.0),
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           // Recipe Name Field
  //                           Text(
  //                             'RECIPE NAME',
  //                             style: FlutterFlowTheme.of(context).bodyMedium,
  //                           ),
  //                           SizedBox(height: 8),
  //                           TextFormField(
  //                             controller: recipeNameController,
  //                             focusNode: recipeNameFocusNode,
  //                             decoration: InputDecoration(
  //                               filled: true,
  //                               fillColor: Color(0xFFF1F4F8),
  //                               enabledBorder: OutlineInputBorder(
  //                                 borderSide: BorderSide(color: Color(0xFFE0E3E7)),
  //                                 borderRadius: BorderRadius.circular(8),
  //                               ),
  //                               focusedBorder: OutlineInputBorder(
  //                                 borderSide: BorderSide(color: Color(0xFFE59368)),
  //                                 borderRadius: BorderRadius.circular(8),
  //                               ),
  //                             ),
  //                           ),
  //                           SizedBox(height: 20),

  //                           // Recipe Description
  //                           Text(
  //                             'RECIPE DESCRIPTION',
  //                             style: FlutterFlowTheme.of(context).bodyMedium,
  //                           ),
  //                           SizedBox(height: 8),
  //                           TextFormField(
  //                             controller: recipeDescriptionController,
  //                             focusNode: recipeDescriptionFocusNode,
  //                             maxLines: 3,
  //                             decoration: InputDecoration(
  //                               filled: true,
  //                               fillColor: Color(0xFFF1F4F8),
  //                               enabledBorder: OutlineInputBorder(
  //                                 borderSide: BorderSide(color: Color(0xFFE0E3E7)),
  //                                 borderRadius: BorderRadius.circular(8),
  //                               ),
  //                               focusedBorder: OutlineInputBorder(
  //                                 borderSide: BorderSide(color: Color(0xFFE59368)),
  //                                 borderRadius: BorderRadius.circular(8),
  //                               ),
  //                             ),
  //                           ),
  //                           SizedBox(height: 20),

  //                           // Image & Video Upload
  //                           Text(
  //                             'IMAGE & VIDEO',
  //                             style: FlutterFlowTheme.of(context).bodyMedium,
  //                           ),
  //                           SizedBox(height: 8),
  //                           Row(
  //                             children: [
  //                               Expanded(
  //                                 child: InkWell(
  //                                   onTap: () {
  //                                     // Handle image upload
  //                                   },
  //                                   child: Container(
  //                                     height: 100,
  //                                     decoration: BoxDecoration(
  //                                       color: Color(0xFFF1F4F8),
  //                                       borderRadius: BorderRadius.circular(8),
  //                                       border: Border.all(
  //                                         color: Color(0xFFE0E3E7),
  //                                         // style: BorderStyle.dashed,
  //                                       ),
  //                                     ),
  //                                     child: Column(
  //                                       mainAxisAlignment: MainAxisAlignment.center,
  //                                       children: [
  //                                         Icon(Icons.add_photo_alternate_outlined),
  //                                         SizedBox(height: 8),
  //                                         Text('UPLOAD IMAGE'),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                               SizedBox(width: 16),
  //                               Expanded(
  //                                 child: InkWell(
  //                                   onTap: () {
  //                                     // Handle video upload
  //                                   },
  //                                   child: Container(
  //                                     height: 100,
  //                                     decoration: BoxDecoration(
  //                                       color: Color(0xFFF1F4F8),
  //                                       borderRadius: BorderRadius.circular(8),
  //                                       border: Border.all(
  //                                         color: Color(0xFFE0E3E7),
  //                                         // style: BorderStyle.dashed,
  //                                       ),
  //                                     ),
  //                                     child: Column(
  //                                       mainAxisAlignment: MainAxisAlignment.center,
  //                                       children: [
  //                                         Icon(Icons.videocam_outlined),
  //                                         SizedBox(height: 8),
  //                                         Text('UPLOAD VIDEO'),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                           SizedBox(height: 20),

  //                           // Difficulty Selection
  //                           Text(
  //                             'DIFFICULTY',
  //                             style: FlutterFlowTheme.of(context).bodyMedium,
  //                           ),
  //                           SizedBox(height: 8),
  //                           Row(
  //                             children: [
  //                               _buildDifficultyOption('EASY'),
  //                               SizedBox(width: 16),
  //                               _buildDifficultyOption('INTERMEDIATE'),
  //                               SizedBox(width: 16),
  //                               _buildDifficultyOption('ADVANCED'),
  //                             ],
  //                           ),
  //                           SizedBox(height: 20),

  //                           // Required Ingredients
  //                           Text(
  //                             'REQUIRED INGREDIENT',
  //                             style: FlutterFlowTheme.of(context).bodyMedium,
  //                           ),
  //                           SizedBox(height: 8),
  //                           Column(
  //                             children: ingredients.map((ingredient) {
  //                               return Padding(
  //                                 padding: EdgeInsets.only(bottom: 8),
  //                                 child: TextFormField(
  //                                   decoration: InputDecoration(
  //                                     filled: true,
  //                                     fillColor: Color(0xFFF1F4F8),
  //                                     enabledBorder: OutlineInputBorder(
  //                                       borderSide: BorderSide(color: Color(0xFFE0E3E7)),
  //                                       borderRadius: BorderRadius.circular(8),
  //                                     ),
  //                                     focusedBorder: OutlineInputBorder(
  //                                       borderSide: BorderSide(color: Color(0xFFE59368)),
  //                                       borderRadius: BorderRadius.circular(8),
  //                                     ),
  //                                     suffixIcon: Icon(Icons.arrow_drop_down),
  //                                   ),
  //                                   readOnly: true,
  //                                   controller: TextEditingController(text: ingredient),
  //                                 ),
  //                               );
  //                             }).toList(),
  //                           ),
  //                           SizedBox(height: 20),

  //                           // Procedure
  //                           Text(
  //                             'PROCEDURE',
  //                             style: FlutterFlowTheme.of(context).bodyMedium,
  //                           ),
  //                           SizedBox(height: 8),
  //                           TextFormField(
  //                             controller: procedureController,
  //                             focusNode: procedureFocusNode,
  //                             maxLines: 5,
  //                             decoration: InputDecoration(
  //                               filled: true,
  //                               fillColor: Color(0xFFF1F4F8),
  //                               enabledBorder: OutlineInputBorder(
  //                                 borderSide: BorderSide(color: Color(0xFFE0E3E7)),
  //                                 borderRadius: BorderRadius.circular(8),
  //                               ),
  //                               focusedBorder: OutlineInputBorder(
  //                                 borderSide: BorderSide(color: Color(0xFFE59368)),
  //                                 borderRadius: BorderRadius.circular(8),
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(height: 24),
  //                 // Submit Button
  //                 FFButtonWidget(
  //                   onPressed: () {
  //                     // Handle form submission
  //                   },
  //                   text: 'Submit',
  //                   options: FFButtonOptions(
  //                     width: double.infinity,
  //                     height: 50,
  //                     color: Colors.black,
  //                     textStyle: FlutterFlowTheme.of(context).titleSmall.override(
  //                       fontFamily: 'Inter',
  //                       color: Colors.white,
  //                     ),
  //                     elevation: 2,
  //                     borderRadius: BorderRadius.circular(25),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildDifficultyOption(String difficulty) {
  //   bool isSelected = selectedDifficulty == difficulty;
  //   return Expanded(
  //     child: InkWell(
  //       onTap: () {
  //         setState(() {
  //           selectedDifficulty = difficulty;
  //         });
  //       },
  //       child: Container(
  //         padding: EdgeInsets.symmetric(vertical: 8),
  //         decoration: BoxDecoration(
  //           color: isSelected ? Color(0xFFE59368) : Color(0xFFF1F4F8),
  //           borderRadius: BorderRadius.circular(8),
  //           border: Border.all(
  //             color: isSelected ? Color(0xFFE59368) : Color(0xFFE0E3E7),
  //           ),
  //         ),
  //         child: Text(
  //           difficulty,
  //           textAlign: TextAlign.center,
  //           style: FlutterFlowTheme.of(context).bodySmall.override(
  //             fontFamily: 'Inter',
  //             color: isSelected ? Colors.white : Colors.black,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
