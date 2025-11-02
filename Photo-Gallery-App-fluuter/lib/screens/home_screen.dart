import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/photo_provider.dart';
import '../models/photo.dart';
import 'fullscreen_photo_screen.dart';

/// Home screen displaying the photo gallery in a grid layout
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSelectionMode = false;
  final Set<String> _selectedPhotoIds = {};

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isSelectionMode) {
          setState(() {
            _isSelectionMode = false;
            _selectedPhotoIds.clear();
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
        floatingActionButton: _buildFloatingActionButtons(),
      ),
    );
  }

  /// Build the app bar with dynamic title based on selection mode
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: _isSelectionMode
          ? Text('${_selectedPhotoIds.length} selected')
          : const Text('Photo Gallery'),
      elevation: 4,
      actions: _isSelectionMode
          ? _buildSelectionActions()
          : _buildDefaultActions(),
    );
  }

  /// Build app bar actions in selection mode
  List<Widget> _buildSelectionActions() {
    return [
      if (_selectedPhotoIds.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.delete),
          tooltip: 'Delete selected',
          onPressed: _deleteSelectedPhotos,
        ),
      IconButton(
        icon: const Icon(Icons.close),
        tooltip: 'Cancel selection',
        onPressed: () {
          setState(() {
            _isSelectionMode = false;
            _selectedPhotoIds.clear();
          });
        },
      ),
    ];
  }

  /// Build default app bar actions
  List<Widget> _buildDefaultActions() {
    return [
      Consumer<PhotoProvider>(
        builder: (context, photoProvider, _) {
          return IconButton(
            icon: const Icon(Icons.more_vert),
            tooltip: 'More options',
            onPressed: () => _showOptionsMenu(context),
          );
        },
      ),
    ];
  }

  /// Build the main body with grid or empty state
  Widget _buildBody() {
    return Consumer<PhotoProvider>(
      builder: (context, photoProvider, _) {
        if (photoProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (photoProvider.photos.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_not_supported,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No photos yet',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Take a photo or select from gallery to get started',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (photoProvider.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 80, color: Colors.red[400]),
                const SizedBox(height: 16),
                Text('Error', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    photoProvider.errorMessage ?? 'Unknown error',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    photoProvider.clearError();
                    photoProvider.loadPhotos();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: photoProvider.photos.length,
            itemBuilder: (context, index) {
              return _buildPhotoGridItem(context, photoProvider.photos[index]);
            },
          ),
        );
      },
    );
  }

  /// Build individual photo grid item
  Widget _buildPhotoGridItem(BuildContext context, Photo photo) {
    final isSelected = _selectedPhotoIds.contains(photo.id);

    return GestureDetector(
      onLongPress: () {
        setState(() {
          _isSelectionMode = true;
          if (isSelected) {
            _selectedPhotoIds.remove(photo.id);
          } else {
            _selectedPhotoIds.add(photo.id);
          }
        });
      },
      onTap: () {
        if (_isSelectionMode) {
          setState(() {
            if (isSelected) {
              _selectedPhotoIds.remove(photo.id);
              if (_selectedPhotoIds.isEmpty) {
                _isSelectionMode = false;
              }
            } else {
              _selectedPhotoIds.add(photo.id);
            }
          });
        } else {
          _navigateToFullscreen(context, photo);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 3,
                )
              : null,
        ),
        child: Stack(
          children: [
            // Photo image
            Hero(
              tag: photo.id,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[300],
                ),
                child: Image.file(
                  photo.getFile(),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.grey[400],
                        size: 40,
                      ),
                    );
                  },
                ),
              ),
            ),
            // Selection indicator overlay
            if (isSelected)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black.withOpacity(0.4),
                ),
                child: Center(
                  child: Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                    size: 40,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Navigate to fullscreen photo view with Hero animation
  void _navigateToFullscreen(BuildContext context, Photo photo) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FullscreenPhotoScreen(photo: photo);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  /// Build floating action buttons
  Widget _buildFloatingActionButtons() {
    if (_isSelectionMode) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: 'pick_gallery',
          onPressed: () {
            final photoProvider = context.read<PhotoProvider>();
            photoProvider.pickFromGallery();
          },
          tooltip: 'Pick from gallery',
          child: const Icon(Icons.image),
        ),
        const SizedBox(height: 16),
        FloatingActionButton(
          heroTag: 'pick_multiple',
          onPressed: () {
            final photoProvider = context.read<PhotoProvider>();
            photoProvider.pickMultipleFromGallery();
          },
          tooltip: 'Pick multiple',
          child: const Icon(Icons.collections),
        ),
        const SizedBox(height: 16),
        FloatingActionButton(
          onPressed: () {
            final photoProvider = context.read<PhotoProvider>();
            photoProvider.takePhoto();
          },
          tooltip: 'Take photo',
          child: const Icon(Icons.camera_alt),
        ),
      ],
    );
  }

  /// Show options menu
  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final photoProvider = context.read<PhotoProvider>();
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.refresh),
                  title: const Text('Refresh'),
                  onTap: () {
                    Navigator.pop(context);
                    photoProvider.loadPhotos();
                  },
                ),
                if (photoProvider.photos.isNotEmpty)
                  ListTile(
                    leading: const Icon(Icons.select_all),
                    title: const Text('Select all'),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _isSelectionMode = true;
                        _selectedPhotoIds.clear();
                        _selectedPhotoIds.addAll(
                          photoProvider.photos.map((p) => p.id),
                        );
                      });
                    },
                  ),
                if (photoProvider.photos.isNotEmpty)
                  ListTile(
                    leading: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                    title: const Text(
                      'Delete all',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _showDeleteAllConfirmation(context);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Delete selected photos
  void _deleteSelectedPhotos() {
    if (_selectedPhotoIds.isEmpty) return;

    final count = _selectedPhotoIds.length;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete photos?'),
          content: Text(
            'Are you sure you want to delete $count photo${count > 1 ? 's' : ''}? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                final photoProvider = context.read<PhotoProvider>();
                photoProvider.deleteMultiplePhotos(_selectedPhotoIds.toList());
                setState(() {
                  _isSelectionMode = false;
                  _selectedPhotoIds.clear();
                });
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  /// Show delete all confirmation
  void _showDeleteAllConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete all photos?'),
          content: const Text(
            'Are you sure you want to delete all photos? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                final photoProvider = context.read<PhotoProvider>();
                photoProvider.clearAllPhotos();
              },
              child: const Text(
                'Delete all',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
