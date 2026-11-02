import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/constants/app_dimensions.dart';
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
    required EdgeInsets padding,
    Widget? suffixIcon,
  }) {
    final theme = Theme.of(context);

    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(prefixIcon, color: theme.colorScheme.onSurfaceVariant),
      suffixIcon: suffixIcon,
      contentPadding: padding,
    ).applyDefaults(theme.inputDecorationTheme);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final layout = AppDimensions.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(layout.screenPadding),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: layout.contentMaxWidth),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(layout.cardRadius),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withValues(alpha: 0.08),
                      blurRadius: 30,
                      offset: Offset(0, 14),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(layout.cardPadding),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: SvgPicture.asset(
                            AppAssets.logo,
                            width: layout.brandMarkSize,
                            height: layout.brandMarkSize,
                          ),
                        ),
                        SizedBox(height: layout.headingSpacing),
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
                        SizedBox(height: layout.headingSpacing),
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
                            padding: layout.fieldPadding,
                          ),
                        ),
                        SizedBox(height: layout.sectionSpacing),
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
                            padding: layout.fieldPadding,
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
                          height: layout.actionHeight,
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
                        SizedBox(height: layout.sectionSpacing),
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
