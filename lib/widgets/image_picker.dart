import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as imagePicker;
import 'dart:io';

class CustomImagePicker extends StatefulWidget{
  final ValueChanged<String> onImagePicked; // Callback для передачи пути
  final coverPath;

  const CustomImagePicker({Key? key, required this.onImagePicked, required this.coverPath}) : super(key: key);

  @override
  _CustomImagePickerState createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  File? _imageFile; // Хранит выбранное изображение
  final imagePicker.ImagePicker _picker = imagePicker.ImagePicker(); // Экземпляр ImagePicker

  // Метод для выбора изображения из галереи
  Future<void> _pickImage() async {
    final imagePicker.XFile? pickedFile = await _picker.pickImage(source: imagePicker.ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      widget.onImagePicked(pickedFile.path); // Передаем путь через callback
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage, // При нажатии открываем галерею для выбора изображения
      child: _imageFile == null
        ? ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          width: 100,
          height: 134,
          color: Theme.of(context).colorScheme.primaryContainer,
          child: const Icon(Icons.book, size: 30, color: Colors.black54),
        )
      )
      : ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.file(
          _imageFile!,
          width: 100,
          height: 134,
          fit: BoxFit.cover,
        ),
      )
    );
  }
}