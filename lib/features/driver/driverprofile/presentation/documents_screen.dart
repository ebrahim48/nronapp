import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nron_app/features/driver/driverprofile/presentation/widgets/document_list_tile.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/custom_widgets/custom_button.dart';
import '../../../../core/custom_widgets/custom_text.dart';
import '../controller/documents_controller.dart';
import 'car_picture_screen.dart';
import 'driving_license_screen.dart';
import 'nid_rax_id_screen.dart';


class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  final _ctrl = DocumentsController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _navigateToDoc(String id) {
    switch (id) {
      case 'nid':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NidTaxIdScreen(
              onSubmitted: () => _ctrl.markUploaded('nid'),
            ),
          ),
        );
        break;
      case 'driving_license':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DrivingLicenseScreen(
              onSubmitted: () =>
                  _ctrl.markUploaded('driving_license'),
            ),
          ),
        );
        break;
      case 'driver_car':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CarPicturesScreen(
              onSubmitted: () =>
                  _ctrl.markUploaded('driver_car'),
            ),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2427),
        elevation: 0,
        toolbarHeight: 52.h,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios,
              color: AppColors.primaryTextColor, size: 18.r),
        ),
        title: CustomText(
          text: 'Upload Your Documents',
          fontsize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryTextColor,
          textAlign: TextAlign.start,
        ),
        centerTitle: false,
      ),
      body: ListenableBuilder(
        listenable: _ctrl,
        builder: (context, _) {
          return SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      24.w, 50.h, 24.w, 110.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomText(
                        text: 'Upload your documents',
                        fontsize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryTextColor,
                      ),
                      SizedBox(height: 8.h),
                      CustomText(
                        text:
                        'Please upload the required documents to complete your application process',
                        fontsize: 12.sp,
                        color: AppColors.secondaryTextColor,
                        textHeight: 1.5,
                      ),
                      SizedBox(height: 36.h),

                      ..._ctrl.documents.asMap().entries.map((e) {
                        final isLast =
                            e.key == _ctrl.documents.length - 1;
                        return DocumentListTile(
                          document: e.value,
                          onTap: () => _navigateToDoc(e.value.id),
                          isLast: isLast,
                        );
                      }),
                    ],
                  ),
                ),

                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: AppColors.backgroundColor,
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.w, vertical: 12.h),
                    child: CustomButton(
                      title: 'Submit',
                      loading: _ctrl.isLoading,
                      onpress: () async {
                        await _ctrl.submit();
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}