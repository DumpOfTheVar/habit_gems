final sqliteDataProviderMigrations = [
  '''CREATE TABLE gem_icon(
      id INTEGER PRIMARY KEY,
      color STRING NOT NULL,
      title STRING NOT NULL);
  ''',
  '''CREATE TABLE gem(
      id INTEGER PRIMARY KEY,
      icon_id INT NOT NULL,
      title STRING NOT NULL,
      trigger STRING NOT NULL,
      description STRING NOT NULL,
      goal_count INTEGER NOT NULL,
      goal_period INTEGER NOT NULL,
      sort_order INTEGER NOT NULL,
      is_active INT NOT NULL);
  ''',
  '''CREATE TABLE owned_gem(
      id INTEGER PRIMARY KEY NOT NULL,
      gem_id INT NOT NULL,
      date STRING NOT NULL,
      day STRING NOT NULL);
  ''',
  '''INSERT INTO gem_icon(id, color, title) VALUES 
      (1, 'ff3030', 'Ruby'),
      (2, 'ffa060', 'Fire opal'),
      (3, 'ffff60', 'Yellow jasper'),
      (4, '30ff30', 'Emerald'),
      (5, '60a0ff', 'Topaz'),
      (6, 'a060ff', 'Amethyst');
  ''',
  'CREATE TABLE setting(id INT PRIMARY KEY, name STRING, value STRING);',
  '''INSERT INTO setting(id, name, value) VALUES
      (1, 'dark_theme', '1'),
      (2, 'shift_day_start', '1');
  ''',
];
