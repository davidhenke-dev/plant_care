import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../application/chat_notifier.dart';

const _kGreen = Color(0xFF4CAF50);
const _kPlantyName = 'Planty';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  String? _pendingImagePath;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      imageQuality: 80,
    );
    if (picked != null) setState(() => _pendingImagePath = picked.path);
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty && _pendingImagePath == null) return;
    ref.read(chatNotifierProvider.notifier).send(text, imagePath: _pendingImagePath);
    _controller.clear();
    setState(() => _pendingImagePath = null);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final state = ref.watch(chatNotifierProvider);

    ref.listen(chatNotifierProvider, (_, next) {
      if (!next.isLoading) _scrollToBottom();
    });

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          _kPlantyName,
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: state.messages.isEmpty
                  ? _EmptyState(l: l, onSuggestion: (s) {
                      _controller.text = s;
                      _send();
                    })
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      itemCount:
                          state.messages.length + (state.isLoading ? 1 : 0),
                      itemBuilder: (context, i) {
                        if (state.isLoading && i == state.messages.length) {
                          return const _TypingIndicator();
                        }
                        return _MessageBubble(message: state.messages[i]);
                      },
                    ),
            ),
            if (state.error != null)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Text(
                  l.chatErrorMessage,
                  style: const TextStyle(
                    color: CupertinoColors.systemRed,
                    fontSize: 13,
                  ),
                ),
              ),
            _InputBar(
              controller: _controller,
              pendingImagePath: _pendingImagePath,
              isLoading: state.isLoading,
              placeholder: l.chatPlaceholder,
              onPickImage: _pickImage,
              onRemoveImage: () => setState(() => _pendingImagePath = null),
              onSend: _send,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final AppLocalizations l;
  final ValueChanged<String> onSuggestion;

  const _EmptyState({required this.l, required this.onSuggestion});

  @override
  Widget build(BuildContext context) {
    final suggestions = [
      '🌿 Warum werden meine Blätter gelb?',
      '💧 Wie oft soll ich gießen?',
      '🌱 Welche Pflanze passt ins Büro?',
      '🔍 Pflanze identifizieren',
    ];

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Avatar
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _kGreen.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                CupertinoIcons.leaf_arrow_circlepath,
                size: 38,
                color: CupertinoColors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              _kPlantyName,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l.chatEmptySubtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: CupertinoColors.systemGrey,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            // Suggestion chips
            Wrap(
              spacing: 8,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: suggestions
                  .map((s) => _SuggestionChip(
                        label: s,
                        onTap: () => onSuggestion(s),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SuggestionChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: kCardBackground.resolveFrom(context),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: CupertinoColors.systemGrey4.resolveFrom(context),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

// ── Message bubble ────────────────────────────────────────────────────────────

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 30,
              height: 30,
              margin: const EdgeInsets.only(right: 8, bottom: 2),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.leaf_arrow_circlepath,
                size: 14,
                color: CupertinoColors.white,
              ),
            ),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                color: isUser ? _kGreen : kCardBackground.resolveFrom(context),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.systemGrey
                        .resolveFrom(context)
                        .withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.imagePath != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(message.imagePath!),
                        width: 200,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (message.text.isNotEmpty) const SizedBox(height: 8),
                  ],
                  if (message.text.isNotEmpty)
                    Text(
                      message.text,
                      style: TextStyle(
                        fontSize: 15,
                        color: isUser
                            ? CupertinoColors.white
                            : CupertinoColors.label.resolveFrom(context),
                        height: 1.45,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Typing indicator ──────────────────────────────────────────────────────────

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 30,
            height: 30,
            margin: const EdgeInsets.only(right: 8, bottom: 2),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              CupertinoIcons.leaf_arrow_circlepath,
              size: 14,
              color: CupertinoColors.white,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            decoration: BoxDecoration(
              color: kCardBackground.resolveFrom(context),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: const _ThreeDots(),
          ),
        ],
      ),
    );
  }
}

class _ThreeDots extends StatefulWidget {
  const _ThreeDots();

  @override
  State<_ThreeDots> createState() => _ThreeDotsState();
}

class _ThreeDotsState extends State<_ThreeDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final offset = ((_ctrl.value * 3) - i).clamp(0.0, 1.0);
            final scale = 0.6 + 0.4 * (offset < 0.5 ? offset * 2 : (1 - offset) * 2);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.5),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey2.resolveFrom(context),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

// ── Input bar ─────────────────────────────────────────────────────────────────

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final String? pendingImagePath;
  final bool isLoading;
  final String placeholder;
  final VoidCallback onPickImage;
  final VoidCallback onRemoveImage;
  final VoidCallback onSend;

  const _InputBar({
    required this.controller,
    required this.pendingImagePath,
    required this.isLoading,
    required this.placeholder,
    required this.onPickImage,
    required this.onRemoveImage,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (pendingImagePath != null) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 4),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(pendingImagePath!),
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: -6,
                    right: -6,
                    child: GestureDetector(
                      onTap: onRemoveImage,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: CupertinoColors.systemGrey,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          CupertinoIcons.xmark,
                          size: 11,
                          color: CupertinoColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          // Input container (Claude-style)
          Container(
            decoration: BoxDecoration(
              color: kCardBackground.resolveFrom(context),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: CupertinoColors.systemGrey4.resolveFrom(context),
              ),
              boxShadow: [
                BoxShadow(
                  color: CupertinoColors.systemGrey
                      .resolveFrom(context)
                      .withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Photo button
                CupertinoButton(
                  padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
                  onPressed: isLoading ? null : onPickImage,
                  child: Icon(
                    CupertinoIcons.photo,
                    size: 22,
                    color: isLoading
                        ? CupertinoColors.systemGrey3
                        : _kGreen,
                  ),
                ),
                // Text field
                Expanded(
                  child: CupertinoTextField.borderless(
                    controller: controller,
                    placeholder: placeholder,
                    placeholderStyle: const TextStyle(
                      color: CupertinoColors.systemGrey,
                      fontSize: 15,
                    ),
                    style: const TextStyle(fontSize: 15),
                    maxLines: 5,
                    minLines: 1,
                    textAlignVertical: TextAlignVertical.center,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => onSend(),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 4,
                    ),
                  ),
                ),
                // Send button
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
                  child: GestureDetector(
                    onTap: isLoading ? null : onSend,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: isLoading
                            ? CupertinoColors.systemGrey4.resolveFrom(context)
                            : _kGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        CupertinoIcons.arrow_up,
                        color: CupertinoColors.white,
                        size: 17,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
