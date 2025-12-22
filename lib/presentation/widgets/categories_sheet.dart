import 'package:fit_app/application/dto/category.dart';
import 'package:fit_app/application/interactors/create_category.dart';
import 'package:fit_app/application/interactors/delete_category.dart';
import 'package:fit_app/application/interactors/update_category.dart';
import 'package:fit_app/application/interfaces/repo/category.dart';
import 'package:fit_app/domain/entities/category.dart';
import 'package:fit_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CategoriesSheet extends StatefulWidget {
  const CategoriesSheet({
    super.key,
    required this.categoryRepository,
    required this.createCategory,
    required this.updateCategory,
    required this.deleteCategory,
  });

  final CategoryRepository categoryRepository;
  final CreateCategory createCategory;
  final UpdateCategory updateCategory;
  final DeleteCategory deleteCategory;

  @override
  State<CategoriesSheet> createState() => _CategoriesSheetState();
}

enum _CategoryAction { edit, delete }

class _CategoryEditResult {
  final String name;
  final Color color;

  const _CategoryEditResult({
    required this.name,
    required this.color,
  });
}

class _CategoriesSheetState extends State<CategoriesSheet> {
  final _nameController = TextEditingController();
  Color _selectedColor = Colors.blue;

  List<Category> _categories = const [];
  bool _creating = false;

  @override
  void initState() {
    super.initState();
    _categories = widget.categoryRepository.getAll();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _refreshCategories() {
    setState(() {
      _categories = widget.categoryRepository.getAll();
    });
  }

  Future<void> _createCategory() async {
    final l10n = AppLocalizations.of(context)!;
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _showMessage(l10n.errorCategoryNameRequired);
      return;
    }
    setState(() => _creating = true);
    try {
      final colorHex = _colorToHex(_selectedColor);
      widget.createCategory.execute(
        NewCategoryDTO(name: name, color: colorHex),
      );
      _nameController.clear();
      _refreshCategories();
      _showMessage(l10n.messageCategoryCreated);
    } catch (_) {
      _showMessage(l10n.errorCreateCategory);
    } finally {
      if (mounted) {
        setState(() => _creating = false);
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Color _colorFromHex(String value) {
    if (value.length == 7 && value.startsWith('#')) {
      final parsed = int.tryParse(value.substring(1), radix: 16);
      if (parsed != null) {
        return Color(0xFF000000 | parsed);
      }
    }
    return Colors.grey;
  }

  String _colorToHex(Color color) {
    final r = _componentToInt(color.r);
    final g = _componentToInt(color.g);
    final b = _componentToInt(color.b);
    return '#${r.toRadixString(16).padLeft(2, '0').toUpperCase()}'
        '${g.toRadixString(16).padLeft(2, '0').toUpperCase()}'
        '${b.toRadixString(16).padLeft(2, '0').toUpperCase()}';
  }

  int _componentToInt(double component) =>
      ((component * 255).round()).clamp(0, 255).toInt();

  Future<Color?> _showColorPickerDialog(Color initialColor) async {
    final l10n = AppLocalizations.of(context)!;
    Color tempColor = initialColor;
    final chosen = await showDialog<Color>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.categoryColorPickerTitle),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: tempColor,
            onColorChanged: (color) => tempColor = color,
            pickerAreaBorderRadius: const BorderRadius.all(Radius.circular(12)),
            displayThumbColor: true,
            enableAlpha: false,
            labelTypes: const [],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.buttonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(tempColor),
            child: Text(l10n.buttonSave),
          ),
        ],
      ),
    );
    return chosen;
  }

  Future<void> _pickColor() async {
    final chosen = await _showColorPickerDialog(_selectedColor);
    if (chosen != null) {
      setState(() => _selectedColor = chosen);
    }
  }

  Future<_CategoryEditResult?> _showEditCategoryDialog(Category category) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: category.name);
    Color tempColor = _colorFromHex(category.color);
    bool showNameError = false;
    final result = await showDialog<_CategoryEditResult>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: Text(l10n.categoryEditDialogTitle),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: controller,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: l10n.categoryNameLabel,
                    errorText:
                        showNameError ? l10n.errorCategoryNameRequired : null,
                  ),
                  onChanged: (_) {
                    if (showNameError) {
                      setStateDialog(() => showNameError = false);
                    }
                  },
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.categoryColorLabel,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: tempColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white24),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _colorToHex(tempColor),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 4),
                        OutlinedButton.icon(
                          onPressed: () async {
                            final chosen =
                                await _showColorPickerDialog(tempColor);
                            if (chosen != null) {
                              setStateDialog(() => tempColor = chosen);
                            }
                          },
                          icon: const Icon(Icons.color_lens_outlined),
                          label: Text(l10n.categoryPickColorButton),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.buttonCancel),
            ),
            FilledButton(
              onPressed: () {
                final trimmed = controller.text.trim();
                if (trimmed.isEmpty) {
                  setStateDialog(() => showNameError = true);
                  return;
                }
                Navigator.of(context).pop(
                  _CategoryEditResult(name: trimmed, color: tempColor),
                );
              },
              child: Text(l10n.buttonUpdate),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
    return result;
  }

  Future<void> _editCategory(Category category) async {
    final result = await _showEditCategoryDialog(category);
    if (result == null) return;
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    try {
      widget.updateCategory.execute(
        UpdateCategoryDTO(
          categoryId: category.id,
          name: result.name,
          color: _colorToHex(result.color),
        ),
      );
      _refreshCategories();
      _showMessage(l10n.messageCategoryUpdated);
    } catch (_) {
      _showMessage(l10n.errorUpdateCategory);
    }
  }

  Future<void> _deleteCategory(Category category) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.categoryDeleteDialogTitle),
        content: Text(l10n.categoryDeleteConfirmation(category.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.buttonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.buttonDelete),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }
    try {
      widget.deleteCategory.execute(category.id);
      _refreshCategories();
      _showMessage(l10n.messageCategoryDeleted);
    } catch (_) {
      _showMessage(l10n.errorDeleteCategory);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: SizedBox(
        height: size.height * 0.85,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    l10n.categoriesSheetTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    tooltip: l10n.buttonClose,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _categories.isEmpty
                    ? Center(
                        child: Text(
                          l10n.categoriesEmpty,
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.separated(
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          final color = _colorFromHex(category.color);
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: color,
                                child: const Icon(
                                  Icons.palette,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              title: Text(category.name),
                              trailing: PopupMenuButton<_CategoryAction>(
                                onSelected: (action) {
                                  switch (action) {
                                    case _CategoryAction.edit:
                                      _editCategory(category);
                                      break;
                                    case _CategoryAction.delete:
                                      _deleteCategory(category);
                                      break;
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: _CategoryAction.edit,
                                    child: Text(l10n.categoryActionEdit),
                                  ),
                                  PopupMenuItem(
                                    value: _CategoryAction.delete,
                                    child: Text(l10n.buttonDelete),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (_, unused) =>
                            const SizedBox(height: 8),
                        itemCount: _categories.length,
                      ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.categoryFormTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.categoryNameLabel,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.categoryColorLabel,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _selectedColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white24),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _colorToHex(_selectedColor),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      OutlinedButton.icon(
                        onPressed: _pickColor,
                        icon: const Icon(Icons.color_lens_outlined),
                        label: Text(l10n.categoryPickColorButton),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _creating ? null : _createCategory,
                  child: _creating
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.categoryCreateButton),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
