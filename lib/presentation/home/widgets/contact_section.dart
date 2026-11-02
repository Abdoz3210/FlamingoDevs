import 'package:bma_portfolio/core/constants/app_typogragh.dart';
import 'package:bma_portfolio/service/email_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// import '../../../core/theme/app_text_theme.dart';
import '../../../core/utils/responsive.dart';
// import '../../../services/email_service.dart';
import '../../shared_widgets/primary_button.dart';
import '../../shared_widgets/section_title.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  Future<void> _openEmail() async {
    final uri = Uri.parse('mailto:flamingodevsofficial@gmail.com');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _openWhatsApp() async {
    final uri = Uri.parse('https://wa.me/201033388204');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final vh = MediaQuery.sizeOf(context).height;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: vh),
      child: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            Responsive.sideMargin(context),
            isMobile ? 88 : 112,
            Responsive.sideMargin(context),
            isMobile ? 64 : 120,
          ),
          child: isMobile ? _buildMobile(context) : _buildDesktop(context),
        ),
      ),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _buildInfo(context)),
        const SizedBox(width: 60),
        Expanded(flex: 3, child: const _ContactForm()),
      ],
    );
  }

  Widget _buildMobile(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfo(context),
        const SizedBox(height: 40),
        const _ContactForm(),
      ],
    );
  }

  Widget _buildInfo(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          eyebrow: 'Contact',
          title: "Let's fold something",
          accent: 'together.',
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Text(
            'Tell us what you want to build and we will get back to you.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 28),

        // Email
        _ContactRow(
          icon: Icons.mail_outline,
          label: 'flamingodevsofficial@gmail.com',
          onTap: _openEmail,
        ),
        const SizedBox(height: 12),

        // WhatsApp
        _ContactRow(
          icon: Icons.chat_outlined,
          label: '+20 103 338 8204',
          onTap: _openWhatsApp,
        ),
        const SizedBox(height: 24),

        // Quick links to freelance platforms
        Text(
          'FIND US ON',
          style: AppTypogragh.mono(color: colors.onSurfaceVariant),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _PlatformChip(
              label: 'Fiverr',
              url: 'https://www.fiverr.com/s/rEWarQj',
            ),
            _PlatformChip(
              label: 'Freelancer',
              url: 'https://www.freelancer.com/u/flamingodevs',
            ),
            _PlatformChip(
              label: 'Upwork',
              url: 'https://www.upwork.com/freelancers/~012c563d8b6649e09f',
            ),
          ],
        ),
      ],
    );
  }
}

// ── Contact Row ──────────────────────────────────────────────

class _ContactRow extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ContactRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_ContactRow> createState() => _ContactRowState();
}

class _ContactRowState extends State<_ContactRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.icon,
              size: 16,
              color: _hovered ? colors.primary : colors.onSurfaceVariant,
            ),
            const SizedBox(width: 10),
            Text(
              widget.label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _hovered ? colors.primary : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Platform Chip ────────────────────────────────────────────

class _PlatformChip extends StatefulWidget {
  final String label;
  final String url;

  const _PlatformChip({required this.label, required this.url});

  @override
  State<_PlatformChip> createState() => _PlatformChipState();
}

class _PlatformChipState extends State<_PlatformChip> {
  bool _hovered = false;

  Future<void> _open() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: _open,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: _hovered ? colors.primary : colors.outlineVariant,
            ),
            color: _hovered
                ? colors.primary.withValues(alpha: 0.08)
                : Colors.transparent,
          ),
          child: Text(
            widget.label,
            style: AppTypogragh.mono(
              color: _hovered ? colors.primary : colors.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Contact Form ─────────────────────────────────────────────

enum _SubmitState { idle, loading, success, error }

class _ContactForm extends StatefulWidget {
  const _ContactForm();

  @override
  State<_ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<_ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  String _projectType = 'E-Commerce';
  _SubmitState _state = _SubmitState.idle;

  final _emailService = EmailService();

  static const _projectTypes = [
    'E-Commerce',
    'Education',
    'Payments / Fintech',
    'AI Integration',
    'App Redesign / Maintenance',
    'Something Else',
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _state = _SubmitState.loading);

    final ok = await _emailService.send(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      projectType: _projectType,
      message: _messageCtrl.text.trim(),
    );

    if (!mounted) return;

    setState(() => _state = ok ? _SubmitState.success : _SubmitState.error);

    if (ok) {
      _nameCtrl.clear();
      _emailCtrl.clear();
      _messageCtrl.clear();
      Future.delayed(const Duration(seconds: 4), () {
        if (mounted) setState(() => _state = _SubmitState.idle);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Field(
            label: 'FULL NAME',
            controller: _nameCtrl,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 28),

          _Field(
            label: 'EMAIL ADDRESS',
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Required';
              if (!v.contains('@')) return 'Enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: 28),

          // Project type dropdown
          Text(
            'PROJECT TYPE',
            style: AppTypogragh.mono(color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _projectType,
            isExpanded: true,
            decoration: const InputDecoration(isDense: true),
            items: _projectTypes
                .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                .toList(),
            onChanged: (v) => setState(() => _projectType = v ?? _projectType),
          ),
          const SizedBox(height: 28),

          _Field(
            label: 'TELL US ABOUT THE VISION',
            controller: _messageCtrl,
            maxLines: 4,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 32),

          // Error message
          if (_state == _SubmitState.error)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'Something went wrong. Please try again or '
                'contact us directly on WhatsApp.',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: colors.error),
              ),
            ),

          // Submit button / success badge
          if (_state == _SubmitState.success)
            _SuccessBadge()
          else
            Align(
              alignment: Alignment.centerLeft,
              child: PrimaryButton(
                label: _state == _SubmitState.error
                    ? 'Try again'
                    : 'Send message',
                loading: _state == _SubmitState.loading,
                onPressed: _submit,
              ),
            ),
        ],
      ),
    );
  }
}

// ── Reusable labeled underline field ─────────────────────────

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;

  const _Field({
    required this.label,
    required this.controller,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypogragh.mono(color: colors.onSurfaceVariant)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: colors.onSurface),
          decoration: const InputDecoration(isDense: true),
        ),
      ],
    );
  }
}

// ── Success badge ─────────────────────────────────────────────

class _SuccessBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colors.primary.withValues(alpha: 0.4)),
        color: colors.primary.withValues(alpha: 0.06),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline, size: 18, color: colors.primary),
          const SizedBox(width: 10),
          Text(
            "Message sent — we'll be in touch shortly.",
            style: AppTypogragh.mono(color: colors.primary, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
