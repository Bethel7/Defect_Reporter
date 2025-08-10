import 'package:defect_reporter/core/common/bottom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'report_form_provider.dart';
import 'image_input.dart';
import 'report_confirmation_page.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/validators.dart';
import 'location_selector.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/custom_button.dart';
import '../../../core/common/profile_popup_menu.dart';
import '../../../features/my_reports/presentation/my_reports_provider.dart';
import '../../../features/report/data/report_model.dart';
import '../../../core/utils/network_checker.dart';
import '../../../widgets/offline_banner.dart';
import '../../../services/offline_storage_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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
      borderSide: BorderSide(color: AppColors.borderGray),
    );
    OutlineInputBorder greenBorder = const OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.borderGreen),
    );
    OutlineInputBorder redBorder = const OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.borderRed),
    );

    bool titleValid = Validators.validateTitle(formState.title) == null;
    bool descriptionValid =
        Validators.validateDescription(formState.description) == null;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Semantics(
            label: 'New Report Page',
            header: true,
            child: Text(
              'New Report',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          leading: Semantics(
            label: 'Back',
            button: true,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.primary),
              onPressed: () => Navigator.pop(context),
              tooltip: 'Back',
            ),
          ),
          actions: [
            Semantics(
              label: 'Notifications',
              button: true,
              child: IconButton(
                icon: const Icon(Icons.notifications, color: AppColors.primary),
                onPressed: () {
                  Navigator.pushNamed(context, '/notifications');
                },
                tooltip: 'Notifications',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Semantics(
                label: 'Open profile menu',
                button: true,
                child: ProfilePopupMenu(),
              ),
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
                              focusedBorder: titleValid ? greenBorder : grayBorder,
                              errorBorder: redBorder,
                              focusedErrorBorder: redBorder,
                              errorStyle: const TextStyle(color: AppColors.error),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Description
                          Semantics(
                            label: 'Report Description Input',
                            textField: true,
                            child: TextFormField(
                              initialValue: formState.description,
                              decoration: InputDecoration(
                                labelText: 'Description',
                                alignLabelWithHint: true,
                                border: grayBorder,
                                enabledBorder: grayBorder,
                                focusedBorder: descriptionValid
                                    ? greenBorder
                                    : grayBorder,
                                errorBorder: redBorder,
                                focusedErrorBorder: redBorder,
                                errorStyle: const TextStyle(color: AppColors.error),
                              ),
                              maxLines: 3,
                              onChanged: (val) {
                                formProvider.setDescription(val);
                                setState(() {
                                  _descriptionTouched = true;
                                });
                              },
                              validator: (val) {
                                if (!_descriptionTouched && !_submitted) return null;
                                return Validators.validateDescription(val);
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Location Selector
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
                            ),
                          ),
                          if (_locationError != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4, left: 8),
                              child: Text(
                                _locationError!,
                                style: const TextStyle(
                                  color: AppColors.error,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          const SizedBox(height: 32),
                          // Image upload area
                          Semantics(
                            label: 'Image Upload Area',
                            child: ImageInput(
                              onImageSelected: (path) {
                                formProvider.setImagePath(path);
                                setState(() {
                                  _imageError = null;
                                });
                              },
                            ),
                          ),
                          if (_imageError != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8, left: 8),
                              child: Text(
                                _imageError!,
                                style: const TextStyle(
                                  color: AppColors.error,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          const SizedBox(height: 30),
                          // Cancel and Submit buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Semantics(
                                  label: 'Cancel Report Submission',
                                  button: true,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: AppColors.primary,
                                      side: const BorderSide(color: AppColors.primary),
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
                                      Navigator.pushReplacementNamed(context, '/home');
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Semantics(
                                  label: 'Submit Report',
                                  button: true,
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
                                              final isConnected = await NetworkChecker().isConnected;
                                              if (isConnected) {
                                                final result = await formProvider.submit();
                                                if (result != null && context.mounted) {
                                                  ref
                                                      .read(myReportsProvider.notifier)
                                                      .addReport(
                                                        ReportModel(
                                                          id: result['reportId'] ?? '',
                                                          title: formState.title,
                                                          description:
                                                              formState.description,
                                                          location: formState.location,
                                                          status: "Submitted",
                                                          imageUrl: formState.imagePath,
                                                          aiDepartment: null,
                                                          aiSeverity: null,
                                                          timestamp: DateTime.tryParse(
                                                            result['timestamp'] ?? '',
                                                          ),
                                                        ),
                                                      );
                                                  ref
                                                      .read(reportFormProvider.notifier)
                                                      .reset();

                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          ReportConfirmationPage(
                                                            reportId: result['reportId']!,
                                                            timestamp: result['timestamp']!,
                                                            submittedTitle: formState.title,
                                                            submittedDescription:
                                                                formState.description,
                                                            submittedLocation:
                                                                formState.location,
                                                          ),
                                                    ),
                                                  );
                                                }
                                              } else {
                                                // Save offline
                                                await OfflineStorageService().saveReport(
                                                  ReportModel(
                                                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                                                    title: formState.title,
                                                    description: formState.description,
                                                    location: formState.location,
                                                    status: "Submitted",
                                                    imageUrl: formState.imagePath,
                                                    aiDepartment: null,
                                                    aiSeverity: null,
                                                    timestamp: DateTime.now(),
                                                  ),
                                                );
                                                ref.read(reportFormProvider.notifier).reset();
                                                if (context.mounted) {
                                                  Navigator.pushReplacementNamed(context, '/home');
                                                }
                                              }
                                            }
                                          },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (formState.error != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              formState.error!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
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