import 'package:flutter/material.dart';

import '../../core/storage/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/brand_mark.dart';

/// A local, itinerary-aware social template prototype. Album and photo data is
/// deliberately in-memory so the workflow can be demonstrated without a photo
/// picker, upload service, or social-network connection.
class StudioPage extends StatefulWidget {
  const StudioPage({super.key});

  @override
  State<StudioPage> createState() => _StudioPageState();
}

class _StudioPageState extends State<StudioPage> {
  _StudioStage _stage = _StudioStage.home;
  final Set<String> _selectedAlbumIds = <String>{};
  final Set<String> _selectedPhotoIds = <String>{};
  String _format = '9:16 Story';

  static const _albums = [
    _SharedAlbum(
      id: 'breakfast',
      day: 'DAY 2 · 09:00',
      plan: 'Traditional breakfast stop',
      location: 'Campbell Street · George Town',
      photoCount: 6,
      accent: AppColors.amber,
      photos: [
        _SharedPhoto(
          id: 'breakfast-kopi',
          title: 'Kopi corner',
          caption: 'Morning light',
          start: Color(0xFFB96847),
          end: Color(0xFFF6D99A),
          icon: Icons.coffee_rounded,
        ),
        _SharedPhoto(
          id: 'breakfast-table',
          title: 'The table',
          caption: 'First bites',
          start: Color(0xFF4F6D62),
          end: Color(0xFFB7D4BF),
          icon: Icons.breakfast_dining_rounded,
        ),
      ],
    ),
    _SharedAlbum(
      id: 'heritage',
      day: 'DAY 2 · 10:30',
      plan: 'Heritage street discovery',
      location: 'Armenian Street · George Town',
      photoCount: 14,
      accent: AppColors.terracotta,
      photos: [
        _SharedPhoto(
          id: 'heritage-mural',
          title: 'Mural pause',
          caption: 'Armenian Street',
          start: Color(0xFF718B78),
          end: Color(0xFFE8C294),
          icon: Icons.brush_rounded,
        ),
        _SharedPhoto(
          id: 'heritage-bikes',
          title: 'Laneway ride',
          caption: 'Old town',
          start: Color(0xFF4C6172),
          end: Color(0xFFA6CCDC),
          icon: Icons.pedal_bike_rounded,
        ),
        _SharedPhoto(
          id: 'heritage-window',
          title: 'Five-foot way',
          caption: 'Blue hour',
          start: Color(0xFF845F57),
          end: Color(0xFFE6B8A6),
          icon: Icons.window_rounded,
        ),
      ],
    ),
    _SharedAlbum(
      id: 'lunch',
      day: 'DAY 2 · 12:30',
      plan: 'Lunch with the group',
      location: 'Little India · George Town',
      photoCount: 9,
      accent: AppColors.sage,
      photos: [
        _SharedPhoto(
          id: 'lunch-briyani',
          title: 'Banana leaf lunch',
          caption: 'Shared table',
          start: Color(0xFFAC6E36),
          end: Color(0xFFF3D17B),
          icon: Icons.rice_bowl_rounded,
        ),
        _SharedPhoto(
          id: 'lunch-friends',
          title: 'Lunch stories',
          caption: 'The whole crew',
          start: Color(0xFF5A7A70),
          end: Color(0xFFB6D9D0),
          icon: Icons.groups_rounded,
        ),
      ],
    ),
    _SharedAlbum(
      id: 'rain-plan',
      day: 'DAY 2 · 02:00',
      plan: 'Indoor heritage stop',
      location: 'Cheong Fatt Tze Mansion · George Town',
      photoCount: 5,
      accent: AppColors.terracottaDark,
      photos: [
        _SharedPhoto(
          id: 'rain-blue',
          title: 'Blue Mansion',
          caption: 'Rain plan',
          start: Color(0xFF31556C),
          end: Color(0xFF91C1D2),
          icon: Icons.museum_rounded,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final trip = state.currentTrip;
    final destination = trip?.destination ?? 'your trip';
    final content = switch (_stage) {
      _StudioStage.home => _homeContent(context, destination),
      _StudioStage.albums => _albumContent(context),
      _StudioStage.photos => _photoContent(context),
      _StudioStage.canvas => _canvasContent(context, destination),
    };

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          key: const Key('studio-scroll'),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 108),
          children: [
            const _StudioTopBar(),
            const SizedBox(height: 24),
            ...content,
          ],
        ),
      ),
    );
  }

  List<Widget> _homeContent(BuildContext context, String destination) => [
    const Text(
      'SOCIAL STORY STUDIO',
      style: TextStyle(
        color: AppColors.terracottaDark,
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: .8,
      ),
    ),
    const SizedBox(height: 6),
    Text(
      'Turn trip moments into posts',
      style: Theme.of(context).textTheme.headlineLarge,
    ),
    const SizedBox(height: 7),
    Text(
      'Create story-ready frames from one or more shared albums in $destination.',
      style: const TextStyle(color: AppColors.muted, height: 1.4),
    ),
    const SizedBox(height: 18),
    _StudioHero(onCreate: () => setState(() => _stage = _StudioStage.albums)),
    const SizedBox(height: 26),
    Row(
      children: [
        Expanded(
          child: Text(
            'Shared albums by itinerary',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        TextButton(
          onPressed: () => setState(() => _stage = _StudioStage.albums),
          child: const Text('Use albums'),
        ),
      ],
    ),
    const SizedBox(height: 4),
    const Text(
      'Every plan has its own group album, ready for everyone to add moments.',
      style: TextStyle(color: AppColors.muted, fontSize: 12, height: 1.4),
    ),
    const SizedBox(height: 13),
    ..._albums
        .take(3)
        .map(
          (album) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _AlbumCard(
              album: album,
              onTap: () => setState(() {
                _selectedAlbumIds.add(album.id);
                _stage = _StudioStage.albums;
              }),
            ),
          ),
        ),
  ];

  List<Widget> _albumContent(BuildContext context) => [
    _StudioBackHeader(
      step: 'STEP 1 OF 3',
      title: 'Choose shared albums',
      detail: 'Select one or more itinerary plans. Their photos can be combined in one template.',
      onBack: () => setState(() => _stage = _StudioStage.home),
    ),
    const SizedBox(height: 18),
    ..._albums.map(
      (album) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: _AlbumCard(
          key: Key('album-${album.id}'),
          album: album,
          selected: _selectedAlbumIds.contains(album.id),
          onTap: () => setState(() {
            if (_selectedAlbumIds.contains(album.id)) {
              _selectedAlbumIds.remove(album.id);
              _selectedPhotoIds.removeWhere(
                (photoId) => album.photos.any((photo) => photo.id == photoId),
              );
            } else {
              _selectedAlbumIds.add(album.id);
            }
          }),
        ),
      ),
    ),
    const SizedBox(height: 8),
    SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _selectedAlbumIds.isEmpty
            ? null
            : () => setState(() => _stage = _StudioStage.photos),
        icon: const Icon(Icons.photo_library_outlined),
        label: Text(
          _selectedAlbumIds.isEmpty
              ? 'Select an album to continue'
              : 'Select photos from ${_selectedAlbumIds.length} album${_selectedAlbumIds.length == 1 ? '' : 's'}',
        ),
      ),
    ),
  ];

  List<Widget> _photoContent(BuildContext context) {
    final photos = _albums
        .where((album) => _selectedAlbumIds.contains(album.id))
        .expand((album) => album.photos)
        .toList();
    return [
      _StudioBackHeader(
        step: 'STEP 2 OF 3',
        title: 'Pick photos',
        detail: 'Choose up to three photos from the selected shared albums.',
        onBack: () => setState(() => _stage = _StudioStage.albums),
      ),
      const SizedBox(height: 18),
      GridView.count(
        crossAxisCount: 2,
        childAspectRatio: .86,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          for (final photo in photos)
            _PhotoTile(
              key: Key('photo-${photo.id}'),
              photo: photo,
              selected: _selectedPhotoIds.contains(photo.id),
              onTap: () => setState(() {
                if (_selectedPhotoIds.contains(photo.id)) {
                  _selectedPhotoIds.remove(photo.id);
                } else if (_selectedPhotoIds.length < 3) {
                  _selectedPhotoIds.add(photo.id);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Choose up to three photos for one template.',
                      ),
                    ),
                  );
                }
              }),
            ),
        ],
      ),
      const SizedBox(height: 18),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _selectedPhotoIds.isEmpty
              ? null
              : () => setState(() => _stage = _StudioStage.canvas),
          icon: const Icon(Icons.auto_awesome_outlined),
          label: Text(
            _selectedPhotoIds.isEmpty
                ? 'Select a photo to continue'
                : 'Create template with ${_selectedPhotoIds.length} photo${_selectedPhotoIds.length == 1 ? '' : 's'}',
          ),
        ),
      ),
    ];
  }

  List<Widget> _canvasContent(BuildContext context, String destination) {
    final selectedPhotos = _albums
        .expand((album) => album.photos)
        .where((photo) => _selectedPhotoIds.contains(photo.id))
        .toList();
    return [
      _StudioBackHeader(
        step: 'STEP 3 OF 3',
        title: 'Template canvas',
        detail:
            'A local preview using ${selectedPhotos.length} selected shared photo${selectedPhotos.length == 1 ? '' : 's'}.',
        onBack: () => setState(() => _stage = _StudioStage.photos),
      ),
      const SizedBox(height: 18),
      _StoryCanvas(photos: selectedPhotos, destination: destination),
      const SizedBox(height: 18),
      const Text(
        'POST FORMAT',
        style: TextStyle(
          color: AppColors.muted,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: .7,
        ),
      ),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: ['9:16 Story', '4:5 Post', '1:1 Square']
            .map(
              (format) => ChoiceChip(
                label: Text(format),
                selected: _format == format,
                onSelected: (_) => setState(() => _format = format),
              ),
            )
            .toList(),
      ),
      const SizedBox(height: 18),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Template saved to the shared album.'),
            ),
          ),
          icon: const Icon(Icons.ios_share_outlined),
          label: const Text('Save social template'),
        ),
      ),
      const SizedBox(height: 9),
      SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => setState(() {
            _selectedAlbumIds.clear();
            _selectedPhotoIds.clear();
            _stage = _StudioStage.albums;
          }),
          icon: const Icon(Icons.add_photo_alternate_outlined),
          label: const Text('Create another template'),
        ),
      ),
    ];
  }
}

enum _StudioStage { home, albums, photos, canvas }

class _StudioTopBar extends StatelessWidget {
  const _StudioTopBar();

  @override
  Widget build(BuildContext context) => Row(
    children: [
      const RoamWordmark(),
      const SizedBox(width: 10),
      const Expanded(
        child: Text(
          'Social Story Studio',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
        ),
      ),
    ],
  );
}

class _StudioHero extends StatelessWidget {
  const _StudioHero({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: AppColors.ink,
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
          color: Color(0x1F2C2623),
          blurRadius: 18,
          offset: Offset(0, 7),
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          width: 66,
          height: 78,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFE7B584), Color(0xFF9D5D47)],
            ),
          ),
          child: const Icon(Icons.auto_awesome_rounded, color: Colors.white),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create photo template',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Mix shared moments into a story-ready frame.',
                style: TextStyle(
                  color: Color(0xFFE4E0DA),
                  fontSize: 12,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 11),
              TextButton.icon(
                onPressed: onCreate,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.amber,
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                label: const Text('Start creating'),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _StudioBackHeader extends StatelessWidget {
  const _StudioBackHeader({
    required this.step,
    required this.title,
    required this.detail,
    required this.onBack,
  });

  final String step;
  final String title;
  final String detail;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextButton.icon(
        onPressed: onBack,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(0, 32),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        icon: const Icon(Icons.arrow_back_rounded, size: 17),
        label: const Text('Studio'),
      ),
      const SizedBox(height: 13),
      Text(
        step,
        style: const TextStyle(
          color: AppColors.terracottaDark,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: .8,
        ),
      ),
      const SizedBox(height: 5),
      Text(title, style: Theme.of(context).textTheme.headlineLarge),
      const SizedBox(height: 6),
      Text(detail, style: const TextStyle(color: AppColors.muted, height: 1.4)),
    ],
  );
}

class _AlbumCard extends StatelessWidget {
  const _AlbumCard({
    super.key,
    required this.album,
    required this.onTap,
    this.selected = false,
  });

  final _SharedAlbum album;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) => Material(
    color: selected ? AppColors.blushStrong : AppColors.parchment,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(
        color: selected ? AppColors.terracotta : AppColors.line,
        width: selected ? 1.5 : 1,
      ),
    ),
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 58,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [album.accent.withValues(alpha: .94), AppColors.ink],
                ),
              ),
              child: const Icon(
                Icons.photo_library_rounded,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    album.day,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: .5,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    album.plan,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${album.location} · ${album.photoCount} photos',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 7),
            Icon(
              selected
                  ? Icons.check_circle_rounded
                  : Icons.add_circle_outline_rounded,
              color: selected ? AppColors.terracottaDark : AppColors.muted,
            ),
          ],
        ),
      ),
    ),
  );
}

class _PhotoTile extends StatelessWidget {
  const _PhotoTile({
    super.key,
    required this.photo,
    required this.selected,
    required this.onTap,
  });

  final _SharedPhoto photo;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    clipBehavior: Clip.antiAlias,
    borderRadius: BorderRadius.circular(16),
    child: InkWell(
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [photo.start, photo.end],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.terracottaDark : AppColors.line,
            width: selected ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Icon(photo.icon, size: 40, color: const Color(0xCCFFFFFF)),
            ),
            Positioned(
              left: 10,
              right: 10,
              bottom: 10,
              child: Text(
                photo.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  shadows: [Shadow(color: Color(0x66000000), blurRadius: 4)],
                ),
              ),
            ),
            Positioned(
              top: 9,
              right: 9,
              child: Icon(
                selected
                    ? Icons.check_circle_rounded
                    : Icons.add_circle_outline_rounded,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _StoryCanvas extends StatelessWidget {
  const _StoryCanvas({required this.photos, required this.destination});

  final List<_SharedPhoto> photos;
  final String destination;

  @override
  Widget build(BuildContext context) {
    final first = photos.isEmpty ? _fallbackPhoto : photos.first;
    final second = photos.length > 1 ? photos[1] : first;
    final third = photos.length > 2 ? photos[2] : second;
    return Center(
      child: AspectRatio(
        aspectRatio: .62,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 310),
          decoration: BoxDecoration(
            color: AppColors.ink,
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                color: Color(0x242C2623),
                blurRadius: 22,
                offset: Offset(0, 9),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Stack(
              children: [
                Positioned.fill(child: _CanvasPhoto(photo: first)),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 74,
                  child: Row(
                    children: [
                      Expanded(
                        child: _CanvasPhoto(photo: second, compact: true),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _CanvasPhoto(photo: third, compact: true),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 16,
                  top: 17,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.parchment.withValues(alpha: .92),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: const Text(
                      'DAY 2 · 4 STOPS',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 17,
                  right: 17,
                  bottom: 18,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'GEORGE TOWN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          height: 1,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -.6,
                          shadows: [
                            Shadow(color: Color(0x99000000), blurRadius: 8),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        destination,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFFF5EEE4),
                          fontWeight: FontWeight.w700,
                          shadows: [
                            Shadow(color: Color(0x99000000), blurRadius: 6),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static const _fallbackPhoto = _SharedPhoto(
    id: 'preview',
    title: 'Shared moment',
    caption: 'Studio preview',
    start: Color(0xFF59786F),
    end: Color(0xFFE9BE8D),
    icon: Icons.photo_camera_rounded,
  );
}

class _CanvasPhoto extends StatelessWidget {
  const _CanvasPhoto({required this.photo, this.compact = false});

  final _SharedPhoto photo;
  final bool compact;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [photo.start, photo.end],
      ),
    ),
    child: Center(
      child: Icon(
        photo.icon,
        size: compact ? 25 : 58,
        color: const Color(0xBFFFFFFF),
      ),
    ),
  );
}

class _SharedAlbum {
  const _SharedAlbum({
    required this.id,
    required this.day,
    required this.plan,
    required this.location,
    required this.photoCount,
    required this.accent,
    required this.photos,
  });

  final String id;
  final String day;
  final String plan;
  final String location;
  final int photoCount;
  final Color accent;
  final List<_SharedPhoto> photos;
}

class _SharedPhoto {
  const _SharedPhoto({
    required this.id,
    required this.title,
    required this.caption,
    required this.start,
    required this.end,
    required this.icon,
  });

  final String id;
  final String title;
  final String caption;
  final Color start;
  final Color end;
  final IconData icon;
}
