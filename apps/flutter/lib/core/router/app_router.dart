import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dni_connect/features/home/presentation/home_screen_new.dart';
import 'package:dni_connect/features/qr_scan/presentation/qr_scan_screen.dart';
import 'package:dni_connect/features/qr_scan/presentation/qr_verify_screen.dart';
import 'package:dni_connect/features/qr_scan/presentation/qr_result_screen.dart';
import 'package:dni_connect/features/nfc_read/presentation/nfc_input_screen.dart';
import 'package:dni_connect/features/nfc_read/presentation/nfc_read_screen.dart';
import 'package:dni_connect/features/result/presentation/result_screen.dart';
import 'package:dni_connect/core/widgets/app_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          pageBuilder: (context, state) => const MaterialPage(
            child: HomeScreenNew(),
          ),
        ),
        GoRoute(
          path: '/scan',
          name: 'qr_scan',
          pageBuilder: (context, state) => const MaterialPage(
            child: QrScanScreen(),
          ),
        ),
        GoRoute(
          path: '/verify',
          name: 'qr_verify',
          pageBuilder: (context, state) {
            final qrData = state.extra as String? ?? '';
            return MaterialPage(
              child: QrVerifyScreen(qrRawData: qrData),
            );
          },
        ),
        GoRoute(
          path: '/qr-result',
          name: 'qr_result',
          pageBuilder: (context, state) {
            final qrData = state.extra as String? ?? '';
            return MaterialPage(
              child: QrResultScreen(qrData: qrData),
            );
          },
        ),
        GoRoute(
          path: '/nfc',
          name: 'nfc_input',
          pageBuilder: (context, state) => const MaterialPage(
            child: NfcInputScreen(),
          ),
        ),
        GoRoute(
          path: '/nfc/read',
          name: 'nfc_read',
          pageBuilder: (context, state) {
            final accessKey = state.extra as String? ?? '';
            return MaterialPage(
              child: NfcReadScreen(accessKey: accessKey),
            );
          },
        ),
        GoRoute(
          path: '/result',
          name: 'result',
          pageBuilder: (context, state) {
            final resultData = state.extra as String? ?? 'No data';
            return MaterialPage(
              child: ResultScreen(verificationResult: resultData),
            );
          },
        ),
      ],
    ),
  ],
);
