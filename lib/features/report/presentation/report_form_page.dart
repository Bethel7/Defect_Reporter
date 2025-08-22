import 'package:defect_reporter/core/common/bottom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'report_form_provider.dart';
import 'image_input.dart';
import 'report_confirmation_page.dart';
import 'cached_report_confirmation_page.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/input_borders.dart';
import '../../../core/utils/validators.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/custom_button.dart';
import '../../../core/common/profile_popup_menu.dart';
import '../../../features/my_reports/presentation/my_reports_provider.dart';
import '../../../features/report/data/report_model.dart';
import '../../../core/utils/network_checker.dart';
import '../../../services/offline_storage_service.dart';
import 'location_selector.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/common/notification_bell.dart';

class ReportFormPage extends ConsumerStatefulWidget {
  const ReportFormPage({super.key});

  @override
  ConsumerState<ReportFormPage> createState() => _ReportFormPageState();
}

class _ReportFormPageState extends ConsumerState<ReportFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _titleTouched = false;
  bool _descriptionTouched = false;
  bool _submitted = false;
  String? _locationError;
  String? _imageError;

  @override
  Widget build(BuildContext context) {
    final formProvider = ref.watch(reportFormProvider.notifier);
    final formState = ref.watch(reportFormProvider);

    final grayBorder = InputBorders.gray;
    final greenBorder = InputBorders.green;
    final redBorder = InputBorders.red;

    final titleValid = Validators.validateTitle(formState.title) == null;
    final descriptionValid =
        Validators.validateDescription(formState.description) == null;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          titleSpacing: 0,
          title: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              'New Report',
              style: TextStyles.headlineMedium.copyWith(
                color: AppColors.text,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.text),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              '/home',
              (route) => false,
            ),
            tooltip: 'Back',
          ),
          actions: [
            const NotificationBell(),
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: ProfilePopupMenu(),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: ListView(
                    children: [
                      Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: Semantics(
                            label: 'Report Title Input',
                            textField: true,
                            child: CustomTextField(
                              label: 'Title',
                              initialValue: formState.title,
                              maxLines: 1,
                              validator: (val) {
                                if (!_titleTouched && !_submitted) return null;
                                return Validators.validateTitle(val);
                              },
                              onChanged: (val) {
                                formProvider.setTitle(val);
                                setState(() => _titleTouched = true);
                              },
                              border: grayBorder,
                              enabledBorder: grayBorder,
                              focusedBorder: titleValid
                                  ? greenBorder
                                  : grayBorder,
                              errorBorder: redBorder,
                              focusedErrorBorder: redBorder,
                              errorStyle: const TextStyle(
                                color: AppColors.error,
                              ),
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF252525),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Description (twice the height)
                      Semantics(
                        label: 'Report Description Input',
                        textField: true,
                        child: Container(
                          width: MediaQuery.of(context).size.width - 32,
                          margin: const EdgeInsets.symmetric(horizontal: 0),
                          child: CustomTextField(
                            label: 'Description',
                            initialValue: formState.description,
                            maxLines: 2,
                            border: grayBorder,
                            enabledBorder: grayBorder,
                            focusedBorder: descriptionValid
                                ? greenBorder
                                : grayBorder,
                            errorBorder: redBorder,
                            focusedErrorBorder: redBorder,
                            errorStyle: const TextStyle(color: AppColors.error),
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF252525),
                            ),
                            onChanged: (val) {
                              formProvider.setDescription(val);
                              setState(() => _descriptionTouched = true);
                            },
                            validator: (val) {
                              if (!_descriptionTouched && !_submitted) {
                                return null;
                              }
                              return Validators.validateDescription(val);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Location Selector
                      Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: Semantics(
                            label: 'Location Selector',
                            child: LocationSelector(
                              selectedLocation: formState.location,
                              onLocationSelected: (loc) {
                                formProvider.setLocation(loc);
                                setState(() => _locationError = null);
                              },
                              errorText: _locationError,
                              textStyle: const TextStyle(
                                color: Color(0xFF252525),
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Image upload area
                      Semantics(
                        label: 'Image Upload Area',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ImageInput(
                              onImageSelected: (path) {
                                formProvider.setImagePath(path);
                                setState(() => _imageError = null);
                              },
                            ),
                            if (_imageError != null) ...[
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 8.0,
                                  left: 8.0,
                                ),
                                child: Text(
                                  _imageError!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Cancel and Submit buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF474747),
                                side: const BorderSide(
                                  color: AppColors.borderGray,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                              onPressed: () {
                                ref.read(reportFormProvider.notifier).reset();
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/home',
                                );
                              },
                              child: const Text('Cancel'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomButton(
                              label: 'Submit',
                              isLoading: formState.isSubmitting,
                              onPressed: formState.isSubmitting
                                  ? null
                                  : () async {
                                      setState(() => _submitted = true);
                                      bool valid = _formKey.currentState!
                                          .validate();
                                      String? locationError =
                                          Validators.validateLocation(
                                            formState.location,
                                          );
                                      String? imageError =
                                          Validators.validateImagePath(
                                            formState.imagePath,
                                          );
                                      setState(() {
                                        _locationError = locationError;
                                        _imageError = imageError;
                                      });
                                      if (valid &&
                                          locationError == null &&
                                          imageError == null) {
                                        final isOnline = await NetworkChecker().isConnected;
                                        if (isOnline) {
                                          final result = await formProvider
                                              .submit();
                                          if (result != null &&
                                              context.mounted) {
                                            ref
                                                .read(
                                                  myReportsProvider.notifier,
                                                )
                                                .addReport(
                                                  ReportModel(
                                                    id:
                                                        result['reportId'] ??
                                                        '',
                                                    title: formState.title,
                                                    description:
                                                        formState.description,
                                                    location:
                                                        formState.location,
                                                    status: ReportModel
                                                        .statusSubmitted,
                                                    imageUrl:
                                                        formState.imagePath,
                                                    timestamp:
                                                        DateTime.tryParse(
                                                          result['timestamp']
                                                                  ?.toString() ??
                                                              '',
                                                        ) ??
                                                        DateTime.now(),
                                                  ),
                                                );
                                            ref
                                                .read(
                                                  reportFormProvider.notifier,
                                                )
                                                .reset();
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    ReportConfirmationPage(
                                                      reportId:
                                                          result['reportId']!,
                                                      timestamp:
                                                          result['timestamp']!,
                                                      submittedTitle:
                                                          formState.title,
                                                      submittedDescription:
                                                          formState.description,
                                                      submittedLocation:
                                                          formState.location,
                                                      submittedImageUrl:
                                                          formState.imagePath,
                                                    ),
                                              ),
                                            );
                                          }
                                        } else {
                                          final report = ReportModel(
                                            id: DateTime.now()
                                                .millisecondsSinceEpoch
                                                .toString(),
                                            title: formState.title,
                                            description: formState.description,
                                            location: formState.location,
                                            status: ReportModel.statusSubmitted,
                                            imageUrl: formState.imagePath,
                                            timestamp: DateTime.now(),
                                          );
                                          await OfflineStorageService()
                                              .saveReport(report);
                                          ref
                                              .read(reportFormProvider.notifier)
                                              .reset();
                                          if (context.mounted) {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    CachedReportConfirmationPage(report: report),
                                              ),
                                            );
                                          }
                                        }
                                      }
                                    },
                            ),
                          ),
                        ],
                      ),
                      formState.error != null
                          ? Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Text(
                                formState.error!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: const MainBottomAppBar(),
      ),
    );
  }
}
