import 'package:equatable/equatable.dart';

class BaseEquatable extends Equatable {
  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) => false;
  @override
  List<Object> get props => [];
}
