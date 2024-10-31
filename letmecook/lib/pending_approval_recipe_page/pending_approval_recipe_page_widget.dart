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
import 'pending_approval_recipe_page_model.dart';
export 'pending_approval_recipe_page_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class PendingApprovalRecipePageWidget extends StatefulWidget {
  const PendingApprovalRecipePageWidget({super.key});

  @override
  State<PendingApprovalRecipePageWidget> createState() =>
      _PendingApprovalRecipePageWidgetState();
}

class _PendingApprovalRecipePageWidgetState
    extends State<PendingApprovalRecipePageWidget> {
  final RecipeRepository _recipeRepository = RecipeRepository();
  late Future<List<Recipe>> _pendingRecipes;
  late PendingApprovalRecipePageModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PendingApprovalRecipePageModel());
    _pendingRecipes = _recipeRepository.getPendingApprovalRecipes();
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
          'Pending Approval Recipes',
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
    future: _recipeRepository.getRecipesWithUsernames(),
    builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
      if (!snapshot.hasData) {
        return Container();
      }
      return ListView.builder(
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          var recipe = snapshot.data![index];
          return InkWell(
            onTap: () {
              context.pushNamed(
                'display_pending_approval_recipe_page',
                extra: recipe,
              );
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
),

    );
  }
}
