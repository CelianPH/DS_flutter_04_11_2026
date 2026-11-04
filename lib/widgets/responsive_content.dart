// lib/widgets/responsive_content.dart

import 'package:flutter/material.dart';

class ResponsiveContent extends StatelessWidget {
  final Widget child;

  const ResponsiveContent({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400.0),
          child: Padding(padding: const EdgeInsets.all(16.0), child: child),
        ),
      ),
    );
  }
}
