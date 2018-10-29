package.cpath = package.cpath .. ";?.dylib"
require("gameobject")

function setup(scene, object)
end

function update(scene, object, delta)
    target = gameobject_get_integer(object, "target")
    x, y, z = gameobject_get_global_transform(target)
    xoff, yoff, zoff = gameobject_rotate_vector(target, 0, 0, -10)
    gameobject_set_transform(object, x + xoff, y + 40 + yoff, z + 40 + zoff)
end
