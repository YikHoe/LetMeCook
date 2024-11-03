import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
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
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:url_launcher/url_launcher.dart';

class DisplayPendingApprovalRecipePageWidget extends StatefulWidget {
  final Map<String, dynamic> recipeData;

  const DisplayPendingApprovalRecipePageWidget({
    Key? key,
    required this.recipeData,
  }) : super(key: key);

  @override
  State<DisplayPendingApprovalRecipePageWidget> createState() =>
      _DisplayPendingApprovalRecipePageWidgetState();
}

class _DisplayPendingApprovalRecipePageWidgetState
    extends State<DisplayPendingApprovalRecipePageWidget> {
  late DisplayPendingApprovalRecipePageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final RecipeRepository recipeRepository = RecipeRepository();
  late YoutubePlayerController _youtubeController;
  bool isDesktop = false;

  @override
  void initState() {
    super.initState();
    _model =
        createModel(context, () => DisplayPendingApprovalRecipePageModel());

    // Determine if the app is running on a desktop platform
    isDesktop =
        !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);

    // Initialize YouTube controller if video link exists and not on desktop
    String videoUrl = widget.recipeData['videoTutorialLink'] ?? '';
    if (videoUrl.isNotEmpty && !isDesktop) {
      String videoId = YoutubePlayerController.convertUrlToId(videoUrl) ?? '';
      _youtubeController = YoutubePlayerController.fromVideoId(
        videoId: videoId,
        params: YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
        ),
      );
    }
  }

  @override
  void dispose() {
    _model.dispose();
    if (!isDesktop) {
      _youtubeController.close();
    }
    super.dispose();
  }

  // Helper to launch a URL in the default browser
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url); // Parse the string URL to a Uri object
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
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
          onTap: isClickable
              ? () async {
                  _launchURL(value); // Launch the URL when clicked
                }
              : isCopyable
                  ? () async {
                      await Clipboard.setData(ClipboardData(text: value));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Link copied to clipboard!')),
                      );
                    }
                  : null,
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

// Helper function to load network image as bytes for web compatibility
  Future<Uint8List> _loadNetworkImageBytes(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Failed to load image');
      }
    } catch (e) {
      throw Exception('Failed to load image: $e');
    }
  }

  // Helper widget to display the uploaded image
  Widget _buildImageSection() {
    String imageUrl = widget.recipeData['image'] ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recipe Image",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: imageUrl.isNotEmpty
              ? FutureBuilder<Uint8List>(
                  future: _loadNetworkImageBytes(imageUrl),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: ClipRect(
                          child: Align(
                            alignment: Alignment.center,
                            widthFactor: 1.0,
                            heightFactor: 1.0,
                            child: Image.memory(
                              snapshot.data!,
                              fit: BoxFit.cover,
                              height: 250,
                            ),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'Failed to load image',
                          style: TextStyle(color: Colors.black54),
                        ),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
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
    final recipeId = widget.recipeData['id']; // Get the recipe ID
    final result = await recipeRepository.updateRecipeStatus(recipeId, 1);
    if (result == null) {
      // Show success message and possibly navigate back or refresh the page
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recipe approved successfully!')),
      );
      Navigator.of(context).pop(); // Go back to the previous screen
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    }
  }

  void onReject() async {
    final recipeId = widget.recipeData['id']; // Get the recipe ID
    final result = await recipeRepository.updateRecipeStatus(recipeId, -1);
    if (result == null) {
      // Show success message and possibly navigate back or refresh the page
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recipe rejected successfully!')),
      );
      Navigator.of(context).pop(); // Go back to the previous screen
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    }
  }

  bool _isDesktop() {
    return !kIsWeb &&
        (Platform.isWindows || Platform.isLinux || Platform.isMacOS);
  }

  // Widget for displaying the video tutorial link or embedded video
  Widget _buildVideoTutorialSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _isDesktop()
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Non-editable text field with clickable link
                  _buildReadOnlyField(
                    "Video Tutorial Link",
                    widget.recipeData['videoTutorialLink'],
                    isClickable: true, // Makes the link clickable
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display "Video Tutorial" text only for non-desktop platforms
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
                      borderRadius: BorderRadius.circular(10.0),
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
                ],
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
                "Recipe Title", widget.recipeData['recipeTitle'] ?? ''),
            const SizedBox(height: 16.0),
            _buildReadOnlyField(
                "Description", widget.recipeData['description'] ?? ''),
            const SizedBox(height: 16.0),
            _buildReadOnlyField(
                "Ingredients", widget.recipeData['ingredients'] ?? ''),
            const SizedBox(height: 16.0),
            _buildReadOnlyField(
                "Instructions", widget.recipeData['instructions'] ?? ''),
            const SizedBox(height: 16.0),
            _buildReadOnlyField("Cooking Time (minutes)",
                widget.recipeData['cookingTime']?.toString() ?? ''),
            const SizedBox(height: 16.0),
            _buildReadOnlyField(
                "Difficulty", widget.recipeData['difficulty'] ?? ''),
            const SizedBox(height: 16.0),
            _buildVideoTutorialSection(),
            _buildImageSection(),
            const SizedBox(height: 24.0),
            _buildApprovalButtons(),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
