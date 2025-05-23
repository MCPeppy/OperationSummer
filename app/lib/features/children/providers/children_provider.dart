import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/child.dart';

final childrenProvider = StateProvider<List<Child>>((ref) => []);
