package.cpath = package.cpath .. ";?.dylib"
require("gameobject")

function setup(scene, object)
end

function update(scene, object, delta)
    follow = gameobject_get_integer(object, "folow")
    x, y, z = gameobject_get_global_transform(follow)
    gameobject_set_transform(object, x + 20, y + 20, z + 20)
end
