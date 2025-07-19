// section_state.dart

import 'package:edutrack/core/Models/section_model.dart';

abstract class SectionState {}

class SectionInitial extends SectionState {}

class SectionLoading extends SectionState {}

class SectionLoaded extends SectionState {
  final List<SectionModel> sections;
  SectionLoaded(this.sections);
}

class SectionError extends SectionState {
  final String message;
  SectionError(this.message);
}
