import 'package:flutter/material.dart';

import 'package:volnex/components/common/page_header.dart';
import 'package:volnex/pages/app/university_detail_page.dart';

class UniversityDetailShell extends StatelessWidget {
  const UniversityDetailShell({super.key, required this.universityId});

  final String universityId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: <Widget>[
          PageHeader(title: '院校详情'),
          UniversityDetailPage(universityId: universityId),
        ],
      ),
    );
  }
}
