breed [cooks a-cook]
breed [servers a-server]
breed [customers a-customer]
globals [current capacity]
turtles-own [infected]
customers-own [order-wait-time sitting-time]

to setup
  clear-all
  reset-ticks
end

to go
  ;on repeat
  ;Starting setup - 2 people sitting uninfected, 1 person walks in who is infected
  ;No employees infected for now
  customer-init
  spawn-customers
  tick
end

to customer-init
  ;Create 2 customers uninfected and sitting with sitting time 0
end

to spawn-customers
  ;TODO - probability that a customer will walk through the door
  ;At the start - the probability will be 100% since 1 person will enter
  ;Assume that every customer who enters will immeditaely go to order
end

to exit
  ;TODO - customer who is currently sitting down may leave with probability
  ;Assume it takes 1 tick for someone to leave
  ;Make this probablity dependent on the time that the person has been sitting for
end

to order
  ;TODO - customer orders, waits 5 ticks, then goes to seat
end

to infect
  ; for now, just everything in a semicircle in the direction that the turtle is facing
  ; call breath infect or sneeze infect based on probability
  ;TODO
end
