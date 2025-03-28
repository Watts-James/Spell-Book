import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spell_book/Screens/AllSpells/AllSpells.dart';
import 'package:spell_book/Screens/SpellBook/SpellBook.dart';
import 'package:spell_book/Screens/SpellForm/SpellFormPage.dart';

final GoRouter appRouter = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return SpellBook(
          key: ValueKey(state.uri.toString()),
          title: 'Spell Book',
        );
      },
    ),
    GoRoute(
      path: '/AllSpells',
      builder: (BuildContext context, GoRouterState state) {
        return AllSpells(title: 'All Spells');
      },
    ),
    GoRoute(
      path: '/SpellFormPage',
      builder: (BuildContext context, GoRouterState state) {
        return SpellFormPage(title: "Create A Spell");
      },
    ),
  ],
);
