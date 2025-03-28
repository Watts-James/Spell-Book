import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spell_book/Screens/AllSpells/AllSpells.dart';
import 'package:spell_book/Screens/SpellBook/SpellBook.dart';

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
      routes: <RouteBase>[
        GoRoute(
          path: '/AllSpells',
          builder: (BuildContext context, GoRouterState state) {
            return AllSpells(title: 'All Spells');
          },
        ),
      ],
    ),
  ],
);
