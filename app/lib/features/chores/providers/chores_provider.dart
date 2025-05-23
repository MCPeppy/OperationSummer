import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chore.dart';

final choresProvider = StateProvider<List<Chore>>((ref) => []);
