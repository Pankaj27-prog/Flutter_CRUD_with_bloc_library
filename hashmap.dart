void main () {
  var map_name = {
    'key1': 'value1',
    'key2':  2,
    'key3': true,
  };

  print(map_name);
  print(map_name['key2']);


  var map2 = Map();

  map2['1'] = "value1";
  map2['2'] = 2;
  map2['3'] = 3.0;
  map2['4'] = true;

  print(map2);
  print(map2['2']);
}