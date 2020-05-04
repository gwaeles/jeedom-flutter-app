
import 'package:flutter_app/utils/bloc_helpers/bloc_event_state.dart';

class ScannerState extends BlocState {
  ScannerState({
    this.isRunning: false,
    this.isSuccess: false,
    this.isFailure: false,
  });

  final bool isRunning;
  final bool isSuccess;
  final bool isFailure;

  @override
  List<Object> get props => [isRunning, isSuccess, isFailure];

  factory ScannerState.idle() {
    return ScannerState();
  }

  factory ScannerState.running(){
    return ScannerState(isRunning: true,);
  }

  factory ScannerState.success(){
    return ScannerState(isSuccess: true,);
  }

  factory ScannerState.failure(){
    return ScannerState(isFailure: true,);
  }

}