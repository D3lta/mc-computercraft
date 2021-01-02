

local function dropItems()
  for i = 1, 16 do
    if turtle.getItemCount(i) > 0 then
      turtle.select(i)
      turtle.drop()
    end
  end
end
