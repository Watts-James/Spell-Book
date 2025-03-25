import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spell_book/Screens/AllSpells.dart';
import 'package:spell_book/Screens/SpellBook.dart';

final GoRouter appRouter = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SpellBook(title: 'Spell Book');
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/AllSpells',
          builder: (BuildContext context, GoRouterState state) {
            return const AllSpells(title: 'All Spells');
          },
        ),
      ],
    ),
  ],
);
