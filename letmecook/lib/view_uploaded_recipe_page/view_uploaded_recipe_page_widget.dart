import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:letmecook/models/recipes.dart';
import 'package:letmecook/repositories/recipe_repository.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'view_uploaded_recipe_page_model.dart';
export 'view_uploaded_recipe_page_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class ViewUploadedRecipePageWidget extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const ViewUploadedRecipePageWidget({super.key, this.userData});

  @override
  State<ViewUploadedRecipePageWidget> createState() =>
      _ViewUploadedRecipePageWidgetState();
}

class _ViewUploadedRecipePageWidgetState
    extends State<ViewUploadedRecipePageWidget> {
  final RecipeRepository _recipeRepository = RecipeRepository();
  late Future<List<Map<String, dynamic>>> savedRecipes;
  late Future<List<Map<String, dynamic>>> _pendingRecipes;
  late Future<List<Map<String, dynamic>>> _approvedRecipes;
  late Future<List<Map<String, dynamic>>> _rejectedRecipes;
  late PendingApprovalRecipePageModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PendingApprovalRecipePageModel());
    _fetchData();
  }

  // Method to initialize the Futures
  void _fetchData() {
    _pendingRecipes =
        _recipeRepository.getRecipesByUsernameNStatus(0, widget.userData);
    _approvedRecipes =
        _recipeRepository.getRecipesByUsernameNStatus(1, widget.userData);
    _rejectedRecipes =
        _recipeRepository.getRecipesByUsernameNStatus(-1, widget.userData);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Uploaded Recipes',
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
          bottom: TabBar(
            tabs: [
              Tab(text: "Pending"),
              Tab(text: "Approved"),
              Tab(text: "Rejected"),
            ],
            indicatorColor: Colors.white,
          ),
        ),
        body: TabBarView(
          children: [
            _buildRecipeList(context, _pendingRecipes),
            _buildRecipeList(context, _approvedRecipes),
            _buildRecipeList(context, _rejectedRecipes),
          ],
        ),
      ),
    );
  }

  // Method to build the recipe list for each tab with its specific future
  Widget _buildRecipeList(
      BuildContext context, Future<List<Map<String, dynamic>>> future) {
    return Container(
      color: Color(0xFFF1F4F8),
      padding: EdgeInsets.all(24.0),
      child: FutureBuilder(
        future: future,
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No recipes to show',
                style: TextStyle(color: Colors.black),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var recipe = snapshot.data![index];
              return InkWell(
                onTap: () async {
                  await context.pushNamed(
                    'modify_recipe_page',
                    pathParameters: {'id': recipe['id']?.toString() ?? '0'},
                    extra: recipe,
                  );
                  _fetchData();
                },
                child: Card(
                  color: Colors.white,
                  child: ListTile(
                    title: Text(
                      recipe['recipeTitle'],
                      style: TextStyle(color: Colors.black),
                    ),
                    leading: Icon(
                      Icons.restaurant_menu,
                      color: Colors.black,
                    ),
                    subtitle: Text(
                      'Uploaded by ${recipe['username']}',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
