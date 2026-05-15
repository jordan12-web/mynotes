import 'package:flutter/material.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/theme/app_theme.dart';
import 'package:mynotes/utilities/dialogs/delete_dialog.dart';
import 'package:mynotes/widgets/note_card.dart';

typedef NoteCallBack = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallBack onDeleteNotes;
  final NoteCallBack onTap;

  const NotesListView({
    super.key,
    required this.notes,
    required this.onDeleteNotes,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final noteList = notes.toList();

    if (noteList.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.note_add_outlined,
                size: 64,
                color: AppColors.primary.withValues(alpha: 0.35),
              ),
              const SizedBox(height: 20),
              Text(
                'No notes yet',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tap + to capture your first thought.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, height: 1.4),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
      itemCount: noteList.length,
      itemBuilder: (context, index) {
        final note = noteList[index];
        return NoteCard(
          note: note,
          onTap: () => onTap(note),
          onDelete: () async {
            final shouldDelete = await showDeleteDialog(context);
            if (shouldDelete) {
              onDeleteNotes(note);
            }
          },
        );
      },
    );
  }
}
