pico-8 cartridge // http://www.pico-8.com
version 5
__lua__
​​
function _init()
  cls()
  tick = 0 -- counter used for all things
  height = 20 -- total height of columns
  columns = {} -- used to store all columns (the conveyor belt)
  left_edge = 1 -- keeps track of what columns to draw
  right_edge = 128 -- keeps track of what columns to draw
  randomizer = 1 -- gradually increases random placement of top/bottom
  level_up_entropy = 2 -- gradually increase how quickly the map gets more random
  level_up_at = 40 -- initial "next level" threshold - when 'tick' is 40, randomness increases
  top = 2 -- initial position of ceiling
  bottom = (height - 3) -- initial position of floor
  min_level = 10 -- how crazy should it get (smaller is more crazy)
  generate_columns(128) -- start the game with a screen of columns
end
​
function _update()
end
​
function _draw()
  cls()
  tock()
  shift_walls(1)
  for x=left_edge,right_edge do
    for y=1,128 do
      pset(x,y,columns[x][y])
    end
  end
​
  print(#columns, tick, height + 8, 8)
  print("top/bottom:", tick, height + 16, 7)
  print(top, tick + 46, height + 16, 9)
  print(",", tick + 46 + 6, height + 16, 9)
  print(bottom, tick + 46 + 9, height + 16, 9)
  print("level:", tick, height + 22, 7)
  print(level_up_at, tick + 26, height + 22, 9)
  camera(tick,0)
end
​
function tock()
  tick += 1
​
  if tick % level_up_at == 0 then
    level_up_at -= level_up_entropy
​
    if level_up_at <= min_level - 1 then
      level_up_at = min_level
    else
      randomizer += 0.25
    end
​
    top = flr(rnd(2 * randomizer) + 1)
    bottom = flr(rnd(2 * randomizer) + (height - 3))
  end
end
​
function generate_column()
  local col = {}
  for i=1,height do col[i] = 0 end
​
  col[top] = rnd(15)
  col[top+1] = col[top]
  col[bottom] = rnd(15)
  col[bottom-1] = col[bottom]
  return col
end
​
function generate_columns(n)
  for i=1,n do
    columns[#columns + 1] = generate_column()
  end
end
​
function shift_walls(n)
  for i=1,n do
    del(columns, 1)
    columns[#columns + 1] = generate_column()
  end
​
  left_edge += n
  right_edge += n
end
