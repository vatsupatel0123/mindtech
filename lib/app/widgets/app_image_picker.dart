// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:mindtech/app/config/app_colors.dart';
// import 'package:mindtech/app/config/app_dimensions.dart';
// import 'package:mindtech/app/config/app_images.dart';
// import 'package:mindtech/app/config/app_strings.dart';
// import 'package:mindtech/app/config/app_text_styles.dart';
// import 'package:mindtech/app/widgets/app_loader.dart';
// import 'app_button.dart';
// import 'app_text.dart';
//
// class AppImagePicker extends StatelessWidget {
//   final String? Function(File?) validator;
//   final Function(File) onChanged;
//   final bool isCameraOnly, isGalleryOnly;
//   File? _pickedImage;
//
//   AppImagePicker({
//     Key? key,
//     required this.validator,
//     required this.onChanged,
//     this.isCameraOnly = false,
//     this.isGalleryOnly = false,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return FormField<File>(
//       validator: validator,
//       builder: (formFieldState) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             AppButton(
//               onTap: () {
//                 if (isCameraOnly) {
//                   _pickImage(ImageSource.camera);
//                 } else if (isGalleryOnly) {
//                   _pickImage(ImageSource.gallery);
//                 } else {
//                   _showPickerDialog(context);
//                 }
//               },
//               buttonText: AppString.upload_image,
//               width: AppScreen.width(context) / 2.2,
//             ),
//             if (formFieldState.hasError)
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 15,
//                   vertical: 5,
//                 ),
//                 child: AppText(
//                   "Please choose an image",
//                   fontSize: AppSize.s12,
//                   color: AppColor.red,
//                 ),
//               ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _showPickerDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Select Image Source'),
//           content: SingleChildScrollView(
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 GestureDetector(
//                   child: Column(
//                     children: [
//                       Image.asset(
//                         AppImage.galleryIcon,
//                         height: 60,
//                         width: 80,
//                         fit: BoxFit.cover,
//                       ),
//                       SizedBox(
//                         height: AppSize.s8,
//                       ),
//                       AppText(
//                         'Gallery',
//                         fontSize: AppSize.s18,
//                         fontWeight: AppFontWeight.medium,
//                       ),
//                     ],
//                   ),
//                   onTap: () async {
//                     Navigator.pop(context);
//                     _pickImage(ImageSource.gallery);
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 GestureDetector(
//                   child: Column(
//                     children: [
//                       Image.asset(
//                         AppImage.photoIcon,
//                         height: 60,
//                         width: 60,
//                         fit: BoxFit.fill,
//                       ),
//                       SizedBox(
//                         height: AppSize.s8,
//                       ),
//                       AppText(
//                         'Camera',
//                         fontSize: AppSize.s18,
//                         fontWeight: AppFontWeight.medium,
//                       ),
//                     ],
//                   ),
//                   onTap: () async {
//                     Navigator.pop(context);
//                     _pickImage(
//                       ImageSource.camera,
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   void _pickImage(ImageSource source) async {
//     final ImagePicker _picker = ImagePicker();
//     final XFile? image = await _picker.pickImage(
//       source: source,
//       imageQuality: 80,
//     );
//     if (image != null) {
//       _pickedImage = File(image.path);
//       onChanged.call(_pickedImage!);
//     }
//   }
// }
