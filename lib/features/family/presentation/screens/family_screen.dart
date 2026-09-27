import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/launcher_utils.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../data/models/family_member_model.dart';
import '../../domain/providers/family_providers.dart';

class FamilyScreen extends ConsumerStatefulWidget {
  const FamilyScreen({super.key});

  @override
  ConsumerState<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends ConsumerState<FamilyScreen> {
  final _meetingPointController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.read(meetingPointProvider.future).then((point) {
      _meetingPointController.text = point;
    });
  }

  @override
  void dispose() {
    _meetingPointController.dispose();
    super.dispose();
  }

  void _saveMeetingPoint() {
    ref
        .read(familyRepositoryProvider)
        .saveMeetingPoint(_meetingPointController.text.trim());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã lưu địa điểm tập kết an toàn offline!'),
        backgroundColor: AppColors.safeGreen,
      ),
    );
  }

  void _showAddMemberDialog(BuildContext context) {
    final nameController = TextEditingController();
    final relationController = TextEditingController();
    final phoneController = TextEditingController();
    final bloodTypeController = TextEditingController();
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: const Text('Thêm Thành Viên Gia Đình'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Họ và tên *'),
              ),
              TextField(
                controller: relationController,
                decoration: const InputDecoration(labelText: 'Mối quan hệ (Bố, Mẹ, Con...)'),
              ),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Số điện thoại *'),
              ),
              TextField(
                controller: bloodTypeController,
                decoration: const InputDecoration(labelText: 'Nhóm máu (A, B, AB, O)'),
              ),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(labelText: 'Ghi chú y tế (Dị ứng thuốc...)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy', style: TextStyle(color: AppColors.textLightSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.emergencyRed,
              minimumSize: const Size(80, 36),
            ),
            onPressed: () {
              final name = nameController.text.trim();
              final phone = phoneController.text.trim();
              if (name.isNotEmpty && phone.isNotEmpty) {
                final newMember = FamilyMemberModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: name,
                  relation: relationController.text.trim(),
                  phone: phone,
                  bloodType: bloodTypeController.text.trim(),
                  medicalNotes: notesController.text.trim(),
                );
                ref.read(familyNotifierProvider.notifier).addMember(newMember);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final familyState = ref.watch(familyNotifierProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Hồ Sơ An Toàn Gia Đình',
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_rounded),
            tooltip: 'Thêm thành viên',
            onPressed: () => _showAddMemberDialog(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Meeting Point Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.dividerDark),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.meeting_room_outlined, color: AppColors.warningAmber, size: 22),
                    SizedBox(width: 8),
                    Text(
                      'ĐIỂM HẸN TẬP KẾT AN TOÀN',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Nơi các thành viên tập trung khi bị lạc nhau trong thiên tai và mất sóng điện thoại:',
                  style: TextStyle(fontSize: 12, color: AppColors.textLightSecondary),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _meetingPointController,
                        decoration: const InputDecoration(
                          hintText: 'Ví dụ: Cổng trường Tiểu học Tân Bình, Tầng 3 UBND...',
                          hintStyle: TextStyle(fontSize: 13, color: AppColors.textLightSecondary),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.check_circle, color: AppColors.safeGreenLight),
                      onPressed: _saveMeetingPoint,
                      tooltip: 'Lưu điểm hẹn',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            'DANH BẠ THÂN NHÂN KHẨN CẤP',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 10),

          familyState.when(
            data: (members) {
              if (members.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(24),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.group_outlined, size: 48, color: AppColors.textLightSecondary),
                      const SizedBox(height: 12),
                      const Text(
                        'Chưa có thông tin người thân',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Thêm số điện thoại người thân để có thể gọi nhanh ngay cả khi hoảng loạn.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: AppColors.textLightSecondary),
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.emergencyRed,
                          minimumSize: const Size(160, 42),
                        ),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Thêm thành viên'),
                        onPressed: () => _showAddMemberDialog(context),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: members.map((member) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.emergencyRed.withOpacity(0.18),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: const Icon(Icons.person, color: AppColors.emergencyRedLight),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      member.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    if (member.relation.isNotEmpty) ...[
                                      const SizedBox(width: 8),
                                      Text(
                                        '(${member.relation})',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: AppColors.textLightSecondary,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  member.phone,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.warningAmber,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (member.bloodType.isNotEmpty || member.medicalNotes.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      [
                                        if (member.bloodType.isNotEmpty) 'Nhóm máu: ${member.bloodType}',
                                        if (member.medicalNotes.isNotEmpty) member.medicalNotes,
                                      ].join(' • '),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textLightSecondary,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.phone, color: AppColors.safeGreenLight),
                            tooltip: 'Gọi ngay',
                            onPressed: () => LauncherUtils.makePhoneCall(member.phone),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.white38, size: 20),
                            tooltip: 'Xóa',
                            onPressed: () {
                              ref
                                  .read(familyNotifierProvider.notifier)
                                  .removeMember(member.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Text('Lỗi: $err'),
          ),
        ],
      ),
    );
  }
}
