import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/lesson.dart';

final lessonsProvider = StateProvider<List<Lesson>>((ref) => []);
