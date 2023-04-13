import 'package:data_provider/data_provider.dart';

final sqliteDataProviderConfig = {
  'db': 'habit_gems',
  'entities': {
    'GemIcon': {
      'table': 'gem_icon',
      'fields': {
        'id': {
          'type': int,
          'column': 'id',
          'converter': const NumToStringValueConverter(),
        },
        'color': {
          'type': String,
          'column': 'color',
          'converter': const StringValueConverter(),
        },
        'title': {
          'type': String,
          'column': 'title',
          'converter': const StringValueConverter(),
        },
      },
    },
    'Gem': {
      'table': 'gem',
      'fields': {
        'id': {
          'type': int,
          'column': 'id',
          'converter': const NumToStringValueConverter(),
        },
        'iconId': {
          'type': int,
          'column': 'icon_id',
          'converter': const NumToStringValueConverter(),
        },
        'title': {
          'type': String,
          'column': 'title',
          'converter': const StringValueConverter(),
        },
        'trigger': {
          'type': String,
          'column': 'trigger',
          'converter': const StringValueConverter(),
        },
        'description': {
          'type': String,
          'column': 'description',
          'converter': const StringValueConverter(),
        },
        'goalCount': {
          'type': int,
          'column': 'goal_count',
          'converter': const NumToStringValueConverter(),
        },
        'goalPeriod': {
          'type': int,
          'column': 'goal_period',
          'converter': const NumToStringValueConverter(),
        },
        'order': {
          'type': int,
          'column': 'sort_order',
          'converter': const NumToStringValueConverter(),
        },
        'isActive': {
          'type': bool,
          'column': 'is_active',
          'converter': const BoolToStringValueConverter(),
        },
      },
    },
    'OwnedGem': {
      'table': 'owned_gem',
      'fields': {
        'id': {
          'type': int,
          'column': 'id',
          'converter': const NumToStringValueConverter(),
        },
        'gemId': {
          'type': int,
          'column': 'gem_id',
          'converter': const NumToStringValueConverter(),
        },
        'date': {
          'type': DateTime,
          'column': 'date',
          'converter': const DateTimeToStringValueConverter(),
        },
        'day': {
          'type': DateTime,
          'column': 'day',
          'converter': const DateTimeToStringValueConverter(),
        },
      },
    },
    'Setting': {
      'table': 'setting',
      'fields': {
        'id': {
          'type': int,
          'column': 'id',
          'converter': const NumToStringValueConverter(),
        },
        'name': {
          'type': String,
          'column': 'name',
          'converter': const StringValueConverter(),
        },
        'value': {
          'type': String,
          'column': 'value',
          'converter': const StringValueConverter(),
        },
      },
    },
  },
};