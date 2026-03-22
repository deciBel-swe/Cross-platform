// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_peaks_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TrackPeaksModelImpl _$$TrackPeaksModelImplFromJson(
  Map<String, dynamic> json,
) => _$TrackPeaksModelImpl(
  trackId: (json['trackId'] as num).toInt(),
  duration: (json['duration'] as num).toInt(),
  peaks:
      (json['peaks'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const <int>[],
);

Map<String, dynamic> _$$TrackPeaksModelImplToJson(
  _$TrackPeaksModelImpl instance,
) => <String, dynamic>{
  'trackId': instance.trackId,
  'duration': instance.duration,
  'peaks': instance.peaks,
};
