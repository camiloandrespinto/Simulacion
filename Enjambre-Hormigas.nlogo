patches-own [
  chemical
  food
  nest?
  nest-scent
  food-source-number
]


to setup
  clear-all
  set-default-shape turtles "bug"
  crt poblacion
  [ set size 2
    set color red  ]
  setup-patches
  reset-ticks
end

to setup-patches
  ask patches
  [ setup-nest
    setup-food
    recolor-patch ]
end

to setup-nest
  set nest? (distancexy 0 0) < 5
  set nest-scent 200 - distancexy 0 0
end

to setup-food
  if (distancexy (0.6 * max-pxcor) 0) < 5
  [ set food-source-number 1 ]
  if (distancexy (-0.6 * max-pxcor) (-0.6 * max-pycor)) < 5
  [ set food-source-number 2 ]
  if (distancexy (-0.8 * max-pxcor) (0.8 * max-pycor)) < 5
  [ set food-source-number 3 ]
  if (distancexy (0.7 * max-pxcor) (0.8 * max-pycor)) < 5
  [ set food-source-number 4 ]
  if (distancexy (0.6 * max-pxcor) (-0.7 * max-pycor)) < 5
  [ set food-source-number 5 ]
  if food-source-number > 0
  [ set food one-of [1 2] ]
end

to recolor-patch
  ifelse nest?
  [ set pcolor violet ]
  [ ifelse food > 0
    [ if food-source-number = 1 [ set pcolor cyan  ]
      if food-source-number = 2 [ set pcolor sky   ]
      if food-source-number = 3 [ set pcolor green ]
      if food-source-number = 4 [ set pcolor blue  ]
      if food-source-number = 5 [ set pcolor yellow ]
    ]
     [ set pcolor scale-color green chemical 0.1 5 ]
   ]
end



to go  ;; forever button
  ask turtles
  [ if who >= ticks [ stop ]
    ifelse color = red
    [ look-for-food  ]
    [ return-to-nest ]
    wiggle
    fd 1 ]
  diffuse chemical (radio / 50)
  ask patches
  [ set chemical chemical * (100 - radio-evaporacion) / 100
    recolor-patch ]
  tick
end

to return-to-nest
  ifelse nest?
  [
    set color red
    rt 180 ]
  [
    set chemical chemical + 60
    uphill-nest-scent ]
end

to look-for-food
  if food > 0
  [ set color orange + 1
    set food food - 0.5
    rt 180
    stop ]
  if (chemical >= 0.001) and (chemical < 5)
  [ uphill-chemical ]
end

to uphill-chemical
  let scent-ahead chemical-scent-at-angle   0
  let scent-right chemical-scent-at-angle  45
  let scent-left  chemical-scent-at-angle -45
  if (scent-right > scent-ahead) or (scent-left > scent-ahead)
  [ ifelse scent-right > scent-left
    [ rt 45 ]
    [ lt 45 ] ]
end

to uphill-nest-scent
  let scent-ahead nest-scent-at-angle   0
  let scent-right nest-scent-at-angle  45
  let scent-left  nest-scent-at-angle -45
  if (scent-right > scent-ahead) or (scent-left > scent-ahead)
  [ ifelse scent-right > scent-left
    [ rt 45 ]
    [ lt 45 ] ]
end

to wiggle
  rt random 40
  lt random 40
  if not can-move? 1 [ rt 180 ]
end

to-report nest-scent-at-angle [angle]
  let p patch-right-and-ahead angle 1
  if p = nobody [ report 0 ]
  report [nest-scent] of p
end

to-report chemical-scent-at-angle [angle]
  let p patch-right-and-ahead angle 1
  if p = nobody [ report 0 ]
  report [chemical] of p
end
