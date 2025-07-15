import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sction_state.dart';

class SctionCubit extends Cubit<SctionState> {
  SctionCubit() : super(SctionInitial());
}
