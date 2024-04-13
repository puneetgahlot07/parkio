import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:parkio/util/color.dart';
import 'package:pinput/pinput.dart';

class ParkioTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatter;
  final TextInputType? keyboardType;
  final List<String>? autofillHints;
  final Color inactiveTextColor;
  final Color inactiveIconColor;
  final bool obscure;

  const ParkioTextField({
    super.key,
    required this.controller,
    this.hint = '',
    this.validator,
    this.inputFormatter,
    this.keyboardType,
    this.autofillHints,
    this.inactiveTextColor = Colors.white,
    this.inactiveIconColor = Colors.white,
    this.obscure = false,
  });

  @override
  State<ParkioTextField> createState() => _ParkioTextFieldState();
}

class _ParkioTextFieldState extends State<ParkioTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();

    super.dispose();
  }

  void _requestFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  void _removeFocus() {
    setState(() {
      FocusScope.of(context).unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Text style used both for editable text and hint
    TextStyle textStyle = TextStyle(
      color: _focusNode.hasFocus
          ? const Color(0xFF101828)
          : widget.inactiveTextColor,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );

    // Color used both for suffix icon
    Color iconColor = _focusNode.hasFocus
        ? const Color(0xFF667085)
        : widget.inactiveIconColor;

    return TextFormField(
      focusNode: _focusNode,
      controller: widget.controller,
      inputFormatters: widget.inputFormatter,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: widget.keyboardType,
      autofillHints: widget.autofillHints,
      obscureText: widget.obscure,
      onTap: _requestFocus,
      onTapOutside: (event) => _removeFocus(),
      style: textStyle,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsetsDirectional.symmetric(
          vertical: 12.0,
          horizontal: 16.0,
        ),
        filled: true,
        fillColor: _focusNode.hasFocus ? Colors.white : const Color(0x1AFFFFFF),
        focusColor: Colors.white,
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))),
        focusedBorder: const GradientOutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          gradient: parkioGradient,
        ),
        hintText: widget.hint,
        hintStyle: textStyle,
        prefixIconConstraints: const BoxConstraints(
            minHeight: 24, maxHeight: 24, minWidth: 24, maxWidth: 48),
        suffixIcon: (widget.controller.text.isNotEmpty)
            ? IconButton(
                onPressed: widget.controller.clear,
                icon: SvgPicture.asset(
                  'assets/ic_close.svg',
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                ))
            : null,
      ),
    );
  }
}

class MailTextField extends StatefulWidget {
  final TextEditingController controller;
  final List<String> autofillHints;
  final bool showSuffixButton;
  final Color inactiveTextColor;
  final Color inactiveIconColor;

  // Autofill hint 'nickname' is used so user will be prompted to save the email alongside password
  const MailTextField({
    super.key,
    required this.controller,
    this.autofillHints = const [AutofillHints.nickname],
    this.showSuffixButton = true,
    this.inactiveTextColor = Colors.white,
    this.inactiveIconColor = Colors.white,
  });

  @override
  State<MailTextField> createState() => _MailTextFieldState();
}

class _MailTextFieldState extends State<MailTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();

    super.dispose();
  }

  void _requestFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  void _removeFocus() {
    setState(() {
      FocusScope.of(context).unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Text style used both for editable text and hint
    TextStyle textStyle = TextStyle(
      color: _focusNode.hasFocus
          ? const Color(0xFF101828)
          : widget.inactiveTextColor,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );

    // Color used both for prefix & suffix icons
    Color iconColor = _focusNode.hasFocus
        ? const Color(0xFF667085)
        : widget.inactiveIconColor;

    return Center(
      child: SizedBox(
        child: TextFormField(
          focusNode: _focusNode,
          controller: widget.controller,
          autofillHints: widget.autofillHints,
          onTap: _requestFocus,
          onTapOutside: (event) => _removeFocus(),
          style: textStyle,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsetsDirectional.only(
              top: 12.0,
              end: 16.0,
              bottom: 12.0,
            ),
            filled: true,
            fillColor:
                _focusNode.hasFocus ? Colors.white : const Color(0x1AFFFFFF),
            focusColor: Colors.white,
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            focusedBorder: const GradientOutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              gradient: parkioGradient,
            ),
            hintText: AppLocalizations.of(context)!.email,
            hintStyle: textStyle,
            prefixIcon: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 8, 0),
              child: SvgPicture.asset(
                'assets/ic_mail.svg',
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
                minHeight: 24, maxHeight: 24, minWidth: 24, maxWidth: 48),
            suffixIcon: widget.controller.text.isNotEmpty &&
                    widget.showSuffixButton
                ? IconButton(
                    onPressed: widget.controller.clear,
                    icon: SvgPicture.asset(
                      'assets/ic_close.svg',
                      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                    ))
                : null,
          ),
        ),
      ),
    );
  }
}

class PhoneTextField extends StatefulWidget {
  final TextEditingController controller;
  final List<String> autofillHints;
  final bool showSuffixButton;
  final Color inactiveTextColor;
  final Color inactiveIconColor;

  // Autofill hint 'nickname' is used so user will be prompted to save the phone number alongside password
  const PhoneTextField({
    super.key,
    required this.controller,
    this.autofillHints = const [AutofillHints.nickname],
    this.showSuffixButton = true,
    this.inactiveTextColor = Colors.white,
    this.inactiveIconColor = Colors.white,
  });

  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  late FocusNode _focusNode;
  PhoneCountryData? _countryData;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (mounted) {}
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();

    super.dispose();
  }

  void _requestFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  void _removeFocus() {
    setState(() {
      FocusScope.of(context).unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Text style used both for editable text and hint
    TextStyle textStyle = TextStyle(
        color: _focusNode.hasFocus
            ? const Color(0xFF101828)
            : widget.inactiveTextColor,
        fontSize: 16,
        fontWeight: FontWeight.w400);

    // Color used both for prefix & suffix icons
    Color iconColor = _focusNode.hasFocus
        ? const Color(0xFF667085)
        : widget.inactiveIconColor;

    return Center(
      child: SizedBox(
        child: TextFormField(
          focusNode: _focusNode,
          controller: widget.controller,
          autofillHints: widget.autofillHints,
          onTap: _requestFocus,
          onTapOutside: (event) => _removeFocus(),
          style: textStyle,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            PhoneInputFormatter(
              onCountrySelected: (PhoneCountryData? countryData) {
                setState(() {
                  _countryData = countryData;
                });
              },
              allowEndlessPhone: false,
            )
          ],
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsetsDirectional.only(
                top: 12.0, end: 16.0, bottom: 12.0),
            filled: true,
            fillColor:
                _focusNode.hasFocus ? Colors.white : const Color(0x1AFFFFFF),
            focusColor: Colors.white,
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            focusedBorder: const GradientOutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                gradient: parkioGradient),
            hintText: AppLocalizations.of(context)!.phoneNumber,
            hintStyle: textStyle,
            prefixIcon: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 8, 0),
              child: SvgPicture.asset(
                'assets/ic_phone.svg',
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
                minHeight: 24, maxHeight: 24, minWidth: 24, maxWidth: 48),
            suffixIcon: widget.controller.text.isNotEmpty &&
                    widget.showSuffixButton
                ? IconButton(
                    onPressed: widget.controller.clear,
                    icon: SvgPicture.asset(
                      'assets/ic_close.svg',
                      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                    ))
                : null,
          ),
        ),
      ),
    );
  }
}

class SearchTextField extends StatefulWidget {
  final TextEditingController controller;
  final Color inactiveTextColor;
  final Color inactiveIconColor;
  final bool isEnabled;
  final bool autofocus;
  final Function()? onTap;
  final Function()? onFieldSubmit;

  const SearchTextField({
    super.key,
    required this.controller,
    this.inactiveTextColor = const Color(0xFF667085),
    this.inactiveIconColor = const Color(0x99667085),
    this.autofocus = false,
    this.isEnabled = true,
    this.onTap,
    this.onFieldSubmit,
  });

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (mounted) {}
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();

    super.dispose();
  }

  void _requestFocus() {
    if (widget.onTap != null) widget.onTap!();
    setState(() => FocusScope.of(context).requestFocus(_focusNode));
  }

  void _removeFocus() {
    setState(() => FocusScope.of(context).unfocus());
  }

  @override
  Widget build(BuildContext context) {
    // Text style used both for editable text and hint
    TextStyle textStyle = TextStyle(
      color: _focusNode.hasFocus
          ? const Color(0xFF101828)
          : widget.inactiveTextColor,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );

    // Color used both for prefix & suffix icons
    Color iconColor = _focusNode.hasFocus
        ? const Color(0xFF667085)
        : widget.inactiveIconColor;

    return TextFormField(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      controller: widget.controller,
      // canRequestFocus: widget.isEnabled,
      onTap: _requestFocus,
      onTapOutside: (event) => _removeFocus(),
      style: textStyle,
      keyboardType: TextInputType.streetAddress,
      onFieldSubmitted: (value) => {
        if (widget.onFieldSubmit != null) widget.onFieldSubmit!(),
      },
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        isDense: true,
        contentPadding:
            const EdgeInsetsDirectional.only(top: 12, end: 16, bottom: 12),
        filled: true,
        fillColor: _focusNode.hasFocus ? Colors.white : const Color(0x1AFFFFFF),
        focusColor: Colors.white,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        focusedBorder: const GradientOutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          gradient: parkioGradient,
        ),
        hintText: AppLocalizations.of(context)!.searchForAreaCodeOrAddress,
        hintStyle: textStyle,
        prefixIcon: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 8, 0),
          child: SvgPicture.asset(
            'assets/ic_search_18.svg',
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(
            minHeight: 24, maxHeight: 24, minWidth: 24, maxWidth: 48),
        suffixIcon: widget.controller.text.isNotEmpty
            ? IconButton(
                onPressed: widget.controller.clear,
                icon: SvgPicture.asset(
                  'assets/ic_close.svg',
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                ))
            : null,
      ),
    );
  }
}

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool showSuffixButton;
  final String? hint;
  final List<String> autofillHints;
  final String? Function(String?)? validator;

  const PasswordTextField({
    super.key,
    required this.controller,
    this.showSuffixButton = true,
    this.hint,
    this.autofillHints = const [AutofillHints.password],
    this.validator,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  late FocusNode _focusNode;
  bool _passwordObscured = true;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();

    super.dispose();
  }

  void _requestFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  void _removeFocus() {
    setState(() {
      FocusScope.of(context).unfocus();
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _passwordObscured = !_passwordObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Text style used both for editable text and hint
    // Font family 'Inter' is used for obscured password because it has larger scale and bigger spacing
    TextStyle textStyle = TextStyle(
      color: _focusNode.hasFocus ? const Color(0xFF101828) : Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontFamily: _passwordObscured ? 'Inter' : 'Mabry Pro',
    );

    // Color used both for prefix & suffix icons
    Color iconColor =
        _focusNode.hasFocus ? const Color(0xFF667085) : Colors.white;

    // Show
    String visibilityIcon = _passwordObscured
        ? 'assets/ic_visibility.svg'
        : 'assets/ic_visibility_off.svg';

    return Center(
      child: SizedBox(
        child: TextFormField(
          focusNode: _focusNode,
          controller: widget.controller,
          autofillHints: widget.autofillHints,
          onTap: _requestFocus,
          onTapOutside: (event) => _removeFocus(),
          validator: widget.validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: textStyle,
          keyboardType: TextInputType.visiblePassword,
          obscureText: _passwordObscured,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsetsDirectional.only(
                top: 12.0, end: 16.0, bottom: 12.0),
            filled: true,
            fillColor:
                _focusNode.hasFocus ? Colors.white : const Color(0x1AFFFFFF),
            focusColor: Colors.white,
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            focusedBorder: const GradientOutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              gradient: parkioGradient,
            ),
            hintText: widget.hint ?? AppLocalizations.of(context)!.password,
            hintStyle: textStyle,
            prefixIcon: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 8, 0),
              child: SvgPicture.asset(
                'assets/ic_lock.svg',
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minHeight: 24,
              maxHeight: 24,
              minWidth: 24,
              maxWidth: 48,
            ),
            suffixIcon: widget.showSuffixButton
                ? IconButton(
                    onPressed: _togglePasswordVisibility,
                    icon: SvgPicture.asset(
                      visibilityIcon,
                      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

class ParkioOtpTextField extends StatefulWidget {
  final TextEditingController controller;
  const ParkioOtpTextField({super.key, required this.controller});

  @override
  State<ParkioOtpTextField> createState() => _ParkioOtpTextFieldState();
}

class _ParkioOtpTextFieldState extends State<ParkioOtpTextField>
    with SingleTickerProviderStateMixin {
  late FocusNode _focusNode;
  late AnimationController _borderLerpContoller;

  @override
  void initState() {
    super.initState();
    _borderLerpContoller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _borderLerpContoller.addStatusListener((animationStatus) {
      switch (animationStatus) {
        case AnimationStatus.completed:
          _borderLerpContoller.reverse();
          break;
        case AnimationStatus.dismissed:
          _borderLerpContoller.forward();
          break;
        case AnimationStatus.forward:
          break;
        case AnimationStatus.reverse:
          break;
      }
    });
    _borderLerpContoller.forward();

    widget.controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _borderLerpContoller.dispose();

    super.dispose();
  }

  void _requestFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  void _removeFocus() {
    setState(() {
      FocusScope.of(context).unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 69,
      height: 57,
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
      decoration: BoxDecoration(
        color: const Color(0x1AFFFFFF),
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(12),
      ),
    );
    final focusedPinTheme = PinTheme(
      width: 69,
      height: 57,
      textStyle: const TextStyle(
        color: Color(0xFF101828),
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.lerp(
          Border.all(
            color: const Color(0xFFFFD077),
            width: 2,
          ),
          Border.all(
            color: const Color(0xFFD18EE8),
            width: 2,
          ),
          _borderLerpContoller.value,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return Pinput(
      controller: widget.controller,
      onTap: _requestFocus,
      focusedPinTheme: focusedPinTheme,
      defaultPinTheme: defaultPinTheme,
      focusNode: _focusNode,
      showCursor: false,
      hapticFeedbackType: HapticFeedbackType.lightImpact,
      keyboardType: TextInputType.number,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      onTapOutside: (event) => _removeFocus(),
    );
  }
}
