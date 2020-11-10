breed [cooks a-cook]
breed [servers a-server]
breed [customers a-customer]
globals [current_capacity]
turtles-own [infected]
customers-own [order-wait-time sitting-time leaving]
extensions [gis]

;TODO - once patches are in, change the random movements to the coordinates of the door or
;counter and make them take a certain amount of ticks.

to setup
  clear-all
  reset-ticks
  set current_capacity 0
  ;load
  init
  create_patches
end

to create_patches
  ask patches [
    set pcolor white
    if (pxcor >= -16 and pxcor <= -4 and pycor >= -16 and pycor <= -4) [
      set pcolor brown
    ]
    if (pxcor >= 4 and pxcor <= 16 and pycor >= -16 and pycor <= 4) [
      set pcolor brown
    ]
    if (pxcor >= 4 and pxcor <= 16 and pycor >= 6 and pycor <= 16) [
      set pcolor green
    ]
    if (pxcor >= -14 and pxcor <= -10 and pycor >= 8 and pycor <= 13) [
      set pcolor blue
    ]
  ]
end

to go
  ;on repeat
  ;Starting setup - 2 people sitting uninfected, 1 person walks in who is infected
  ;No employees infected for now
  spawn-customers
  order
  exit
  sit
  ;infect
  tick
end

to load
  ca
  let view gis:load-dataset "/Users/shahfamily/Documents/PANERA_TESTPLAN - Floor Plan -test3_text.shp"
  gis:set-world-envelope-ds gis:envelope-of view
  foreach gis:feature-list-of view [vector ->
    gis:set-drawing-color white
    gis:draw vector 1.0
  ]
end

to init
  ;Create 2 customers uninfected and sitting with sitting time 0
  create-customers 2 [
    set color green
    set sitting-time 0
    set order-wait-time 5
    set infected false
    set leaving false
  ]
  foreach sort customers [the-customer ->
    ask the-customer [
      setxy (-14 + random 5) (8 + random 6)
      set heading 90
    ]
  ]
  create-servers 2 [
    set color yellow
    set infected false
    set heading 270
    setxy 4 (6 + random 11)
  ]
end

to spawn-customers
  ;TODO - probability that a customer will walk through the door
  ;At the start - the probability will be 100% since 1 person will enter
  ;Assume that every customer who enters will immeditaely go to order
  let num random 10
  let infect_p (random 11 <= infect_prob / 10 and infect_prob != 0)
  if (num = 9 and current_capacity != max_capacity) [
    set current_capacity (current_capacity + 1)
    create-customers 1 [
      setxy 0 -16 ;Change to location of door
      set sitting-time -1
      set heading 0
      set order-wait-time -1
      set infected infect_p
      set leaving false
      ifelse (infected) [
        set color red
      ]
      [
        set color green
      ]
   ]
  ]
end


to exit
  ;TODO - customer who is currently sitting down may leave with probability
  ;Assume it takes 1 tick for someone to leave
  ;Make this probablity dependent on the time that the person has been sitting for
  foreach sort customers [the-customer ->
    if ([sitting-time] of the-customer != -1) [
      ask the-customer [set sitting-time sitting-time + 1]
    ]
    if (([sitting-time] of the-customer) >= 5 and random 10 >= 5) [
      ask the-customer [set leaving true]
    ]
    if ([leaving] of the-customer) [
      ifelse ([xcor] of the-customer >= 0) [
        ask the-customer [
          set heading 180
          set ycor ycor - 2
        ]
      ]
      [
        ask the-customer [
          set xcor xcor + 2
        ]
      ]
      if ([ycor] of the-customer < -14) [
        ask the-customer [die]
        set current_capacity (current_capacity - 1)
      ]
    ]
  ]
end

to order
  ;TODO - customer orders, waits 5 ticks, then goes to seat
  foreach sort customers [the-customer ->
    if ([order-wait-time] of the-customer >= 0 and [order-wait-time] of the-customer < 5) [
      ask the-customer [
        set order-wait-time (1 + [order-wait-time] of the-customer)
        set heading 90
      ]
    ]
    if ([order-wait-time] of the-customer = -1) [
      ask the-customer [setxy 3 ycor + 2]
      if ([ycor] of the-customer = 12) [
        ask the-customer [set order-wait-time 0]
      ]
    ]
  ]
end

to sit
  foreach sort customers [the-customer ->
    if ([order-wait-time] of the-customer = 5 and [sitting-time] of the-customer = -1) [
      ask the-customer [
        set heading 270
        ifelse ([xcor] of the-customer > -8) [
          set xcor xcor - 2
        ]
        [
          set xcor -14 + random 5
          set ycor 8 + random 6
          set sitting-time 0
          ifelse random 2 = 1 [
            set heading 270
          ]
          [
            set heading 90
          ]
        ]
      ]
    ]
  ]
end

to infect
  ; for now, just everything in a semicircle in the direction that the turtle is facing
  ; call breath infect or sneeze infect based on probability
  ;TODO
  foreach sort turtles [the-turtle ->
    foreach sort turtles [other-turtle ->
      if ([infected] of the-turtle and [who] of the-turtle != [who] of other-turtle) [
        let dist sqrt (([xcor] of the-turtle - [xcor] of other-turtle)^ 2 + ([ycor] of the-turtle - [ycor] of other-turtle)^ 2)
        let angle tan(([ycor] of the-turtle - [ycor] of other-turtle) / ([xcor] of the-turtle - [xcor] of other-turtle))
        if (abs(angle - [heading] of the-turtle) <= 30) [
          ask other-turtle [
            set infected True
            set color red
          ]
        ]
      ]
    ]
  ]

end
