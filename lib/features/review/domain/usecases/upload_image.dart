import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/review_repository.dart';

class UploadImage implements UseCase<String, File> {
  final ReviewRepository repository;

  UploadImage(this.repository);

  @override
  Future<Either<Failure, String>> call(File image) async {
    return await repository.uploadImage(image);
  }
}
