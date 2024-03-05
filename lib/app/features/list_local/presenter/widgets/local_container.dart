import 'package:flutter/material.dart';
import 'package:geosave/app/common/colors/colors_app.dart';
import 'package:geosave/app/common/entity/local_entity.dart';
import 'package:geosave/app/features/local/presenter/local_screen.dart';

class LocalContainer extends StatelessWidget {
  const LocalContainer({
    Key? key,
    required this.local,
  }) : super(key: key);

  final LocalEntity local;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LocalScreen(
              local: local,
            ),
          ),
        );
      },
      child: Container(
        width: width * 0.3,
        height: 50,
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: ColorsApp.white150,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(
              Icons.pin_drop,
              color: ColorsApp.green100,
            ),
            Text(
              local.nomeLocal,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
