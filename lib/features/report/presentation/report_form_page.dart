import 'package:defect_reporter/core/common/bottom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'report_form_provider.dart';
import 'image_input.dart';
import 'report_confirmation_page.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/custom_button.dart';
import '../../../core/common/profile_popup_menu.dart';
import '../../../features/my_reports/presentation/my_reports_provider.dart';
import '../../../features/report/data/report_model.dart';
import '../../../core/utils/network_checker.dart';
import '../../../widgets/offline_banner.dart';
import '../../../services/offline_storage_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'location_selector.dart';
import '../../../core/theme/text_styles.dart';

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

    OutlineInputBorder grayBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      borderSide: BorderSide(color: AppColors.borderGray),
    );
    OutlineInputBorder greenBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      borderSide: BorderSide(color: AppColors.borderGreen),
    );
    OutlineInputBorder redBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      borderSide: BorderSide(color: AppColors.borderRed),
    );

    bool titleValid = Validators.validateTitle(formState.title) == null;
    bool descriptionValid =
        Validators.validateDescription(formState.description) == null;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.black12,
          titleSpacing: 0,
          title: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text('New Report', style: TextStyles.headlineMedium),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.text),
            onPressed: () => Navigator.pop(context),
            tooltip: 'Back',
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Navigator.pushNamed(context, '/notifications');
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      FontAwesomeIcons.bell,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: ProfilePopupMenu(),
            ),
          ],
        ),
        body: StreamBuilder<ConnectivityResult>(
          stream: NetworkChecker().onConnectivityChanged,
          builder: (context, snapshot) {
            final isConnected = snapshot.data != ConnectivityResult.none;
            return Column(
              children: [
                if (!isConnected) const OfflineBanner(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      child: ListView(
                        children: [
                          // Title
                          Semantics(
                            label: 'Report Title Input',
                            textField: true,
                            child: CustomTextField(
                              label: 'Title',
                              initialValue: formState.title,
                              validator: (val) {
                                if (!_titleTouched && !_submitted) return null;
                                return Validators.validateTitle(val);
                              },
                              onChanged: (val) {
                                formProvider.setTitle(val);
                                setState(() {
                                  _titleTouched = true;
                                });
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
                          const SizedBox(height: 16),
                          // Description
                          Semantics(
                            label: 'Report Description Input',
                            textField: true,
                            child: CustomTextField(
                              label: 'Description',
                              initialValue: formState.description,
                              maxLines: 3,
                              border: grayBorder,
                              enabledBorder: grayBorder,
                              focusedBorder: descriptionValid
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
                              onChanged: (val) {
                                formProvider.setDescription(val);
                                setState(() {
                                  _descriptionTouched = true;
                                });
                              },
                              validator: (val) {
                                if (!_descriptionTouched && !_submitted)
                                  return null;
                                return Validators.validateDescription(val);
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Location Selector (modular)
                          Semantics(
                            label: 'Location Selector',
                            child: LocationSelector(
                              selectedLocation: formState.location,
                              onLocationSelected: (loc) {
                                formProvider.setLocation(loc);
                                setState(() {
                                  _locationError = null;
                                });
                              },
                              errorText: _locationError,
                              textStyle: const TextStyle(
                                color: Color(0xFF252525),
                                fontSize: 15,
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
                                    setState(() {
                                      _imageError = null;
                                    });
                                  },
                                ),
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
                                    foregroundColor: AppColors.primary,
                                    side: const BorderSide(
                                      color: AppColors.primary,
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
                                    ref
                                        .read(reportFormProvider.notifier)
                                        .reset();
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
                                          setState(() {
                                            _submitted = true;
                                          });
                                          bool valid = _formKey.currentState!
                                              .validate();
                                          String? locationError =
                                              Validators.validateLocation(
                                                formState.location,
                                              );
                                          String? imageError = kIsWeb
                                              ? null // Skip image validation on web
                                              : Validators.validateImagePath(
                                                  formState.imagePath,
                                                );

                                          setState(() {
                                            _locationError = locationError;
                                            _imageError = imageError;
                                          });

                                          if (valid &&
                                              locationError == null &&
                                              imageError == null) {
                                            final isConnected =
                                                await NetworkChecker()
                                                    .isConnected;
                                            if (isConnected) {
                                              final result = await formProvider
                                                  .submit();
                                              if (result != null &&
                                                  context.mounted) {
                                                ref
                                                    .read(
                                                      myReportsProvider
                                                          .notifier,
                                                    )
                                                    .addReport(
                                                      ReportModel(
                                                        id:
                                                            result['reportId'] ??
                                                            '',
                                                        title: formState.title,
                                                        description: formState
                                                            .description,
                                                        location:
                                                            formState.location,
                                                        status: "Submitted",
                                                        imageUrl:
                                                            formState.imagePath,
                                                        aiDepartment: null,
                                                        aiSeverity: null,
                                                        timestamp:
                                                            DateTime.tryParse(
                                                              result['timestamp'] ??
                                                                  '',
                                                            ),
                                                      ),
                                                    );
                                                ref
                                                    .read(
                                                      reportFormProvider
                                                          .notifier,
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
                                                              formState
                                                                  .description,
                                                          submittedLocation:
                                                              formState
                                                                  .location,
                                                        ),
                                                  ),
                                                );
                                              }
                                            } else {
                                              // Save offline
                                              await OfflineStorageService()
                                                  .saveReport(
                                                    ReportModel(
                                                      id: DateTime.now()
                                                          .millisecondsSinceEpoch
                                                          .toString(),
                                                      title: formState.title,
                                                      description:
                                                          formState.description,
                                                      location:
                                                          formState.location,
                                                      status: "Submitted",
                                                      imageUrl:
                                                          formState.imagePath,
                                                      aiDepartment: null,
                                                      aiSeverity: null,
                                                      timestamp: DateTime.now(),
                                                    ),
                                                  );
                                              ref
                                                  .read(
                                                    reportFormProvider.notifier,
                                                  )
                                                  .reset();
                                              if (context.mounted) {
                                                Navigator.pushReplacementNamed(
                                                  context,
                                                  '/home',
                                                );
                                              }
                                            }
                                          }
                                        },
                                ),
                              ),
                            ],
                          ),
                          if (formState.error != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Text(
                                formState.error!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: const MainBottomAppBar(),
      ),
    );
  }
}
