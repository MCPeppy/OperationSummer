import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

/// Builds a simple worksheet PDF and launches the print dialog.
Future<void> printSampleWorksheet() async {
  final doc = pw.Document();
  doc.addPage(
    pw.Page(
      build: (context) => pw.Center(
        child: pw.Text('Operation Summer Worksheet'),
      ),
    ),
  );
  await Printing.layoutPdf(onLayout: (format) async => doc.save());
}
