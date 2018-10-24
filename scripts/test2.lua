require("gameobject")
require("scene")

function setup(scene, object)
    gameobject_set_number(object, "count", 0.0)
end

function update(scene, object, delta)
    count = gameobject_get_number(object, "count") + delta
    gameobject_set_number(object, "count", count)
    gameobject_set_transform(object, 10 * math.cos(count), 10, 10 * math.sin(count))
end
