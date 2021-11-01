function decompressmeshes(meshlist)
  for meshindex, mesh in ipairs(meshlist) do
    for k, v in pairs(mesh) do
      if type(v)=="number" then
        mesh[k] = meshlist[v][k]
      end
    end
  end
  return meshlist
end
return decompressmeshes