
import 'package:flutter/material.dart';
import '../services.dart';
import '../theme.dart';
import '../widgets/custom_text_field.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  List<Map<String, dynamic>> posts = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  Future<void> loadPosts() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await AppServices.getPosts();

      if (!mounted) return;

      setState(() {
        posts = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = 'تعذر تحميل المنشورات. تحقق من اتصالك بالإنترنت.';
        isLoading = false;
      });
    }
  }

  Future<void> showCreatePostDialog() async {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    final areaController = TextEditingController();
    bool isSaving = false;

    await showDialog(
      context: context,
      barrierDismissible: !isSaving,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                'إنشاء منشور',
                textAlign: TextAlign.right,
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextField(
                      label: 'عنوان المنشور',
                      hint: 'اكتب عنواناً واضحاً',
                      controller: titleController,
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      label: 'محتوى المنشور',
                      hint: 'اكتب ما تريد مشاركته...',
                      controller: contentController,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      label: 'المنطقة (اختياري)',
                      hint: 'مثلاً: الحلة',
                      controller: areaController,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSaving
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: const Text('إلغاء'),
                ),
                ElevatedButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          final title = titleController.text.trim();
                          final content = contentController.text.trim();
                          final area = areaController.text.trim();

                          if (title.isEmpty || content.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('اكتب العنوان ومحتوى المنشور'),
                              ),
                            );
                            return;
                          }

                          setDialogState(() {
                            isSaving = true;
                          });

                          try {
                            await AppServices.createPost(
                              title: title,
                              content: content,
                              area: area.isEmpty ? null : area,
                            );

                            if (!mounted) return;

                            Navigator.pop(dialogContext);

                            ScaffoldMessenger.of(this.context).showSnackBar(
                              const SnackBar(
                                content: Text('تم نشر منشورك بنجاح'),
                              ),
                            );

                            await loadPosts();
                          } catch (e) {
                            setDialogState(() {
                              isSaving = false;
                            });

                            ScaffoldMessenger.of(this.context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'لم نتمكن من نشر المنشور. حاول مرة أخرى.',
                                ),
                              ),
                            );
                          }
                        },
                  child: isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('نشر'),
                ),
              ],
            );
          },
        );
      },
    );

    titleController.dispose();
    contentController.dispose();
    areaController.dispose();
  }

  String formatDate(dynamic value) {
    final date = DateTime.tryParse(value?.toString() ?? '');

    if (date == null) return '';

    final localDate = date.toLocal();

    return '${localDate.year}/${localDate.month}/${localDate.day} '
        '${localDate.hour.toString().padLeft(2, '0')}:'
        '${localDate.minute.toString().padLeft(2, '0')}';
  }

  Widget buildPostCard(Map<String, dynamic> post) {
    final title = post['title']?.toString() ?? '';
    final content = post['content']?.toString() ?? '';
    final area = post['area']?.toString() ?? '';
    final imageUrl = post['image_url']?.toString() ?? '';
    final createdAt = formatDate(post['created_at']);

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFFE3F2FD),
                  child: Icon(
                    Icons.person,
                    color: WaynTheme.primary,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'مستخدم WAYN',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (area.isNotEmpty)
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: WaynTheme.muted,
                      ),
                      Text(
                        area,
                        style: const TextStyle(
                          color: WaynTheme.muted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: WaynTheme.text,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                height: 1.6,
                color: WaynTheme.text,
              ),
            ),
            if (imageUrl.isNotEmpty) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 14,
                  color: WaynTheme.muted,
                ),
                const SizedBox(width: 5),
                Text(
                  createdAt,
                  style: const TextStyle(
                    fontSize: 12,
                    color: WaynTheme.muted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'المجتمع',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: showCreatePostDialog,
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'إنشاء منشور',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: loadPosts,
        child: isLoading
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 180),
                  Center(child: CircularProgressIndicator()),
                ],
              )
            : errorMessage != null
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(24),
                    children: [
                      const SizedBox(height: 120),
                      const Icon(
                        Icons.cloud_off_outlined,
                        size: 55,
                        color: WaynTheme.muted,
                      ),
                      const SizedBox(height: 16),
                      Center(child: Text(errorMessage!)),
                      const SizedBox(height: 12),
                      Center(
                        child: TextButton(
                          onPressed: loadPosts,
                          child: const Text('إعادة المحاولة'),
                        ),
                      ),
                    ],
                  )
                : posts.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          const SizedBox(height: 140),
                          const Icon(
                            Icons.forum_outlined,
                            size: 65,
                            color: WaynTheme.muted,
                          ),
                          const SizedBox(height: 16),
                          const Center(
                            child: Text(
                              'لا توجد منشورات حتى الآن',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Center(
                            child: Text('كن أول من يشارك في المجتمع'),
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: showCreatePostDialog,
                              icon: const Icon(Icons.add),
                              label: const Text('إنشاء منشور'),
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          return buildPostCard(posts[index]);
                        },
                      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showCreatePostDialog,
        backgroundColor: WaynTheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.edit),
      ),
    );
  }
}
