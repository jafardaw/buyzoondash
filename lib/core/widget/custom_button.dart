import 'package:buyzoonapp/core/style/color.dart';
import 'package:buyzoonapp/core/style/styles.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.onTap, required this.text});

  final VoidCallback onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width < 600 ? 60 : 150,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          splashColor: Palette.primary.withValues(alpha: 0.5),
          highlightColor: Colors.transparent,
          child: Ink(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Palette.primary, Palette.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            width: double.infinity,
            height: MediaQuery.of(context).size.width < 600 ? 50 : 55,
            child: Center(
              child: Text(
                text,
                style: Styles.textStyle18Bold.copyWith(
                  color: Palette.backgroundColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:imagep/core/util/const.dart';
// import 'package:imagep/core/util/styles.dart';

// class CustomButton extends StatelessWidget {
//   const CustomButton({super.key, this.onTap, required this.text});

//   final VoidCallback? onTap;
//   final String text;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       // splashColor: Palette.primary,
//       // highlightColor: Colors.white,
//       child: Padding(
//         padding: EdgeInsets.symmetric(
//           horizontal: MediaQuery.of(context).size.width < 600 ? 100 : 150,
//         ),
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 250),
//           curve: Curves.easeInOut,
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               colors: [Palette.primary, Palette.primaryLight],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             boxShadow: [
//               // BoxShadow(
//               //   // ignore: deprecated_member_use
//               //   color: Colors.blueAccent.withOpacity(0.2),
//               //   spreadRadius: 2,
//               //   blurRadius: 8,
//               //   offset: const Offset(0, 4),
//               // ),
//             ],
//             borderRadius: const BorderRadius.all(Radius.circular(20)),
//           ),
//           width: double.infinity,
//           height: MediaQuery.of(context).size.width < 600 ? 50 : 55,
//           child: Center(
//             child: Text(
//               text,
//               style: Styles.textStyle18Bold.copyWith(
//                 color: Palette.backgroundColor,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }