function decompresscolors(meshlist)
  for meshindex, mesh in ipairs(meshlist) do
    if mesh.colors~=nil then
      local colors = mesh.colors
      mesh.colors = {}
      for color, group in pairs(colors) do
        for groupitemindex, groupitem in ipairs(group) do
          if type(groupitem)=="table" then
            for i = groupitem[1], groupitem[2] do
              mesh.colors[i+1] = color
            end
          elseif type(groupitem)=="number" then
            mesh.colors[groupitem+1] = color
          end
        end
      end
    end
  end
  return meshlist
end
return decompresscolors