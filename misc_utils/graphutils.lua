--[[
Graph format:
graph = {
  { -- Each of these is a vertex
    position={x, y},
    neighbors={
      connectionVertexIndex=connectionWeight -- Each of these in a vertex describes the vertex's connections
    }
  }
}
--]]



local graphutils = {}
function graphutils.euclideanDistance(x1, y1, x2, y2)
  return fmath.sqrt(((x2-x1)*(x2-x1))+((y2-y1)*(y2-y1)))
end

function graphutils.basicHeuristic(Graph, node, sinkIndex)
  return graphutils.euclideanDistance(Graph[node].position[1], Graph[node].position[2], Graph[sinkIndex].position[1], Graph[sinkIndex].position[2])
end

function graphutils.aStar(Graph, sourceIndex, sinkIndex, heuristic)
  local cameFrom = {}

  local gScore = {}
  setmetatable(gScore, {__index = function () return 4294967296fx end})
  gScore[sourceIndex] = 0fx

  local fScore = {}
  setmetatable(fScore, {__index = function () return 4294967296fx end})

  local sourceFScore = heuristic(Graph, sourceIndex, sinkIndex)
  fScore[sourceIndex] = sourceFScore

  local openSet = {[sourceFScore] = {sourceIndex}}
  local lowestOpenSetFScore = sourceFScore

  while next(openSet)~=nil do
    current = openSet[lowestOpenSetFScore][1]
    if current==sinkIndex then
      local totalPath = {current}
      while cameFrom[current]~=nil do
        current = cameFrom[current]
        table.insert(totalPath, 1, current)
      end
      return totalPath
    end

    for index, vertexIndex in pairs(openSet[fScore[current]]) do
      if vertexIndex==current then
        table.remove(openSet[fScore[current]], index)
        break
      end
    end

    if #(openSet[lowestOpenSetFScore])==0 then
      openSet[lowestOpenSetFScore] = nil
      lowestOpenSetFScore = 4294967296fx
      for fScoreValue, _ in pairs(openSet) do
        if fScoreValue < lowestOpenSetFScore then
          lowestOpenSetFScore = fScoreValue
        end
      end
    end

    for neighborIndex, neighborWeight in pairs(Graph[current].neighbors) do
      local tentative_gScore = gScore[current] + neighborWeight
      if tentative_gScore < gScore[neighborIndex] then
        cameFrom[neighborIndex] = current
        gScore[neighborIndex] = tentative_gScore
        local neighborFScore = gScore[neighborIndex] + heuristic(Graph, neighborIndex, sinkIndex)
        fScore[neighborIndex] = neighborFScore
        local neighborInOpenSet = false
        for _, node in pairs(openSet) do
          if node==neighborIndex then neighborInOpenSet = true end
        end
        if not neighborInOpenSet then
          if openSet[neighborFScore]~=nil then
            openSet[neighborFScore] = {table.unpack(openSet[neighborFScore]), neighborIndex}
          else
            openSet[neighborFScore] = {neighborIndex}
          end
        end
        if neighborFScore < lowestOpenSetFScore then
          lowestOpenSetFScore = neighborFScore
        end
      end
    end
  end
  return nil
end

function graphutils.DFS(Graph)
  local s = {0}
  local discovered = {}
  while next(s)~=nil do
    local vertex = table.remove(s)
    if table.contains(discovered, vertex)~=nil then
      table.insert(discovered, vertex)
      for connectionId, _ in pairs(Graph[vertex].neighbors) do
        table.insert(s, connectionId)
      end
    end
  end
  return discovered
end

function graphutils.isConnected(Graph)
  local discovered = graphutils.DFS(Graph)
  for vertex, _ in pairs(Graph) do
    if table.contains(discovered, vertex)==nil then
      return false
    end
  end
  return true
end

function graphutils.findBridges(Graph)
  assert(graphutils.isConnected(Graph), "Unconnected graph cannot be tested for bridges")
  local processed = {}
  local bridges = {}
  for startVertexIndex, startVertex in pairs(Graph) do
    local startConnections = startVertex.neighbors
    for endVertexIndex, _ in pairs(startConnections) do
      local processedContainsCurrentEdge = false
      for _, processedEdge in pairs(processed) do
        if table.contains(processedEdge, startVertexIndex) and table.contains(processedEdge, endVertexIndex) then
          processedContainsCurrentEdge = true
          break
        end
      end
      if not processedContainsCurrentEdge then
        table.insert(processed, {startVertexIndex, endVertexIndex})
        local tempGraph = graphutils.duplicateGraph(Graph)
        graphutils.removeConnection(tempGraph)
        if not graphutils.isConnected(tempGraph) then table.insert(bridges, {startVertexIndex, endVertexIndex}) end
      end
    end
  end
  return bridges
end

return graphutils