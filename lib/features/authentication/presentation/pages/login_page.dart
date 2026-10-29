import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/constants/app_responsive.dart';
import '../../../../app/constants/assets.dart';
import '../../../../app/router/app_router.dart';
import '../../../../core/utils/validators/email_validator.dart';
import '../../../../core/utils/validators/password_validator.dart';
import '../../application/dto/login_request.dart';
import '../../application/use_cases/sign_in_with_email_use_case.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({required this.signInWithEmailUseCase, super.key});

  final SignInWithEmailUseCase signInWithEmailUseCase;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await widget.signInWithEmailUseCase.execute(
        LoginRequest(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );

      if (!mounted) return;

      Navigator.of(context).pushReplacementNamed(AppRouter.homeRoute);
    } on ArgumentError catch (error) {
      if (!mounted) return;
      _showMessage(error.message?.toString() ?? 'Não foi possível entrar.');
    } catch (_) {
      if (!mounted) return;
      _showMessage('Não foi possível entrar agora. Tente novamente.');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    final theme = Theme.of(context);
    final fieldPadding = EdgeInsets.symmetric(
      horizontal: context.responsive<double>(
        mobile: 18,
        tablet: 20,
        desktop: 22,
      ),
      vertical: context.responsive<double>(mobile: 18, tablet: 20, desktop: 22),
    );

    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(prefixIcon, color: theme.colorScheme.onSurfaceVariant),
      suffixIcon: suffixIcon,
      contentPadding: fieldPadding,
    ).applyDefaults(theme.inputDecorationTheme);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxWidth = context.responsive<double>(
      mobile: double.infinity,
      tablet: 460,
      desktop: 520,
    );
    final outerPadding = context.responsive<double>(
      mobile: 24,
      tablet: 32,
      desktop: 40,
    );
    final cardPadding = context.responsive<double>(
      mobile: 28,
      tablet: 32,
      desktop: 36,
    );
    final cardRadius = context.responsive<double>(
      mobile: 28,
      tablet: 32,
      desktop: 36,
    );
    final logoSize = context.responsive<double>(
      mobile: 86,
      tablet: 94,
      desktop: 104,
    );
    final actionHeight = context.responsive<double>(
      mobile: 56,
      tablet: 60,
      desktop: 62,
    );
    final sectionSpacing = context.responsive<double>(
      mobile: 20,
      tablet: 22,
      desktop: 24,
    );
    final headingSpacing = context.responsive<double>(
      mobile: 28,
      tablet: 30,
      desktop: 32,
    );

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(outerPadding),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(cardRadius),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.08),
                      blurRadius: 30,
                      offset: Offset(0, 14),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(cardPadding),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: SvgPicture.asset(
                            AppAssets.logo,
                            width: logoSize,
                            height: logoSize,
                          ),
                        ),
                        SizedBox(height: headingSpacing),
                        Text(
                          'BEM-VINDO DE VOLTA',
                          style: theme.textTheme.labelMedium?.copyWith(
                            letterSpacing: 2,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Continue sua jornada.',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Entre para continuar de onde você parou.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: headingSpacing),
                        Text(
                          'E-mail',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: EmailValidator.validate,
                          decoration: _buildInputDecoration(
                            hintText: 'seunome@email.com',
                            prefixIcon: Icons.mail_outline,
                          ),
                        ),
                        SizedBox(height: sectionSpacing),
                        Text(
                          'Senha',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _submit(),
                          validator: PasswordValidator.validate,
                          decoration: _buildInputDecoration(
                            hintText: 'Digite sua senha',
                            prefixIcon: Icons.lock_outline,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () {
                              _showMessage(
                                'Recuperação de senha indisponível nesta fase.',
                              );
                            },
                            child: const Text('Esqueci minha senha'),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: actionHeight,
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: _isSubmitting ? null : _submit,
                            child: _isSubmitting
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Entrar no Verbum'),
                          ),
                        ),
                        SizedBox(height: sectionSpacing),
                        Center(
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 4,
                            children: [
                              Text(
                                'Ainda não tem conta?',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  _showMessage(
                                    'Cadastro indisponível nesta fase mockada.',
                                  );
                                },
                                child: const Text('Criar conta grátis'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            'Ao continuar, você concorda com os Termos de Uso e a Política de Privacidade.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
