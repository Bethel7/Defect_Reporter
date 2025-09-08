import '../../../core/utils/network_checker.dart';
import 'package:defect_reporter/core/common/bottom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
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
import '../../../features/report/data/report_repository_provider.dart';
import '../../../services/offline_storage_service.dart';
import '../../../services/location_service.dart';
import 'location_selector.dart';
import 'location_provider.dart';
import '../../../core/common/notification_bell.dart';

class ReportFormPage extends ConsumerStatefulWidget {
  const ReportFormPage({super.key});

  @override
  ConsumerState<ReportFormPage> createState() => _ReportFormPageState();
}

class _ReportFormPageState extends ConsumerState<ReportFormPage> {
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    final service = LocationService();
    final position = await service.getCurrentLocation(context);
    if (mounted && position != null) {
      setState(() {
        _currentPosition = position;
      });
    }
  }

  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _titleTouched = false;
  bool _descriptionTouched = false;
  bool _submitted = false;
  String? _locationError;
  String? _imageError;

  Future<void> _refreshForm() async {
    ref.invalidate(activeLocationsProvider);
    // Optionally, you can also reload userIdProvider if needed:
    // ref.invalidate(userIdProvider);
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    final formProvider = ref.watch(reportFormProvider.notifier);
    final formState = ref.watch(reportFormProvider);

    final repository = ref.watch(reportRepositoryProvider);
    final userIdAsync = ref.watch(userIdProvider);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final grayBorder = InputBorders.adaptive(color: theme.dividerColor);
    final greenBorder = InputBorders.adaptive(color: colorScheme.primary);
    final redBorder = InputBorders.adaptive(
      color: colorScheme.error,
      isError: true,
    );

    final titleValid = Validators.validateTitle(formState.title) == null;
    final descriptionValid =
        Validators.validateDescription(formState.description) == null;

    return userIdAsync.when(
      data: (userId) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: colorScheme.brightness == Brightness.dark
                ? Colors.grey[900]
                : Colors.white,
            elevation: 0,
            leading: Semantics(
              label: 'Back',
              button: true,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: colorScheme.brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (route) => false,
                ),
                tooltip: 'Back',
              ),
            ),
            title: Semantics(
              label: 'New Report Page',
              header: true,
              child: Text(
                'New Report',
                style:
                    theme.textTheme.titleLarge?.copyWith(
                      color: colorScheme.brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ) ??
                    TextStyle(
                      color: colorScheme.brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
              ),
            ),
            actions: [
              const NotificationBell(),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Semantics(
                  label: 'Open profile menu',
                  button: true,
                  child: ProfilePopupMenu(),
                ),
              ),
            ],
            centerTitle: false,
            scrolledUnderElevation: 0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                color:
                    (colorScheme.brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black)
                        .withOpacity(0.07),
                height: 1,
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: RefreshIndicator(
                      onRefresh: _refreshForm,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
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
                                    if (!_titleTouched && !_submitted) {
                                      return null;
                                    }
                                    return Validators.validateTitle(val);
                                  },
                                  onChanged: (val) {
                                    formProvider.setTitle(val);
                                    setState(() => _titleTouched = true);
                                  },
                                  focusNode: _titleFocusNode,
                                  border: grayBorder,
                                  enabledBorder: grayBorder,
                                  focusedBorder:
                                      (_titleFocusNode.hasFocus && titleValid)
                                      ? greenBorder
                                      : (_titleFocusNode.hasFocus &&
                                            !_titleTouched &&
                                            !_submitted)
                                      ? grayBorder
                                      : (_titleFocusNode.hasFocus
                                            ? redBorder
                                            : grayBorder),
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
                                focusNode: _descriptionFocusNode,
                                border: grayBorder,
                                enabledBorder: grayBorder,
                                focusedBorder:
                                    (_descriptionFocusNode.hasFocus &&
                                        descriptionValid)
                                    ? greenBorder
                                    : (_descriptionFocusNode.hasFocus &&
                                          !_descriptionTouched &&
                                          !_submitted)
                                    ? grayBorder
                                    : (_descriptionFocusNode.hasFocus
                                          ? redBorder
                                          : grayBorder),
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
                                child: Consumer(
                                  builder: (context, ref, _) {
                                    final locationsAsync = ref.watch(
                                      activeLocationsProvider,
                                    );
                                    return locationsAsync.when(
                                      data: (locations) => LocationSelector(
                                        locations: locations,
                                        selectedLocationId:
                                            formState.locationId,
                                        selectedLocationName:
                                            formState.locationName,
                                        onLocationSelected: (id, name) {
                                          formProvider.setLocation(id, name);
                                          setState(() => _locationError = null);
                                        },
                                        onNewLocationAdded: (name) async {
                                          final service = ref.read(
                                            locationApiServiceProvider,
                                          );
                                          final newId = await service
                                              .createLocation(name);
                                          // Invalidate the provider so the dropdown refreshes
                                          ref.invalidate(
                                            activeLocationsProvider,
                                          );
                                          formProvider.setLocation(newId, name);
                                          setState(() => _locationError = null);
                                          return newId;
                                        },
                                        errorText: _locationError,
                                        textStyle: const TextStyle(
                                          color: Color(0xFF252525),
                                          fontSize: 15,
                                        ),
                                      ),
                                      loading: () =>
                                          const CircularProgressIndicator(),
                                      error: (e, _) => Text('Error: $e'),
                                    );
                                  },
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
                                    backgroundColor:
                                        colorScheme.brightness ==
                                            Brightness.dark
                                        ? colorScheme.surface
                                        : Colors.white,
                                    foregroundColor:
                                        colorScheme.brightness ==
                                            Brightness.dark
                                        ? colorScheme.onSurface
                                        : const Color(0xFF474747),
                                    side: BorderSide(
                                      color:
                                          colorScheme.brightness ==
                                              Brightness.dark
                                          ? colorScheme.outline.withOpacity(0.4)
                                          : AppColors.borderGray,
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
                                          setState(() => _submitted = true);
                                          bool valid = _formKey.currentState!
                                              .validate();
                                          String? locationError =
                                              Validators.validateLocationId(
                                                formState.locationId
                                                    ?.toString(),
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
                                            // Always fetch latest location before submit
                                            final service = LocationService();
                                            final position = await service
                                                .getCurrentLocation(context);
                                            double? latitude;
                                            double? longitude;
                                            if (position != null) {
                                              latitude = position.latitude;
                                              longitude = position.longitude;
                                              setState(() {
                                                _currentPosition = position;
                                              });
                                            } else {
                                              latitude = null;
                                              longitude = null;
                                            }
                                            final isOnline =
                                                await InternetStatusChecker
                                                    .instance
                                                    .isConnected;
                                            if (isOnline) {
                                              // Pass context only; provider handles location
                                              final result = await formProvider
                                                  .submit(context);
                                              if (result != null &&
                                                  context.mounted) {
                                                final reportId =
                                                    result['reportId']
                                                        ?.toString();
                                                ReportModel? serverReport;
                                                if (reportId != null &&
                                                    reportId.isNotEmpty) {
                                                  try {
                                                    final remoteDataSource =
                                                        ref.read(
                                                              reportRepositoryProvider,
                                                            )
                                                            as dynamic;
                                                    serverReport =
                                                        await remoteDataSource
                                                            .remoteDataSource
                                                            .getMyReportById(
                                                              reportId,
                                                            );
                                                  } catch (e) {
                                                    // fallback to local data if fetch fails
                                                    serverReport = null;
                                                  }
                                                }
                                                ref
                                                    .read(
                                                      reportFormProvider
                                                          .notifier,
                                                    )
                                                    .reset();
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) => ReportConfirmationPage(
                                                      report:
                                                          serverReport ??
                                                          ReportModel(
                                                            localId: DateTime.now()
                                                                .millisecondsSinceEpoch
                                                                .toString(),
                                                            title:
                                                                formState.title,
                                                            description:
                                                                formState
                                                                    .description,
                                                            locationName:
                                                                formState
                                                                    .locationName ??
                                                                '',
                                                            status: 'submitted',
                                                            imageUrl: formState
                                                                .imagePath,
                                                            timestamp:
                                                                DateTime.tryParse(
                                                                  result['timestamp']
                                                                          ?.toString() ??
                                                                      '',
                                                                ) ??
                                                                DateTime.now(),
                                                            latitude: latitude,
                                                            longitude:
                                                                longitude,
                                                            locationId:
                                                                formState
                                                                    .locationId,
                                                          ),
                                                    ),
                                                  ),
                                                );
                                              }
                                            } else {
                                              // For offline/cached reports, use localId only
                                              final localId = DateTime.now()
                                                  .millisecondsSinceEpoch
                                                  .toString();
                                              final report = ReportModel(
                                                localId: localId,

                                                title: formState.title,
                                                description:
                                                    formState.description,
                                                locationName:
                                                    formState.locationName ??
                                                    '',
                                                status: 'submitted',
                                                imageUrl: formState.imagePath,
                                                timestamp: DateTime.now(),
                                                latitude:
                                                    _currentPosition?.latitude,
                                                longitude:
                                                    _currentPosition?.longitude,
                                                locationId:
                                                    formState.locationId,
                                              );
                                              await OfflineStorageService()
                                                  .saveReport(report);
                                              ref
                                                  .read(
                                                    reportFormProvider.notifier,
                                                  )
                                                  .reset();
                                              if (context.mounted) {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        CachedReportConfirmationPage(
                                                          report: report,
                                                        ),
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
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.error,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: const MainBottomAppBar(),
        ),
      ),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, st) =>
          Scaffold(body: Center(child: Text('Error loading user ID: $e'))),
    );
  }
}
