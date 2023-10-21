local snake = {{},}
local grade = {}
local food = {}
local audio = {}
local menu = "main"
local d = "right"
local tempo = 0
local score = {0,true}

local function gradeDraw(w,h)
  local gw = w/22
  local gh = h/22
  local ii = 1
  local y = gh
  for i=1,20 do
    grade[ii]={}
    local jj = 1
    local x = gw
    for j=1,20 do
      grade[ii][jj]={}
      grade[ii][jj].x = x
      grade[ii][jj].y = y
      grade[ii][jj].cx = x+gw/2
      grade[ii][jj].cy = y+gh/2
      grade[ii][jj].l = gw
      jj = jj+1
      x = x+gw
    end
    ii = ii+1
    y = y+gh
  end
end
local function snakeDraw()
  if #snake == 1 then
    snake[1].x = grade[10][5].cx
    snake[1].y = grade[10][10].cy
    snake[1].r = 19
    snake[2] = {}
    table.insert(snake[2],{x=grade[10][4].cx,y=grade[10][10].cy})
    table.insert(snake[2],{x=grade[10][3].cx,y=grade[10][10].cy})
  else
    for i=1,#grade do
      for j=1,#grade[i] do
        if snake[2][#snake[2]-1].x == grade[i][j].cx and snake[2][#snake[2]-1].y == grade[i][j].cy then
          if snake[2][#snake[2]-2].x == grade[i][j-1].cx and snake[2][#snake[2]-2].y == grade[i][j].cy then
            snake[2][#snake[2]].x = grade[i][j+1].cx
            snake[2][#snake[2]].y = grade[i][j].cy
            return
          elseif snake[2][#snake[2]-2].x == grade[i][j+1].cx and snake[2][#snake[2]-2].y == grade[i][j].cy then
            snake[2][#snake[2]].x = grade[i][j-1].cx
            snake[2][#snake[2]].y = grade[i][j].cy
            return
          elseif snake[2][#snake[2]-2].x == grade[i][j].cx and snake[2][#snake[2]-2].y == grade[i-1][j].cy then
            snake[2][#snake[2]].x = grade[i][j].cx
            snake[2][#snake[2]].y = grade[i+1][j].cy
            return
          elseif snake[2][#snake[2]-2].x == grade[i][j].cx and snake[2][#snake[2]-2].y == grade[i+1][j].cy then
            snake[2][#snake[2]].x = grade[i][j].cx
            snake[2][#snake[2]].y = grade[i-1][j].cy
            return
          end
          return
        end
      end
    end
  end
end
local function foodDraw()
  math.randomseed(os.time())
  local i = math.random(1,#grade)
  local j = math.random(1,#grade[i])
  food.x = grade[i][j].cx
  food.y = grade[i][j].cy
  food.r = 15
end
local function audioLoad()
  audio.start = love.audio.newSource('sounds/gstart.wav','static')
  audio.menu = love.audio.newSource('sounds/menusnd.wav','static')
  audio.point = love.audio.newSource('sounds/getpoint.wav','static')
  audio.getbigger = love.audio.newSource('sounds/getbigger.wav','static')
  audio.gameover = love.audio.newSource('sounds/gameover.wav','static')
end
local function pointRecord(pt)
  if diff == 1 then
    local file_read = io.open('record/RECORD_easy.txt','r')
    local rcd = file_read:read()
    if not rcd then
      local new_record = io.open('record/RECORD_easy.txt','w')
      new_record:write(pt)
      score[2] = true
      io.close(new_record)
    elseif pt <= tonumber(rcd) then
      score[2] = false
    else
      local file_write = io.open('record/RECORD_easy.txt','w+')
      file_write:write(pt)
      score[2] = true
      io.close(file_write)
    end
    io.close(file_read)
    return
  elseif diff == 2 then
    local file_read = io.open('record/RECORD_normal.txt','r')
    local rcd = file_read:read()
    if not rcd then
      local new_record = io.open('record/RECORD_normal.txt','w')
      new_record:write(pt)
      score[2] = true
      io.close(new_record)
    elseif pt <= tonumber(rcd) then
      score[2] = false
    else
      local file_write = io.open('record/RECORD_normal.txt','w+')
      file_write:write(pt)
      score[2] = true
      io.close(file_write)
    end
    io.close(file_read)
    return
  elseif diff == 3 then
    local file_read = io.open('record/RECORD_hard.txt','r')
    local rcd = file_read:read()
    if not rcd then
      local new_record = io.open('record/RECORD_hard.txt','w')
      new_record:write(pt)
      score[2] = true
      io.close(new_record)
    elseif pt <= tonumber(rcd) then
      score[2] = false
    else
      local file_write = io.open('record/RECORD_hard.txt','w+')
      file_write:write(pt)
      score[2] = true
      io.close(file_write)
    end
    io.close(file_read)
    return
  end
end
local function menuDraw()
  local w, h = love.graphics.getDimensions()
  if menu == "main" then
    
    love.graphics.setColor(0.18,0.75,0.25)
    title:set(string.format("SNAKE"))
    local tw,th = title:getDimensions()
    love.graphics.draw(title,w/2-tw/2,h/3-th)
    
    love.graphics.setColor(1,1,1)
    name:set(string.format("by Tomaz Felner"))
    local nw,nh = name:getDimensions()
    love.graphics.draw(name,10,h-nh)
    
    play:set(string.format("PLAY"))
    local pw,ph = play:getDimensions()
    love.graphics.draw(play,w/2-pw/2,h/1.5-ph)
    
    exit:set(string.format("EXIT"))
    local ew,eh = exit:getDimensions()
    love.graphics.draw(exit,w/2-ew/2,h-2*eh)
    
  elseif menu == "diffselec" then
    love.graphics.setColor(0.18,0.75,0.25)
    title:set(string.format("SNAKE"))
    local tw,th = title:getDimensions()
    love.graphics.draw(title,w/2-tw/2,h/3-th)
    
    love.graphics.setColor(1,1,1)
    name:set(string.format("by Tomaz Felner"))
    local nw,nh = name:getDimensions()
    love.graphics.draw(name,10,h-nh)
    
    if diff == 1 then
      play:set(string.format("EASY"))
      local pw,ph = play:getDimensions()
      love.graphics.draw(play,w/2-pw/2,h/1.5-ph)
      
      diffalt:set(string.format("<"))
      local diffw,diffh = diffalt:getDimensions()
      love.graphics.draw(diffalt,(w/2-pw)+diffw,h/1.43-ph)
    
      diffalt2:set(string.format(">"))
      local diff2w,diff2h = diffalt2:getDimensions()
      love.graphics.draw(diffalt2,(w/2+pw)-3*diff2w,h/1.43-ph)
      
      elseif diff == 2 then
      play:set(string.format("NORMAL"))
      local pw,ph = play:getDimensions()
      love.graphics.draw(play,w/2-pw/2,h/1.5-ph)
      
      diffalt:set(string.format("<"))
      local diffw,diffh = diffalt:getDimensions()
      love.graphics.draw(diffalt,(w/2-pw)+diffw,h/1.43-ph)
    
      diffalt2:set(string.format(">"))
      local diff2w,diff2h = diffalt2:getDimensions()
      love.graphics.draw(diffalt2,(w/2+pw)-3*diff2w,h/1.43-ph)
      
    elseif diff == 3 then
      play:set(string.format("HARD"))
      local pw,ph = play:getDimensions()
      love.graphics.draw(play,w/2-pw/2,h/1.5-ph)
      
      diffalt:set(string.format("<"))
      local diffw,diffh = diffalt:getDimensions()
      love.graphics.draw(diffalt,(w/2-pw)+diffw,h/1.43-ph)
    
      diffalt2:set(string.format(">"))
      local diff2w,diff2h = diffalt2:getDimensions()
      love.graphics.draw(diffalt2,(w/2+pw)-3*diff2w,h/1.43-ph)
      
    end
    
    
    exit:set(string.format("EXIT"))
    local ew,eh = exit:getDimensions()
    love.graphics.draw(exit,w/2-ew/2,h-2*eh)
    
  elseif menu == "game" then
    
    love.graphics.setColor(1,1,1)
    gscore:set(string.format("SCORE: %.f",score[1]))
    local sw,sh = gscore:getDimensions()
    love.graphics.draw(gscore,w/2-sw/2,0)
    
  elseif menu == "pause" then
    
    love.graphics.setColor(1,1,1)
    title:set(string.format("PAUSE"))
    local tw,th = title:getDimensions()
    love.graphics.draw(title,w/2-tw/2,h/3-th)
    
    love.graphics.setColor(1,1,1)
    play:set(string.format("PLAY"))
    local pw,ph = play:getDimensions()
    love.graphics.draw(play,w/2-pw/2,h/1.5-ph)
    
    exit:set(string.format("EXIT"))
    local ew,eh = exit:getDimensions()
    love.graphics.draw(exit,w/2-ew/2,h-2*eh)
    
  elseif menu == "gameover" then
    
    love.graphics.setColor(1,0,0)
    title:set(string.format("GAME OVER"))
    local tw,th = title:getDimensions()
    love.graphics.draw(title,w/2-tw/2,h/3-th)
    
    if score[2] == true then
      love.graphics.setColor(0,1,0)
      fscore:set(string.format("NEW RECORD: %.f",score[1]))
      local sw,sh = fscore:getDimensions()
      love.graphics.draw(fscore,w/2-sw/2,h/2.5-sh)
    elseif score[2] == false then
      love.graphics.setColor(1,1,0)
      fscore:set(string.format("SCORE: %.f",score[1]))
      local sw,sh = fscore:getDimensions()
      love.graphics.draw(fscore,w/2-sw/2,h/2.5-sh)
    end
    
    love.graphics.setColor(1,1,1)
    play:set(string.format("RETURN TO MENU"))
    local pw,ph = play:getDimensions()
    love.graphics.draw(play,w/2-pw/2,h/1.5-ph)
    
    exit:set(string.format("EXIT"))
    local ew,eh = exit:getDimensions()
    love.graphics.draw(exit,w/2-ew/2,h-2*eh)
  end
end

function love.load()
  love.window.setTitle("SNAKE")
  love.window.setMode(800,800)
  
  local titlefont = love.graphics.newFont("snakechain.ttf",100)
  local playfont = love.graphics.newFont("bitcell.ttf",100)
  local configfont = love.graphics.newFont("bitcell.ttf",50)
  local exitfont = love.graphics.newFont("bitcell.ttf",50)
  local diffalternate = love.graphics.newFont("bitcell.ttf",50)
  local scorefont = love.graphics.newFont("snakechain.ttf",40)
  local gamescorefont = love.graphics.newFont("bitcell.ttf",40)
  local namefont = love.graphics.newFont("bitcell.ttf",32)
  
  
  title = love.graphics.newText(titlefont,"")
  play = love.graphics.newText(playfont,"")
  config = love.graphics.newText(configfont,"")
  exit = love.graphics.newText(exitfont,"")
  name = love.graphics.newText(namefont,"")
  fscore = love.graphics.newText(scorefont,"")
  gscore = love.graphics.newText(gamescorefont,"")
  diffalt = love.graphics.newText(diffalternate,"")
  diffalt2 = love.graphics.newText(diffalternate,"")
  
  local w,h = love.graphics.getDimensions()
  audioLoad()
  gradeDraw(w,h)
  snakeDraw()
  foodDraw()
  
  audio.start:stop() audio.start:play()
end
function love.mousepressed(x,y,key)
  local w, h = love.graphics.getDimensions() -- x,y
  local pw, ph = play:getDimensions()
  local plw, plh = w/2-pw/2, h/1.5-ph 
  local ew, eh = exit:getDimensions()
  local elw, elh = w/2-ew/2, h-2*eh
  if menu == "gameover" then
    if x <= (pw+plw) and y <= (ph+plh) then
      if plw <= x and plh <= y then
        menu = "main"
        snake = {{},}
        food = {}
        d = "right"
        snakeDraw()
        foodDraw()
        score[1] = 0
        audio.menu:stop() audio.menu:play()
        return
      end
    end
    if x <= (ew+elw) and y <= (eh+elh) then
      if elw <= x and elh <= y then
        love.quit()
        return
      end
    end
  end
  if menu == "main" then
    if x <= (pw+plw) and y <= (ph+plh) then
      if plw <= x and plh <= y then
        menu = "diffselec"
        diff = 1
        audio.menu:stop() audio.menu:play()
        return
      end
    end
    if x <= (ew+elw) and y <= (eh+elh) then
      if elw <= x and elh <= y then
        love.quit()
        return
      end
    end
  end
  if menu == "diffselec" then
    local diffcw,diffch = diffalt:getDimensions()
    local difflw,difflh = (w/2-pw)+diffcw,h/1.43-ph
    local diff2cw,diff2ch = diffalt2:getDimensions()
    local diff2lw,diff2lh = (w/2+pw)-3*diff2cw,h/1.43-ph
    if x <= (pw+plw) and y <= (ph+plh) then
      if plw <= x and plh <= y then
        menu = "game"
        audio.menu:stop() audio.menu:play()
        return
      end
    end
    if x <= (diffcw+difflw) and y <= (diffch+difflh) then
      if difflw <= x and difflh <= y then
        if diff == 1 then
          diff = 3
        elseif diff == 2 then
          diff = 1
        elseif diff == 3 then
          diff = 2
        end
        audio.menu:stop() audio.menu:play()
      end
    end
    if x <= (diff2cw+diff2lw) and y <= (diff2ch+diff2lh) then
      if diff2lw <= x and diff2lh <= y then
        if diff == 1 then
          diff = 2
        elseif diff == 2 then
          diff = 3
        elseif diff == 3 then
          diff = 1
        end
        audio.menu:stop() audio.menu:play()
      end
    end
    if x <= (ew+elw) and y <= (eh+elh) then
      if elw <= x and elh <= y then
        love.quit()
        return
      end
    end
  end
  if menu == "pause" then
    if x <= (pw+plw) and y <= (ph+plh) then
      if plw <= x and plh <= y then
        menu = "game"
        audio.menu:stop() audio.menu:play()
        return
      end
    end
    if x <= (ew+elw) and y <= (eh+elh) then
      if elw <= x and elh <= y then
        love.quit()
        return
      end
    end
  end
end
function love.keypressed(bt)
  if bt == "escape" and menu == "pause" then
    menu = "game"
  elseif bt == "escape" and menu == "game" then
    menu = "pause"
    return
  end
  if menu == "game" then
    if direction == true then
      if bt == "left" then
        if d == "right" then return
        else d = "left" end
      elseif bt == "right" then
        if d == "left" then return
        else d = "right" end
      elseif bt == "down" then
        if d == "up" then return
        else d = "down" end
      elseif bt == "up" then
        if d == "down" then return
        else d = "up" end
      end
      direction=false
    end
  end
end
function love.draw()
  if menu == "game" then
    love.graphics.setColor(0.2,0.2,0.2)
    for i=1,#grade do
      for j=1,#grade[i] do
        love.graphics.rectangle('line',grade[i][j].x,grade[i][j].y,grade[i][j].l,grade[i][j].l)
      end
    end
    love.graphics.setColor(1,1,1)
    love.graphics.setColor(1,0,0)
    love.graphics.circle('fill',food.x,food.y,food.r)
    love.graphics.setColor(0.18,0.75,0.25)
      love.graphics.circle('fill',snake[1].x,snake[1].y,snake[1].r)
    for i=1,#snake[2] do
      love.graphics.setColor(0.15,1,0.20)
      love.graphics.circle('fill',snake[2][i].x,snake[2][i].y,snake[1].r)
    end
  end
  menuDraw()
end
function love.update(dt)
  if menu == "game" then
    tempo = tempo + dt
    if diff == 1 then
      if tempo >= 0.6 then
        tempo = 0
        direction=true
        
        snake[2][#snake[2]].x = snake[1].x
        snake[2][#snake[2]].y = snake[1].y
        table.insert(snake[2],1,{x=snake[2][#snake[2]].x,y=snake[2][#snake[2]].y})
        table.remove(snake[2],#snake[2])
        
        for i=1,#grade do
          for j=1,#grade[i] do
            if snake[1].x == grade[i][j].cx and snake[1].y == grade[i][j].cy then
              if d == "left" then
                if j == 1 then
                  snake[1].x = grade[i][#grade[i]].cx
                  return
                else
                  snake[1].x = grade[i][j-1].cx
                  return
                end
              elseif d == "right" then
                if j == 20 then
                  snake[1].x = grade[i][1].cx
                  return
                else
                  snake[1].x = grade[i][j+1].cx
                  return
                end
              elseif d == "up" then
                if i == 1 then
                  snake[1].y = grade[#grade][j].cy
                  return
                else
                  snake[1].y = grade[i-1][j].cy
                  return
                end
              elseif d == "down" then
                if i == 20 then
                  snake[1].y = grade[1][j].cy
                  return
                else
                  snake[1].y = grade[i+1][j].cy
                  return
                end
              end
            end
          end
        end
      end
    elseif diff == 2 then
      if tempo >= 0.4 then
        tempo = 0
        direction=true
        
        snake[2][#snake[2]].x = snake[1].x
        snake[2][#snake[2]].y = snake[1].y
        table.insert(snake[2],1,{x=snake[2][#snake[2]].x,y=snake[2][#snake[2]].y})
        table.remove(snake[2],#snake[2])
        
        for i=1,#grade do
          for j=1,#grade[i] do
            if snake[1].x == grade[i][j].cx and snake[1].y == grade[i][j].cy then
              if d == "left" then
                if j == 1 then
                  snake[1].x = grade[i][#grade[i]].cx
                  return
                else
                  snake[1].x = grade[i][j-1].cx
                  return
                end
              elseif d == "right" then
                if j == 20 then
                  snake[1].x = grade[i][1].cx
                  return
                else
                  snake[1].x = grade[i][j+1].cx
                  return
                end
              elseif d == "up" then
                if i == 1 then
                  snake[1].y = grade[#grade][j].cy
                  return
                else
                  snake[1].y = grade[i-1][j].cy
                  return
                end
              elseif d == "down" then
                if i == 20 then
                  snake[1].y = grade[1][j].cy
                  return
                else
                  snake[1].y = grade[i+1][j].cy
                  return
                end
              end
            end
          end
        end
      end
    elseif diff == 3 then
      if tempo >= 0.2 then
        tempo = 0
        direction=true
        
        snake[2][#snake[2]].x = snake[1].x
        snake[2][#snake[2]].y = snake[1].y
        table.insert(snake[2],1,{x=snake[2][#snake[2]].x,y=snake[2][#snake[2]].y})
        table.remove(snake[2],#snake[2])
        
        for i=1,#grade do
          for j=1,#grade[i] do
            if snake[1].x == grade[i][j].cx and snake[1].y == grade[i][j].cy then
              if d == "left" then
                if j == 1 then
                  snake[1].x = grade[i][#grade[i]].cx
                  return
                else
                  snake[1].x = grade[i][j-1].cx
                  return
                end
              elseif d == "right" then
                if j == 20 then
                  snake[1].x = grade[i][1].cx
                  return
                else
                  snake[1].x = grade[i][j+1].cx
                  return
                end
              elseif d == "up" then
                if i == 1 then
                  snake[1].y = grade[#grade][j].cy
                  return
                else
                  snake[1].y = grade[i-1][j].cy
                  return
                end
              elseif d == "down" then
                if i == 20 then
                  snake[1].y = grade[1][j].cy
                  return
                else
                  snake[1].y = grade[i+1][j].cy
                  return
                end
              end
            end
          end
        end
      end

    end
    if math.sqrt((food.x-snake[1].x)^2+(food.y-snake[1].y)^2)<snake[1].r then
      table.remove(food,x,y)
      audio.point:stop() audio.point:play()
      foodDraw()
      score[1] = score[1] + 100
      if diff == 3 then
        snake[2][#snake[2]+1] = {}
        snakeDraw()
        snake[2][#snake[2]+1] = {}
        snakeDraw()
      else 
        snake[2][#snake[2]+1] = {}
        snakeDraw()
      end
      audio.getbigger:stop() audio.getbigger:play()
    end
    for i=1,#snake[2] do
      if math.sqrt((snake[2][i].x-snake[1].x)^2+(snake[2][i].y-snake[1].y)^2)<snake[1].r then
        menu = "gameover"
        pointRecord(score[1])
        audio.gameover:stop() audio.gameover:play()
      end
    end
  end
end
function love.quit()
  os.exit()
end