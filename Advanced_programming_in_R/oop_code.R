Longitudinal <- setRefClass("Longitudinal",
                            fields = list(id = "character",
                                          visit = "numeric",
                                          room = "character",
                                          value = "numeric",
                                          timepoint = "numeric"),
                            methods = list(
                              make_LD = function(d){
                                id <<- d$id
                                visit <<- d$visit
                                room <<- d$room
                                value <<- d$value
                                timepoint <<- d$timepoint
                              }
                            ))