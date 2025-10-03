import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'voxbay_click_launcher.dart';

class VoxbayCallConfig {
  const VoxbayCallConfig({
    this.callBridgeUrl =
        'https://pbx.voxbaysolutions.com/vl/callcenterbridging',
    this.clickToCallBaseUrl =
        'https://pbx.voxbaysolutions.com/api/clicktocall.php',
    this.uid = 'azhtu2123h',
    this.pin = 'yhet238jgy',
    this.defaultCallerId = '914847173130',
    this.recordingBaseUrl = 'http://pbx.voxbaysolutions.com/callrecordings/',
    this.connectTimeout = const Duration(seconds: 15),
    this.receiveTimeout = const Duration(seconds: 20),
  });

  final String callBridgeUrl;
  final String clickToCallBaseUrl;
  final String uid;
  final String pin;
  final String defaultCallerId;
  final String recordingBaseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;

  VoxbayCallConfig copyWith({
    String? callBridgeUrl,
    String? clickToCallBaseUrl,
    String? uid,
    String? pin,
    String? defaultCallerId,
    String? recordingBaseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
  }) {
    return VoxbayCallConfig(
      callBridgeUrl: callBridgeUrl ?? this.callBridgeUrl,
      clickToCallBaseUrl: clickToCallBaseUrl ?? this.clickToCallBaseUrl,
      uid: uid ?? this.uid,
      pin: pin ?? this.pin,
      defaultCallerId: defaultCallerId ?? this.defaultCallerId,
      recordingBaseUrl: recordingBaseUrl ?? this.recordingBaseUrl,
      connectTimeout: connectTimeout ?? this.connectTimeout,
      receiveTimeout: receiveTimeout ?? this.receiveTimeout,
    );
  }
}

class CallApiResult {
  const CallApiResult({required this.success, required this.message});

  final bool success;
  final String message;
}

class VoxbayCallService {
  VoxbayCallService({Dio? dio, VoxbayCallConfig? config})
    : _config = config ?? const VoxbayCallConfig(),
      _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout:
                  (config ?? const VoxbayCallConfig()).connectTimeout,
              receiveTimeout:
                  (config ?? const VoxbayCallConfig()).receiveTimeout,
              responseType: ResponseType.plain,
              followRedirects: true,
              validateStatus: (status) => status != null && status < 500,
            ),
          ),
      _launcher = const VoxbayClickLauncher();

  final VoxbayCallConfig _config;
  final Dio _dio;
  final VoxbayClickLauncher _launcher;

  VoxbayCallConfig get config => _config;

  Future<CallApiResult> initiateClickToCall({
    required String source,
    required String destination,
    required String extension,
    String? callerId,
  }) async {
    final cleanSource = _normalizeDialString(source);
    final cleanDestination = _normalizeDialString(destination);
    final cleanExtension = _normalizeDialString(extension);
    final cleanCallerId = _normalizeDialString(
      callerId ?? _config.defaultCallerId,
    );

    final uri = _buildClickToCallUri(
      source: cleanSource,
      destination: cleanDestination,
      extension: cleanExtension,
      callerId: cleanCallerId,
    );

    _logCallAttempt(
      source: cleanSource,
      destination: cleanDestination,
      extension: cleanExtension,
      callerId: cleanCallerId,
      uri: uri,
    );

    if (_launcher.launch(uri)) {
      _logCallResult(
        payload: {
          'source': cleanSource,
          'destination': cleanDestination,
          'extension': cleanExtension,
          'callerid': cleanCallerId,
          'transport': 'image-ping',
          'url': uri.toString(),
        },
        success: true,
      );
      return const CallApiResult(success: true, message: 'Call triggered.');
    }

    try {
      final response = await _dio.getUri(uri);
      final payload = response.data?.toString().trim() ?? '';
      final normalized = payload.toLowerCase();
      final success = normalized.contains('success');
      _logCallResult(
        payload: {
          'source': cleanSource,
          'destination': cleanDestination,
          'extension': cleanExtension,
          'callerid': cleanCallerId,
          'transport': 'dio-get',
          'url': uri.toString(),
          'response': payload,
        },
        success: success,
      );
      final message =
          success
              ? 'Call triggered successfully.'
              : (payload.isEmpty ? 'Click-to-call request failed.' : payload);
      return CallApiResult(success: success, message: message);
    } catch (error) {
      _logCallError('dio-get', error, {
        'source': cleanSource,
        'destination': cleanDestination,
        'extension': cleanExtension,
        'callerid': cleanCallerId,
        'url': uri.toString(),
      });
      return CallApiResult(
        success: false,
        message: 'Click-to-call error: ${error.toString()}',
      );
    }
  }

  Future<CallApiResult> sendOutgoingCallEvent({
    required String extension,
    required String destination,
    required String callerId,
    required String callUuid,
  }) async {
    final payload = <String, dynamic>{
      'extension': extension,
      'destination': destination,
      'callerid': callerId,
      'callUUlD': callUuid,
    };
    return _postToBridge(payload, contextLabel: 'outgoing call');
  }

  Future<CallApiResult> sendCallCdr({
    required String extension,
    required String destination,
    required String callerId,
    String? durationSeconds,
    String? status,
    String? dateTime,
    String? recordingUrl,
  }) async {
    final payload = <String, dynamic>{
      'extension': extension,
      'destination': destination,
      'callerid': callerId,
      'duration': durationSeconds,
      'status': status,
      'date': dateTime,
      'recording_URL': _normalizeRecordingUrl(recordingUrl),
    }..removeWhere((key, value) => value == null || value.toString().isEmpty);

    return _postToBridge(payload, contextLabel: 'call CDR');
  }

  Uri _buildClickToCallUri({
    required String source,
    required String destination,
    required String extension,
    String? callerId,
  }) {
    final query = <String, String>{
      'uid': _config.uid,
      'pin': _config.pin,
      'source': source,
      'destination': destination,
      'ext': extension,
      'callerid': callerId ?? _config.defaultCallerId,
    };

    final base = Uri.parse(_config.clickToCallBaseUrl);
    return base.replace(queryParameters: query);
  }

  String _normalizeDialString(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return trimmed;
    final cleaned = trimmed.replaceAll(RegExp(r'[^0-9+]'), '');
    if (cleaned.startsWith('00') && !cleaned.startsWith('+')) {
      return '+${cleaned.substring(2)}';
    }
    return cleaned;
  }

  void _logCallAttempt({
    required String source,
    required String destination,
    required String extension,
    required String callerId,
    required Uri uri,
  }) {
    // ignore: avoid_print
    print(
      "[Voxbay] Initiating call -> source: $source, destination: $destination, "
      "extension: $extension, callerid: $callerId, url: ${uri.toString()}",
    );
  }

  void _logCallResult({
    required Map<String, dynamic> payload,
    required bool success,
  }) {
    // ignore: avoid_print
    final details = payload.entries
        .map((e) => '${e.key}: ${e.value}')
        .join(', ');
    print('[Voxbay] Call ${success ? 'succeeded' : 'failed'} -> $details');
  }

  void _logCallError(
    String transport,
    Object error,
    Map<String, dynamic> payload,
  ) {
    // ignore: avoid_print
    final details = payload.entries
        .map((e) => '${e.key}: ${e.value}')
        .join(', ');
    print('[Voxbay] Call error [$transport] -> $details, error: $error');
  }

  Future<CallApiResult> _postToBridge(
    Map<String, dynamic> payload, {
    required String contextLabel,
  }) async {
    final uri = Uri.parse(_config.callBridgeUrl);
    try {
      final response = await _dio.postUri(
        uri,
        data: payload,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          responseType: ResponseType.plain,
        ),
      );

      final body = response.data?.toString().trim() ?? '';
      final normalized = body.toLowerCase();
      final success = normalized.contains('success');
      _logCallResult(
        payload: {
          ...payload,
          'transport': 'dio-post',
          'bridge': uri.toString(),
          'url': uri.toString(),
          'context': contextLabel,
          'response': body,
        },
        success: success,
      );
      final message =
          success ? 'Success' : (body.isEmpty ? 'Request failed' : body);

      return CallApiResult(success: success, message: message);
    } catch (error) {
      _logCallError('dio-post', error, {
        ...payload,
        'bridge': uri.toString(),
        'url': uri.toString(),
        'context': contextLabel,
      });
      return CallApiResult(
        success: false,
        message:
            '${contextLabel[0].toUpperCase()}${contextLabel.substring(1)} error: ${error.toString()}',
      );
    }
  }

  String? _normalizeRecordingUrl(String? url) {
    if (url == null || url.trim().isEmpty) return null;
    final trimmed = url.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    return '${_config.recordingBaseUrl}${trimmed.startsWith('/') ? trimmed.substring(1) : trimmed}';
  }
}

final voxbayCallServiceProvider = Provider<VoxbayCallService>((ref) {
  return VoxbayCallService();
});
