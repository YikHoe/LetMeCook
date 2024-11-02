import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:letmecook/repositories/recipe_repository.dart';
import 'package:letmecook/repositories/user_repository.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'display_recipe_page_model.dart';
export 'display_recipe_page_model.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

class DisplayRecipePageWidget extends StatefulWidget {
  final Map<String, dynamic> recipeData;

  const DisplayRecipePageWidget({
    Key? key,
    required this.recipeData,
  }) : super(key: key);

  @override
  State<DisplayRecipePageWidget> createState() =>
      _DisplayRecipePageWidgetState();
}

class _DisplayRecipePageWidgetState extends State<DisplayRecipePageWidget> {
  late DisplayRecipePageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final RecipeRepository recipeRepository = RecipeRepository();
  final UserRepository userRepository = UserRepository();
  late YoutubePlayerController _youtubeController;

  // Track if the recipe is saved
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DisplayRecipePageModel());

    // Initialize YouTube controller if video link exists
    String videoUrl = widget.recipeData['videoTutorialLink'] ?? '';
    if (videoUrl.isNotEmpty) {
      String videoId = YoutubePlayerController.convertUrlToId(videoUrl) ?? '';
      _youtubeController = YoutubePlayerController.fromVideoId(
        videoId: videoId,
        params: YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
        ),
      );
    }
    //Check if the recipe is already saved
    checkIfRecipeIsSaved(widget.recipeData['id']);
  }

  Future<void> checkIfRecipeIsSaved(recipeId) async {
    bool savedStatus = await userRepository.isRecipeSaved(recipeId);
    setState(() {
      isSaved = savedStatus;
    });
  }

  Future<void> toggleSaveRecipe(String recipeId) async {
    String message = await userRepository.toggleRecipeSaved(recipeId);
    bool savedStatus = await userRepository.isRecipeSaved(recipeId);
    setState(() {
      isSaved = savedStatus;
    });

    // Display Snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _model.dispose();
    _youtubeController.close();
    super.dispose();
  }

  // Helper to display text information
  Widget _buildInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // Helper widget to display the uploaded image
  Widget _buildImageSection() {
    String imageUrl = widget.recipeData['image'] ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: imageUrl.isNotEmpty
                ? Center(
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain, // Adjusts to fit without zooming in
                      alignment: Alignment.center,
                    ),
                  )
                : const Center(
                    child: Text(
                      'No Image Available',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.recipeData == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Recipe Details',
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
        ),
        body: const Center(child: Text('No recipe data available')),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: false,
      appBar: AppBar(
        title: Text(
          'Recipe Details',
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
            Navigator.of(context).pop(true);
          },
        ),
        actions: [
          Padding(
            padding:
                const EdgeInsets.only(right: 0), // Adjust padding as needed
            child: IconButton(
              icon: Icon(
                isSaved ? Icons.bookmark : Icons.bookmark_border,
                color: Colors.white,
              ),
              onPressed: () => toggleSaveRecipe(widget.recipeData['id'] ?? ''),
            ),
          ),
        ],
      ),
      body: Container(
        color: Color(0xFFF1F4F8),
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            // Recipe Image
            _buildImageSection(),

            // Recipe Title
            _buildInfo("Recipe Title", widget.recipeData['recipeTitle'] ?? ''),

            // Description
            _buildInfo("Description", widget.recipeData['description'] ?? ''),

            // Uploaded By
            _buildInfo("Uploaded by", widget.recipeData['username'] ?? ''),

            // Cooking Time
            _buildInfo("Cooking Time (minutes)",
                widget.recipeData['cookingTime']?.toString() ?? ''),

            // Difficulty
            _buildInfo("Difficulty", widget.recipeData['difficulty'] ?? ''),

            // Ingredients
            _buildInfo("Ingredients", widget.recipeData['ingredients'] ?? ''),

            // Instructions
            _buildInfo("Instructions", widget.recipeData['instructions'] ?? ''),

            // YouTube Video Tutorial
            if (_youtubeController != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Video Tutorial",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 200, // Set fixed height
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          10.0), // Optional rounded corners
                      child: YoutubePlayerScaffold(
                        controller: _youtubeController,
                        builder: (context, player) {
                          return AspectRatio(
                            aspectRatio: 16 / 9,
                            child: player,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
