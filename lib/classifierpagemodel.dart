import 'package:my_eyes/classifier.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class ClassifierPageModel extends Classifier {
  ClassifierPageModel({int? numThreads}) : super(numThreads: numThreads);

  @override
  String get modelName => 'model1.tflite';

  @override
  String get labelsFileName => 'assets/labels1.txt';

  @override
  NormalizeOp get preProcessNormalizeOp => NormalizeOp(127.5, 127.5);

  @override
  NormalizeOp get postProcessNormalizeOp => NormalizeOp(0, 1);
}
