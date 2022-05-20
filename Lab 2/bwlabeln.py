# implementing bwlabeln matlab function from scratch in python

import cv2

def bwlabeln(grid):
    if not grid:
        return 0    

    islands = 0
    area = []
    for i in range(len(grid)):
        for j in range(len(grid[i])):
            a = []
            if grid[i][j] != 0:
                area.append(dfs(grid, i, j, a))

    return area 


def dfs(grid, i, j, a):
    if i<0 or i>=len(grid) or j<0 or j>=len(grid[0]) or grid[i][j] == 0:
        return 0
  
    a.append(grid[i][j])
    grid[i][j] = 0
    dfs(grid, i+1, j, a) #down
    dfs(grid, i-1, j, a) #up
    dfs(grid, i, j+1, a)
    dfs(grid, i, j-1, a)
    return sum(a)

grid = [
    [0,0,0,1],
    [0,1,2,0],
    [0,2,3,0],
    [0,0,0,0],
    [0,3,3,0]
    ]

print(bwlabeln(grid))



