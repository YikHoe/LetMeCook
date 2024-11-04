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
import 'modify_recipe_page_model.dart';
export 'modify_recipe_page_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class ModifyRecipePageWidget extends StatefulWidget {
  final Map<String, dynamic> recipeData;
  const ModifyRecipePageWidget({super.key, required this.recipeData});

  @override
  State<ModifyRecipePageWidget> createState() => _ModifyRecipePageWidgetState();
}

class _ModifyRecipePageWidgetState extends State<ModifyRecipePageWidget> {
  late ModifyRecipePageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ModifyRecipePageModel());

    // Initialize form fields with recipeData
    _model.recipeTitleController.text = widget.recipeData['recipeTitle'] ?? '';
    _model.descriptionController.text = widget.recipeData['description'] ?? '';
    _model.ingredientsController.text = widget.recipeData['ingredients'] ?? '';
    _model.instructionsController.text =
        widget.recipeData['instructions'] ?? '';
    _model.cookingTimeController.text =
        widget.recipeData['cookingTime']?.toString() ?? '';
    _model.videoTutorialLinkController.text =
        widget.recipeData['videoTutorialLink'] ?? '';
    _difficulty = widget.recipeData['difficulty'] ?? 'Easy';
  }

  String getStatusText(int status) {
    switch (status) {
      case 1:
        return 'Approved';
      case -1:
        return 'Rejected';
      default:
        return 'Pending';
    }
  }

  Future<void> _deleteRecipe() async {
    bool confirmed = await _showConfirmationDialog(
        'Delete Recipe', 'Are you sure you want to delete this recipe?');
    if (!confirmed) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Deleting recipe...")),
    );
    await RecipeRepository().deleteRecipe(widget.recipeData['id']);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Recipe deleted successfully.")),
    );
    Navigator.pop(context);
  }

  Future<void> _editRecipe() async {
    String dialogTitle = 'Edit Recipe';
    String dialogContent;

    int status = widget.recipeData['status'] ?? 0;
    if (status == 1) {
      dialogContent =
          'This recipe is currently approved. Editing it will reset its status to "Pending" for re-verification. Do you want to proceed?';
    } else if (status == -1) {
      dialogContent =
          'This recipe was previously rejected. Are you sure you want to resubmit?';
    } else {
      dialogContent = 'Are you sure you want to edit this recipe?';
    }

    bool confirmed = await _showConfirmationDialog(dialogTitle, dialogContent);
    if (!confirmed) return;

    await _submitRecipe();
  }

  Future<bool> _showConfirmationDialog(String title, String content) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: Text('Confirm'),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _submitRecipe() async {
    if (_model.recipeTitleController.text.isEmpty ||
        _model.descriptionController.text.isEmpty ||
        _model.ingredientsController.text.isEmpty ||
        _model.instructionsController.text.isEmpty ||
        _model.cookingTimeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Please fill out all required fields and upload an image.'),
        ),
      );
      return;
    }

    int cookingTime;
    try {
      cookingTime = int.parse(_model.cookingTimeController.text);
      if (cookingTime <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Please enter a valid cooking time greater than zero.')),
        );
        return;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please enter a valid cooking time in minutes.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Updating recipe...')),
    );

    final String? result = await RecipeRepository().updateRecipe(
      widget.recipeData['id'],
      _model.recipeTitleController.text,
      _model.descriptionController.text,
      _model.ingredientsController.text,
      _model.instructionsController.text,
      cookingTime,
      _difficulty,
      _model.videoTutorialLinkController.text,
      imageBytes: _imageBytes,
      imageFile: _imageFile,
    );

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recipe updated successfully.')),
      );
      Navigator.pop(context, true); // Navigate back and trigger refresh
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update recipe: $result")),
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
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageBytes = bytes;
          _imageFile = null; // Clear _imageFile to use web image
        });
      }
    } else {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
          _imageBytes = null; // Clear _imageBytes to use local image
        });
      }
    }
  }

  Widget _buildImageWidget() {
    if (_imageBytes != null) {
      // Display selected image from web
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
      // Display selected image from local file
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
    } else if (widget.recipeData['image'] != null) {
      // Display original image from database
            return ClipRect(
        child: Align(
          alignment: Alignment.center, // Aligns the image in the center
          widthFactor: 1.0, // Take full width of the container
          heightFactor: 1.0, // Take full height of the container
          child: Image.network(widget.recipeData['image'],
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
          'Edit Recipe',
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Color(0xFFF1F4F8),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Status Display
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: widget.recipeData['status'] == 1
                        ? Colors.green.withOpacity(0.2)
                        : widget.recipeData['status'] == -1
                            ? Colors.red.withOpacity(0.2)
                            : Colors.yellow.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'Status: ${getStatusText(widget.recipeData['status'] ?? 0)}',
                    style: TextStyle(
                      color: widget.recipeData['status'] == 1
                          ? Colors.green
                          : widget.recipeData['status'] == -1
                              ? Colors.red
                              : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.0),

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
                style: TextStyle(
                  color: Colors.black,
                ),
                value: _difficulty,
                items: ['Easy', 'Medium', 'Hard'].map((difficulty) {
                  return DropdownMenuItem(
                      value: difficulty, child: Text(difficulty));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _difficulty = value!;
                  });
                },
              ),
              SizedBox(height: 16.0),

              // Video Tutorial Link
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

              // Centered Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _deleteRecipe,
                    child: Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: _editRecipe,
                    child: Text('Edit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE59368),
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
