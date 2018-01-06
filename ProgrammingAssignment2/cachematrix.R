## Cache the inverse of a matrix

## Make a cached Matrix to store the inverse

makeCacheMatrix <- function(x = matrix()) {
          i <- NULL
          set <- function(y) {
                x <<- y
                i <<- NULL
          }
          get <- function() x
          setinverse <- function(inverse) i <<- inverse
          getinverse <- function() i
          list(set = set, get = get, setinverse = setinverse, getinverse = getinverse)
}


## Check if the inverse has been stored in cache
## if not, calculate the inverse and put it back to cache

cacheSolve <- function(x, ...) {
        ## Return a matrix that is the inverse of 'x'
  
          i <- x$getinverse()
          if(!is.null(i)) {
              message("getting cached data")
              return(m)
          }
          matrix <- x$get()
          i <- solve(matrix, ...)
          x$setinverse(i)
          i
}
