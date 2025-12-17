import 'dart:typed_data';

import 'package:fit_app/application/dto/exercise.dart';
import 'package:fit_app/application/interactors/create_exercise.dart';
import 'package:fit_app/application/interactors/update_exercise.dart';
import 'package:fit_app/application/interfaces/file_manager.dart';
import 'package:fit_app/domain/entities/exercise.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreateExerciseSheet extends StatefulWidget {
  const CreateExerciseSheet({super.key, this.exercise});

  final Exercise? exercise;

  @override
  State<CreateExerciseSheet> createState() => _CreateExerciseSheetState();
}

class _CreateExerciseSheetState extends State<CreateExerciseSheet> {
  final _nameController = TextEditingController();
  final _techniqueController = TextEditingController();
  final _notesController = TextEditingController();
  final List<TextEditingController> _linkControllers = [];
  bool _usesWeights = true;
  Uint8List? _photoPreviewBytes;
  Uint8List? _pendingPhotoBytes;
  bool _removePhoto = false;
  bool _loadingExistingPhoto = false;
  final ImagePicker _imagePicker = ImagePicker();

  late final CreateExercise _createExercise;
  late final UpdateExercise _updateExercise;
  late final FileManager _fileManager;
  bool _dependenciesReady = false;
  bool get _isEditing => widget.exercise != null;

  @override
  void initState() {
    super.initState();
    final exercise = widget.exercise;
    if (exercise != null) {
      _nameController.text = exercise.name;
      _techniqueController.text = exercise.technique ?? '';
      _notesController.text = exercise.notes ?? '';
      _usesWeights = exercise.usesWeights;
      if (exercise.links.isEmpty) {
        _linkControllers.add(TextEditingController());
      } else {
        for (final link in exercise.links) {
          _linkControllers.add(TextEditingController(text: link));
        }
      }
    } else {
      _linkControllers.add(TextEditingController());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_dependenciesReady) return;
    _createExercise = context.read<CreateExercise>();
    _updateExercise = context.read<UpdateExercise>();
    _fileManager = context.read<FileManager>();
    _dependenciesReady = true;
    final exercise = widget.exercise;
    if (exercise?.photoId != null) {
      _loadExistingPhoto(exercise!.photoId!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _techniqueController.dispose();
    _notesController.dispose();
    for (final controller in _linkControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addLinkField() {
    setState(() => _linkControllers.add(TextEditingController()));
  }

  void _removeLinkField(int index) {
    if (_linkControllers.length == 1) {
      _linkControllers[index].clear();
      return;
    }
    final controller = _linkControllers.removeAt(index);
    controller.dispose();
    setState(() {});
  }

  Future<void> _loadExistingPhoto(String photoId) async {
    setState(() => _loadingExistingPhoto = true);
    await Future<void>.delayed(Duration.zero);
    try {
      final bytes = _fileManager.read(photoId);
      if (!mounted) return;
      setState(() {
        _photoPreviewBytes = bytes;
        _loadingExistingPhoto = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingExistingPhoto = false);
    }
  }

  Future<void> _pickPhoto() async {
    final picked = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 85,
    );
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    if (!mounted) return;
    setState(() {
      _photoPreviewBytes = bytes;
      _pendingPhotoBytes = bytes;
      _removePhoto = false;
    });
  }

  void _removePhotoSelection() {
    final hadExisting = widget.exercise?.photoId != null;
    setState(() {
      _photoPreviewBytes = null;
      _pendingPhotoBytes = null;
      _removePhoto = hadExisting;
    });
  }

  void _submit() {
    final name = _nameController.text.trim();
    final technique = _techniqueController.text.trim();
    final notes = _notesController.text.trim();
    if (name.isEmpty) {
      _showMessage('Enter exercise name');
      return;
    }
    final techniqueValue = technique.isEmpty ? null : technique;
    final notesValue = notes.isEmpty ? null : notes;

    final links = _linkControllers
        .map((controller) => controller.text.trim())
        .where((link) => link.isNotEmpty)
        .toList();

    if (_isEditing) {
      final dto = UpdateExerciseDTO(
        exerciseId: widget.exercise!.id,
        name: name,
        technique: techniqueValue,
        notes: notesValue,
        links: links,
        photoBytes: _pendingPhotoBytes,
        removePhoto: _removePhoto,
      );
      _updateExercise.execute(dto);
    } else {
      final dto = NewExerciseDTO(
        name: name,
        technique: techniqueValue,
        notes: notesValue,
        usesWeights: _usesWeights,
        links: links,
        photoBytes: _pendingPhotoBytes,
      );

      _createExercise.execute(dto);
    }
    Navigator.of(context).pop(true);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 24,
          bottom: bottomPadding + 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _isEditing ? 'Edit Exercise' : 'Create Exercise',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Exercise name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Photo',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _loadingExistingPhoto
                  ? const SizedBox(
                      height: 180,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : _photoPreviewBytes != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            _photoPreviewBytes!,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(
                          height: 180,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white24),
                          ),
                          alignment: Alignment.center,
                          child: const Text('No photo selected'),
                        ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickPhoto,
                    icon: const Icon(Icons.photo_library_outlined),
                    label: Text(_photoPreviewBytes == null
                        ? 'Add photo'
                        : 'Change photo'),
                  ),
                  const SizedBox(width: 12),
                  if (_photoPreviewBytes != null ||
                      (widget.exercise?.photoId != null && !_removePhoto))
                    TextButton.icon(
                      onPressed: _removePhotoSelection,
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Remove'),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _techniqueController,
                decoration: const InputDecoration(
                  labelText: 'Technique description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                value: _usesWeights,
                title: const Text('Uses weights'),
                onChanged: _isEditing
                    ? null
                    : (value) => setState(() => _usesWeights = value),
              ),
              const SizedBox(height: 12),
              Text(
                'Links',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ...List.generate(_linkControllers.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _linkControllers[index],
                          decoration: InputDecoration(
                            labelText: 'Link ${index + 1}',
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => _removeLinkField(index),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                );
              }),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: _addLinkField,
                  icon: const Icon(Icons.add),
                  label: const Text('Add link'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: Text(_isEditing ? 'Save changes' : 'Add exercise'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
