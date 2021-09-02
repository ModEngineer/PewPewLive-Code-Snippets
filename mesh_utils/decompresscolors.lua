function decompresscolors(meshlist)
   for meshindex = 1, #meshlist do
      local mesh = meshlist[meshindex]
      if mesh.colors~=nil then
         local colors = mesh.colors
         mesh.colors = {}
         for color, group in pairs(colors) do
            for groupitemindex = 1,  #group do
               local groupitem = group[groupitemindex]
               if type(groupitem)=="table" then
                  for i = groupitem[1], groupitem[2] do
                     mesh.colors[i+1] = color
                  end
               elseif type(groupitem)=="number" then
                  mesh.colors[groupitem+1] = color
               end
            end
         end
         meshlist[meshindex] = mesh
      end
   end
   return meshlist
end
return decompresscolors