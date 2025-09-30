import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VoxbayCallConfig {
  const VoxbayCallConfig({
    this.callBridgeUrl = 'https://pbx.voxbaysolutions.com/vl/callcenterbridging',
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
          );

  final VoxbayCallConfig _config;
  final Dio _dio;

  VoxbayCallConfig get config => _config;

  Future<CallApiResult> initiateClickToCall({
    required String source,
    required String destination,
    required String extension,
    String? callerId,
  }) async {
    final uri = _buildClickToCallUri(
      source: source,
      destination: destination,
      extension: extension,
      callerId: callerId,
    );

    try {
      final response = await _dio.getUri(uri);
      final payload = response.data?.toString().trim() ?? '';
      final normalized = payload.toLowerCase();
      final success = normalized.contains('success');
      final message =
          success
              ? 'Call triggered successfully.'
              : (payload.isEmpty ? 'Click-to-call request failed.' : payload);
      return CallApiResult(success: success, message: message);
    } catch (error) {
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
      'uid': "azhtu2123h",
      'pin': "yhet238jgy",
      'source': "+91 73565 33368",
      'destination': 8129130745.toString(),
      'ext': "1000",
      'callerid': "914847173130",
    };

    final base = Uri.parse(_config.clickToCallBaseUrl);
    return base.replace(queryParameters: query);
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
      final message =
          success ? 'Success' : (body.isEmpty ? 'Request failed' : body);

      return CallApiResult(success: success, message: message);
    } catch (error) {
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
